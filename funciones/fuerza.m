function F = fuerza(x_i0, x_j0, x_i, x_j, k, TipoDef)

  if (TipoDef == 1)  % Grandes deformaciones
    F = k * (norm(x_j - x_i) - norm(x_j0 - x_i0)) * ((x_j - x_i) / norm(x_j - x_i));

  elseif (TipoDef == 2)  % Pequeñas deformaciones
    F = k * ((norm(x_j - x_i) / norm(x_j0 - x_i0)) - 1) * (x_j0 - x_i0);

  else
    error("Método no reconocido. Usar 1 para grandes deformaciones o 2 para pequeñas deformaciones.");
  endif
endfunction
