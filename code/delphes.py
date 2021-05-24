#!/usr/bin/python

import os
import re
import sys
import yaml
from madminer import DelphesReader
from pathlib import Path


########################
### Argument parsing ###
########################

config_file = sys.argv[1]
event_path = sys.argv[2]
input_file = sys.argv[3]
benchmark_file = sys.argv[4]
madgraph_dir = sys.argv[5]
output_dir = sys.argv[6]

project_path = Path(__file__).parent.parent
output_path = Path(output_dir)

card_dir = str(project_path.joinpath("code", "cards"))
data_dir = str(output_path.joinpath("data"))
logs_dir = str(output_path.joinpath("logs"))

with open(input_file, "r") as f:
    spec = yaml.safe_load(f)

with open(benchmark_file, "r") as f:
    benchmark = f.read()


########################
## Load configuration ##
########################

reader = DelphesReader(config_file)


##########################
#### Find events file ####
##########################

events_file = None
events_regex = re.compile(r"tag_[0-9]+_pythia8_events\.hepmc\.gz")

# This is required when running locally
for _, _, files in os.walk(event_path):
    for file in files:
        if events_regex.match(file):
            events_file = file
            break


#########################
###### Run Delphes ######
#########################

reader.add_sample(
    lhe_filename=f"{event_path}/unweighted_events.lhe.gz",
    hepmc_filename=f"{event_path}/{events_file}",
    sampled_from_benchmark=benchmark,
    weights="lhe",
)

reader.run_delphes(
    delphes_directory=f"{madgraph_dir}/Delphes",
    delphes_card=f"{card_dir}/delphes_card.dat",
    log_file=f"{logs_dir}/log_delphes.log",
)


############################
## Add observables / cuts ##
############################

for observable in spec["observables"]:
    reader.add_observable(
        observable["name"],
        observable["definition"],
        observable["required"],
        observable["default"],
    )

for cut in spec["cuts"]:
    reader.add_cut(cut["expression"])


############################
###### Analyse events ######
############################

reader.analyse_delphes_samples()


############################
##### Save events data #####
############################

os.makedirs(data_dir, exist_ok=True)

data_file_name = f"madminer_delphes_data_{benchmark}.h5"
data_file_path = f"{data_dir}/{data_file_name}"

reader.save(data_file_path)
