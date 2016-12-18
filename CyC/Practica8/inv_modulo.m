%A=[1 3 2 5;7 -3 1 1 ;0 0 4 2; 3,5,2,1]
%entrada de la funci?n : la matriz y el modulo
%salida: la inversa de la matriz, si existe en ese modulo, en caso
%contrario inver=0
function inver=inv_modulo(A,m)
[filas,col]=size(A);
if filas~=col  
    inver=0;
    error('ErrorTests:convertTest','la matriz no es cuadrada, no puede tener inversa')
    return
else
    if ~isequal(A,round(A) )
        inver =0;
        error('ErrorTests:convertTest','la matriz no tiene todos los elementos enteros')
        return
    else
        A=mod(A,m);
        deter=round(mod(det(A),m));%porque gcd admite entradas enteras
        [g ,u ,v]=gcd(m,deter);
        if(g==1)   % si det es primo relativo con m?dulo detrabajo
            adjA=mod(det(A)*inv(A),m);
            inverso_deter=mod(v,m);
            inver=mod(inverso_deter*adjA,m);
            inver=round(inver);
        else
            error('ErrorTests:convertTest','la matriz no es inversible modulo%d\n',m)
            inver=0;
        end
    end
end