
# Python modules
import os
import matplotlib.pyplot as plt
# ROSCO toolbox modules 
from ROSCO_toolbox import turbine as ROSCO_turbine
from ROSCO_toolbox.utilities import write_rotor_performance
from ROSCO_toolbox.inputs.validation import load_rosco_yaml

# Initialize parameter dictionaries
turbine_params = {}
control_params = {}

# Load yaml file
this_dir = os.path.dirname(os.path.abspath(__file__))
tune_dir = os.getcwd()
parameter_filename = 'ServoData/OPT_20_295.yaml'
inps = load_rosco_yaml(parameter_filename)
path_params         = inps['path_params']
turbine_params      = inps['turbine_params']
controller_params   = inps['controller_params']

# Load turbine data from openfast model
turbine = ROSCO_turbine.Turbine(turbine_params)
turbine.load_from_fast(
    path_params['FAST_InputFile'],
    os.path.join(this_dir, path_params['FAST_directory']),
    rot_source='cc-blade',
    txt_filename=None)

# Write rotor performance text file
txt_filename = os.path.join(this_dir, 'Cp_Ct_Cq_OPTIMUS_20_295_v2.txt')
write_rotor_performance(turbine, txt_filename=txt_filename)

# plot rotor performance
print('Plotting Cp data')
turbine.Cp.plot_performance()

if False:
  plt.show()
else:
  plt.savefig('Output/Cp_Ct_Cq_OPTIMUS_20_295_v3.png')
