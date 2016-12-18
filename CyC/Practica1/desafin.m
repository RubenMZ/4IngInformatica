function descifraafin=desafin(clave, d, texto)
if (mod(d,1)~=0) || (mod(clave,1)~=0)
    error ('ErrorTests:convertTest','Desplazamiento d o clave no es entero');
    return
end
numero = letranumero(texto);
abecedario='abcdefghijklmnnopqrstuvwxyz';
abecedario(15)=[char(241)];

[G, U, V] = gcd(length(abecedario), clave);

if G==1;
    aux = V*(numero-d);
    aux = mod(aux, length(abecedario));
else
    error('ErrorTests:convertTest','La clave no tiene mcd(clave,n)=1');
end

descifraafin=numeroletra(aux);