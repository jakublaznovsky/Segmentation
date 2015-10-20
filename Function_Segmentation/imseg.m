function [imgTemplate, imgTemplateFlat] = imseg(img, method, ParaSeg)
    % Segmentation program for medical image.
    % By Pengwei Wu.

    if(strcmp(method, 'level_set_3_1'))
%         A possible parameter solution
%         ParaSeg = struct('booSmooth', 1, 'window', [0.015 0.023], 'iterOuter', ...
%             100, 'iterInner', 10, 'sigma', 2, 'thres', 0.024, 'num1', 0.016, 'num2', 0.017, ...
%             'timeStep', 0.1, 'muBase', 0.1, 'nuBase', 0.001, 'epsilon', 1, ...
%             'scale', 0.5, 'save', []);  
        imgBack = img;
        if(ParaSeg.booSmooth)
            img = smooth_2d(img, 2, 10);
        end    
        imgUnSeg = imadjust_ya(img, ParaSeg.window, 0); % [0.015 0.023]

        [M1, M2, M3] = imseg_levelset(imgUnSeg, ParaSeg, 1); %#ok<ASGLU>

        %% After level set

        logMussel = M < 0.5;
        logNotAir = imfill((M3 < 0.5), 'holes');
        logAir = ~logNotAir;
        logBone = (imgBack > ParaSeg.thres);
        logSoft = ones(size(img)) - logMussel - logAir;
        
        numPadding1 = ParaSeg.num1;
        numPadding2 = ParaSeg.num2;

        imgTemplate = imgBack .* logAir + imgBack .* logBone + numPadding1 .* ones(size(imgBack)) ...
            .* logSoft + numPadding2 .* ones(size(imgBack)) .* logMussel; 

        imgTemplateFlat = imgBack .* zeros(size(imgBack)) + imgBack .* logBone + numPadding1 .* ones(size(imgBack)) ...
            .* logSoft + numPadding2 .* ones(size(imgBack)) .* logMussel; 
    end
    

    if(strcmp(method, 'load'))
        dir = ParaSeg.dir;
        name = ParaSeg.name;
        nameFlat = ParaSeg.nameFlat;
        load(strcat(dir, name));
        load(strcat(dir, nameFlat));
        if(~exist('imgTemplate', 'var'))
            error('The name of the loaded template has to be imgTemplae');
        end
        if(~exist('imgTemplateFlat', 'var'))
            warning(['You should also provide imgTemplateFlat']);
        end
    end

    if(strcmp(method, 'load_supp'))
        dir = ParaSeg.dir;
        name = ParaSeg.name;
        nameFlat = ParaSeg.nameFlat;
        load(strcat(dir, name));
        load(strcat(dir, nameFlat));
        if(~exist('imgTemplate', 'var'))
            error('The name of the loaded template has to be imgTemplae');
        end
        if(~exist('imgTemplateFlat', 'var'))
            warning(['You should also provide imgTemplateFlat']);
        end
        logAir = img > (ParaSeg.suppThres);
        imgTemplate(logAir) = img(logAir) + ParaSeg.suppAdd;
        imgTemplateFlat(logAir) = img(logAir) + ParaSeg.suppAdd;
    end



end