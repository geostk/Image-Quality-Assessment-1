clc;
clear all;
close all;


% Code Starts here. 

% Flow: 

%Image_read = > Image_semi_read = > Process_image.

%This script, Collects the feature vectors for Training, Testing, Data. 

% Calls image_semi_read function, withe the path to the folder containing
% images. Return type is a Cell, Where it contains information of imagename and the
% respective feature vector.

%%TG : Training => Good Quality Images. , Path to the Folder => ./data/TG. Folder contains the good quality images.  
TG=image_semi_read('data/TG');
save('Train_Good','TG');

%%TB : Training => Bad Quality Images. , Path to the Folder => ./data/TB . Folder contains the Bad quality images 
TB=image_semi_read('data/TB');
save('Train_Bad','TB');

%%SG : Testing Set => Good Quality Images. , Path to the Folder => ./data/SG. Folder contains the good quality images 
SG=image_semi_read('data/SG');
save('Test_Good','SG');

%%SB : Testing Set => Bad Quality Images. , Path to the Folder => ./data/TG. Folder contains the good quality images 

SB=image_semi_read('data/SB');
save('Test_Bad','SB');

%% Once the TG, TB,SG,SB are obtained, these are given input to svmimpl code. 