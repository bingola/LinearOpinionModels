clc
clear all
dataset='Reddit';
opinionFile=strcat('../RawGraphs/',dataset,'/opinion.txt');
nodeFile=strcat('../RawGraphs/',dataset,'/nodelist.txt');
edgeFile=strcat('../RawGraphs/',dataset,'/edgelist.txt');

A=dlmread(opinionFile);
time=A(:,2);
tweetcnt=A(:,3);
t0=min(time);
t1=max(time);
L=20;


Ax=dlmread(nodeFile);
Edgex=dlmread(edgeFile);
Tweetx=dlmread(opinionFile);

Adj(max(size(Ax)),max(size(Ax)))=0;
for i=1:max(size(Edgex))
    v1=Edgex(i,1);
    v2=Edgex(i,2);
    s1=0;
    s2=0;
    for j=1:length(Ax)
        if s1==0
         if(Ax(j)==v1)
           s1=1;                 
           n1=j; 
         end
        end
        
        if s2==0
         if(Ax(j)==v2)
           s2=1;
           n2=j;
         end
        end
                 
    end
     
            Adj(n1,n2)=1;

end
T=Tweetx;
for i=1:max(size(Tweetx))
    v1=Tweetx(i,1);
    
    for j=1:length(Ax)
         if(Ax(j)==v1)
                             
           T(i,1)=j;
         end
                 
    end
end

for i=1:L+1
t(i)=t0+(i-1)*(t1-t0)/L;
end
t(1)=t(1)-1;
for i=1:length(t)-1
v1=find((time<=t(i+1)));
v2=find(time>t(i));
v=sort((intersect(v1,v2)));
% min(v)
Anew(v,1)=T(v,1);
Anew(v,2)=i;
z=tweetcnt(v);
Anew(v,3)=z;
end
% Anew(:,3)=Anew(:,3)./max(Anew(:,3));
om(L,max(size(Adj)))=0;

for i=1:max(size(Anew))
 om(Anew(i,2),Anew(i,1))=om(Anew(i,2),Anew(i,1))+tweetcnt(i);
end
for i=1:L
om(i,:)=om(i,:)/sum(om(i,:));
end
graphx.opMat=om;
graphx.adj=Adj;
eval(['save ../realDataOut/',dataset,'_graph graphx']);
% save L L
% save adj Adj
% save om om