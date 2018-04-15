function []=InferOpinionA(Dataset,training_type,out,window)
% clc
% Dataset='Twitter';
% training_type='fixed';
% out=19;
% window=5;
clearvars -except Dataset training_type out window
eval(['load ../realDataOut/',Dataset,'_graph']);
L=20;
om=graphx.opMat;
Adj=graphx.adj;

    if strcmp(training_type,'fixed')
        fixedinit=out-window;
    end
    
    
    if strcmp(training_type,'all')
        fixedinit=1;
    end
%     if strcmp(Dataset,'Reddit')==1
%        load adjx
%        load Lx
%        load omx
%        fl=0;
%     end
%     if strcmp(Dataset,'Twitter')==1
%        load adj2
%        load L
%        load om2
%        fl=1;
%      end
    
om=om';
fl=1;

n=max(size(Adj));
 xk=om;
 Adj=sign(Adj+eye(n));
A=Adj;
for node=1:n
 for i=2:L-1
  if om(node,i)==0
      om(node,i)=om(node,i-1);
  end
 end
end
% l=max(max(om));
% om=om+max(max(om));
% om=0.5*om/max(max(om));

l1=max(max(om));
l2=min(min(om));


om=(2*om-(l1+l2))/(l1-l2);
xk=om;
 
ik=1;

for init=1:3
    init
    for final=init+1:3
         
        randlast=30;
        if init==final
          randlast=1;
        end
        for xx=1:randlast
          rx(xx,:) = randi([init final],1,20);
        end
for xx=1:randlast 
    xx
    r=rx(xx,:);
Ak=1*Adj;
if fl==1
    Ak=0.001*Adj;
end
for i=1:n
Ak(i,:)=Ak(i,:)/sum(Ak(i,:)+1e-7);
end
k=1:100;
t=1:100;
for iter=1:20
    
a=0;
% Ak=Ak.*Adj;
for i=1+fixedinit:out
    
    ti=r(i-1);
    a=a+ti*(((Ak^(ti-1))*(xk(:,(i-1)))*(xk(:,(i-1)))'*(Ak^(ti))'+(xk(:,(i-1)))*(xk(:,(i-1)))'*(Ak^(ti))'*Ak^(ti-1)-2*(xk(:,(i-1)))*(xk(:,(i)))'*Ak^(ti-1)));

end

 g=0.5^5;
 
Ak=Ak-g*a/norm(a,'fro');
Akx=(Ak.*Adj)^(r(out));
x=xk;
x1=Akx*x;
j=out;
f=(x(:,j+1)-x1(:,j))'*(x(:,j+1)-x1(:,j));
px(iter)=sqrt(f);

% if iter>1
%  if px(iter)>px(iter-1)
%     px(iter)=px(iter-1);
    erx=px(iter);
%     Ak=Mk;
%     break;
%  end
% end

% Mk=Ak;
 
end
xc(ik)=px(end);
ik=ik+1;
adj_mat(xx,:,:)=Ak;
sprintf('new')
errorv(xx)= (erx/(2*sqrt(n)))
randomseq(xx,:)=rx(xx,:);
mat(xx)=norm(Ak);
clear errorCost
clear px
% max(err)
end
clear Data
Data.Af=adj_mat;
Data.errorx=errorv;
Data.randomseq=randomseq;
Data.matnorm=mat;
eval(['save final_',num2str(window),'_',Dataset,'_',training_type,'_',num2str(out),'_',num2str(init),'_',num2str(final),' Data']);
clear errorv
clear randomseq
clear mat
clear adj_mat;
    end
end
 
