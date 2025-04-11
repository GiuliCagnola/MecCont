#-----Función para calcular el instante en el que dos triángulos se intersectan

function ti = interseccion(t, Y, triangulos, tmax)

  n_tiempo = length(t);
  n_triangulos = size(triangulos, 1);
  A0 = zeros(n_triangulos, 1);

  #-----Calcular áreas iniciales
  for k = 1:n_triangulos
    ind = triangulos(k, :);
    coords = Y(1, [2*ind(1)-1, 2*ind(1), 2*ind(2)-1, 2*ind(2), 2*ind(3)-1, 2*ind(3)]);
    p = reshape(coords, 2, 3)';  # p = [x1 y1; x2 y2; x3 y3]
    A0(k) = area_triangulo(p(1,:), p(2,:), p(3,:));
  endfor

  #-----Detectar el cambio de signo del área
  for i = 1:n_tiempo
    for j = 1:n_triangulos
      ind = triangulos(j,:);
      coords = Y(i, [2*ind(1)-1, 2*ind(1), 2*ind(2)-1, 2*ind(2), 2*ind(3)-1, 2*ind(3)]);
      p =  reshape(coords, 2, 3)';
      A = area_triangulo(p(1,:), p(2,:), p(3,:));

      if A * A0(j) < 0
        ti = t(i);
        return;
      endif
    endfor
  endfor

  ti = tmax;

endfunction






