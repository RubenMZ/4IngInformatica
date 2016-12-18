function pote=potencia(c,d,n)
%Comprueba si son enteros positivos c, d, n
if mod(c,1)==0&&mod(d,1)==0&&mod(n,1)==0&&sign(c)==1&&sign(d)==1&&sign(n)==1
    pote=1;
    %El exponente lo convierte en binario para despues pillar las potencias
    %de 2
    exponente = dec2bin(d);
    vector=[];
    for i=1:length(exponente)
        if i==1
            aux =mod(c,n);
        else
            aux = uint64(mod(vector(i-1)^2, n));
        end
        %Guardamos las potencias de 2 y cogeremos son las que esten activas
        %en el número binario
        vector=[vector, aux];
        if exponente(length(exponente)-(i-1) )=='1'
            pote=uint64(mod(pote*vector(i),n));
        end
    end
else
    disp('Los valores no son enteros positivos');
end