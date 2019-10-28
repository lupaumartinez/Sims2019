import numpy as np
import matplotlib.pyplot as plt

data = np.loadtxt('X.dat')

plt.figure()
plt.histogram(data)
plt.show()
