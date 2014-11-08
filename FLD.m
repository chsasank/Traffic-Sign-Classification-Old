function f = FLD(X,y,K,m)
%% Returns FLD object
%
N = size(y,1);
numVariables = length(X(1,:));

sigmaW = zeros(numVariables);
mu = zeros(K,numVariables);
p = zeros(K,1);
h = waitbar(0,'Training...');
for k = 1:K
    waitbar(k/K,h)
    X_k = X(y == k,:);
    mu(k,:) = mean(X_k);
    p(k) = size(X_k,1)/N;
    X_k_bar = X(y == k,:) - ones(size(X_k,1),1)*mean(X_k);
    sigmaW = sigmaW + (X_k_bar)'*(X_k_bar);
end
mu_bar =  mu - ones(size(mu,1),1)*mean(X);
sigmaB = mu_bar'*diag(p*N)*mu_bar;
[W,D] = eigs(sigmaB,sigmaW,m);
W = W./(ones(size(W,1),1)*sqrt(sum(W.^2)));
close(h)
f = struct('W',W,'sigmaB',sigmaB,'sigmaW',sigmaB,'K',K,'dataBase',X*W);