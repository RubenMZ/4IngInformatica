function criptoanalisis_afin(v,n)
abecedario='abcdefghijklmnnopqrstuvwxyz';
abecedario(15)=[char(241)];
%v='eymcklcdmgdcyescmeligvcqwbseiwycklevqgqwdgrlcldwveuiemwqwcrgvbmcipgevseiwycklevqgqwcscdelucgvnelyciwqzucl';
comparo=barras(v);
option=1;
i=1;
j=2;
x1 = comparo(1, 2);
x2 = comparo(2, 2);
length(v)
while (option==1)
    if( j >  length(abecedario) && (i+1) > length(abecedario) )
        disp('No hay mas claves para probar');
        return
    else
        if ( j > length(abecedario) )
            i=i+1;
            j=1;
        else
            if( j == i && (j+1) ~= length(abecedario) )
                j=j+1;
            end
        end
        y1 = comparo(i, 4);
        y2 = comparo(j, 4);
        j=j+1;
    end
    
    a = [x1 1; x2 1]
    
    A=mod(a,n);
    deter=round(mod(det(A),n));%porque gcd admite entradas enteras
    [G ,U ,V]=gcd(n,deter);
    if(G==1)   % si det es primo relativo con m?dulo detrabajo
        inva = inv_modulo(a, 27)

        vector = [y1; y2]

        out =inva*vector;

        k = mod(out(1,1), n)
        d = mod(out(2,1), n)

        %Para ver si la clave k tiene mcd = 1
        [G, U, V] = gcd(length(abecedario), k);
        if G==1;
            descifraafin=desafin(k, d, v)
            %Condicional auxiliar para comparar con el inicio de la cadena
            prompt = 'si quieres probar otra clave introduce 1,en caso contrario introduce 0 -> ';
            option = input(prompt);
        else
            disp('La clave no tiene mcd(clave,n)=1, probamos otra siguiente')
        end
    else
        error('La matriz no es inversible modulo%d\n',m);
    end
end