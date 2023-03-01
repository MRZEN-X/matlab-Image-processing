[filename,pathname]=uigetfile({'*.jpeg';'*.jpg';'*.png';});
%选择文件
if isequal(filename , 0) && isequal(pathname, 0)
    errordlg('未选择文件','错误');
else
    filepath = strcat(pathname,filename);
end
%若选择失败则提示失败，否者生成文件路径名

app.img = imread(filepath);
app.img_gray=0;
app.img_c=0;
app.img_noise =0 ;
app.img_wave =0 ;
%读入原图后清空数据

app.UIAxes_5.Visible=0;
app.UIAxes_6.Visible=0;
