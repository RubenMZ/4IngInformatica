function [texto, cifrado]=cifro_permutacion(p , texto)
abecedario='abcdefghijklmn�opqrstuvwxyz';
A = matper(p);
cifrado = cifro_hill(A, length(abecedario), texto);
