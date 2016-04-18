UCSDped2;
options_all;
options.itrnum = 21;
options.ClipOfFrame = 8;
options.threshold_pixellevel = 0.39;
% Optical_Flow_Normal = Create_DOF_Image(options);
% seg_all = SegmentFeature_image_DOF(measureDB,segmentall,Optical_Flow_Normal,options);
[ImgGrandtruth,TestVideoFile_new] = Create_GT_UCSD_Frame(options,TestVideoFile);
% %%%%%%%%%%%%%%%%%%%%%%%%

result = SegmentResultMatrix(seg_all,TestVideoFile_new,ImgGrandtruth,options);
TP1 = TruePositiveValue(result,options);
[TPR,FPR,Roc1] = ROCValue(TP1,options);

    plot(Roc1(:,2),Roc1(:,1),'-*')
    grid on
    xlabel('FPR'); ylabel('TPR')
    title('ROC for classification by logistic regression')
    %     hold on;
    
    
    
    
    
    
    
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mov = avifile('E:\video.crowd\UCSD_Anomaly_Dataset.v1p2_for_changing\save\ped1_all_0_22.avi');
% dirlist1 = dir(fullfile('e:','video.crowd','UCSD_Anomaly_Dataset.v1p2_for_changing','UCSDped1','Test','video','Test***'));%%%'test***'
% num_files1 = length(dirlist1);
% for numtext=1:num_files1
%     disp(['processing folder '  num2str(numtext)])
%     filenames1 = cell(num_files1, 1);
%     filenames1{numtext} = dirlist1(numtext).name;
%     filename1= filenames1{numtext};
%     dirlist = dir(fullfile('e:','video.crowd','UCSD_Anomaly_Dataset.v1p2_for_changing','UCSDped1','Test','video',filename1,'***.tif'));
%     num_files = length(dirlist);
%     for iM = 1:num_files-1
%         filenames = cell(num_files, 1);
%         filenames{iM} = dirlist(iM).name;
%         filename= filenames{iM};
%         img= imread(fullfile('e:','video.crowd','UCSD_Anomaly_Dataset.v1p2_for_changing','UCSDped1','Test','video',filename1,filename));
%         % imshow(imga); hold on;
%         DD = Sum_abnormal_opticalflow(numtext,iM).num(:,:)>=0.8;
%         Rim =2*(DD .* double(img(:,:)))+((1-DD).*double(img(:,:)));
%         Image2=double(img);
%         Image2(:,:)=Rim;
%         Q=uint8(Image2);
%         imshow(Q);
%         % figure;
%         F = getframe(gcf);
%         mov=addframe(mov,F);
%     end
% end
% mov=close(mov);
% 
% 
% 
% options.ImageName = imread('ped1.tif');
% 
% for kk = 1: size(Local_frame,3)
%     iC = [];
%     for ii = 1: size(Local_frame,1)
%         ss=[];
%         for jj = 1: size(Local_frame,2)
%             a = repmat(Local_frame(ii,jj,kk), [20 20]);
%             ss =[ss,a];
%         end
%         iC = [iC;ss];
%     end
%     if (size(iC,2)~=size(options.ImageName,2))
%         iC(:,end-((size(iC,2)-size(options.ImageName,2))-1):end)=[];
%     end
%     if (size(iC,1)~=size(options.ImageName,1))
%         iC(end-((size(iC,1)-size(options.ImageName,1))-1):end,:)=[];
%     end
%     Frame1{kk} = iC ;
% end
% 
