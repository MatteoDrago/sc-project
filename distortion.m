function dst = distortion(img, cb, coded_img)

dst = zeros(size(img,1),1);
    for i = 1:size(cb,1)
        values = coded_img == i;
        dst(values,:) = sum((cb(i,:)-img(values,:)).^2,2).^0.5;
    end
end

