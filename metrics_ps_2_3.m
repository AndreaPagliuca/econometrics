%NAME: ANDREA PAGLIUCA
%DATE: 31/10/2023
%SUBJECT: ECONOMETRICS
%PS2 EXE 3

clear;

%PARAMETERS

n=300;
big_J= 20;
risk_sim = zeros(21, 1); % simulation risk
risk_lim = zeros(21, 1); % risk measure limit 



%CYCLE OVER DIFFERENT VALUES OF p
for j = 0:big_J
    p = 100 + 30*j;
    gamma = p/n;

    % True regression model
    beta = ones(p,1); % I choose it in this way
    X = randn(n, p);
    e = randn(n, 1);
    Y = X* beta + e;

    if n >= p % OLS regression
        risk_lim(j+1, 1) = gamma / (1 - gamma);
        
        % Risk = Bias + Var
        bias = 0;
        var = inv(X' * X);
        risk_sim(j+1, 1) =  bias + trace(var);
    
    else % p > n: MOORE PENROSE pseudo-INVERSE
        risk_lim(j+1, 1) = beta' * beta * (gamma - 1) / gamma + 1 / (gamma - 1);

        % Risk = Bias + Var
        [V, D] = eig(X' * X); % eigenvectors (V) and diagonalized matrix
        lambda = diag(D); %eigenvalues

        % Bias
        PI = zeros(p, p);
        for i = (n+1):p
            PI = PI + V(:, (p+1-i)) * V(:, (p+1-i))';
        end
        bias = beta' * PI * beta;

        % Var
        XX_penrose = zeros(p, p);
        for i = 1:n
            XX_penrose = XX_penrose + (1 / lambda(p+1-i)) * V(:, (p+1-i)) * V(:, (p+1-i))';
        end
        var = trace(XX_penrose);
        % Risk
        risk_sim(j+1, 1) = bias + var;


        disp(['gamma: ', num2str(gamma)]);
        disp(['Risk term 1: ', num2str(beta' * beta * (gamma - 1) / gamma)]);
        disp(['Risk term 2: ', num2str(1 / (gamma - 1))]);
        disp(['Bias: ', num2str(bias)]);
        disp(['Var: ', num2str(var)]);

      
    end
end

plot(risk_sim)
hold
plot(risk_lim)







