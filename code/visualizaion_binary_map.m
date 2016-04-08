load('../data/output/sec1_bin.mat');
dims = size(motion_feats_binary);
h_img_size = dims(3);
w_img_size = dims(2);
bin_size = 8;

img_folder = '../data/crowd_frm/';
tp_size = 1;
dirlist = dir([img_folder, '***.jpg']);
src_image = imread([img_folder dirlist(1).name]);
%% Visualize binary maps
motion_feats_img = zeros(size(src_image,1),size(src_image,2),dims(1));
for sample_no=1:dims(1)
    result = reshape(motion_feats_binary(sample_no,:,:,:),[dims(2) dims(3) bin_size]);
    img = zeros(h_img_size,w_img_size);
    for i=1:h_img_size
        for j=1:w_img_size
            img(i,j) = bi2de( reshape(result(j,i,:),[1 bin_size]), 'left-msb');
        end
    end
    img = resize_binary_map( src_image, img );
    motion_feats_img(:,:,sample_no)=img;
end

heatAVI( img_folder, motion_feats_img, tp_size );





%img = resize_binary_map(org_img,img);

%%imshow(mat2gray(img))
%%img = imresize(img , [183 183]);
%%org_img= imresize(imread(img_org_name),[183 183]);
%%org_img= imresize(imread(img_org_name),[h_img_size w_img_size]);
%%imshow([mat2gray(repmat(img,[1 1 3])), mat2gray(org_img)]);

%fusion = imfuse(org_img,img,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
%imshow ([mat2gray(repmat(img,[1 1 3])), mat2gray(org_img), mat2gray(fusion)] );
%figure; imagesc(img);

%% Visualize binary maps
% img = zeros(h_img_size,w_img_size);
% for sample_no=1:dims(1)
% result = reshape(motion_feats_binary(sample_no,:,:,:),[dims(2) dims(3) bin_size]);
% for i=1:h_img_size
%     for j=1:w_img_size
%         img(i,j) = bi2de( reshape(result(j,i,:),[1 bin_size]), 'left-msb');
%     end
% end
% 
% img_org_name = ['../data/crowd_frm/' '.jpg'];
% %org_img= imread(img_org_name);
% imagesc(img)
% w = waitforbuttonpress;
% end