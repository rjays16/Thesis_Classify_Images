function [r] = RedChannel(img)
%REDCHANNEL Summary of this function goes here
%   Detailed explanation goes here
R=img(:, :, 1);
[M, N, ~]=size(img);
r=zeros(M, N, 'uint8');

parfor i=1:M
    for j=1:N
        r(i, j)=(R(i, j)*0.2989);
    end
end
end

