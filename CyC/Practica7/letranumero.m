function numero=letranumero(texto)
%Pasa las letras a numeros, correspondiendo a la posicion del abecedario
abecedario='abcdefghijklmnnopqrstuvwxyz';
abecedario(15)=[char(241)];
texto=lower(texto);
numero=[];
for i=1:length(texto)
    for j=1:length(abecedario)
       if texto(i) == abecedario(j);
           numero=[numero, j-1];
           break 
       end    
    end
end
