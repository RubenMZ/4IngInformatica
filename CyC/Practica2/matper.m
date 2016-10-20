function mat_p=matper(p)
if permutacion_v(p)
    mat_p = zeros(length(p));
   for i=1:length(p)
       mat_p(i, p(i))=1;
   end
else
    mat_p=0;
    error('ErrorTests:convertTest','Este vector no permuta');
    return
end