
function Config = configurePsych(whichScreen, skipTest, debugMode)

% CONFIGUREPSYCH - Configure Psychtoolbox parameters
%    This MATLAB function returns parameters that can be used to set up
%    Psychtoolbox (PTB) before starting a new experiment.  Also, the command
%    'PsychDefaultSetup(2)' is issued to perform a standard setup of PTB.
%
%    INPUT ARGUMENTS
%      whichScreen (char) - Either 'main' or 'max'.  Used to set the field
%                           'Config.screenNumber', which can be used to
%                           specify the screen that PTB ought to open a
%                           new window on.  Defaults to 'main' if not
%                           specified.
%
%      skipTest (int) - Either 0 or 1.  Assigned to the field
%                       'Config.skipTest', which can be used to set the
%                       argument 'SkipSyncTests' when opening a new
%                       PTB window.  Defaults to 1 if not specified.
%
%      debugMode (logical) - Given that 'whichScreen' is set to 'main',
%                            this parameter is used to set the field
%                            'Config.debugMode', which influences the
%                            fields 'widthPixels', 'heightPixles',
%                            'widthMM', 'heightMM' 'winRect', 'xCenter',
%                            'yCenter' and 'center' of the struct 'Config'.
%                            If 'debugMode' is set to 'true', these values
%                            are computed relative to a window that is
%                            positioned in the top-left corner of the
%                            screen, covering only 25 % of the entire
%                            screen.  Does not have any effect if
%                            'whichScreen' is set to 'max'.  Defaults to
%                            'false' if not specified.
%
%    OUTPUT
%      Config (struct) - A 1 x 1 struct with fields whose values can be
%                        used to set up a new PTB session.
%
%    ASSUMPTIONS & LIMITATIONS
%      Psychtoolbox (<http://psychtoolbox.org>) needs to be installed.
%      For system requirements regarding the use of Psychtoolbox, please
%      check <http://psychtoolbox.org/requirements.html>.

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

arguments
    whichScreen char {mustBeMember(whichScreen, {'main', 'max'})} = 'main'
    skipTest (1, 1) { ...
        mustBeInteger, ...
        mustBeGreaterThanOrEqual(skipTest, 0), ...
        mustBeLessThanOrEqual(skipTest, 1) ...
        } = 1
    debugMode (1, 1) logical = false
end

% Perform standard setup of PTB
% NOTE: 'PsychDefaultSetup(featureLevel)' performs a standard setup of PTB,
% where 'featureLevel' determines what kind of setup is performed.
%   featureLevel = 0: executes the AssertOpenGL command, which ensures
%       that the Screen() .mex-file is properly installed and functional
%   featureLevel = 1: additionally executes "KbName('UnifyKeyNames')"
%       to provide a consistent mapping of keyCodes to key names on
%       all operating systems
%   featureLevel = 2: additionally implies the execution of
%       "Screen('ColorRange', window, 1, [], 1)", immediately after
%       and whenever "PsychImaging('OpenWindow', ...)" is called,
%       switching the default color range from the classic 0 - 255
%       integer number range to the normalized floating point number
%       range 0.0 - 1.0
PsychDefaultSetup(2);

% Determine whether PTB is supposed to open a new window in 'debugMode'
if strcmp(whichScreen, 'max')
    Config.debugMode = false;
else
    Config.debugMode = debugMode;
end

% Set field 'Config.skipTest', which can be used to set the argument
% 'SkipSyncTests' when opening a new PTB window
Config.skipTest = skipTest;

% Set which keyboard to use (here: any)
Config.keyboard = -1;

% "Screen('Screens')" assigns a number to each of the screens attached
% to the computer
Config.screens = Screen('Screens');

% Assign screen number to use for the PTB window to 'Config.screenNumber'
if strcmp(whichScreen, 'main')
    % Use main screen
    Config.screenNumber = 0;
else
    % Use screen detected last
    Config.screenNumber = max(Config.screens);
end

% Obtain screen size and assign width and height of chosen screen to
% corresponding fields of the struct 'Config'
[Config.widthPixels, Config.heightPixels] = Screen( ...
    'WindowSize', Config.screenNumber);
[Config.widthMM, Config.heightMM] = Screen( ...
    'DisplaySize', Config.screenNumber);

% Set 'Config.winRect' according to the value of 'Config.debugMode'.
% NOTE: If 'Config.debugMode' is set to 'true', we only use 25 % of the
% available screen and position the window in the top-left of the screen.
% Also, if 'Config.debugMode' is set to true, this implies that
% 'Config.screenNumber' is equal to 0!

if Config.debugMode
    % Scale with and height down to 50 %
    Config.widthPixels = floor(Config.widthPixels * 0.5);
    Config.heightPixels = floor(Config.heightPixels * 0.5);
    Config.widthMM = Config.widthMM * 0.5;
    Config.heightMM = Config.heightMM * 0.5;

    % Set window rectangle relative to screen's top-left corner
    Config.winRect = [0, 0, Config.widthPixels, Config.heightPixels];
else
    % Use entire available screen to open window
    Config.winRect = [];
end

% Obtain center coordinates of the specified window (relative to the
% window, NOT to the entire screen)
Config.xCenter = floor(Config.widthPixels / 2);    % in pixels
Config.yCenter = floor(Config.heightPixels / 2);   % in pixels
Config.center = [Config.xCenter, Config.yCenter];  % in pixels

% Compute pixels per mm
% NOTE: Theoretically, the two ratios we compute below should be identical.
% In practice, they're not.  So we simply take the mean of the two.
Config.pixelsPerMM = mean([Config.widthPixels / Config.widthMM, ...
                    Config.heightPixels / Config.heightMM]);

end
