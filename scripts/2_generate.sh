#!/usr/bin/env sh

# The script exits when a command fails or it uses undeclared variables
set -o errexit
set -o nounset


# Define help function
helpFunction()
{
    printf "\n"
    printf "Usage: %s -p project_path -s signal_folder -j num_jobs -c config_file -o output_dir\n" "${0}"
    printf "\t-p Project top-level path\n"
    printf "\t-s Signal folder sub-path\n"
    printf "\t-j Number of jobs\n"
    printf "\t-c Configuration file path\n"
    printf "\t-o Workflow output dir\n"
    exit 1
}

# Argument parsing
while getopts "p:s:j:c:o:" opt
do
    case "$opt" in
        p ) PROJECT_PATH="$OPTARG" ;;
        s ) SIGNAL_FOLDER="$OPTARG" ;;
        j ) NUM_JOBS="$OPTARG" ;;
        c ) CONFIG_FILE="$OPTARG" ;;
        o ) OUTPUT_DIR="$OPTARG" ;;
        ? ) helpFunction ;;
    esac
done

if [ -z "${PROJECT_PATH}" ] || [ -z "${SIGNAL_FOLDER}" ] || [ -z "${NUM_JOBS}" ] || \
    [ -z "${CONFIG_FILE}" ] || [ -z "${OUTPUT_DIR}" ]
then
    echo "Some or all of the parameters are empty";
    helpFunction
fi


# Define auxiliary variables
SIGNAL_ABS_PATH="${OUTPUT_DIR}/${SIGNAL_FOLDER}"


# Perform actions
python3 "${PROJECT_PATH}/code/generate.py" "${NUM_JOBS}" "${CONFIG_FILE}" "${OUTPUT_DIR}"

for i in $(seq 0 $((NUM_JOBS-1))); do
    tar -czvf "${OUTPUT_DIR}/folder_${i}.tar.gz" \
        -C "${SIGNAL_ABS_PATH}" \
        "bin" \
        "Cards" \
        "HTML" \
        "lib" \
        "madminer/scripts/run_${i}.sh" \
        "madminer/cards/benchmark_${i}.dat" \
        "madminer/cards/mg_commands_${i}.dat" \
        "madminer/cards/param_card_${i}.dat" \
        "madminer/cards/pythia8_card_${i}.dat" \
        "madminer/cards/reweight_card_${i}.dat" \
        "madminer/cards/run_card_${i}.dat" \
        "Source" \
        "SubProcesses" \
        "madevent.tar.gz"
done
