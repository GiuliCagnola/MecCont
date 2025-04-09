#GUIA 1
#EJERCICIO 6
#--------------------

#-----Sistema de ecuaciones diferenciales

#1) sum(F_1j) = F_13 + R1 = m1*a1 = m1*dv1
#2) sum(F_2j) = F_23 + F_24 + R2 = m2*a2 = m2*dv2
#3) sum(F_3j) = F_31 + F_32 + F_34 + F35 = m3*a3 = m3*dv3
#4) sum(F_4j) = F_42 + F_43 + F_45 + F_46 = m4*a4 = m4*dv4
#5) sum(F_5j) = F_53 + F_54 + F_56 + F_57 = m5*a5 = m5*dv5
#6) sum(F_6j) = F_64 + F_65 + F_67 = m6*a6 = m6*dv6
#7) sum(F_7j) = F_57 + F_67 + W = m7*a7 = m7*dv7
#8) v1 = dx1
#9) v2 = dx2
#10) v3 = dx3
#11) v4 = dx4
#12) v5 = dx5
#13) v6 = dx6
#14) v7 = dx7


  function dy = sistema_G1E6(t, Y)

  #t = intervalo de tiempo
  #Y = posición y velocidad de los nodos en el tiempo t
  #Y = [x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7,
  #    vx1, vy1, vx2, vy2, vx3, vy3, vx4, vy4, vx5, vy5, vx6, vy6, vx7, vy7]
  #Y(1:14) -> posiciones
  #Y(15:28) -> velocidades

  #-----Condiciones iniciales

  #Posiciones
  L=5;
  #X = [x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7]
  X = [0, 0, 0, L, L, 0, L, L, 2*L, 0, 2*L, L, 3*L, 0];

  #Resortes
  k=20;

  #Masas
  m=0.5;

  #Carga uniforme
  W = [0,5]; #Wx=0, Wy=W

  #Carga variable
  f=5; #frecuencia
  #W=[0, sin(f*t)];

  #-----Cálculo de fuerzas -> 3LN: Fij = -Fji
  F_13 = fuerza(X(1:2), X(5:6), Y(1:2), Y(5:6), k);
  F_23 = fuerza(X(3:4), X(5:6), Y(3:4), Y(5:6), k);
  F_24 = fuerza(X(3:4), X(7:8), Y(3:4), Y(7:8), k);
  F_31 = -F_13;
  F_32 = -F_23;
  F_34 = fuerza(X(5:6), X(7:8), Y(5:6), Y(7:8), k);
  F_35 = fuerza(X(5:6), X(9:10), Y(5:6), Y(9:10), k);
  F_42 = -F_24;
  F_43 = -F_34;
  F_45 = fuerza(X(7:8), X(9:10), Y(7:8), Y(9:10), k);
  F_46 = fuerza(X(7:8), X(11:12), Y(7:8), Y(11:12), k);
  F_53 = -F_35;
  F_54 = -F_45;
  F_56 = fuerza(X(9:10), X(11:12), Y(9:10), Y(11:12), k);
  F_57 = fuerza(X(9:10), X(13:14), Y(9:10), Y(13:14), k);
  F_64 = -F_46;
  F_65 = -F_56;
  F_67 = fuerza(X(11:12), X(13:14), Y(11:12), Y(13:14), k);
  F_75 = -F_57;
  F_76 = -F_67;

  #-----Armado del sistema
  dy = zeros(length(Y), 1);

  #Velocidades
  dy(1:14) = Y(15:28);

  #Posiciones
  dy(15:16) = [0, 0] ; #nodo1  fijo (x1_i = x1_f, y1_i = y1_f)
  dy(17:18) = [0, 0]; #nodo2 fijo (x2_i = x2_f, y2_i = y2_f)
  dy(19:20) = (F_31 + F_32 + F_34 + F_35)/m; #pos nodo3
  dy(21:22) = (F_42 + F_43 + F_45 + F_46)/m; #pos nodo4
  dy(23:24) = (F_53 + F_54 + F_56 + F_57)/m; #pos nodo5
  dy(25:26) = (F_64 + F_65 + F_67)/m; #pos nodo6
  dy(27:28) = (F_75 + F_67 + W)/m; #pos nodo7














