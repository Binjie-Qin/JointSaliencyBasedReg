function newimg = transform2DPV(img,trfMat)
% 刚体变换二维图像
% 在我们的图像坐标系中，为了方便，索性将(1,1)点看成是原点。
% 注意这里代入的应该是逆变换！
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