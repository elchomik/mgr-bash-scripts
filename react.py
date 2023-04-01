import pandas as pd
import matplotlib.pyplot as plt
import sys
import os

if len(sys.argv) < 2:
    print("Skorzystaj z: python react.py filename.csv")
    sys.exit()

path = '~/Desktop/wyniki/wyniki_react/dane_python/'
filename = path + sys.argv[1]
values = ["VIRT", "RES", "SHR", "CPU", "MEM", "TIME"]

df = pd.read_csv(filename, header=None, names=values)

x_values = df["TIME"] / 60

fig1, ax1 = plt.subplots()

ax1.plot(x_values, df["VIRT"], label="VIRT")
ax1.plot(x_values, df["RES"], label="RES")
ax1.plot(x_values, df["SHR"], label="SHR")
ax1.plot(x_values, df["CPU"], label="CPU")
ax1.plot(x_values, df["MEM"], label="MEM")

ax1.legend()
ax1.set_xlabel("Time [min]")
ax1.set_ylabel("Usage")
ax1.set_title("Resource usage over time")
ax1.set_ylim(ymin=df.min().min(), ymax=df.max().max())

table = pd.pivot_table(df, values=values, index= "TIME")

fig2, ax2 = plt.subplots()
table.plot(kind='bar', ax=ax2)
ax2.set_title("Wartość VIRT, RES, SHR, CPU, MEM w poszczególnych okresach czasowych")
ax2.set_xlabel("Time [min]")
ax2.set_ylabel("Wartość VIRT, RES, SHR, CPU, MEM")

plt.show()
