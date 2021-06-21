clear all

%myDir = 'C:\Users\simky\Downloads\Sun_104633\Sun_104633_FITS\converted';

%myDir = 'D:\testmardi\TiffSeq20210621_010633\Ha16__2021-06-14_T_17-01-43-0825_L\converted'

fname ='data.json';
str = fileread(fname)
data = jsondecode(str);
myDir=data.rootdir;

myFiles = dir(fullfile(myDir,'corrected_*.tif'));

baseFileName = myFiles(1).name;
fullFileName = fullfile(myDir, baseFileName);
fr=imread(fullFileName);

bestFrame=0;
highestMean=-10;
for k = 1:length(myFiles)
    if mod(k,100)==0
        disp(k)
    end
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    fr=imread(fullFileName);
    thismean=mean(fr(:));
    if(thismean>highestMean)
        bestFrame=k;
        highestMean=thismean;
    end
end

baseFileName = myFiles(bestFrame).name;
fullFileName = fullfile(myDir, baseFileName);
fr=imread(fullFileName);
imagesc(fr);
xold = 0;
yold = 0;
k = 0;
hold on;
[xi, yi] = ginput(1);      % get a point
xi=floor(xi)
hold off



for k = 1:length(myFiles)
    disp(k)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    fr=imread(fullFileName);
    u=1;
    for c=xi-5:xi+5 % wav
        cube(:,k,u)=fr(:,c);
        u=u+1;
    end
end
