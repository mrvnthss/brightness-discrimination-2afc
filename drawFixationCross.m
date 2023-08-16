
function drawFixationCross(windowPtr, fixCrossSize, fixCrossWidth, ...
    centerCoords, color)

% DRAWFIXATIONCROSS - Draw fixation cross on Psychtoolbox window
%    This MATLAB function draws a fixation cross at a specified location on
%    a specified Psychtoolbox (PTB) window.
%
%    INPUT ARGUMENTS
%      windowPtr (int) - Index of the PTB window that the fixation cross
%                        ought to be drawn on.
%
%      fixCrossSize (int) - Length of the bars that make up the fixation
%                           cross in pixels.  Must be positive.
%
%      fixCrossWidth (int) - Thickness of the bars that make up the
%                            fixation cross in pixels.  Must be positive.
%
%      centerCoords (int) - Coordinates of the center of the fixation cross
%                           in pixels.
%
%      color (double) - 1 x 3 vector representing a color in RGB color
%                       space.  Can also be a single value (grayscale).
%                       Color range is assumed to be the normalized
%                       floating point number range 0.0 - 1.0.  Defaults to
%                       0 (i.e., black) if not specified.
%
%    ASSUMPTIONS & LIMITATIONS
%      Psychtoolbox (http://psychtoolbox.org) needs to be installed.
%      For system requirements regarding the use of Psychtoolbox, please
%      check http://psychtoolbox.org/requirements.html.

arguments
    windowPtr (1, 1) double {mustBeInteger}
    fixCrossSize (1, 1) double {mustBeInteger, mustBePositive}
    fixCrossWidth (1, 1) double {mustBeInteger, mustBePositive}
    centerCoords (1, 2) double {mustBeInteger, mustBePositive}
    color (1, 3) double { ...
        mustBeGreaterThanOrEqual(color, 0), ...
        mustBeLessThanOrEqual(color, 1) ...
        } = 0
end

% Compute size of a single arm of the fixation cross
singleArmSize = floor(fixCrossSize ./ 2);  % in pixels

% Set up coordinates
xCoords = [-singleArmSize, singleArmSize, 0, 0];
yCoords = [0, 0, -singleArmSize, singleArmSize];
allCoords = [xCoords; yCoords];

% Draw fixation cross
Screen('DrawLines', windowPtr, ...
    allCoords, fixCrossWidth, color, centerCoords);

end
