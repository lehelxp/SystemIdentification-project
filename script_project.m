clc
clear all
load('proj_fit_14');
%load the input data 
mesh(id.X{1},id.X{2},id.Y');
%mesh the input data
m=input('grade of polynomial m=');
%user choice given degree of the polynomial used for approximating the
%unknown function
for i=1:m
    %computation of the mean sqaured error for both datasets(id,val)
   [MSEi(i,1) yhati{i}]=proj_approx(i,id);
   [MSEv(i,1) yhatv{i}]=proj_approx(i,val);
end
[mMsev poz]=min(MSEv);%choose the best mean squared error and the grade of polynomial for this MSE
figure
plot(MSEi(:,1))
hold
plot(MSEv(:,1))
title('MSE comparison between identification and validation');
legend('Identification','Validation');
Yhat=reshape(yhatv{poz},val.dims);%Reshape the yhat vector in order to obtain the matrix for the mesh
figure
mesh(val.X{1},val.X{2},Yhat');
title(['the best approximation is for grade=',num2str(poz),' and MSE=',num2str(mMsev)]);