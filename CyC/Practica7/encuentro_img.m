function encuentro_img(c_chica, f_chica, fotogrande_mod)
mFoto= imread(fotogrande_mod);
[r, c, capa]= size(mFoto);
tam= c_chica*f_chica*8;
sobra=mod(tam, c);
filas=floor(tam/c)+1;
if r<f_chica || c<c_chica
    error('El num filas o columnas no es el correcto')
else
    for i=1:capa
        obten=obtengo_bit(mFoto(:,:,i), 1, filas, sobra);
        mAux=reshape(obten, 8, [])';
        mAux_final(:,:,i)=bin2dec(mAux);
    end
    for i=1:capa
        aux=mAux_final(:,:,i);
        matriz(:,:,i)=uint8(reshape(aux, f_chica, c_chica))';
    end
    if capa>1
        imshow(matriz(:,:,1:3));
    else
        imshow(matriz(:,:,:))
    end
end