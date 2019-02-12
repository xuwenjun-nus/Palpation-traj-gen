clear all
close all
clc
addpath(genpath('gmm_lib/.'))  
load('JG.mat')
fv_x=[]; fv_y=[];
for i=1:6
    
    for j=1:length(E_cell{i})-3
       fv_x= [fv_x;E_cell{i}(j:j+2)'];
       fv_y=[fv_y;(x_cell{i}(j+3)-x_cell{i}(j+2)),(y_cell{i}(j+3)-y_cell{i}(j+2))];
    end
end
Data=[fv_x';fv_y'];

% apply GMM
model.nbStates = 11; %Number of states in the GMM
model.nbVar = 5; %Number of variables [e1 e2 e3 x y]
model = init_GMM_kmeans(Data, model);
model = EM_GMM(Data, model);
% [DataOut, SigmaOut] = GMR(model, [1:nbData]*model.dt, 1:3, 4:model.nbVar); %see Eq. (17)-(19)

% plot GMM
figure('position',[10,10,1300,500]); 
%Plot GMM
% subplot(1,2,1);
hold on; axis off; title('GMM');
plot(Data(4,:),Data(5,:),'.','markersize',8,'color',[.5 .5 .5]);
plotGMM(model.Mu(4:model.nbVar,:), model.Sigma(4:model.nbVar,4:model.nbVar,:), [.8 0 0], .5);


% GMR
stiff1=[]; stiff2=[];
for i=1:6
   stiff1= [stiff1;E_cell{i}(1:50)];
   stiff2=[stiff2;E_cell{i}(51:end)];
end
[mu1,sigma1] = normfit(stiff1);
[mu2,sigma2] = normfit(stiff2);

% apply GMR to a simulated tissue
StiffMatrix=zeros(100,50);
Xc=60;
Yc=15;
for n=1:100
    for m=1:50
%         if ((n-Xc)^2+(m-Yc)^2<=10)
%             RewardMatrix(n,m)=5;
        if ((n-Xc)^2+(m-Yc)^2<=100) 
            StiffMatrix(n,m)=normrnd(mu1*2, sigma2);
        else
             StiffMatrix(n,m)=normrnd(mu1,sigma1);
        end
        
    end 
end 
% plot tissue 
[X,Y] = meshgrid(1:1:100,1:1:50);
figure
surf(X,Y,StiffMatrix');
%%
%generated traj by gmr
gen(:,1:3)=floor([5.63326666666665,12.0550000000000,17.2196000000000;...
    1.33960000000001,0.640266666666677,4.87446666666667]);
gen(1,1:3)=floor(rand(3,1)*99+1);
gen(2,1:3)=floor(rand(3,1)*49+1);
E1=StiffMatrix(gen(1,1),gen(2,1));
E2=StiffMatrix(gen(1,2),gen(2,2));

E3=StiffMatrix(gen(1,3),gen(2,3));
E(:,1)=[E1;E2;E3];
i=1;
while(1)
    
    [DataOut, SigmaOut] = GMR(model, E(:,i), 1:3, 4:model.nbVar);
    gen=[gen,floor(gen(:,end)+DataOut)];
    flag1=gen(1,i+3)<=100 && gen(1,i+3)>0;
    flag2=gen(2,i+3) <=50 && gen(2,i+3)>0;
    if(flag1 && flag2)
        E1=StiffMatrix(gen(1,i+1),gen(2,i+1));
        E2=StiffMatrix(gen(1,i+2),gen(2,i+2));
        E3=StiffMatrix(gen(1,i+3),gen(2,i+3));
        E=[E,[E1;E2;E3]];
        i=i+1;
   
    else
      
        genx=floor(rand(1,1)*99+1);
        geny=floor(rand(1,1)*49+1);
        gen(1,i+3)=genx;
        gen(2,i+3)=geny;
        E1=StiffMatrix(gen(1,i+1),gen(2,i+1));
        E2=StiffMatrix(gen(1,i+2),gen(2,i+2));

        E3=StiffMatrix(genx,geny);
         E=[E,[E1;E2;E3]];
         i=i+1;
        
    end
    if(length(E)>200)
        break;
    end
end

 figure 
 % plot generated traj
  xt =gen(1,3:end)
    yt =gen(2,3:end)
    yt(end) = NaN;
    c = E(1,:);
    patch(xt,yt,c,'EdgeColor','interp','Marker','o','MarkerFaceColor','flat');
    colorbar;
    xlabel('X(mm)')
    ylabel('Y(mm)')
