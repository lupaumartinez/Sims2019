import numpy as np
import matplotlib.pyplot as plt
import os

def open_data(parent_folder):

	list_of_files = []

	for files in os.listdir(parent_folder):
		if files.startswith("Temperatura"):
			list_of_files.append(files) 

	#list_of_files.sort()

	L = len(list_of_files)

	print('Cantidad de temperaturas', L)

	#Temperatura, Energy_med,Energy2_med,var_energy,Cv,Magnetization_med,Magnetization2_med,var_magnetization, X,N_tot,N_fav

	temperature = np.zeros(L)
	energy = np.zeros(L)
	err_energy = np.zeros(L)
	var_energy = np.zeros(L)
	cv = np.zeros(L)
	magnetization = np.zeros(L)
	err_magnetization = np.zeros(L)
	var_magnetization = np.zeros(L)
	x = np.zeros(L)
	Neff = np.zeros(L)

	for i in range(L):

		#a = list_of_files[i].split('_')[1]
		#b = a.split('.')[0]
		#c = b.replace(",", ".")
		#temperature[i] = c

		name = os.path.join(parent_folder, list_of_files[i])
		data = np.genfromtxt(name, delimiter=',')

		temperature[i] = data[1,0]

		energy[i] = np.mean(data[1:,1])
		err_energy[i] = np.std(data[1:,1])

		var_energy[i] = np.mean(np.array(data[1:,3]))
		cv[i] = np.mean(np.array(data[1:,4])*np.array(data[1:,3]))

		magnetization[i] = -1*np.mean(data[1:,5])/400
		err_magnetization[i] = np.std(data[1:,5])/400

		var_magnetization[i] = np.mean(np.array(data[1:,7]))
		x[i] = np.mean(np.array(data[1:,8])*np.array(data[1:,7])/400)

		Neff[i] = np.mean(data[1:,10])/np.mean(data[1:,9])

	data = np.array([temperature, energy, err_energy, var_energy, cv, magnetization, err_magnetization, var_magnetization, x, Neff]).T
	name = os.path.join(parent_folder, 'all_data_temperature.csv')
	header_text = 'Temperature, Energy, Err Energy, Var Energy, Cv, Magnetization, Err Magnetization, Var Magnetization, X, Neff'
	np.savetxt(name, data, header=header_text)

	return data

def manage_save_directory(path, new_folder_name):
    # Small function to create a new folder if not exist.
    new_folder_path = os.path.join(path, new_folder_name)
    if not os.path.exists(new_folder_path):
        os.makedirs(new_folder_path)
    return new_folder_path

def plot_data(parent_folder):

	save_folder = manage_save_directory(parent_folder, 'figures_temperature')

	name = os.path.join(parent_folder, 'all_data_temperature.csv')
	data = np.genfromtxt(name, delimiter='')

	temperature = data[0:,0]
	energy = data[0:,1]
	err_energy = data[0:,2]
	var_energy = data[0:,3]
	cv  = data[0:,4]
	magnetization  = data[0:,5]
	err_magnetization = data[0:,6]
	var_magnetization  = data[0:,7]
	x  = data[0:,8]
	Neff  = data[0:,9]

	Tc = 2.3
	betha = 1/2
	temp, mag = bragg_williams(Tc, betha)

	print('Grafico energía')
	plt.figure()
	plt.errorbar(temperature, energy, yerr = err_energy,linestyle = 'none', marker = 'o')
	plt.xlabel('Temperatura')
	plt.ylabel('Energía')
	figure_name = os.path.join(save_folder, 'energy_vs_temperature.png')
	plt.savefig(figure_name, dpi = 400)
	plt.close()

	print('Grafico fluctuación energía')
	plt.figure()
	plt.plot(temperature, var_energy, 'o')
	plt.xlabel('Temperatura')
	plt.ylabel('Fluctuación Energía')
	figure_name = os.path.join(save_folder, 'var_energy_vs_temperature.png')
	plt.savefig(figure_name, dpi = 400)
	plt.close()

	print('Grafico Cv')
	plt.figure()
	plt.plot(temperature, cv, 'o')
	plt.xlabel('Temperatura')
	plt.ylabel('Cv')
	figure_name = os.path.join(save_folder, 'cv_vs_temperature.png')
	plt.savefig(figure_name, dpi = 400)
	plt.close()

	print('Grafico Magnetización')
	plt.figure()
	plt.errorbar(temperature, magnetization, yerr = err_magnetization,linestyle = 'none',marker = 'o')
	#plt.plot(temp, mag, 'r--')
	plt.xlabel('Temperatura')
	plt.ylabel('Magnetización')
	figure_name = os.path.join(save_folder, 'M_vs_temperature.png')
	plt.savefig(figure_name, dpi = 400)
	plt.close()

	print('Grafico fluctuación Magnetización')
	plt.figure()
	plt.plot(temperature, var_magnetization, 'o')
	plt.xlabel('Temperatura')
	plt.ylabel('Fluctuación Magnetización')
	figure_name = os.path.join(save_folder, 'var_M_vs_temperature.png')
	plt.savefig(figure_name, dpi = 400)
	plt.close()

	print('Grafico X susceptibilidad magnetica')
	plt.figure()
	plt.plot(temperature, x, 'o')
	plt.xlabel('Temperatura')
	plt.ylabel('X susceptibilidad magnética')
	figure_name = os.path.join(save_folder, 'x_vs_temperature.png')
	plt.savefig(figure_name, dpi = 400)
	plt.close()

	print('Grafico Neff')
	plt.figure()
	plt.plot(temperature, Neff, 'o')
	plt.xlabel('Temperatura')
	plt.ylabel('N aceptados/N total')
	figure_name = os.path.join(save_folder, 'Neff_temperature.png')
	plt.savefig(figure_name, dpi = 400)
	plt.close()
	return

def bragg_williams(Tc, betha):

	T = np.linspace(Tc/2, Tc, 100)
	M = (Tc-T)**(betha)

	return T, M


if __name__ == '__main__':

	#poner la dirección donde estan las Temperturas   .dat"
	parent_folder = 'C:/Users/Alumno/Dropbox/Simulaciones-master/Practica_Ising/Temperaturas/Campo_0'
	#parent_folder = '/home/agustin/Documents/Materia2/Practica_Ising/Temperaturas/Campo_nulo_40x40'

	parent_folder = os.path.normpath(parent_folder)
	print('carpeta', parent_folder)

	#recorre todos archivos que se llamen Temperatura y los guarda en csv
	#data = open_data(parent_folder)

	#crea una carpeta figuras_temperaturas donde guarda los graficos vs temperatura:
	plot_data(parent_folder)
