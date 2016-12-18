function diffie_hellman_intruso(g, p)
%PASO 1. Se introduce un g y p valido
if genera(g,p) ~= 0
    %PASO 2. Se generan valores aleatorios 1<valor<(p-1) y se eleva el
    %generador.
    rand_a = randi([1 (p-1)],1);
    pote_a=potencia(g,rand_a,p);
    fprintf('A genera un número aleatorio aa=%d\n', rand_a);
    fprintf('EL INTRUSO CAPTURA pote_a =%d, y lo guarda\n', pote_a);
        
    rand_c = randi([1 (p-1)],1);
    fprintf('EL INTRUSO GENERA cc=%d\n',rand_c);
    pote_c=potencia(g,rand_c,p);
    fprintf('EL INTRUSO ENVIA a B :pote_a=mod(g^cc,p)= mod(%d ^ %d, %d)=%d\n', g, rand_c, p, pote_c);
    
    rand_b = randi([1 (p-1)],1);    
    fprintf('B genera un número aleatorio bb=%d\n', rand_b);
    pote_b=potencia(g,rand_b,p);  
    fprintf('B envía a A :pote_b=mod(g^bb,p)=mod(%d ^ %d,%d)=%d\n', g, rand_b, p, pote_b);
    
    fprintf('EL INTRUSO CAPTURA pote_b =%d, y lo guarda\n', pote_b);
    
    fprintf('EL INTRUSO ENVIA a A el msmo dato que le ha enviado a B:pote_c= %d\n', pote_c);
    
    %PASO 3. Se obtiene la clave para cifrar.

    clave_a= potencia(pote_c,rand_a,p) 
    clave_b= potencia(pote_c,rand_b,p) 
    
    fprintf('sabe que A cifrará con potencia (pote_c,aa,p)=%d\n', clave_a);
    fprintf('sabe que B cifrará con potencia (pote_c,bb,p)=%d\n', clave_b);
    
else
    disp('No se puede intercambiar claves con g y p');
    return
end