
function plotStimuli(nBrightnesses, rangePct, nRows, nCols, whiteIndex)

% PLOTSTIMULI - Visualize different brightness intensities
%    This MATLAB function can be used to visualize brightness intensities
%    resulting from different parameter choices in a simple tile plot. This
%    can be used to get a first idea of how to choose the parameters of the
%    brightness discrimination experiment.
%
%    INPUT ARGUMENTS
%      nBrightnesses (int) - Number of different brightness intensities.
%                            Must be a positive integer. Defaults to 15 if
%                            not specified.
%
%      rangePct (double) - Proportion of gray levels to be used from the
%                          full range from black to white. Must be a
%                          positive integer no larger than 100. Defaults to
%                          10 if not specified.
%
%      nRows (int) - Number of rows of the tile plot. Must divide
%                    'nBrightnesses'. Defaults to 1 if not specified.
%
%      nCols (int) - Number of columns of the tile plot. Must divide
%                    'nBrightnesses'. Defaults to 'nBrightnesses' if not
%                    specified.
%
%      whiteIndex (double) - Intensity value to produce white at the
%                            current screen depth, assuming a standard
%                            color lookup table for that depth. Defaults to
%                            1 if not specified.
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
