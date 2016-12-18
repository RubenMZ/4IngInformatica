function diffie_hellman(g, p)
%PASO 1. Se introduce un g y p valido

fprintf('PASO 1.- \n\tNos ponemos de acuerdo en g=%d y p=%d\n\n', g, p);

if genera(g,p) ~= 0
    %PASO 2. Se generan valores aleatorios 1<valor<(p-1) y se eleva el
    %generador.
    rand_a = randi([1 (p-1)],1);
    rand_b = randi([1 (p-1)],1);
    pote_a=potencia(g,rand_a,p);
    pote_b=potencia(g,rand_b,p);
    
    fprintf('PASO 2 para A .- \n\tA genera un número aleatorio aa=%d\n', rand_a);
    fprintf('\tA envía a B :pote_a=mod(g^aa,p)= mod(%d ^ %d,%d)=%d\n\n', g, rand_a, p, pote_a);
    
    fprintf('PASO 2 para B.- \n\tB genera un número aleatorio bb=%d\n', rand_b);
    fprintf('\tB envía a A :pote_b=mod(g^bb,p)=mod(%d ^ %d,%d)=%d\n\n', g, rand_b, p, pote_b);
    %PASO 3. Se obtiene la clave para cifrar.
    clave1= potencia(pote_b,rand_a,p);  
    clave2= potencia(pote_a,rand_b,p);
    
    fprintf('PASO 3.- \n\tA y B calculan la clave con la que van a cifrar sus mensajes\n');
    fprintf('\tA obtiene la clave= potencia(pote_b,aa,p)= potencia(%d, %d, %d)=%d\n', pote_b, rand_a, p, clave1);
    fprintf('\tB obtiene la clave= potencia(pote_a,bb,p)=potencia(%d, %d, %d)=%d\n\n', pote_a, rand_b, p, clave2);
    
else
    disp('No se puede intercambiar claves con g y p');
    return
end