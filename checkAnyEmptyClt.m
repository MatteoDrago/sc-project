function [counter, anyEmpty, clt] = checkAnyEmptyClt(idx, cb_size)

anyEmpty = false;
clt_info = tabulate(idx);
counter = clt_info(:,2);

if size(counter,1) < cb_size
    trail = zeros(cb_size - size(counter,1),1); % that's only in the case that not all of the empty clusters are spotted 
    counter = [counter; trail];
end

clt = find(counter == 0);
if clt ~= 0
    clt = clt(1,1); % it may happen that more than one cluster is empty, so I pick the first
    anyEmpty = true;
end

end

