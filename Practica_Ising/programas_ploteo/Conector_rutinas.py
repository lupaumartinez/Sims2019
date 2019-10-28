#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct  6 20:25:14 2019

@author: agustin
"""

#import pandas as pd
import os

parent_folder = '/home/luciana/Documentos/Simulaciones-master/Practica_Ising/Temperaturas/'
#parent_folder = "/home/agustin/Documents/Materia/Practica_Ising/Temperaturas/"

#Crea carpeta de campo indicado donde se alojaran los archivos "Temperatura...dat"
B = 0.1
#B = 0
new_folder_name = 'Campo_B_{}'.format(B)
new_folder = os.path.join(parent_folder, new_folder_name)
if not os.path.exists(new_folder):
    os.makedirs(new_folder)
        
#Abre archivos con nombre Temperatura alojados en el parent_folder, recorre 9 RUNs y abre las variables_fisicas.dat y las escribe en Temperatura_....dat
for files in os.listdir(parent_folder):
    
    if files.startswith("Temperatura"):
        
        temperatura = files.split('_')[1]
        print('Temperatura', temperatura)
        
       # datos = pd.read_csv('Temperatura_{}.dat'.format(temperatura))

        for i in range(9):
        
            f = open(parent_folder + "Temperatura_{}/RUN_{}/variables_fisicas.dat".format(temperatura, i+1),"r")
            g = open(new_folder +"/Temperatura_{}.dat".format(temperatura),"a")   
            
            if i==0 :
                line = f.readline()
                g.write('Temperatura,'+line+'\n')
                line = f.readline()
                g.write('{},'.format(temperatura)+line+'\n')
            else:
                line = f.readline()
                line = f.readline()
                g.write('{},'.format(temperatura)+line+'\n')
                f.close()
                g.close()

        
    
    
    
    
    