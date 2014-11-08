function y = classifyLDA(l,X)
%% Takes in LDA object 'l' and returns prediction for each row of 'X'
%
y = zeros(size(X,1),1);
K = l.K;
N = size(X,1);
sigmainv = inv(l.sigma);
delta = zeros(N,K); %each row correspods to a row in X
h = waitbar(0,'Classifying...');
for k = 1:K
    waitbar(k/K,h)
    delta(:,k) = X*sigmainv*l.mu(k,:)' - 1/2*l.mu(k,:)*sigmainv*l.mu(k,:)'+log(l.pi(k));
end
[~,y] = max(delta,[],2);
close(h)
