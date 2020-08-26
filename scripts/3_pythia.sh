#!/usr/bin/env sh

# The script exits when a command fails or it uses undeclared variables
set -o errexit
set -o nounset


# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -p|--project_path)  project_path="$2";  shift  ;;
        -m|--madgraph_dir)  madgraph_dir="$2";  shift  ;;
        -s|--signal_dir)    signal_dir="$2";    shift  ;;
        -z|--zip_file)      zip_file="$2";      shift  ;;
        -o|--output_dir)    output_dir="$2";    shift  ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done


# Define auxiliary variables
MADGRAPH_ABS_PATH="${project_path}/${madgraph_dir}"
SIGNAL_ABS_PATH="${output_dir}/${signal_dir}"
LOGS_ABS_PATH="${output_dir}/logs"


# Cleanup previous files (useful when run locally)
rm -rf "${output_dir}/events"
rm -rf "${SIGNAL_ABS_PATH}/Events"
rm -rf "${SIGNAL_ABS_PATH}/madminer"
rm -rf "${SIGNAL_ABS_PATH}/rw_me"
rm -rf "${LOGS_ABS_PATH}"

mkdir -p "${output_dir}/events"
mkdir -p "${SIGNAL_ABS_PATH}/Events"
mkdir -p "${SIGNAL_ABS_PATH}/madminer"
mkdir -p "${SIGNAL_ABS_PATH}/rw_me"
mkdir -p "${LOGS_ABS_PATH}"


# Perform actions
tar -xf "${zip_file}" -m -C "${SIGNAL_ABS_PATH}"


### IMPORTANT NOTE:
###
### The execution of the Pythia shell scripts is launched within a subshell (),
### placed at the working directory before running the code and calling MadGraph.
###
### This is necessary as MadGraph automatically creates a Python <-> Fortran
### translation file called "py.py" which needs to be written on disk.
(
    cd "${output_dir}" && \
    sh "${SIGNAL_ABS_PATH}/madminer/scripts/run"*".sh" "${MADGRAPH_ABS_PATH}" "${SIGNAL_ABS_PATH}" "${LOGS_ABS_PATH}"
)

tar -czf "${output_dir}/events/Events.tar.gz" \
    -C "${SIGNAL_ABS_PATH}" \
    "Events" \
    "madminer/cards"
