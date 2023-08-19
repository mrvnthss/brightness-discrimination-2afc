
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

function plotStimuli(nBrightnesses, rangePct, nRows, nCols, whiteIndex)

% PLOTSTIMULI - Visualize different brightness intensities
%    This MATLAB function can be used to visualize brightness intensities
%    resulting from different parameter choices in a simple tile plot.
%    This can be used to get a first idea of how to choose the parameters
%    of the brightness discrimination experiment.
%
%    INPUT ARGUMENTS
%      nBrightnesses (int) - Number of different brightness intensities.
%                            Must be a positive integer.  Defaults to 15 if
%                            not specified.
%
%      rangePct (double) - Proportion of gray levels to be used from the
%                          full range from black to white.  Must be a
%                          positive integer no larger than 100.  Defaults
%                          to 10 if not specified.
%
%      nRows (int) - Number of rows of the tile plot.  Must divide
%                    'nBrightnesses'.  Defaults to 1 if not specified.
%
%      nCols (int) - Number of columns of the tile plot.  Must divide
%                    'nBrightnesses'.  Defaults to 'nBrightnesses' if not
%                    specified.
%
%      whiteIndex (double) - Intensity value to produce white at the
%                            current screen depth, assuming a standard
%                            color lookup table for that depth.  Defaults
%                            to 1 if not specified.
%
%    ASSUMPTIONS & LIMITATIONS
%      None

arguments
    nBrightnesses (1, 1) {mustBeInteger, mustBePositive} = 15
    rangePct (1, 1) double { ...
        mustBePositive, ...
        mustBeLessThanOrEqual(rangePct, 100) ...
        } = 10
    nRows (1, 1) {mustBeInteger, mustBePositive} = 1
    nCols (1, 1) {mustBeInteger, mustBePositive} = nBrightnesses
    whiteIndex (1, 1) {mustBePositive} = 1
end


% Compute different brightnesses (equal increments between any two
% consecutive brightnesses)
gray = whiteIndex / 2;
lowerEnd = gray - (whiteIndex * rangePct / (100 * 2));
upperEnd = gray + (whiteIndex * rangePct / (100 * 2));
brightnesses = round(linspace(lowerEnd, upperEnd, nBrightnesses), 4);

% Create a grayscale image using the selected brightnesses
image = reshape(brightnesses, nRows, nCols);

% Display the grayscale image
imshow(image);

end
