% %%�����������������ڿ���ͼ����ҪԤ������ȥ��­������Ӱ�졪������������������%%
% % ���δ���Ŀ���Ƕ���������ͼ����Ԥ��������­��������Ӱ�졣
% % ������������������������ѡȡ���ɸ��㣬ÿ����ͨ��������ֻ��Ҫһ���㣻
% %       ֮������Ҽ����
% %
% % �Ҷ�ͼ��ת��Ϊ2ֵͼ,��ȡ����������亯��ֻ�Ա������������ã�
% BW1 = ~im2bw(salient);
% % idx����������ص���������������Ե
% [BW2,idx] = bwfill(BW1,4);
% % ��idx��Ӧ������������
% salient(idx) = 0;
% %%��������������������������������������������������������������������������%%
%%
w=salient;

outcoor = [0 0 0]'; 
xp = 10;
yp = 10;
rp = 10;

[H,W] = size(w);
centerx = H/2;    % ͼ��İ��
centery = W/2;    % ͼ��İ���

coos = [  outcoor(1)+xp            0               0          outcoor(1);
                0            outcoor(2)+yp         0          outcoor(2);
                0                  0         outcoor(3)+rp    outcoor(3)  ];
% dataat Ŀ��ͼ��, databt ����ͼ��
[t,outcoor] = Simplex2DPV(coos,centerx,centery,databt,dataat,w,1);
Trans=t;
newimg = transform2DPV(databt,inv(Trans));
% figure('name','Registered');
figure;
imshow(uint8(newimg(2:end-1,2:end-1)));

