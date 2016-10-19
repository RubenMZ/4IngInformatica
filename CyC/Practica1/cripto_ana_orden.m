function [frecuencia, freordenada]=cripto_ana_orden(v)
abecedario='abcdefghijklmnñopqrstuvwxyz';
numero=letranumero(v);
matrix = [];
for i=1:length(abecedario)
    aux = (numero==(i-1));
    frec = sum(aux);
    matrix(i, 1)=frec/length(v);
    matrix(i, 2)=(i-1);
end
frecuencia=matrix;
freordenada=sortrows(matrix, -1);