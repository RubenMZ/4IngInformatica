function generador=genera_0(g,p)
tic
%Comprueba si g es generador de Zp comprobando que se generan todos los
%componentes de Zp
generador=g;
vector=[];
for i=1:p-1
    %Va generando todos los elementos de Zp
    aux = potencia(g, i, p);
    if find(aux == vector)
        generador=0;
        toc
        return
    else
        vector = [vector,aux];
    end
end
toc