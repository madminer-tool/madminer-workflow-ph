#!/usr/bin/python

import os
import sys
from madminer import combine_and_shuffle
from pathlib import Path


##########################
#### Argument parsing ####
##########################

input_files = sys.argv[1]
output_dir = Path(sys.argv[2])

data_dir = str(output_dir.joinpath("data"))


###########################
### Cleaning file names ###
###########################

file_paths = input_files.split()
print(file_paths)

##########################
#### Merging entities ####
##########################

os.makedirs(data_dir, exist_ok=True)

output_file = "multi_combined.h5"
output_path = f"{data_dir}/{output_file}"

combine_and_shuffle(
    input_filenames=input_files.split(),
    output_filename=output_path,
)
print("end")
