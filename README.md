# MIRRORS 
v1.8.0

[![DOI](https://zenodo.org/badge/100439021.svg)](https://zenodo.org/badge/latestdoi/100439021)

MIRRORS is a Graphical User Interface (GUI) created using the Matlab© GUIDE© program. The software is designed to process .TIFF images produced by a multispectral imaging radiometry (MIR) system for temperature measurement of samples heated in a diamond anvil cell, similar to the one developed by [Campbell (2008)](http://doi.org/10.1063/1.2827513)[^1] and which has been copied at the School of Earth Sciences at the University of Bristol, UK [(Lord et al. 2014)](http://doi.org/10.1016/j.epsl.2014.09.046)[^2].

The GUI can work in live mode (during an experiment) or in post-processing mode, and performs both spatial and thermal calibrations on the data before producing maps of temperature, temperature error and image difference, i.e. the change in shape of the temperature field, based on the work presented in the Supplementary Information of [Briggs et al. (2017)](http://doi.org/10.1103/PhysRevB.95.054102)[^3]. The software also provides the user with an example Wien fit, peak temperature as a function of elapsed time, an image difference metric (also as a function of elapsed time), orthoganol temperature cross-sections centered on the peak pixel and finally emissivity as a function of temperature, as described in [Fischer & Campbell (2010)](http://doi.org/10.2138/am.2010.3463)[^4]. 

Since version 1.8.0, the software has been updated to allow the user to choose whether 3 or 4 colors are fitted, so that if one of the 4 monochromatic images has a very low signal to noise ratio, it can be ignored. This is especially useful at low temperatures. In additon, since version 1.8.0, the software now supports MIR systems based on either the original hardware design of [Campbell (2008)](http://doi.org/10.1063/1.2827513)[^1] in which the four images are focussed onto each quadrant of a single CCD camera, or more recent set-ups that use four separate, inexpensive, CMOS cameras. This approach means that the four separate images do not need to be recombined before focussing onto the cameras, dramatically reducing light loss, increasing signal to noise ratio and reducing the minimum temperature that can be accurately fitted.

The original release of MIRRORS is described in detail in [Lord & Wang (2018)](http://doi.org/10.1063/1.5041360)[^5].

[^1]:[Campbell, A. J. (2008). Measurement of temperature distributions across laser heated samples by multispectral imaging radiometry. Review of Scientific Instruments, 79(1), 015108.](http://doi.org/10.1063/1.2827513)

[^2]:[Lord, O. T., Wood, I. G., Dobson, D. P., Vočadlo, L., Wang, W., Thomson, A. R., et al. (2014). The melting curve of Ni to 1 Mbar. Earth and Planetary Science Letters, 408, 226–236.](http://doi.org/10.1016/j.epsl.2014.09.046)

[^3]:[Briggs, R., Daisenberger, D., Lord, O. T., Salamat, A., Bailey, E., Walter, M. J., & McMillan, P. F. (2017). High-pressure melting behavior of tin up to 105 GPa. Physical Review B, 95(5), 054102.](http://doi.org/10.1103/PhysRevB.95.054102)

[^4]:[Fischer, R. A., & Campbell, A. J. (2010). High-pressure melting of wustite. American Mineralogist, 95(10), 1473–1477.](http://doi.org/10.2138/am.2010.3463)

[^5]:[Lord, O. T., & Wang, W. (2018). MIRRORS: A MATLAB ®GUI for temperature measurement by multispectral imaging radiometry. Review of Scientific Instruments, 89(10), 104903](http://doi.org/10.1063/1.5041360)

## Required hardware

MIRRORS requires a multispectral imaging radiometry (MIR) system that produces either 

1. a single .TIFF file containing four monochromatic images of the laser heated spot to be analysed, each approximately centered on the centre pixel of one quadrant of the full image or

2. four separate .TIFF files, each containing a single image of the laser heated spot to be analysed, again approximately centered on the centre pixel of the sensor as long as the files are appended \_a, \_b, \_c and \_d. In this case, for live mode to be effective, all four images need to appear in the target directory almost simultaneously or they will be ignored and left unfitted.

Images can be of any resolution, aspect ratio and bit depth. The software performs a spatial calibration before stacking the four quadrants and so the centering does not need to be perfect. Each image must be at a different, precisely known wavelength.

The system needs a thermal calibration .TIFF image produced using a calibrated source of known spectral radiance and as before, consisting of four equal quadrants each illuminated by a monochromatic image of the calibration source.

Details of the MIR system as well as calibration methods can be found in Campbell et al. (2008) and Lord & Wang (2018).

## System compatibility

MIRRORS can be run from the MATLAB command line or as a standalone application on any machine running 64-bit Mac OS X or Windows. Note, support for 32-bit Windows machines ends at version 1.7.9; in that release, MIRRORS can still be run from the MATLAB command line on a 32-bit Windows machine, but the standalone app will not work. From version 1.8.0 onwards, MIRRORS uses functions not available in MATLAB 2014a, the last version compatible with 32-bit hardware and so cannot be run from the MATLAB command line on a 32-bit machine.

* [from v1.8.0](https://github.com/olivertlord/MIRRORS/tree/v1.7.9): For this version, MIRRORS has been tested and compiled on MATLAB R2022b on Mac OS X 12.6.3 Monterey with Apple Silicon and Windows 11 Home version 22H2 running in the Parallels Virtualisation platform (both 64-bit operating systems). The associated binaries have been produced from these versions of MATLAB. This version may not work correctly if run from the command line of an earlier version of MATLAB

* [from v1.7.9](https://github.com/olivertlord/MIRRORS/tree/v1.7.9): For this version MIRRORS has been tested on MATLAB R2021b on Mac OS X 11.5.2 Big Sur and Windows 10 (both 64-bit operating systems) and the associated binaries have been produced from this version of MATLAB. This version may not work correctly if run from the command line of an earlier version of MATLAB

* [v1.7.0](https://github.com/olivertlord/MIRRORS/tree/v1.7.0) to [v1.7.8](https://github.com/olivertlord/MIRRORS/tree/v1.7.8): These versions were written and tested on MATLAB R2014a (32-bit Windows 7) & R2018b (64-bit OS X 10.13 High Sierra) and the associated binaries have been produced from these versions of MATLAB. It will likely work on all versions after R2014a on Windows 7 and all versions after R2018b on OS X, but has not been explicity tested.

* [v1.6.16](https://github.com/olivertlord/MIRRORS/tree/1.6.16) and earlier: standalone binaries were not available, but otherwise compatibility is as for [v1.7.0](https://github.com/olivertlord/MIRRORS/tree/v1.7.0).

## Third party functions

MIRRORS uses two third-party functions (i.e. functions not provided by MathWorks and not written by me):[im2col3](https://uk.mathworks.com/matlabcentral/fileexchange/93040-im2col3)[^6] and [Tooltip Waitbar](https://uk.mathworks.com/matlabcentral/fileexchange/26284-tooltip-waitbar?s_tid=ta_fx_results)[^7]

[^6]:[Yury (2023). im2col3, GitHub. Retrieved April 25, 2023.](https://github.com/caiuspetronius/im2col3/releases/tag/v1.0)

[^7]:[Geoffrey Akien (2023). Tooltip Waitbar, MATLAB Central File Exchange. Retrieved April 25, 2023.](https://www.mathworks.com/matlabcentral/fileexchange/26284-tooltip-waitbar)

## Running MIRRORS from the Matlab command line

MIRRORS requires the Image Processing Toolbox, Signal Processing Toolbox and the Statistics and Machine Learning Toolbox to be installed.

Download the [source code](https://github.com/olivertlord/MIRRORS/releases/latest) as a .ZIP or .tar.gz file, and extract to your desired location. 

To run MIRRORS, open Matlab, navigate to the MIRRORS directory and then type `MIRRORS`

It is convenient to add the MIRRORS directory to the Matlab PATH. To do so, at the Matlab command prompt type:

```
location = userpath
location = location(1:end-1)
cd(location)
edit startup.m
```

If you are prompted to create `startup.m`, then do so. In the new .m file that opens in the Editor, add `addpath(genpath('~/MIRRORS'));` (where `~/MIRRORS` is the full path to your MIRRORS directory). Now, next time you start Matlab, MIRRORS will be on the Matlab PATH and you can run MIRRORS from any location.

## Running MIRRORS from a standalone app

The MIRRORS standalone application requires the Matlab Component Runtime to be installed on your local machine, which can be dowdloaded for free. The version of the MCR you require depends on your operating system and the version of MATLAB that was used to create the standalone app you are using. For [the current release](https://github.com/olivertlord/MIRRORS/releases/latest):

* `Mac OS X (64-bit):`	[MCR version 9.13 for Mac (64-bit)](https://ssd.mathworks.com/supportfiles/downloads/R2022b/Release/5/deployment_files/installer/complete/maci64/MATLAB_Runtime_R2022b_Update_5_maci64.dmg.zip)

* `Windows (64-bit) :`	[MCR version 9.14 for Windows (64-bit)](https://ssd.mathworks.com/supportfiles/downloads/R2023a/Release/1/deployment_files/installer/complete/win64/MATLAB_Runtime_R2023a_Update_1_win64.zip)

For version [v1.7.9](https://github.com/olivertlord/MIRRORS/tree/v1.7.9) you will need:

* `Mac OS X (64-bit):`	[MCR version 9.11 for Mac (64-bit)](https://ssd.mathworks.com/supportfiles/downloads/R2021b/Release/1/deployment_files/installer/complete/maci64/MATLAB_Runtime_R2021b_Update_1_maci64.dmg.zip)

* `Windows (64-bit) :`	[MCR version 9.11 for Windows (64-bit)](https://ssd.mathworks.com/supportfiles/downloads/R2021b/Release/1/deployment_files/installer/complete/win64/MATLAB_Runtime_R2021b_Update_1_win64.zip)

For versions [v1.7.0](https://github.com/olivertlord/MIRRORS/tree/v1.7.0) to [v1.7.8](https://github.com/olivertlord/MIRRORS/tree/v1.7.8) you will need:

* `Mac OS X (64-bit):`	[MCR version 9.5 for Mac (64-bit)](http://ssd.mathworks.com/supportfiles/downloads/R2018b/deployment_files/R2018b/installers/maci64/MCR_R2018b_maci64_installer.dmg.zip) 

* `Windows (32-bit) :`	[MCR version 8.3 for Windows (32-bit)](https://uk.mathworks.com/supportfiles/downloads/R2014a/deployment_files/R2014a/installers/win32/MCR_R2014a_win32_installer.exe)

* `Windows (64-bit) :`	[MCR version 8.3 for Windows (64-bit)](https://uk.mathworks.com/supportfiles/downloads/R2014a/deployment_files/R2014a/installers/win64/MCR_R2014a_win64_installer.exe)

Once the correct MCR is installed, simply download and extract MIRRORS.app.zip (Mac Os X) or download MIRRORS.exe (Windows) from [your chosen release](https://github.com/olivertlord/MIRRORS/releases/), move it to a location of your choosing and double click to launch MIRRORS.

## Testing your installation

To check your installation is working, a set of example data files are provided along with a text file containing expected numerical output. The example data can be [downloaded as a .zip archive](https://github.com/olivertlord/MIRRORS/releases/latest).

Run MIRRORS (from the Matlab command line or the standalone app) and click on the `run test` button. MIRRORS will ask you to point it to the folder containing the example data. MIRRORS will then perform 80 calculations on the three data files within using a variety of options. If successful, two new text files, `test_data` and `results` will appear. Inspect `results` in a text editor. It should look something like this:

```
       NaN	  -0.60000	   0.00000	   0.00000	   0.00000	   0.00000	   0.00000	       NaN	
       NaN	  -0.60000	   0.00000	   0.00000	   0.00000	   0.00000	   0.00000	   0.00000	
       NaN	  -0.60000	   0.00000	   0.00000	   0.00000	   0.00000	   0.00000	   0.00000	
       NaN	  -0.60000	   0.00000	   0.00000	   0.00000	   0.00000	   0.00000	       NaN	
       NaN	  -0.60000	   0.00000	   0.00000	   0.00000	   0.00000	   0.00000	   0.00000	
       NaN	  -0.60000	   0.00000	   0.00000	   0.00000	   0.00000	   0.00000	   0.00000
```

I.e. it should contain only zeros and NaN values. Note that this test can take many minutes to complete, but does not test live mode.

## Customising MIRRORS for your system

Once MIRRORS is installed, you will need to set various hardware specific parameters to fit your system. This only needs to be done once, or when your hardware configuration changes.

### Update Hardware Parameters

1. Launch MIRRORS and click the `Update Hardware Parameters` button. This will open a separate window (see screenshot below), listing various hardware specific constants.

2. Update the values in the three sections to match your system:

**Filter Wavelengths Section**

The four boxes represent the four quadrants of your CCD image (or four separate cameras):
* **Top Left**: Wavelength (nm) for quadrant A (e.g., 670.08 nm)
* **Top Right**: Wavelength (nm) for quadrant B (e.g., 752.97 nm)  
* **Bottom Left**: Wavelength (nm) for quadrant C (e.g., 851.32 nm)
* **Bottom Right**: Wavelength (nm) for quadrant D (e.g., 578.61 nm)

If you are using a 4 camera setup, each camera must produce files appended with different letter from the list `_a`, `_b`, `_c` or `_d` where a = top left, b = top right, c = bottom left, d = bottom right of a stitched image as represented by the quadrants in the hardware parameter window.

**Spectral Radiance Section**

Enter the spectral radiance values (W sr⁻¹ m⁻² nm⁻¹) for each filter wavelength in the corresponding quadrant boxes.

**Optical Parameters Section**

You will need to change these parameters to match your system:
* `Pixel Width (nm)`: Physical size of each CCD pixel (e.g., 9 nm)
* `Magnification`: Total magnification of your optical system (e.g., 50)
* `NA`: Numerical aperture of your objective (e.g., 0.26)

3. Once updates are complete, click **save**. The window will close and the values will be remembered by the software.

### Update Calibration Image

1. Click the `Update Calibration Image` button and select your current thermal calibration image(s):
   * For single-camera systems: Select one .TIFF file containing all four quadrants
   * For four-camera systems: Select all four .TIFF files (they must be named with suffixes `_a`, `_b`, `_c` and `_d`)

2. The filename of your calibration will appear in the GUI below the button.

The calibration image should be from a source of known spectral radiance (e.g., a tungsten ribbon lamp) captured under the same optical conditions as your experiment.

![Update Hardware Parameters window](hardware_parameters_screenshot.png)

# Operation

MIRRORS can operate in two modes:
- **Post-Processing Mode**: For analyzing pre-existing image files after an experiment
- **Live Mode**: For real-time analysis during an active experiment

Both modes follow a similar workflow but differ in file selection and timing. This guide walks through each mode step-by-step.

## Post-Processing Mode

Use this mode to analyze image files that have already been saved to disk.

### Step 1: Select Camera Configuration

Choose your hardware setup:
- Click **One** if using a single camera (image divided into four quadrants)
- Click **Four** if using four separate cameras (four individual image files per measurement)

The selected button will turn green.

### Step 2: Select Number of Wavelengths

Choose how many wavelengths to fit:
- Click **4-color** to fit all four wavelengths (default, better for high temperatures)
- Click **3-color** to fit only the three brightest wavelengths (useful for low temperatures where one channel has poor signal-to-noise)

The selected button will turn green.

### Step 3: Configure Processing Options

On the right side of the GUI, configure these settings:

#### Checkboxes
- **Fit Saturated images**: Check to process images where some pixels are saturated (maxed out)
- **Fit blank images**: Check to process images where the signal is very weak
- **Save Output**: Check to save results to disk (highly recommended)

#### Intensity Cutoff Slider
Adjust the slider to set the minimum intensity threshold (as percentage of peak):
- **Higher values** (e.g., 50%): Only fit brightest pixels, faster processing
- **Lower values** (e.g., 10%): Fit more pixels including dimmer regions, slower but more complete maps
- Default: 25%

#### Peak Pixel Method (Radio Buttons)
Select how to identify the peak temperature:
- **Maximum Intensity**: Uses the brightest pixel (default, good for most cases)
- **Minimum Error**: Uses the pixel with smallest fitting error (good when noise is an issue)
- **Maximum Temperature**: Uses hottest pixel where error ≤ 5× minimum error
- **9th percentile**: Averages temperature across top 20% of intensity values (good for larger hot spots)
- **Centre pixel**: Uses the pixel at the center of the ROI (good when hot spot is perfectly centered)

#### Optional Plot (Radio Buttons)
Select what to display in the top-right plot:
- **Difference metric**: Shows image change over time (useful for detecting melting or phase transitions)
- **Temperature cross-sections**: Shows temperature profiles through the hot spot
- **Emissivity vs Temperature cross-sections**: Shows emissivity variation through the hot spot
- **Emissivity vs Peak T**: Shows how emissivity changes with temperature over time (useful for studying surface changes)

#### Colour Map
Select your preferred color scheme from the dropdown menu (default: jet).

### Step 4: Load Image Files

1. Click the **Post Process** button (it will turn green)
2. A file selection dialog will open
3. Navigate to your data folder
4. Select one or more .TIFF files to process:
   - For single-camera systems: Select the full-frame .TIFF files
   - For four-camera systems: Select all files (the software will automatically group sets of four by their _a, _b, _c, _d suffixes)
5. Click "Open"

The first selected image will appear in the bottom-right panel of the GUI showing all four quadrants.

### Step 5: Define Region of Interest (ROI)

1. Click the **ROI** button (it will turn green)
2. A red rectangle will appear on the image in the bottom-right panel
3. This rectangle defines the region to be analyzed:
   - The rectangle is constrained to areas where all four quadrants overlap after spatial correlation
   - You can resize the rectangle by dragging its corners or edges
   - You can reposition it by dragging from the center
   - The rectangle is constrained to remain square and within the valid analysis area
4. **Double-click inside the rectangle** when you're satisfied with the ROI selection
   - The rectangle will turn white
   - The **ROI** button will become inactive
   - The **process** button will become active (green)

### Step 6: Process the Data

1. Click the **process** button
2. A progress bar will appear at the bottom of the GUI
3. The software will:
   - Perform spatial correlation between the four quadrants
   - Apply thermal calibration
   - Fit the Wien approximation to Planck's law for each pixel
   - Calculate temperatures, errors, and emissivities
   - Generate all plots and maps

### Step 7: View Results

As processing completes, the GUI will populate with results:

#### Top Row Plots
- **Top Left**: Wien fit for the peak pixel (normalized intensity vs. normalized wavelength with linear fit)
- **Top Middle**: Peak temperature history over elapsed time with error bars
- **Top Right**: Your selected optional plot (difference metric, cross-sections, or emissivity plot)

#### Bottom Row Maps
- **Bottom Left**: Temperature map (K) with intensity contours and peak position marked
- **Bottom Middle**: Temperature error map (K)
- **Bottom Right**: Difference map (showing spatial temperature changes between successive images)

#### Bottom Right Panel
- Displays the current raw image being processed with the ROI marked

The title bar of the temperature history plot shows the timestamp and processing progress percentage.

### Step 8: Access Saved Output

If **Save Output** was checked, a new folder will be created in your image directory with a name like:
```
MIRRORS_output_YYYY_MM_DD_HH_MM_SS
```

This folder contains:
- **SUMMARY.txt**: Tab-delimited text file with one row per processed image containing:
  - Filename
  - Timestamp
  - Elapsed time (seconds)
  - Peak temperature (K)
  - Temperature error (K)
  - Emissivity
  - Emissivity error
  - Difference metric
  
- **[filename]_map.txt**: For each processed image, a text file containing pixel-by-pixel data:
  - Column 1-2: Pixel indices (x, y)
  - Column 3-4: Physical position (microns)
  - Column 5: Smoothed intensity
  - Column 6: Temperature (K)
  - Column 7: Temperature error (K)
  - Column 8: Emissivity (nm⁵/Jm)
  - Column 9: Emissivity error
  - Column 10: Difference metric

- **VIDEO.avi**: Time-lapse video showing the evolution of the GUI during processing (1 frame per second)

- **calibration.mat**: Copy of the calibration data used
- **hardware_parameters.mat**: Copy of the hardware parameters used

## Live Mode

Use this mode for real-time analysis during an active experiment when new image files are continuously being saved to disk.

### Step 1: Configure Settings

Follow the same configuration steps as Post-Processing Mode (Steps 1-3), setting:
- Camera configuration (One/Four)
- Number of wavelengths (4-color/3-color)
- Processing options (checkboxes, intensity cutoff, peak method, optional plot, color map)

**Note**: In Live Mode, the checkboxes for **Fit Saturated images** and **Fit blank images** are automatically enabled and cannot be disabled. This ensures no images are skipped during the experiment.

### Step 2: Start Live Mode

1. Click the **LIVE** button
2. A folder selection dialog will open
3. Navigate to and select the folder where images are being/will be saved during your experiment
4. Click "Select Folder"

The **LIVE** button will turn green, indicating Live Mode is active.

### Step 3: Automatic File Detection

The software will now:
- Continuously monitor the selected folder (checking every 1 second)
- Automatically detect new .TIFF files as they appear
- For four-camera systems, wait for all four files (_a, _b, _c, _d) to appear before processing
- Process each new image (or set of four images) automatically
- Update all plots and maps in real-time

The first new image detected will trigger the ROI selection workflow.

### Step 4: Define ROI (First Image Only)

When the first new image is detected:
1. The **ROI** button will automatically become active
2. Click the **ROI** button
3. Select your region of interest as described in Post-Processing Step 5
4. **Double-click inside the rectangle** to confirm

The same ROI will be used for all subsequent images.

### Step 5: Monitor Progress

As new images are processed:
- All plots update automatically
- Temperature history builds up over time
- Maps show the most recent image
- Progress indicators show elapsed time and image count

The bottom-right panel shows each new image as it's processed.

### Step 6: Stop Live Mode

To stop Live Mode and finish processing:
- Click the **LIVE** button again (it will turn gray)
- Processing will complete for any queued images
- If **Save Output** was checked, all results will be written to disk

---

## Understanding the Output Plots

### Wien Fit Plot (Top Left)
- **X-axis**: Normalized wavelength (c₂/λ where c₂ = 14387773.54 nm·K)
- **Y-axis**: Normalized intensity (natural log of calibrated radiance)
- **Blue circles**: Data points from the four wavelengths
- **Red line**: Linear fit to Wien approximation
- **Title**: Peak temperature ± error in Kelvin

The linearity of this fit validates the Wien approximation. Deviations indicate:
- Non-blackbody behavior
- Chromatic aberration effects
- Saturation or low signal issues

### Temperature History Plot (Top Middle)
- **X-axis**: Elapsed time since first image (seconds)
- **Y-axis**: Peak temperature (K)
- **Error bars**: Uncertainty in temperature
- **Title**: Current timestamp and processing progress percentage

Use this to monitor:
- Temperature stability
- Heating/cooling rates
- Timing of phase transitions

### Optional Plots (Top Right)

#### Difference Metric
- Shows how the *shape* of the temperature field changes over time
- Independent of absolute temperature changes
- Useful for detecting:
  - Melting (hot spot becomes more circular)
  - Sample movement
  - Laser mode changes

#### Temperature Cross-Sections
- **Red line**: Horizontal profile through peak pixel
- **Green line**: Vertical profile through peak pixel
- Shows temperature gradients
- Useful for estimating thermal gradients and hot spot size

#### Emissivity vs Temperature Cross-Sections
- Shows how emissivity varies spatially through the hot spot
- Can reveal temperature-dependent surface changes

#### Emissivity vs Peak T
- Shows time evolution of emissivity at the hottest point
- Useful for studying surface oxidation or changes in sample reflectivity

### Temperature Map (Bottom Left)
- **Color scale**: Temperature in Kelvin
- **White contours**: Lines of equal intensity (showing brightness gradients)
- **White square**: Location of peak pixel
- **Axes**: Physical distance in microns from map center

### Error Map (Bottom Middle)
- Shows uncertainty in temperature for each pixel
- Higher errors typically at:
  - Edge of hot spot (lower signal)
  - Saturated regions
  - Areas with chromatic aberration

### Difference Map (Bottom Right)
- Shows spatial changes in normalized temperature between current and previous image
- Weighted by intensity (dim pixels contribute less)
- Color scale auto-adjusts to show full range of changes
- For the first image, this map is blank (NaN values)

## Tips and Best Practices

### ROI Selection
- **Keep it square**: The analysis requires a square ROI for optimal binning
- **Avoid edges**: Stay away from the edge of the quadrants where spatial correlation may be poor
- **Center on hot spot**: For best results, center the ROI on your heated region
- **Not too large**: Larger ROIs increase processing time; select only the region of interest

### Processing Settings
- **Start with defaults**: Maximum Intensity peak method with 25% intensity cutoff works well for most cases
- **Low temperature measurements**: Switch to 3-color fitting and lower the intensity cutoff
- **High temperature measurements**: Use 4-color fitting for best accuracy
- **Noisy data**: Try Minimum Error or 9th percentile peak methods

### Calibration
- **Match conditions**: Calibration should be collected with the same optical setup, filters, and camera settings
- **Temperature range**: Calibration source should span your expected temperature range if possible
- **Regular recalibration**: Update calibration if you change filters, objectives, or camera settings

### Live Mode
- **Test first**: Always do a post-processing test run before using Live Mode during an important experiment
- **File naming**: Ensure your acquisition software produces compatible filenames
- **Network speed**: If saving to a network drive, ensure sufficient speed to avoid file access delays
- **Monitor performance**: Watch for dropped frames or processing delays

### Four-Camera Systems
- **Synchronized acquisition**: All four cameras must save their files nearly simultaneously
- **Consistent naming**: Files must follow the _a, _b, _c, _d suffix convention

### Troubleshooting

**ROI button inactive after loading files**
- Ensure at least one valid image was loaded
- Check that your images are .TIFF format

**No results after clicking process**
- Check that you've selected an ROI
- Verify your intensity cutoff isn't too high (try 10%)
- Ensure "Fit blank images" is checked if signal is weak

**Unexpected temperature values**
- Verify hardware parameters are correct
- Check calibration image is appropriate
- Ensure wavelength values match your filters

**Processing very slow**
- Reduce intensity cutoff to fit fewer pixels
- Select smaller ROI
- Close other applications to free memory

**Four-camera mode not grouping files correctly**
- Ensure filenames follow the exact pattern: basename_a.tiff, basename_b.tiff, etc.
- Check that all four files are present for each timestamp
- Verify file extensions are consistent (.tif or .tiff, not mixed)

## Output File Formats

### SUMMARY.txt Format
Tab-delimited text file with header row:
```
filename    timestamp    elapsed time (s)    T (K)    error (K)    emissivity    error    difference
```

Can be opened in Excel, MATLAB, Python, or any text editor for further analysis.

### Map Files Format
Space-delimited text file with no header, 10 columns per pixel:
```
x_index y_index x_microns y_microns intensity temperature error emissivity emissivity_error difference
```

Load into plotting software to create custom visualizations or perform additional analysis.

### VIDEO.avi
Standard uncompressed AVI format showing the GUI evolution. Useful for presentations or reviewing the entire experiment progression.

## Related Documentation

For more information about the theoretical background and validation:
- See the main README.md file for citations and hardware requirements
- Consult Lord & Wang (2018) Review of Scientific Instruments for detailed methodology
- See Campbell (2008) for the original MIR technique

## Troubleshooting

Should the testing procedure fail, or if you detect any bugs during use, then please contact me (Oliver Lord) at <oliver.lord@bristol.ac.uk>. Suggestions for new features are also welcome.

## Authors

* [**Oliver Lord, School of Earth Science, Univeristy of Bristol**](https://seis.bristol.ac.uk/~glotl/index.html)

* [**Weiwei Wang, Innovative Technology and Science Ltd**](http://www.innotecuk.com/)

## License

This project is licensed under the GNU General Public Licence Version 3 - see the [LICENSE.txt](licences/licence_GNU_GPL3.txt) file for details.

## Acknowledgments

* Mike Walter, Director, Gephysical Laboratory, Carnegie Institution of Washington for help and advice on all things radiometic.
* The students and post-doctoral researchers at the DAC lab, School of Earth Sciences, University of Bristol, who tested the software, detected numerous bugs and suggested improvements.
* Oliver Lord would like to acknowledge support from the Royal Society in the form of a University Research Fellowship (UF150057) and the Natural Environment Research Council (NERC) in the form of an Post-doctoral Research Fellowship (NE/J018945/1).
