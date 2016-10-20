function cifrado = cifro_hill(A, m, texto)
abecedario='abcdefghijklmnñopqrstuvwxyz';
invA = inv_modulo(A,m);
numero = letranumero(texto);
if (invA==0)
    cifrado=0;
    error('ErrorTests:convertTest','la matriz no puede tener inversa')
   return
else
    long = length(numero);
    dims = size(A);
    dim = dims(1);
    aux = mod(long, dim);
    if(aux~= 0)
        for i=1:(dim-aux)
            numero = [numero, 23];
        end
    end
    rows=dim;
    cols=length(numero)/dim;
    M = reshape(numero, [rows, cols]);
    out=[];
    for i=1:cols
        x = mod(A*M(1:rows, i),m);
        out = [out, x'];
    end
    cifrado=numeroletra(out);
end