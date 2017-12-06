function [ out ] = svmimpl( train_good,train_bad,test_good,test_bad )
%SVMIMPL Summary of this function goes here
%   Each input variable , is a cell, contaiing the feaure vector. This
%   code, reads the feature vectors and returns the confusion matrix,
%   accuracy. 

[dummy,train_g_length]=size(train_good);
[dummy,train_b_length]=size(train_bad);

[dummy,test_g_length]=size(test_good);
[dummy,test_b_length]=size(test_bad);


confusion_mat=zeros(2,2);

[dummy,i_b]=size(train_good{1}.data);

svm_data_x=zeros(train_g_length+train_b_length,i_b);
svm_data_y=zeros(train_g_length+train_b_length,1);


svm_test_x=zeros(test_g_length+test_b_length,i_b);
svm_test_y=zeros(test_g_length+test_b_length,1);

disp(size(svm_data_x));



i=1;
count=1;
while(i<=train_g_length)
    svm_data_x(count,:)=train_good{i}.data;
    svm_data_y(count,1)=1;
    count=count+1;
    i=i+1;
end

i=1;

while(i<=train_b_length)
    svm_data_x(count,:)=train_bad{i}.data;
    svm_data_y(count,1)=0;
    count=count+1;
    i=i+1;
end


i=1;
count=1;
while(i<=test_g_length)
    svm_test_x(count,:)=test_good{i}.data;
    svm_test_y(count,1)=1;
    count=count+1;
    i=i+1;
end

i=1;
while(i<=test_b_length)
    svm_test_x(count,:)=test_bad{i}.data;
    svm_test_y(count,1)=0;
    count=count+1;
    i=i+1;
end



svm_data_x=sparse((svm_data_x));
svm_test_x=sparse((svm_test_x));
disp('OK');
disp(size(svm_data_x));

model_linear = train(svm_data_y, svm_data_x,'-c 1');

disp('OK');
disp(size(svm_test_x));

[predict_label_L, accuracy_L, dec_values_L] = predict(svm_test_y, svm_test_x, model_linear);

out={};
out{1}=svm_test_y;
out{2}=predict_label_L;
out{3}=accuracy_L;
out{4}=dec_values_L;

conf_matrix=zeros(2,2);

i=1;
while(i<length(svm_test_y))
    
    l1=svm_test_y(i,1);
    l2=predict_label_L(i,1);
    conf_matrix(l1+1,l2+1)=conf_matrix(l1+1,l2+1)+1;
    i=i+1;
end

out{5}=conf_matrix;

disp('OK');


end



