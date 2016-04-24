function feats_img = apply_super_pixel( feats_img, img_folder, options)
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here

dispstat('','init');
dispstat('Creating video file...','keepthis');
dirlist = dir([img_folder, '***.tif']);
[ h, w, n ] = size(feats_img);
for sample_no=1:n
    dispstat(['Calculate frame ' num2str(sample_no) '/' num2str(n) ]);
temp_sp_frame=zeros(h,w);
img_org_name = [img_folder dirlist(sample_no+options.shift-1).name];
frame= imread(img_org_name);
frame_feat = feats_img(:,:,sample_no);
[segments, ~, ~, ~] = slic(repmat(frame,[1 1 3]), 200, 10 ,3.5, 'mean');
sp_count = max(segments(:));

for sp_idx=1:sp_count
    val_segment = frame_feat .* (segments==sp_idx);
    val_segment = sum((val_segment(:)))/sum(segments(:)==sp_idx);
    tt = val_segment .* (segments==sp_idx);
    temp_sp_frame = temp_sp_frame + tt;
end
feats_img (:,:,sample_no)=temp_sp_frame;
end

end

