clear all;
% % ���δ���������ʾ��������ͼ
% ��ȡͼ������
% �ڿ���ͼ�� ��Ҫ��RegTest��Ԥ����
dataat = imread('IMG\1a_256.bmp');
databt = imread('IMG\1b_256.bmp');



% % �鷨ͼ��
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
% ��������ͼ
figure(1);
imshow(salient);

%% �ֲ�������ʸ��ͼ
% figure(2);
% [m,n] = size(salient);
% [x,y] = meshgrid(1:n,1:m);
% [Dx,Dy]=gradient(salient,5,5);
% quiver(x,y,Dx,Dy,0);