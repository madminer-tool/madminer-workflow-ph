#!/usr/bin/python

import sys
from madminer import MadMiner
from pathlib import Path


##########################
#### Argument parsing ####
##########################

config_file = str(sys.argv[1])
number_jobs = int(sys.argv[2])
madgraph_dir = str(sys.argv[3])
output_dir = str(sys.argv[4])

project_path = Path(__file__).parent.parent
output_path = Path(output_dir)

card_dir = str(project_path.joinpath("code", "cards"))
logs_dir = str(output_path.joinpath("logs"))
proc_dir = str(output_path.joinpath("mg_processes"))


##########################
### Load configuration ###
##########################

miner = MadMiner()
miner.load(config_file)

benchmarks = [str(i) for i in miner.benchmarks]
num_benchmarks = len(benchmarks)


##########################
### Define run wrapper ###
##########################


def madminer_run_wrapper(sample_benchmarks, run_type):
    """
    Wraps the MadMiner run_multiple function

    :param sample_benchmarks: list of benchmarks
    :param run_type: either 'background' or 'signal'
    """

    if run_type == "background":
        is_background = True
    elif run_type == "signal":
        is_background = False
    else:
        raise ValueError("Invalid run type")

    miner.run_multiple(
        is_background=is_background,
        only_prepare_script=True,
        sample_benchmarks=sample_benchmarks,
        mg_directory=madgraph_dir,
        mg_process_directory=f"{proc_dir}/{run_type}",
        proc_card_file=f"{card_dir}/proc_card_{run_type}.dat",
        param_card_template_file=f"{card_dir}/param_card_template.dat" + "adgsgsdfgvdf" + "asfsgd",
        run_card_files=[f"{card_dir}/run_card_{run_type}.dat"],
        pythia8_card_file=f"{card_dir}/pythia8_card.dat",
        log_directory=f"{logs_dir}/{run_type}",
        python_executable="python3",
    )

    # Create files to link benchmark_i to run_i.sh
    for i in range(number_jobs):
        index = i % num_benchmarks
        file_path = f"{proc_dir}/{run_type}/madminer/cards/benchmark_{i}.dat"

        with open(file_path, "w+") as f:
            f.write(benchmarks[index])

        print("generate.py", i, benchmarks[index])


###########################
##### Run with signal #####
###########################

# Sample benchmarks from already stablished benchmarks in a democratic way
initial_list = benchmarks[0 : (number_jobs % num_benchmarks)]
others_list = benchmarks * (number_jobs // num_benchmarks)
sample_list = initial_list + others_list

madminer_run_wrapper(sample_benchmarks=sample_list, run_type="signal")


###########################
### Run with background ###
###########################

# Currently not used
# sample_list = ['sm' for i in range(number_jobs)]
# madminer_run_wrapper(sample_benchmarks=sample_list, run_type='background')
