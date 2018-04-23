function [ yhat, yhats,theta, MSEp, MSEs] = my_arx( na,nb,m,id,val)
b=m+1;
dimr=b^(na+nb);
dimc=na+nb;
W=zeros(dimr,dimc);
for j=dimc:-1:1
    i=2;
    d=1;
    while i<=dimr
        if W(i-1,j)<m && j==dimc
            W(i,j)=W(i-1,j)+1;
        elseif mod(d,b^(dimc-j))>0 && j<dimc
            W(i,j)=W(i-1,j);
            d=d+1;
        elseif mod(d,b^(dimc-j))==0 && j<dimc && W(i-1,j)<m
            W(i,j)=W(i-1,j)+1;
            d=1;
        elseif mod(d,b^(dimc-j))==0 && j<dimc && W(i-1,j)==m
            W(i,j)=0;
            d=d+1;
        end
        i=i+1;
    end
end
for j=1:dimc
    i=1;
    while i<=length(W)
        Wa(i+(j-1)*length(W),j)=W(i,j)+1;
        Wa(i+(j-1)*length(W),(j+1):dimc)=W(i,(j+1):dimc);
        if j>1
            Wa(i+(j-1)*length(W),1:j-1)=W(i,1:j-1);
        end
        i=i+1;
    end
end

l=length(Wa);
i=1;
while i<=l
    if(sum(Wa(i,:))>m+1)
        Wa(i,:)=[];
        l=l-1;
    else
        i=i+1;
    end
end
Wb=unique(Wa,'rows','stable');
d=zeros(length(id.u),dimc);
for i=2:length(id.u)
    for j=1:dimc
        if((i-j)<=0) && (i-j+na<=0)
            d(i,j)=0;
        elseif(j<=na) &&((i-j)>0)
            d(i,j)=-id.y(i-j);
        elseif(j>na) 
            d(i,j)=id.u(i-j+na);
        end
    end
end
for i=1:length(id.u)
    for k=1:length(Wb)
            phi(i,k)=prod(d(i,:).^Wb(k,:));
    end
end
theta=phi\id.y;
for i=2:length(val.u)
    for j=1:dimc
        if((i-j)<=0) && (i-j+na<=0)
            dh(i,j)=0;
        elseif(j<=na) &&((i-j)>0)
            dh(i,j)=-val.y(i-j);
        elseif(j>na) 
            dh(i,j)=val.u(i-j+na);
        end
    end
end
for i=1:length(val.u)
    for k=1:length(Wb)
            phiv(i,k)=prod(dh(i,:).^Wb(k,:));
    end
end
yhat=phiv*theta;
MSEp=(sum(yhat-val.y)^2)/length(val.y);
yhi=zeros(length(id.u),na+nb);
yhats(1)=0;
for i=2:length(id.u)
    for j=1:na+nb
        if((i-j)<=0) &&(i-j+na<=0)
            yhi(i,j)=0;
        elseif(j<=na) &&((i-j)>0)
            yhi(i,j)=yhats(i-j);
        elseif(j>na)
            yhi(i,j)=id.u(i-j+na);
        end
    end
    for l=1:length(id.u)
    for k=1:length(W)
            yhit(l,k)=prod(yhi(l,:).^W(k,:));
    end
    end
    yhats(i,1)=phi(i,:)*theta;
end
MSEs=(sum(yhats-val.y)^2)/length(val.y);
end

