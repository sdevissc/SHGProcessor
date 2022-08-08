classdef Utils
    properties
        corr;
        limup=0;
        limdown=0;
        limleft=0;
        limright=0;
        tr_HF;
        xi;
    end
    methods
        function out = SHGpreProcess(this,myDir,isFirst,TransveraliumBlur,destDir)
            disp('test');
            %This code aims at the processing of spectroheliography sequences, i.e.
            %produce sun map(s) in given wavelength(s) from the initial spectral tif sequence.
            sfact=15;

            myFiles = dir(fullfile(myDir,'*.tif'));
            C = natsortfiles({myFiles.name});

            if(isFirst==1)

                bestFrame=0;
                highestMean=-10;
                for k = 1:numel(C)%length(myFiles)
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
                this.tr_HF=tr./tr_LF;


                disp('Define the lines fitting limits')
                froi = drawrectangle('StripeColor','y');

                disp('Define the final wav range to process')
                proi = drawrectangle('SelectedColor','g');

                %%

                this.limup=round(froi.Position(2)); %Upper limit for line fitting
                this.limdown=round(froi.Position(2)+froi.Position(4)); % Lower limit for line fitting
                this.limleft=round(proi.Position(1)); % Left limit for image skimming
                this.limright=round(proi.Position(1)+proi.Position(3)); %Right limit for image skimming
                frame_skimmed=frame_orig(1:end,this.limleft:this.limright);
                frame=imresize(frame_skimmed,[size(frame_skimmed,1),sfact*size(frame_skimmed,2)]);
                tic
                %CALCUL SMILE%%%%%%%%%%%%%%%%

                counter=1;
                for i=this.limup:this.limdown
                    x(counter)=i;
                    [ minXH(counter) ,px(counter)] =min(frame(i,:));
                    counter = counter + 1;
                end

                format long
                p = polyfit(x,px,2)
                f= polyval(p,x);


                disp('isFirst=1 ---> write the corr fitting parametetr to a textfile.')
                fid=fopen('corr.txt','w')
                value = p;
                jsonencode(value);
                s = struct("p1",p(1), "p2", p(2),"p3",p(3));
                encodedJSON = jsonencode(s);
                fprintf(fid, encodedJSON);

                f2 = polyval(p,1:size(frame,1));
                shifted = zeros(size(frame));

                for i=1:size(frame,1)
                    this.corr(i)=round(f2(i)-min(f2));
                end
            end


            str = fileread('corr.txt')
            data = jsondecode(str);
            p(1)=data.p1;
            p(2)=data.p2;
            p(3)=data.p3;

            myFiles = dir(fullfile(myDir,'*.tif'));

            for k = 1:numel(C)
                if mod(k,100)==0
                    disp(k)
                end
                baseFileName = C{k};
                fullFileName = fullfile(myDir, baseFileName);
                fr=imread(fullFileName);
                fr =  imrotate( fr , -90 );
                fr=fr(1:end,this.limleft:this.limright);
                fr=imresize(fr,[size(fr,1),sfact*size(fr,2)]);
                for i=1:size(fr,1)
                    frame_corr(i,1:size(fr,2)-this.corr(i))=fr(i,1+this.corr(i):size(fr,2));
                end
                frame_corr=imresize(frame_corr,[size(frame_corr,1),size(frame_corr,2)/sfact]);
                frame_corr=uint16(double(frame_corr)./this.tr_HF);
                imwrite(frame_corr,fullfile(destDir,strcat('corrected_',baseFileName)));
            end
            disp('done')
            toc
        end

        function out2 = SHGMapper(this,myDir,isFirst,destDir,name)

            myFiles = dir(fullfile(myDir,'corrected_*.tif'));
            C = natsortfiles({myFiles.name});
            baseFileName = myFiles(1).name;
            fullFileName = fullfile(myDir, baseFileName);
            fr=imread(fullFileName);
            if(isFirst==1)
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
                this.xi=floor(xi);
                hold off

            end
            for k = 1:numel(C)
                disp(k)
                baseFileName = C{k};
                fullFileName = fullfile(myDir, baseFileName);
                fr=imread(fullFileName);
                u=1;
                for c=this.xi-8:this.xi+8 % wav
                    cube(:,k,u)=fr(:,c);
                    u=u+1;
                end
            end
            for u=1:size(cube,3)
                filename=sprintf('%s_layer%d.png',name,u);
                imwrite(cube(:,:,u),strcat(destDir,'\/',filename));
            end

        end

    end
end
