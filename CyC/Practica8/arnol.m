function arnol(foto, A)
mFoto=imread(foto);
[r, c, capa]=size(mFoto)
if(r>c)
    mFoto=mFoto(1:(c-1),1:(c-1),1:3);
else
    if(r<c)
        mFoto=mFoto(1:(r-1),1:(r-1),1:3);
    end
end
option=1;
    disp('Introduce la variable para continuar');
    disp('    1 - Desordenar foto')
    disp('    2 - Ordenar foto')
    option=input('Opcion:  ')
    switch option
        case 1
            desorden_pixel(mFoto,A);
            matriz=getappdata(gcf, 'matriz');
            imwrite(matriz,'desorden.bmp')
            imshow('desorden.bmp')
            
        case 2
            invA=inv_modulo(A, r)
            desorden_pixel(mFoto, invA);
            matriz=getappdata(gcf, 'matriz');
            imwrite(matriz,'nueva.bmp')
            imshow('nueva.bmp')
    end
