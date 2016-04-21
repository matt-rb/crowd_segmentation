clc
clear
startup;
UCSDped2;

%load data files
disp('1 - Load data');
feat_type='of_ovrs';
options.segments_file=['../data/output/feats_conv5_th_0.3_' feat_type '.mat'];
load(options.segments_file);
%options = options_extracted_feats;
options.gt_folder='../data/ucsd/UCSDped2/gt/';


%my options
options.shift=ceil(options.tracklet_len/2);
options.th_roc=0;

options.itrnum = 20;
options.ClipOfFrame = options.shift;
options.threshold_pixellevel = 0.39;


disp('2 - Create grand-truth annotation');
%[ImgGrandtruth,TestVideoFile_new] = Create_GT_UCSD_Frame(options,TestVideoFile);
load('variables/gt_ped2.mat','ImgGrandtruth','TestVideoFile_new');

RoCs=cell(12,1);

for i=1:1
start=i;
end_vid=i+10;
disp(['Evaluation results ' num2str(i)]);
result = SegmentResultMatrix(all_CoAp(start:end_vid,:),TestVideoFile_new(start:end_vid),ImgGrandtruth(start:end_vid,:),options);
TP1 = TruePositiveValue(result,all_CoAp(start:end_vid,:),options);
[TPR,FPR,Roc1] = ROCValue(TP1,all_CoAp(start:end_vid,:),options);

close all
disp('Plot ROC');
plot(Roc1(:,2),Roc1(:,1),'-*')
hold on
plot([0 1] ,[1 0],'red')
grid on
xlabel('FPR'); ylabel('TPR')
title(['ROC for classification/ ' strrep(options.segments_file(29:end-4), '_', ' ')])
file_name=['eval_results/new/' sprintf('%.3d', i) '_' feat_type '_all.png'];
%print(file_name,'-dpng');
RoCs{i}=Roc1;
%close all
w = waitforbuttonpress;
end
%save(['evaluation_set/RoC_' feat_type '.mat'],'RoCs');
%save(['evaluation_set/RoC_' feat_type '_overall.mat'],'Roc1');
%legend('tt1','tt2')