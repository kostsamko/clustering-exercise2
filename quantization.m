function [clustering]=quantization(data,labels,clusters, bel, features_names, title_name)

std_features_values = cell(1,clusters);
clustering = cell(1,clusters);
[figure_index,~] = size(get(0,'Children'));
for i=1:clusters
     cluster = data(find(bel{clusters} == i),:);
     std_features_values{i} = std(cluster);
     clustering{i} = labels(bel{clusters} == i);
     figure(figure_index+i), hold on
     [~,length] = size(features_names);
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
for i=1:clusters
     subplot(3,4,i)
     h = bar(X, diag(std_features_values{i}),'stacked');
     title(strcat('cluster: ',int2str(i)));
     sgtitle(strcat(title_name,' std bar plot'));
     legend_cell{i} = strcat('min: ',sprintf('%.2f',min_values(i)),' max: ', sprintf('%.2f',max_values(i)), ' mean: ', sprintf('%.2f',mean_values(i)));
end
subplot(3,4,i+1)
[~, features_size]= size(data) ;
for i=1:clusters
    std_features_values{i} = zeros(1,features_size);
end
h = bar(X, diag(std_features_values{i}),'stacked');
axis off
set(h, {'DisplayName'}, legend_cell')
lg = legend();
lg.Location = 'northwest';
hold off
