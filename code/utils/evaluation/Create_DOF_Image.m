function Optical_Flow_Normal = Create_DOF_Image(options)
filedir = fullfile(options.input,'opticalflow1',options.nameofdataset);
dirlist = dir(fullfile(filedir,'test***'));%%%'test***'
    num_files = length(dirlist);
for numtext=1:num_files
    disp(['processing folder '  num2str(numtext)])
    filenames = cell(num_files, 1);
    filenames{numtext} = dirlist(numtext).name;
    filename= filenames{numtext};
dirlist_img = dir(fullfile(filedir,filename,'***.tif'));
num_files_img = length(dirlist_img);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iM=1:num_files_img
%%%%%%%%%%%%%%%%%%%%%
filenames_img = cell(num_files_img, 1);
filenames_img {iM} = dirlist_img (iM).name;
filename_img= filenames_img {iM};
img = imread(fullfile(filedir,filename,filename_img));
%-----------------------------------
w=(abs(double((size(img,1)+70)-[1:size(img,1)])))/((size(img,1)));
img1 = bsxfun( @times, double(img(:,:,1)) , w(:))  ;
%------------------------------------------------
Optical_Flow_Normal{numtext,iM}=double(img1(:,:,1))/255;
end
end
