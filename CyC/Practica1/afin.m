function cifradoafinr=afin(clave, d, texto)
if (mod(d,1)~=0) || (mod(clave,1)~=0)
    error ('ErrorTests:convertTest','Desplazamiento d o clave no es entero');
    return
end
numero = letranumero(texto);
abecedario='abcdefghijklmnñopqrstuvwxyz';

if gcd(clave,length(abecedario))==1;
    aux = numero*clave + d;
    aux = mod(aux, length(abecedario));
else
    error('ErrorTests:convertTest''La clave no tiene mcd(clave,n)=1');
end

cifradoafinr=numeroletra(aux);