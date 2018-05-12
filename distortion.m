function dst = distortion(img, cb, idx)
%DISTORTION Evaluate the distortion between pixel of the image and
%the quantization value
%   Detailed explanation goes here
dst = zeros(size(img,1),1);
    for i = 1:size(cb,1)
        values = idx == i;
        dst(values,:) = sum((cb(i,:)-img(values,:)).^2,2).^0.5;
    end
end

