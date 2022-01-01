function [clustering]=quantization(data,labels,clusters, bel, features_names, title_name)

[~, features_size]= size(data);
std_features_values = cell(1,clusters);
clustering = cell(1,clusters);
[figure_index,~] = size(get(0,'Children'));
for i=1:clusters
     % data per cluster
     % do the clustering
     if startsWith(title_name,'fuzzy')
         indexes = find(bel{clusters}(i,:) == max(bel{clusters}));
         cluster = data(indexes,:);
         clustering{i} = labels(indexes);
     else
         cluster = data(find(bel{clusters} == i),:);
         clustering{i} = labels(bel{clusters} == i);
     end
     % std per cluster
     [size_cluster, ~] = size(cluster);
     if size_cluster > 1
        std_features_values{i} = std(cluster);
     else
      std_features_values{i} = zeros(1,features_size) ;
     end  
     figure(figure_index+i), hold on
     [~,length] = size(features_names);
     % histogram per cluster
     for j=1:length
        subplot(3,3,j)
        histogram(cluster(:,j));
        title(features_names{j})
        sgtitle(strcat(title_name,'quantization histogram',' cluster: ',int2str(i))) 
     end
end
hold off
[figure_index,~] = size(get(0,'Children'));

min_values = min(data);
max_values = max(data);
mean_values = mean(data);

figure(figure_index+1), hold on
X = categorical(features_names);
X = reordercats(X,features_names);
legend_cell = cell(1,clusters);

% plot bar plot per cluster with all features
for i=1:clusters
     subplot(3,4,i)
     h = bar(X, diag(std_features_values{i}),'stacked');
     title(strcat('cluster: ',int2str(i)));
     sgtitle(strcat(title_name,' std bar plot'));
end

% features legend values
for j=1:features_size
     legend_cell{j} = strcat('min: ',sprintf('%.2f',min_values(j)),' max: ', sprintf('%.2f',max_values(j)), ' mean: ', sprintf('%.2f',mean_values(j)));
end

%create one more sublot to include the legend..
%matlab does not support overall legend for suplots.. 
%https://www.mathworks.com/matlabcentral/answers/98474-is-there-a-command-in-matlab-for-creating-one-overall-legend-when-i-have-a-figure-with-subplots
subplot(3,4,i+1)
for i=1:clusters
    std_features_values{i} = zeros(1,features_size);
end
h = bar(X, diag(std_features_values{i}),'stacked');
axis off
set(h, {'DisplayName'}, legend_cell')
lg = legend();
lg.Location = 'northwest';
hold off
