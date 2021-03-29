#!/usr/bin/env sh

# The script exits when a command fails or it uses undeclared variables
set -o errexit
set -o nounset


# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -p|--project_path)  project_path="$2";  shift  ;;
        -m|--madgraph_dir)  madgraph_dir="$2";  shift  ;;
        -c|--config_file)   config_file="$2";   shift  ;;
        -i|--input_file)    input_file="$2";    shift  ;;
        -e|--events_file)   events_file="$2";   shift  ;;
        -o|--output_dir)    output_dir="$2";    shift  ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done


# Define auxiliary variables
MADGRAPH_ABS_PATH="${project_path}/${madgraph_dir}"
EXTRACT_ABS_PATH="${output_dir}/extract"
LOGS_ABS_PATH="${output_dir}/logs"


# Cleanup previous files (useful when run locally)
rm -rf "${EXTRACT_ABS_PATH}"
rm -rf "${LOGS_ABS_PATH}"

mkdir -p "${EXTRACT_ABS_PATH}"
mkdir -p "${LOGS_ABS_PATH}"


# Perform actions
tar -xf "${events_file}" -C "${EXTRACT_ABS_PATH}"
mv "${EXTRACT_ABS_PATH}/madminer/cards/benchmark_"*".dat" "${EXTRACT_ABS_PATH}/madminer/cards/benchmark.dat"

python3 "${project_path}/code/delphes.py" \
    "${config_file}" \
    "${EXTRACT_ABS_PATH}/Events/run_01" \
    "${input_file}" \
    "${EXTRACT_ABS_PATH}/madminer/cards/benchmark.dat" \
    "${MADGRAPH_ABS_PATH}" \
    "${output_dir}"
