n = 10;
while n>=1
    h = msgbox(sprintf('please wait: %d', n));
    pause(1);
    n = n-1;
    delete(h);
end