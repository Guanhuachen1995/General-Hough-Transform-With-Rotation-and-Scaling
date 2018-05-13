function [thresholded,theta] = cannyedge(I)

I = double(I);
mask =  1/25 * ones(5);
%correlation through the image
[M,N]=size(I);
for i=3:(M-2)
     for j=3:(N-2)
         tem = I(i-2:i+2, j-2:j+2) .* mask;
         I(i,j) = floor(sum(tem(:)));
     end
end
%figure;
%I = uint8(I);
%imshow(I);

%use dx filter to correlate the image
I = double(I);
dx = [ -1 , 0, 1; -2, 0, 2; -1 , 0, 1];
g_x = zeros(M,N);
for i=2:(M-1)
     for j=2:(N-1)
         tem = I(i-1:i+1, j-1:j+1) .* dx;
         g_x(i,j) = floor(sum(tem(:)));
     end
end
%map to [0,255]
range_x = max(g_x(:)) - min(g_x(:));
g_x_min = min(g_x(:));
g_x_show = g_x;
for i=1:M
     for j=1:N
         g_x_show(i,j) = floor((g_x(i,j) - g_x_min)/range_x *255);
     end
end

%use dy filter to correlate the image
dy = [ 1 , 2, 1; 0, 0, 0; -1 , -2, -1];
g_y = zeros(M,N);
for i=2:(M-1)
     for j=2:(N-1)
         tem = I(i-1:i+1, j-1:j+1) .* dy;
         g_y(i,j) = floor(sum(tem(:)));
     end
end
%map to [0,255]
range_y = max(g_y(:)) - min(g_y(:));
g_y_min = min(g_y(:));
g_y_show = g_y;
for i=1:M
     for j=1:N
         g_y_show(i,j) = floor((g_y(i,j) - g_y_min)/range_y *255);
     end
end

%use the function of canny algorithm learned in class to detect the edges magnitude.
g = sqrt(g_x.^2 + g_y.^2);



%use the function of canny algorithm learned in class to detect the edges Orientation.
theta = atand(g_y./g_x);

direc = arrayfun(@(x)normalize_directions(x), theta);
g = non_max_supression(g, direc);

%map to [0,255]
range_g = max(g(:)) - min(g(:));
g_min = min(g(:));
g_show = g;
for i=1:M
     for j=1:N
         g_show(i,j) = floor((g(i,j) - g_min)/range_g *255);
     end
end

low = 30;
high = 80;
thresholded = arrayfun(@(x)double_threshold(x,low,high), g_show);



%show edges image
figure;
g_show = uint8(g_show);
imshow(g_show);


end