import numpy as np
import matplotlib.pyplot as plt
# ROSCO toolbox modules
from ROSCO_toolbox.ofTools.fast_io import output_processing
import os

this_dir = os.path.dirname(os.path.abspath(__file__))
example_out_dir = os.path.join(this_dir,'Output')
if not os.path.isdir(Output_dir):
  os.makedirs(Output_dir)

# Define openfast output filenames
filenames = [r"IEA-15-240-RWT-Monopile.outb"]
# ---- Note: Could load and plot multiple cases, textfiles, and binaries...
# filenames = ["../Test_Cases/NREL-5MW/NREL-5MW.outb",
#             "../Test_Cases/NREL-5MW/NREL-5MW_ex8.outb"]

filenames = [os.path.join(this_dir,file) for file in filenames]

#  Define Plot cases
#  --- Comment,uncomment, create, and change these as desired...
cases = {}
#cases['Baseline'] = ['Wind1VelX', 'BldPitch1', 'GenTq', 'RotSpeed']
cases['Rotor'] = ['Wind1VelX','BldPitch1', 'GenTq', 'GenPwr']
# cases['Platform Motion'] = ['PtfmSurge', 'PtfmSway', 'PtfmHeave', 'PtfmPitch','PtfmRoll','PtfmYaw']


# Instantiate fast_IO
fast_out = output_processing.output_processing()
# Can also do:
# fast_out = output_processing.output_processing(filenames=filenames, cases=cases)
# fast_out.plot_fast_out()

# Load and plot
fastout = fast_out.load_fast_out(filenames)
fast_out.plot_fast_out(cases=cases,showplot=False)

plt.savefig(os.path.join(example_out_dir,'10ms'))
