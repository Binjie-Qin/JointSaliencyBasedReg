function re = smoothimage(srcimg, s) 
% 对图象高斯平滑
if s==0
    re = srcimg;
    return;
end
src = srcimg;
W = ceil( 4 * s  ) ;
J = 1:(2*W+1);
filter = exp(-0.5 * (J-W-1) .* (J-W-1) / (s*s) );
% normalize to one
% normalize(filter, W) ;*bgca
filter =filter./sum(filter);

% convolve
re = conv2(filter,filter,src,'same');