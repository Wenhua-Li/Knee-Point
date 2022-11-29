function [knee,Extreme]=find_knee(pop,rate)

% n=100;

PopObj=pop.objs;
[n,M]=size(PopObj);
Current=1:n;

%% ȷ�����ڴ�С

% Find the extreme points
[~,Rank]   = sort(PopObj(Current,:),'descend');
Extreme    = zeros(1,M);
Extreme(1) = Rank(1,1);
for j = 2 : length(Extreme)
    k = 1;
    Extreme(j) = Rank(k,j);
    while ismember(Extreme(j),Extreme(1:j-1))
        k = k+1;
        Extreme(j) = Rank(k,j);
    end
end
EdgePoints = sort(PopObj(Current(Extreme),:));
WinSize = sum((EdgePoints(end,:)-EdgePoints(1,:)).^2);
WinSize = 0.04*WinSize.^0.5*M;
% WinSize = 1.1*(1-exp(-M*rate));
% WinSize =1;

% ����hyperplane
Hyperplane = PopObj(Current(Extreme),:)\ones(length(Extreme),1);
% �������
Distance(Current) = -(PopObj(Current,:)*Hyperplane-1)./sqrt(sum(Hyperplane.^2));
dis=Distance;

%% Ѱ�Ҿֲ����ֵ
index=[];
for i=1:1:n
    tmpresult=[];
    tmpdis=[];
    for j=1:1:n
        newdis =  sum((PopObj(i,:)-PopObj(j,:)).^2);
        newdis = newdis^0.5;
        if newdis<WinSize
            tmpresult=[tmpresult j];
            tmpdis=[tmpdis newdis];
        end
    end
    
    if max(dis(tmpresult))<=dis(i)
        if numel(index)==0
            index=i;
        else
            index=[index i];
        end
    end
end

knee=[index];
% num = numel(index);