function desci= elgamal(q, g , texto)
%Metodo de intercambio de claves el gamal
if g>0
    % A partir de  q y g A y B generan sus claves privadas a y k
    %a = 301065
    a = randi([1 (q-1)],1)
    publ_a = potencia(g, a, q)
    
    %Las claves publicas seran publ_a y gk
    
    %k = 124357
    k = randi([1 (q-1)],1)
    gk = potencia(g, k, q)
    gak = potencia(g, a*k, q)
    
    %Se prepara el texto para cifrar con tamaño de bloque length(q)-1
    
    tama = length(int2str(q))-1;
    doble= letra2numeros(texto);
    blo = prepa_num_cifrar(tama, doble)
    
    %B cifra los bloques de texto con gak
    y1 = gk;
    y2 = [];
    for i=1:length(blo)
        y2 = [y2 mod(blo(i)*gak, q)];
    end
    y2
    
    
    %A descifra los mensajes con el inverso de gk*a que es gak, la clave
    %con la que se cifro.
    invyla = int64(potencia(y1, a, q));
    [g ,u ,v]=gcd(q, invyla);
    invyla = mod(v, q)
    aux = uint64(y2*uint64(invyla));
    descifro = mod(aux, q)
    desci= num_descifra(q, descifro);
    
else
    disp('g debe ser mayor que 0');
    return
end