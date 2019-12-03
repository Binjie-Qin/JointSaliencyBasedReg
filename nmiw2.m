function  result = nmiw2(data,dataaa,databb, tfr,w)  
% 计算归一化互信息 64bin
% data为参考图象或者浮动图像，仅仅为了得到它的长宽而引入
% dataa为参考图像,datab为浮动图像
% tfr为后向内插的变换矩阵，故而需要在外面取inv操作
% w是附带的权值

% 初始化直方图  
bin = 32;
q = 0;
P_R  = zeros(1,bin);
P_F  = zeros(1,bin);
P_RF = zeros(bin,bin);

% 采用PV方式进行
[width,height] = size(data);
% 对于灰度值首先归一化
step = (1.01+0.01)/bin;
coos = zeros(3,1);
datapixels = 0;
wb = zeros(1,5);

for I=1:width
    for J=1:height
        coos(1,1) = I;
        coos(2,1) = J;
        coos(3,1) = 1;
        coos = tfr*coos;
        xc = coos(1,1);
        yc = coos(2,1);
        if (xc<=width && yc<=height && xc>=1 && yc>=1)
            dx = xc-floor(xc);
            dy = yc-floor(yc);
            r2 = dx*dy;
            r1 = (1-dx)*dy;
            r3 = dx*(1-dy);
            r4 = (1-dx)*(1-dy);
            ref_int=dataaa(I,J);
            x1 = ceil(xc);
            x2 = floor(xc);
            y1 = ceil(yc);
            y2 = floor(yc);
            flo_int1 = databb(x1,y2);
            flo_int2 = databb(x2,y2);
            flo_int3 = databb(x2,y1);
            flo_int4 = databb(x1,y1);
            wb(1) = w(x1,y2);
            wb(2) = w(x2,y2);
            wb(3) = w(x2,y1);
            wb(4) = w(x1,y1);
            wp= w(I,J);
            if wp==0 
                continue;
            end
            wp = q+(1-q)*wp;
            datapixels = wp+datapixels;
            P_R(uint16(floor((ref_int +0.01)*1.0/step)+1))   = wp   + P_R(uint16(floor((ref_int+0.01)*1.0/step)+1));
            P_F(uint16(floor((flo_int1+0.01)*1.0/step)+1))   = r3*wp + P_F(uint16(floor((flo_int1+0.01)*1.0/step)+1));
            P_F(uint16(floor((flo_int2+0.01)*1.0/step)+1))   = r4*wp + P_F(uint16(floor((flo_int2+0.01)*1.0/step)+1));
            P_F(uint16(floor((flo_int3+0.01)*1.0/step)+1))   = r1*wp + P_F(uint16(floor((flo_int3+0.01)*1.0/step)+1));
            P_F(uint16(floor((flo_int4+0.01)*1.0/step)+1))   = r2*wp + P_F(uint16(floor((flo_int4+0.01)*1.0/step)+1));
            P_RF(uint16(floor((ref_int+0.01)*1.0/step)+1),uint16(floor((flo_int1+0.01)*1.0/step)+1)) = r3*wp + P_RF(uint16(floor((ref_int+0.01)*1.0/step)+1),uint16(floor((flo_int1+0.01)*1.0/step)+1));
            P_RF(uint16(floor((ref_int+0.01)*1.0/step)+1),uint16(floor((flo_int2+0.01)*1.0/step)+1)) = r4*wp + P_RF(uint16(floor((ref_int+0.01)*1.0/step)+1),uint16(floor((flo_int2+0.01)*1.0/step)+1));
            P_RF(uint16(floor((ref_int+0.01)*1.0/step)+1),uint16(floor((flo_int3+0.01)*1.0/step)+1)) = r1*wp + P_RF(uint16(floor((ref_int+0.01)*1.0/step)+1),uint16(floor((flo_int3+0.01)*1.0/step)+1));
            P_RF(uint16(floor((ref_int+0.01)*1.0/step)+1),uint16(floor((flo_int4+0.01)*1.0/step)+1)) = r2*wp + P_RF(uint16(floor((ref_int+0.01)*1.0/step)+1),uint16(floor((flo_int4+0.01)*1.0/step)+1));
        end
    end
end

% 开始计算互信息
H_R  = 0;
H_F  = 0;
H_RF = 0;

for I=1:bin
    if P_R(I)>0
        p_r_norm = P_R(I)/datapixels;
        H_R = p_r_norm*log2(p_r_norm) + H_R;
    end

    if P_F(I)>0
        p_f_norm = P_F(I)/datapixels;
        H_F = p_f_norm*log2(p_f_norm) + H_F;
    end

    for J=1:bin
        if P_RF(I,J)>0
            p_rf_norm = P_RF(I,J)/datapixels;
            H_RF = H_RF + p_rf_norm*log2(p_rf_norm);
        end
    end
end

result(1) = -(H_R+H_F-H_RF);
result(2) = -(H_R+H_F)/H_RF;
return;