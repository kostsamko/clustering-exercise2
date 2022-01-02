function [best_thetas,best_bel,best_J]=cfo_algorithms(X,clusters, run_times, algorithm)


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
    for j=2:clusters
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
  for j=2:clusters
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
    for j=2:10
        GMModel = fitgmdist(X',j,'Replicates',run_times,'RegularizationValue',0.0000000001, 'Options',options);
        best_J(j) = GMModel.NegativeLogLikelihood;
        best_thetas{j} = GMModel.mu';
        best_bel{j} = cluster(GMModel,X')';
    end
elseif strcmp('fuzzy', algorithm)
    for j=2:clusters
        min_J = inf;
        for t=1:run_times
            [centers,U,objFunc] = fcm(X',j);
            J = objFunc(end,1);
            if J < min_J
                min_J = J;
                best_thetas{j} = centers;
                best_J(j) = J;
                best_bel{j} = U;
            end
        end
    end
elseif strcmp('fuzzy-GK', algorithm)
    phi=2;
    maxiter=1000;
    toldif=1e-6;
    ndata = size(X', 1);
    for j=2:clusters
        min_J = inf;
        for t=1:run_times
           Uinit= initmember(0.1,j,ndata); % initialise random
           [U, centroid, ~, ~, ~, obj] = gk_fkm(j,X',Uinit,phi,maxiter,toldif);
           J = obj;
           if J < min_J
               min_J = J;
               best_thetas{j} = centroid;
               best_J(j) = J;
               best_bel{j} = U';
           end
        end
    end
elseif strcmp('possibilistic-c_means', algorithm)
    [N, ~] = size(X');
    %try to estimate the etas..
    %First approach using the variance from the mean from every datapoint
    b = sum(sum(((X' - ones(N,1) * mean(X')).^2)'))/N;
    etas = (b/(2 * sqrt(clusters)) * ones(clusters,1))';
    
    % second approach trying to run a fuzzy c-means algorithm first to
    % estimate the variance from each cluster.
    % When we try this approach the etas were not estimated correcly and
    % and all point tend to belong to only one cluster..
    % We keep the code for future work
    %     etas = zeros(1,clusters)
    %     for i=1:clusters
    %         etas(i) = sum(sum(((X' - ones(N,1)*best_thetas_cmeans_min_max{clusters}(i,:)).^2)') .* best_bel_fuzzy_cmeans_zscore{clusters}(i,:).^2) / sum(best_bel_fuzzy_cmeans_zscore{clusters}(i,:).^2)
    %     end
    toldif=1e-6;
    % We use the second version of the algorithm, the results seem to be
    % better.
    % Run the algorithm firstly when the points have the max distance on each
    % the other based on the mean
    [U,theta, J] = possibi(X,clusters,etas,0,0,3,toldif);
    min_J = J;
    best_thetas{clusters} = theta;
    best_J(clusters) = J;
    best_bel{clusters} = U';
    % run again the algorithm trying to find better initial values for the
    % representatives
    for init_proc=1:2
        for t=1:run_times
            [U,theta, J] = possibi(X,clusters,etas,0,t,init_proc,toldif);
            if J < min_J
                min_J = J;
                best_thetas{clusters} = theta;
                best_J(clusters) = J;
                best_bel{clusters} = U';
            end
        end
    end
else
    error('Algorithm is not supported');
end
