function []=InferOpinionAFinalTrainingTestPeriodic(Dataset,trainingWidth,regValIdx,thr)
 regValv=[0 1 10 100];
 regVal=regValv(regValIdx);
% clearvars -except Dataset training_type out window
regValIdx
eval(['load ../realDataSource/',Dataset,'_graph']);
L=20;
om=graphx.opMat;
Adj=graphx.adj;

out=floor(trainingWidth*L/100);
    
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
% dd=xk(:);
% sum(dd>0)
% sum(dd<0)
ik=1;

    for init=1:3
        initx=init;
      for final=init
         finalx=final;
        randlast=5;
        if init==final
          randlast=1;
        end
            for xx=1:randlast
              rx(xx,:) = randi([init final],1,L);
            end
           for xx=1:randlast 
                 r=rx(xx,:);
%                 Ak=1*Adj;
                if fl==1
                    Ak=0.001*Adj;
                end
                for i=1:n
                    Ak(i,:)=Ak(i,:)/sum(Ak(i,:)+1e-7);
                end
%                 k=1:100;
%                 t=1:100;
                for iter=1:20

                    a=0;
                    % Ak=Ak.*Adj;
                    for i=2:out

                        ti=r(i-1);
                        a=a+ti*(((Ak^(ti-1))*(xk(:,(i-1)))*(xk(:,(i-1)))'*(Ak^(ti))'+...
                            (xk(:,(i-1)))*(xk(:,(i-1)))'*(Ak^(ti))'*Ak^(ti-1)-2*(xk(:,(i-1)))*(xk(:,(i)))'*Ak^(ti-1)))+2*regVal*Ak;

                    end

                     g=0.5^5;

                    Ak=Ak-g*a/norm(a,'fro');
 
 
                end
                 
                 f=0; qe=0;
                 
%                  max(max(xk))
%                  min(min(xk))
                 xkq=xk-mean(mean(xk));
                 xkq(abs(xkq)<thr)=0;
                 for kk=out:L-1

                    Akx=(Ak.*Adj)^(r(kk));
                    x=xk;
                    x1=Akx*x;
                    j=kk;
                    f=(x(:,j+1)-x1(:,j))'*(x(:,j+1)-x1(:,j))+f;
                    x1kq=x1;
                    x1kq=x1kq-mean(mean(xk));
%                     [xkq(:,j+1) x1kq(:,j)]
                    
                    x1kq(xkq(:,j+1)==0,j)=0;
                    qe=sum(sign(xkq(:,j+1))~=sign(x1kq(:,j)))+qe;
%                     px(iter)=sqrt(f);
%                     erx=px(iter);
                 end
%                 xc(ik)=px(end);
%                 ik=ik+1;
                opMatActual{xx}=xk;
                adj_mat{xx}=Ak;
%                 sprintf('new')
                errorv(xx)=(sqrt(f)/(2*sqrt(n)))
                qev(xx)=(qe)/n
                randomseq(xx,:)=rx(xx,:);
                mat(xx)=norm(Ak);
%                 clear errorCost
%                 clear px
                % max(err)
           end
           graphxData.thr=thr;
           graphxData.Af=adj_mat;
           graphxData.errorx=errorv;
           graphxData.qevx=qev;
           graphxData.opMatx=opMatActual;
           graphxData.randomseq=randomseq;
           graphxData.matnorm=mat;
           eval(['save ../realDataOut/LearnedPer_',Dataset,'_',num2str(trainingWidth),'_',num2str(regValIdx),'_',num2str(initx),'_x graphxData']);
           clear errorv
           clear randomseq
           clear mat
           clear adj_mat;
    end
   end
 
