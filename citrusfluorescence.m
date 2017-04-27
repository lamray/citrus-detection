%all in one
clear
[name path] = uigetfile({'*.jpg','JEPG File';'*.bmp','bit File';'*.png',...
    'png File';'*.tif','ALL Image Files'},'open image file');
im=imread([path name]);
% I=imresize(im,0.3);
tic
I1=im;
I2=im;
I3=im;
figure;
subplot(221),imshow(I1);
%%
im=im2double(im);
r=im(:,:,1);
g=im(:,:,2);
b=im(:,:,3);

% %colorgraythresh g
% % level=graythresh(H);
% level=graythresh(g);
% int_level=255*level;
% % bw=im2bw(H,level);
% bw=im2bw(g,level);
% % bw=imclearborder(bw);
% bw=~bw;
% subplot(222),imshow(bw);title(['b component:',num2str(int_level)]);

%HSI color model
I=(r+g+b)/3;
tmp1=min(min(r,g),b);
tmp2=r+g+b;
tmp2(tmp2==0)=eps;
S=1-3.*tmp1./tmp2;
tmp1=0.5*((r-g)+(r-b));
tmp2=sqrt((r-g).^2+(r-b).*(g-b));
theta=acos(tmp1./(tmp2+eps));
H=theta;
H(b>g)=2*pi-H(b>g);
H=H/(2*pi);
H(S==0)=0;

%colorgraythresh H
level=graythresh(H);
int_level=255*level;
bw=im2bw(H,level);
% bw=imclearborder(bw);
% bw=~bw;
subplot(222),imshow(bw);title(['H component:',num2str(int_level)]);

%%
re=repmat(bw,[1,1,3]); 
I2(re<1)=0;  
subplot(223),imshow(I2);
%%
stats = regionprops(~bw, 'BoundingBox', 'Centroid');
subplot(224),imshow(I3);
 hold on
 for object=1:length(stats)
     bb=stats(object).BoundingBox;
     bc=stats(object).Centroid;
     rectangle('Position',bb,'EdgeColor','g','LineWidth',1)
%      plot(bc(1),bc(2),'-k*')
%      b=text(bc(1)+15,bc(2),strcat('X:',num2str(round(bc(1))),'Y:',num2str(round(bc(2)))));
%      set(b,'FontName','Arial','FontWeight','bold','FontSize',12,'Color','m');
     h(object)=round(bc(1));
     z(object)=round(bc(2));
 end
 hold off