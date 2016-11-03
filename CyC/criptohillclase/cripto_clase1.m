function matrizclave=cripto_clase1(claro,cripto,m)
%m es el orden de la matriz
matrizclave=[];
claro=letranumero(claro);
cripto=letranumero(cripto);
nclaro=length(claro);
ncripto=length(cripto);
if ncripto>=m*m
    ll = (ncripto-nclaro);
    claro=[claro, zeros(1, ll)+23 ];
    nclaro=length(claro);
    % PONER EL TEXTO CLARO Y EL CIFRADO EN FILAS DE m columnas,
    claro=reshape(claro,m,[])';
    crip=reshape(cripto,m,[])';
    % HACEMOS OPERACIONES ELEMENTALES HASTA  QUE LA MATRIZ DEL TEXTO CLARO SEA I
    for j=1:m
        [G,AA,B]=gcd(27,claro(j,j));
        if G==1
            %EL PIVOTE,LO HACEMOS 1 MULTIPLICANDO  LA FILA POR SU INVERSO
            inv11=mod(B,27);
            claro(j,:)=mod(inv11*claro(j,:),27); crip(j,:)=mod(inv11*crip(j,:),27);
            %HACEMOS CEROS DEBAJO Y ENCIMA DEL PIVOTE
            for i=1:(nclaro/m)
                if i~=j
                    crip(i,:)=mod(crip(i,:)-claro(i,j).*crip(j,:),27);
                    claro(i,:)=mod(claro(i,:)-claro(i,j).*claro(j,:),27);
                end
            end
        else
            aux=0;
            for k=j+1:(nclaro/m)
                [g,u,v]=gcd(27,claro(k,j));
                if g==1
                    filaClaro = claro(k,:);
                    filaCripto = crip(k, :);
                    claro(k, :)=claro(j,:);
                    claro(j,:)=filaClaro;
                    crip(k, :)=crip(j,:);
                    crip(j,:)=filaCripto;
                    break
                else
                    aux = aux+1;
                end
            end
            if aux == (nclaro/m)-j
                disp('La matriz no es valida');
                return
            end
        end
    end
else
   disp('texto pequeño, no puedo conseguir matriz cuadrada de texto claro'); 
   return
end
matrizclave=crip(1:m,:)';

