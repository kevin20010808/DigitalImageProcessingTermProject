function output = wmap(i1,i2)
   [w,h,d]=size(i1);
   output = zeros(w,h,d);
   for i=1:d
       maxmap = max(i1(:,:,i),i2(:,:,i));
       temp = double(maxmap==i1(:,:,i));
       output(:,:,i) = temp;
   end
end