function cifrado=cifro_hill(A,m,texto)
%1.-lo primero es ver si la matriz  inversa trabajando m�dulo m
inver=inv_modulo(A,m);
%2.- pasamos a  n�meros porque queremos operar con ellos
numero=letranumero(texto);
n=size(A);
%3.- La long del texto debe de ser m�ltiplo del numero de filas de la matriz.
%en caso de no ser as�, a�adimos tantos 23 (w) como hagan falta  al mensaje.
if mod(length(numero),n(1))~=0
    mas= n(1)-mod(length(numero),n(1));
    mas= zeros(1,mas)+23;
    numero=[numero,mas];
end
%4.- dividimos  en bloques los n�meros del mensaje  para poder realizar el
%cifrado: cifrado = A*mensaje
mm=reshape(numero,n(1),[]);
cifrado=mod(A*mm,27);
cifrado=reshape(cifrado,1,[]);
%5.- lo pasamosa letras 
alfabeto ='abcdefghijklmn�opqrstuvwxyz';
cifrado=alfabeto(cifrado+1);


