#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Oct  4 18:15:38 2019

@author: agustin
"""

import subprocess
import numpy as np

#pi = []
# completed = subprocess.run(['ls','-1'])
f = open('Lista_temp.dat','r')
for renglon in f:
    temp = renglon
    g = open('configuracion_ini.dat','w+')
    g.write('! Temperatura \n')
    g.write(temp)
    g.write('! N pasos de MC \n')
    g.write('10000\n')
    g.write('! Size red MC\n')
    g.write('20\n')
    g.write('! Campo externo\n')
    g.write('0.0\n')
    g.close()
    for i in range(9):
        print('Start RUN_{} Temperatura_{}'.format(i+1,temp))    
        completed = subprocess.run('mkdir RUN_{}'.format(i+1),shell=True)
        completed2 = subprocess.run('../simple',shell=True)
#        completed3 = subprocess.run('mv salida.dat ~/Documents/Materia2/Practica_Ising/Temperaturas/RUN_{}'.format(i+1),shell=True)
        completed4 = subprocess.run('mv variables_fisicas.dat ~/Documents/Materia2/Practica_Ising/Temperaturas/RUN_{}'.format(i+1),shell=True)
        completed5 = subprocess.run('cp input.dat ~/Documents/Materia2/Practica_Ising/Temperaturas/RUN_{}'.format(i+1),shell=True)
        completed6 = subprocess.run('cp configuracion_ini.dat ~/Documents/Materia2/Practica_Ising/Temperaturas/RUN_{}'.format(i+1),shell=True)
        print('End RUN_{}'.format(i+1))
    print('antes de crear directorio')        
    completed7 = subprocess.run('mkdir Temperatura_{}'.format(temp),shell=True)
    print('despues de crear directorio')    
    for j in range(9):
        print('antes de mover')
        completed8= subprocess.run('mv RUN_{}/ ./Temperatura_{}/'.format(j+1,temp),shell=True)
        print('despues de mover')
f.close()        
