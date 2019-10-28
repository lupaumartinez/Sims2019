module globals
implicit none
real(kind=8), allocatable :: m(:,:)
real(kind=8) :: temp, field
integer(kind=8) :: red, n_iteraciones
contains

subroutine lectura
    open(unit=20,file='configuracion_ini.dat',status='old')
    read(20,*)
    read(20,*) temp
    read(20,*)
    read(20,*) n_iteraciones
    read(20,*)
    read(20,*) red
    read(20,*)
    read(20,*) field
    close(20)
    
    allocate (m(0:red+1,0:red+1))
end subroutine
    
end module globals 
