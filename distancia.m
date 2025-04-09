function L = distancia(X, C)

  #X -> Posiciones de los nodos
  #C -> Matriz de conectividad

  n = size(C, 1); #cantidad de barras
  L = zeros(n, 1);

  for k=1:n

    ni=C(k,1);
    nj=C(k,2);

    xi=X(2*ni-1);
    yi=X(2*ni);

    xj=X(2*nj-1);
    yj=X(2*nj);

    L(k)=sqrt((xj-xi)^2 + (yj-yi)^2); #distancia

  endfor

endfunction

