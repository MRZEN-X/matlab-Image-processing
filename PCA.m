%不分块,整体PCA
if app.img == 0
    return;
end
%若未读入原图则结束运行脚本

app.img_gray = rgb2gray(app.img);
[mx, nx] = size(app.img_gray);
%获取灰度图，并获取大小

[ux sx vx] = svd(double(app.img_gray));
% 奇异值分解
% 重构压缩后的图像
rx = app.Slider.Value; % 压缩率
Kx = round(2 * mx * nx / (rx * (mx + nx + 1)));

if Kx > min(mx, nx)
    Kx = min(mx, nx);
end
app.img_c = zeros([mx, nx]);
%生成空白压缩图

for i = 1:Kx
    app.img_c = app.img_c + sx(i, i) * ux(:, i) * vx(:, i)'; 
    % 利用前K个特征值重构原图像
end

RMSe=sum(sum((std(double(app.img_c),0,1).^2)))/sum(sum((std(double(app.img_gray),0,1).^2)));
%、计算压缩图保留信息与原图的比值

app.UIAxes.Visible=1;
app.UIAxes_2.Visible=1;
app.UIAxes_3.Visible=1;
app.UIAxes_4.Visible=1;
%设置控件可视
app.UIAxes.Title.String='原图';app.UIAxes.Title.Color='b';
app.UIAxes_2.Title.String='灰度图';app.UIAxes_2.Title.Color='b';
app.UIAxes_3.Title.String=['压缩比:', num2str(uint8(app.Slider.Value)), '  信息量：',num2str(RMSe)];app.UIAxes_3.Title.Color='b';
app.UIAxes_4.Title.String='压缩前后差值:';app.UIAxes_4.Title.Color='b';
%设置控件标题，和标题颜色
imshow(app.img,'Parent',app.UIAxes);
imshow(app.img_gray,'Parent',app.UIAxes_2);
imshow(uint8(app.img_c),'Parent',app.UIAxes_3);
imshow(uint8(uint8(app.img_gray) - uint8(app.img_c)),'Parent',app.UIAxes_4);
%在控件中显示原图，灰度图，压缩图，差值图