function descifro_num = descifro_rsa_num(d, n, cifrado_numeros)
    %Se aplica la potencia con el inverso de e que es d al bloque de
    %numeros cifrados
    descifro_num = [];
    for i=1:length(cifrado_numeros)
        aux = potencia(cifrado_numeros(i),d,n);
        descifro_num = [descifro_num aux];
    end
    