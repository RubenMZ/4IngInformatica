function texto=numeroletra(numero)
abecedario='abcdefghijklmn�opqrstuvwxyz';
texto=[];
for i=1:length(numero)
    x=numero(i)+1;
    texto=[texto, abecedario(x)];
end
