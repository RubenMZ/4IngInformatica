function desorden_pixel(foto, A)
%mfoto=imread(foto);
%mfoto=mfoto(1:193, 1:193, 1:3);
[row, col]=size(A);
[r, c, capa]=size(foto);
maux=foto;
if row==col && row==2
    for i=1:(r)
        for j=1:(c)
            coord = mod(A*[i;j], r);
            x=coord(1);
            y=coord(2);
            
            if(x==0)
                x=r;
            end
            
            if(y==0)
                y=r;
            end
            
            if(capa>1)
                maux(i,j,1:3)=foto(x,y,1:3);
            else
                maux(i,j,:)=foto(x,y,:);
            end
        end
    end
    setappdata(gcf, 'matriz', maux);
else
    disp('Las matrices deben ser cuadradas')
end