
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
%   <https://doi.org/10.1016/j.visres.2016.02.002>
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
%   SET PARAMETERS FOR DATA LOADING
%----------------------------------------------------------------------

% NOTE: The experiment can be run with different settings (intensity of
% standard stimulus, number of comparison stimuli, and maximum difference
% between standard and comparison stimuli).  Further, the number of
% repetitions that each comparison stimulus is shown together with the
% standard stimulus can be varied as well.  Here, we choose which datasets
% to analyze (in case data were collected with different settings).

standardStim = 0.5;
nComparisonStim = 3;
maxDifference = 0.1;
nReps = 4;


%----------------------------------------------------------------------
%   CONFIGURE PSIGNIFIT PARAMETERS
%----------------------------------------------------------------------

% NOTE: While the experiment used a 2AFC design (participants were always
% presented with two stimuli simultaneously and were forced to make a
% decision), we set 'expType' to "YesNo" instead of "2AFC".  This way, both
% asymptotes are set free to vary.  This is important because we want to
% plot the proportion of "darker" responses against the values of the
% comparison stimuli (instead of the proportion of correct responses
% against the absolute value of the difference between standard and
% comparison stimuli).  For details, please check
%   <https://github.com/wichmann-lab/psignifit/wiki/Experiment-Types>.
Options.sigmoidName = 'norm';
Options.expType = 'YesNo';


%----------------------------------------------------------------------
%   OBTAIN NAMES OF VALID DATASETS
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
    + sprintf('_%02dSt_', standardStim * 100) ...       % value of standard stimulus
    + sprintf('%02dnCo_', nComparisonStim) ...          % number of comparison stimuli
    + sprintf('%02dMaxDiff_', maxDifference * 100) ...  % maximum difference
    + sprintf('%02dReps_', nReps) ...                   % number of repetitions each
    + digitsPattern(4) + "-" + digitsPattern(2) + "-" ...
    + digitsPattern(2) + "_" + alphanumericsPattern(2) + ".csv";
datasets = datasets(matches(datasets, pat));  % select appropriate datasets

nDatasets = length(datasets);       % number of datasets to load
nTrials = nComparisonStim * nReps;  % number of completed trials per dataset

% Clean up workspace
clear maxDifference nComparisonStim nReps pat standardStim


%----------------------------------------------------------------------
%   LOAD DATA
%----------------------------------------------------------------------

% Preallocate table to store raw data
varNames = ["ParticipantID", "ID", "ComparisonStim", "StandardPos", ...
    "DurationFixCrossSecs", "Repetition", "Response", "BrightnessJudgement"];

varTypes = ["string", "double", "double", "string", ...
    "double", "double", "string", "string"];

rawData = table('Size', [nTrials * nDatasets, length(varNames)], ...
    'VariableTypes', varTypes, 'VariableNames', varNames);

startIndex = 1;  % helper variable to store individual results in 'rawData' table

% Load raw data from 'data/' directory
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
clear endIndex fileName filePath iDataset indResults ParticipantID ...
    startIndex varNames varTypes
