function [amplio, f_chica, c_chica]= escondo_img(fotochica , fotocobertura)
mFotoCob=imread(fotocobertura);
mFoto=imread(fotochica);
[row, col, capa]=size(mFotoCob);
if(capa>1)
    f_chica(:,:,1:3)=mFotoCob(:,:,1:3);
else
    f_chica(:,:,:)=mFotoCob(:,:,:);
end

for i=1:capa
    [amplio, f_chica(:,:,i)]=modificamos_img(mFotoCob(:,:,i), mFoto(:,:, i), 1);
end
c_chica=size(mFoto,1)*size(mFoto, 2)*8;
imwrite(f_chica, 'foto_escondida.bmp');
imshow('foto_escondida.bmp');