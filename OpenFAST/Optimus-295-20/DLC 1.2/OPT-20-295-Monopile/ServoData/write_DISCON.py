# Python modules
import os
# ROSCO toolbox modules
from ROSCO_toolbox import controller as ROSCO_controller
from ROSCO_toolbox import turbine as ROSCO_turbine
from ROSCO_toolbox.utilities import write_DISCON
from ROSCO_toolbox.inputs.validation import load_rosco_yaml


tune_dir = os.getcwd()
parameter_filename = 'OPT_20_295.yaml'
inps = load_rosco_yaml(parameter_filename)
path_params         = inps['path_params']
turbine_params      = inps['turbine_params']
controller_params   = inps['controller_params']

turbine         = ROSCO_turbine.Turbine(turbine_params)
controller      = ROSCO_controller.Controller(controller_params)

FAST_InputFile = 'OPT-20-295-Monopile.fst'

cp_filename = os.path.join(os.path.dirname(os.path.dirname(__file__)), path_params['FAST_directory'], path_params['rotor_performance_filename'])


turbine.load_from_fast(
    FAST_InputFile,
    os.path.join(os.path.dirname(os.path.dirname(__file__)), path_params['FAST_directory']),
    rot_source='txt', txt_filename=cp_filename
    )

controller.tune_controller(turbine)

param_file = os.path.join(os.path.dirname(__file__), '../OPT-20-295-Monopile-DISCON.IN')
write_DISCON(turbine,controller,
param_file=param_file,
txt_filename=cp_filename
)
