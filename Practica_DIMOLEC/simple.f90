program simple 
    use ziggurat
    use verlet_positions
    implicit none
    logical :: es, inp
    integer :: seed,i ,j,k
    integer(kind=8) :: a, b, c
    real(kind=8) :: fza_int, fza_interaction

![NO TOCAR] Inicializa generador de número random

    inquire(file='seed.dat',exist=es)
    if(es) then
        open(unit=10,file='seed.dat',status='old')
        read(10,*) seed
        close(10)
        print *,"  * Leyendo semilla de archivo seed.dat"
    else
        seed = 24583490
    end if

    call zigset(seed)
![FIN NO TOCAR]    

!! 
!! EDITAR AQUI 
!!

      call lectura
      r = 0
      v = 0
      f = 0
      fza_int = 0

!!Armo la configuración inicial de las posiciones  al azar si es que no existe el archivo input.dat

    inquire(file='input.dat', exist=inp) !Si existe lo abro para asignar los valores de las posiciones, tiene que estar la informacion en columnas
    if (inp) then
       open(unit = 20, file = 'input.dat', status = 'old')
       read(20, *) r(3, N)
       close(20)

    else ! Si no existe el archivo, genero unas posiciones aleatorias para las N posiciones
       do a = 1, N
          r(1, a)  = L*uni()
          r(2, a)  = L*uni()
          r(3, a)  = L*uni()
          fza_int = fza_interaction()
          print *, "Posicion de particula", a, r(1, a), r(2, a), r(3, a), fza_int
       end do
   end if   



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
