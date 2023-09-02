
% PURPOSE: A brightness discrimination experiment (2afc paradigm)
% 
% CONTEXT: Course "Programming for Behavioral and Neurosciences" at
%          Justus Liebig University Giessen <https://www.uni-giessen.de>.
%          Modified as part of the seminar "Introduction to Computational
%          Modelling" at JLU Giessen.
% 
% AUTHOR: 2023 Marvin Theiss
% 
% LICENSE: MIT License
% 
% Copyright (c) 2023 Marvin Theiss
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.


%----------------------------------------------------------------------
%   CLEAN UP & CONFIGURE PTB
%----------------------------------------------------------------------

sca
close all
clear
clc

% Perform basic configuration of PTB parameters
% NOTE: Type "help configurePsych" into the command window for details on
% how to modify this command to fit your needs.
Config = configurePsych();

% Seed the random number generator
rng('shuffle')


%----------------------------------------------------------------------
%   EXPERIMENTAL SETUP
%----------------------------------------------------------------------

%------------------------------------------------------------------
%       CONFIGURATION OF EXPERIMENT
%------------------------------------------------------------------

% Set number of different brightnesses to use
% NOTE: This needs to be an odd number!  That way, there are as many
% brightnesses brighter than the base brightness as there are
% brightnesses that are less bright than the base brightness.
nBrightnesses = 15;

% Set the range the brightnesses are to cover (as a fraction of the full
% range from black to white)
% EXAMPLE: By setting 'Brightness.rangePct' to 30, the brightnesses will
% range from 0.35 to 0.65 as this corresponds to (0.65 - 0.35) / 1 = 30 %
% of the full range available (assuming that the intensity value of white
% equals 1 and that of black equals 0).
Brightness.rangePct = 10;  % in pct

% 'nReps' controls how many times each brightness is shown to the
% participant
% NOTE: This needs to be a positive integer!
nReps = 25;

% 'Progress.thresholdPct' can be modified to control how often the
% participant is informed about his/her progress
% EXAMPLE: By setting 'Progress.thresholdPct' to 20, the participant is
% informed about his/her progress after 20 %, 40 %, 60 % and 80 % of all
% trials.
% NOTE: While this script does work for arbitrary numbers between 1 and 100,
% the value of 'Progress.thresholdPct' should be chosen reasonably.
% Sensible choices would be 5 %, 10 %, 20 % or 25 %.
Progress.thresholdPct = 20;  % in pct

% Set duration to wait before presenting the fixation cross after the
% participant has started the trial
Duration.waitSecs = 0.1;  % in secs

% The next two parameters set the minimum & maximum duration of the
% fixation cross prior to the two brightnesses being presented
Duration.fixCrossMinSecs = 0.5;  % in secs
Duration.fixCrossMaxSecs = 2;    % in secs

% Set duration of stimuli (i.e., squares of different brightnesses) being
% presented (constant across trials)
Duration.stimulusSecs = 0.2;  % in secs

% Set text size and font
% NOTE: This script was developed on a 16" laptop.  For laptops of
% different sizes, 'txtSize' will most likely need some adjustment.
txtSize = 40;
txtFont = 'Helvetica';

% If the PTB window is opened in 'debugMode' (i.e., the window only covers
% 25 % of the screen), we scale down the text size accordingly
if Config.debugMode
    txtSize = round(0.5 * txtSize);
end


%------------------------------------------------------------------
%       KEYBOARD SETTINGS
%------------------------------------------------------------------

% NOTE: The command "KbName('UnifyKeyNames')" is automatically executed by
% the command 'PsychDefaultSetup(2)', which is issued within the function
% 'configurePsych'.  The latter is called at the very beginning of this
% script.

% Set keys
% NOTE: The space bar will be used by participants to start individual
% trials.  To indicate a decision, participants will press either the left
% arrow key or the right arrow key.  Finally, the escape key can be used to
% prematurely end the experiment prior to the start of each trial.
Key.space = KbName('SPACE');
Key.leftArrow = KbName('LEFTARROW');
Key.rightArrow = KbName('RIGHTARROW');
Key.escape = KbName('ESCAPE');


%------------------------------------------------------------------
%       INSTRUCTION/ERROR MESSAGES
%------------------------------------------------------------------

% Message to be displayed at the very beginning of the experiment
Msg.instructions = [ ...
    'In this experiment, you will be performing a simple brightness\n' ...
    'discrimination task. The experiment consists of multiple trials.\n' ...
    'Each trial will follow the exact same structure:\n\n' ...
    '1.) You decide when to start each trial by pressing the space bar.\n\n' ...
    '2.) A fixation cross will appear at the center of the screen.\n' ...
    'You are asked to fixate this cross throughout the entire trial.\n\n' ...
    '3.) Two squares will appear on the screen (left and right to the\n' ...
    'cross). Keep fixating the cross in the center of the screen.\n\n' ...
    '4.) Both squares and the fixation cross will vanish.\n\n' ...
    '5.) You are asked to judge which square was darker. Press the left\n' ...
    'arrow key for the left square or the right arrow key for the right ' ...
    'square.\n\n' ...
    'Press space to continue.'];

% Message to be displayed before a trial is started
Msg.startTrial = 'Press space to start the trial.';

% Message to be displayed after the stimuli have been presented and the
% participant is asked to make a judgement
Msg.makeDecision = ['Which square was darker?\n\n' ...
    'Left or right?'];

% Message to be displayed to inform the participant about his/her progress
Msg.progress = ['You have completed %d %% of all trials.\n\n' ...
    'Press space to continue.'];

% Thank-you-message presented at the end of the experiment
Msg.thankYou = ['You have completed the experiment!\n' ...
    'Thank you for participating!\n\n' ...
    'This window will close automatically in: %d'];

% Error message that is printed to the command window if the participant
% does not provide any information through the dialog box
Msg.errorNoInput = ['No participant information was entered into the ' ...
    'dialog box. Please start the experiment again.'];

% Error message that is printed to the command window if an invalid
% participant ID was entered into the dialog box that is opened at the
% beginning of the experiment
Msg.errorInvalidID = ...
    'Participant ID is not valid, expected an integer between 1 and 999!';

% Error message that is printed to the command window if an invalid sex
% was entered into the dialog box that is opened at the beginning of the
% experiment
Msg.errorInvalidSex = ...
    'Participant sex is not valid, expected one of m, w, d!';

% Error message that is printed to the command window if an invalid
% year of birth was entered into the dialog box that is opened at the
% beginning of the experiment
Msg.errorInvalidYoB = ...
    'Participant''s year of birth is not valid, expected a positive integer!';

% Error message that is printed to the command window if a participant ID
% is chosen that already exists and the entered participant data does not
% match previously entered data
Msg.errorInvalidParticipantData = ['Participant data does not match ' ...
    'previously entered data. Please enter the same data or choose a ' ...
    'different ID!'];

% Error message that is printed to the command window if participant ends
% the experiment prematurely
Msg.errorExptAborted = ['The participant has ended the experiment ' ...
    'prematurely.\n' ...
    'A total of %d trials out of %d trials have been completed.\n' ...
    'All data collected so far was saved.'];


%------------------------------------------------------------------
%       STIMULI SETUP
%------------------------------------------------------------------

% Define black and white
% NOTE: There also exists a Psychtoolbox function 'BlackIndex'.  However,
% this function always returns 0, so it doesn't make sense to call it.
Color.black = 0;
Color.white = WhiteIndex(Config.screenNumber);

% Compute different brightnesses (equal increments between any two
% consecutive brightnesses)
Brightness.base = Color.white / 2;
lowerEnd = Brightness.base - ...
    (Color.white * Brightness.rangePct / (100 * 2));
upperEnd = Brightness.base + ...
    (Color.white * Brightness.rangePct / (100 * 2));
Brightness.intensityArray = round( ...
    linspace(lowerEnd, upperEnd, nBrightnesses), 4);

% Clean up workspace
clear lowerEnd upperEnd


%------------------------------------------------------------------
%       POSITIONING OF SQUARES & FIXATION CROSS
%------------------------------------------------------------------

% We want both squares to be centered at the center of the respective
% half of the screen
Config.xCenterLeft = floor(Config.xCenter / 2);
Config.xCenterRight = floor(Config.xCenter / 2 * 3);

% Length of a single side of the squares in pixels (set relative to size of
% the window so that it scales with different screen sizes)
sizeSquare = floor(Config.widthPixels / 4);  % in pixels

% Compute coordinates of both squares
rectSquare = [0, 0, sizeSquare, sizeSquare];
posLeftSquare = CenterRectOnPoint(rectSquare, Config.xCenterLeft, ...
    Config.yCenter);
posRightSquare = CenterRectOnPoint(rectSquare, Config.xCenterRight, ...
    Config.yCenter);

% We set the length of the bars of the fixation cross to 4 % of the window
% height.  This way, it scales with different screen sizes.
fixCrossSize = floor(Config.heightPixels * 4 / 100);  % in pixels

% Thickness of the fixation cross
fixCrossWidth = 2;  % in pixels

% Clean up workspace
clear rectSquare sizeSquare


%------------------------------------------------------------------
%       TRIAL STRUCTURE
%------------------------------------------------------------------

% Compute total number of trials
nTrials = nBrightnesses * nReps;

% Set up a table that stores all information needed to control/conduct the
% experiment (e.g., which brightness is shown when and where).  We also use
% this table to store the participant's responses.
varNames = ["Order", "ID", "Intensity", "BasePos", "BrightnessDiff", ...
    "DurationFixCrossSecs", "Repetition", "Response", ...
    "BrightnessJudgement", "Correctness"];

varTypes = ["double", "double", "double", "string", "double", "double", ...
    "double", "string", "string", "double"];

% Preallocate table
trials = table('Size', [nTrials, length(varNames)], ...
    'VariableTypes', varTypes, 'VariableNames', varNames);

% Set random trial order
trials.Order = randperm(nTrials)';

% The trial ID is an integer that can be used to uniquely identify the pair
% of brightnesses shown to the participant
trials.ID = repmat(1:nBrightnesses, 1, nReps)';

% Assign unique brightness to each unique trial ID (from darkest to
% brightest)
trials.Intensity = repmat(Brightness.intensityArray, 1, nReps)';

% Randomly choose at which side of the screen the base brightness will be
% presented in each trial
posOptions = ["left", "right"];
trialPos = randi(2, nTrials, 1);
trials.BasePos = posOptions(trialPos)';

% Compute brightness differences
% NOTE: Positive values correspond to trials where the presented brightness
% is brighter than the base brightness.  Negative values correspond to
% trials where the presented brightness is darker than the base brightness.
trials.BrightnessDiff = round( ...
    trials.Intensity - Brightness.base, 4);

% Randomize the duration that the fixation cross is presented by itself
% before the two stimuli (i.e., squares of different brightnesses) are
% shown to the participant
trials.DurationFixCrossSecs = Duration.fixCrossMinSecs + ( ...
    Duration.fixCrossMaxSecs - Duration.fixCrossMinSecs ...
    ) .* rand(nTrials, 1);  % in secs

% Sort the table 'trials' by its column 'Order' (which was poulated with
% the numbers from 1 to 'nTrials' in random order) to achieve a randomized
% order of trials
trials = sortrows(trials, 'Order');

% For each trial, compute how often the brightness shown in that trial has
% already been shown to the participant (including the current trial)
for iTrial = 1:nTrials
    trials.Repetition(iTrial) = sum( ...
        trials.ID(1:iTrial) == trials.ID(iTrial));
end

% Clean up workspace
clear posOptions trialPos varNames varTypes


%----------------------------------------------------------------------
%   RECORD PARTICIPANT DATA
%----------------------------------------------------------------------

% Record some basic data of our participant using a dialog box
prompt = {'Participant ID (1 - 999):', ...
    'Please enter your sex (m/w/d):', ...
    'Please enter your year of birth:'};
dlgtitle = 'Participant Data';
dims = [1, 40];
answer = inputdlg(prompt, dlgtitle, dims);

% Check if the participant closed the dialog box or clicked on 'Cancel'
if isempty(answer)
    error(Msg.errorNoInput);
end

% Store input in struct 'Participant'
Participant.id = str2double(answer{1});
Participant.sex = upper(answer{2});
Participant.yob = str2double(answer{3});

% Ensure that the data provided by the participant is valid
%   a) Check participant ID (expected to be integer between 1 and 999)
assert(isnumeric(Participant.id) && isreal(Participant.id) && ...
    isfinite(Participant.id) && mod(Participant.id, 1) == 0 && ...
    1 <= Participant.id && Participant.id <= 999, Msg.errorInvalidID);

%   b) Check participant sex (expected to be one of 'M', 'W', 'D')
assert(ismember(Participant.sex, {'M', 'W', 'D'}), ...
    Msg.errorInvalidSex);

%   c) Check participant's year of birth (expected to be positive integer)
assert(isnumeric(Participant.yob) && isreal(Participant.yob) && ...
    isfinite(Participant.yob) && mod(Participant.yob, 1) == 0 && ...
    Participant.yob > 0, Msg.errorInvalidYoB);

% Convert ID to nicely formatted string (e.g., the number 1 will be
% converted to the string "001") and store participant data in table
Participant.id = string(sprintf('%03d', Participant.id));
participantData = table( ...
    Participant.id, string(Participant.sex), Participant.yob, ...
    'VariableNames', ["ID", "Sex", "YearOfBirth"]);

% Make sure that subdirectoy 'data/participants' exists
% NOTE: This will also work if the directory 'data' does not yet exist.
if ~isfolder(fullfile('data', 'participants'))
    mkdir(fullfile('data', 'participants'))
end

% Construct filename
filename = fullfile('data', 'participants', Participant.id + ".csv");

% If participant ID already exists, make sure that entered participant data
% coincides with previously entered data, else create a new file
if isfile(filename)
    prevParticipantData = readtable(filename);
    identicalSex = strcmp(participantData.Sex, prevParticipantData.Sex);
    identicalYoB = ...
        participantData.YearOfBirth == prevParticipantData.YearOfBirth;
    if ~(identicalSex && identicalYoB)
        error(Msg.errorInvalidParticipantData);
    end
else
    writetable(participantData, filename, 'Delimiter', ',');
end

% Create filename to store the results of the experiment
t = datetime("now", "Format", "yyyy-MM-dd");
filePattern = Participant.id + "_" + sprintf('%02d', nBrightnesses) ...
    + "-Lvls_" + sprintf('%02d', Brightness.rangePct) + "-PctRange_" ...
    + sprintf('%02d', nReps) + '-Reps_' + string(t) + "_v%d";
filePattern = fullfile("data", filePattern + ".csv");

% Clean up workspace
clear answer dims dlgtitle identicalSex identicalYoB nReps ...
    prevParticipantData prompt t


%----------------------------------------------------------------------
%   OPEN PTB WINDOW
%----------------------------------------------------------------------

try
    % Skip sync tests depending on configuration of 'Config.skipTest'
    Screen('Preference', 'SkipSyncTests', Config.skipTest);

    % Enable listening for keyboard input & suppress any output of key
    % presses to MATLAB windows (e.g., this script)
    % NOTE: Inside the function 'shutDown', the command 'ListenChar(0)' is
    % issued to turn off character listening and re-enable keyboard input!
    ListenChar(2);

    % Open new PTB window with black background
    [windowPtr, windowRect] = PsychImaging('OpenWindow', ...
        Config.screenNumber, Color.black, Config.winRect);

    % Hide cursor
    HideCursor(Config.screenNumber);

    % Set text size & font
    Screen('TextSize', windowPtr, txtSize);
    Screen('TextFont', windowPtr, txtFont);

    % Enable antialiasing
    Screen('BlendFunction', ...
        windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);


%------------------------------------------------------------------
%       OBTAIN TIMING INFORMATION
%------------------------------------------------------------------

    % Query frame duration
    Config.ifi = Screen('GetFlipInterval', windowPtr);

    % Set priority to maximum priority
    Priority(MaxPriority(windowPtr));

    % Convert duration of stimuli being presented from seconds to number of
    % frames
    Duration.waitFrames = round(Duration.waitSecs / Config.ifi);          % in frames
    Duration.stimulusFrames = round(Duration.stimulusSecs / Config.ifi);  % in frames


%----------------------------------------------------------------------
%   START OF EXPERIMENT
%----------------------------------------------------------------------

    % Compute the number of trials that correspond to multiples of 
    % 'Progress.thresholdPct' % of all trials
    Progress.nSteps = round(100 / Progress.thresholdPct);
    Progress.stepArray = round(linspace(0, nTrials, Progress.nSteps + 1));

    % Drop first entry (which is always equal to 0)
    Progress.stepArray = Progress.stepArray(2:end);

    % Present general instructions to participant
    DrawFormattedText(windowPtr, Msg.instructions, ...
        'center', 'center', Color.white);
    Screen('Flip', windowPtr);

    % Increase text size by 50 % for rest of experiment
    Screen('TextSize', windowPtr, 1.5 * txtSize);

    % Wait for participant to press the space bar to start the first trial
    KbReleaseWait(Config.keyboard);
    while true
        [~, ~, keyCode] = KbCheck(Config.keyboard);
        % Exit while-loop and continue if space bar has been pressed, else
        % continue checking the keyboard for input
        if keyCode(Key.space)
            break
        end
    end


%------------------------------------------------------------------
%       LOOP OVER INDIVIDUAL TRIALS
%------------------------------------------------------------------

    for iTrial = 1:nTrials
        % STEP 0: Report progress to participant
        if ismember(iTrial - 1, Progress.stepArray)
            % Compute progress
            Progress.completed = round((iTrial - 1) / nTrials * 100);  % in pct

            % Display progress to participant
            DrawFormattedText(windowPtr, ...
                sprintf(Msg.progress, Progress.completed), ...
                'center', 'center', Color.white);
            Screen('Flip', windowPtr);

            % Wait for participant to press the space bar to start the
            % next trial
            KbReleaseWait(Config.keyboard);
            while true
                [~, ~, keyCode] = KbCheck(Config.keyboard);
                if keyCode(Key.space)
                    break
                end
            end
        end


        % STEP 1: Prepare for trial
        %   1.1 Query presentation duration of fixation cross (in secs)
        %   and convert to number of frames
        durationFixCrossSecs = trials.DurationFixCrossSecs(iTrial);
        durationFixCrossFrames = round(durationFixCrossSecs / Config.ifi);

        %   1.2 Assign brightnesses to both squares
        if strcmp(trials.BasePos(iTrial), 'left')
            brightnessLeft = Brightness.base;
            brightnessRight = trials.Intensity(iTrial);
        else
            brightnessLeft = trials.Intensity(iTrial);
            brightnessRight = Brightness.base;
        end


        % STEP 2: Wait for participant to start the trial
        %   2.1 Display instructions on how to start the next trial
        DrawFormattedText(windowPtr, Msg.startTrial, ...
            'center', 'center', Color.white);
        Screen('Flip', windowPtr);

        %   2.2 Wait for participant to press the space bar to continue or
        %   to press the escape key to prematurely end the experiment
        KbReleaseWait(Config.keyboard);
        while true
            [~, ~, keyCode] = KbCheck(Config.keyboard);
            if keyCode(Key.space)
                break
            elseif keyCode(Key.escape)
                % Throw error containing number of completed (out of total)
                % trials
                error(Msg.errorExptAborted, iTrial - 1, nTrials);
            end
        end

        %   2.3 Wait 0.5 seconds before presenting the fixation cross.
        %   To do so, we wipe the screen, save a timestamp and then flip
        %   the fixation cross to the screen 0.5 seconds after this
        %   timestamp (see 3.2 below)
        [~, stimulusOnsetTime] = Screen('Flip', windowPtr);


        % STEP 3: Display fixation cross
        %   3.1 Draw fixation cross at the center of the screen
        %   NOTE: Type "help drawFixationCross" into the command window
        %   for further information.
        drawFixationCross(windowPtr, fixCrossSize, fixCrossWidth, ...
            Config.center, Color.white);

        %   3.2 Flip fixation cross to screen
        %   NOTE: We set 'dontclear' (fourth argument) to 1 for
        %   incremental drawing (since we also want the fixation cross
        %   to be displayed when the two squares are presented)
        [~, stimulusOnsetTime] = Screen('Flip', windowPtr, ...
            stimulusOnsetTime + (Duration.waitFrames-0.5) * Config.ifi, 1);


        % STEP 4: Display squares
        %   4.1 Draw both squares
        Screen('FillRect', windowPtr, brightnessLeft, posLeftSquare);
        Screen('FillRect', windowPtr, brightnessRight, posRightSquare);

        %   4.2 Flip squares to screen
        [~, stimulusOnsetTime] = Screen('Flip', windowPtr, ...
            stimulusOnsetTime + (durationFixCrossFrames-0.5) * Config.ifi);

        %   4.3 Wipe screen after the two squares have been presented
        %   for the timespan specified by 'Duration.stimulusFrames'
        %   (in number of frames)
        [~, stimulusOnsetTime] = Screen('Flip', windowPtr, ...
            stimulusOnsetTime + (Duration.stimulusFrames-0.5) * Config.ifi);


        % STEP 5: Wait for participant to make decision
        %   5.1 Display instructions on how to respond after screen has
        %   been left blank for 0.5 seconds
        DrawFormattedText(windowPtr, Msg.makeDecision, ...
            'center', 'center', Color.white);
        Screen('Flip', windowPtr, ...
            stimulusOnsetTime + (Duration.waitFrames-0.5) * Config.ifi);

        %   5.2 Wait for participant to give a valid response (left or
        %   right arrow key)
        KbReleaseWait(Config.keyboard);
        while true
            [~, ~, keyCode] = KbCheck(Config.keyboard);
            if keyCode(Key.leftArrow)
                response = 'left';
                break
            elseif keyCode(Key.rightArrow)
                response = 'right';
                break
            end
        end

        %   5.3 Store participant's response
        trials.Response(iTrial) = response;

        %   5.4 Determine whether participant judged the varying brightness
        %   (i.e., the brightness that is NOT the base brightness) to be
        %   lighter or darker than the base brightness
        if strcmp(trials.BasePos(iTrial), 'left')
            if strcmp(response, 'left')
                judgement = 'brighter';
            else % response = 'right'
                judgement = 'darker';
            end
        else % trials.BasePos(iTrial) = 'right'
            if strcmp(response, 'left')
                judgement = 'darker';
            else
                judgement = 'brighter';
            end
        end

        trials.BrightnessJudgement(iTrial) = judgement;

        %   5.5 Determine whether participant was correct or not
        %   NOTE: In case both squares were of the same brightness, we
        %   set the correctness to NaN, as there is no right or wrong
        %   answer.
        if trials.BrightnessDiff(iTrial) < 0 % varying darker than base
            correctness = strcmp(judgement, 'darker');
        elseif trials.BrightnessDiff(iTrial) > 0 % varying brighter than base
            correctness = strcmp(judgement, 'brighter');
        else % both brightnesses identical
            correctness = NaN;
        end

        trials.Correctness(iTrial) = correctness;
    end

    % Clean up workspace
    clear brightnessLeft brightnessRight correctness ...
        durationFixCrossFrames durationFixCrossSecs fixCrossSize ...
        fixCrossWidth iTrial judgement keyCode nTrials posLeftSquare ...
        posRightSquare response stimulusOnsetTime


%----------------------------------------------------------------------
%   END OF EXPERIMENT
%----------------------------------------------------------------------

    % Wipe screen
    Screen('Flip', windowPtr);
    WaitSecs(0.5);

    % Present thank-you-message to participant
    for secs = 10:-1:1
        DrawFormattedText(windowPtr, sprintf(Msg.thankYou, secs), ...
            'center', 'center', Color.white);
        Screen('Flip', windowPtr);
        WaitSecs(1);
    end

    % Wipe screen again before shutting down
    Screen('Flip', windowPtr);
    WaitSecs(0.5);

    % Clean up workspace
    clear ans secs


%------------------------------------------------------------------
%       SAVE DATA & SHUT DOWN
%------------------------------------------------------------------

    % Make sure that filename is unique
    counter = 1;
    while true
        filename = sprintf(filePattern, counter);
        if ~isfile(filename)
            break
        else
            counter = counter + 1;
        end
    end

    writetable(trials, filename, 'Delimiter', ',');

    % Turn off character listening, re-enable keyboard input and close all
    % open screens
    endExperiment();

    % Clean up workspace
    clear counter filePattern


%----------------------------------------------------------------------
%   ERROR HANDLING
%----------------------------------------------------------------------

catch errorMessage
    % Indicate that the collected data is incomplete
    filePattern = strrep(filePattern, 'data/', 'data/INCOMPLETE_');

    % Make sure that filename is unique
    counter = 1;
    while true
        filename = sprintf(filePattern, counter);
        if ~isfile(filename)
            break
        else
            counter = counter + 1;
        end
    end

    % Save data
    writetable(trials, filename, 'Delimiter', ',');

    % Clean up workspace
    clear ans brightnessLeft brightnessRight correctness counter ...
        durationFixCrossFrames durationFixCrossSecs filePattern ...
        fixCrossSize fixCrossWidth iTrial judgement keyCode nTrials ...
        posLeftSquare posRightSquare response secs stimulusOnsetTime

    % Turn off character listening, re-enable keyboard input and close all
    % open screens
    endExperiment();

    % Rethrow error message for debugging purposes
    rethrow(errorMessage);
end


%----------------------------------------------------------------------
%   HELPER FUNCTION(S)
%----------------------------------------------------------------------

function endExperiment()
% ENDEXPERIMENT - Turn off character listening and close all open screens
    ListenChar(0);
    Screen('CloseAll');
end
