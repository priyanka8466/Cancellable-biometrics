%Program for Fingerprint Minutiae Extraction.
%This program extracts the ridges and bifurcation from a fingerprint image

%Read Input Image
binary_image=im2bw(imread('input_1.tif'));

%Small region is taken to show output clear
binary_image = binary_image(120:400,20:250);
figure;imshow(binary_image);title('Input image');

%Thinning
thin_image=~bwmorph(binary_image,'thin',Inf);
figure;imshow(thin_image);title('Thinned Image');

%Minutiae extraction
s=size(thin_image);
N=3;  %window size
n=(N-1)/2;
r=s(1)+2*n;
c=s(2)+2*n;
  
temp=zeros(r,c);bifurcation=zeros(r,c);ridge=zeros(r,c);
temp((n+1):(end-n),(n+1):(end-n))=thin_image(:,:);
outImg=zeros(r,c,3);  %For Display

outImg(:,:,1) = temp .* 255;
outImg(:,:,2) = temp .* 255;
outImg(:,:,3) = temp .* 255;
for x=(n+1+10):(s(1)+n-10)
    for y=(n+1+10):(s(2)+n-10)
        e=1;
        for k=x-n:x+n
            f=1;
            for l=y-n:y+n
                mat(e,f)=temp(k,l);
                f=f+1;
            end
            e=e+1;
        end;
         if(mat(2,2)==0)
            ridge(x,y)=sum(sum(~mat));
            bifurcation(x,y)=sum(sum(~mat));
         end
    end;
end;
figure;imshow(outImg);title('sample Image');
% RIDGE END FINDING
[ridge_x ridge_y]=find(ridge==2);
len=length(ridge_x);
%For Display
for i=1:len
    outImg((ridge_x(i)-3):(ridge_x(i)+3),(ridge_y(i)-3),2:3)=0;
    outImg((ridge_x(i)-3):(ridge_x(i)+3),(ridge_y(i)+3),2:3)=0;
    outImg((ridge_x(i)-3),(ridge_y(i)-3):(ridge_y(i)+3),2:3)=0;
    outImg((ridge_x(i)+3),(ridge_y(i)-3):(ridge_y(i)+3),2:3)=0;
    
    outImg((ridge_x(i)-3):(ridge_x(i)+3),(ridge_y(i)-3),1)=255;
    outImg((ridge_x(i)-3):(ridge_x(i)+3),(ridge_y(i)+3),1)=255;
    outImg((ridge_x(i)-3),(ridge_y(i)-3):(ridge_y(i)+3),1)=255;
    outImg((ridge_x(i)+3),(ridge_y(i)-3):(ridge_y(i)+3),1)=255;
end

figure;imshow(outImg);title('sample Image');

%BIFURCATION FINDING
[bifurcation_x bifurcation_y]=find(bifurcation==4);
len=length(bifurcation_x);
%For Display
for i=1:len
    outImg((bifurcation_x(i)-3):(bifurcation_x(i)+3),(bifurcation_y(i)-3),1:2)=0;
    outImg((bifurcation_x(i)-3):(bifurcation_x(i)+3),(bifurcation_y(i)+3),1:2)=0;
    outImg((bifurcation_x(i)-3),(bifurcation_y(i)-3):(bifurcation_y(i)+3),1:2)=0;
    outImg((bifurcation_x(i)+3),(bifurcation_y(i)-3):(bifurcation_y(i)+3),1:2)=0;
    
    outImg((bifurcation_x(i)-3):(bifurcation_x(i)+3),(bifurcation_y(i)-3),3)=255;
    outImg((bifurcation_x(i)-3):(bifurcation_x(i)+3),(bifurcation_y(i)+3),3)=255;
    outImg((bifurcation_x(i)-3),(bifurcation_y(i)-3):(bifurcation_y(i)+3),3)=255;
    outImg((bifurcation_x(i)+3),(bifurcation_y(i)-3):(bifurcation_y(i)+3),3)=255;
end

disp(size(ridge_x))
disp(size(ridge_y))
disp(size(bifurcation_x))
disp(size(bifurcation_y))

%concatenating the x,y minutiae coordinates

minutiae_x = vertcat(ridge_x,bifurcation_x)
minutiae_y = vertcat(ridge_y,bifurcation_y)

ridges = horzcat(ridge_x,ridge_y);
bifurcation = horzcat(bifurcation_x,bifurcation_y);

minutiae = horzcat(minutiae_x,minutiae_y);

figure;imshow(outImg);title('Minutiae');

%plotting the minutiae points as a graph
figure;plot(minutiae_x,minutiae_y,'*');title('Minutiae Points Graph')

% Display reference point
disp('Reference Point:')
disp(['X: ', num2str(minutiae_x(1)), ', Y: ', num2str(minutiae_y(1))]);

% Visualize reference point on the minutiae graph
hold on;
plot(minutiae_x(1), minutiae_y(1), 'ro', 'MarkerSize', 10, 'LineWidth', 2);

%calculating the distance between the selected reference minutiae point with all other minutiae points 
distance =[];
disp('length')
disp(length(minutiae))
for i=2:length(minutiae)
     distance(i) = sqrt(((minutiae_x(i)-minutiae_x(1))*(minutiae_x(i)-minutiae_x(1)))+((minutiae_y(1)-minutiae_y(i))*(minutiae_y(1)-minutiae_y(i)))); 
end

disp(distance);

x = 2:length(minutiae)
disp(x)
y = distance(x)
figure
plot(x,y,'--gs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])
title('Distance Graph')
xlabel('x')
ylabel('distance from reference minutiae')

