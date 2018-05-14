function clt = checkAnyEmptyClt(idx,cb_dim)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
clt = 0;
for i=1:cb_dim
    if nnz(idx == i) == 0
        clt = i;
    end
end
end

