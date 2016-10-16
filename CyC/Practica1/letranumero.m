function numero=letranumero(texto)
abecedario='abcdefghijklmnñopqrstuvwxyz';
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
