function mensaje=des_bitmenos(numero, fotomens)
mFoto = imread(fotomens);
matriz=mFoto(:,:,1);
[filasFoto, columFoto, capas] = size(mFoto);
filas=(numero/columFoto);
modu= mod(filas, 1);
if(modu>0)
    filas=floor(filas)+1;
end
mensaje_num=[];
for i=1:filas
    for j=1:columFoto
        if mod((matriz(i,j)-1),2) == 0
          %Sumamos 1 a la matriz
           mensaje_num=[mensaje_num 1];
        else
           mensaje_num=[mensaje_num 0];
        end
    end
end
mensaje_num=mensaje_num(1:numero);
texto_bit=reshape(mensaje_num,8,[])';
texto_bit=num2str(texto_bit);
num = bin2dec(texto_bit)';
mensaje=char(num);
