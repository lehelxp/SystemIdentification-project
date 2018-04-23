function [ MSE yhat ] = proj_approx(Grade,data)
%this function is used for computing the MSE and the approximated output of
%the system based on the datasets and the polinomial degree
N=length(data.Yflat);
%determine the number of rows of the phi matrix
phi(1:N,1)=1;%the first column is always filled with 1
j=2;n=1;%initializing the column and row
while n<=Grade
%generating the x^1...x^n powers
    for i=1:N
        if mod(j,2)==0%choose the position for x1 or x2 depending on the index of the column
        phi(i,j)=data.Xflat(1,i)^n;
        else
        phi(i,j)=data.Xflat(2,i)^n;
        end
    end
    if mod(j,2)==1
        n=n+1;
    end
    j=j+1;
end
a=2;b=3;%a and b represents the x1 and x2 and their grades used below for multiplication
for i=j:sum(1:n)
 %generating the multiplications between the x1 and x2 variation based on
 %the degree(x1*x2,x1*x2^2...)
    for k=1:N
        phi(k,i)=phi(k,a)*phi(k,b);
    end
    if a+b<2*n-1%if the grade of the two x is smaller then the grade n than raise the x2 grade by one
            b=b+2;
    else%starts over and raise the x1 grade by one
            b=3;
            a=a+2;
    end
end
theta=phi\data.Yflat';%create the coefficients column vector
yhat=phi*theta;%create the approximated column vector
MSE=sum((yhat'-data.Yflat).^2)/N;%calculating the mean squared error for the given dataset
end