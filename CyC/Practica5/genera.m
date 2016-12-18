function generador=genera(g, p)
tic
generador=0;
%Comprueba si g es generador de Zp sacando los factores comunes.
if length(factor(p))==1 && g<p && g>0
    generador=g;
    q=(p-1);
    F=factor(p-1);
    for i=1:length(F)
        %Eleva el g al (p-1) partido de cada factor.
        aux = potencia(g, q/F(i), p);
        if(aux<=1 || aux>(p-1))
            disp('g no es generador');
            generador=0;
            toc
            return
        end
    end 
toc
else
    disp('el numero p debe de ser primo y g menor que p y mayor que cero')
    toc
    return
end