load data_country;

%feeling the data
min_features_values = min(Countrydata);
max_features_values = max(Countrydata);
figure(1), hold on
for i=1:9
    subplot(3,3,i)
    histogram(Countrydata(:,i));
end
hold off

%mean, standard devation per feature
mean_features_values = mean(Countrydata);
std_features_values = std(Countrydata);
%matrix with correlation between features. Drop some highly corelated feautues(?)
coefficient_matrix = corrcoef(Countrydata);

%feature selection
%based on observations in the coefficient_matrix_ we can remove features 1
%and 5 becase they are highly correlated with 8 and 9
Countrydata(:,1) = [];
Countrydata(:,5) = [];

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

% plot elbow curve to find the number of clusters
figure(2), plot(best_J)
hold off

% clusters found are 3
cluster_1 = country(find(best_bel{3} == 1))
cluster_2 = country(find(best_bel{3} == 2))
cluster_3 = country(find(best_bel{3} == 3))

% To do: 
% Check why for 1 cluster we have a smaller value than with more thne . An indication that we
% don't have compact clusters or a bug (?)
% min-max normalization and execute again all the algorithms (?)
% Try k-medians clopy paste the code (?)
% Execute other fuzzy algorithms..
% Find a way to charecterize the clustering produced. Std per feature in
% each clusters as the professor said (?) Mean,std,mean ? Check the subject
% characterization of clusters in assignment.