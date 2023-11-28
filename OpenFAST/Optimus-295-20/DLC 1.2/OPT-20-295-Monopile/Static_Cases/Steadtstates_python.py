import os
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from pyFAST.input_output import FASTOutputFile
import plotly.graph_objects as go
from plotly.subplots import make_subplots


directory_path = os.getcwd()
out_files = []

# Scan for all the .fst files in the directory_path and add to fst_files
for filename in os.listdir(directory_path):
    if filename.endswith(".out"):
        out_files.append(filename)

Time = []
Wind1speed = []
BldPitch1 = []
RotSpeed = []
GenPower = []
for index, filename in enumerate(out_files):
    fastout = FASTOutputFile(filename)
    FB= fastout.toDataFrame()
    Time.append(FB['Time_[s]'])
    Wind1speed.append(FB['Wind1VelX_[m/s]'])
    BldPitch1.append(FB['BldPitch1_[deg]'])
    RotSpeed.append(FB['RotSpeed_[rpm]'])
    GenPower.append(FB['GenPwr_[kW]'])


last_vals = 60


Time_avg = [np.mean(Time[i]) for i in range(len(Time))]
Wind1speed_avg = [np.mean(Wind1speed[i]) for i in range(len(Wind1speed))]
BldPitch1_avg = [np.mean(BldPitch1[i]) for i in range(len(BldPitch1))]
RotSpeed_avg = [np.mean(RotSpeed[i]) for i in range(len(RotSpeed))]
GenPower_avg = [np.mean(GenPower[i]) for i in range(len(GenPower))]

sort_values = [('Time', val) for val in Time_avg] + \
             [('Wind1speed', val) for val in Wind1speed_avg] + \
             [('BldPitch1', val) for val in BldPitch1_avg] + \
             [('RotSpeed', val) for val in RotSpeed_avg] + \
             [('GenPower', val) for val in GenPower_avg]

# Sort the averages in ascending order
sort_values.sort(key=lambda x: x[1])


# Convert list of tuples into DataFrame
sort_values_df = pd.DataFrame(sort_values, columns=['Variable', 'Value'])

# Separate the values based on the variable
Wind1speed = sort_values_df[sort_values_df['Variable'] == 'Wind1speed']['Value']
Windspeed = Wind1speed
BldPitch1 = sort_values_df[sort_values_df['Variable'] == 'BldPitch1']['Value']
RotSpeed = sort_values_df[sort_values_df['Variable'] == 'RotSpeed']['Value']
GenPower = sort_values_df[sort_values_df['Variable'] == 'GenPower']['Value']

# Plotting
plt.figure(figsize=(12, 8))

plt.subplot(4, 1, 1)
plt.plot(Windspeed, BldPitch1, '.-')
plt.title('BldPitch1')
plt.grid(True)

plt.subplot(4, 1, 2)
plt.plot(Windspeed, RotSpeed, '.-')
plt.title('RotSpeed')
plt.grid(True)

plt.subplot(4, 1, 3)
plt.plot(Windspeed, GenPower, '.-')
plt.title('GenPower')
plt.grid(True)

plt.tight_layout()
plt.show()

# Create subplots: 3 rows, 1 column
fig = make_subplots(rows=3, cols=1)

# Adding traces
fig.add_trace(go.Scatter(x=Windspeed, y=BldPitch1, mode='lines+markers', name='BldPitch1'), row=1, col=1)
fig.add_trace(go.Scatter(x=Windspeed, y=RotSpeed, mode='lines+markers', name='RotSpeed'), row=2, col=1)
fig.add_trace(go.Scatter(x=Windspeed, y=GenPower, mode='lines+markers', name='GenPower'), row=3, col=1)

# Update xaxis properties
fig.update_xaxes(title_text="Windspeed", row=1, col=1)
fig.update_xaxes(title_text="Windspeed", row=2, col=1)
fig.update_xaxes(title_text="Windspeed", row=3, col=1)

# Update yaxis properties
fig.update_yaxes(title_text="BldPitch1", row=1, col=1)
fig.update_yaxes(title_text="RotSpeed", row=2, col=1)
fig.update_yaxes(title_text="GenPower", row=3, col=1)

# Update title and height
fig.update_layout(height=1200, width=1600, title_text="Subplots")

fig.show()



