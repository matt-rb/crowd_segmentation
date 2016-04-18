function [w_matrix, cluster_centers]= calculate_w_matrix(motion_feats_binary , motion_feats, options )
% Calculate weight matrix W for all binary bins
%

dispstat('','init');
max_binary_bin = 2^options.bin_size;

bin_per_frame = options.h*options.w;
all_fc7_feats = zeros(length(motion_feats)*bin_per_frame,length(motion_feats{1}));
all_binary_feats = zeros(length(motion_feats)*bin_per_frame,1);

start=1;

for frm_idx=1:length(motion_feats)
    dispstat(['concat frame: ' num2str(frm_idx) '/' num2str(length(motion_feats)) ' feats: ' num2str(start) '/' num2str(start+bin_per_frame)]);
    all_fc7_feats(start:start+bin_per_frame-1,:)=motion_feats{frm_idx};
    all_binary_feats(start:start+bin_per_frame-1)=bi2de( motion_feats_binary{frm_idx}, 'left-msb');
    start=start+bin_per_frame;
end

dispstat('calculate cluster centers');
cluster_centers= zeros (max_binary_bin,length(motion_feats{1}));
for c_idx=1:max_binary_bin
    dispstat([num2str(c_idx) '/' num2str(max_binary_bin)]);
    cluster_feats = all_fc7_feats((all_binary_feats==c_idx-1),:);
    if (size(cluster_feats,1)>0)
        cluster_centers(c_idx,:) = mean(cluster_feats);
    end
end

dispstat('calculate W matrix');
w_matrix = zeros (max_binary_bin,max_binary_bin);
for bin_idx_i=1:max_binary_bin
    source_cluster_center = cluster_centers(bin_idx_i,:);
    for bin_idx_j=1:max_binary_bin
        target_cluster_center= cluster_centers(bin_idx_j,:);
        if (max(target_cluster_center)==0)
            w_matrix(bin_idx_i,bin_idx_j)=0;
        else
            switch options.W_measure_type
                case 'euc'
                    w_matrix(bin_idx_i,bin_idx_j)= ...
                        pdist([target_cluster_center ; source_cluster_center],'euclidean');
                case 'ham' 
                    val1 = de2bi(bin_idx_i, options.bin_size, 'left-msb');
                    val2 = de2bi(bin_idx_j, options.bin_size, 'left-msb');
                    w_matrix(bin_idx_i,bin_idx_j) = pdist([val1 ; val2 ], 'minkowski',1);
                case 'dec'
                    w_matrix(bin_idx_i,bin_idx_j) = abs(bin_idx_i-bin_idx_j);
            end
            
        end
    end
end


end

