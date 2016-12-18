function n=pote(A,m)
I=[1 0;0 1];
n=1;
aux=A;
while ~isequal(aux,I)
    aux=mod(aux*A,m);
    n=n+1;
end
