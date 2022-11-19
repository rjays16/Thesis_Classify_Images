function [] = accepted()
h = waitbar(0,'ACCEPTED');
    steps = 1000;
    parfor step = 1:steps
        waitbar(step / steps)
    end
    close(h)
end

