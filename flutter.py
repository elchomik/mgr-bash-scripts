import pandas as pd
import matplotlib.pyplot as plt
import sys
import os

if len(sys.argv) < 2:
    print("Skorzystaj z: python react.py filename.csv")
    sys.exit()

path = '~/Desktop/wyniki/wyniki_flutter/dane_python/'
filename = path + sys.argv[1]
values = ["VIRT", "RES", "SHR", "CPU", "MEM", "TIME"]

df = pd.read_csv(filename, header=None, names=values)

x_values = df["TIME"] / 60

fig1, ax1 = plt.subplots()

ax1.plot(x_values, df["VIRT"], label="VIRT [G]")
ax1.plot(x_values, df["RES"], label="RES [M]")
ax1.plot(x_values, df["SHR"], label="SHR [M]")
ax1.plot(x_values, df["CPU"], label="CPU [%]")
ax1.plot(x_values, df["MEM"], label="MEM [%]")

ax1.legend()
ax1.set_xlabel("Time [min]")
ax1.set_ylabel("Usage")
ax1.set_title("Resource usage over time")
ax1.set_ylim(ymin=df.min().min(), ymax=df.max().max())

plt.show()
