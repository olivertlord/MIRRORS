# MIRRORS (MultIspectRal imaging RadiOmetRy Software) Version 1.7.0

[![DOI](https://zenodo.org/badge/100439021.svg)](https://zenodo.org/badge/latestdoi/100439021)

MIRRORS is a Graphical User Interface (GUI) created using the Matlab© GUIDE© program. The software is designed to process .TIFF images from a four colour multispectral imaging radiometry system like the one developed by Campbell (2008) for temperature measurement of samples laser heated in a diamond anvil cell and which has been copied at the School of Earth Sciences at the University of Bristol, UK (Lord et al. 2014).

The GUI can work in either a live mode (during an experiment) or in a post-processing mode, and performs both spatial and thermal calibrations on the data before producing maps of temperature, temperature error and image difference (i.e. the change in shape of the temperature field, based on the work presented in the Supplementary Information of Briggs et al. 2017). The software also provides the user with an example Wien fit, peak temperature as a function of elapsed time, an image difference metric (also as a function of elapsed time), orthoganol temperature cross-sections centered on the peak pixel and finally emissivity as a function of temperature (as described in Fischer & Campbell (2010). 

MIRRORS is described in detail in the following publication:

Lord, O. T., & Wang, W. (2018). MIRRORS: A MATLAB ®GUI for temperature measurement by multispectral imaging radiometry. Review of Scientific Instruments, 89(10), 104903. http://doi.org/10.1063/1.5041360

## Prerequisites

MIRRORS requires a multispectral imaging radiometry system that produces .TIFF files of any resolution, aspect ratio and bit depth but each .TIFF must include four monochromatic images of the laser heated spot to be analysed, each centered on the middle pixel of one quadrant of the full image. The software performs a spatial calibration before stacking the four quadrants and so the centering does not need to be perfect. Each image must be at a different, precisely known wavelength.  

The system needs a thermal calibration .TIFF image produced using a calibrated source of known spectral radiance and as before, consisting of four equal quadrants each illuminated by a monochromatic image of the calibration source.

Details of the MIR system as well as calibration methods can be found in Campbell et al. (2008) and Lord & Wang (2018).

## Installation

MIRRORS can be run either from the Matlab command line or as a standalone application on Mac OS X or Windows 7. MIRRORS was written and tested on versions R2014a (Windows 7) & R2015a/17a/18b (OS X 10.13). It will likely work on all versions after R2014a on both Windows 7 and OS X, but has not been explicity tested.

### Instructions for users intending to run MIRRORS from the Matlab command line

MIRRORS requires the Matlab image, signal and statistics toolboxes to be installed.

Simply navigate to https://github.com/olivertlord/MIRRORS/releases/latest and download the latest source code (as either a .ZIP or .tar.gz file) and extract to your desired location. 

To run MIRRORS, open Matlab, navigate to the MIRRORS directory and then type

```
MIRRORS
```

To add the MIRRORS directory to the Matlab PATH, at the Matlab command prompt type:

```
location = userpath
location = location(1:end-1)
cd(location)
edit startup.m
```

At this point, if you are prompted to create ```startup.m```, then do so. In the new .m file that opens in the Editor, add the following line and resave:

```
addpath(genpath('~/MIRRORS'));
```

Where ```~/MIRRORS``` is the full path to your MIRRORS directory. Now, next time you start Matlab, MIRRORS will be on the Matlab PATH and you can type MIRRORS at the command prompt from any directory and the GUI should run.

### Instructions for users intending to run MIRRORS from the standalone app

The MIRRORS standalone application requires the Matlab Component Runtime, which can be dowdloaded for free. If you are running MIRRORS on Mac OS X, then you will need [MCR version 9.5 ofr Mac](http://ssd.mathworks.com/supportfiles/downloads/R2018b/deployment_files/R2018b/installers/maci64/MCR_R2018b_maci64_installer.dmg.zip). If you are running MIRRORS on Windows 7, then you will need [MCR version 8.3 for Windows (32-bit)] (https://uk.mathworks.com/supportfiles/downloads/R2014a/deployment_files/R2014a/installers/win32/MCR_R2014a_win32_installer.exe)

Once this is installed, simply download MIRRORS.app (Mac Os X) or MIRRORS.exe (Windows 7) from https://github.com/olivertlord/MIRRORS/releases/latest and move it to a location of your choosing. Double clicking on the APP should launch MIRRORS.

## Customising Mirrors for your system

Once MIRRORS is installed, you will need to set various hardware specific parameters to fit your system. To do this:

1. Click the ```Update Calibration Image``` button and select your current thermal calibration image.

2. Click the ```Update Hardware Parameters``` button. This will produce the following window:

![alt text](https://raw.githubusercontent.com/olivertlord/MIRRORS/master/hardware_parameters_screenshot.png)

Change the values to match your system. The ```Filter Wavelengths``` and ```Spectral Radiance``` values are arranged graphically to mimic the quadrants of the CCD so be careful to correctly match the wavelength to its quadrant in the image.

You will also need to change the following constants to values appropriate for your system:

* `pixel_width` - the size of the pixels of the CCD camera 
* `system_mag` - the magnification of the system
* `NA` - numerical aperture

## Testing

To check that MIRRORS is working correctly, a set of example data files are provided, along with screnshots of the MIRRORS GUI after processing plus output files containing the expected results. The example data can be downloaded as a .zip archive from https://github.com/olivertlord/MIRRORS/releases/latest. 

Before testing mirrors, whether you are running it from the Matlab command line or the standalone app, you must ensure that it is set up the way it was when the benchmarking output was created. To do this you need to do two things:

1. Click the ```Update Calibration Image``` button and select ```tc_example.tiff``` within the ```MIRRORS/example``` folder.

2. Click the ```Update Hardware Parameters``` button and change the values to those in the image above.

### Testing MIRRORS when running it from the Matlab command line

If you are running MIRRORS from the Matlab command line, then click on the ```Benchmark``` button in the MIRRORS GUI. MIRRORS will prompt you to select the folder containing the example data. MIRRORS will then automatically fit the example data repeatedly, using different options, and compare each against the output files that contain the expected results (also stored in ```MIRRORS/example/```.

After each of the 16 test runs are complete, you should see output at the command line that looks like this:

```
difference =

         0    0.0016         0         0         0         0         0       NaN
         0    0.0016         0         0         0         0         0         0
         0    0.0016         0         0         0         0         0         0
         0    0.0016         0         0         0         0         0         0
         0    0.0040  206.0000         0         0         0         0         0
```
Any differences in column 2 and 3 simply reflect the fact that when downloading files from the internet, their modification date is set as the download time, rather than the time they were acquired. MIRRORS automatically resets these timestamps when you run the benchmark routine so there is at least 1 second between each. This allows the data to be plotted as a function of time, but the times will not match those in the example output. This is not a problem with MIRRORS and can be ignored. 

### Testing MIRRORS when running the standalone app

If you are using the standalone MIRRORS app, you probably don't have access to Matlab but you can still check that MIRRORS is working, using the same procedure as described above

The tests will run, but you will not see the numerical output. Instead, you will find 16 new folders within the ```example``` folder with names of the form ```MIRRORS_output_xx_xxx_xxx_xx_xx_xx``` containing a ```data_SUMMARY.txt``` file. Looking at the first of these folders, compare the contents of ```data_SUMMARY.txt``` with ```example/data/test_1/data_SUMMARY.txt```. The contents should be identical, except for columns two and three. Repeat this for the second folder, comparing ```MIRRORS_output_xx_xxx_xxx_xx_xx_xx/data_SUMMARY.txt``` with ```example/data/test_2/data_SUMMARY.txt```, and so on for all 16 folders.

### Troubleshooting

Should the testing procedure fail, or if you detect any bugs during use, then please contact me (Oliver Lord) at <oliver.lord@bristol.ac.uk>. Suggestions for new features are also welcome.

## Authors

* **Oliver Lord, School of Earth Science, Univeristy of Bristol** - (https://github.com/olivertlord, https://seis.bristol.ac.uk/~glotl/index.html)

* **Weiwei Wang, Innovative Technology and Science Ltd** - (http://www.innotecuk.com/)

## License

This project is licensed under the GNU General Public Licence Version 3 - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Mike Walter, Director, Gephysical Laboratory, Carnegie Institution of Washington for help and advice on all things radiometic.
* The students and post-doctoral researchers at the DAC lab, School of Earth Sciences, University of Bristol, who tested the software, detected numerous bugs and suggested improvements.
* I (Oliver Lord) would like to acknowledge support from the Royal Society in the form of a University Research Fellowship (UF150057) and the Natural Environment Research Council (NERC) in the form of an Post-doctoral Research Fellowship (NE/J018945/1).

## References

* Briggs, R., Daisenberger, D., Lord, O. T., Salamat, A., Bailey, E., Walter, M. J., & McMillan, P. F. (2017). High-pressure melting behavior of tin up to 105 GPa. Physical Review B, 95(5), 054102. http://doi.org/10.1103/PhysRevB.95.054102

* Campbell, A. J. (2008). Measurement of temperature distributions across laser heated samples by multispectral imaging radiometry. Review of Scientific Instruments, 79(1), 015108. http://doi.org/10.1063/1.2827513

* Fischer, R. A., & Campbell, A. J. (2010). High-pressure melting of wustite. American Mineralogist, 95(10), 1473–1477. http://doi.org/10.2138/am.2010.3463

* Lord, O. T., Wood, I. G., Dobson, D. P., Vočadlo, L., Wang, W., Thomson, A. R., et al. (2014). The melting curve of Ni to 1 Mbar. Earth and Planetary Science Letters, 408, 226–236. http://doi.org/moving 10.1016/j.epsl.2014.09.046
