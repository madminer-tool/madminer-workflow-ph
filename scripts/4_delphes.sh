#!/usr/bin/env sh

# The script exits when a command fails or it uses undeclared variables
set -o errexit
set -o nounset


# Define help function
helpFunction()
{
    printf "\n"
    printf "Usage: %s -p project_path -c config_file -i input_file -e events_file -o output_dir\n" "${0}"
    printf "\t-p Project top-level path\n"
    printf "\t-c Configuration file path\n"
    printf "\t-i Workflow input file\n"
    printf "\t-e Events file path\n"
    printf "\t-o Workflow output dir\n"
    exit 1
}

# Argument parsing
while getopts "p:c:i:e:o:" opt
do
    case "$opt" in
        p ) PROJECT_PATH="$OPTARG" ;;
        c ) CONFIG_FILE="$OPTARG" ;;
        i ) INPUT_FILE="$OPTARG" ;;
        e ) EVENTS_FILE="$OPTARG" ;;
        o ) OUTPUT_DIR="$OPTARG" ;;
        ? ) helpFunction ;;
    esac
done

if [ -z "${PROJECT_PATH}" ] || [ -z "${CONFIG_FILE}" ] || [ -z "${INPUT_FILE}" ] || \
    [ -z "${EVENTS_FILE}" ] || [ -z "${OUTPUT_DIR}" ]
then
    echo "Some or all of the parameters are empty";
    helpFunction
fi


# Define auxiliary variables
EXTRACT_PATH="${OUTPUT_DIR}/extract"
LOGS_PATH="${OUTPUT_DIR}/logs"


# Cleanup previous files (useful when run locally)
rm -rf "${EXTRACT_PATH}"
rm -rf "${LOGS_PATH}"

mkdir -p "${EXTRACT_PATH}"
mkdir -p "${LOGS_PATH}"


# Perform actions
tar -xvf "${EVENTS_FILE}" -C "${EXTRACT_PATH}"
mv "${EXTRACT_PATH}/madminer/cards/benchmark_"*".dat" "${EXTRACT_PATH}/madminer/cards/benchmark.dat"

python3 "${PROJECT_PATH}/code/delphes.py" \
    "${CONFIG_FILE}" \
    "${EXTRACT_PATH}/Events/run_01" \
    "${INPUT_FILE}" \
    "${EXTRACT_PATH}/madminer/cards/benchmark.dat" \
    "${OUTPUT_DIR}"
