options.run_name = '\31_10_2014\ped1_11\';
options.dataset_path='..\data\input\Ped1_Tracklet';
options.working_path ='..\data\Working';
options.input='..\data\input';
options.output='\..data\output';
options.datasetcategory='UCSDped1';
options.dataroot='E:\MY CODE\HOT\Data\Input';
options.Trackletfolder='TrackletOverlap-11';
% options.output_path='';
options.TextName='**.txt';%%%%%type of tracklet file for reading from folder
options.ImageFormat='**.tif';%the name of image that use for counting the number of image are in the folder
% options.max_magnitude_all_cell=[5.82,13.29,20.55];%%ped1 11.4
options.tracklet_length_cell=[5,11,21];
options.numbin_cell=[3,5,8,16,24,36,48,60];
options.Xinput=4;
options.Yinput=6;
options.ImageName='E:\MY CODE\HOT\Data\Input\UCSDped1\Test\Test001\001.tif';
options.FileTracklet='';
options.OverLaprang=1;
options.addpath1='E:\MY CODE\Utility\Vl_feat\vlfeat-0.9.18\toolbox';
options.addpath2='E:\MY CODE\Utility\libsvm-3.17\matlab';
options.addpath3='E:\MY CODE\Utility\pwmetric';
% tracklet_length=11;%%%%%%% tracklet lenght
% options.tracklet_length = 11;
% NumGridPixel=30;
options.Image='C:\Users\hmousavi\Documents\GitHub\AbnormalityMeasureProject\code\1.bmp';

addpath('E:\code\Vl_feat\vlfeat-0.9.18\toolbox')
options.file='E:\video.crowd\klt\UCSDped1\Test\folder';
addpath('E:\code\ped2\supperpixel')
options.file1='E:\video.crowd\klt\UCSDped1\Test\';
options.numbin = 16;
options.number_of_orientation=1;
options.hotsize = options.number_of_orientation* options.numbin ;
Index_Hist1=[1:options.hotsize];
options.Index_Hist=reshape(Index_Hist1 , options.numbin, options.number_of_orientation);

%------------------DOF options
options.nameofdataset = 'ped1';
options.testortrain = 'test';
