# Turbine development for a 20 MW wind turbine 

## Origin
This github repository started as a for fork of the IEA-15-240-RWT:
https://github.com/IEAWindTask37/IEA-15-240-RWT

## How to get started
* download the openfast_x64.exe v3.5.0 from https://github.com/OpenFAST/openfast/releases/download/v3.5.0/openfast_x64.exe to the OptimusOceanus17MW-Monopile folder
* download the ROSCO libdiscon.dll v2.8.0 from [https://github.com/NREL/ROSCO/releases/download/v2.8.0/libdiscon.dll](https://github.com/NREL/ROSCO/releases/download/v2.8.0/libdiscon.dll) to the OptimusOceanus17MW-Monopile folder
* run  in the OptimusOceanus17MW-Monopile folder
```
openfast_x64.exe IEA-15-240-RWT-Monopile.fst
```
* check the results using pydatview from https://github.com/ebranlard/pyDatView/releases
