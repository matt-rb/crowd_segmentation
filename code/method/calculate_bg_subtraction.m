function w_bs_mask = calculate_bg_subtraction(motion_feats_binary, boxes , options )
% Calculate background subtraction mask for all binary bins
%
dispstat('','init');
w_bs_mask= zeros(options.h,options.w);
for bin_idx=1:length(boxes)
    dispstat(['compute variance for bin: ' num2str(bin_idx) '/' num2str(length(boxes))]);
    sample_bin_decimal_values= zeros(length(motion_feats_binary),1);
    for sample_idx=1:length(motion_feats_binary)
        bin_binary_value=motion_feats_binary{sample_idx}(bin_idx,:);
        sample_bin_decimal_values(sample_idx)=bi2de( bin_binary_value, 'left-msb');
    end
    w_bs_mask(boxes(bin_idx,5),boxes(bin_idx,6))= var(sample_bin_decimal_values);
end
end

