function desci=num_descifra(n, bloque_numero)
bloqueAux='';
%Añade 0 a los bloques cifrado para poder descifrar
for i=1:length(bloque_numero)
    aux = num2str(bloque_numero(i));
    while(length(aux)< (length(num2str(n))-1) ) 
        aux = strcat('0', aux);
    end
    bloqueAux=strcat(bloqueAux, aux);
end
%Elimina si existe algun 0 al final
if mod(length(bloqueAux),2)==1
    bloqueAux = bloqueAux(1:length(bloqueAux)-1);
end
%Agrupar de 2 en 2
matrix = reshape(bloqueAux, 2, [])';
[row, col]= size(matrix);
desci = [];
%Elimina los 30 que existan al final
for i = row:-1:1
    if(strcmp(matrix(i,:), '30'))
        matrix=matrix(1:length(matrix)-1, :);
    else
        break
    end
end
matrix=str2num(matrix);
desci=numeroletra(matrix);
