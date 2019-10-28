real(kind=8) function  eng_cal()
use globals
implicit none
real(kind=8) :: eng_aux
integer :: c_aux, l_aux
eng_aux = 0
do c_aux = 1, red
    do l_aux = 1, red
        eng_aux = eng_aux-0.5*m(l_aux,c_aux)*(m(l_aux-1,c_aux)+m(l_aux,c_aux+1)+m(l_aux+1,c_aux)+m(l_aux,c_aux-1)+2*field)
   end do
end do
eng_cal= eng_aux

end function

