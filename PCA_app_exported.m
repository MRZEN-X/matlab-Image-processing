classdef PCA_app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure       matlab.ui.Figure
        Button_5       matlab.ui.control.Button
        Button_13      matlab.ui.control.Button
        Button_12      matlab.ui.control.Button
        ButtonGroup_2  matlab.ui.container.ButtonGroup
        Button_11      matlab.ui.control.RadioButton
        Button_10      matlab.ui.control.RadioButton
        Button_9       matlab.ui.control.RadioButton
        ButtonGroup    matlab.ui.container.ButtonGroup
        Button_8       matlab.ui.control.RadioButton
        Button_7       matlab.ui.control.RadioButton
        Button_6       matlab.ui.control.RadioButton
        EditField_2    matlab.ui.control.EditField
        Button_4       matlab.ui.control.Button
        Switch_2       matlab.ui.control.ToggleSwitch
        Switch         matlab.ui.control.ToggleSwitch
        Button_3       matlab.ui.control.Button
        Button_2       matlab.ui.control.Button
        EditField      matlab.ui.control.EditField
        Slider         matlab.ui.control.Slider
        Label          matlab.ui.control.Label
        Button         matlab.ui.control.Button
        UIAxes_7       matlab.ui.control.UIAxes
        UIAxes         matlab.ui.control.UIAxes
        UIAxes_6       matlab.ui.control.UIAxes
        UIAxes_5       matlab.ui.control.UIAxes
        UIAxes_4       matlab.ui.control.UIAxes
        UIAxes_3       matlab.ui.control.UIAxes
        UIAxes_2       matlab.ui.control.UIAxes
    end


    properties (Access = public)
        filterNum = 0 % 滤波次数
    end

    properties (Access = public)
        img_blocks = 0 % 分区压缩图
    end

    properties (Access = public)
        img_wave=0 %经过滤波的噪音图
    end

    properties (Access = public)
        img_noise=0 % 噪音图
    end

    properties (Access = public)
        img_c=0 % 压缩图
    end

    properties (Access = public)
        img_gray=0 % 灰度图
    end

    properties (Access = public)
        img=0%原图
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)

        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
            choiceImage;%读取图片
            PCA;             %整体PCA处理
            PCA_BLOCKS;%分区PCA处理
        end

        % Value changed function: Slider
        function changingRate(app, event)
            app.EditField.Value=strcat(num2str(uint8(app.Slider.Value)),'%');
            PCA;%更改压缩率后 重新进行PCA
        end

        % Button pushed function: Button_2
        function Button_2Pushed(app, event)
            addNoise;  %添加噪音
        end

        % Button pushed function: Button_3
        function Button_3Pushed(app, event)
            waveFilter; %滤波
        end

        % Button pushed function: Button_4
        function Button_4Pushed(app, event)
            if app.img_noise ==0
                errordlg('请先生成噪音图','错误');
                return;
            end

            app.filterNum =0;
            app.img_noise = app.img_gray;
            imshow(app.img_noise,'Parent',app.UIAxes_5);
            %清空噪音，重新显示噪音图
        end

        % Button pushed function: Button_5
        function Button_5Pushed(app, event)
            if app.img_c==0
                errordlg('无图片','错误');
                return;
            end

            %imwrite(uint8(app.img_c),'test.jpg');
            f = figure('visible', 'off');
            copyobj(app.UIAxes_3, f);
            imsave(f);
            %、保存压缩后的图片
        end

        % Selection changed function: ButtonGroup
        function ButtonGroupSelectionChanged(app, event)
            PCA_BLOCKS;%更换选择重新分区PCA
        end

        % Selection changed function: ButtonGroup_2
        function ButtonGroup_2SelectionChanged(app, event)
            PCA_BLOCKS;%更换选择重新分区PCA
        end

        % Button pushed function: Button_12
        function Button_12Pushed(app, event)
            if (app.img_gray ==0) | (app.img_c ==0) | (app.img_blocks == 0)
                errordlg('无图片','错误');
                return;
            end

            subplot(1, 3, 1); imshow(app.img_gray, []);title('灰度图');
            subplot(1, 3, 2); imshow(app.img_c, []); title('整体压缩图');
            subplot(1, 3, 3); imshow(app.img_blocks, []); title('分块压缩图');
        end

        % Button pushed function: Button_13
        function Button_13Pushed(app, event)
            if (app.img_noise ==0) | (app.img_wave ==0)
                errordlg('无图片','错误');
                return;
            end

            subplot(1, 2, 1); imshow(app.img_noise, []);title('噪音图');
            subplot(1, 2, 2); imshow(app.img_wave, []); title('滤波图');
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 812 704];
            app.UIFigure.Name = '图片处理';

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.UIFigure);
            app.UIAxes_2.Toolbar.Visible = 'off';
            app.UIAxes_2.XTick = [];
            app.UIAxes_2.YTick = [];
            app.UIAxes_2.Visible = 'off';
            app.UIAxes_2.Position = [274 457 225 185];

            % Create UIAxes_3
            app.UIAxes_3 = uiaxes(app.UIFigure);
            app.UIAxes_3.Toolbar.Visible = 'off';
            app.UIAxes_3.XTick = [];
            app.UIAxes_3.YTick = [];
            app.UIAxes_3.Visible = 'off';
            app.UIAxes_3.Position = [1 256 225 185];

            % Create UIAxes_4
            app.UIAxes_4 = uiaxes(app.UIFigure);
            app.UIAxes_4.Toolbar.Visible = 'off';
            app.UIAxes_4.XTick = [];
            app.UIAxes_4.YTick = [];
            app.UIAxes_4.Visible = 'off';
            app.UIAxes_4.Position = [274 256 225 185];

            % Create UIAxes_5
            app.UIAxes_5 = uiaxes(app.UIFigure);
            app.UIAxes_5.Toolbar.Visible = 'off';
            app.UIAxes_5.XTick = [];
            app.UIAxes_5.YTick = [];
            app.UIAxes_5.Visible = 'off';
            app.UIAxes_5.Position = [1 21 225 185];

            % Create UIAxes_6
            app.UIAxes_6 = uiaxes(app.UIFigure);
            app.UIAxes_6.Toolbar.Visible = 'off';
            app.UIAxes_6.XTick = [];
            app.UIAxes_6.YTick = [];
            app.UIAxes_6.Visible = 'off';
            app.UIAxes_6.Position = [274 21 225 185];

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            app.UIAxes.Toolbar.Visible = 'off';
            app.UIAxes.XTick = [];
            app.UIAxes.YTick = [];
            app.UIAxes.Visible = 'off';
            app.UIAxes.Position = [1 457 225 185];

            % Create UIAxes_7
            app.UIAxes_7 = uiaxes(app.UIFigure);
            app.UIAxes_7.Toolbar.Visible = 'off';
            app.UIAxes_7.XTick = [];
            app.UIAxes_7.YTick = [];
            app.UIAxes_7.Visible = 'off';
            app.UIAxes_7.Position = [541 372 225 185];

            % Create Button
            app.Button = uibutton(app.UIFigure, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.BackgroundColor = [0 0.4471 0.7412];
            app.Button.FontSize = 20;
            app.Button.FontColor = [1 1 1];
            app.Button.Position = [1 651 163 54];
            app.Button.Text = '选择图片';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'right';
            app.Label.Position = [174 672 41 22];
            app.Label.Text = '压缩率';

            % Create Slider
            app.Slider = uislider(app.UIFigure);
            app.Slider.ValueChangedFcn = createCallbackFcn(app, @changingRate, true);
            app.Slider.Position = [236 681 150 3];

            % Create EditField
            app.EditField = uieditfield(app.UIFigure, 'text');
            app.EditField.Editable = 'off';
            app.EditField.BackgroundColor = [0.9412 0.9412 0.9412];
            app.EditField.Position = [174 652 41 22];

            % Create Button_2
            app.Button_2 = uibutton(app.UIFigure, 'push');
            app.Button_2.ButtonPushedFcn = createCallbackFcn(app, @Button_2Pushed, true);
            app.Button_2.Position = [688 177 94 25];
            app.Button_2.Text = '加噪音';

            % Create Button_3
            app.Button_3 = uibutton(app.UIFigure, 'push');
            app.Button_3.ButtonPushedFcn = createCallbackFcn(app, @Button_3Pushed, true);
            app.Button_3.Position = [682 90 100 25];
            app.Button_3.Text = '滤波';

            % Create Switch
            app.Switch = uiswitch(app.UIFigure, 'toggle');
            app.Switch.Items = {'高斯', '椒盐'};
            app.Switch.Orientation = 'horizontal';
            app.Switch.Position = [598 178 45 20];
            app.Switch.Value = '高斯';

            % Create Switch_2
            app.Switch_2 = uiswitch(app.UIFigure, 'toggle');
            app.Switch_2.Items = {'中值', '高斯'};
            app.Switch_2.Orientation = 'horizontal';
            app.Switch_2.Position = [598 92 45 20];
            app.Switch_2.Value = '中值';

            % Create Button_4
            app.Button_4 = uibutton(app.UIFigure, 'push');
            app.Button_4.ButtonPushedFcn = createCallbackFcn(app, @Button_4Pushed, true);
            app.Button_4.BackgroundColor = [0 0.4471 0.7412];
            app.Button_4.FontSize = 18;
            app.Button_4.FontColor = [1 1 1];
            app.Button_4.Position = [565 129 217 33];
            app.Button_4.Text = '清除噪音';

            % Create EditField_2
            app.EditField_2 = uieditfield(app.UIFigure, 'text');
            app.EditField_2.Editable = 'off';
            app.EditField_2.HorizontalAlignment = 'center';
            app.EditField_2.FontSize = 20;
            app.EditField_2.FontColor = [0.149 0.149 0.149];
            app.EditField_2.BackgroundColor = [0.9412 0.9412 0.9412];
            app.EditField_2.Position = [1 218 803 31];
            app.EditField_2.Value = '-------------------滤波---------------------';

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.UIFigure);
            app.ButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ButtonGroupSelectionChanged, true);
            app.ButtonGroup.ForegroundColor = [0.149 0.149 0.149];
            app.ButtonGroup.TitlePosition = 'centertop';
            app.ButtonGroup.Title = '分块大小';
            app.ButtonGroup.BackgroundColor = [0.6078 0.8471 0.9216];
            app.ButtonGroup.Position = [561 592 123 106];

            % Create Button_6
            app.Button_6 = uiradiobutton(app.ButtonGroup);
            app.Button_6.Text = '16*16';
            app.Button_6.Position = [11 57 53 22];
            app.Button_6.Value = true;

            % Create Button_7
            app.Button_7 = uiradiobutton(app.ButtonGroup);
            app.Button_7.Text = '32*32';
            app.Button_7.Position = [11 35 53 22];

            % Create Button_8
            app.Button_8 = uiradiobutton(app.ButtonGroup);
            app.Button_8.Text = '64*64';
            app.Button_8.Position = [11 13 53 22];

            % Create ButtonGroup_2
            app.ButtonGroup_2 = uibuttongroup(app.UIFigure);
            app.ButtonGroup_2.SelectionChangedFcn = createCallbackFcn(app, @ButtonGroup_2SelectionChanged, true);
            app.ButtonGroup_2.TitlePosition = 'centertop';
            app.ButtonGroup_2.Title = '特征值数';
            app.ButtonGroup_2.BackgroundColor = [0.5922 0.8353 0.9098];
            app.ButtonGroup_2.Position = [682 592 123 106];

            % Create Button_9
            app.Button_9 = uiradiobutton(app.ButtonGroup_2);
            app.Button_9.Text = '16';
            app.Button_9.Position = [11 57 35 22];
            app.Button_9.Value = true;

            % Create Button_10
            app.Button_10 = uiradiobutton(app.ButtonGroup_2);
            app.Button_10.Text = '8';
            app.Button_10.Position = [11 35 29 22];

            % Create Button_11
            app.Button_11 = uiradiobutton(app.ButtonGroup_2);
            app.Button_11.Text = '4';
            app.Button_11.Position = [11 13 29 22];

            % Create Button_12
            app.Button_12 = uibutton(app.UIFigure, 'push');
            app.Button_12.ButtonPushedFcn = createCallbackFcn(app, @Button_12Pushed, true);
            app.Button_12.Position = [561 297 244 42];
            app.Button_12.Text = '放大比较';

            % Create Button_13
            app.Button_13 = uibutton(app.UIFigure, 'push');
            app.Button_13.ButtonPushedFcn = createCallbackFcn(app, @Button_13Pushed, true);
            app.Button_13.Position = [564 31 217 43];
            app.Button_13.Text = '放大比较';

            % Create Button_5
            app.Button_5 = uibutton(app.UIFigure, 'push');
            app.Button_5.ButtonPushedFcn = createCallbackFcn(app, @Button_5Pushed, true);
            app.Button_5.BackgroundColor = [0 0.4471 0.7412];
            app.Button_5.FontSize = 20;
            app.Button_5.FontColor = [1 1 1];
            app.Button_5.Position = [399 652 163 54];
            app.Button_5.Text = '保存图片';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = PCA_app_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end