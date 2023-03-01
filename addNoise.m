if app.img_gray == 0 
    errordlg('请先生成灰度图','错误');
    return;
end
% 检测是否生灰度图

if strcmp(app.Switch.Value,'高斯')
    type = 'gaussian';
end

if strcmp(app.Switch.Value,'椒盐')
    type = 'salt & pepper';
end

if app.img_noise == 0
    app.img_noise=imnoise(app.img_gray,type,0.02);
else
    app.img_noise = imnoise(app.img_noise,type,0.02);
end
%根据SWITCH控件，选择添加不同类型的噪音

app.filterNum = 0;
%生成噪音后将降噪次数将为0
app.UIAxes_5.Title.Color='r';
app.UIAxes_5.Title.String='噪音图';app.UIAxes.Title.Color='r';
app.UIAxes_5.Visible=1;
imshow(uint8(app.img_noise),'Parent',app.UIAxes_5);
%显示噪音图