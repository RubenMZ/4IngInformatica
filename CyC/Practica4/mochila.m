
function valida = mochila (s)
valida=1;
vector = sort(s);
%Comprueba si estan ordenados en orden creciente
if vector ~= s
   valida=0;
   disp('los elementos no están ordenados en orden creciente');
   return
end

aux=0;

for i=1:length(s)
    %Comprueba que sean valores enteros positivos
    if mod(s(i),1)~=0 ||  s(i)<0
        valida=0;
        fprintf('el valor %f valida=mochila([5 6 17 40]) no es entero positivo', s(i));
        return  
    end
    %Comprueba que cada elemento sea mayor a la suma de los anteriores
    if s(i)<= aux;
        valida=0;
        disp('La mochila no es supercreciente');
        return  
    end
    aux = aux +s(i);
end