function pote=potencia(c,d,n)
if mod(c,1)==0&&mod(d,1)==0&&mod(n,1)==0&&sign(c)==1&&sign(d)==1&&sign(n)==1
    pote=1;
    exponente = dec2bin(d);
    vector=[];
    for i=1:length(exponente)
        if i==1
            aux =uint64(mod(c,n));
        else
            aux = uint64(mod(vector(i-1)^2, n));
        end
        vector=[vector, aux];
        if exponente(length(exponente)-(i-1) )=='1'
            pote=uint64(mod(pote*vector(i),n));
        end
    end
else
    disp('Los valores no son enteros positivos');
end

% function pote=potencia(c,d,n)
% % Convertir los datos de entrada a enteros sin aproximar
% n=uint64(n);
% c=uint64(c);
% d=uint64(d);
% 
% d_base2=dec2bin(d)-'0'; % Pasar el exponente a base 2
% 
% % Inicializar vector con las potencias modulares a 0, excepto el último
% % elemento, que será igual a c mod n
% potModN=zeros(1,length(d_base2));
% potModN(length(d_base2))=uint64(mod(c,n));
% 
% % Calcular el resto de potencias modulares desde el final del vector al principio
% % para que los elementos de d_base2 se correspondan con potModN
% for i=length(d_base2)-1:-1:1
%     potModN(i)=uint64(mod(uint64(potModN(i+1)^2),n));
% end
% 
% pote=1; % pote contendrá la multiplicación de los elementos
% 
% for i=1:length(d_base2)
% 
%     % Multiplicar si el elemento correspondiente 
%     % está a 1 en d_base2
%     if(d_base2(i)==1)
%        pote=uint64(mod(pote*potModN(i),n));
%     end
% end