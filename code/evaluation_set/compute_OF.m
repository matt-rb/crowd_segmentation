%% Compute optical flow
sample_dirlist = dir([feat_dir,'/T*']);
all_OF=cell(length(sample_dirlist),1);
all_OF_map=cell(length(sample_dirlist),1);

for sample_idx=1:length(sample_dirlist)
    frames_list = dir([feat_dir '/' sample_dirlist(sample_idx).name '/***.bmp']);
    OF_frame = zeros(options.h*options.w,1);
    OF_video = cell(length(frames_list),1);
    for frm_idx=1:length(frames_list)
        dispstat(['computing Video ' num2str(sample_idx) '/' num2str(length(sample_dirlist))...
            ' Frame ' num2str(frm_idx) '/' num2str(length(frames_list))]);
        frm= imread([feat_dir '/' sample_dirlist(sample_idx).name '/' frames_list(frm_idx).name]);
        frm=mean(frm,3);
        for box_idx=1:length(boxes)
            patch= frm(boxes(box_idx,2):boxes(box_idx,4),boxes(box_idx,1):boxes(box_idx,3));
            OF_frame(box_idx) = mean(patch(:));
        end
        OF_video{frm_idx}=OF_frame;
    end
    [motion_feats_img, bin_val_map] = create_image_feat( OF_video, boxes, img_folder, pres_rescore, options);
    max_val=max(motion_feats_img(:));
    motion_feats_img = motion_feats_img .* (1/max_val);
    bin_val_map = bin_val_map .* (1/max_val);
    for im_idx=1:size(motion_feats_img,3)
        all_OF{sample_idx,im_idx} = motion_feats_img(:,:,im_idx);
        all_OF_map{sample_idx,im_idx} = bin_val_map(:,:,im_idx);
    end
end

save(options.segments_file, 'all_OF','all_OF_map','options');