
function plotStimuli(standardStim, nComparisonStim, maxDifference)

% PLOTSTIMULI - Visualize comparison stimuli
%    This MATLAB function can be used to visualize the comparison stimuli
%    resulting from different parameter choices in a simple tile plot.
%    This can be used to get a first idea of how to choose the parameters
%    for the brightness discrimination experiment.
%
%    INPUT ARGUMENTS
%
%      standardStim (double) - Value of the standard stimulus.  Must be
%                              between 0 and 1.  Defaults to 0.5 if not
%                              specified.
%
%      nComparisonStim (int) - Number of comparison stimuli. Must be an odd
%                              integer.  Defaults to 9 if not specified.
%
%      maxDifference (double) - Maximum absolute difference between
%                               standard and comparison stimuli.  Must be
%                               greater than 0 and less than or equal to
%                               'standardStim' and 1 - 'standardStim'.
%                               Defaults to 0.1 if not specified.
%
%    ASSUMPTIONS & LIMITATIONS
%      None

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
    standardStim (1, 1) double { ...
        mustBeInRange(standardStim, 0, 1, "exclusive")} = 0.5
    nComparisonStim (1, 1) {mustBeInteger, mustBePositive, mustBeOdd} = 9
    maxDifference (1, 1) double { ...
        mustBePositive, ...
        mustBeValidMaxDiff(maxDifference, standardStim) ...
        } = 0.1
end

% Compute values for comparison stimuli (equal increments between any two
% consecutive values)
minComparisonStim = standardStim - maxDifference;
maxComparisonStim = standardStim + maxDifference;
comparisonStim = linspace( ...
    minComparisonStim, maxComparisonStim, nComparisonStim);

% Modify 'comparisonStim' vector for visualization purposes
nRows = (nComparisonStim-1) / 2;
comparisonStim = [comparisonStim(1:nRows), ...
    standardStim*ones(1, nRows), ...
    flip(comparisonStim(nRows+2:end))];

% Create a grayscale image using the selected brightnesses
image = reshape(comparisonStim, nRows, 3);
image = repelem(image, 100, 100);

% Display the grayscale image
imshow(image);

end


%------------------------------------------------------------------
%   CUSTOM VALIDATION FUNCTIONS
%------------------------------------------------------------------

% NOTE: The function 'mustBeOdd' assumes that the input 'value' is a
% positive integer.
function mustBeOdd(value)
% MUSTBEODD - Validate that value is an odd number
isOdd = mod(value, 2) == 1;

if ~isOdd
    eidType = 'mustBeOdd:notOdd';
    msgType = 'Value is not odd.';
    throwAsCaller(MException(eidType, msgType));
end


end

function mustBeValidMaxDiff(maxDifference, standardStim)
% MUSTBEVALIDMAXDIFF - Validate that maxDifference is chosen appropriately
isValid = maxDifference <= min(standardStim, 1-standardStim);

if ~isValid
    eidType = 'mustBeValidMaxDiff:notValidMaxDiff';
    msgType = ['Value of ''maxDifference'' must be less than ' ...
        '''standardStim'' and 1-''standardStim''.'];
    throwAsCaller(MException(eidType, msgType));
end

end
