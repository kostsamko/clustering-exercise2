load data_country;

min_features_values = min(Countrydata);
max_features_values = max(Countrydata);
figure(1), hold on
for i=1:9
    subplot(3,3,i)
    histogram(Countrydata(:,i));
end

%% mean, std and coefficient correlation
mean_features_values = mean(Countrydata);
std_features_values = std(Countrydata);

coefficient_matrix_ = corrcoef(Countrydata);

Countrydata(:,5)=[];
Countrydata(:,1)=[];
%% normalization
standard_score = zscore(Countrydata);
min_standard_score = min(standard_score);
max_standard_score = max(standard_score);


min_max_normalization = normalize(Countrydata,'range');

%% normalization zscore
%% k_means

X = standard_score;
X = X';
[l,N] = size(X);

% run k means
% Compute J_m and plot J_m versus m
nruns = 1000;
m_min = 2;
m_max = 10;
J_m = [];
for m=m_min:m_max
    J_temp_min=inf;
    for t=1:nruns
        rand('seed',100*t)
        theta_ini = rand(l,m);
        [theta,bel,J] = k_means(X,theta_ini);
        if(J_temp_min>J)
            J_temp_min=J;
        end
    end
    J_m=[J_m J_temp_min];
end
m=m_min:m_max;
figure(2), plot(m,J_m)

%% min_max normalization
X = min_max_normalization;
X = X';
[l,N] = size(X);

% run k means
% Compute J_m and plot J_m versus m
nruns = 1000;
m_min = 2;
m_max = 10;
J_m = [];
for m=m_min:m_max
    J_temp_min=inf;
    for t=1:nruns
        rand('seed',100*t)
        theta_ini = rand(l,m);
        [theta,bel,J] = k_means(X,theta_ini);
        if(J_temp_min>J)
            J_temp_min=J;
        end
    end
    J_m=[J_m J_temp_min];
end
m=m_min:m_max;
figure(3), plot(m,J_m)

%% k_medoids
%% min_max normalization
X = min_max_normalization;
X = X';
[l,N] = size(X);

nruns = 100;
m_min = 2;
m_max = 10;
J_m = [];
for m=m_min:m_max
    J_temp_min=inf;
    for t=1:nruns
        rand('seed',100*t)
        theta_ini = rand(l,m);
        [bel,J,w,a]=k_medoids(X,m,0);
        if(J_temp_min>J)
            J_temp_min=J;
        end
    end
    J_m=[J_m J_temp_min];
end
m=m_min:m_max;
figure(4), plot(m,J_m)



