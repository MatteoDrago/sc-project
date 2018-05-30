%% FIRST VERSION
% If it provides additional gain, reassign training vectors to the new
% codewords and iterates the first evaluation procedure until no more gain
% can be obtained

% while flag
%     
% %     mi conviene iniziare da quelli nuovi, altrimenti all'inizio non avrò
% %     niente da modificare, perchè parto dal caso "ottimo" precedente
% %     Questo significa che per ottimizzarlo, l'algoritmo è tutto da
% %     rivedere
%     for i = 1:size(cb,1)
%         empty_clt = true;
%         temp_dist = sum((cb(i,:)-img).^2,2).^0.5;
%         toChange = temp_dist < dst;
%         idx(toChange,:) = i; % this corresponds to assign one quantization value to a single training vector 
%         counter_idx(i) = nnz(toChange);
%         while empty_clt
%             clt = find(counter_idx == 0);
%             fprintf('First method: %d \n', clt);
%             clt = checkAnyEmptyClt(idx,size(cb,1)); % check if there's any empty cluster
%             fprintf('Second method: %d \n', clt);
%             if clt == 0
%                 empty_clt = false;
%             else
%                 we need to reassign the codeword in order to avoid empty
%                 cluster
%                 cb(clt,:) = reassignCodeword(img, idx, size(cb,1));
%                 temp_dist = sum((cb(clt,:)-img).^2,2).^0.5;
%                 toChange = temp_dist < dst;
%                 idx(toChange,:) = clt;
%             end
%         end
%     end
%     
%     for i=1:size(cb,1)
%         cb(i,1) = mean(img(idx == i,1));
%         cb(i,2) = mean(img(idx == i,2));
%         cb(i,3) = mean(img(idx == i,3));
%     end
% 
%     new_dst = distortion(img, cb, dst); % evaluate new value for the distortion
% 
%     Evaluate the gain obtained changing the codebook 
%     before = mean(dst);
%     after = mean(new_dst);
%     progress = (after - before)/after;
% 
%     if progress < epsilon
%         flag = false;
%     end
%     dst = new_dst;
% end