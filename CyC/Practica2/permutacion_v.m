function permuta=permutacion_v(p)
aux = sort(p);
aux2 = [1:length(p)];
if( aux == aux2)
    permuta=1;
    return
else
    permuta=0;
    return
end