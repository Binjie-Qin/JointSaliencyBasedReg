function [maxv, vect]  = enertiaeig( coor,data, size)
%计算特征值和特征向量
% coor：坐标
% data: 图像数据
% size: 区域半径
re00=0;
re01=0;
re02=0;
re10=0;
re12=0;
re11=0;
re20=0;
re21=0;

T1 = coor - size;
T2 = coor + size;
for I =T1(1):T2(1)
    for J = T1(2): T2(2)
        if sqrt( (I-coor(1)).^2+(J-coor(2)).^2 ) <=size
            re00 = re00+data(I,J);
            re10 = re10+data(I,J)*I;
            re01 = re01+data(I,J)*J;     
            re20 = re20+data(I,J)*I*I;
            re02 = re02+data(I,J)*J*J;
            re11 = re11+data(I,J)*I*J;
        end
    end
end


ux=re10/re00;
uy=re01/re00;

mu00=re00;
mu11=re11-uy*re10;
mu20=re20-ux*re10;
mu02=re02-uy*re01;

tempmat = zeros(2,2);
tempmat(1,1)=mu20;
tempmat(1,2)=-1*mu11;
tempmat(2,1)=-1*mu11;
tempmat(2,2)=mu02;

% 特征向量矩阵和特征值组成的对角阵
[v,e] = eig(tempmat);

if abs(e(1,1)) >= abs(e(2,2))
    maxv = abs(e(1,1));
    vect = v(:,1);
else
    maxv = abs(e(2,2));
    vect = v(:,2);
end