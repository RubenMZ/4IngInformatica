function [cifra, claro]=descifro_permutacion(p, cifrado)
abecedario='abcdefghijklmn�opqrstuvwxyz';
A = matper(p);
claro = cifro_hill(inv_modulo(A, length(abecedario)), length(abecedario), cifrado);
cifra= cifrado;