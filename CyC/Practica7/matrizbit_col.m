function [amplio, matriz_bit]=matrizbit_col(matriz, col)
matriz=mod(matriz, 256);
bit=[];
for i=1:size(matriz, 1)
    for j=1:size(matriz, 2)
        bit=[bit, dec2bin(matriz(i,j),8)];
    end
end
tam = length(bit);
amplio=0;
aux = mod(tam,col);
if aux~=0
    amplio=col-aux;
    for i=1:amplio
        bit = [bit, '0'];
    end
end
matriz_bit=reshape(bit,col,[])';