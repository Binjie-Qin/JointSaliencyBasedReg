% %%————————内窥镜图像需要预处理以去除颅骨轮廓影响——————————%%
% % 本段代码目的是对联合显著图进行预处理消除颅骨轮廓的影响。
% % 方法：鼠标左键随意在轮廓上选取若干个点，每个联通区域最少只需要一个点；
% %       之后鼠标右键激活。
% %
% % 灰度图象转化为2值图,并取反（种子填充函数只对背景物体有作用）
% BW1 = ~im2bw(salient);
% % idx——填充象素的线性索引，即边缘
% [BW2,idx] = bwfill(BW1,4);
% % 把idx对应的显著性置零
% salient(idx) = 0;
% %%—————————————————————————————————————%%
%%
w=salient;

outcoor = [0 0 0]'; 
xp = 10;
yp = 10;
rp = 10;

[H,W] = size(w);
centerx = H/2;    % 图像的半高
centery = W/2;    % 图像的半列

coos = [  outcoor(1)+xp            0               0          outcoor(1);
                0            outcoor(2)+yp         0          outcoor(2);
                0                  0         outcoor(3)+rp    outcoor(3)  ];
% dataat 目标图像, databt 浮动图像
[t,outcoor] = Simplex2DPV(coos,centerx,centery,databt,dataat,w,1);
Trans=t;
newimg = transform2DPV(databt,inv(Trans));
% figure('name','Registered');
figure;
imshow(uint8(newimg(2:end-1,2:end-1)));


