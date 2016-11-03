function [cp , mu , invw]=mochila_mh(s1)
valida = mochila(s1)
if valida==1
   mu=input('Ingrese el valor de la variable mu: ')
   if mu > 2*s1(length(s1))
       i=1
       while true
           if mod(mu, i)==1
               w=i;
               break;
           end
           i=i+1;
       end
       cp = mod(s1*w, mu);
       [G, U, V] = gcd(mu, w);
       invw = mod(V, mu);
   else
       disp('mu debe ser mayor que (2*an+1)')
       return  
   end
else
    disp('La mochila no es valida')
    return
end