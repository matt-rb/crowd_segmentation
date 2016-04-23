   im=imread('161.tif');
%    for ind=1:3
%       imo(:,:,ind)=im;
%    end
    [segments, Am, Sp, d] = slic(repmat(im,[1 1 3]), 200, 10 ,3.5, 'mean');
   %segments =l;
   for ind=1:3
        imo(:,:,ind)=segments;
   end
   fusion = imfuse(segments,im, 'ColorChannels',[1 2 2]);
   %figure;imshow(segments, [1 max(max(segments))])
   imshow(fusion);