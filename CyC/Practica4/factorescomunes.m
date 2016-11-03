function factores_c = factorescomunes(w, s1)
% Saca los factores primos de w
F = factor(w);
factores_c=0;
% Compara si algun elemento de s1 tiene factores comunes con w
for i = 1:length(s1)
    for j=1:length(F)
        Faux = factor(s1(i));
        if sum(Faux == F(j))>1
            factores_c=1;
            return
        end
    end
end


