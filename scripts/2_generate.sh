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
        -j|--number_jobs)   number_jobs="$2";   shift  ;;
        -o|--output_dir)    output_dir="$2";    shift  ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done


# Define auxiliary variables
MADGRAPH_ABS_PATH="${project_path}/${madgraph_dir}"
SIGNAL_ABS_PATH="${output_dir}/mg_processes/signal"


### IMPORTANT NOTE:
###
### The generation of future executable scripts is launched within a subshell (),
### placed at the working directory before running the code and calling MadGraph.
###
### This is necessary as MadGraph automatically creates a Python <-> Fortran
### translation file called "py.py" which needs to be written on disk.
(
    cd "${output_dir}" && \
    python3 "${project_path}/code/generate.py" "${config_file}" "${number_jobs}" "${MADGRAPH_ABS_PATH}" "${output_dir}"
)

for i in $(seq 0 $((number_jobs-1))); do
    tar -czf "${output_dir}/folder_${i}.tar.gz" \
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
