#GUIA 1
#EJERCICIO 6
#--------------------

#-----Valores
ti = 0;
tf = 50;
L=5;
k=20;


#-----Posiciones
#Los nodos 1 y 2 son fijos
#X0 = [x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7]
X0 = [0, 0, 0, L, L, 0, L, L, 2*L, 0, 2*L, L, 3*L, 0];

#-----Velocidades
#V0 = [vx1, vy1, vx2, vy2, vx3, vy3, vx4, vy4, vx5, vy5, vx6, vy6, vx7, vy7]
V0 = zeros(1,14);

Y0=[X0, V0]; #posiciones y velocidades

#-----Resolver el sistema (ode23, ode45, ode15s)
[t, Y] = ode23(@sistema_G1E6, [ti tf], Y0);


#-----Fuerza en la barra 2-3
for i=1:size(Y,1)
  F(i)=norm(fuerza(X0(3:4), X0(5:6), Y(i, 3:4), Y(i, 5:6), k));
endfor

figure(1)
hold on
grid on
plot(t, F)
title("Fuerza en la barra 2-3")
xlabel("Tiempo t")
ylabel("Fuerza F")





