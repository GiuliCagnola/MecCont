function A = area_triangulo(p1, p2, p3)

  v1 = p2 - p1;
  v2 = p3 - p1;

  A = 0.5 * (v1(1) * v2(2) - v1(2) * v2(1));

endfunction
