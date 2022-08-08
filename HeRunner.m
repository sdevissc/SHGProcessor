clear all;
fname ='data.json';
str = fileread(fname)
data = jsondecode(str);
myDir=data.rootdir;
rootname=data.rootname
d=dir(myDir)

u=Utils;
%%
TransveraliumBlur=data.TransveraliumBlur;
%%Produce the corrected spectra 

isFirst=1;
for i=1:length(d)
    if(d(i).isdir && ~ismember({d(i).name},{'.','..'}))
        disp(strcat(d(i).name,' is ok'));
        currentDir=strcat(myDir,'\/',d(i).name);
        destDir = strcat(currentDir,'\/converted')
        if ~exist(destDir, 'dir')
            mkdir(destDir);
        end
        u.SHGpreProcess(currentDir,isFirst,TransveraliumBlur,destDir);
        isFirst=0;
    end
    

end


%% Produce the maps

isFirst=1;
for i=1:length(d)
    if(d(i).isdir && ~ismember({d(i).name},{'.','..'}))
        disp(strcat(d(i).name,' is ok'));
        currentDir=strcat(myDir,'\/',d(i).name,'\/converted');
        destDir = strcat(currentDir,'\/cubes')
        if ~exist(destDir, 'dir')
            mkdir(destDir);
        end
        u.SHGMapper(currentDir,isFirst,destDir,d(i).name);
        isFirst=0;
    end
    

end
