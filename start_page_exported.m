classdef start_page_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure            matlab.ui.Figure
        PlayerSTARTButton   matlab.ui.control.Button
        Image               matlab.ui.control.Image
        ExitButton          matlab.ui.control.Button
        InstructionsButton  matlab.ui.control.Button
        DealerSTARTButton   matlab.ui.control.Button
    end



    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: DealerSTARTButton
        function DealerSTARTButtonPushed(app, event)
         % opens dealer app if button pressed
           dealer
           app.delete
        end

        % Button pushed function: InstructionsButton
        function InstructionsButtonPushed(app, event)
            % opens instructions for playes with questions
            instructions_window
        end

        % Button pushed function: ExitButton
        function ExitButtonPushed(app, event)
            % removes app if button pressed
            delete(app)
        end

        % Button pushed function: PlayerSTARTButton
        function PlayerSTARTButtonPushed(app, event)
            player
            app.delete
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.9882 0.8706 0.9882];
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create DealerSTARTButton
            app.DealerSTARTButton = uibutton(app.UIFigure, 'push');
            app.DealerSTARTButton.ButtonPushedFcn = createCallbackFcn(app, @DealerSTARTButtonPushed, true);
            app.DealerSTARTButton.BackgroundColor = [0.851 0.9608 0.8118];
            app.DealerSTARTButton.FontName = 'Comic Sans MS';
            app.DealerSTARTButton.FontSize = 20;
            app.DealerSTARTButton.Position = [61 152 174 118];
            app.DealerSTARTButton.Text = {'Dealer'; 'START'};

            % Create InstructionsButton
            app.InstructionsButton = uibutton(app.UIFigure, 'push');
            app.InstructionsButton.ButtonPushedFcn = createCallbackFcn(app, @InstructionsButtonPushed, true);
            app.InstructionsButton.FontName = 'Comic Sans MS';
            app.InstructionsButton.FontSize = 20;
            app.InstructionsButton.Position = [254 86 134 50];
            app.InstructionsButton.Text = 'Instructions';

            % Create ExitButton
            app.ExitButton = uibutton(app.UIFigure, 'push');
            app.ExitButton.ButtonPushedFcn = createCallbackFcn(app, @ExitButtonPushed, true);
            app.ExitButton.FontName = 'Comic Sans MS';
            app.ExitButton.FontSize = 20;
            app.ExitButton.Position = [254 26 134 50];
            app.ExitButton.Text = 'Exit';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [83 291 475 237];
            app.Image.ImageSource = fullfile(pathToMLAPP, 'LOGO.png');

            % Create PlayerSTARTButton
            app.PlayerSTARTButton = uibutton(app.UIFigure, 'push');
            app.PlayerSTARTButton.ButtonPushedFcn = createCallbackFcn(app, @PlayerSTARTButtonPushed, true);
            app.PlayerSTARTButton.BackgroundColor = [0.851 0.9608 0.8118];
            app.PlayerSTARTButton.FontName = 'Comic Sans MS';
            app.PlayerSTARTButton.FontSize = 20;
            app.PlayerSTARTButton.Position = [404 152 174 118];
            app.PlayerSTARTButton.Text = {'Player'; 'START'};

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = start_page_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

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