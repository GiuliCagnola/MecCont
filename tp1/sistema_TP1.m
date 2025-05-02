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

function dy = sistema_TP1(t, Y, CI)
#-----Condiciones iniciales-----
X0 = CI.X0;
C = CI.C;
L = CI.L;
Mn = CI.Mn;
K = CI.K;
W = CI.W;
TipoDef = CI.TipoDef; # 1: grandes deformaciones, 2: pequeñas deformaciones
X = X0;


#-----Cálculo de fuerzas -> 3LN: Fij = -Fji
F_13 = fuerza(X(1:2), X(5:6), Y(1:2), Y(5:6), K(1),TipoDef);
F_14 = fuerza(X(1:2), X(7:8), Y(1:2), Y(7:8), K(3),TipoDef);
F_24 = fuerza(X(3:4), X(7:8), Y(3:4), Y(7:8), K(4),TipoDef);
F_25 = fuerza(X(3:4), X(9:10), Y(3:4), Y(9:10), K(5),TipoDef);
F_31 = -F_13;
F_34 = fuerza(X(5:6), X(7:8), Y(5:6), Y(7:8), K(2),TipoDef);
F_38 = fuerza(X(5:6), X(15:16), Y(5:6), Y(15:16), K(7),TipoDef);
F_41 = -F_14;
F_42 = -F_24;
F_43 = -F_34;
F_45 = fuerza(X(7:8), X(9:10), Y(7:8), Y(9:10), K(6),TipoDef);
F_48 = fuerza(X(7:8), X(15:16), Y(7:8), Y(15:16), K(10),TipoDef);
F_48 = fuerza(X(7:8), X(15:16), Y(7:8), Y(15:16), K(10),TipoDef);
F_49 = fuerza(X(7:8), X(17:18), Y(7:8), Y(17:18), K(11),TipoDef);
F_52 = -F_25;
F_54 = -F_45;
F_59 = fuerza(X(9:10), X(17:18), Y(9:10), Y(17:18), K(9),TipoDef);
F_68 = fuerza(X(11:12), X(15:16), Y(11:12), Y(15:16), K(15),TipoDef);
F_79 = fuerza(X(13:14), X(17:18), Y(13:14), Y(17:18), K(14),TipoDef);
F_79 = fuerza(X(13:14), X(17:18), Y(13:14), Y(17:18), K(14),TipoDef);
F_83 = -F_38;
F_84 = -F_48;
F_86 = -F_68;
F_89 = fuerza(X(15:16), X(17:18), Y(15:16), Y(17:18), K(8),TipoDef);
F_810 = fuerza(X(15:16), X(19:20), Y(15:16), Y(19:20), K(12),TipoDef);
F_94 = -F_49;
F_95 = -F_59;
F_97 = -F_79;
F_98 = -F_89;
F_910 = fuerza(X(17:18), X(19:20), Y(17:18), Y(19:20), K(13),TipoDef);
F_108 = -F_810;
F_109 = -F_910;

#-----Armado del sistema-----
dy = zeros(length(Y), 1);

#-----Velocidades
dy(1:20) = Y(21:40); #v=dx

#-----Posiciones
dy(21:22) = [0, 0]; #pos nodo1  fijo (x1_i = x1_f, y1_i = y1_f)
dy(23) = (F_24(1) + F_25(1) + W(1))/Mn(2); #pos nodo2 movil en x
dy(24) = 0; #pos nodo2 fijo en Y (y2_i = y2_f)
dy(25:26) = (F_31 + F_34 + F_38)/Mn(3); #pos nodo3
dy(27:28) = (F_41 + F_42 + F_43 + F_45 + F_48 + F_49)/Mn(4); #pos nodo4
dy(29:30) = (F_52 + F_54 + F_59)/Mn(5); #pos nodo5
dy(31:32) = F_68/Mn(6); #pos nodo6
dy(33:34) = F_79/Mn(7); #pos nodo7
dy(35:36) = (F_83 + F_84 + F_86 + F_89 + F_810)/Mn(8); #pos nodo8
dy(37:38) = (F_94 + F_95 + F_97 + F_98 + F_910)/Mn(9); #pos nodo9
dy(39:40) = (F_108 + F_109)/Mn(10); #pos nodo10
dy(1:20) = Y(21:40); #v=dx