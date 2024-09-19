classdef dealerwin_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure         matlab.ui.Figure
        RestartButton    matlab.ui.control.Button
        DealerWinsLabel  matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % special effect: sound added
           pause(3)
            [y, fs] = audioread('tada-fanfare-a-6313.mp3');
     sound(y, fs);
        end

        % Button pushed function: RestartButton
        function RestartButtonPushed2(app, event)
     % runs game again from start
            start_page
            app.delete
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.9882 0.8706 0.9882];
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create DealerWinsLabel
            app.DealerWinsLabel = uilabel(app.UIFigure);
            app.DealerWinsLabel.HorizontalAlignment = 'center';
            app.DealerWinsLabel.FontName = 'Comic Sans MS';
            app.DealerWinsLabel.FontSize = 48;
            app.DealerWinsLabel.Position = [161 205 320 105];
            app.DealerWinsLabel.Text = 'Dealer Wins!';

            % Create RestartButton
            app.RestartButton = uibutton(app.UIFigure, 'push');
            app.RestartButton.ButtonPushedFcn = createCallbackFcn(app, @RestartButtonPushed2, true);
            app.RestartButton.BackgroundColor = [0.851 0.9608 0.8118];
            app.RestartButton.FontName = 'Comic Sans MS';
            app.RestartButton.FontSize = 14;
            app.RestartButton.Position = [254 154 134 43];
            app.RestartButton.Text = 'Restart';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = dealerwin_exported

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