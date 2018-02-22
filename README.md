# MIRRORS (MultIspectRal imaging RadiOmetRy Software)

MIRRORS is a Graphical User Interface (GUI) created using the Matlab(c) GUIDE(c) program and was written in Matlab(c). The software is designed to process .TIFF images from a four colour multispectral imaging radiometry system like the one developed by Campbell et al. (2008) for temperature measurement of samples laser heated in a diamond anvil cell and which has been copied at the School of Earth Sciences at the University of Bristol, UK. 

The GUI can work in either a live mode (during an experiment) or in a post-processing mode, and performs both spatial and thermal calibrations on the data beofre producing maps of temprature, temperature error and image difference (i.e. the change in shape of the temperature field, based on the work presented in the Supplementary Information of Briggs et al. 2017). The software also provides the user with an example Wien fit, peak temperature as a function of elapsed time, an image difference metric (also as a function of elapsed time), orthoganol temperature cross-sections centered on the peak pixel and finally emissivity as a function of temperature 9as described in Fischer & Campbell (2010).

## Getting Started

These instructions will get you a copy of the project up and running on your local machine.

### Prerequisites

MIRRORS requires Matlab to run and was written and tested on versions R2014a (Windows 7) & R2015/17a (OS X 10.13). It will likely work on all versions after R2014a on both Windows and OS X, but has not been tested. 

You will also need:

1. A multispectral imaging radiometry system that produces .TIFF files of any resolution, aspect ratio and bit depth. Each .TIFF must include four monochromatic images of the laser heated spot to be analysed, each centered on the middle pixel of one quadrant of the full image. The software performs a spatial calibration before stacking the four quadrants and so the centering does not need to be perfect. Each image must be at a different, precisely known wavelength.  

2. A thermal calibration .TIFF image produced using a calibrated source of known spectral radiance and and as before, consisting of four equal quadrants each illuminated by a monochromatic image of the calibration source.

Details of these systems as well as calibration methods can be found in Campbell et al. 2017 and Lord & Wang (in prep).

### Installing

Installation is simple. Simply navigate to https://github.com/olivertlord/MIRRORS and download the .ZIP file and extract it into your chosen directory. Alternatively, if you have git installed, then at the command line type:

```
cd targetdirectory
git clone https://github.com/olivertlord/MIRRORS.git
```
This will craete a clone of the GitHub repository called ```MIRRORS``` inside ```targetdirectory```

To run MIRRORS, simply open Matlab, navigate to the MIRRORS directory and then type

```
MIRRORS
```

To add the MIRRORS directory to the Matlab PATH, at the Matlab command prompt type:
End with an example of getting some data out of the system or using it for a little demo

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

Before using MIRRORS, you will need to edit the code to match your hardware. Find the following lines in ```mapper.m```:

```
%//////////////////////////////////////////////////////////////////////////
% HARDWARE SPECIFIC - REQUIRES EDITING
% Wavelengths in nm
wa = 670.08; %top left
wb = 752.97; %top right
wc = 851.32; %bottom left
wd = 578.61; %bottom right

% Values of Spectral Radiance of calibration source at each wavelength in 
sr_wa = 7.26917; 
sr_wb = 9.86540; 
sr_wc = 12.0780; 
sr_wd = 4.19100;
%//////////////////////////////////////////////////////////////////////////
```

You will need to change the values ```wa```,```wb```,```wc```,```wd```, to match the wavelngths of the filters used in your system, being careful to correctly match the wavelgnth of the image to its quadrant in the image. You will also need to change the values of ```sr_wa```,```sr_wb```,```sr_wc```,```sr_wd``` to the spectral radiance of your calibration source at the relevant wavelength.

### Testing

To check that MIRRORS is working correctly, a set of example data files are provided, along with screnshots of the MIRRORS GUI after processing and output files containing the epected results. Below are instructions on how to process these files and check that the output matches expectations.

To test your insatallation:

1. Run MIRRORS by typing ```MIRRORS``` at the Matlab command prompt.

2. Once the GUI has opened, click the 'Post process' button. 

3. Navigate to the folder ```/MIRRORS/example/data``` and click 'Open'. 

4. Click 'Select ROI' and then double click inside the white rectangle that appears in the summary plot window at the bottom right of the GUI. The 'Select ROI' button should go green.

5. Type '1' in the 'Start' box and '11' in the 'End' box. Both should go green.

6. Check that the tickboxes and radiobuttons match those in ```/MIRRORS/example/data/test_1/test_1.png```.

7. Click 'Process'. Once processing is complete, the GUI window should look like ```/MIRRORS/example/data/test_1/test_1.png```.

8. A new folder should appear in ```/MIRRORS/example/data``` of the form ```MIRRORS_output_xx_xxx_xxx_xx_xx_xx``` where the x's denote the date and time. Inside that folder should be 13 files, 11 of the form ```example_xxx_map.txt``` where xxx is 001 to 011, 1 called ```data_SUMMARY.txt``` and 1 called ```data_VIDEO.avi```.

9. 

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone who's code was used
* Inspiration
* etc
