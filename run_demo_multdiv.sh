#!/bin/bash
# A script to demonstrate the full grammarinator workflow.
# This version uses the stable command-line tool.

# Stop the script if any command fails
set -e

echo "--- 1. Processing the grammar (tiny_calc_multdiv.g4) ---"
echo "This reads the .g4 file and generates the Python fuzzer."
grammarinator-process tiny_calc_multdiv.g4
echo "✅ Fuzzer generated!"
echo

echo "--- 2. Generating 20 test cases ---"
echo "This runs the generated fuzzer to create test inputs."
# Ensure the output directory exists
mkdir -p test_cases_multdiv

# 1. We must use a full output pattern for '-o', like 'test_cases/test_%d.txt'.
#    Using just a directory 'test_cases/' is ambiguous.
#
# 2. We must add '--sys-path .' so Python can find the module.
#
# 3. The final 'NAME' argument MUST be in the format 'ModuleName.ClassName'.
#    In our case, that is 'tiny_calcGenerator.tiny_calcGenerator'.
#
grammarinator-generate \
    --sys-path . \
    -n 20 \
    -d 8 \
    -o test_cases_multdiv/test_%d.txt \
    tiny_calc_multdivGenerator.tiny_calc_multdivGenerator
# ----------------------------------

echo "✅ 20 test cases created in 'test_cases/'"
echo

echo "--- 3. Running the 'calc.py' target against all test cases ---"
# Initialize counters
crash_count=0
test_count=0

# Loop through all generated .txt files in the directory
for testfile in test_cases_multdiv/test_*.txt; do
    
    # Check if the file exists before running
    if [ -f "$testfile" ]; then
        echo "--- Testing with: $testfile ---"
        ((test_count++))
        
        # Run the test.
        # 'if !' checks the exit code (crash or not).
        if ! python calc.py "$testfile"; then
            echo "💥 CRASH DETECTED 💥"
            ((crash_count++))
        fi
        
        sleep 0.1 # Small delay for readability
    fi
done

echo
echo "--- 🏁 Test Run Complete ---"
echo "Processed $test_count test files."
echo "Total crashes found: $crash_count"

# Exit with a non-zero code if we found any crashes
if [ $crash_count -gt 0 ]; then
    exit 1
fi