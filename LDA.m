function l = LDA(X,y,K)
%% Returns LDA object
%
N = size(y,1);
numVariables = length(X(1,:));

sigma = zeros(numVariables);
mu = zeros(K,numVariables);
p = zeros(K,1);
h = waitbar(0,'Training...');
for k = 1:K
    waitbar(k/K,h)
    X_k = X(y == k,:);
    mu(k,:) = mean(X_k);
    p(k) = size(X_k,1)/N;
    X_k_bar = X(y == k,:) - ones(size(X_k,1),1)*mean(X_k);
    sigma = sigma + 1/(N-K)*((X_k_bar)'*(X_k_bar));
end
close(h)
l = struct('sigma',sigma,'mu',mu,'pi',p,'K',K); %LDA object