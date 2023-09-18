
% PURPOSE: Analyze data collected via the 'BrightnessDiscrimination.m'
%          script using the psignifit toolbox by Schütt et al.
%          <https://github.com/wichmann-lab/psignifit>
% 
% CONTEXT: Seminar "Introduction to Computational Modelling" at Justus
%          Liebig University Giessen <https://www.uni-giessen.de>
% 
% AUTHOR: 2023 Marvin Theiss
%
% ASSUMPTIONS & LIMITATIONS:
%   The psignifit toolbox by Schütt et al. needs to be installed.
%   For installation instructions, please check
%   <https://github.com/wichmann-lab/psignifit/wiki/Install>.
%   The corresponding paper by Schütt et al. (2016) can be found here:
%   <https://doi.org/10.1016/j.visres.2016.02.002>.
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
%   CLEAN UP
%----------------------------------------------------------------------

close all
clear
clc


%----------------------------------------------------------------------
%   SET PARAMETERS FOR DATA LOADING
%----------------------------------------------------------------------

% NOTE: The experiment can be run with different settings (intensity of
% standard stimulus, number of comparison stimuli, and maximum difference
% between standard and comparison stimuli).  Further, the number of
% repetitions that each comparison stimulus is shown together with the
% standard stimulus can be varied as well.  Here, we choose which datasets
% to analyze (in case data were collected with different settings).
standardStim = 0.5;
nComparisonStim = 9;
maxDifference = 0.05;
nReps = 50;


%----------------------------------------------------------------------
%   CONFIGURE PSIGNIFIT PARAMETERS
%----------------------------------------------------------------------

% NOTE: While the experiment used a 2AFC design (participants were always
% presented with two stimuli simultaneously and were forced to make a
% decision), we set 'expType' to "YesNo" instead of "2AFC".  This way, both
% asymptotes are set free to vary.  This is important because we want to
% plot the proportion of "brighter" responses against the values of the
% comparison stimuli (instead of the proportion of correct responses
% against the absolute value of the difference between standard and
% comparison stimuli).  For details, please check
%   <https://github.com/wichmann-lab/psignifit/wiki/Experiment-Types>.
Options.sigmoidName = 'norm';  % fit a cumulative Gaussian
Options.expType = 'YesNo';     % see above comment
Options.widthalpha = 0.25;     % used to compute the width of the psychometric function

% Set plotting parameters
PlotOptions.xLabel = 'Value of comparison stimulus';        % x-axis label
PlotOptions.yLabel = 'Proportion of "brighter" responses';  % y-axis label
PlotOptions.labelSize = 18;                                 % font size for axis labels
PlotOptions.fontSize = 14;                                  % font size for tick labels
PlotOptions.fontName = 'Helvetica';                         % name of font
PlotOptions.aspectRatio = true;                             % use golden ratio as aspect ratio for plots
PlotOptions.CIthresh = true;                                % add confidence interval to threshold


%----------------------------------------------------------------------
%   SELECT (VALID) DATASETS
%----------------------------------------------------------------------

% Obtain the names of all .csv-files located in the 'data/' directory
datasets = struct2table(dir(fullfile('data', '*.csv')));
datasets = string(datasets.name);

% Include only files with valid data, i.e., files with
%   - a value of 'standardStim' for the standard stimulus,
%   - a number of 'nComparisonStim' comparison stimuli,
%   - a maximum difference of 'maxDifference' between standard and
%     comparison stimuli,
%   - 'nReps' repetitions per comparison stimulus, and
%   - complete data only (i.e., no "INCOMPLETE_..." files).
pat = digitsPattern(3) ...
    + sprintf('_%03dSt_', standardStim * 1000) ...       % value of standard stimulus
    + sprintf('%02dnCo_', nComparisonStim) ...           % number of comparison stimuli
    + sprintf('%03dMaxDiff_', maxDifference * 1000) ...  % maximum difference
    + sprintf('%02dReps_', nReps) ...                    % number of repetitions each
    + digitsPattern(4) + "-" + digitsPattern(2) + "-" ...
    + digitsPattern(2) + "_" + alphanumericsPattern(2) + ".csv";

datasets = datasets(matches(datasets, pat));  % select appropriate datasets
datasets = sort(datasets, 'ascend');          % sort datasets by participant ID        

nDatasets = length(datasets);       % number of datasets to load
nTrials = nComparisonStim * nReps;  % number of completed trials per dataset

% Clean up workspace
clear maxDifference nReps pat standardStim


%----------------------------------------------------------------------
%   LOAD DATA
%----------------------------------------------------------------------

% Preallocate table to store data
varNames = ["ParticipantID", "ID", "ComparisonStim", "StandardPos", ...
    "DurationFixCrossSecs", "Repetition", "Response", "BrightnessJudgement"];

varTypes = ["string", "double", "double", "string", ...
    "double", "double", "string", "string"];

rawData = table('Size', [nTrials * nDatasets, length(varNames)], ...
    'VariableTypes', varTypes, 'VariableNames', varNames);

startIndex = 1;  % helper variable to store individual results in 'rawData' table

% Load data from 'data/' directory
for iDataset = 1:nDatasets
    % Construct filepath
    fileName = datasets{iDataset};
    filePath = fullfile('data', fileName);

    % Read data
    indResults = readtable(filePath);

    % Preprocess data
    indResults = removevars(indResults, 'Order');
    ParticipantID = repmat( ...
        string(extractBefore(fileName, '_')), ...
        nTrials, 1);
    indResults = addvars(indResults, ParticipantID, 'Before', 'ID');
    indResults = sortrows(indResults, ["ID", "Repetition"], 'ascend');

    % Append data to 'rawData' table
    endIndex = startIndex + nTrials - 1;
    rawData(startIndex:endIndex, :) = indResults;
    startIndex = endIndex + 1;
end

% Clean up workspace
clear endIndex fileName filePath indResults ParticipantID startIndex ...
    varNames varTypes


%----------------------------------------------------------------------
%   PREPROCESSING
%----------------------------------------------------------------------

% To analyze the collected data using the psignifit toolbox, we need to
% arrange the data into k separate (n x 3)-matrices, where k is the number
% of datasets and n is the number of comparison stimuli.  For details,
% please check
%   <https://github.com/wichmann-lab/psignifit/wiki/Basic-Usage>.

% Preallocate matrix to store preprocessed data
preprocessedData = NaN(nComparisonStim, 3, nDatasets);

% Extract participant IDs
% NOTE: The 'rawData' table is sorted by participants' IDs because the
% 'datasets' array (which was used to iteratively create the 'rawData'
% table) was sorted that way.  Hence, the 'participantIDs' array is also
% sorted alphabetically.
participantIDs = unique(rawData.ParticipantID);

for iDataset = 1:nDatasets
    % Select participants' data one by one
    participantID = participantIDs(iDataset);
    indData = rawData(strcmp(rawData.ParticipantID, participantID), :);

    % Count how many times each comparison stimulus was judged to be
    % brighter than the standard stimulus
    indData.JudgedBrighter = strcmp( ...
        indData.BrightnessJudgement, 'brighter');
    indData = grpstats(indData, 'ComparisonStim', 'mean', ...
        'DataVars', 'JudgedBrighter', ...
        'VarNames', ["ComparisonStim", "nTotal", "JudgedBrighterPct"]);
    indData.nBrighter = indData.nTotal .* indData.JudgedBrighterPct;

    % Sort by value of comparison stimulus and append to 'preprocessedData'
    % array
    indData = sortrows(indData, 'ComparisonStim', 'ascend');
    preprocessedData(:, :, iDataset) = [ ...
        indData.ComparisonStim, indData.nBrighter, indData.nTotal];
end

% Clean up workspace
clear indData nTrials participantID


%----------------------------------------------------------------------
%   FIT INDIVIDUAL DATA USING PSIGNIFIT
%----------------------------------------------------------------------

[thresholdVals, thresholdCIlower, thresholdCIupper, ...
    widthVals, widthCIlower, widthCIupper] = deal(NaN(nDatasets, 1));

for iDataset = 1:nDatasets
    % Extract individual dataset
    data = preprocessedData(:, :, iDataset);

    % Run psignifit
    % NOTE: The psignifit function returns a structure array containing 18
    % fields (as of September 2023).  The two fields that are most
    % important to us are:
    %   - Fit: Contains the basic results of the fit.  Most importantly,
    %          Fit(1) is the determined threshold (i.e., the stimulus
    %          intensity that corresponds to 50% on the fitted sigmoid)
    %          and Fit(2) is the width of the sigmoid (i.e., the difference
    %          in stimulus intensities corresponding to 25% and 75% on the
    %          sigmoid).
    %   - conf_Intervals: This is a (5 x 2 x 3)-array containing 3 sets of
    %                     confidence intervals (i.e., lower and upper
    %                     bound, hence 2 values per set) for each of the 5
    %                     values reported in 'fitResults.Fit' corresponding
    %                     to confidence levels of 68%, 90%, and 95%.
    % NOTE: The threshold is set to 50% by default.  This could
    % theoretically be changed by setting 'Options.threshPC' accordingly.
    % In our brightness discrimination task, the 50% threshold corresponds
    % to the point of subjective equality (PSE).
    % NOTE: The width of the fitted psychometric function is determined by
    % the 'Options.widthalpha' parameter, which we have set to 0.25 in
    % accordance with Chapter 3 of Gescheider (1997).
    fitResults = psignifit(data, Options);

    % Store subset of fit results (i.e., threshold, width, and confidence
    % intervals for both)
    thresholdVals(iDataset) = fitResults.Fit(1);  % 50% threshold / PSE
    widthVals(iDataset) = fitResults.Fit(2);      % width of psychometric function

    thresholdCIlower(iDataset) = fitResults.conf_Intervals(1, 1, 2);  % lower bound of 90% CI (threshold)
    thresholdCIupper(iDataset) = fitResults.conf_Intervals(1, 2, 2);  % upper bound of 90% CI (threshold)
    widthCIlower(iDataset) = fitResults.conf_Intervals(2, 1, 2);      % lower bound of 90% CI (width)
    widthCIupper(iDataset) = fitResults.conf_Intervals(2, 2, 2);      % upper bound of 90% CI (width)

    % Plot results
    figure('Name', 'Individual Results');  % open new figure
    plotPsych(fitResults, PlotOptions);    % plot psychometric curve
    [t, s] = title( ...                    % add title and subtitle
        sprintf('Participant ID: %s', participantIDs(iDataset)), ...
        sprintf('PSE = %.2f,  DL_{avg} = %.4f', ...
            [fitResults.Fit(1), fitResults.Fit(2)/2] ...
        ), 'FontName', 'Helvetica');
    t.FontSize = 18;         % font size of title
    s.FontSize = 16;         % font size of subtitle
    s.FontAngle = 'italic';  % font angle of subtitle
end

% Clean up workspace
clear data iDataset


%----------------------------------------------------------------------
%   FIT DATA POOLED ACROSS PARTICIPANTS USING PSIGNIFIT
%----------------------------------------------------------------------

% Initialize matrix to store data pooled across participants
pooledData = NaN(nComparisonStim, 3);

% Pool data across participants
pooledData(:, 1) = preprocessedData(:, 1, 1);
pooledData(:, [2, 3]) = sum(preprocessedData(:, [2, 3], :), 3);

% Run psignifit
fitResults = psignifit(pooledData, Options);

% Plot results
figure('Name', 'Results Pooled Across Participants');  % open new figure
plotPsych(fitResults, PlotOptions);                    % plot psychometric curve
[t, s] = title( ...                                    % add title and subtitle
        sprintf('Results pooled across %d participants', nDatasets), ...
        sprintf('PSE = %.2f,  DL_{avg} = %.4f', ...
            [fitResults.Fit(1), fitResults.Fit(2)/2] ...
        ), 'FontName', 'Helvetica');
t.FontSize = 18;         % font size of title
s.FontSize = 16;         % font size of subtitle
s.FontAngle = 'italic';  % font angle of subtitle

% Clean up workspace
clear ans nComparisonStim nDatasets participantIDs s t
