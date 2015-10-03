function [imgTemplate, imgTemplateFlat] = imseg(img, method, ParaSeg)
    % Segmentation program for medical image.
    % By Pengwei Wu.

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