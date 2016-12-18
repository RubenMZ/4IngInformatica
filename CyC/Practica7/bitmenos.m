function [numero, amplio] = bitmenos(texto, foto)

mFoto = imread(foto);
[filasFoto, columFoto, capas] = size(mFoto);
numero = length(texto)*8;
[amplio, matriz] = modificamos(mFoto(:,:,1), texto, 1, columFoto);

matriz(:,:,2:3)=mFoto(:,:,2:3);

fprintf('numero=%d (n de pixeles a modificar)\n', numero);
fprintf('amplia=%d (los que hemos añadido)\n', amplio);

imwrite(matriz, 'fotomens.bmp');