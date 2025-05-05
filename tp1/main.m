addpath('../funciones');
clear all;
close all;


#-----Posiciones------#
l=5;
X = [0, 0, 2*l, 0, l, 2*l, 2*l, 2*l, 3*l, 2*l, 0, 3*l, 4*l, 3*l, l, 4*l, 3*l, 4*l, 2*l, 5*l];
X0 = X; # [x1, y1, x2, y2, ... , x10, y10] posiciones iniciales
#---------------------#


#-----Velocidades ------#
V0 = zeros(1,20); #[vx1, vy1, vx2, vy2, ... , vx10, vy10]
#-----------------------#


#-----Conectividades------#
C = [1 3; 3 4; 1 4; 4 2; 2 5; 5 4; 3 8; 8 9; 9 5; 8 4; 4 9; 8 10; 10 9; 9 7; 8 6];
#-------------------------#


#----------Barra----------#
rho=1; #Densidad
E=50; #Módulo de elasticidad longitudinal
A=2; #Área de sección transversal
W=[1.5 0]; #Carga uniforme con Wx=W, Wy=0

#Barra a=8 y nodo b=10

# Calcular L (longitud) para cada barra
L = distancia(X, C); #L=[L0 L1 ... L15]



# Constantes elásticas de las barras
K=E*A./L; #K=[k1 k2 ... k15] 
#---------------------------#


#-----Masas-------#
# Calculo de masas de cada barra
Mr = rho*A.*L; #[m1 m2 ... m15]

#Masas de los nodos (mitad de las masas de las barras que llegan al nodo)

Mn = masas_nodos(C, Mr, length(X)/2); #Mn = [mn1 mn2 ... mn10]

#---------------------------#

#----------Tiempo----------#
ti = 0;
tf = 50;
#---------------------------#
Y0=[X0, V0]; #posiciones y velocidades iniciales

# empaquetar las condiciones iniciales para pasarlas a la función del sistema
CI.X0 = X0;
CI.C = C;
CI.L = L;
CI.K = K;
CI.W = W;
CI.Mn = Mn;
CI.TipoDef = 1; # 1: grandes deformaciones, 2: pequeñas deformaciones

#-----Resolver el sistema (ode23, ode45, ode15s)
#Y=[x1(t), y1(t), x2(t), y2(t), ... x10(t), y10(t), vx1(t), vy1(t), vx2(t), vy2(t), ... vx10(t), vy10(t)]
[t, Y] = ode23(@(t, Y) sistema_TP1(t, Y, CI), [ti tf], Y0);

n=length(t);

#-----Graficar
figure(1);
hold on;
grid on;
for i = 1:2:20
  nodo = (i+1)/2;
  x = Y(:,i);
  y = Y(:,i+1);
  pos = sqrt(x.^2 + y.^2);  
  plot(t, pos, 'DisplayName', sprintf("Nodo %d", nodo));
endfor

xlabel("Tiempo (t)");
ylabel("Posición");
title("Posición (x,y) vs t");
legend show;


#-----Triangulación
triangulos = [1 3 4;  # T1
              2 4 5;  # T2
              3 8 4;  # T3
              4 8 9;  # T4
              4 9 5;  # T5
              8 10 9  # T6
              ];
              
sueltos = [6 8;
           7 9];

#-----Calcular áreas iniciales
n_triangulos = size(triangulos,1);
A0 = zeros(n_triangulos, 1);
for k = 1:n_triangulos
    ind = triangulos(k, :);
    coords = Y(1, [2*ind(1)-1, 2*ind(1), 2*ind(2)-1, 2*ind(2), 2*ind(3)-1, 2*ind(3)]);
    p = reshape(coords, 2, 3)';
    A0(k) = signo_area_triangulo(p(1,:), p(2,:), p(3,:));
    A0(k) = signo_area_triangulo(p(1,:), p(2,:), p(3,:));
endfor

x_min = -10;
x_max = 40;
y_min = 0;
y_max = 40;

#-----Animación
out_dir = 'output_images';  % En este directorio se guardaran las imagenes de la animacion
mkdir(out_dir);  % Esto lo crea si no existe

figure(2)
axis([x_min x_max y_min y_max])
hold on; grid on;
title('Movimiento del reticulado')
xlabel('Posición (x)');
ylabel('Posición (y)');
n_nodos = size(Y, 2) / 2;

h = [];
A0 = zeros(size(triangulos,1), 1);

# Inicializar Triangulos
for k = 1:size(triangulos, 1)
  n1 = triangulos(k,1); n2 = triangulos(k,2); n3 = triangulos(k,3);
  p1 = Y(1, [2*n1-1, 2*n1]);
  p2 = Y(1, [2*n2-1, 2*n2]);
  p3 = Y(1, [2*n3-1, 2*n3]);
  A0(k) = 0.5 * det([p2 - p1; p3 - p1]);
  h(end+1) = fill([p1(1), p2(1), p3(1)], [p1(2), p2(2), p3(2)], 'g');
endfor

# Inicializar los no Triangulos
h_sueltos = [];
for k = 1:size(sueltos, 1)
  n1 = sueltos(k, 1); n2 = sueltos(k, 2);
  p1 = Y(1, [2*n1-1, 2*n1]);
  p2 = Y(1, [2*n2-1, 2*n2]);
  h_sueltos(end+1) = plot([p1(1), p2(1)], [p1(2), p2(2)], 'k', 'LineWidth', 1);
endfor


# Actualizar
for i = 1:n
  pause(0.01);

  # Triangulos
  for k = 1:size(triangulos, 1)
    n1 = triangulos(k,1); n2 = triangulos(k,2); n3 = triangulos(k,3);
    p1 = Y(i, [2*n1-1, 2*n1]);
    p2 = Y(i, [2*n2-1, 2*n2]);
    p3 = Y(i, [2*n3-1, 2*n3]);
    A = 0.5 * det([p2 - p1; p3 - p1]);
    c = (A * A0(k) < 0) * [1 0 0] + (A * A0(k) >= 0) * [0 1 0];
    set(h(k), 'xdata', [p1(1), p2(1), p3(1)],
          'ydata', [p1(2), p2(2), p3(2)],
          'facecolor', c,
          'FaceAlpha', 0.6
          );
  endfor
  
  % Sueltos
  for k = 1:size(sueltos, 1)
    n1 = sueltos(k, 1); n2 = sueltos(k, 2);
    p1 = Y(i, [2*n1-1, 2*n1]);
    p2 = Y(i, [2*n2-1, 2*n2]);
    set(h_sueltos(k), 'xdata', [p1(1), p2(1)],
                      'ydata', [p1(2), p2(2)]);
  endfor
  title(sprintf('Tiempo: %.2f', t(i)));

  # Guardar el cuadro actual como imagen
  fname = fullfile(out_dir, sprintf("img%03i.png", i));
  imwrite(getframe(gcf).cdata, fname);
endfor


palette_file = fullfile(out_dir, "palette.png");

# Generate palette
cmd_palette = sprintf("ffmpeg -i %s/img%%03d.png -vf palettegen %s", out_dir, palette_file);
system(cmd_palette);

# Crear el gif usando ffmpeg (tienen que instalarlo usando sudo apt-get install ffmpeg)
if exist(out_dir, 'dir') && exist(palette_file, 'file')
  cmd = sprintf("ffmpeg -framerate 30 -i %s/img%%03d.png -i %s -lavfi paletteuse tp1.gif", out_dir, palette_file);
  system(cmd);
else
  error("Output directory or palette file does not exist. Ensure images and palette are generated correctly.");
end
system(cmd);


#----------INCISO B.i----------
#-----Determinar el estado límite del sistema -> el área de los triángulos que forman los nodos cambia de signo

ti = interseccion(t, Y, triangulos, tf);


#----------INCISO B.ii----------
#gráfica de evolución de la tensión de la barra a y de la coordenada actual del nodo b

#-----Fuerza sobre la barra 8
for i = 1:n
   F(i) = norm(fuerza(X0(15:16), X0(17:18),Y(i,35:36), Y(i,37:38), K(8), CI.TipoDef));
endfor

[Fmax, imax] = max(F); #Fuerza máxima
t_Fmax = t(imax);
[Fmin, imin] = min(F); #Fuerza mínima
t_Fmin = t(imin);

figure(3)
hold on
grid on
plot(t,F)
title("Fuerza sobre Barra 8")
xlabel("Tiempo (t)")
ylabel("Fuerza (F)")

#Dirección del vector tensión
X8 = [Y(n, 35), Y(n, 36)];
X9 = [Y(n, 37), Y(n, 38)];
X8 = [Y(n, 35), Y(n, 36)];
X9 = [Y(n, 37), Y(n, 38)];
dir_barra8 = X9 - X8; #vector dirección
u_barra8 = dir_barra8./norm(dir_barra8); #dirección normalizada

#En grandes deformaciones, el vector de tensión sigue la dirección de la fuerza de las barras
#En pequeñas deformaciones, sigue la dirección de la configuración de referenci



#-----Posición del nodo 10
figure(4)
hold on
grid on
#Trayectoria xy
subplot(3,1,1);
plot(Y(1:n, 39), Y(1:n, 40));
plot(Y(1:n, 39), Y(1:n, 40));
title("Trayectoria nodo 10 (X vs Y)")
xlabel("X");
ylabel("Y");
axis equal
grid on
#Posición en x
subplot(3,1,2);
plot(t,Y(1:n, 39));
plot(t,Y(1:n, 39));
title("Posicion X nodo 10")
xlabel("Tiempo (t)");
ylabel("Posición (x)");
#Posición en y
subplot(3,1,3);
plot(t,Y(1:n, 40));
plot(t,Y(1:n, 40));
title("Posicion Y nodo 10")
xlabel("Tiempo (t)");
ylabel("Posición (y)");

#----------INCISO B.iii----------
#Norma del vector desplazamiento máximo y en que instante se produce

n_pos=length(Y0)/2; #tomo las posiciones
for i=1:n_pos
  delta(:,i) = abs(Y(:,i+20) - Y0(i));
endfor

#mag_delta es una matriz donde las filas son los valores de t y las columnas son los nodos
mag_delta = zeros(length(t), 10);
mag_delta(:,1)=0; #x1 fijo
mag_delta(:,2)=0; #y1 fijo
mag_delta(:,3)=delta(:,3); #delta(x2)
mag_delta(:,4)=0; #y2 fijo
cant=1;
for i=5:2:n_pos-1
  cant=cant+1;
  for j=1:length(delta(:,i))
    mag_delta(j, cant)=norm([delta(j,i), delta(j,i+1)]);
  endfor
endfor

[delta_max ind] = max(mag_delta(:)); #máximo global
[fila nodo] = ind2sub(size(mag_delta), ind); #convierte el indice en coords de la matriz
tmax=t(fila);

#GD
#delta_max = 27.452
#tmax = 48.823
#nodo 9

#PD
#delta_max = 1.3261e+10
#tmax = 50
#nodo 5

