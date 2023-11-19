# Python Modules
import os
import matplotlib.pyplot as plt
# ROSCO Modules
from ROSCO_toolbox import turbine as ROSCO_turbine
from ROSCO_toolbox.inputs.validation import load_rosco_yaml


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
    os.path.join(tune_dir,path_params['FAST_directory']),
    rot_source='txt',txt_filename=os.path.join(tune_dir,path_params['FAST_directory'],path_params['rotor_performance_filename'])
    )

# Print some basic turbine info
print(turbine)

# plot rotor performance
print('Plotting Cp data')
turbine.Cp.plot_performance()
plt.show()
