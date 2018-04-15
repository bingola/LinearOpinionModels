clc
clear all
dV={'Twitter','VTwitter','GTwitter','MlargeTwitter','STwitter','Reddit'};
thV=[0.3 0.3 0.1 0.1 0.017 0.1];
for i=1:6
    s=0;
    for tW=[95 90 80 60 50]
        s=s+1;
        for rI=[1]
%                eval(['load ../realDataOut/Learned_',dV{i},'_',num2str(tW),'_',num2str(1),'_',num2str(1),'_',num2str(3),'_x']);
%                a(i,s)=min(graphxData.errorx);
%                b(i,s)=min(graphxData.qevx);
               
% PLM
                eval(['load ../realDataOut/LearnedPer_',dV{i},'_',num2str(tW),'_',num2str(rI),'_',num2str(2),'_x']);
%                
                 a(i,s)=min(graphxData.errorx);
                 b(i,s)=min(graphxData.qevx);

        end
    end
end
 