clear;
close all;
I = imread('t_1.jpg');
I = rgb2gray(I);
temp = imread('t_3.jpg');
temp = rgb2gray(temp);

temp = double(temp);

I = double(I);

%canny detection
[canny_I,theta_I] =  cannyedge(I);
[canny_temp, theta_temp] =  cannyedge(temp);


% canny_I = edge(I,'canny');
% canny_temp = edge(temp,'canny');
% figure;
% imshow(canny_temp);
% 
% [dy,dx] = gradient(temp);
% theta_temp = atan2(dy,dx)*180/pi();
% [dy,dx] = gradient(I);
% theta_I = atan2(dy,dx)*180/pi();

%reference zero point:
refPointy = round(size(canny_temp,1)/2);
refPointx = round(size(canny_temp,2)/2);

%-----------------------------
%Generate the R-table
[y,x] = find(canny_temp > 0);
pointsRange = round(size(x,1));
angleRange = 50;
%theta_temp = Gradient(canny_temp);

Rtable = zeros(angleRange, pointsRange,360,20,2);
binCount = zeros(181,1);

%Write to Rtable

for i = 1:pointsRange
    %fi = round(theta_temp(y(i),x(i)) + 91);
    fi = theta_temp(y(i),x(i)) + 90;
    fi = round(fi/180*(angleRange-1) )+1;
    binCount(fi) = binCount(fi) + 1;
    h = binCount(fi);
    for scale = 5:20
        delta_x = scale/10*(refPointx - x(i));
        delta_y = scale/10*(refPointy - y(i));
        for angle = 1:360
            Rtable(fi, h,angle,scale, 1) = round(delta_x*cosd(angle) - delta_y*sind(angle));
            Rtable(fi, h,angle,scale, 2) = round(delta_x*sind(angle) + delta_y*cosd(angle));
        end
    end
end

%-----------------------------
%Accumulator:

%get the image edge points
[y_I,x_I] = find(canny_I > 0);
pointRange_I = size(x_I,1);
%theta_I = Gradient(canny_I);
[M,N] = size(canny_I);

%generate accumulator:
count = zeros(M,N);


% for i=1:pointRange_I
%     %the gradient angle:
%     fi = round(theta_I(y_I(i),x_I(i)) + 181);
%     for j = 1:binCount(fi)
%         n_x = x_I(i) + Rtable(fi, j, 1);
%         n_y = y_I(i) + Rtable(fi, j, 2);
%         if (n_y>=1) && (n_y<=M) && (n_x>=1) && (n_x<=N)
%             count(n_y, n_x) = count(n_y, n_x)+1;
%         end
%     end
% end
% 

maxeach = zeros(360,20,1);
for scale = 5:20
    for angle = 1:360
        for i=1:pointRange_I
            %the gradient angle:
    %         fi = theta_I(y_I(i),x_I(i)) - angle;
    %         fi = round(asind(sind(fi)) + 91);
            fi = theta_I(y_I(i),x_I(i)) + angle;
            fi = asind(sind(fi)) + 90;
            fi = round(fi/180*(angleRange-1) )+1;
            for j = 1:binCount(fi)
                n_x = x_I(i) + Rtable(fi, j,angle,scale, 1);
                n_y = y_I(i) + Rtable(fi, j,angle,scale, 2);
                if (n_y>=1) && (n_y<=M) && (n_x>=1) && (n_x<=N)
                    count(n_y, n_x) = count(n_y, n_x)+1;
                end
            end
        end
        maxpoint = max(count(:));
        maxeach(angle,scale) = maxpoint;
        count = zeros(M,N);
    end
end

bestvoting = max(maxeach(:));
[bestangle, bestscale] = find(maxeach >= bestvoting);


for i=1:pointRange_I
    %the gradient angle:
%     fi = round(theta_I(y_I(i),x_I(i)) + 91);
    fi = theta_I(y_I(i),x_I(i)) + bestangle;
        fi = asind(sind(fi)) + 90;
        fi = round(fi/180*(angleRange-1) )+1;
    for j = 1:binCount(fi)
        n_x = x_I(i) + Rtable(fi, j,bestangle,bestscale, 1);
        n_y = y_I(i) + Rtable(fi, j,bestangle,bestscale, 2);
        if (n_y>=1) && (n_y<=M) && (n_x>=1) && (n_x<=N)
            count(n_y, n_x) = count(n_y, n_x)+1;
        end
    end
end

%show hough space image
figure;
houghspace = uint8(count);
imagesc(houghspace);

maxpoint = max(count(:));
[loc_y,loc_x] = find(count == (maxpoint));




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

temp = imread('t_2.jpg');
temp = rgb2gray(temp);

temp = double(temp);

I = double(I);

%canny detection
[canny_I,theta_I] =  cannyedge(I);
[canny_temp, theta_temp] =  cannyedge(temp);


% canny_I = edge(I,'canny');
% canny_temp = edge(temp,'canny');
% figure;
% imshow(canny_temp);
% 
% [dy,dx] = gradient(temp);
% theta_temp = atan2(dy,dx)*180/pi();
% [dy,dx] = gradient(I);
% theta_I = atan2(dy,dx)*180/pi();

%reference zero point:
refPointy = round(size(canny_temp,1)/2);
refPointx = round(size(canny_temp,2)/2);

%-----------------------------
%Generate the R-table
[y,x] = find(canny_temp > 0);
pointsRange = round(size(x,1));
angleRange = 50;
%theta_temp = Gradient(canny_temp);

Rtable = zeros(angleRange, pointsRange,360,20,2);
binCount = zeros(181,1);

%Write to Rtable

for i = 1:pointsRange
    %fi = round(theta_temp(y(i),x(i)) + 91);
    fi = theta_temp(y(i),x(i)) + 90;
    fi = round(fi/180*(angleRange-1) )+1;
    binCount(fi) = binCount(fi) + 1;
    h = binCount(fi);
    for scale = 5:20
        delta_x = scale/10*(refPointx - x(i));
        delta_y = scale/10*(refPointy - y(i));
        for angle = 1:360
            Rtable(fi, h,angle,scale, 1) = round(delta_x*cosd(angle) - delta_y*sind(angle));
            Rtable(fi, h,angle,scale, 2) = round(delta_x*sind(angle) + delta_y*cosd(angle));
        end
    end
end

%-----------------------------
%Accumulator:

%get the image edge points
[y_I,x_I] = find(canny_I > 0);
pointRange_I = size(x_I,1);
%theta_I = Gradient(canny_I);
[M,N] = size(canny_I);

%generate accumulator:
count = zeros(M,N);


% for i=1:pointRange_I
%     %the gradient angle:
%     fi = round(theta_I(y_I(i),x_I(i)) + 181);
%     for j = 1:binCount(fi)
%         n_x = x_I(i) + Rtable(fi, j, 1);
%         n_y = y_I(i) + Rtable(fi, j, 2);
%         if (n_y>=1) && (n_y<=M) && (n_x>=1) && (n_x<=N)
%             count(n_y, n_x) = count(n_y, n_x)+1;
%         end
%     end
% end
% 

maxeach = zeros(360,20,1);
for scale = 5:20
    for angle = 1:360
        for i=1:pointRange_I
            %the gradient angle:
    %         fi = theta_I(y_I(i),x_I(i)) - angle;
    %         fi = round(asind(sind(fi)) + 91);
            fi = theta_I(y_I(i),x_I(i)) + angle;
            fi = asind(sind(fi)) + 90;
            fi = round(fi/180*(angleRange-1) )+1;
            for j = 1:binCount(fi)
                n_x = x_I(i) + Rtable(fi, j,angle,scale, 1);
                n_y = y_I(i) + Rtable(fi, j,angle,scale, 2);
                if (n_y>=1) && (n_y<=M) && (n_x>=1) && (n_x<=N)
                    count(n_y, n_x) = count(n_y, n_x)+1;
                end
            end
        end
        maxpoint = max(count(:));
        maxeach(angle,scale) = maxpoint;
        count = zeros(M,N);
    end
end

bestvoting = max(maxeach(:));
[bestangle, bestscale] = find(maxeach >= bestvoting);


for i=1:pointRange_I
    %the gradient angle:
%     fi = round(theta_I(y_I(i),x_I(i)) + 91);
    fi = theta_I(y_I(i),x_I(i)) + bestangle;
        fi = asind(sind(fi)) + 90;
        fi = round(fi/180*(angleRange-1) )+1;
    for j = 1:binCount(fi)
        n_x = x_I(i) + Rtable(fi, j,bestangle,bestscale, 1);
        n_y = y_I(i) + Rtable(fi, j,bestangle,bestscale, 2);
        if (n_y>=1) && (n_y<=M) && (n_x>=1) && (n_x<=N)
            count(n_y, n_x) = count(n_y, n_x)+1;
        end
    end
end

%show hough space image
figure;
houghspace = uint8(count);
imagesc(houghspace);

maxpoint = max(count(:));
[loc_y1,loc_x1] = find(count == (maxpoint));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
I = uint8(I);
imshow(I);
hold on;
sita=0:0.05:2*pi;
r=30;

plot(loc_x, loc_y, 'r*', 'LineWidth', 2, 'MarkerSize', 2);
plot(loc_x+r*cos(sita),loc_y+r*sin(sita));
plot(loc_x1, loc_y1, 'r*', 'LineWidth', 2, 'MarkerSize', 2);
plot(loc_x1+r*cos(sita),loc_y1+r*sin(sita));
hold off;

% function Circle(centery, centerx, reference, r)
% radius = reference + r;
% angle = 0:0.01:2*pi; 
% d_x = radius*cos(angle);
% d_y = radius*sin(angle);
% plot(centery+d_y, centerx+d_x, 'r');
% end
% 
% function [result] = Gradient(input)
%     dy=imfilter(double(input),[1; -1],'same');
%     dx=imfilter(double(input),[1  -1],'same');
%     result = atan2(dy,dx)*180/pi();
% end





