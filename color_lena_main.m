clc;
clear all;
close all;

lena_color = imread('lena512color.tiff'); % read the original image

%display original lena color picture 512x512 
Xoriginal = lena_color(1:512, 1:512, :);
Image1 = figure;
set(Image1, 'name', 'Original lena 512x512 color version', 'numbertitle', 'off')

% Convert data type unit8 to double
lena_color = double(lena_color);
imagesc(Xoriginal);
axis square

% Convert RGB to YCbCr
R = lena_color(:,:,1);
G = lena_color(:,:,2);
B = lena_color(:,:,3); %separate R, G, B from the original image 

%Y - luminance variable 
%Cb and Cr - color difference variables CbºÍCr 
Y = 0.299*R + 0.587*G + 0.114*B;
Cb = B - Y;
Cr = R - Y;

Quan_Y =    [16, 11, 10, 16, 24, 40, 51, 61;
             12, 12, 14, 19, 26, 58, 60, 55;
             14, 13, 16, 24, 40, 57, 69, 56;
             14, 17, 22, 29, 51, 87, 80, 62;
             18, 22, 37, 56, 68, 109, 103, 77;
             24, 35, 55, 64, 81, 104, 113, 92;
             49, 64, 78, 87, 103, 121, 120, 101;  
             72, 92, 95, 98, 112, 100, 103, 99];  %use this to quantize Luminance Variable Y

Quan_C =    [17, 18, 24, 47, 99, 99, 99, 99;
             18, 21, 26, 66, 99, 99, 99, 99;
             24, 26, 56, 99, 99, 99, 99, 99;
             47, 66, 99, 99, 99, 99, 99, 99;
             99, 99, 99, 99, 99, 99, 99, 99;
             99, 99, 99, 99, 99, 99, 99, 99;
             99, 99, 99, 99, 99, 99, 99, 99; 
             99, 99, 99, 99, 99, 99, 99, 99]; %use this to quantize color difference variables Cb and Cr 
         
% Compression and Decompression image using DCT and two different quantisation tables
%(with the function DCT_Compre_and_Decompre)
%Apply DCT filtering to Y
Yout  = DCT_Compre_and_Decompre(Y, i, j, Quan_Y); 
%Apply DCT filtering to color differences Cb and Cr
Cbout = DCT_Compre_and_Decompre(Cb, i, j, Quan_C);
Crout = DCT_Compre_and_Decompre(Cr, i, j, Quan_C);

%Convert YCbCr to RGB
R = Crout + Yout;
B = Cbout + Yout;
G =(Yout - 0.299*R - 0.114*B) / 0.587;

lena_color_out(:,:,1)=uint8(R);
lena_color_out(:,:,2)=uint8(G);
lena_color_out(:,:,3)=uint8(B);

% compressed image output
Image2=figure;
set(Image2,'name', 'Color JPEG image after compression','numbertitle','off');
imagesc(lena_color_out); %display the image after compression
axis square;

% comparision image output
Image3=figure;
set(Image3,'name', 'Compare the original image with compressed image','numbertitle','off');
Different = imshowpair(Xoriginal,lena_color_out,'diff') %Compare the original image with compressed image display
axis square;