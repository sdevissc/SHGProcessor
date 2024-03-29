function preProcess = SHGpreProcess(fname)
%This code aims at the processing of spectroheliography sequences, i.e.
%produce sun map(s) in given wavelength(s) from the initial spectral tif sequence.
sfact=15;

fname ='data.json';
str = fileread(fname)
data = jsondecode(str);
myDir=data.rootdir;
TransveraliumBlur=data.TransveraliumBlur;

destDir = strcat(myDir,'\converted')
if ~exist(destDir, 'dir')
    mkdir(destDir);
end

%myDir = 'C:\Users\simky\Downloads\Sun_104633\Sun_104633_FITS';
%myDir = 'D:\testmardi\TiffSeq20210621_010633\Ha16__2021-06-14_T_17-01-43-0825_L'
myFiles = dir(fullfile(myDir,'*.tif'));
C = natsortfiles({myFiles.name});
bestFrame=0;
highestMean=-10;
for k = 1:numel(C)%length(myFiles)
    if mod(k,100)==0
        disp(k)
    end
    baseFileName = C{k}
    fullFileName = fullfile(myDir, baseFileName);
    fr=imread(fullFileName);
    thismean=mean(fr(:));
    if(thismean>highestMean)
        bestFrame=k;
        highestMean=thismean;
    end
end

bestFrame

%%

baseFileName = C{bestFrame}
fullFileName = fullfile(myDir, baseFileName);

%%

frame_orig=imread(fullFileName);%:\Users\simky\Downloads\Sun_104633\out.fit');
frame_orig =  imrotate( frame_orig , -90 );
imshow(frame_orig);

%Transversalium calculation

tr=mean(frame_orig,2);
tr_LF= imgaussfilt(tr,TransveraliumBlur);
tr_HF=tr./tr_LF;



disp('Define the lines fitting limits')
froi = drawrectangle('StripeColor','y');

disp('Define the final wav range to process')
proi = drawrectangle('SelectedColor','g');

%%

limup=round(froi.Position(2)); %Upper limit for line fitting
limdown=round(froi.Position(2)+froi.Position(4)); % Lower limit for line fitting
limleft=round(proi.Position(1)); % Left limit for image skimming
limright=round(proi.Position(1)+proi.Position(3)); %Right limit for image skimming
frame_skimmed=frame_orig(1:end,limleft:limright);
frame=imresize(frame_skimmed,[size(frame_skimmed,1),sfact*size(frame_skimmed,2)]);
tic
%CALCUL SMILE%%%%%%%%%%%%%%%%

counter=1;
for i=limup:limdown
    x(counter)=i;
    [ minXH(counter) ,px(counter)] =min(frame(i,:));
    counter = counter + 1;
end

format long
p = polyfit(x,px,2)
f= polyval(p,x);


figure;
subplot(2,3,3)

hold off;

imagesc(frame)
axis image
hold on;
f2 = polyval(p,1:size(frame,1));
plot(f2,1:size(frame,1),'r-')
shifted = zeros(size(frame));

for i=1:size(frame,1)
    corr(i)=round(f2(i)-min(f2));
    for j=1:size(frame,2)
        shifted(i,j)=frame(i,min(size(frame,2),j+corr(i)));
    end

end
imagesc(shifted)

subplot(2,3,[4 6])
plot(corr)



myFiles = dir(fullfile(myDir,'*.tif'));

for k = 1:numel(C)
    if mod(k,100)==0
        disp(k)
    end
    baseFileName = C{k};
    fullFileName = fullfile(myDir, baseFileName);
    fr=imread(fullFileName);
    fr =  imrotate( fr , -90 );
    fr=fr(1:end,limleft:limright);
    fr=imresize(fr,[size(fr,1),sfact*size(fr,2)]);
    for i=1:size(fr,1)
        frame_corr(i,1:size(fr,2)-corr(i))=fr(i,1+corr(i):size(fr,2));
    end
    frame_corr=imresize(frame_corr,[size(frame_corr,1),size(frame_corr,2)/sfact]);
    frame_corr=uint16(double(frame_corr)./tr_HF);
    imwrite(frame_corr,fullfile(destDir,strcat('corrected_',baseFileName)));
end
disp('done')
toc
end
