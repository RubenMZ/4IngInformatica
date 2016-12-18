function blo=prepa_num_cifrar(tama, bloque)
%Anade 30 al final de las cadenas y 0 si es impar para que se formen
%bloques de tamano tama
if(mod(length(bloque), tama)~=0)
    %Anade solo 30 hasta completar los bloquees
    if(mod( tama - mod(length(bloque), tama), 2) ==0 )
        while mod(length(bloque), tama)~=0
            bloque = strcat(bloque, '30');
        end
    else
    %Anade 30s y posteriormente un 0 porque tiene tamano 
    %mod(tama, long.bloque)=1
        while ( tama - mod(length(bloque), tama)) ~= 1
            bloque = strcat(bloque, '30');
        end
        bloque = strcat(bloque, '0');
    end
end
bloque = reshape(bloque, tama, [])';
blo= str2num(bloque)';
    
    