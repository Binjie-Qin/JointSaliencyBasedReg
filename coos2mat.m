function tfr = coos2mat( coos, centerx, centery)
% 将一个三维的向量转换为变换矩阵
% centerx,centery为旋转中心
% coos是一个三行的列向量，分别代表x,y位移和旋转角度

% if coos.rows()!=3){ShowMessage("维数不对！");return 0;};
if length(coos)~=3 
    disp('维数不对！');
end

tfr1 = [1,0,-centerx; 0 1 -centery;0 0 1];

tfr2=inv(tfr1);

tfr3 = [1 0 coos(1,1); 0 1 coos(2,1); 0 0 1];

tfr = [cos(pi*coos(3,1)/180) -sin(pi*coos(3,1)/180)  0;
       sin(pi*coos(3,1)/180) cos(pi*coos(3,1)/180)   0;
       0                          0                  1];

tfr=tfr3*tfr2*tfr*tfr1;
