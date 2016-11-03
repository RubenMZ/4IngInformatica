
function valida = mochila2(s)
valida=1;
vector = sort(s);
if vector ~= s
   valida=0;
   return
end

aux=0;

for i=1:length(s)
    if mod(s(i),1)~=0 ||  s(i)<0
        valida=0;
        return  
    end
    if s(i)<= aux;
        valida=0;
        return  
    end
    aux = aux +s(i);
end