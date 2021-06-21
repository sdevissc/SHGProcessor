

Ha=fitsread("D:\testmardi\Ha16__2021-06-14_T_17-01-43-0825_L.fit");
Ha=Ha/max(Ha(:));
Hap=fitsread("D:\testmardi\Ha16__2021-06-14_T_17-01-43-0825_L+6.fit");
Hap=Hap/max(Hap(:));
Ham=fitsread("D:\testmardi\Ha16__2021-06-14_T_17-01-43-0825_L-6.fit");
Ham=Ham/max(Ham(:));

% subplot(4,3,1)
% imagesc(Ha/max(Ha(:)))
% colormap(gray)
% title("H\alpha")
% axis image;
% 
% subplot(4,3,2)
% imagesc(Hap5/max(Hap5(:)))
% axis image;
% title("H\alpha +")
% colormap(gray)
% 
% subplot(4,3,3)
% imagesc(Ham5/max(Ham5(:)))
% axis image;
% title("H\alpha -")
% colormap(gray)

subplot(2,4,[1 5]);
colormap(gray)
raie=fitsread("D:\testmardi\check2.fit");
imagesc(raie(1:end,10:100))

subplot(2,4,[2 4]);
imagesc(cat(3, Ham, Ha, Hap))

axis image;
title("R=H\alpha +, G=H\alpha , B= H\alpha -")

subplot(2,4,[6 8]);
zgreenChannel = Ha/max(Ha(:));
zredChannel = Hap/max(Hap(:));
zblueChannel = Ham/max(Ham(:));

ROIy=1500:2100;
ROIx=3600:4600;

zHa = Ha(ROIy,ROIx);
zHap = Hap(ROIy,ROIx);
zHam = Ham(ROIy,ROIx);
imagesc(cat(3, zHam, zHa,zHap))
axis image;




% 
% subplot(2,1,2);
% imagesc((Hap3-Ham3));
% axis image;
% 
% %zlim([0.8 1.2]);