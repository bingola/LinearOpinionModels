clc
clear all
dV={'Twitter','VTwitter','GTwitter','MlargeTwitter','STwitter','Reddit'};
thV=[0.3 0.3 0.1 0.1 0.017 0.1];
for i=1:6
for tW=[95 90 80 60 50]
    for rI=[1]
        InferOpinionAFinalTrainingTestAperiodic(dV{i},tW,rI,thV(i))
    end
end
end