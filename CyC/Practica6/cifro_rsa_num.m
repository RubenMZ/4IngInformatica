function cifrado=cifro_rsa_num(e, n, blo)
%Igual que cifro_rsa pero teniendo ya el bloque de numeros preparado
cifrado=[];
for i=1:length(blo)
    cifrado = [cifrado, potencia(blo(i), e, n)];
end