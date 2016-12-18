function [amplio, matriz_cob_modi]=modificamos_img(matrizCob, matriz, ini_fila)
[rows, cols] = size(matriz);
[r, c] = size(matrizCob);
tama1 = rows * cols*8;
tama2 = r * c;
amplio=0;
if tama1 > tama2
    disp('La matriz debe ser menor que la matriz de cobertura');
else
    [amplio, matriz_bit]=matrizbit_col(matriz, size(matrizCob,2));
    ini_fila=ini_fila-1;
    for i=1:size(matriz_bit,1)
        for j=1:size(matriz_bit, 2)
            if matriz_bit(i,j) == '1'
              %Sumamos 1 a la matriz
              aux = i + ini_fila;
              if mod(matrizCob(aux,j),2) == 0
                matrizCob(aux, j) = mod(matrizCob(aux, j) +1, 256);
              end
           else
               aux = i + ini_fila;
               if mod(matrizCob(aux, j), 2) ~=0
                   matrizCob(aux, j) = mod(matrizCob(aux, j) -1, 256);
               end
           end
        end
    end
    matriz_cob_modi=matrizCob;
end