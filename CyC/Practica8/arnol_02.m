function potencia=arnol_02(foto,A)
mfoto=imread(foto);
[row, col]=size(A);
[r, c, capa]=size(mfoto)
if row==col && row==2 
    option=1;
    disp('Introduce la variable para continuar');
    disp('    1 - Recuperar foto')
    disp('    2 - Desordenar foto k veces')
    option=input('Opcion:  ')
    switch option
        case 1
            potencia=pote(A,r);
            potencia
            aux=input('Introduce el num de potencia anterior: ');
            for i=1:(potencia-aux)
                i
                desorden_pixel(mfoto, A);
                mfoto=getappdata(gcf, 'matriz');
            end
            imwrite(mfoto,'nueva2.bmp')
            imshow('nueva2.bmp')
            
        case 2
            salir=0;
            potencia=0;
            while salir==0
                potencia=potencia+1;
                potencia
                desorden_pixel(mfoto, A);
                mfoto=getappdata(gcf, 'matriz');
                imshow(mfoto);
                salir=input('Introduce 0 para cont, 1 para salir: ');
            end
            imwrite(mfoto,'desorden2.bmp')
            imshow('desorden2.bmp')
    end
else
    disp('La matriz A tiene que ser 2x2');
end
    
    