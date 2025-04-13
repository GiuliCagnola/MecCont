#-----Sistema de ecuaciones diferenciales

#1) sum(F_1j) = F_13 + F_14 + R1 = m1*a1 = m1*dv1
#2) sum(F_2j) = F_24 + F_25 + W + R2 = m2*a2 = m2*dv2
#3) sum(F_3j) = F_31 + F_34 + F_38 = m3*a3 = m3*dv3
#4) sum(F_4j) = F_41 + F_42 + F_43 + F_45 + F_48 + F_49 = m4*a4 = m4*dv4
#5) sum(F_5j) = F_52 + F_54 + F_59 = m5*a5 = m5*dv5
#6) sum(F_6j) = F_68 = m6*a6 = m6*dv6
#7) sum(F_7j) = F_79 = m7*a7 = m7*dv7
#8) sum(F_8j) = F_83 + F_84 + F_86 + F_89 + F_810 = m8*a8 = m8*dv8
#9) sum(F_9j) = F_94 + F_95 + F_97 + F_98 + F_910 = m9*a9 = m9*dv9
#10) sum(F_10j) = F_108 + F_109 = m10*a10 = m10*dv10
#11) v1 = dx1
#12) v2 = dx2
#13) v3 = dx3
#14) v4 = dx4
#15) v5 = dx5
#16) v6 = dx6
#17) v7 = dx7
#18) v8 = dx8
#19) v9 = dx9
#20) v10 = dx10

function dy = sistema_TP1(t, Y)

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

#-----Masas de los resortes
#M = [mr1 mr2 mr3 mr4 mr5 mr6 mr7 mr8 mr9 mr10 mr11 mr12 mr13 mr14 mr15]
Mr=rho*A.*L;

#-----Masas de los nodos (mitad de las masas de las barras que llegan al nodo)
#Mn = [mn1 mn2 mn3 mn4 mn5 mn6 mn7 mn9 mn9 mn10]
Mn = zeros(10,1);
Mn(1) = (Mr(1) + Mr(3))/2;
Mn(2) = (Mr(4) + Mr(5))/2;
Mn(3) = (Mr(1) + Mr(2) + Mr(7))/2;
Mn(4) = (Mr(2) + Mr(3) + Mr(4) + Mr(6) + Mr(10) + Mr(11))/2;
Mn(5) = (Mr(5) + Mr(6) + Mr(9))/2;
Mn(6) = Mr(15)/2;
Mn(7) = Mr(14)/2;
Mn(8) = (Mr(7) + Mr(8) + Mr(10) + Mr(12) + Mr(15))/2;
Mn(9) = (Mr(8) + Mr(9) + Mr(11) + Mr(13) + Mr(14))/2;
Mn(10) = (Mr(12) + Mr(13))/2;


#-----Cálculo de fuerzas -> 3LN: Fij = -Fji
F_13 = fuerza(X(1:2), X(5:6), Y(1:2), Y(5:6), K(1));
F_14 = fuerza(X(1:2), X(7:8), Y(1:2), Y(7:8), K(3));
F_24 = fuerza(X(3:4), X(7:8), Y(3:4), Y(7:8), K(4));
F_25 = fuerza(X(3:4), X(9:10), Y(3:4), Y(9:10), K(5));
F_31 = -F_13;
F_34 = fuerza(X(5:6), X(7:8), Y(5:6), Y(7:8), K(2));
F_38 = fuerza(X(5:6), X(15:16), Y(5:6), Y(15:16), K(7));
F_41 = -F_14;
F_42 = -F_24;
F_43 = -F_34;
F_45 = fuerza(X(7:8), X(9:10), Y(7:8), Y(9:10), K(6));
F_48 = fuerza(X(7:8), X(15:16), Y(7:8), Y(15:16), K(10));
F_49 = fuerza(X(7:8), X(17:18), Y(7:8), Y(17:18), K(11));
F_52 = -F_25;
F_54 = -F_45;
F_59 = fuerza(X(9:10), X(17:18), Y(9:10), Y(17:18), K(9));
F_68 = fuerza(X(11:12), X(15:16), Y(11:12), Y(15:16), K(15));
F_79 = fuerza(X(13:14), X(17:18), Y(13:14), Y(17:18), K(14));
F_83 = -F_38;
F_84 = -F_48;
F_86 = -F_68;
F_89 = fuerza(X(15:16), X(17:18), Y(15:16), Y(17:18), K(8));
F_810 = fuerza(X(15:16), X(19:20), Y(15:16), Y(19:20), K(12));
F_94 = -F_49;
F_95 = -F_59;
F_97 = -F_79;
F_98 = -F_89;
F_910 = fuerza(X(17:18), X(19:20), Y(17:18), Y(19:20), K(13));
F_108 = -F_810;
F_109 = -F_910;

#-----Armado del sistema-----
dy = zeros(length(Y), 1);

#-----Posiciones
dy(1:2) = [0, 0]; #pos nodo1  fijo (x1_i = x1_f, y1_i = y1_f)
dy(3) = (F_24(1) + F_25(1) + W(1))/Mn(2); #pos nodo2 movil en X
dy(4) = 0; #pos nodo2 fijo en Y (y2_i = y2_f)
dy(5:6) = (F_31 + F_34 + F_38)/Mn(3); #pos nodo3
dy(7:8) = (F_41 + F_42 + F_43 + F_45 + F_48 + F_49)/Mn(4); #pos nodo4
dy(9:10) = (F_52 + F_54 + F_59)/Mn(5); #pos nodo5
dy(11:12) = F_68/Mn(6); #pos nodo6
dy(13:14) = F_79/Mn(7); #pos nodo7
dy(15:16) = (F_83 + F_84 + F_86 + F_89 + F_810)/Mn(8); #pos nodo8
dy(17:18) = (F_94 + F_95 + F_97 + F_98 + F_910)/Mn(9); #pos nodo9
dy(19:20) = (F_108 + F_109)/Mn(10); #pos nodo10

#-----Velocidades
dy(21:40) = Y(21:40); #v=dx
