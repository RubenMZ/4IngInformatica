function obten=obtengo_bit(matriz, ini_filas, fin_filas, admas)
[r, c]=size(matriz);
obten=[];
if ini_filas>r || fin_filas>r || ini_filas>fin_filas
    disp('ini_filas y fin_filas deben tener un valor adecuado');
else
    for i=ini_filas:fin_filas
        for j=1:c
            if i==fin_filas && j>admas
                break;
            end
            aux=dec2bin(matriz(i,j), 8);
            obten=[obten, aux(8)];
        end
    end
end