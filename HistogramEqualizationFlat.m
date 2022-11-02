% Function to transform an object in the "foreground" of an image into another image
% that has a histogram that looks like the foreground itself.
% I provide three examples with 3 demo images:
%   I change the image of a city skyline so that the histogram of the new image looks like the skyline.
%   I change the image of a car so that the histogram of the new image looks like the car shape.
%   I change the image of a woman so that the histogram of the new image looks like the shape of the woman.
% By Image Analyst
% September 2010
function HistogramEqualization()
try
	workspace;	% Make sure the workspace panel is showing.
	fontSize = 14;
	
	% Introduce the demo, and ask user if they want to continue or exit.
	message = sprintf('This demo will create an image with that has a flat histogram (TRULY histogram equalized).\nIt requires the Image Processing Toolbox.\nMake your selection.');
	reply = questdlg(message, 'Run Demo?', 'Demo Image', 'My Own Image', 'Cancel', 'Demo Image');
	if strcmpi(reply, 'Cancel')
		% User canceled so exit.
		return;
	elseif strcmpi(reply, 'Demo Image')
		%===============================================================================
		% Get the name of the demo image the user wants to use.
		% Let's let the user select from a list of all the demo images that ship with the Image Processing Toolbox.
		folder = fileparts(which('cameraman.tif')); % Determine where demo folder is (works with all versions).
		% Demo images have extensions of TIF, PNG, and JPG.  Get a list of all of them.
		imageFiles = [dir(fullfile(folder,'*.TIF')); dir(fullfile(folder,'*.PNG')); dir(fullfile(folder,'*.jpg'))];
		for k = 1 : length(imageFiles)
		% 	fprintf('%d: %s\n', k, files(k).name);
			[~, baseFileName, extension] = fileparts(imageFiles(k).name);
			ca{k} = baseFileName;
		end
		% celldisp(ca);
		button = menu('Use which gray scale demo image?', ca); % Display all image file names in a popup menu.
		% Get the base filename.
		baseFileName = imageFiles(button).name; % Assign the one on the button that they clicked on.
		% Get the full filename, with path prepended.
		fullFileName = fullfile(folder, baseFileName);

		% Read in demo image.
		grayImage = imread(fullFileName);
	else
		% They want to use their own image.
		% Get the name of the color image file that the user wants to use.
		defaultFileName = fullfile(startingFolder, '*.*');
		[baseFileName, folder] = uigetfile(defaultFileName, 'Select a file');
		if baseFileName == 0
			% User clicked the Cancel button.
			return;
		end
		fullFileName = fullfile(folder, baseFileName);
		grayImage = imread(fullFileName);
	end
	% Get the dimensions of the image.  
	% numberOfColorBands should be = 1.
	[rows, columns, numberOfColorBands] = size(grayImage);
	if numberOfColorBands > 1
		message = sprintf('This is not a gray scale image.\nI will convert it to gray scale so I can continue.');
		reply = questdlg(message, 'Convert to gray scale?', 'OK', 'Cancel', 'OK');
		if strcmpi(reply, 'Cancel')
			return;
		end
		grayImage = rgb2gray(grayImage);
	end

	% Check that user has the Image Processing Toolbox installed.
	versionInfo = ver; % Capture their toolboxes in the variable.
	hasIPT = license('test', 'image_toolbox');
	if ~hasIPT
		% User does not have the toolbox installed.
		message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
		reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
		if strcmpi(reply, 'No')
			% User said No, so exit.
			return;
		end
	end

	% Display oroginal image.
	subplot(2, 2, 1); 
	imshow(grayImage, []);
	caption = sprintf('Initial Gray Image.');
	title(caption, 'FontSize', fontSize, 'Color', 'b');
	
	% Set up figure properties:
	% Enlarge figure to full screen.
	set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
	% Get rid of tool bar and pulldown menus that are along top of figure.
	set(gcf, 'Toolbar', 'none', 'Menu', 'none');
	% Give a name to the title bar.
	set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 
	drawnow; % Force it to display immediately.

	% Now, let's get its histogram.
	PlotGrayHistogram(grayImage);
	drawnow; % Force it to display immediately.

	% Now let's transform the gray image so that it has a histogram like the binary image.
	[outputImage, desiredPixelsInEachBin] = TransformImage(grayImage);
	outputImage = uint16(outputImage);

	% Now, let's get the histogram of the transformed image.
	% It should look like the skyline.
	numberOfOutputBins = 256;
	% Get the histogram, one bin per gray level.
	[pixelCountT, grayLevelsT] = imhist(outputImage, 65536);
	% We don't need all those gray levels, just the same number of gray levels
	% as there are columns in the binary image.  So take just those.
% 	pixelCountT(1) = 0;
	pixelCountT = pixelCountT(1:numberOfOutputBins);
	
	% Display the transformed image in the upper right.
	subplot(2, 2, 3);
	imshow(outputImage, []);
	title('Transformed Gray Image', 'FontSize', fontSize, 'Color', 'b');
	axis on;
	% Display the transformed histogram in the lower right.
	subplot(2, 2, 4);
	bar(pixelCountT, 'BarWidth', 1); 
% 	axis square;
	grid on;
	caption = sprintf('Histogram of\nTransformed Gray Image');
	title(caption, 'FontSize', fontSize, 'Color', 'b');
	xlim([0 numberOfOutputBins]); % Scale x axis manually.
	% If it's a flat histogram, let's make the max Y height a little bigger than the height of the bars.
	maxBarheight = max(pixelCountT);
	yAxisLength = maxBarheight * 1.2;
	ylim([0 yAxisLength]);
	
	% Ask if user wants to save the transformed image to a new file.
	message = sprintf('Done with the demo!\n\nDo you want to save the transformed image to a new file?');
	reply = questdlg(message, 'Done!  Save Image?', 'Save Image', 'Exit', 'Exit');
	if strcmpi(reply, 'Save Image')
		filterSpec = '*.*';
		defaultName = sprintf('FlatHistogramImage.png');
		dialogTitle = 'Save Tranformed Image?';
		[baseFileName, folder] = uiputfile(filterSpec, dialogTitle, defaultName);
		if baseFileName == 0
			% User clicked cancel.
			return; % Bail out.
		end
		fullFileName = fullfile(folder, baseFileName);
		% If the number of bins is less than 256, convert it to a uint8 image
		% for ease of getting histograms in other software packages.
		% Otherwise it will be a uint16 image and the gray levels will be in the low end of the 32768 gray levels,
		% so other software may compress the histogram and gray levels (because they want to do the whole range)
		% and this will make it difficult to see unless you do special things to see them.
		if numberOfOutputBins <= 256
			% Our demo images are NOT this because they all have more than 256 columns
			% so we won't get here for our demos.
			outputImage = uint8(outputImage);
		end
		% Save the array out to a disk file.
		imwrite(outputImage, fullFileName);
		message = sprintf('Image file has been saved.\n%s\n\nNOTE: To make this 16 bit image look right in Photoshop\nyou have to do Image->Adjustments->Auto Levels', fullFileName);
		msgbox(message);
	end

catch ME
	errorMessage = sprintf('Error in program %s, function %s(), at line %d.\n\nError Message:\n%s', ...
		mfilename, ME.stack(1).name, ME.stack(1).line, ME.message);
	WarnUser(errorMessage);
end
return; % from HistogramEqualizationFlat, the main routine.

%=====================================================================
function PlotGrayHistogram(grayImage)
	try
		fontSize = 20;

		% Let's get its histograms.
		[pixelCount, grayLevels] = imhist(grayImage);
		subplot(2, 2, 2); 
		bar(pixelCount, 'BarWidth', 1); 
		grid on;
		caption = sprintf('Histogram of Gray Scale Image');
		title(caption, 'FontSize', fontSize, 'Color', 'b');
		xlim([0 grayLevels(end)]); % Scale x axis manually.

	catch ME
		errorMessage = sprintf('Error in PlotGrayHistogram():\n\nError Message:\n%s', ME.message);
		uiwait(warndlg(errorMessage));
	end
	return; % from PlotGrayHistogram()
	
	
%=====================================================================
function [outputImage, desiredPixelsInEachBin] = TransformImage(grayImage)
	try
	% Find the dimensions the image.
	[rows, columns] = size(grayImage);
	numberOfPixelsInImage = double(rows) * double(columns);
	
	% A gray level image has only 256 gray levels, but the binary image
	% can have more of less than that number of columns in it.
	% To do this accurately, we'll need to convert the uint8 image so that
	% it will have the same number of intensity levels as the binary image has columns.
	dblImage = double(grayImage);
	% I know this sounds strange but you need some randomness to do this,
	% otherwise, how can you split up the number of pixels at one gray level
	% (and thus all lie in one bin) into a different number of bins?
	% You may have to think about that a bit, but if you do, you'll see that you
	% can do it two ways.  Let's take an example.  Let's say that you have 1000 pixels
	% in bin 50, and let's say the binary image is 512 columns across.
	% So we need to take the pixels that are in bin 50 (which may be scattered
	% across the image) and put them into two bins, which may be at locations
	% 71 and 72, for example.  So which of those 1000 pixels gets mapped to gray level
	% 71 and which of the 1000 pixels gets mapped to gray level 72?  See - that's why
	% you need randomness.  One way to do it is to just find the 1000 pixels 
	% in the image and randomly take right proportion of them to put in each bin.
	% The way I'm going to do it is to add up to +/- 0.5 gray levels of noise to the pixel values of our
	% floating point image.  This is valid because we have a quantized image.  For example
	% take a pixel at gray level 50.  Now you know that it could have had a
	% number of photons coming in that corresponded to a gray level anywhere in between
	% 49.5 gray levels and 50.5 gray levels.  Anything in that range would have been
	% quantized to 50.  You wouldn't be able to tell.  So we're basically just undoing the process.
	% We're taking everything at 50 and redistributing it back over 49.5 to 50.5.
	% Then, when we sort the image, and take some fractions of the pixels with gray level 50,
	% and remap them to another gray level (e.g. 71 or 72), they will come from random locations all over the image.
	% Pretty clever, huh?
	noisyImage = dblImage + rand(rows, columns) - 0.5;
	minGL = min(min(noisyImage));
	maxGL = max(max(noisyImage));
	slope = 255.0 / (maxGL - minGL);
	noisyImage = slope * (noisyImage - minGL);
	% Now there may be some pixels in the -0.5 - 0 range.
	% We don't want that to mess up our bin positions so let's put all negative
	% values in the 0-0.5 bin by simply negating them.
	noisyImage(noisyImage<0) = -noisyImage(noisyImage<0);
	% Same thing for pixels in the 255 - 255.5 range.
	% Move them back into the 254.5 - 255 range by simply subtracting 0.5.
	noisyImage(noisyImage>255) = noisyImage(noisyImage>255) - 0.5;
	% Check to make sure it did it right.
	minGL = min(min(noisyImage));
	maxGL = max(max(noisyImage));
	
	% Let's get its histogram.
	% Have the number of bins be equal to the number of columns.
	% Find out the counts that each bin ACTUALLY holds.
	[pixelCountsActual, grayLevelsActual] = imhist(noisyImage, columns);
	numberOfBins = length(pixelCountsActual);
	
	% Find out the number of pixels that each bin SHOULD hold.  Make an array of 255 bins of equal height.
	desiredPixelsInEachBin = ceil(numberOfPixelsInImage / 256) * ones(255, 1);
	% The last bin may have a different number of pixels if the number of pixels
	% in the image is not a multiple of 256.
	desiredPixelsInEachBin(256) = numberOfPixelsInImage - sum(numberOfPixelsInImage);

	% Convert the 2D image into a 1D vector.
	lineImage = reshape(noisyImage, [1, rows*columns]);
	% Sort this
	[sortedValues, sortedIndexes] = sort(lineImage);
	% Now here's the tough, tricky part.
	% We need to go through every intensity of the output image (0 - #columns in image), and:
	% 1. Find the number of the pixels of that intensity that should go in that bin.
	% 2. Start going along the sorted input image and find out where those gray levels occur
	% 3. Assign those locations in the output image the intensity that we're processing.
	% 4. Then move on to the next intensity.
	% By the way, if they asked for a flat histogram, this will give a much flatter histogram than 
	% the function adapthisteq(), in fact, it will give a perfectly flat histogram.
	outputImage = -1 * ones(1, length(lineImage));
	% Make a pointer to our sorted list of input pixels.
	% We're going to march this along until we've transformed
	% each and every one of them and stored the new value in our output image.
	pointer = 0;
	maxOutputGrayLevel = length(grayLevelsActual);
	for outputBin = 1 : maxOutputGrayLevel
% 		fprintf(1, 'outputBin = %d,   pointer = %d\n', outputBin, pointer);
		desiredPixelsInThisBin = desiredPixelsInEachBin(outputBin);
		% Start marching along all input pixels...
		for p = 1:desiredPixelsInThisBin
			if pointer+p > numberOfPixelsInImage
				% Bail out if rounding errors cause this to be greater
				% than the array length.
				break;
			end
% 			originalGrayLevel = sortedValues(pointer+p);
			% Find out the linear index where this sorted pixel originally lived.
			originalIndex = sortedIndexes(pointer+p);
			% Replace the pixel at that original location
			% with the gray level that we need it to have.
			outputImage(originalIndex) = outputBin - 1; % New, desired gray level
		end
		% Move the pointer along to the next input pixel that we will transform.
		pointer = pointer + desiredPixelsInThisBin;
		% Now go on to the next gray level, if we need to, by continuing the loop.
	end
	
	% Sometimes, due to rounding, there are still a very few pixels (~10 or so)
	% that did not get assigned.  These will have the value -1 and should be
	% assigned the maximum gray level.  Unless fixed, they show up a dark
	% anomolous dark specks in the bright parts of the image.  Let's fix them.
	outputImage(outputImage == -1) = maxOutputGrayLevel;
	
	% Now outputImage is good - it has been transformed.
	% But it's the wrong shape - it's still in a line.
	% Reshape it to the size of the original image.
	outputImage = reshape(outputImage, [rows columns]);
	
	catch ME
		errorMessage = sprintf('Error in TransformImage():\n\nError Message:\n%s', ME.message);
		uiwait(warndlg(errorMessage));
	end
	
	return; % from TransformImage
	
%==========================================================================================================================
% Warn user via the command window and a popup message.
function WarnUser(warningMessage)
fprintf(1, '%s\n', warningMessage);
uiwait(warndlg(warningMessage));
return; % from WarnUser()

