function cifrado=cifr_mochila(s, texto)

% Convierte el texto a ascii y el ascii a binario
texto_ascii= double(texto)
texto_binario= dec2bin(texto_ascii,8)

% Rellena con 1 el vector si no tiene el tamaño correcto para la mochila s
[rows, cols]=size(texto_binario);
modulo = mod(rows*cols, length(s));
texto_binario = reshape(texto_binario', 1, []);
if modulo ~=0
    for i=1:(length(s)-modulo)
        texto_binario = [texto_binario, '1'];
    end
end
% Reordena el vector binario a una matriz para poder cifrar con la mochila
mat = reshape(texto_binario, length(s), [])';
[rows, cols] = size(mat);
cifrado = [];
% Cifra el mensaje con matriz y la mochila
for i=1:rows
    aux = 0;
    for j =1:cols
        aux = aux + str2double(mat(i,j))*s(j);
    end
    cifrado = [cifrado, aux];
end
