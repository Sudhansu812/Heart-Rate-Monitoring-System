% Made by students of KIIT. Name of group members :
% 
%     1. Sudhansu Kumar Maharana
%     2. Satyaki Chakraborti
%     3 .Mabdhab Jyoti Mohanty
%     4. Sujay Das
%     5. Sonu Kumar

clearvars

%User Details
name = input('Name : ', 's');
ID = input('ID : ', 's');
age = input('Age : ');
mno = input('Mobile Number : ', 's');

%Read the video, number of frames, frame rate and create an array of
%nFrames x 1
vidObj    = VideoReader( "D:\Minor\Repos\test9.mp4");
nFrames   = vidObj.NumberOfFrames;
tFrame    = (1:nFrames) / vidObj.FrameRate;
frate = vidObj.FrameRate;
gCom  = zeros( nFrames, 1);

%Converts every frame to gray which is stored in matrix format, each
%numbers representing the white vallue
%gCom stores the sum of white value of each frame
for fId = 1 : nFrames
   grayImage = rgb2gray(read(vidObj,fId));
   gCom(fId) = sum(grayImage(:));
end

%Plotting of gCom, this graph is reveresed as we are interested in the dark
%values (ie lower white values)
figure();
clf;
set( gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.1, 1, 0.6]);
subplot(411);
plot(tFrame, gCom/max(gCom), 'b');
title('Raw Input Plot');
set( gca, 'YTick', [0, 1], 'YDir', 'reverse');
xlabel('Time [s]');
ylabel('Amplitude');


filtered = medfilt1(gCom,9);

%Creating a threshold to get rid of the unwanted parts of the signal in the
%later part but in this part the higher white values are to be filtered
%as they have too much noise, the lower white value parts are untouched for 
%now
len = length(gCom);
gPeak = max(gCom);
gLow = min(gCom);
plDiff = gPeak - gLow;
threshold = gLow + (0.45*plDiff);

for i = 1 : nFrames
    if(gCom(i) > threshold)
        gCom(i) = filtered(i);
    end
end

%Plotting of the filtered signal
subplot(412);
set( gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.1, 1, 0.6]);
plot(tFrame,gCom/max(gCom));
title('Filtered Input Plot');
set( gca, 'YTick', [0, 1], 'YDir', 'reverse');
xlabel('Time [s]');
ylabel('Amplitude');

%In this section the unwanted parts are cut off(made 0) and the parts that
%we need is made to 1. Basically rectifying the signal and we get a square wave.
for i = 1:len
    if gCom(i) <= threshold
        gFin(i) = 1;
    else
        gFin(i) = 0;
    end
end

set( gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.1, 1, 0.6]);
subplot(413);
plot(tFrame, gFin, 'b');
title('Rectified Filtered Input Plot');
axis([0 2*pi -2 2.5]);
set( gca, 'YTick', [0, 1]);
xlabel('Time [s]');
ylabel('Amplitude');

%This part is made just to count the number of beats and display them.
%Impulse signal is just made to better visualize not mandatory to have.

c=1;
prev = gFin(1);
for i=1:len
    if(gFin(i) ~= prev)
        imp(c) = prev;
        c = c+1;
        prev = gFin(i);
        if(i==len)
            imp(c) = gFin(i);
        end
    else
        prev = gFin(i);
    end
end

%Fetching the current date and time
format longG;
t = now;
d = datetime(t,'ConvertFrom','datenum');

%Printing of the heart rate, as the video is of 10 seconds six is
%multiplied
hRate = int32(fix(c/2))*6;
subplot(414);
stem(imp, 'b');
title('Impulse Plot');
set(gca,'YTick',[-0.5,1]);
axis([0 2*pi -2 2.5]);
str = sprintf('Heart Rate : %d \nName : %s \nID : %s \nAge : %d \nMobile Number : +91%s',hRate,name,ID,age,mno);
legend(str);


