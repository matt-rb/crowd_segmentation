function [motion_feats_img, bin_val_map] = create_image_feat( motion_feats_binary, boxes, img_folder, pres_rescore, options )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
frame_count= length(motion_feats_binary);
dirlist = dir([img_folder, '***.jpg']);
src_image = imread([img_folder dirlist(1).name]);

motion_feats_img = zeros(size(src_image,1),size(src_image,2),frame_count);
bin_val_map = zeros(options.h, options.w, frame_count);
for sample_no=1:frame_count
    result = motion_feats_binary{sample_no};
    img = zeros(options.h,options.w);
    for i=1:length(boxes)
        if options.binary_based
            pixel_val = bi2de(result(i,:), 'left-msb');
        else
            pixel_val =result(i);
        end
        img(boxes(i,5),boxes(i,6))= pixel_val;
    end
    
    img = img .* pres_rescore;
    bin_val_map(:,:,sample_no) = img;
    img = resize_binary_map( src_image, img );
    motion_feats_img(:,:,sample_no) = img;
end

end

