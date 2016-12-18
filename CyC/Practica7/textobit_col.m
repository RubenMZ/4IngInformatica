function [amplio, texto_bit]=textobit_col(texto, col)
num = double(texto);
bit = dec2bin(num,8)';
[r,c]=size(bit);
tam = r*c;
aux = mod(tam,col);
amplio=0;
bit = reshape(bit, 1, []);
if aux~=0
    amplio=col-aux;
    for i=1:amplio
        bit = [bit, '0'];
    end
end
texto_bit=reshape(bit,col,[])';