clear all;
% % 本段代码用以显示联合显著图
% 读取图像数据
% 内窥镜图像 需要在RegTest中预处理
dataat = imread('IMG\1a_256.bmp');
databt = imread('IMG\1b_256.bmp');



% % 书法图像
% dataat = imread('IMG\IMG_0049.bmp');
% databt = imread('IMG\IMG_0043.bmp');


% 
dataat = dataat(:,:,1);
databt = databt(:,:,1);

radiusofwmp    = 10;
thresofwmp     = 0.005;
s              = 2;
salient = GetWeightMap(dataat,databt,radiusofwmp, thresofwmp, s);
% 



%%
% 联合显著图
figure(1);
imshow(salient);

%% 局部显著性矢量图
% figure(2);
% [m,n] = size(salient);
% [x,y] = meshgrid(1:n,1:m);
% [Dx,Dy]=gradient(salient,5,5);
% quiver(x,y,Dx,Dy,0);