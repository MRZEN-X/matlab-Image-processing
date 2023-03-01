%分块PCA
if app.img == 0
    return;
end
%若未读取原图则退出运行脚本
app.img_gray = rgb2gray(app.img);
[M N] = size(app.img_gray);
%获取灰度图获得大小

if app.Button_6.Value == 1
    block_l = 16;
elseif app.Button_7.Value == 1
    block_l = 32;
elseif app.Button_8.Value == 1
    block_l = 64;
end
%一个区块的边长为16 ，大小为16*16 = 256,选择区块边长

if app.Button_9.Value == 1
    p = 16;
elseif app.Button_10.Value == 1
    p = 8;
elseif app.Button_11.Value == 1
    p = 4;
end
%取特征值数目


% 若block_l= 16 ,m=512 ,n = 512

blocks = im2col(app.img_gray, [block_l  block_l], 'distinct');
%将图像块分块，随后每一块重排列生成新矩阵，总体为许多个16*16 的小矩阵组成,变成了N*256的数据集
%%因此这里由512*512变为（16*16）*1024 即256行*1024列

blocks_m = ones(size(blocks,1),1)*mean(blocks);
 %计算每块的灰度均值
%ones（创建一个新的矩阵 行数=16*16=256 ，数值全部为1）
%mean()输出每列的灰度均值，共M+N列 两者相乘得到256*1024矩阵，每一列的256个元素都是mean(）
% )的值

blocks=double(blocks)-double(blocks_m);
%每个灰度减去该列的灰度均值

covarianceMatrix = blocks*blocks'/(size(blocks,2)-1);
%乘自己的转置 除以blocks矩阵的列-1  得出协方差矩阵

[E, D] = eig(covarianceMatrix); 
%返回特征值的对角矩阵 D 和矩阵 E，其列是对应的右特征向量，使得 covarianceMatrix*E = E*D。

[d_out,order] = sort(diag(D),'descend');
%diag函数 取对角元素 即矩阵D中特征向量 sort 进行降序排列 与序号一起组成256*2的矩阵

E = E(:,order);
%把E的列倒换，即原来第x列变为第257-x列

D = diag(d_out);
%把排列好的特征向量再放回到矩阵中去，成为排列好的对角特征向量矩阵D

E_1 = E(:,1:p);
%取最大的p个特征值所对应的特征矢量进行降维

g_1 = blocks'*E_1;  
%从block_L^2维映射到p维 最后得出1\block_l*p矩阵 达到降维目的

r_1 = g_1*E_1';
%使用1024*p矩阵与256*p矩阵的转置（即p*256矩阵）相乘，得到一个1024*256的矩阵g_rec

s1 =r_1' + blocks_m;
%处理前每个块的灰度均值
s1 = col2im(s1, [block_l block_l], [M N], 'distinct');app.img_blocks = s1 ;
%每一块重排列生成新矩阵，使用卷积重建法


RMSe1=sum(sum((std(double(s1),0,1).^2)))/sum(sum((std(double(app.img_gray),0,1).^2)));
%获取信息差

app.UIAxes_7.Visible=1;

app.UIAxes_7.Title.String=['块长',num2str(block_l),',取',num2str(p),'个特征值，信息量：',num2str(RMSe1)];app.UIAxes_7.Title.Color='g';


imshow(uint8(s1),'Parent',app.UIAxes_7);%显示图片