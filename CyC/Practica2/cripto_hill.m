function cripto_hill(textoclaro, textocifrado , orden)
abecedario='abcdefghijklmnñopqrstuvwxyz';
n = length(abecedario);
%textoclaro = 'enunlugardelamanchadecuyono';
%textocifrado = 'wvx idq ddo itq jgo gji ymg fvc uñt';
%Creo los vectores de numeros a partir de los textos
numeroClaro = letranumero(textoclaro);
numeroCifrado = letranumero(textocifrado);
%Para igualar la longitud a un multiplo del valor de orden.
long = length(numeroClaro);
aux = mod(long, orden);
    if(aux~= 0)
        for i=1:(orden-aux)
            numeroClaro = [numeroClaro, 23];
            numeroCifrado = [numeroCifrado, 23];
        end
    end
%Creo las matrices a partir de los vectores de numeros
rows = orden;
cols = length(numeroClaro)/orden;
matrizClaro = reshape(numeroClaro, [rows, cols]);
matrizCifrado = reshape(numeroCifrado, [rows, cols]);
%Hacemos la traspuesta para trabajar con ellas
matrizClaro = matrizClaro';
matrizCifrado = matrizCifrado';
matriz = [matrizClaro, matrizCifrado];
[rows, cols] = size(matriz);
for i=1:orden
    aux = matriz(i,i);
    while aux == 0
       j = i+1;
       if matriz(j, i)~=0
           fila = matriz(i, 1:cols);
           matriz(i, 1:cols) = matriz(j, 1:cols);
           matriz(j, 1:cols) = fila;
       end
       aux = matriz(i,i);
       if j==orden && aux==0
           matriz
           error('ErrorTests:convertTest','Gauss no se pudo completar, filas de ceros');
           return
       end
       j = j+1;
    end    
    [G, U, V] = gcd(n, aux);
    for j=1:cols
        matriz(i,j) = mod(matriz(i,j)*V, n);
    end
    for j=1:rows
        if(i~=j)
           aux2 = matriz(j,i);
           matriz(j,1:cols) = mod(matriz(j,1:cols)-aux2*matriz(i,1:cols), n);
        end
    end
end
matriz_clave = matriz(1:orden, (orden+1):(orden+orden));
matriz_clave = matriz_clave'
