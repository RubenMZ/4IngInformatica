function des_mmh(s1, cifrado, mu, invw)
cifrado = mod(cifrado*invw, mu);
des_mochila(s1,cifrado)
