program simple 
    use ziggurat
    use globals
    implicit none
    logical :: es,inp
    integer :: seed,i ,j,k
    integer(kind=8) :: l,c,step, l_aux, c_aux, m_aux, n_fav, n_tot
    real(kind=8) ::  x_aux, eng_cal, energy, energy_aux, delta_e,mag
    real(kind=8) :: energy_ac, energy_ac2, mag_ac, mag_ac2, energy_med, energy2_med, var_energy
    real(kind=8) :: mag_med, mag2_med, var_mag, cv, susc
![NO TOCAR] Inicializa generador de número random

    inquire(file='seed.dat',exist=es)
    if(es) then
        open(unit=10,file='seed.dat',status='old')
        read(10,*) seed
        close(10)
!        print *,"  * Leyendo semilla de archivo seed.dat"
    else
        seed = 24583490
    end if

    call zigset(seed)
![FIN NO TOCAR]    

!Defino los valores iniciales de los contadores y acumuladores
    energy = 0
    mag = 0
    energy_ac = 0
    energy_ac2 = 0
    mag_ac = 0
    mag_ac2 = 0
    n_fav = 0
    n_tot = 0
    call lectura
    m = 0
!Armo la configuracion la matriz al azar si es que no existe el archivo imput.dat
    
    inquire(file='input.dat', exist=inp)   !Reviso si existe un input.dat para dar la condicion inicial de la red
    if (inp) then
        open(unit=20,file='input.dat',status='old') ! Si existe lo abro para asignar los valores de la red, el archivo de entrada
        do c = 1, red                                !debe tener la informacion por columnas
            do l = 1, red
                read(20,*) m(l,c) ! Recorro las columnas y las filas 
                mag = mag + m(l,c)
            end do
        end do
        close(20)

    else ! Si no existe genero una matriz aleatoria definiendo cada valor individualmente
        do c = 1, red
            do l = 1, red
                x_aux = uni()
                if (x_aux .lt. 0.5) then  ! Si el numero aleatorio es menor que 0.5 entonces tengo un -1, en caso contrario 1
                    m(l,c) = -1
                    mag = mag - 1
                else
                    m(l,c) = 1
                    mag = mag + 1
                end if
            end do
        end do
    end if
    m(0,1:red) = m (red,1:red)  !Defino las condiciones periodicas de contorno
    m(red+1,1:red) = m (1,1:red)
    m(1:red,0) = m(1:red,red)
    m(1:red,red+1) = m(1:red,1)   
    

! Calculo el valor inicial de la energia
    energy = eng_cal()
!    energy_ac = energy_ac + energy
!    energy_ac2 = energy_ac2 + energy**2
!    mag_ac = mag_ac + mag
!    mag_ac2= mag_ac2 + mag**2 

! Procedo a invertir un spin al azar y calcula la nueva energia del sistema

!    open(unit=35,file='salida.dat',status='unknown')
!    write(35,*) 'Energy,Magnetization'    
    do step= 1, n_iteraciones
        l_aux = ceiling(uni()*red)  ! Defino un l y un c al azar para invertir el spin
        c_aux = ceiling(uni()*red)
        ! Calculo el delta de energia al cambiar la orientacion del spin
        delta_e = 2*m(l_aux,c_aux)*(m(l_aux-1,c_aux)+m(l_aux,c_aux+1)+m(l_aux+1,c_aux)+m(l_aux,c_aux-1)) + 2*m(l_aux,c_aux)*field 
        if (mod(step,1000) .eq. 0) then
            if ( delta_e .le. 0) then ! Si la variacion es menor a cero  se acepta el cambio
                energy = energy + delta_e  ! Calculo la nueva energia
                m(l_aux,c_aux) = -1.0*m(l_aux,c_aux) ! Cambio la orientacion del spin
                mag = mag + 2*m(l_aux,c_aux) ! Calculo la nueva magnetizacion
                m(0,1:red) = m (red,1:red)  !Defino las condiciones periodicas de contorno A LO BOBO
                m(red+1,1:red) = m (1,1:red)
                m(1:red,0) = m(1:red,red)
                m(1:red,red+1) = m(1:red,1)   
                n_fav = n_fav + 1  ! Sumo uno si el caso fue favorable
            else if (exp(-1.0*delta_e/temp) .gt. uni()) then ! Si la variacion es tal que cumpla con la cond
                energy = energy + delta_e   ! Mismo que en el caso anterior
                m(l_aux,c_aux) = -1.0*m(l_aux,c_aux)
                mag = mag + 2*m(l_aux,c_aux)
                m(0,1:red) = m (red,1:red)  !Defino las condiciones periodicas de contorno
                m(red+1,1:red) = m (1,1:red)
                m(1:red,0) = m(1:red,red)
                m(1:red,red+1) = m(1:red,1)   
                n_fav = n_fav + 1
            end if
            ! Despues del paso de MC actualizo los acumuladores
            energy_ac = energy_ac + energy
            energy_ac2 = energy_ac2 + energy**2
            mag_ac = mag_ac + mag
            mag_ac2 =  mag_ac2 + mag**2 
            n_tot = n_tot + 1
!            write(35,*) energy,' , ', mag/(red**2)
        else
            if ( delta_e .le. 0) then ! Si la variacion es menor a cero  se acepta el cambio
                energy = energy + delta_e  ! Calculo la nueva energia
                m(l_aux,c_aux) = -1.0*m(l_aux,c_aux) ! Cambio la orientacion del spin
                mag = mag + 2*m(l_aux,c_aux) ! Calculo la nueva magnetizacion
                m(0,1:red) = m (red,1:red)  !Defino las condiciones periodicas de contorno
                m(red+1,1:red) = m (1,1:red)
                m(1:red,0) = m(1:red,red)
                m(1:red,red+1) = m(1:red,1)   
            else if (exp(-1.0*delta_e/temp) .gt. uni()) then ! Si la variacion es tal que cumpla con la cond
                energy = energy + delta_e   ! Mismo que en el caso anterior
                m(l_aux,c_aux) = -1.0*m(l_aux,c_aux)
                mag = mag + 2*m(l_aux,c_aux)
                m(0,1:red) = m (red,1:red)  !Defino las condiciones periodicas de contorno
                m(red+1,1:red) = m (1,1:red)
                m(1:red,0) = m(1:red,red)
                m(1:red,red+1) = m(1:red,1)   
            end if 
        end if
    end do
!   close(35)
    

    
    energy_med = energy_ac/n_tot
    energy2_med = energy_ac2/n_tot
    var_energy = sqrt(energy2_med-energy_med**2)
    cv = var_energy**2/(temp**2*red**2)
    mag_med = mag_ac/n_tot
    mag2_med = mag_ac2/n_tot
    var_mag = sqrt(mag2_med-mag_med**2)
    susc = var_mag**2/temp


    open(unit=21,file='variables_fisicas.dat',status='unknown')
    write(21,*) 'Energy_med,Energy2_med,var_energy,Cv,Magnetization_med,Magnetization2_med,var_magnetization,X,N_tot,N_fav'
    write(21,*) energy_med,',',energy2_med,',',var_energy,',',cv,',',mag_med,',',mag2_med,',',var_mag,',',susc,',',n_tot,',',n_fav
    close(21)
    ! Guardo la configuracion de salida de la red para futuras corridas 
    open(unit=20,file='input.dat',status='unknown')
    do c = 1, red
        do l = 1,red
            write(20,*) m(l,c)
        end do
    end do
    close(20)






!! EDITAR AQUI 
!! 


!! 
!! FIN FIN edicion
!! 
![No TOCAR]
! Escribir la última semilla para continuar con la cadena de numeros aleatorios 

        open(unit=10,file='seed.dat',status='unknown')
        seed = shr3() 
        write(10,*) seed
        close(10)
![FIN no Tocar]        


end program simple
