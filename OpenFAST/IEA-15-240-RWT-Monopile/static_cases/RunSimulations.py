## This Script Scans for all the .fst files in a directory and runs them in OENFAST Executable file.
## Best is to place this script in the directory where you want to run the simulations
## This script needs ROSCO_toolbox to be installed


import os

# ROSCO toolbox modules

from ROSCO_toolbox.utilities import run_openfast

#Define the path of OPENFAST execuatble file
fastcall = 'openfast_x64.exe'

# Define the directory_path to your current working directory
# **Comment** You can also replace with the actual path to your .fst files

directory_path = os.getcwd() # Replace with the actual path to your .fst files

# Load all the .fst files here
fst_files = []

# Scan for all the .fst files in the directory_path and add to fst_files
for filename in os.listdir(directory_path):
    if filename.endswith(".fst"):
        fst_files.append(filename)


# Run each .fst file in a loop
for fst_file in fst_files:
    fst_path = os.path.abspath(os.path.join(directory_path, fst_file))
    run_openfast(
        directory_path,
        fastcall=fastcall,
        fastfile=fst_path,
        chdir=True
    )