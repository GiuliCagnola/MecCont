function F = fuerza(xi_0, xj_0, xi, xj, k)

  #(xi_0, xj_0) = posición inicial
  #(xi, xj) = posición final (después de la deformación)
  #k = constante elástica del resorte
  #F = [Fx, Fy] -> fuerza resultante

  L0 = sqrt((xj_0(1) - xi_0(1))^2 + (xj_0(2) - xi_0(2))^2);
  L = sqrt((xj(1) - xi(1))^2 + (xj(2) - xi(2))^2);
  Fesc = k*(1-L0/L);
  F(1) = Fesc*(xj(1) - xi(1)); #Fx
  F(2) = Fesc*(xj(2) - xi(2)); #Fy
