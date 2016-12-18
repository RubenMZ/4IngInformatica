function [publico, privado]= genero_clave(p, q)

%Calculamos n y fiden a partir de los valores p y q privados
n = p * q;
fiden = (p-1)*(q-1);
while(true)
    
    e = randi([1 (fiden-1)], 1);
    [G,d,V] = gcd(e,fiden);
    if (G==1)
        break;
    end
end
%Obtenemos un valor random valido para e y devolvemos la clave privada y
%publica.
publico = [n e];
privado = [n mod(d,fiden)];
