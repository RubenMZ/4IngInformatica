function doble = letra2numeros(texto)
numeros = letranumero(texto);
doble=[];
%Pasamos las letras a numeros y le añadimos 0 a los numeros individuales
%para formar bloques de 2 numeros.
for i=1:length(numeros)
    aux = int2str(numeros(i));
    if(length(aux)==1)  
        aux = ['0', aux];
    end
    doble = [doble, aux];
end
