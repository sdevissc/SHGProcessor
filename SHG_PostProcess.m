clear all

fname ='data.json';
str = fileread(fname)
data = jsondecode(str);
myDir=strcat(data.rootdir,'\converted');

myFiles = dir(fullfile(myDir,'corrected_*.tif'));
C = natsortfiles({myFiles.name});
baseFileName = myFiles(1).name;
fullFileName = fullfile(myDir, baseFileName);
fr=imread(fullFileName);

bestFrame=0;
highestMean=-10;
for k = 1:numel(C)
    if mod(k,100)==0
        disp(k)
    end
    baseFileName = C{k};
    fullFileName = fullfile(myDir, baseFileName);
    fr=imread(fullFileName);
    thismean=mean(fr(:));
    if(thismean>highestMean)
        bestFrame=k;
        highestMean=thismean;
    end
end

baseFileName = C{bestFrame};
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



for k = 1:numel(C)
    disp(k)
    baseFileName = C{k};
    fullFileName = fullfile(myDir, baseFileName);
    fr=imread(fullFileName);
    u=1;
    for c=xi-8:xi+8 % wav
        cube(:,k,u)=fr(:,c);
        u=u+1;
    end
end
