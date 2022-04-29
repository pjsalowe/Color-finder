clc;    % Clear the command window.
close all;  % Close all figures

FileName = 'red2.jpg';      % The name of the imput file

rgbImage = imread(FileName);   %convert image to color image


subplot(2, 2, 1);
imshow(rgbImage);title("input image");  % Display the input image.

% Use the createMask program generated by the color Threshholder to create
% a mask from the image inputted above
[mask, maskedRGBImage] = createMask(rgbImage); 

subplot(2, 2, 2);
imshow(mask);title("mask");  % Display the mask from the image.

% Mask the image using bsxfun() function to multiply the mask by each channel individually.
maskedRgbImage = bsxfun(@times, rgbImage, cast(mask, 'like', rgbImage));


subplot(2, 2, 3);
imshow(maskedRgbImage);title("Masked image");  % Display the image.

k_red = maskedRgbImage(:,:,1);  		%extract red channel

k_blue = maskedRgbImage(:,:,3); 		 %extract blue channel

[count1, x1] = imhist(k_red);      		%save histogram into variables

[count3, x3] = imhist(k_blue);  			%save histogram into variables

mean_red = 0;   %set mean to 0
sum_count = sum(count1);  			%find sum of count
g_x1 = count1 / sum_count;   			%the count / sum of count

for k = 1:256
    mean_red = mean_red + (g_x1(k) * k);  	%find the means of all sums
end 	

mean_blue = 0;   					%set mean to 0
sum_count = sum(count3);  				%find sum of count
g_x1 = count3 / sum_count;   				%the count / sum of count

for k = 1:256
    mean_blue = mean_blue + (g_x1(k) * k); 		 %find the means of all sums
end 	

disp("red mean:");    %display the mean found from the red histogram
disp(mean_red);
disp("blue mean:");    %display the mean found from the blue histogram
disp(mean_blue);

if mean_red > mean_blue    % find the greater mean, the greater mean represents the color of the image
    disp("image is red");
else
    disp("image is blue");
end

%below is the fuction created from the color threshholder
function [BW,maskedRGBImage] = createMask(RGB)    

% Convert RGB image to chosen color space
I = rgb2hsv(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.000;
channel1Max = 1.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.215;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.082;
channel3Max = 0.810;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
	(I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
	(I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

end
