load data_country;

min_features_values = min(Countrydata);
max_features_values = max(Countrydata);
figure(1), hold on
for i=1:9
    subplot(3,3,i)
    histogram(Countrydata(:,i));
end

mean_features_values = mean(Countrydata);
std_features_values = std(Countrydata);

coefficient_matrix_ = corrcoef(Countrydata);

standard_score = zscore(Countrydata)

%min_max_normalization_matrix = zeros(size(Countrydata));

%min_max_normalization_matrix = (Countrydata - ones(size(country)) * min_features_values) / (max_features_values - min_features_values)


%initial theta for both k-means and k-medians
rand('seed',0)
X = standard_score;
X = X'
[l,N] = size(X)
m=3;
theta_ini=rand(l,m);

% run k means
[theta,bel,J] = k_medians(X, theta_ini);
cluster_1 = country(find(bel == 1))
cluster_2 = country(find(bel == 2))
cluster_3 = country(find(bel == 3))