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
        param_card_template_file=f"{card_dir}/param_card_template.dat",
        run_card_files=[f"{card_dir}/run_card_{run_type}.dat"],
        pythia8_card_file=f"{card_dir}/pythia8_card.dat",
        log_directory=f"{logs_dir}/{run_type}",
        python_executable="python3",
    )

    # Create files to link benchmark_i to run_i.sh
    for i, benchmark in enumerate(benchmarks):
        file_path = f"{proc_dir}/{run_type}/madminer/cards/benchmark_{i}.dat"

        with open(file_path, "w+") as f:
            f.write(benchmark)

        print("Benchmark:", i, benchmark)


###########################
##### Run with signal #####
###########################

madminer_run_wrapper(
    sample_benchmarks=benchmarks,
    run_type="signal",
)


###########################
### Run with background ###
###########################

# Currently not used
# madminer_run_wrapper(
#     sample_benchmarks=["sm"] * len(benchmarks),
#     run_type="background",
# )
