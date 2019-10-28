real(kind=8) function fza_interaction()

use verlet_positions

implicit none

real(kind=8):: rij_x, rij_y, rij_z, rij, eng_int, fza

integer:: a, b, c

rij_x = 0
rij_y = 0
rij_z = 0
rij = 0
eng_int = 0
fza = 0

do a = 1, N
      do b = 1, N
              rij_x = r(1, b) - r(1, a)
              rij_y = r(2, b) - r(2, a)
              rij_z = r(3, b) - r(3, a)
              rij = SQRT((rij_x**2 + rij_y**2 + rij_z**2))
              eng_int = 4*(-1/rij**6 + 1/rij**12)
              fza =  - eng_int/rij
              print *, 'fuerza ij', a, b, fza
      end do
end do

fza_interaction = fza

end function

