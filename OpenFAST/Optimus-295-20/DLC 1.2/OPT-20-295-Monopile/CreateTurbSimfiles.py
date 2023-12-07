import os
import shutil
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal.windows import hamming
from scipy import signal
from scipy.interpolate import interp1d
from scipy.io import loadmat

# Add paths
import sys
sys.path.append('..\PythonFunctions')
from ManipulateTXTFile import ManipulateTXTFile


nSeed = 6                                                   # [-] number of stochastic turbulence field samples
Seed_vec = list(range(1, nSeed + 1))                        # [-] vector of seeds


# Files (should not be be changed)
TurbSimExeFile = 'TurbSim_x64.exe'
TurbSimTemplateFile = '../Wind/TurbSimInputFileTemplate_Optimus_295.inp'


if not os.path.exists('TurbulentWind'):
    os.makedirs('TurbulentWind')


# Preprocessing: generate turbulent wind field

# Copy the adequate TurbSim version to the example folder
shutil.copyfile(os.path.join('../Wind', TurbSimExeFile), os.path.join('TurbulentWind', TurbSimExeFile))

# Generate all wind fields
for iSeed in range(nSeed):
    Seed = Seed_vec[iSeed]
    WindFileName = f'URef_28_Seed_{Seed:02d}'
    TurbSimInputFile = os.path.join('TurbulentWind', f'{WindFileName}.ipt')
    TurbSimResultFile = os.path.join('TurbulentWind', f'{WindFileName}.wnd')
    if not os.path.exists(TurbSimResultFile):
        shutil.copyfile(TurbSimTemplateFile, TurbSimInputFile)
        ManipulateTXTFile(TurbSimInputFile, 'MyRandSeed1', str(Seed))                           # adjust seed
        os.system(os.path.join('TurbulentWind', TurbSimExeFile) + ' ' + TurbSimInputFile)

# Clean up
os.remove(os.path.join('TurbulentWind', TurbSimExeFile))
