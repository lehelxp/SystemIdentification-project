clear all
clc
load('iddata-19');
plot(id.u);hold on
plot(id.y,'r');
legend('Input signal','Output');
m=input('Grade of the polynomial:');
na=input('na=');
nb=input('nb=');
[yhat, yhats,teta, msep, mses]=my_arx(na,nb,m,id,val);
figure
plot(yhat);hold
plot(val.y,'r');
title('One-step-ahed prediction');
legend('Approximated output','Real Output');
figure
plot(yhats);hold
plot(val.y,'r');
