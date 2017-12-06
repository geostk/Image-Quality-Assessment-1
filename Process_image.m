function [ d ] = Process_image( im )
%PROCESS_IMAGE Summary of this function goes here

%% This function Uses 
% 1. create_mask : Create the fundus mask of the image. 
% 2. cnn_imagenet_minimal : Takes a 224x224 size image as input and returns
% the feature vector. 
% 3. logsample:  Compute log-polar transform of image

%%

% This function takes image as input and returns the feature vector as
% output. 

%% Step 1: Mask Creation, Followed by fundus extension, 

mask = create_mask(im ,10);
im = extension(im,mask);

%% Step2: Bounding Box around the mask will be taken and the fundus extension image is cropped. Need for doing this : A Bounding Box around a circle
% would be a square, so patch will be a near square. 

s = regionprops(mask, 'BoundingBox' );
patch = im(round(s(1).BoundingBox(2):s(1).BoundingBox(2)+s(1).BoundingBox(4)),round(s(1).BoundingBox(1):s(1).BoundingBox(1)+s(1).BoundingBox(3)),:);

%% Step3: Resizing the patch: , As the CNN takes a fixed size image as a input i,e 224X224 image as input. We resized the image 672X672,
 
main_size = 224 ;
ac = 3 * main_size;
am = 2;
im = imresize( patch,[ac,ac]);
disp(size(im));

start=0;
limit = ac/2;
factor = 4 ;
interval = limit / factor;
endi = start  + interval;
img_data={};
count=1;

%% Step4 : This loop here, Calls the circular_patch function, with different start,endi vars. These help in generating the concentric circular patches. 
while(endi <= limit)    
    
    rr=start;
    if rr==0 
        rr = 1;
    end
    
    %Logsample code, takes image as input, center of the image, start - end
    %radius of the patch. Logsample function is documented. 
    circular_extended = logsample(im,rr,endi,ac/2,ac/2,360,360);
    
    % Output of Logsample is resized to 448x448 image. 
    circular_extended = imresize( circular_extended,[2*main_size,2*main_size]);
    img_data{count} = circular_extended;
    count = count + 1;
    start = endi;
    endi = start+interval;
end

% At the end of this loop, we get img_data cell , with 4 448x448 sized
% images. 
%% Step 5: Now we have 4 448x448 images each representing a concentric patch. 
% So for each 448x448 image, we divide the image into 4 cells, into a 2x2 grid,
% So Each 448x448 image => 4 cells of 224x224 image. 
% Each of this 224x224 image is given input to cnn_imagenet_minimal
% function, it returns a feature vector. , Later we concat the feature
% vector of all the images, into a single vector. 

d = [];

uu =1;
while(uu<=length(img_data))

    im = img_data{uu};
    i=1;
    while(i<=am)
        j=1;
        while(j<=am)
            patch = im( (i-1)*main_size + 1 : i*main_size , (j-1)*main_size + 1 : j*main_size ,: );
            data = cnn_imagenet_minimal(patch);
            data = data(:);
            data = data';
            d=[d,data];
            j=j+1;
        end
        i=i+1;
    end
    uu=uu+1;
end

end

