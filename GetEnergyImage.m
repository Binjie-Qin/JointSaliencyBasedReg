function energy = GetEnergyImage( src, kind)
% 产生能量图像
energy=src*1;
[width,height] = size(src);
% width=src.rows();
%   int height=src.cols();

for J=2:height-1
    for I=2:width-1
        tempenergyb=0;
        for numberi=-1:1
            for numberj=-1:1
                tempenergyb = tempenergyb +  (src(I,J)-src(I+numberi,J+numberj))^2;
            end
        end
        energy(I,J)=tempenergyb;
    end
end
% 归一化到[0，1]内

if(kind==0)
    energy = energy/max(energy(:));
end
