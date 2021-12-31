function [best_thetas,best_bel,best_J]=k_algorithms(X,clusters, run_times, algorithm)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
% function [theta,bel,J]=k_algorithms(X,clusters_size, run_times,algorithm)

% This fuction is used to run the algorithms k-means, k-medians and
% k-medoids. The function will run the correspoding algorithm trying to find
% the best initial parameters (theta) for the specified number of clusters
% and the best clustering.
%
% INPUT ARGUMENTS:
%  X:           lxN matrix, each column of which corresponds to
%               an l-dimensional data vector.
%  clusters:    an integer containing the max number of clusters to check.
%  run_times:   an integer containing how many times the algorithm will run to identify the best
%               initial values
%  algorithm:   a string which contains the algorithm that will run
%
% OUTPUT ARGUMENTS:
%  best_thetas:   a cell 1xclusters that contains the best representatives found for
%                 the number of clusters selected
%  best_bel:      a cell 1xclusters that contains the best clustering for
%                 the max number of clusters specified
%  best_J:        a cell 1xclusters that contains the best value of the cost function (sum of squared Euclidean
%                 distances of each data vector from its closest parameter
%                 vector) that corresponds to the  estimated clustering
%

min_score_values = min(X');
max_score_values = max(X');
[l,~] = size(X);
% initialize best choosen values
best_thetas = cell(1,clusters);
best_J = zeros(1,clusters);
best_bel = cell(1,clusters);

if strcmp('k_means',algorithm) || strcmp('k_medians',algorithm)
    % number of clusters to check
    for j=1:clusters
        theta_ini = zeros(l,j);
        min_J = inf;
        % number of runs to choose a good initial theta
        for t=1:run_times
            for k=1:j
                for i=1:l
                    %get random value inside the range of the specific feature
                    random_value = min_score_values(:,i) + (max_score_values(:,i)-min_score_values(:,i)) * rand(1,1);
                    theta_ini(i,k) = random_value;
                end    
            end
        [theta,bel,J] = feval(algorithm,X,theta_ini);
        if J < min_J
            min_J = J;
            best_thetas{j} = theta;
            best_J(j) = J;
            best_bel{j} = bel;
        end    
        end 
    end
elseif strcmp('k_medoids',algorithm)
  for j=1:clusters  
     min_J = inf;  
     for t=1:run_times
        [theta,bel,J] = feval(algorithm,X,j,t);
         if J < min_J
            min_J = J;
            best_thetas{j} = theta;
            best_J(j) = J;
            best_bel{j} = bel;
         end
     end   
  end
elseif strcmp('probalistic_gmm',algorithm)
    options = statset('MaxIter',1000);
    for j=1:10
        GMModel = fitgmdist(X',j,'Replicates',run_times,'RegularizationValue',0.0000000001, 'Options',options);
        best_J(j) = GMModel.NegativeLogLikelihood;
        best_thetas{j} = GMModel.mu';
        best_bel{j} = cluster(GMModel,X')';
    end
elseif strcmp('fuzzy', algorithm)
    for j=1:clusters
        min_J = inf;
        for t=1:run_times
            [centers,U,objFunc] = fcm(X,j);
            J = objFunc(end,1);
            if J < min_J
                min_J = J;
                best_thetas{j} = centers;
                best_J(j) = J;
                best_bel{j} = U;
            end
        end
    end
elseif strcmp('fuzzy_gk', algorithm)
    for j=1:clusters
        min_J = inf;
        for t=1:run_times
            param.c=j;
            param.m=2;
            param.e=1e-6;
            param.ro=ones(1,param.c);
            param.val=3;
            result = GKclust(X,param);
            J = result.cost(end);
            if J < min_J
                min_J = J;
                best_thetas{j} = result.cluster.v;
                best_J(j) = J;
                best_bel{j} = result.data.f;
            end
        end
    end
else
    error('Algorithm is not supported');
end
