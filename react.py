import pandas as pd
import matplotlib.pyplot as plt
import sys
import os

if len(sys.argv) < 2:
    print("Skorzystaj z: python react.py filename.csv")
    sys.exit()

path = '~/Desktop/wyniki/wyniki_react/dane_python/'
filename = path + sys.argv[1]


df = pd.read_csv(filename, header=None, names=["VIRT", "RES", "SHR", "CPU", "MEM", "TIME"])

x_values = df["TIME"] / 60

plt.plot(x_values, df["VIRT"], label="VIRT")
plt.plot(x_values, df["RES"], label="RES")
plt.plot(x_values, df["SHR"], label="SHR")
plt.plot(x_values, df["CPU"], label="CPU")
plt.plot(x_values, df["MEM"], label="MEM")

plt.legend()
plt.xlabel("Time [min]")
plt.ylabel("Usage")
plt.title("Resource usage over time")

plt.ylim(ymin=df.min().min(), ymax=df.max().max())
plt.show()
