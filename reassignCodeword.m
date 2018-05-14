function cb = reassignCodeword(img, idx, cb_dim)
%REASSIGNCODEWORD Summary of this function goes here
%   Detailed explanation goes here

most_populated = 0;
cluster_idx = 0;

for i=1:cb_dim
    cluster_pop = nnz(idx == i);
    if cluster_pop > most_populated
        most_populated =  cluster_pop;
        cluster_idx = i;
    end
end

candidates = img(idx == cluster_idx,:);

cb = candidates(randi(size(candidates,1)),:);

