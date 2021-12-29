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
features_names = setdiff(features_names, features_names{8});
features_names = setdiff(features_names, features_names{8});
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
[best_thetas_k_means_zscore,best_bel_k_means_zscore,best_J_k_means_zscore] = k_algorithms(standard_score',number_of_clusters, 1000, 'k_means');
% plot elbow curve to find the number of clusters
figure(2), plot(2:number_of_clusters,best_J_k_means_zscore(2:end))
title('K-means elbow plot - zscore normalization')
hold off

[best_thetas_k_means_min_max,best_bel_k_means_min_max,best_J_k_means_min_max] = k_algorithms(min_max_normalization',number_of_clusters,1000, 'k_means');
% plot elbow curve to find the number of clusters
figure(3), plot(2:number_of_clusters,best_J_k_means_min_max(2:end))
title('K-means elbow plot - min max normalization')
hold off

% k-medians
[best_thetas_k_medians_zscore,best_bel_k_medians_zscore,best_J_k_medians_zscore] = k_algorithms(standard_score',number_of_clusters, 1000, 'k_medians');
% plot elbow curve to find the number of clusters
figure(4), plot(2:number_of_clusters,best_J_k_medians_zscore(2:end))
title('K-medians elbow plot - zscore normalization')
hold off

[best_thetas_k_medians_min_max,best_bel_k_medians_min_max,best_J_k_medians_min_max] = k_algorithms(min_max_normalization',number_of_clusters, 1000, 'k_medians');
% plot elbow curve to find the number of clusters
figure(5), plot(2:number_of_clusters,best_J_k_medians_min_max(2:end))
title('K-medians elbow plot - min max normalization')
hold off

% k-medoids
[best_thetas_k_medoids_zscore,best_bel_k_medoids_zscore,best_J_k_medoids_zscore] = k_algorithms(standard_score',number_of_clusters, 10, 'k_medoids');
% plot elbow curve to find the number of clusters
figure(6), plot(2:number_of_clusters,best_J_k_medoids_zscore(2:end))
title('K-medoids elbow plot - zscore normalization')
hold off

[best_thetas_k_medoids_min_max,best_bel_k_medoids_min_max,best_J_k_medoids_min_max] = k_algorithms(min_max_normalization',number_of_clusters, 10, 'k_medoids');
% plot elbow curve to find the number of clusters
figure(7), plot(2:number_of_clusters,best_J_k_medoids_min_max(2:end))
title('K-medoids elbow plot - min max normalization')
hold off

% probalistic with gaussian mixture models
[best_thetas_gmm_zscore,best_bel_gmm_zscore,best_J_gmm_zscore] = k_algorithms(standard_score',number_of_clusters, 1000, 'probalistic_gmm');
% plot elbow curve to find the number of clusters
figure(8), plot(2:number_of_clusters,best_J_gmm_zscore(2:end))
title('Gausian Mixture models elbow plot - zscore normalization')
hold off

[best_thetas_gmm_min_max,best_bel_gmm_min_max,best_J_gmm_min_max] = k_algorithms(min_max_normalization',number_of_clusters, 1000, 'probalistic_gmm');
% plot elbow curve to find the number of clusters
figure(9), plot(2:number_of_clusters,best_J_gmm_min_max(2:end))
title('Gausian Mixture models elbow plot - min max normalization')
hold off




% Based on the elbow plot the number of clusters that best represent the data using
% k-means are 3. However, the decrease on J is not so big so k-means maybe
% is not an appropriate algorithm for clustering the specfic data.
cluster_1 = country(find(best_bel_k_means_zscore{3} == 1))
cluster_2 = country(find(best_bel_k_means_zscore{3} == 2))
cluster_3 = country(find(best_bel_k_means_zscore{3} == 3))

% Quantization
% k-means

k_means_zscore = Countrydata(find(best_bel_k_means_zscore{3} == 3),:);
min_features_values = min(k_means_zscore);
max_features_values = max(k_means_zscore);
figure(1), hold on
[~,length] = size(features_names);
for i=1:length
    subplot(3,3,i)
    histogram(k_means_zscore(:,i));
    title(features_names{i}) 
end
hold off

%mean, standard devation per feature
mean_features_values = mean(k_means_zscore);
std_features_values = std(k_means_zscore);
%matrix with correlation between features. Drop some highly corelated feautues(?)


% To do: 
% Check why for 1 cluster we have a smaller value than with other values . An indication that we
% don't have compact clusters or a bug (?)
% min-max normalization and execute again all the algorithms (?)
% Try k-medians clopy paste the code (?)
% Execute other fuzzy algorithms..
% Find a way to charecterize the clustering produced. Std per feature in
% each clusters as the professor said (?) Mean,std,histogram ? Check the subject
% characterization of clusters in the assignment.