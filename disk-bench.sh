#!/bin/bash

# A simple disk benchmark script using fio.
# It runs a series of sequential and random 4K tests.
# The script output is automatically saved to a log file.

# --- Configuration ---
RUNTIME=60      # Duration of each test in seconds. 60s is a reasonable default.
SEQ_BS="1m"     # Block size for sequential tests
RAND_BS="4k"    # Block size for random tests
TEST_GAP=5      # Seconds to wait between each test

# --- Pre-flight Checks ---
set -e # Exit immediately if a command exits with a non-zero status.

# Function to display usage information
usage() {
    echo "Usage: $0 <test_path> <test_size>"
    echo "  <test_path> : Directory on the disk/volume to be tested."
    echo "                Example: /mnt/my_volume"
    echo "  <test_size> : Size of the test file. fio accepts suffixes like 'm' for MB, 'g' for GB."
    echo "                Example: 1g, 2048m"
    exit 1
}

# Check for dependencies
command -v fio >/dev/null 2>&1 || { echo >&2 "fio is not installed. Please install it (e.g., 'sudo apt-get install fio' or 'sudo yum install fio')."; exit 1; }
command -v jq >/dev/null 2>&1 || { echo >&2 "jq is not installed. Please install it (e.g., 'sudo apt-get install jq' or 'sudo yum install jq')."; exit 1; }

# Validate input arguments
if [ "$#" -ne 2 ]; then
    usage
fi

TEST_PATH=$1
TEST_SIZE=$2

# Check if the test path is a valid, writable directory
if [ ! -d "$TEST_PATH" ] || [ ! -w "$TEST_PATH" ]; then
    echo "Error: Test path '$TEST_PATH' is not a valid or writable directory."
    exit 1
fi

# --- Log File Setup ---
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
# Sanitize the test path for use in a filename (replace slashes with underscores)
SANITIZED_PATH=$(echo "$TEST_PATH" | sed 's/^\///' | sed 's/\//_/g')
LOG_FILE="fio-benchmark_${SANITIZED_PATH}_${TEST_SIZE}_${TIMESTAMP}.log"

echo "Benchmark starting. Results will be saved to: $LOG_FILE"
echo # Add a newline for readability

# --- Automatic Output Logging ---
# This line redirects all subsequent stdout and stderr to the tee command.
# tee will then write to the specified log file AND to the original stdout (the screen).
exec > >(tee "$LOG_FILE") 2>&1

# --- Test Setup ---
FILENAME="fio_benchmark_$(date +%s).tmp"
TEST_FILE="$TEST_PATH/$FILENAME"

# This function contains the cleanup tasks.
cleanup() {
    echo ""
    echo "Cleaning up test file: $TEST_FILE"
    # The 'rm -f' command will not error if the file doesn't exist.
    rm -f "$TEST_FILE"
    echo "Cleanup complete."
}

# Trap the EXIT signal to ensure the 'cleanup' function runs, even if the script
# is interrupted by CTRL+C, an error, or when it finishes normally.
trap cleanup EXIT

echo "--- FIO Disk Benchmark ---"
echo "Test Location: $TEST_PATH"
echo "Test File Size:  $TEST_SIZE"
echo "Test Duration:   ${RUNTIME}s per test"
echo "Pause Between:   ${TEST_GAP}s"
echo "--------------------------"
echo ""

# 1. Prepare the test file
echo "Step 1: Preparing test file ($TEST_SIZE)..."
fio --create_only=1 \
    --name=prepare \
    --filename="$TEST_FILE" \
    --size="$TEST_SIZE" \
    --output-format=json > /dev/null

echo "Preparation complete."
echo ""
echo "Step 2: Running benchmark tests..."
echo ""

# --- Helper Functions ---

# Pauses for a set duration between tests to allow the system to settle
pause_between_tests() {
    #echo "Pausing for ${TEST_GAP} seconds before the next test..."
    sleep "$TEST_GAP"
}

# A function to run a specific fio test and print formatted results
run_fio_test() {
    local test_name=$1
    local rw_mode=$2
    local block_size=$3
    local io_depth=$4
    local common_params="--output-format=json --ioengine=libaio --direct=1 --randrepeat=0 --refill_buffers --end_fsync=1"
    local json_output
    json_output=$(fio $common_params --filename="$TEST_FILE" --name="$test_name" --size="$TEST_SIZE" --bs="$block_size" --runtime="$RUNTIME" --rw="$rw_mode" --iodepth="$io_depth" --numjobs=1)
    local op_type
    case "$rw_mode" in read|randread) op_type="read" ;; write|randwrite) op_type="write" ;; *) echo "Error: unsupported rw_mode $rw_mode"; exit 1 ;; esac
    local iops bw_kib lat_us
    iops=$(echo "$json_output" | jq -r ".jobs[0].${op_type}.iops // 0 | tonumber | round")
    bw_kib=$(echo "$json_output" | jq -r ".jobs[0].${op_type}.bw // 0")
    lat_us=$(echo "$json_output" | jq -r ".jobs[0].${op_type}.clat_ns.mean // 0 | . / 1000 | round")
    local bw_mib
    bw_mib=$(awk "BEGIN {printf \"%.2f\", $bw_kib / 1024}")
    printf "%-25s | %-8s | %-12s | %-10s | %-15s\n" "$test_name" "QD$io_depth" "${bw_mib} MiB/s" "${iops} IOPS" "${lat_us} us"
}

# --- Main Test Execution ---
printf "%-25s | %-8s | %-12s | %-10s | %-15s\n" "Test Type" "IO Depth" "Bandwidth" "IOPS" "Avg Latency (us)"
echo "---------------------------------------------------------------------------------"
run_fio_test "Sequential Read" "read" "$SEQ_BS" 1
pause_between_tests
run_fio_test "Sequential Read" "read" "$SEQ_BS" 32
pause_between_tests
run_fio_test "Sequential Write" "write" "$SEQ_BS" 1
pause_between_tests
run_fio_test "Sequential Write" "write" "$SEQ_BS" 32
echo ""
pause_between_tests
run_fio_test "Random Read (4K)" "randread" "$RAND_BS" 1
pause_between_tests
run_fio_test "Random Read (4K)" "randread" "$RAND_BS" 32
pause_between_tests
run_fio_test "Random Write (4K)" "randwrite" "$RAND_BS" 1
pause_between_tests
run_fio_test "Random Write (4K)" "randwrite" "$RAND_BS" 32
echo "---------------------------------------------------------------------------------"
echo ""
echo "Benchmark finished."
