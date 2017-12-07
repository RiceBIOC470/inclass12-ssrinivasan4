% Sanjana Srinivasan
% ss159

image1=('011917-wntDose-esi017-RI_f0016.tif');
reader=bfGetReader(image1);
[reader.getSizeX, reader.getSizeY];
reader.getSizeZ;
image_time=reader.getSizeT;
image_chan=reader.getSizeC;

time = 30;
iplane=reader.getIndex(0,0,29)+1;
img=bfGetPlane(reader, iplane);
imshow(img, [500 5000])


iplane=reader.getIndex(0,1,29)+1;
img2=bfGetPlane(reader, iplane);
imshow(img2, [500 5000])

img2show=cat(3, imadjust(img), imadjust(img2), zeros(size(img)));
imshow(img2show);

img_bw=img > 900;
imshow(img_bw);

imshow(imerode(img_bw,strel('disk',3)));
imshow(imdilate(img_bw,strel('disk',3)));

%Inclass 12. 

% Continue with the set of images you used for inclass 11, the same time 
% point (t = 30)

% 1. Use the channel that marks the cell nuclei. Produce an appropriately
% smoothed image with the background subtracted. 
fgauss=fspecial('gaussian', 10, 3);
img2_smooth=imfilter(img2, fgauss);
imshow(img2_smooth, [500 1500]);

img2_sm = imfilter(img2, fspecial('gaussian',4,2));
img2_back = imfilter(img2_sm, strel('disk',100));
imshow(img2_back,[]);

img2_sm_rmback = imsubtract(img2_sm, img2_back);
imshow(img2_sm_rmback,[]);

% 2. threshold this image to get a mask that marks the cell nuclei. 

img2_nuc = (2^16-1)*(img2/max(max(img2)));
imshow(img2_nuc, []);

img_bw = img2 > 1000;
imshow(img_bw);

% 3. Use any morphological operations you like to improve this mask (i.e.
% no holes in nuclei, no tiny fragments etc.)

img_dil = imdilate(img2, strel('disk',5));
imshow(img_dil, [500 5000]);

subplot(1,2,1), imshow(img2, [500 5000]), title('Original');

subplot(1,2,2), imshow(img_dil, [500 5000])
title('Morphologically Improved')

% 4. Use the mask together with the images to find the mean intensity for
% each cell nucleus in each of the two channels. Make a plot where each data point 
% represents one nucleus and these two values are plotted against each other

mes1 = regionprops( img_bw,img2, 'MeanIntensity');
mes2 = regionprops( img_bw,img_dil, 'MeanIntensity');

mes_1 = struct2dataset(mes1);
mes_2 = struct2dataset(mes2);
plot(mes_1,mes_2,'o'); 
xlabel('Img1 Mean Intensity');
ylabel('Img2 Mean Intensity');
