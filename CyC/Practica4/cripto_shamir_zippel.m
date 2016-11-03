function cripto_shamir_zippel(cp, mu)
b1 = cp(1);
b2 = cp(2);
%Calculamos el inverso de B2
[G, U, V] = gcd(mu, b2);
inv_b2 = mod(V, mu);
[G, U, V] = gcd(inv_b2, mu);
if G~=1
    disp('El valor inv_b2 tiene que ser mcd(inv_b2, mu)==1')
end
% 1) Obtenemos el valor de q = b1 * b2^-1
q= mod(b1*inv_b2, mu);
% 2) Se calculan todos los multiplos modulares
resp=1;
j=1;
while resp==1
    tic
    CM=[];
    for i=1:(2^(length(cp)+j))
        CM = [CM, mod(i*q, mu)];
    end
    CM= sort(CM);

    iteracion = 1;
    salir=false;
    fprintf('Vamos a buscar en el rango [ 1 , %d ]\n', 2^(length(cp)+j));
    disp('Espera respuesta de ordenador');
    while(salir == false)

        
        % 3) Cogemos el menor de CM como candidato a a1
        a1 = CM(iteracion);
        %a1= CM(iteracion);
        % 4) Se calcula el valor w = b1*a1^-1
        [G, U, V] = gcd(mu, a1);
        inv_a1 = mod(V, mu);
        w= mod( b1*inv_a1 , mu);
        % 5) Invertimos el valor w y calculamos todos los valores para la mochila
        % privada
        [G, U, V] = gcd(mu, w);
        inv_w = mod(V, mu);

        s1 = mod(cp*inv_w, mu);

        if mochila2(s1)
            disp('Hemos encontrado la mochila simple: ');
            s1
            salir=true;
            return
        else    
            iteracion = iteracion +1 ;
            if(iteracion>length(CM))

                %disp('No se ha encontrado la mochila');
                salir=true;
                break;
            end
        end
    end
    toc
    resp = input('No hemos encontrado la mochila, si quieres ampliar el rango, responde 1 ');
    j=j+1;
end