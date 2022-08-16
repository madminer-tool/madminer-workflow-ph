#!/usr/bin/env sh

# The script exits when a command fails or it uses undeclared variables
set -o errexit
set -o nounset


# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -p|--project_path) project_path="$2";   shift  ;;
        -i|--input_files)  input_files="$2";    shift  ;;
        -o|--output_dir)   output_dir="$2";     shift  ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

echo "before python3"

# Perform actions
python3 "${project_path}/code/multi_combine.py" "${input_files}" "${output_dir}"
