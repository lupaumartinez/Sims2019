import numpy as np
import matplotlib.pyplot as plt
import os

def plot_input(folder, temperature, run, save_folder):

	name = os.path.join(folder, 'input.dat')

	spins = np.loadtxt(name)

	spins_2D = np.reshape(spins, (-1, 20))

	#plt.title('Temperatura_%s_RUN_%s'%(temperature,run))
	plt.imshow(spins_2D)
	#plt.show()

	fig_name = os.path.join(save_folder, 'fig_configuration_spins_Temperatura_%s_RUN_%s.png'%(temperature,run))
	plt.savefig(fig_name)

	return

def manage_save_directory(path, new_folder_name):

	# Small function to create a new folder if not exist.
    new_folder_path = os.path.join(path, new_folder_name)
    if not os.path.exists(new_folder_path):
        os.makedirs(new_folder_path)

    return new_folder_path


def plot_input_temperatures(parent_folder, run, save_folder):

	for files in os.listdir(parent_folder):
		if files.startswith("Temperatura"):  #recorre las carpetas, importante que los Temperatura_1.dat esten en otro lado
			temperatura = files.split('_')[1]
			name_folder = os.path.join(parent_folder, files, "RUN_%s"%run)
			plot_input(name_folder, temperatura, run, save_folder)

	return

if __name__ == '__main__':

    	#poner la dirección:
    
    	#parent_folder = 'C:/Users/Alumno/Dropbox/Simulaciones-master/Practica_Ising/Temperaturas/'
    parent_folder = '/home/agustin/Documents/Simulaciones/Practica_Ising/Temperaturas/Campo_0.01'
    save_folder = manage_save_directory(parent_folder, 'fig_configuration_spins')
    
    #%%
    		#Para una sola temperatura y run determinado:
   # run = 9
  #  temperatura = 1.2
 #   folder = os.path.join(parent_folder, "Temperatura_%s"%temperatura, "RUN_%s"%run)
  #  plot_input(folder, temperatura, run, save_folder)
    
    #%%
    
    	#Para todas las temepraturas y un run determinado, como recorre las carpetas "Temperatura_", importante que las Temperatura_.dat esten en otra carpeta
    run = 9
    plot_input_temperatures(parent_folder, run, save_folder)
       


