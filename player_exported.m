classdef player_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        CheckDealersHandButton  matlab.ui.control.Button
        UITable                 matlab.ui.control.Table
        rollsumEditField        matlab.ui.control.NumericEditField
        rollsumEditFieldLabel   matlab.ui.control.Label
        PlayerLabel             matlab.ui.control.Label
        Image2                  matlab.ui.control.Image
        Image                   matlab.ui.control.Image
        stayButton              matlab.ui.control.Button
        rollButton              matlab.ui.control.Button
    end

    properties (Access = private)
    % functions to update scores and sums
    playerScore 
    dealerScore
    tableSum2
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
    app.UITable.RowName{2}='Player';
    app.UITable.Data=zeros(2);
    app.tableSum2=0;
    % disable buttons until they update scores
    app.rollButton.Enable = 'off';
    app.stayButton.Enable = 'off';
    app.playerScore = 0;
    app.dealerScore = 0;
        end

        % Button pushed function: rollButton
        function rollButtonPushed(app, event)
      % set randomized dice
    app.stayButton.Enable = 'on';
    dice1=randi(6);
        dice2=randi(6);
         % annimation effect for dice
         app.Image.ImageSource='diceroll.gif';
    app.Image2.ImageSource='diceroll.gif';
    % special effect: sound added
    [y, fs] = audioread('dice-142528.mp3');
    sound(y, fs);
         % special feature: changes color of button once pressed
        
        set(app.rollButton,'BackgroundColor','#bedbb4');pause (0.1)
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
    rollsum=dice1+dice2;
    app.rollsumEditField.Value=rollsum;
    app.tableSum2=app.tableSum2+rollsum;
    app.UITable.Data(2)=app.tableSum2;
    % ensures that a player can't continue to roll once they pass 21
        if app.tableSum2 >= 21
            app.rollButton.Enable = 'off';
        end        
        end

        % Button pushed function: stayButton
        function stayButtonPushed(app, event)
    % disables roll button when player chooses to stay
    app.rollButton.Enable = 'off';
    app.stayButton.Enable = "off";
    % assignes scores to players bases on the updated scores 
    if app.UITable.Data(2) > app.UITable.Data(1) && app.UITable.Data(2) < 21
    app.playerScore = app.playerScore + 1;
    app.UITable.Data(4)=app.playerScore;
    elseif app.UITable.Data(1) > app.UITable.Data(2) && app.UITable.Data(1) < 21
    app.dealerScore = app.dealerScore +1;
    app.UITable.Data(3) = app.dealerScore;
    elseif app.UITable.Data(2) > 21 && app.UITable.Data(1) < 21
    app.dealerScore = app.dealerScore +1;
    app.UITable.Data(3) = app.dealerScore;
    elseif app.UITable.Data(2) == 21
    app.playerScore = app.playerScore+2;
    app.UITable.Data(4)=app.playerScore;
    elseif app.UITable.Data(1) == 21
    app.dealerScore = app.dealerScore+2;
    app.UITable.Data(3)=app.dealerScore;
    end
    % write score data into thingspeak
    thingSpeakWrite(app.channelID2, 'WriteKey', app.writeKey2, 'Fields', 1, 'Values',app.playerScore);
    thingSpeakWrite(app.channelID3, 'WriteKey', app.writeKey3, 'Fields', 1, 'Values',app.dealerScore);
    app.UITable.Data(1) = 0;
    app.UITable.Data(2) = 0;
    app.tableSum2 = 0;
    % once players reach 10, they are given screen indicating win
    if app.UITable.Data(3) == 10 
    dealerwin
    elseif app.UITable.Data(4) == 10
    playerwin
    end
        end

        % Button pushed function: CheckDealersHandButton
        function CheckDealersHandButtonPushed(app, event)
    % enables roll button only once player checks sums and
    % dealer rolls
    app.UITable.Data(1) = thingSpeakRead(app.channelID1, 'ReadKey', app.readKey1, 'Fields', 1);
    if app.UITable.Data(1) >0
    app.rollButton.Enable = 'on';
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

            % Create rollButton
            app.rollButton = uibutton(app.UIFigure, 'push');
            app.rollButton.ButtonPushedFcn = createCallbackFcn(app, @rollButtonPushed, true);
            app.rollButton.BackgroundColor = [0.851 0.9608 0.8118];
            app.rollButton.FontName = 'Comic Sans MS';
            app.rollButton.FontSize = 14;
            app.rollButton.FontColor = [0.0392 0.0392 0.0392];
            app.rollButton.Position = [336 80 126 43];
            app.rollButton.Text = 'roll';

            % Create stayButton
            app.stayButton = uibutton(app.UIFigure, 'push');
            app.stayButton.ButtonPushedFcn = createCallbackFcn(app, @stayButtonPushed, true);
            app.stayButton.BackgroundColor = [1 0.7882 0.7882];
            app.stayButton.FontName = 'Comic Sans MS';
            app.stayButton.FontSize = 14;
            app.stayButton.Position = [484 80 126 43];
            app.stayButton.Text = 'stay';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [358 253 100 100];
            app.Image.ImageSource = fullfile(pathToMLAPP, 'Dice 1.png');

            % Create Image2
            app.Image2 = uiimage(app.UIFigure);
            app.Image2.Position = [497 253 100 100];
            app.Image2.ImageSource = fullfile(pathToMLAPP, 'Dice 1.png');

            % Create PlayerLabel
            app.PlayerLabel = uilabel(app.UIFigure);
            app.PlayerLabel.FontName = 'Comic Sans MS';
            app.PlayerLabel.FontSize = 36;
            app.PlayerLabel.Position = [401 388 108 49];
            app.PlayerLabel.Text = 'Player';

            % Create rollsumEditFieldLabel
            app.rollsumEditFieldLabel = uilabel(app.UIFigure);
            app.rollsumEditFieldLabel.BackgroundColor = [0.9882 0.8706 0.9882];
            app.rollsumEditFieldLabel.HorizontalAlignment = 'right';
            app.rollsumEditFieldLabel.FontName = 'Comic Sans MS';
            app.rollsumEditFieldLabel.Position = [387 154 49 22];
            app.rollsumEditFieldLabel.Text = 'roll sum';

            % Create rollsumEditField
            app.rollsumEditField = uieditfield(app.UIFigure, 'numeric');
            app.rollsumEditField.BackgroundColor = [0.9882 0.8706 0.9882];
            app.rollsumEditField.Position = [451 154 100 22];

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.BackgroundColor = [0.9882 0.8706 0.9882;0.9882 0.8706 0.9882];
            app.UITable.ColumnName = {'total sum'; 'total score'};
            app.UITable.RowName = {'player 1, player 2'};
            app.UITable.FontName = 'Comic Sans MS';
            app.UITable.Position = [51 200 239 162];

            % Create CheckDealersHandButton
            app.CheckDealersHandButton = uibutton(app.UIFigure, 'push');
            app.CheckDealersHandButton.ButtonPushedFcn = createCallbackFcn(app, @CheckDealersHandButtonPushed, true);
            app.CheckDealersHandButton.FontName = 'Comic Sans MS';
            app.CheckDealersHandButton.Position = [105 139 132 23];
            app.CheckDealersHandButton.Text = 'Check Dealer''s Hand';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = player_exported

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