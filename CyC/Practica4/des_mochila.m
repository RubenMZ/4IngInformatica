function mensaje= des_mochila(s, cifrado)
texto_binario=[];
% Pasa el codigo cifrado a binario
 for i=1:length(cifrado)
     [v, valida]= sol_mochila(s, cifrado(i));
     if valida==1
         texto_binario = [texto_binario, v ];
     else
         disp('con el algoritmo usado no se puede descifrar');
         return
     end
 end
 % Pasa el codigo binario a grupos de 8 bits
 modulo =  mod(length(texto_binario), 8);
 if modulo ~=0
     aux = length(texto_binario)-modulo;
     texto_binario = texto_binario(1:aux);
 end
 mat = reshape(texto_binario, 8, [])';
 % Convierte los grupos 8bits a decimal ascii
 texto_ascii = bin2dec(num2str(mat));
 % El codigo ascii lo convierte en letras
 mensaje = [char(texto_ascii')];