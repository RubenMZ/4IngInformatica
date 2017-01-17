% md5(
% Compute the MD5 digest of the message, as a hexadecimal digest.

% Follow the MD5 algorithm from RFC 1321 [1] and Wikipedia [2].
% [1] http://tools.ietf.org/html/rfc1321
% [2] http://en.wikipedia.org/wiki/MD5

% m is the modulus for 32-bit unsigned arithmetic.
function fhash = md5(mensaje)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PASO 1 INTRODUCIMOS VARIABLES Y CONSTANTES NECESARIAS
clc
%PASO1.1 ESCRIBIMOS EL MENSAJE
%mensaje=
%Mensaje introducido por argumento


%PASO 1.2.- VAMOS A TRABAJAR MODULO M=2^32
m=2^32;

% PASO 1.3.- CREAMOS UNA MATRIZ S PARA HACER LA ROTACIÓN,
% LOS NÚMEROS NEGATIVOS POR SER UNA ROTACIÓN A IZQUIERDA
s = [-7, -12, -17, -22;-5,  -9, -14, -20;-4, -11, -16, -23;-6, -10, -15, -21];

% PASO 1.4.- t ES LA TABLA QUE USAREMOS MÁS ADELANTE,para construir la función
% Hash  del emnsaje
t = fix(abs(sin(1:64)) .* m);

% PASO 1.5.- INICIALIZAMOS LA HASH
% MD5 utiliza las cuatro palabras siguientes:
% A=01 23 45 67 pero en Little endian:67 45 23 01
% B=89 ab cd ef --> ef cd ab 89 
% C=fe dc ba 98 --> 98 ba dc fe
% D=76 54 32 10 --> 10 32 54 76
A=['67452301']
B=['efcdab89'] 
C=['98badcfe']
D=['10325476']
fhash=[hex2dec(A),hex2dec(B),hex2dec(C),hex2dec(D)]
uint32(fhash)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PASO 2.- PREPARAMOS EL MENSAJE PARA APLICARLE LA HASH

%mensaje='hola que tal estas esto es una prueba para codigos';%
%mensaje='hola, me voy al cine';

mensaje = abs(mensaje);
bytelen = numel(mensaje)%número de elementos del vector 

% PASO 2.1.-
% AÑADIMOS AL MENSAJE UN 1 Y  LOS 0'S NECESARIOS PARA QUE EL NÚNERO DE BITS
% SEA CONGRUENTE CON 448 MÓDULO 512
% COMO TENEMOS BYTES, AÑADIMOS 128 (10000000) Y LOS CEROS NECESARIOS PARA QUE 
% EL NÚMERO DE BYTES SEA CONGRUENTE CON 56 MÓDULO 64

auxmensaje=mensaje;
auxmensaje = [auxmensaje 128];
tam=numel(mensaje);
while mod(tam, 64)~=56
    auxmensaje=[auxmensaje 0];
    tam=numel(auxmensaje);
end

% PASO 2.2.-
% CÓMO CADA PALABRA ESTÁ FORMADA POR 4 BYTES, HACEMOS UNA MATRIZ DE 4 FILAS
% CON LOS BYTES DEL MENSAJE, ASÍ CADA COLUMNA SERÁ UNA PALABRA 

matriz=reshape(auxmensaje, 4,[])

% PASO 2.3.-
% CONVERTIMOS CADA COLUMNA A ENTEROS DE 32 BITS, little endian.

auxM=[];
for j=1:size(matriz, 2)
    auxM=[auxM, matriz(1,j) + matriz(2,j)*(2^8) + matriz(3,j)*(2^16) + matriz(4,j)*(2^24)];
end

% PASO 2.4.-
% AÑADIMOS LA LONG DEL MENSAJE ORIGINAL COMO UN ENTERO 
% DE 64 BITS __>8 bytes__>dos palabras : little endian.
bitlen=bytelen*8

num1=mod(bitlen, m);
aux=(bitlen/m);
num2=mod(aux, m);

auxM=[auxM, num1, num2]

mensaje=auxM
uint32(mensaje)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PASO 3. REALIZAMOS LA FUNCIÓN HASH
% CADA BLOQUE DE  512bit
% TENEMOS ENTEROS DE 32 BITS (PALABRA)CADA BLOQUE TIENE 16 ELEMENTOS
% (PALABRAS)
% message(k + (0:15)).
for k = 1:16:numel(mensaje)
    a = fhash(1); b = fhash(2); c = fhash(3); d = fhash(4);
    for i =1:64
        % Convertimos b, c, d a vector fila  of bits (0s and 1s).
        bv = dec2bin(b, 32) - '0';
        cv = dec2bin(c, 32) - '0';
        dv = dec2bin(d, 32) - '0';
        % obtenemos  f  = mix of b, c, d.
        %      ki = indice  0:15, del mensaje (k + ki).
        %      sr = filas 1:4, de  s(sr, :).
        if i <= 16          % ronda 1
            f = (bv & cv) | (~bv & dv);
            ki = i - 1;
            sr = 1;
        elseif i <= 32      % ronda 2
            f = (bv & dv) | (cv & ~dv);
            ki = mod(5 * i - 4, 16); %de 5 en 5 empezando en 1
            sr = 2;
        elseif i <= 48      % ronda 3
            f = xor(bv, xor(cv, dv));
            ki = mod(3 * i + 2, 16);    %de 3 en 3 empezando en 5
            sr = 3;
        else                % ronda 4
            f = xor(cv, bv | ~dv);
            ki = mod(7 * i - 7, 16);    %de 7 en 7 empezando en 0
            sr = 4;
        end
        % Convert f, DE VECTOR FILA DE BITS  A  ENTEROS DE 32-bit .        
        f=bin2dec(char(f+'0'));
       
        % HACEMOS LA ROTACIONES
        sc = mod(i - 1, 4) + 1;
        sum = mod(a + f + mensaje(k + ki) + t(i), m);
        sum = dec2bin(sum, 32);
        sum = circshift(sum, [0, s(sr, sc)]);
        sum = bin2dec(sum);
        %sum = mod(b+sum, m);
        % ACTUALIZAMOS  a, b, c, d.
        aux=d;
        d=c;
        c=b;
        b=mod(b+sum, m);
        a=aux;
        
        
    end
    
    % MODIFICAMOS EL HASH.
    fhash = [mod(fhash + [a,b,c,d], m)];
    
    
end

% CONVERTIMOS HASH DE ENTEROS DE 32 BITS  , LITTLE ENDIAN, A BYTES .
uint32(fhash)
fhash=[fhash; fhash/(2^8); fhash/(2^16); fhash/(2^24)]
fhash=reshape(mod(floor(fhash), 256), 1, numel(fhash))

% CONVERTIMOS HASH A HEXADECIMAL.

fhash=dec2hex(fhash);
fhash=reshape(fhash', 1, numel(fhash));




