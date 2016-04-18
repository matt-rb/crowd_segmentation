function w_bg_mask = calculate_bg_subtraction(motion_feats_binary, boxes, cluster_centers , options )
% Calculate background subtraction mask for all binary bins
%
dispstat('','init');
w_bg_mask= zeros(options.h,options.w);
if strcmp(options.bg_mask_type,'dec')
    for bin_idx=1:length(boxes)
        dispstat(['compute variance for bin: ' num2str(bin_idx) '/' num2str(length(boxes))]);
        sample_bin_decimal_values= zeros(length(motion_feats_binary),1);
        for sample_idx=1:length(motion_feats_binary)
            bin_binary_value=motion_feats_binary{sample_idx}(bin_idx,:);
            sample_bin_decimal_values(sample_idx)=bi2de( bin_binary_value, 'left-msb');
        end
        w_bg_mask(boxes(bin_idx,5),boxes(bin_idx,6))= var(sample_bin_decimal_values);
    end
else
    for bin_idx=1:length(boxes)
        dispstat(['compute variance for bin: ' num2str(bin_idx) '/' num2str(length(boxes))]);
        sample_bin_cluster_centers= zeros(length(motion_feats_binary),size(cluster_centers,2));
        for sample_idx=1:length(motion_feats_binary)
            bin_binary_value=motion_feats_binary{sample_idx}(bin_idx,:);
            cluster_code =bi2de( bin_binary_value, 'left-msb')+1;
            sample_bin_cluster_centers(sample_idx) = cluster_centers(cluster_code,:);
        end
        w_bg_mask(boxes(bin_idx,5),boxes(bin_idx,6))= norm(var(sample_bin_cluster_centers));
    end
end
end

