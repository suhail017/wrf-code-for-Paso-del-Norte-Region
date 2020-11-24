# -*- coding: utf-8 -*-
"""
Created on Tue Nov 24 12:23:31 2020

@author: Administrator
"""

from windrose import WindroseAxes
from matplotlib import pyplot as plt
import matplotlib.cm as cm
import numpy as np
import pandas

colnames = ['WindSpeed', 'WindDirection']
df = pandas.read_csv('test.csv')


#print(df[df['WindSpeed'].isnull()])
df = df.dropna(subset=['WindSpeed'])
df = df.dropna(subset=['WindDirection'])


#names = data.name.tolist()
ws = df.WindSpeed.tolist()
wd = df.WindDirection.tolist()





ax = WindroseAxes.from_ax()
ax.bar(wd, ws, normed=True, opening=0.5, edgecolor='red')
ax.set_legend()