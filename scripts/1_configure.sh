#!/usr/bin/env sh

# The script exits when a command fails or it uses undeclared variables
set -o errexit
set -o nounset


# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -p|--project_path) project_path="$2";   shift  ;;
        -i|--input_file)   input_file="$2";     shift  ;;
        -o|--output_dir)   output_dir="$2";     shift  ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done


# Perform actions
python3 "${project_path}/code/configure.py" "${input_file}" "${output_dir}"
