#!/usr/bin/env sh

# The script exits when a command fails or it uses undeclared variables
set -o errexit
set -o nounset


# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -p|--project_path)  project_path="$2";  shift  ;;
        -i|--input_file)    input_file="$2";    shift  ;;
        -s|--events_file)   events_file="$2";   shift  ;;
        -c|--config_file)   config_file="$2";   shift  ;;
        -o|--output_dir)    output_dir="$2";    shift  ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done


# Define auxiliary variables
EXTRACT_PATH="${output_dir}/extract"
LOGS_PATH="${output_dir}/logs"


# Cleanup previous files (useful when run locally)
rm -rf "${EXTRACT_PATH}"
rm -rf "${LOGS_PATH}"

mkdir -p "${EXTRACT_PATH}"
mkdir -p "${LOGS_PATH}"


# Perform actions
tar -xf "${events_file}" -C "${EXTRACT_PATH}"
mv "${EXTRACT_PATH}/madminer/cards/benchmark_"*".dat" "${EXTRACT_PATH}/madminer/cards/benchmark.dat"

python3 "${project_path}/code/delphes.py" \
    "${config_file}" \
    "${EXTRACT_PATH}/Events/run_01" \
    "${input_file}" \
    "${EXTRACT_PATH}/madminer/cards/benchmark.dat" \
    "${output_dir}"
