close all;
clear;
load data_country;

%feeling the data
features_names = {'Child mortality','Exports','Health','Imports','Income','Inflation','Life expectancy','Total fertality','GDPP'};
min_features_values = min(Countrydata);
max_features_values = max(Countrydata);
figure(1), hold on
[~,length] = size(features_names);
for i=1:length
    subplot(3,3,i)
    histogram(Countrydata(:,i));
    title(features_names{i}) 
end
hold off

%mean, standard devation per feature
mean_features_values = mean(Countrydata);
std_features_values = std(Countrydata);
%matrix with correlation between features. Drop some highly corelated feautues(?)
coefficient_matrix = corrcoef(Countrydata);

%feature selection
%based on observations in the coefficient_matrix_ we can remove feature 8
%(Total_fertality) and 9(GDPP) because they are highly correlated with 1 (Child_mortality) and 5 (Income)
Countrydata(:,8) = [];
Countrydata(:,8) = [];
features_names = setdiff(features_names, features_names{8},'stable');
features_names = setdiff(features_names, features_names{8},'stable');
% normalize the data 

% standard score normalization
standard_score = zscore(Countrydata);
coefficient_standard_score = corrcoef(Countrydata);


% min max normalization
min_max_normalization = normalize(Countrydata, 'range');
coefficient_min_max_normalization = corrcoef(Countrydata);

% We don't remove other features

%CLUSTERING METHODS
number_of_clusters = 10;

% k-means
[best_thetas_k_means_zscore,best_bel_k_means_zscore,best_J_k_means_zscore] = cfo_algorithms(standard_score',number_of_clusters, 1000, 'k_means');
% plot elbow curve to find the number of clusters
figure(2), plot(2:number_of_clusters,best_J_k_means_zscore(2:end))
title('K-means elbow plot - zscore normalization')
hold off

[best_thetas_k_means_min_max,best_bel_k_means_min_max,best_J_k_means_min_max] = cfo_algorithms(min_max_normalization',number_of_clusters,1000, 'k_means');
% plot elbow curve to find the number of clusters
figure(3), plot(2:number_of_clusters,best_J_k_means_min_max(2:end))
title('K-means elbow plot - min max normalization')
hold off

% k-medians
[best_thetas_k_medians_zscore,best_bel_k_medians_zscore,best_J_k_medians_zscore] = cfo_algorithms(standard_score',number_of_clusters, 1000, 'k_medians');
% plot elbow curve to find the number of clusters
figure(4), plot(2:number_of_clusters,best_J_k_medians_zscore(2:end))
title('K-medians elbow plot - zscore normalization')
hold off

[best_thetas_k_medians_min_max,best_bel_k_medians_min_max,best_J_k_medians_min_max] = cfo_algorithms(min_max_normalization',number_of_clusters, 1000, 'k_medians');
% plot elbow curve to find the number of clusters
figure(5), plot(2:number_of_clusters,best_J_k_medians_min_max(2:end))
title('K-medians elbow plot - min max normalization')
hold off

% k-medoids
[best_thetas_k_medoids_zscore,best_bel_k_medoids_zscore,best_J_k_medoids_zscore] = cfo_algorithms(standard_score',number_of_clusters, 10, 'k_medoids');
% plot elbow curve to find the number of clusters
figure(6), plot(2:number_of_clusters,best_J_k_medoids_zscore(2:end))
title('K-medoids elbow plot - zscore normalization')
hold off

[best_thetas_k_medoids_min_max,best_bel_k_medoids_min_max,best_J_k_medoids_min_max] = cfo_algorithms(min_max_normalization',number_of_clusters, 10, 'k_medoids');
% plot elbow curve to find the number of clusters
figure(7), plot(2:number_of_clusters,best_J_k_medoids_min_max(2:end))
title('K-medoids elbow plot - min max normalization')
hold off

% probalistic with gaussian mixture models
[best_thetas_gmm_zscore,best_bel_gmm_zscore,best_J_gmm_zscore] = cfo_algorithms(standard_score',number_of_clusters, 1000, 'probalistic_gmm');
% plot elbow curve to find the number of clusters
figure(8), plot(2:number_of_clusters,best_J_gmm_zscore(2:end))
title('Gausian Mixture models elbow plot - zscore normalization')
hold off

[best_thetas_gmm_min_max,best_bel_gmm_min_max,best_J_gmm_min_max] = cfo_algorithms(min_max_normalization',number_of_clusters, 1000, 'probalistic_gmm');
% plot elbow curve to find the number of clusters
figure(9), plot(2:number_of_clusters,best_J_gmm_min_max(2:end))
title('Gausian Mixture models elbow plot - min max normalization')
hold off

% fuzzy c-means algorithm
[best_thetas_fuzzy_cmeans_zscore, best_bel_fuzzy_cmeans_zscore, best_J_fuzzy_cmeans_zscore] = cfo_algorithms(standard_score', number_of_clusters, 1000, 'fuzzy');
% plot elbow curve to find the number of clusters
figure(10), plot(2:number_of_clusters, best_J_fuzzy_cmeans_zscore(2:end))
title('Fuzzy-cmeans elbow plot - zscore normalization')

[best_thetas_cmeans_min_max, best_bel_cmeans_min_max, best_J_cmeans_min_max] = cfo_algorithms(min_max_normalization', number_of_clusters, 1000, 'fuzzy');
% plot elbow curve to find the number of clusters
figure(11), plot(2:number_of_clusters, best_J_cmeans_min_max(2:end))
title('Fuzzy-cmeans elbow plot - min max normalization')

% fuzzy Gustafson-Kessel
[best_thetas_fuzzy_GK_zscore, best_bel_fuzzy_GK_zscore, best_J_fuzzy_GK_zscore] = cfo_algorithms(standard_score', number_of_clusters, 1000, 'fuzzy-GK');
% plot elbow curve to find the number of clusters
figure(10), plot(2:number_of_clusters, best_J_fuzzy_GK_zscore(2:end))
title('Fuzzy-GK elbow plot - zscore normalization')

[best_thetas_fuzzy_GK_min_max, best_bel_fuzzy_GK_min_max, best_J_fuzzy_GK_min_max] = cfo_algorithms(min_max_normalization', number_of_clusters, 1000, 'fuzzy-GK');
% plot elbow curve to find the number of clusters
figure(11), plot(2:number_of_clusters, best_J_fuzzy_GK_min_max(2:end))
title('Fuzzy-GK elbow plot - min max normalization')

[best_thetas_fuzzy_gk_zscore, best_bel_fuzzy_gk_zscore, best_J_fuzzy_gk_zscore] = k_algorithms(standard_score, number_of_clusters, 1000, 'fuzzy_gk');
% plot elbow curve to find the number of clusters
figure(12), plot(2:number_of_clusters, best_J_fuzzy_gk_zscore(2:end))
title('Fuzzy GK elbow plot - zscore normalization')

[best_thetas_fuzzy_gk_min_max, best_bel_fuzzy_gk_min_max, best_J_fuzzy_gk_min_max] = k_algorithms(min_max_normalization, number_of_clusters, 1000, 'fuzzy_gk');
% plot elbow curve to find the number of clusters
figure(13), plot(2:number_of_clusters, best_J_fuzzy_gk_min_max(2:end))
title('Fuzzy GK elbow plot - min max normalization')

% Quantization
% k-means
[best_k_means_clustering_min_max] = quantization(min_max_normalization,country,7,best_bel_k_means_min_max,features_names,'K-means - min max');
% fuzzy
[best_fuzzy_clustering_zscore] = quantization(standard_score,country,3,best_bel_fuzzy_zscore,features_names,'fuzzy - zscore');

[best_fuzzy_gk_clustering_zscore] = quantization(standard_score,country,3,best_bel_fuzzy_gk_zscore,features_names,'fuzzy GK - zscore');