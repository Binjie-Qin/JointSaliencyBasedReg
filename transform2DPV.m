function newimg = transform2DPV(img,trfMat)
% ����任��άͼ��
% �����ǵ�ͼ������ϵ�У�Ϊ�˷��㣬���Խ�(1,1)�㿴����ԭ�㡣
% ע����������Ӧ������任��
[numberx,numbery] = size(img);
newimg=zeros(numberx,numbery);
for I=1:numberx
    for J=1:numbery
        cood(1,1)=I;
        cood(2,1)=J;
        cood(3,1)=1;
        coodn=trfMat*cood;
        temp=interpolate_PV(coodn,img);
        newimg(I,J)=temp;        
    end
end