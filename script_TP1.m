#-----Tiempo
ti = 0;
tf = 50;

#-----Posiciones
l=5;
#X0=[x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7, x8, y8, x9, y9, x10, y10]
X0 = [0, 0, 2*l, 0, l, 2*l, 2*l, 2*l, 3*l, 2*l, 0, 3*l, 4*l, 3*l, l, 4*l, 3*l, 4*l, 2*l, 5*l];

#-----Velocidades
#V0 = [vx1, vy1, vx2, vy2, vx3, vy3, vx4, vy4, vx5, vy5, vx6, vy6, vx7, vy7, vx8, vy8, vx9, vy9, vx10, vy10]
V0 = zeros(1,20);

Y0=[X0, V0]; #posiciones y velocidades iniciales

#-----Resolver el sistema (ode23, ode45, ode15s)
#Y=[x1(t), y1(t), x2(t), y2(t), ... x10(t), y10(t), vx1(t), vy1(t), vx2(t), vy2(t), ... vx10(t), vy10(t)]
[t, Y] = ode23(@sistema_TP1, [ti tf], Y0);

#-----Graficar
figure(1)
hold on
grid on
plot(t, Y)
title("...")
xlabel("Tiempo t")
ylabel("Y")


#-----INCISO B.i-----
#-----Determinar el estado límite del sistema -> el área de los triángulos que forman los nodos cambia de signo

triangulos = [1 3 4; #T1
              2 4 5; #T2
              3 8 4; #T3
              4 8 9; #T4
              4 9 5; #T5
              8 10 9]; #T6

ti = interseccion([ti tf], Y, triangulos, tf);
