function [v, valida]= sol_mochila(s, obj)
%Declara un vector de enteros para luego activar a 1 las posiciones
%necesarias
vector = zeros(1, length(s));
valida=mochila(s);
aux=obj;
%Activa las positiciones que reduzcan el objetivo en orden decreciente
for i=length(s):-1:1
    if aux>=s(i)
        aux = aux-s(i); 
        vector(i)=1;
    end
end
% Si no reduce el objetivo a 0, no se encuentra la solucion
if aux~=0
    disp('con el algoritmo usado no encuentro el objetivo');
    v=0;
else
    v=vector;
end