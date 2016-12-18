function cifrado=cifro_rsa(e, n, texto)
%Pasa el texto a numeros de 2 cifras
doble = letra2numeros(texto);
tama = length(num2str(n))-1;
%Prepara los bloquees añadiendo  30 y 0
blo=prepa_num_cifrar(tama, doble);
cifrado=[];
%Cifra los bloques realizando la potencia e mod n
for i=1:length(blo)
    cifrado = [cifrado, potencia(blo(i), e, n)];
end