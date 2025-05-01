function Mn = masas_nodos(C, Mr, n_nodos)
    Mn = zeros(n_nodos, 1);
    for i = 1:size(C, 1)
      n1 = C(i, 1);
      n2 = C(i, 2);
      Mn(n1) += Mr(i) / 2;
      Mn(n2) += Mr(i) / 2;
    end
  endfunction
  