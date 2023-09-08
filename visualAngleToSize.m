
function objSizeMM = visualAngleToSize(visualAngle, viewingDistanceMM, ...
    offsetMM, mode)

% VISUALANGLETOSIZE - Convert degrees of visual angle to size in mm
%    This MATLAB function converts visual angle in degrees to size of the
%    viewed object in mm.  Can be used for objects centered on the screen
%    as well as objects presented only on one half of the screen.  Objects
%    that are offset from the center of the screen can be handled as well.
%
%    INPUT ARGUMENTS
%      visualAngle (double) - The visual angle of the viewed object in
%                             degrees.  Must be positive and less than 180.
%                             Must be less than 90 if 'mode' is set to
%                             "oneSided".
%
%      viewingDistanceMM (double) - The (orthogonal) distance from eye to
%                                   screen in mm.  Must be positive.
%
%      offsetMM (double) - The distance from screen center to target in mm.
%                          Must be non-negative.  Must be 0 if 'mode' is
%                          set to "centered".  Defaults to 0 if not
%                          specified.
%
%      mode (string) - Either "centered" or "oneSided".  Defaults to
%                      "centered" if not specified.
%
%    OUTPUT
%      objSizeMM (double) - The size of the viewed target in mm.
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
    visualAngle (1, :) double {mustBePositive, ...
        mustBeLessThan(visualAngle, 180)}
    viewingDistanceMM (1, :) double { ...
        mustBePositive, ...
        mustBeEqualLength(viewingDistanceMM, visualAngle)}
    offsetMM (1, :) double { ...
        mustBeGreaterThanOrEqual(offsetMM, 0), ...
        mustBeEqualLength(offsetMM, visualAngle), ...
        mustBeEqualLength(offsetMM, viewingDistanceMM)} = 0
    mode (1, :) string { ...
        mustBeMember(mode, ["centered", "oneSided"]), ...
        mustBeEqualLength(mode, visualAngle), ...
        mustBeEqualLength(mode, viewingDistanceMM), ...
        mustBeEqualLength(mode, offsetMM), ...
        mustBeValidCombo(mode, visualAngle, offsetMM)} = "centered"
end

% Additional factor that's needed to compute object size in the "centered"
% condition
centeredFactor = ones(size(mode));
centeredFactor(mode == "centered") = 2;

% Visual angle in degrees corresponding to the offset in mm
offsetVA = atand(offsetMM ./ viewingDistanceMM);

% Final object size in mm
objSizeMM = centeredFactor .* tand( ...
    visualAngle ./ centeredFactor + offsetVA ...
    ) .* viewingDistanceMM - offsetMM;

end


%------------------------------------------------------------------
%   CUSTOM VALIDATION FUNCTIONS
%------------------------------------------------------------------

% NOTE: The function 'mustBeEqualLength' assumes that the two inputs 'a'
% and 'b' are vectors.
function mustBeEqualLength(a, b)
% MUSTBEEQUALLENGTH - Validate that two vectors are of equal length
isSameLength = length(a) == length(b);
isSingleton = min(length(a), length(b)) == 1;

if ~(isSameLength || isSingleton)
    eidType = 'mustBeEqualSize:notEqualSize';
    msgType = ['Size of input must equal size of remaining inputs' ...
        ' or input size must be 1x1.'];
    throwAsCaller(MException(eidType, msgType));
end

end


% NOTE: The function 'mustBeValidCombo' is only supposed to be used for the
% 'mode', 'visualAngle', and 'offsetMM' arguments passed to the
% 'visualAngleToSize' function!  Whenever 'mode' is set to "centered",
% 'offsetMM' must equal 0!  If 'mode' is "oneSided", 'visualAngle' must be
% less than 90.
function mustBeValidCombo(mode, visualAngle, offsetMM)
% MUSTBEVALIDCOMBO - Validate compatibility of arguments

% NOTE: We know that all arguments are either of the same length or of size
% 1x1.  We now make sure that they are actually the same length, b/c we'll
% need this later.
commonLength = max([length(mode), length(visualAngle), length(offsetMM)]);

if length(mode) < commonLength
    mode = repmat(mode, 1, commonLength);
end

if length(visualAngle) < commonLength
    visualAngle = repmat(visualAngle, 1, commonLength);
end

if length(offsetMM) < commonLength
    offsetMM = repmat(offsetMM, 1, commonLength);
end

modeAndVisualAngleCompatible = all(visualAngle(mode == "oneSided") < 90);
modeAndOffsetCompatible = all(offsetMM(mode == "centered") == 0);

if ~modeAndVisualAngleCompatible
    eidType = 'mustBeValidCombo:invalidCombo';
    msgType = "Arguments 'mode' and 'visualAngle' not compatible! " + ...
        "Whenever 'mode' is set to ""oneSided"", 'visualAngle' must " + ...
        "be less than 90!";
    throwAsCaller(MException(eidType, msgType));
elseif ~modeAndOffsetCompatible
    eidType = 'mustBeValidCombo:invalidCombo';
    msgType = "Arguments 'mode' and 'offsetMM' not compatible! " + ...
        "Whenever 'mode' is set to ""centered"", 'offsetMM' must equal 0!";
    throwAsCaller(MException(eidType, msgType));
end

end
