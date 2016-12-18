function [amplio,matriz]=modificamos(matriz, texto, ini_filas, col)
%Pasamos el texto a bits
[amplio, texto_bit] = textobit_col(texto, col);

%Una vez tenemos eso, recorremos la matriz con la matriz de texto_bit y
%vamos modificando
ini_filas = ini_filas-1;
[rows, col]=size(texto_bit);
for i=1:rows
   for j=1:col
       if texto_bit(i,j) == '1'
          %Sumamos 1 a la matriz
          aux = i + ini_filas;
          if mod(matriz(aux,j),2) == 0
            matriz(aux, j) = matriz(aux, j) +1;
          end
       else
           aux = i + ini_filas;
           if mod(matriz(aux, j), 2) ~=0
               matriz(aux, j) = matriz(aux, j) -1;
           end
       end
   end
end