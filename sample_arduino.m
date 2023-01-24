clear a 
a = arduino('com5', 'uno');
for i = 1:5
    writeDigitalPin(a,'D13',1)
    playTone(a,'D9',240,1)
    pause(0.5)
    playTone(a,'D9',270,1)
    pause(0.5)
    playTone(a,'D9',300,1)
    pause(0.5)
    playTone(a,'D9',337,1)
    pause(0.5)
    playTone(a,'D9',400,1)
    pause(0.5)
    playTone(a,'D9',450,1)
    pause(0.5)
    playTone(a,'D9',470,1)
    pause(0.5)
    writeDigitalPin(a,'D13',0)
    pause(1)
end
clear