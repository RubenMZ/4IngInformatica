function comparo=barras(v)
abecedario='abcdefghijklmn�opqrstuvwxyz';
castellano=[0.1311 4; 0.106 0; 0.0847 19; 0.0823 15; 0.0716 8;0.0714 13; 0.0695 18; 0.0587 3; 0.054 20; 0.0485 2; 0.0442 11; 0.0434 21; 0.0311 12; 0.0271 16; 0.014 6; 0.0116 1; 0.0113 5; 0.0082 22; 0.0079 25; 0.0074 17; 0.006 7; 0.0026 26; 0.0025 9; 0.0015 24; 0.0012 23; 0.0011 10; 0.001 14];
[frec,freordenada]=cripto_ana_orden(v);
comparo = [castellano,freordenada];
%bar(castellano(1:27, 2), castellano(1:27, 1) , 'r');
%bar(freordenada(1:27, 2), freordenada(1:27, 1), 'm');