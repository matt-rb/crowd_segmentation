function w_matrix = calculate_w_matrix_clusters( cluster_centers , options )
% Calculate weight matrix W for all binary bins
%

dispstat('','init');

dispstat('calculate W matrix');
w_matrix = zeros (options.no_clusters,options.no_clusters);
for bin_idx_i=1:options.no_clusters
    source_cluster_center = cluster_centers(bin_idx_i,:);
    for bin_idx_j=1:options.no_clusters
        target_cluster_center= cluster_centers(bin_idx_j,:);
        if (max(target_cluster_center)==0 || max(source_cluster_center)==0)
            w_matrix(bin_idx_i,bin_idx_j)=0;
            w_matrix(bin_idx_j,bin_idx_i)=0;
        else
            switch options.W_measure_type
                case 'euc'
                    w_matrix(bin_idx_i,bin_idx_j)= ...
                        pdist([target_cluster_center ; source_cluster_center],'euclidean');
                case 'ham' 
                    val1 = de2bi(bin_idx_i-1, options.bin_size, 'left-msb');
                    val2 = de2bi(bin_idx_j-1, options.bin_size, 'left-msb');
                    w_matrix(bin_idx_i,bin_idx_j) = pdist([val1 ; val2 ], 'minkowski',1);
                case 'dec'
                    w_matrix(bin_idx_i,bin_idx_j) = abs(bin_idx_i-bin_idx_j);
            end
            
        end
    end
end


end

