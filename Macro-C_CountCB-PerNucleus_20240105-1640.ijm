// dir = "/Users/jacobroth/Library/CloudStorage/OneDrive-Personal/RothJacob_PhDFiles/1-Projects/2-Experiments/JSRe0118-T_NB04-104_TimeCourseIF-CBsHLBs-PRMTi/4-data_processed/20231220_Batch05/"; 
dir = "/Users/jacobroth/Library/CloudStorage/OneDrive-Personal/RothJacob_PhDFiles/1-Projects/2-Experiments/JSRe0118-T_NB04-104_TimeCourseIF-CBsHLBs-PRMTi/4-data_processed/20231221_Batch05/"; 

// 3-hour treatments
	// slide_DMSO = "JSRs023_Z-Stitch"
	// slide_GSK = "JSRs024_Z-Stitch_01"
	// slide_MS023 = "JSRs025_Z-Stitch_01"
	// slide_GM = "JSRs026_Z-Stitch_01"
	
// 24-hour treatments
	// slide_DMSO = "JSRs027_Z-Stitch_01"
	// slide_GSK = "JSRs028_Z-Stitch_01"
	// slide_MS023 = "JSRs029_Z-Stitch_01"
	// slide_GM = "JSRs030_Z-Stitch_01"

// 48-hour treatments
	slide_DMSO = "JSRs031_Z-Stitch_01"
	slide_GSK = "JSRs032_Z-Stitch_01"
	slide_MS023 = "JSRs033_Z-Stitch_01"
	slide_GM = "JSRs034_Z-Stitch_01"

//96-hour treatments
	// slide_DMSO = "JSRs035_Z-Stitch_01"
	// slide_GSK = "JSRs036_Z-Stitch_01"
	slide_MS023 = "JSRs037_Z-Stitch_01"
	// slide_GM = "JSRs038_Z-Stitch_01"

// location = "/20231220_FF-Stitched_"
location = "/20231221_FF-Stitched_"

CH1 = "DAPI"
CH2 = "WDR79"
CH3 = "Actin"
CH4 = "Coilin"

analyzeme = slide_MS023

run("Fresh Start"); // this removes all images and saved data
// https://forum.image.sc/t/fresh-start-macro-command-in-imagej-fiji/43102/7
// run("Fresh Start", "images results rois"); // to note remove images, results, or rois

// Open the DAPI image
open(dir + analyzeme + location + CH1 + ".tif");
rename(CH1);
rename("DAPI");

// Convert RGB to 16-bit
run("16-bit");

// Threshold the DAPI image
setAutoThreshold("RenyiEntropy dark no-reset");
run("Convert to Mask");
run("Watershed");
run("Fill Holes");

// Analyze particles to get the ROIs of the nuclei and measure their size
run("Set Measurements...", "area redirect=None decimal=3");
run("Analyze Particles...", "size=0.1-6 circularity=0.00-1.00 show=Outlines display exclude add");

// Store the initial count of ROIs and nucleus sizes
initialROICount = roiManager("count");
nucleusSizes = newArray(initialROICount);
for (j = 0; j < initialROICount; j++) {
    nucleusSizes[j] = getResult("Area", j);
}

// Clear the results table after storing nucleus sizes
run("Clear Results");

// Open the Coilin image
open(dir + analyzeme + location + CH4 + ".tif");
rename(CH4);

// Convert RGB to 16-bit
run("16-bit");
// Threshold the Coilin image
setAutoThreshold("RenyiEntropy dark no-reset"); // RenyiEntropy captured some of the diffuse areas but not all; Max Entropy seems to be better at diffuse; Intermodes is only puncta; minimum is too few puncta missing some
run("Convert to Mask");
run("Fill Holes");

// Array to store Coilin counts
coilinCounts = newArray(initialROICount);

// For each initial ROI, select it and analyze the Coilin puncta within
for (i = 0; i < initialROICount; i++) {
    roiManager("Select", i);
    // Count the number of Coilin puncta within the ROI
    run("Analyze Particles...", "size=0.0005-0.1 circularity=0.00-1.00 show=Nothing clear");
    // Store the count of Coilin puncta
    coilinCounts[i] = nResults;
}


// Open the WDR79 image
open(dir + analyzeme + location + CH2 + ".tif");
rename(CH2);

// Convert RGB to 16-bit
run("16-bit");

// Substract background
run("Subtract Background...", "rolling=50");

// Threshold the WDR79 image
setAutoThreshold("RenyiEntropy dark no-reset");
run("Convert to Mask");
run("Fill Holes");

// Array to store WDR79 counts
wdr79Counts = newArray(initialROICount);

// For each initial ROI, select it and analyze the WDR79 puncta within
for (i = 0; i < initialROICount; i++) {
    roiManager("Select", i);
    // Count the number of WDR79 puncta within the ROI
    run("Analyze Particles...", "size=0.0005-0.1 circularity=0.00-1.00 show=Nothing clear");
    // Store the count of WDR79 puncta
    wdr79Counts[i] = nResults;
}

// Clear any existing results
run("Clear Results");

// Populate the Results table with the data
for (i = 0; i < initialROICount; i++) {
    setResult("Nucleus", i, i + 1);
    setResult("Nucleus Size", i, nucleusSizes[i]);
    setResult("Coilin Count", i, coilinCounts[i]);
    setResult("WDR79 Count", i, wdr79Counts[i]);
    updateResults();
}

// Save the Results table
saveAs("Results", dir + analyzeme + "/NucleusCoilinWDR79Counts_Macro-C.csv");

run("Fresh Start"); // this removes all images and saved data



analyzeme = slide_GSK

run("Fresh Start"); // this removes all images and saved data
// https://forum.image.sc/t/fresh-start-macro-command-in-imagej-fiji/43102/7
// run("Fresh Start", "images results rois"); // to note remove images, results, or rois

// Open the DAPI image
open(dir + analyzeme + location + CH1 + ".tif");
rename(CH1);
rename("DAPI");

// Convert RGB to 16-bit
run("16-bit");

// Threshold the DAPI image
setAutoThreshold("RenyiEntropy dark no-reset");
run("Convert to Mask");
run("Watershed");
run("Fill Holes");

// Analyze particles to get the ROIs of the nuclei and measure their size
run("Set Measurements...", "area redirect=None decimal=3");
run("Analyze Particles...", "size=0.1-6 circularity=0.00-1.00 show=Outlines display exclude add");

// Store the initial count of ROIs and nucleus sizes
initialROICount = roiManager("count");
nucleusSizes = newArray(initialROICount);
for (j = 0; j < initialROICount; j++) {
    nucleusSizes[j] = getResult("Area", j);
}

// Clear the results table after storing nucleus sizes
run("Clear Results");

// Open the Coilin image
open(dir + analyzeme + location + CH4 + ".tif");
rename(CH4);

// Convert RGB to 16-bit
run("16-bit");
// Threshold the Coilin image
setAutoThreshold("RenyiEntropy dark no-reset"); // RenyiEntropy captured some of the diffuse areas but not all; Max Entropy seems to be better at diffuse; Intermodes is only puncta; minimum is too few puncta missing some
run("Convert to Mask");
run("Fill Holes");

// Array to store Coilin counts
coilinCounts = newArray(initialROICount);

// For each initial ROI, select it and analyze the Coilin puncta within
for (i = 0; i < initialROICount; i++) {
    roiManager("Select", i);
    // Count the number of Coilin puncta within the ROI
    run("Analyze Particles...", "size=0.0005-0.1 circularity=0.00-1.00 show=Nothing clear");
    // Store the count of Coilin puncta
    coilinCounts[i] = nResults;
}


// Open the WDR79 image
open(dir + analyzeme + location + CH2 + ".tif");
rename(CH2);

// Convert RGB to 16-bit
run("16-bit");

// Substract background
run("Subtract Background...", "rolling=50");

// Threshold the WDR79 image
setAutoThreshold("RenyiEntropy dark no-reset");
run("Convert to Mask");
run("Fill Holes");

// Array to store WDR79 counts
wdr79Counts = newArray(initialROICount);

// For each initial ROI, select it and analyze the WDR79 puncta within
for (i = 0; i < initialROICount; i++) {
    roiManager("Select", i);
    // Count the number of WDR79 puncta within the ROI
    run("Analyze Particles...", "size=0.0005-0.1 circularity=0.00-1.00 show=Nothing clear");
    // Store the count of WDR79 puncta
    wdr79Counts[i] = nResults;
}

// Clear any existing results
run("Clear Results");

// Populate the Results table with the data
for (i = 0; i < initialROICount; i++) {
    setResult("Nucleus", i, i + 1);
    setResult("Nucleus Size", i, nucleusSizes[i]);
    setResult("Coilin Count", i, coilinCounts[i]);
    setResult("WDR79 Count", i, wdr79Counts[i]);
    updateResults();
}

// Save the Results table
saveAs("Results", dir + analyzeme + "/NucleusCoilinWDR79Counts_Macro-C.csv");

run("Fresh Start"); // this removes all images and saved data


analyzeme = slide_MS023

run("Fresh Start"); // this removes all images and saved data
// https://forum.image.sc/t/fresh-start-macro-command-in-imagej-fiji/43102/7
// run("Fresh Start", "images results rois"); // to note remove images, results, or rois

// Open the DAPI image
open(dir + analyzeme + location + CH1 + ".tif");
rename(CH1);
rename("DAPI");

// Convert RGB to 16-bit
run("16-bit");

// Threshold the DAPI image
setAutoThreshold("RenyiEntropy dark no-reset");
run("Convert to Mask");
run("Watershed");
run("Fill Holes");

// Analyze particles to get the ROIs of the nuclei and measure their size
run("Set Measurements...", "area redirect=None decimal=3");
run("Analyze Particles...", "size=0.1-6 circularity=0.00-1.00 show=Outlines display exclude add");

// Store the initial count of ROIs and nucleus sizes
initialROICount = roiManager("count");
nucleusSizes = newArray(initialROICount);
for (j = 0; j < initialROICount; j++) {
    nucleusSizes[j] = getResult("Area", j);
}

// Clear the results table after storing nucleus sizes
run("Clear Results");

// Open the Coilin image
open(dir + analyzeme + location + CH4 + ".tif");
rename(CH4);

// Convert RGB to 16-bit
run("16-bit");
// Threshold the Coilin image
setAutoThreshold("RenyiEntropy dark no-reset"); // RenyiEntropy captured some of the diffuse areas but not all; Max Entropy seems to be better at diffuse; Intermodes is only puncta; minimum is too few puncta missing some
run("Convert to Mask");
run("Fill Holes");

// Array to store Coilin counts
coilinCounts = newArray(initialROICount);

// For each initial ROI, select it and analyze the Coilin puncta within
for (i = 0; i < initialROICount; i++) {
    roiManager("Select", i);
    // Count the number of Coilin puncta within the ROI
    run("Analyze Particles...", "size=0.0005-0.1 circularity=0.00-1.00 show=Nothing clear");
    // Store the count of Coilin puncta
    coilinCounts[i] = nResults;
}


// Open the WDR79 image
open(dir + analyzeme + location + CH2 + ".tif");
rename(CH2);

// Convert RGB to 16-bit
run("16-bit");

// Substract background
run("Subtract Background...", "rolling=50");

// Threshold the WDR79 image
setAutoThreshold("RenyiEntropy dark no-reset");
run("Convert to Mask");
run("Fill Holes");

// Array to store WDR79 counts
wdr79Counts = newArray(initialROICount);

// For each initial ROI, select it and analyze the WDR79 puncta within
for (i = 0; i < initialROICount; i++) {
    roiManager("Select", i);
    // Count the number of WDR79 puncta within the ROI
    run("Analyze Particles...", "size=0.0005-0.1 circularity=0.00-1.00 show=Nothing clear");
    // Store the count of WDR79 puncta
    wdr79Counts[i] = nResults;
}

// Clear any existing results
run("Clear Results");

// Populate the Results table with the data
for (i = 0; i < initialROICount; i++) {
    setResult("Nucleus", i, i + 1);
    setResult("Nucleus Size", i, nucleusSizes[i]);
    setResult("Coilin Count", i, coilinCounts[i]);
    setResult("WDR79 Count", i, wdr79Counts[i]);
    updateResults();
}

// Save the Results table
saveAs("Results", dir + analyzeme + "/NucleusCoilinWDR79Counts_Macro-C.csv");

run("Fresh Start"); // this removes all images and saved data



analyzeme = slide_GM

run("Fresh Start"); // this removes all images and saved data
// https://forum.image.sc/t/fresh-start-macro-command-in-imagej-fiji/43102/7
// run("Fresh Start", "images results rois"); // to note remove images, results, or rois

// Open the DAPI image
open(dir + analyzeme + location + CH1 + ".tif");
rename(CH1);
rename("DAPI");

// Convert RGB to 16-bit
run("16-bit");

// Threshold the DAPI image
setAutoThreshold("RenyiEntropy dark no-reset");
run("Convert to Mask");
run("Watershed");
run("Fill Holes");

// Analyze particles to get the ROIs of the nuclei and measure their size
run("Set Measurements...", "area redirect=None decimal=3");
run("Analyze Particles...", "size=0.1-6 circularity=0.00-1.00 show=Outlines display exclude add");

// Store the initial count of ROIs and nucleus sizes
initialROICount = roiManager("count");
nucleusSizes = newArray(initialROICount);
for (j = 0; j < initialROICount; j++) {
    nucleusSizes[j] = getResult("Area", j);
}

// Clear the results table after storing nucleus sizes
run("Clear Results");

// Open the Coilin image
open(dir + analyzeme + location + CH4 + ".tif");
rename(CH4);

// Convert RGB to 16-bit
run("16-bit");
// Threshold the Coilin image
setAutoThreshold("RenyiEntropy dark no-reset"); // RenyiEntropy captured some of the diffuse areas but not all; Max Entropy seems to be better at diffuse; Intermodes is only puncta; minimum is too few puncta missing some
run("Convert to Mask");
run("Fill Holes");

// Array to store Coilin counts
coilinCounts = newArray(initialROICount);

// For each initial ROI, select it and analyze the Coilin puncta within
for (i = 0; i < initialROICount; i++) {
    roiManager("Select", i);
    // Count the number of Coilin puncta within the ROI
    run("Analyze Particles...", "size=0.0005-0.1 circularity=0.00-1.00 show=Nothing clear");
    // Store the count of Coilin puncta
    coilinCounts[i] = nResults;
}


// Open the WDR79 image
open(dir + analyzeme + location + CH2 + ".tif");
rename(CH2);

// Convert RGB to 16-bit
run("16-bit");

// Substract background
run("Subtract Background...", "rolling=50");

// Threshold the WDR79 image
setAutoThreshold("RenyiEntropy dark no-reset");
run("Convert to Mask");
run("Fill Holes");

// Array to store WDR79 counts
wdr79Counts = newArray(initialROICount);

// For each initial ROI, select it and analyze the WDR79 puncta within
for (i = 0; i < initialROICount; i++) {
    roiManager("Select", i);
    // Count the number of WDR79 puncta within the ROI
    run("Analyze Particles...", "size=0.0005-0.1 circularity=0.00-1.00 show=Nothing clear");
    // Store the count of WDR79 puncta
    wdr79Counts[i] = nResults;
}

// Clear any existing results
run("Clear Results");

// Populate the Results table with the data
for (i = 0; i < initialROICount; i++) {
    setResult("Nucleus", i, i + 1);
    setResult("Nucleus Size", i, nucleusSizes[i]);
    setResult("Coilin Count", i, coilinCounts[i]);
    setResult("WDR79 Count", i, wdr79Counts[i]);
    updateResults();
}

// Save the Results table
saveAs("Results", dir + analyzeme + "/NucleusCoilinWDR79Counts_Macro-C.csv");

run("Fresh Start"); // this removes all images and saved data

