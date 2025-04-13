#-----Condiciones iniciales-----

#-----Barra
rho=1; #Densidad
E=50; #Módulo de elasticidad longitudinal
A=2; #Área de sección transversal
W=[1.5 0]; #Carga uniforme con Wx=W, Wy=0
#Barra a=8 y nodo b=10

#-----Posiciones
l=5;
#X=[x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7, x8, y8, x9, y9, x10, y10]
X = [0, 0, 2*l, 0, l, 2*l, 2*l, 2*l, 3*l, 2*l, 0, 3*l, 4*l, 3*l, l, 4*l, 3*l, 4*l, 2*l, 5*l];

#-----Conectividades
C = [1 3; 3 4; 4 1; 4 2; 2 5; 5 4; 3 8; 8 9; 9 5; 8 4; 4 9; 8 10; 10 9; 9 7; 8 6];

#-----Resortes

#Calcular L (longitud) para cada barra
#L=[L0 L1 L2 L3 L4 L5 L6 L7 L8 L9 L10 L11 L12 L13 L14 L15]
L = distancia(X, C);

#K=[k1 k2 k3 k4 k5 k6 k7 k8 k9 k10 k11 k12 k13 k14 k15]
K=E*A./L;

#-----Masas
#M = [m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15]
M=rho*A.*L;


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
figure(1);
hold on;
grid on;
plot(t, Y);
title("...");
xlabel("Tiempo t");
ylabel("Y");


#-----Triangulación
triangulos = [1 3 4;  # T1
              2 4 5;  # T2
              3 8 4;  # T3
              4 8 9;  # T4
              4 9 5;  # T5
              8 10 9]; # T6

#-----Calcular áreas iniciales
n_triangulos = size(triangulos,1);
A0 = zeros(n_triangulos, 1);
for k = 1:n_triangulos
    ind = triangulos(k, :);
    coords = Y(1, [2*ind(1)-1, 2*ind(1), 2*ind(2)-1, 2*ind(2), 2*ind(3)-1, 2*ind(3)]);
    p = reshape(coords, 2, 3)';
    A0(k) = area_triangulo(p(1,:), p(2,:), p(3,:));
endfor

x_min = min(Y(:,1:2:end)(:)) - 5;
x_max = max(Y(:,1:2:end)(:)) + 5;
y_min = min(Y(:,2:2:end)(:)) - 5;
y_max = max(Y(:,2:2:end)(:)) + 5;

#-----Animación
figure(2);
for i = 1:5:length(t)
    clf;
    hold on;

    for k = 1:n_triangulos
        ind = triangulos(k,:);
        coords = Y(i, [2*ind(1)-1, 2*ind(1), 2*ind(2)-1, 2*ind(2), 2*ind(3)-1, 2*ind(3)]);
        p = reshape(coords, 2, 3)';
        A = area_triangulo(p(1,:), p(2,:), p(3,:));

        if A * A0(k) < 0
            c = [1 0 0]; # rojo
        else
            c = [0 1 0]; # verde
        endif

        fill(p(:,1), p(:,2), c, 'FaceAlpha', 0.6);
        text(mean(p(:,1)), mean(p(:,2)), num2str(k), 'FontSize', 10, 'Color', 'k');
    endfor

    title(sprintf('Tiempo: %.2f', t(i)));
    axis([x_min x_max y_min y_max]);
    axis equal;
    grid on;
    drawnow;
    pause(0.1);
endfor


#----------INCISO B.i----------
#-----Determinar el estado límite del sistema -> el área de los triángulos que forman los nodos cambia de signo

ti = interseccion(t, Y, triangulos, tf);


#----------INCISO B.ii----------
#gráfica de evolución de la tensión de la barra a y de la coordenada actual del nodo b

#-----Fuerza sobre la barra 8
n=length(t);
for i = 1:n
   F(i) = norm(fuerza(X0(15:16), X0(17:18),Y(i,15:16), Y(i,17:18), K(8)));
endfor

figure(3)
hold on
grid on
plot(t,F)
title("Fuerza sobre Barra 8")
xlabel("Tiempo (t)")
ylabel("Fuerza (F)")

#Dirección del vector tensión
X8 = [Y(n, 15), Y(n, 16)];
X9 = [Y(n, 17), Y(n, 18)];
dir_barra8 = X9 - X8; #vector dirección
u_barra8 = dir_barra8./norm(dir_barra8); #dirección normalizada


#-----Posición del nodo 10
figure(4)
hold on
grid on
#Trayectoria xy
subplot(3,1,1);
plot(Y(1:n, 19), Y(1:n, 20));
title("Trayectoria nodo 10 (X vs Y)")
xlabel("X");
ylabel("Y");
axis equal
grid on
#Posición en x
subplot(3,1,2);
plot(t,Y(1:n, 19));
title("Posicion X nodo 10")
xlabel("Tiempo (t)");
ylabel("Posición (x)");
#Posición en y
subplot(3,1,3);
plot(t,Y(1:n, 20));
title("Posicion Y nodo 10")
xlabel("Tiempo (t)");
ylabel("Posición (y)");
