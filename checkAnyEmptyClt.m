function [counter, anyEmpty, clt] = checkAnyEmptyClt(idx)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

anyEmpty = false;
clt_info = tabulate(idx);
counter = clt_info(:,2);
%counter = histcounts(idx,cb_size);
clt = find(counter == 0);
if clt ~= 0
    clt = clt(1,1); % it may happen that more than one cluster is empty, so I pick the first
    anyEmpty = true;
end

end

