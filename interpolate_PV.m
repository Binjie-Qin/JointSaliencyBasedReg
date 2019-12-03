function PVOut = interpolate_PV( cood, img)
% 线性插值计算灰度的函数  PV 插值
% cood是一个三行的列向量，代表x,y,1齐次坐标！

NODATA = 0;
[xm,ym] = size(img);  

j_l   = floor(cood(1,1));
i_l   = floor(cood(2,1));
j_u   = ceil(cood(1,1));
i_u   = ceil(cood(2,1));
dx    = cood(1,1)-floor(cood(1,1));
dy    = cood(2,1)-floor(cood(2,1));
r2    = dx*dy;
r1    = (1-dx)*dy;
r3    = dx*(1-dy);
r4    = (1-dx)*(1-dy);

if cood(1)<1 || cood(1)>xm
    PVOut = NODATA;
    return ;
end
if cood(2)<1 || cood(2)>ym
    PVOut = NODATA;
    return ;
end

PVOut =r2*img(j_u,i_u)+r1*img(j_l,i_u)+r3*img(j_u,i_l)+r4*img(j_l,i_l);
return