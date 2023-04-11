import pandas as pd
import matplotlib.pyplot as plt
import sys
import os

if len(sys.argv) < 2:
    print("Skorzystaj z: python flutter_wyniki.py filename.txt")

path = '~/Desktop/wyniki/wyniki_flutter/'
filename = path + sys.argv[1]
values = ["VIRT", "RES", "SHR", "CPU", "MEM", "TIME", "NR"]

df = pd.read_csv(filename, header=None, names = values)

x_values = df["NR"]

fig1, ax1 = plt.subplots()

ax1.plot(x_values, df["TIME"], label = "TIME [min]")


ax1.legend()
ax1.set_xlabel("Sample number")
ax1.set_ylabel("Time usage [min]")
ax1.set_title("Time usage in all sample")
ax1.set_ylim(ymin=df.min().min(), ymax=df.max().max())

plt.show()