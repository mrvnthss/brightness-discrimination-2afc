# Brightness Discrimination (2AFC)

[![MATLAB](https://img.shields.io/badge/MATLAB-2023a-006d9b.svg?logo=data:image/png;base64,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
)](https://www.mathworks.com/)
[![Psychtoolbox](https://img.shields.io/badge/Psychtoolbox-3.0.19-50124e.svg?logo=data:image/png;base64,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
)](https://www.psychtoolbox.net)
[![GitHub License](https://img.shields.io/github/license/mrvnthss/brightness-discrimination-2afc?color=9a2333)](https://opensource.org/license/mit/)

This repository contains MATLAB (The MathWorks Inc., [2023](#matlab)) code to run a brightness discrimination experiment using the [Psychtoolbox](http://psychtoolbox.org/) library (Brainard, [1997](#brainard-ptb); Kleiner et al., [2007](#kleiner-ptb); Pelli, [1997](#pelli-ptb)). Collected data can be analyzed using the [psignifit](https://github.com/wichmann-lab/psignifit) toolbox developed by Schütt et al. ([2016](#psignifit)).

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
- [Configuring the Experiment](#configuring-the-experiment)
- [Data Analysis with *psignifit*](#data-analysis-with-psignifit)
- [Languages and Tools](#languages-and-tools)
- [References](#references)
- [Acknowledgments](#acknowledgments)
- [License](#license)

## Overview

The brightness discrimination experiment provided in this repository is designed to measure participants' ability to perceive differences in brightness between two visual stimuli. To accomplish this, participants are briefly presented with pairs of stimuli and are asked to indicate which stimulus appears brighter by pressing a button.

### Method of Constant Stimuli

The experiment is conducted using the *method of constant stimuli* (2AFC paradigm) as described in Chapter 3 of Gescheider ([1997](#gescheider)). The brightness of one of the two stimuli presented is constant across all trials of the experiment. This stimulus is referred to as the *standard stimulus*. On each trial, this standard stimulus is presented together with another stimulus, the *comparison stimulus*, which is sometimes brighter than, sometimes darker than, and sometimes equally bright as the standard stimulus. The order of presentation of the comparison stimuli is randomized. The following values can be chosen by the experimenter (please check [Configuring the Experiment](#configuring-the-experiment) for details):

- brightness of the standard stimulus,
- number of comparison stimuli,
- maximum absolute difference between standard and comparison stimuli, and
- number of times each comparison stimulus is paired with the standard stimulus.

The `assert` function is used in the [`BrightnessDiscrimination.m`](BrightnessDiscrimination.m) script to enforce that ...

- the number of comparison stimuli is *odd*, and
- the number of repetitions per comparison stimulus is *even*.

The first precaution ensures that there are as many comparison stimuli that are brighter than the standard as there are comparison stimuli that are darker than the standard. The second precaution allows the spatial location of the standard stimulus to be counterbalanced across trials "to control for the effects of the *space error*" (Gescheider, [1997](#gescheider)).

Additionally, the values of the comparison stimuli should be "chosen so that the stimulus of greatest magnitude is almost always judged greater than the standard, and so that the stimulus of least magnitude is almost always judged less than the standard" (Gescheider, [1997](#gescheider)). In the context of brightness discrimination, "greater" means "brighter" and "less" means "darker". To achieve this desired result, the maximum absolute difference between the standard and comparison stimuli must be set appropriately by the experimenter (again, please see [Configuring the Experiment](#configuring-the-experiment) for details). To assist in choosing this value, the [`plotStimuli.m`](plotStimuli.m) function can be used to visualize the comparison stimuli based on the parameters chosen to (potentially) run the experiment. The next figure shows a sample output produced by the [`plotStimuli.m`](plotStimuli.m) function:

<div align="center">
    <img src="figures/comparison-stimuli.png" alt="comparison-stimuli" width="600">
</div>
<br>

The top and bottom rows represent the brightness intensity of the standard stimulus. The comparison stimuli are shown in the middle row with increasing brightness from left to right.

### Flow of the Experiment

Participants complete multiple trials that are split up into separate blocks. Before the start of each block (except for the first one), participants are informed about their progress. Each trial is started by the participants pressing the space bar.

The following figure illustrates the flow of a single trial:

<div align="center">
    <img src="figures/trial-structure.png" alt="trial-structure" width="700">
    <p>Schematic flow of a single trial.<br>
    Size of stimuli has been increased for demonstration purposes.</p>
</div>

Additionally, here is a dynamic preview[^1] of the experiment:

<div align="center">
    <img src="figures/experiment-demo.gif" alt="trial-structure" width="600">
</div>
<br>

[^1]: The size of the stimuli has been increased for demonstration purposes.

As indicated, the presentation duration of the fixation cross (prior to the presentation of the stimuli) varies between trials to fight fatigue by avoiding perfect timing anticipation due to a rhythmic stimulus-response pattern. For each trial, the duration is sampled randomly from a continuous uniform distribution whose parameters (500 ms and 2,000 ms in the example above) can be chosen by the experimenter.

Right now, there is *no* time limit for a response after the stimuli have been presented. Hence, the time participants take to respond is currently *not* being collected either.

After the experiment is completed, all data are saved to a CSV-file. Collected data can be analyzed via the [`fitData.m`](fitData.m) script which uses the [psignifit](https://github.com/wichmann-lab/psignifit) toolbox developed by Schütt et al. ([2016](#psignifit)).

## Getting Started

Follow these steps to clone the repository and run the project on your local machine.

### Prerequisites

- MATLAB with Psychtoolbox installed. Visit [Psychtoolbox](http://psychtoolbox.org/) for installation instructions.
- Psignifit 4 toolbox installed. Visit [wichmann-lab/psignifit/wiki/Install](https://github.com/wichmann-lab/psignifit/wiki/Install) for installation instructions.

### Clone the Repository

1. Open a terminal or command prompt on your local machine.

2. Clone the repository using `git`:

```
git clone https://github.com/mrvnthss/brightness-discrimination-2afc
```

### Run the Experiment

1. Open MATLAB and navigate to the cloned repository's directory.

2. Run the [`BrightnessDiscrimination.m`](BrightnessDiscrimination.m) script to start the experiment.

## Configuring the Experiment

### Setting Experiment Parameters

As mentioned before, there are several parameters that can be changed in the [`BrightnessDiscrimination.m`](BrightnessDiscrimination.m) script that alter the experiment. They can be found in the *Configuration of Experiment* section of the script.

#### Experimental Design

- `Stimuli.standardStim`: Sets the value of the standard stimulus.

- `Stimuli.nComparisonStim`: Defines the number of comparison stimuli. As explained earlier, this must be an odd number to ensure that the number of comparison stimuli that are brighter than the standard is equal to the number of comparison stimuli that are darker than the standard.

- `Stimuli.maxDifference`: Together with the value of the standard stimulus, this setting is used to derive the values of all comparison stimuli in the experiment.

- `Stimuli.nReps`: Determines how often each pair of comparison stimulus and standard stimulus is shown to the participant. This must be an even number to allow for counterbalancing of the spatial location of the standard stimulus.

#### Timing Parameters

- `Duration.waitSecs`: Controls the delay between the pressing of the space bar to start a trial and the presentation of the fixation cross.

- `Duration.fixCrossMinSecs`: First of the two parameters of the continuous uniform distribution that's used to derive the presentation duration of the fixation cross only in each trial.

- `Duration.fixCrossMaxSecs`: Second of the two parameters of the continuous uniform distribution that's used to derive the presentation duration of the fixation cross only in each trial.

- `Duration.stimulusSecs`: Determines presentation duration of the stimuli.

#### Other

- `viewingDistanceMM`: The orthogonal distance (in mm) from the eye of the participant to the screen used to display the stimuli. This value is used to convert stimuli sizes from degrees of visual angle to number of pixels on the screen. The screen resolution as well as the physical size of the display (in mm) necessary for this conversion are provided through a call to the [`configurePsych.m`](configurePsych.m) function.

- `Progress.thresholdPct`: Controls when (i.e., after which fraction of total trials) participants are informed about their progress. Thereby also splitting trials into blocks.

### Configuring Psychtoolbox

The experiment code (i.e., the [`BrightnessDiscrimination.m`](BrightnessDiscrimination.m) script) calls the [`configurePsych.m`](configurePsych.m) function to generate a struct called `Config`. The parameters of this struct are then used to set up a new Psychtoolbox session to run the experiment. You can change the way this session is set up by passing the appropriate arguments to the [`configurePsych.m`](configurePsych.m) function:

- `whichScreen`: Either 'main' or 'max'. Passing 'main' will set `Config.screenNumber` to 0 (i.e., main screen), 'max' will set it to `max(Screen('Screens'))` (i.e., screen detected last). Defaults to 'main'.

- `skipTest`: Either 0 or 1. Assigned to the field `Config.skipTest` which is used to determine whether synchronization tests are to be skipped. A value of 1 will skip the internal synchronization tests, a value of 0 will not. Defaults to 1.

- `debugMode`: Either `true` or `false`. If set to `true` (and `whichScreen` is set to 'main'), Psychtoolbox opens a window positioned in the top-left that only covers 25 % of the screen. Defaults to `false`.

## Data Analysis with *psignifit*

Collected data can be analyzed via the [`fitData.m`](fitData.m) script. Essentially, this script uses the [psignifit](https://github.com/wichmann-lab/psignifit) toolbox developed by Schütt et al. ([2016](#psignifit)) to fit psychometric curves to the data. This is done individually for each participant as well as for data pooled across participants.

### Loading Data

Since the experiment can be run with different parameters (see [Configuring the Experiment](#configuring-the-experiment) for details), different CSV-files in the [`data/`](data/) directory may contain data collected in runs that used differing parameters. Hence, before performing the data analysis, you have to set these parameters to determine which datasets to load. This is done in the *Set Parameters for Data Loading* section at the top of the script.

### *psignifit* Parameters

To perform the fitting of a psychometric curve to data collected in experiments, users have to configure a few parameters before running the analysis. For a brief introduction into the basic usage of [psignifit](https://github.com/wichmann-lab/psignifit), please check [wichmann-lab/psignifit/wiki/Basic-Usage](https://github.com/wichmann-lab/psignifit/wiki/Basic-Usage).

The `fitData.m` script currently uses the following parameters to perform the fitting:

- `Options.sigmoidName = 'norm'`: A cumulative Gaussian is used as the sigmoid.

- `Options.expType = 'YesNo'`: This might be confusing at first. Even though the experiment is conducted using a 2AFC paradigm, we do *not* choose `'2AFC'` as `Options.expType`. This is simply because `Options.expType = '2AFC'` fixes the lower asymptote to $0.5$. On the contrary, `Options.expType = 'YesNo'` leaves both asymptotes free to vary. Since we want to plot the proportion of "brighter" responses against the values of the comparison stimuli, this is what we are after. (Had we wanted to plot the proportion of correct responses against the absolute value of the difference between standard and comparison stimuli, `Options.expType = '2AFC'` would have been the way to go.) For details, please check [wichmann-lab/psignifit/wiki/Experiment-Types](https://github.com/wichmann-lab/psignifit/wiki/Experiment-Types).

- `Options.widthalpha = 0.25`: This controls the way the *width* of the psychometric function is computed. The width of a psychometric function as computed by [psignifit](https://github.com/wichmann-lab/psignifit) is defined as $\text{width} = \Psi^{-1}(1-\alpha) - \Psi^{-1}(\alpha)$, where $\Psi^{-1}$ is the inverse of the fitted psychometric function. The choice of setting $\alpha$ to $0.25$ is based on the remarks in Chapter 3 of Gescheider ([1997](#gescheider)).

### Plotting Parameters

Further, there are several parameters that control the appearance of the plots produced by the `plotPsych` command of the [psignifit](https://github.com/wichmann-lab/psignifit) toolbox. These can also be found in the *Configure psignifit Parameters* section of the [`fitData.m`](fitData.m) script. For further details regarding these parameters, please check [wichmann-lab/psignifit/wiki/Plot-Functions](https://github.com/wichmann-lab/psignifit/wiki/Plot-Functions).

### Fitting and Data Analysis

Based on the configuration of the parameters described in the preceding sections, the appropriate datasets are automatically loaded from the [`data/`](data/) directory. These datasets are then preprocessed and converted into the format that is expected by the *psignifit* function. A psychometric function is fitted to the data of each individual participant as well as to the data pooled across all participants. For each fit, we also compute the following measures:

- **Point of subjective equality (PSE)**: The *point of subjective equality* is simply $\Psi^{-1}(0.5)$, i.e., the value corresponding to $0.5$ on the fitted sigmoid. This value may deviate from the value $\text{St}$ of the standard stimulus. The resulting difference is known as the *constant error* $\text{CE} = \text{PSE} - \text{St}$.

- **Difference threshold**: We report the average difference threshold $DL_{\text{avg}}$ as defined in Chapter 3 of Gescheider ([1997](#gescheider)). The average difference threshold is simply the average of the upper difference threshold $DL_{u} = \Psi^{-1}(0.75) - \text{PSE}$ and the lower difference threshold $DL_{l} = \text{PSE} - \Psi^{-1}(0.25)$. Thus, the average difference threshold $DL_{\text{avg}}$ is simply half the width of the psychometric function $\Psi$ and as such is inversely related to the slope of the psychometric function, which is often used as a measure of sensitivity. Of course, a lower difference threshold (or a steeper/greater slope) corresponds to a greater sensitivity and vice versa.

Confidence intervals are also computed by the *psignifit* function for both of the two values just mentioned and the computed values are stored in the variables `thresholdCIlower`, `thresholdCIupper`, `widthCIlower`, and `widthCIupper`. However, as of now, these values are not used for further analysis.

<div align="center">
    <img src="figures/sample-01.png" alt="sample-01" width="600">
    <p>Sample output of the <a href="fitData.m"><tt>fitData.m</tt></a> script. <b>Simulated</b> data.</p>
</div>
<br>

## Languages and Tools

<p align="left">
  <a href="https://www.mathworks.com/" target="_blank" rel="noreferrer">
    <img src="https://upload.wikimedia.org/wikipedia/commons/2/21/Matlab_Logo.png" alt="matlab" width="40" height="40"/>
  </a>
  <a href="https://www.psychtoolbox.net" target="_blank" rel="noreferrer">
    <img src="https://www.psychtoolbox.net/wp-content/uploads/2022/03/no_background_purple_text.png" alt="pytorch" height="40"/>
  </a>
</p>

## References

- <a id='brainard-ptb'></a> Brainard, D. H. (1997). The Psychophysics Toolbox. *Spatial vision, 10*(4), 433–436. [https://doi.org/10.1163/156856897X00357](https://doi.org/10.1163/156856897X00357)

- <a id='gescheider'></a> Gescheider, G. A. (1997). *Psychophysics: The fundamentals* (3rd ed.). Lawrence Erlbaum Associates, Inc.

- <a id='kleiner-ptb'></a> Kleiner, M., Brainard, D. H., & Pelli, D. G. (2007). What’s new in Psychtoolbox-3? *Perception, 36*(ECVP Abstract Supplement), 14. [https://doi.org/10.1177/03010066070360S101](https://doi.org/10.1177/03010066070360S101)

- <a id='pelli-ptb'></a> Pelli, D. G. (1997). The VideoToolbox software for visual psychophysics: transforming numbers into movies. *Spatial vision, 10*(4), 437–442. [https://doi.org/10.1163/156856897X00366](https://doi.org/10.1163/156856897X00366)

- <a id='psignifit'></a> Schütt, H. H., Harmeling, S., Macke, J. H., & Wichmann, F. A. (2016). Painfree and accurate Bayesian estimation of psychometric functions for (potentially) overdispersed data. *Vision Research, 122*, 105–123. [https://doi.org/10.1016/j.visres.2016.02.002](https://doi.org/10.1016/j.visres.2016.02.002)

- <a id='matlab'></a> The MathWorks Inc. (2023). MATLAB (9.14.0) [Computer software]. The MathWorks Inc. [https://www.mathworks.com](https://www.mathworks.com)

## Acknowledgments

The experiment code is based on the Psychtoolbox library. For more information about Psychtoolbox, visit [Psychtoolbox](http://psychtoolbox.org/).

Screenshots and screen capture videos were taken/recorded using macOS' built-in [Screenshot app](https://support.apple.com/guide/mac-help/take-screenshots-or-screen-recordings-mh26782/mac).

The [Gifski](https://gif.ski) app was used to convert screen capture videos into GIFs.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Permissions

You are free to:

- **Use:** Copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the materials.

### Under the Following Terms

- **No Attribution Required:** The MIT License does not require you to provide attribution when using or distributing the code.

- **No Warranty:** The code is provided "as is," without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and non-infringement.

- **Limitation of Liability:** In no event shall the authors or copyright holders be liable for any claim, damages, or other liability, whether in an action of contract, tort, or otherwise, arising from, out of, or in connection with the code or the use or other dealings in the code.
