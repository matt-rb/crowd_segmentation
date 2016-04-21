
clc
clear
startup;
UCSDped2;

disp('1 - Load data');
options.segments_file='../data/output/feats_conv5_th_0_params.mat';
load(options.segments_file,'all_bin_val_map');
videos_satats=cell(size(all_bin_val_map,1),1);
for video_idx=1:size(all_bin_val_map,1)
    video_frames=all_bin_val_map(video_idx,:);
    video_frames=video_frames((~cellfun(@isempty,video_frames(1,:))));
    frame_data=zeros(length(video_frames),2);
    frame_data(:,1)=[1:length(video_frames)]';
%     for frame_idx=1:length(video_frames)
%         v_frame=video_frames{frame_idx};
%         v_frame=reshape(v_frame,[1,40]);
%         frame_data(frame_idx,2)=sum(v_frame);
%     end
    frame_bins = zeros(40,length(video_frames));

    for i=1:length(video_frames)
        frame_bins (:,i)=reshape(video_frames{i}',[40 1]);
    end
    sorted_video= sort(frame_bins,'descend');
    sorted_video(sorted_video<0.15)=0;
    N = sqrt(sum(abs(frame_bins').^2,2));
    N(:,2)=sum(sorted_video(1:20,:))';
    N(:,3) = N(:,2).*N(:,1);
    N(:,4) = N(:,2)-N(:,1);
    N(:,5) = N(:,4).*N(:,1);
    measure_l2 = compute_coappearance_frame_level( frame_bins );
    frame_data(:,2)=measure_l2;
    videos_satats{video_idx}=frame_data;
end

for stat_idx=1:size(all_bin_val_map,1)
stat=videos_satats{stat_idx};
Y2 = max(stat(:,2));
Y1 = min(stat(:,2));
annotation=TestVideoFile{stat_idx}.gt_frame;
X1=min(annotation);
X2=max(annotation);
fill([20 40; 20 40 ],[1 4; 1 4],'b');
close all
disp(['Plot: ' sprintf('%.3d', stat_idx)]);
plot(stat(1:end-1,1),stat(1:end-1,2),'-*')
ylim([0 30])
hold on
% [X1 X2], [Y1 Y2]
plot([X1 X1] ,[Y2 Y1],'red')
plot([X2 X2] ,[Y2 Y1],'red')
grid on
xlabel('frame no.'); ylabel('app-measure')
file_name=['eval_results/stat_new/stat_l2_' sprintf('%.3d', stat_idx) '.png'];
title(['app-measure for video' sprintf('%.3d', stat_idx)])
print(file_name,'-dpng');
close all
end