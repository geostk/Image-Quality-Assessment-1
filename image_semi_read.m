function [ ff ] = image_semi_read( folder_name )
%This function takes the folder name as the input, and return the Cell , Where it contains data of image name and its respective feature vector. 

% Feature Vector Depends on the respective implementations. That has to be
% changed in Process_image function. 

% This Function calls Process_image, that takes image as input, and returns
% the feature Vector. 

da = dir(strcat(folder_name,'/*.JPG'));
[l,m]= size(da);
i=3;
ff={};
while(i<=l)
    pic_name = strcat(folder_name,'/',da(i).name);
    disp(pic_name);
    im=imread(pic_name);
    ff{i-2}.pic_name = pic_name ;
    ff{i-2}.data = Process_image( im );
    i=i+1;
end

end

