classdef dealer_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        UpdateScoreButton      matlab.ui.control.Button
        DealerLabel            matlab.ui.control.Label
        Image2                 matlab.ui.control.Image
        Image                  matlab.ui.control.Image
        rollsumEditField       matlab.ui.control.NumericEditField
        rollsumEditFieldLabel  matlab.ui.control.Label
        UITable                matlab.ui.control.Table
        DealSumButton          matlab.ui.control.Button
        RollButton             matlab.ui.control.Button
    end

    properties (Access = private)
    % functions to update sums
    tableSum1
    rollsum
    % thingspeak information for channels used
     channelID1 = 2371128;
     userAPIKey ='CHJDG2VMMWZXYG8O';
     readKey1 = 'V68TQ0F02R7BJZP3';
     writeKey1 = 'AXFW1ZR4SP6DM6F7';

     channelID2 = 2371130;
     readKey2 = '1RP9MWCGN0V5URK1';
     writeKey2 = 'OOQZA39H7Q8WGVFB';

     channelID3 = 2371135;
     readKey3 = 'QEE49N4MYRPZFA46';
     writeKey3 = '0EFZQJJK7HK79O4T';
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
        % initializes table which lets players keep track of scores and sums
        % of rolls
        app.UITable.ColumnName{1}='Total Sum';
        app.UITable.ColumnName{2}='Total Scores';
        app.UITable.RowName{1}='Dealer';
        app.UITable.RowName{2}='Player ';
        app.UITable.Data=zeros(2);
        app.tableSum1=0;  
        app.DealSumButton.Enable = 'off';
        app.UpdateScoreButton.Enable = 'off';

        end

        % Button pushed function: RollButton
        function RollButtonPushed(app, event)
       % set randomized dice
        app.DealSumButton.Enable = 'on';
        dice1=randi(6);
        dice2=randi(6);
        app.rollsum=0;
        % annimation effect for dice
           app.Image.ImageSource='diceroll.gif';
           app.Image2.ImageSource='diceroll.gif';
           % special effect: sound added
           [y, fs] = audioread('dice-142528.mp3');
     sound(y, fs);
      % special feature: changes color of button once pressed
                set(app.RollButton,'BackgroundColor','#bedbb4');pause (0.1)
               % sets image to the dice number rolled for each dice
                if dice1==1
                    app.Image.ImageSource='Dice 1.png';
                elseif dice1==2
                    app.Image.ImageSource='Dice 2.png';
                elseif dice1==3
                    app.Image.ImageSource='Dice 3.png';
                elseif dice1==4
                    app.Image.ImageSource='Dice 4.png';
                elseif dice1==5
                    app.Image.ImageSource='Dice 5.png';
                elseif dice1==6
                   app.Image.ImageSource='Dice 6.png';
                end
                if dice2==1
                    app.Image2.ImageSource='Dice 1.png';
                elseif dice2==2
                    app.Image2.ImageSource='Dice 2.png';
                elseif dice2==3
                    app.Image2.ImageSource='Dice 3.png';
                elseif dice2==4
                    app.Image2.ImageSource='Dice 4.png';
                elseif dice2==5
                    app.Image2.ImageSource='Dice 5.png';
                elseif dice2==6
                   app.Image2.ImageSource='Dice 6.png';
                end
 % adds both dice numbers rolled and displays them on dealers
 % column
app.rollsum=dice1+dice2;
app.rollsumEditField.Value=app.rollsum;
app.tableSum1=app.tableSum1+app.rollsum;
app.UITable.Data(1)=app.tableSum1;

% ensures that a player can't continue to roll once they pass 21
                if app.tableSum1 >= 21
                    app.RollButton.Enable = 'off'; 
                end
        
        end

        % Button pushed function: DealSumButton
        function DealSumButtonPushed(app, event)
       % disable the roll button when dealer finishes their roll
        app.RollButton.Enable = 'off';
        app.DealSumButton.Enable = 'on';
        pause(1)
        % goes into thingspeak in order to share dealers sum to other player
        thingSpeakWrite(app.channelID1, 'WriteKey', app.writeKey1, 'Fields', 1, 'Values',app.tableSum1);
       % updates table in order for player to see their current points
        app.UpdateScoreButton.Enable = 'on';
        app.DealSumButton.Enable = 'off';
        app.UITable.Data(1) = 0;
    
        end

        % Button pushed function: UpdateScoreButton
        function UpdateScoreButtonPushed(app, event)
        % button lets dealer see the updated points awarded to each player
        % reades data from other app into this app to update scores 
        app.UITable.Data(3) = thingSpeakRead(app.channelID3, 'ReadKey', app.readKey3, 'Fields', 1);
        app.UITable.Data(4) = thingSpeakRead(app.channelID2, 'ReadKey', app.readKey2, 'Fields', 1);
        app.UpdateScoreButton.Enable = 'on';
        % lets player roll again, starting next round after they update
        % sccores
        app.RollButton.Enable = 'on';
        app.DealSumButton.Enable = 'on';
        app.UITable.Data(1) = 0;
        app.tableSum1 = 0;
        % once players reach 10, they are given screen indicating win
           if app.UITable.Data(3) == 10 
            dealerwin
           elseif app.UITable.Data(4) == 10
            playerwin
            end
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

            % Create RollButton
            app.RollButton = uibutton(app.UIFigure, 'push');
            app.RollButton.ButtonPushedFcn = createCallbackFcn(app, @RollButtonPushed, true);
            app.RollButton.BackgroundColor = [0.851 0.9608 0.8118];
            app.RollButton.FontName = 'Comic Sans MS';
            app.RollButton.FontSize = 14;
            app.RollButton.FontColor = [0.0392 0.0392 0.0392];
            app.RollButton.Position = [336 80 126 43];
            app.RollButton.Text = 'Roll';

            % Create DealSumButton
            app.DealSumButton = uibutton(app.UIFigure, 'push');
            app.DealSumButton.ButtonPushedFcn = createCallbackFcn(app, @DealSumButtonPushed, true);
            app.DealSumButton.BackgroundColor = [1 0.7882 0.7882];
            app.DealSumButton.FontName = 'Comic Sans MS';
            app.DealSumButton.FontSize = 14;
            app.DealSumButton.Position = [484 80 126 43];
            app.DealSumButton.Text = 'Deal Sum';

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.BackgroundColor = [0.9882 0.8706 0.9882;0.9882 0.8706 0.9882];
            app.UITable.ColumnName = {'col1'; 'col2'};
            app.UITable.RowName = {'1,2'};
            app.UITable.FontName = 'Comic Sans MS';
            app.UITable.Position = [27 213 239 162];

            % Create rollsumEditFieldLabel
            app.rollsumEditFieldLabel = uilabel(app.UIFigure);
            app.rollsumEditFieldLabel.BackgroundColor = [0.9882 0.8706 0.9882];
            app.rollsumEditFieldLabel.HorizontalAlignment = 'right';
            app.rollsumEditFieldLabel.FontName = 'Comic Sans MS';
            app.rollsumEditFieldLabel.Position = [378 154 49 22];
            app.rollsumEditFieldLabel.Text = 'roll sum';

            % Create rollsumEditField
            app.rollsumEditField = uieditfield(app.UIFigure, 'numeric');
            app.rollsumEditField.BackgroundColor = [0.9882 0.8706 0.9882];
            app.rollsumEditField.Position = [442 154 100 22];

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [350 253 100 100];
            app.Image.ImageSource = fullfile(pathToMLAPP, 'Dice 1.png');

            % Create Image2
            app.Image2 = uiimage(app.UIFigure);
            app.Image2.Position = [489 253 100 100];
            app.Image2.ImageSource = fullfile(pathToMLAPP, 'Dice 1.png');

            % Create DealerLabel
            app.DealerLabel = uilabel(app.UIFigure);
            app.DealerLabel.FontName = 'Comic Sans MS';
            app.DealerLabel.FontSize = 36;
            app.DealerLabel.Position = [412 384 116 49];
            app.DealerLabel.Text = 'Dealer';

            % Create UpdateScoreButton
            app.UpdateScoreButton = uibutton(app.UIFigure, 'push');
            app.UpdateScoreButton.ButtonPushedFcn = createCallbackFcn(app, @UpdateScoreButtonPushed, true);
            app.UpdateScoreButton.FontName = 'Comic Sans MS';
            app.UpdateScoreButton.Position = [86 114 100 23];
            app.UpdateScoreButton.Text = 'Update Score';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = dealer_exported

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