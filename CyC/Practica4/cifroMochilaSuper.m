function cifrado = cifroMochilaSuper(s, texto)
valida = mochila(s);
if valida==1
    cifrado=cifr_mochila(s, texto);
else
    cifrado=[];
end