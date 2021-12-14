load data_country;

%feeling the data
min_features_values = min(Countrydata);
max_features_values = max(Countrydata);
figure(1), hold on
for i=1:9
    subplot(3,3,i)
    histogram(Countrydata(:,i));
end

%mean, standard devation per feature
mean_features_values = mean(Countrydata);
std_features_values = std(Countrydata);
%matrix with correlation between features. Drop some highly corelated feautues(?)
coefficient_matrix_ = corrcoef(Countrydata);

% normalize the data 

% standard score normalization
standard_score = zscore(Countrydata)
min_standard_score_values = min(standard_score);
max_standard_score_values = max(standard_score);

% min max normalization
%min_max_normalization_matrix = zeros(size(Countrydata));

%min_max_normalization_matrix = (Countrydata - ones(size(country)) * min_features_values) / (max_features_values - min_features_values)

%CLUSTERING METHODS

% k-means
%rand('seed',0)
X = standard_score;
X = X';
[l,N] = size(X);
% number of clusters to check
m = 10;
% number of runs to choose a good initial theta
run_times = 1000;
% best choosen values per cluster case
best_thetas = cell(1,m);
best_J = zeros(1,m);
best_bel = cell(1,m);
for j=1:m
    theta_ini = zeros(l,j);
    min_J = exp(1000);
    for t=1:run_times
        for k=1:j
            for i=1:l
                random_value = min_standard_score_values(:,i) + (max_standard_score_values(:,i)-min_standard_score_values(:,i)) * rand(1,1);
                theta_ini(i,k) = random_value;
            end    
        end
    [theta,bel,J] = k_means(X, theta_ini);
    if J < min_J
        min_J = J;
        best_thetas{j} = theta;
        best_J(j) = J;
        best_bel{j} = bel;
    end    
    end 
end


% clusters found are 3
cluster_1 = country(find(best_bel{3} == 1))
cluster_2 = country(find(best_bel{3} == 2))
cluster_3 = country(find(best_bel{3} == 3))