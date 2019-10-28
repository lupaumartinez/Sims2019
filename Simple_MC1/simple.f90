program simple 
    use ziggurat
    implicit none
    logical :: es
    integer :: seed, N, i ,j,k
    real ::  x, y


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

! Ej: Número random en [0,1]: uni()


!! 
!! EDITAR AQUI

!!FUNCTION prob() result (Pr)
!!	REAL :: Pr, val
!!	Pr = (val-1)**2
!!	RETURN
!!END FUNCTION prob

	open(1, file = 'input.dat', status = 'old')
	read(1, *) N
	close(1)


	open(2, file = 'X.dat', status = 'old')
	do i = 1, N
		x = 2*uni()
		y = uni()
        	print*, x, y
		if (prob(x) > y) then
			write(2, *) x
		end if
	end do
	close(2)

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
