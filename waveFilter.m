if app.img_noise == 0
    errordlg('请先生成噪音图','错误');
    return;
end
%检测是否存在噪音图
if strcmp(app.Switch_2.Value,'中值')
    if app.filterNum==0
        app.img_wave = medfilt2(app.img_noise);
    else
        app.img_wave = medfilt2(app.img_wave);
    end
end
%区分滤波类型
if strcmp(app.Switch_2.Value,'高斯')
    W = fspecial('gaussian',[3,3],1);
    if app.filterNum==0
        app.img_wave = imfilter(app.img_noise, W, 'replicate');
        else
            app.img_wave = imfilter(app.img_wave, W, 'replicate');
    end
end
%根据滤波次数选择滤波对象
app.filterNum = app.filterNum+1;
app.UIAxes_6.Title.Color='r';
app.UIAxes_6.Title.String=strcat('滤波',num2str(app.filterNum),'次');
app.UIAxes_6.Visible=1;
imshow(uint8(app.img_wave),'Parent',app.UIAxes_6);