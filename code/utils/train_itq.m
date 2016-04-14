function [ mean_data,itq_rot_mat,pca_mapping ] = train_itq( pca_size, n_iter, feats )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    fprintf('Normalize Data...\n');
    [feats2, mean_data] = normalize_features( feats );

    %----- PCA ---------
    fprintf('Computing Cov PCA...\n');
    Cov=feats'*feats;
    fprintf('Computing Mapping PCA...\n');
    [pca_mapping,~]=eigs(Cov,pca_size);
    mappeddata = feats * pca_mapping;
    fprintf('Computing ITQ...\n');
    [~,itq_rot_mat] = ITQ(mappeddata, n_iter);
end

