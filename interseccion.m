#-----Función para calcular el instante en el que dos triángulos se intersectan

#triangulos = [1 3 4; T1
#              2 4 5; T2
#              3 8 4; T3
#              4 8 9; T4
#              4 9 5; T5
#              8 10 9] T6

function ti = interseccion(t, Y, triangulos, tmax)

  n_tiempo = length(t);
  n_triangulos = size(triangulos, 1);
  A0 = zeros(n_triangulos, 1);

  #-----Calcular áreas iniciales
  for k=1:n_triangulos

    ind = triangulos(k, :);
    coords = Y(1, [2*ind(1)-1, 2*ind(1), 2*ind(2)-1, 2*ind(2), 2*ind(3)-1, 2*ind(3)]);
    p = reshape(coords, 2, 3)'; #p=[x_k y_k; x_k+1 y_k+1; x_k+2 y_k+2]
    A0(k)=area_triangulo(p(1,:), p(2,:), p(3,:));
  endfor

  #-----Detectar el cambio de signo del área
  for i=1:n_tiempo
    for j=1:n_triangulos

      ind = triangulos(j,:);
      coords = Y(i, 2:ind-1:2*ind);
      p =  reshape(coords, 2, 3)';
      A = area_triangulo(p(1,:), p(2,:), p(3,:));

      if A*A0(j)<0
        ti = t(i);
        return;
      endif
    endfor
  endfor

  ti=tmax;

endfunction







