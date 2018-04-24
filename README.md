# FDA-Drug-Adverse-Effects-Analysis
This is a quick data analysis about differences in drug adverse effects prevalence across countries.

The motivation, work flow and results of this analysis are discussed in the powerpoint presentation called 
"FDA_DrugAdverseEffectsAnalysis.pptx". 

The data files used in this analysis were downloaded from the web page 
https://open.fda.gov/downloads/
of the OpenFDA project.  These files came in the json format and were stored in the json_files/ sub-folder.
But they are quite large and are not included in this repository.

The python files transformed these json files into pickle dictionaries (also very large and stored in a 
folder called obj/, not included in this repository) and then picked up the relevant fields from them to
created and concatenated a number of CSV files.  Their final product is a very large CVS file called 
"drug_adverse_effects.csv", which is not included in this repository either due to its size.

The file called "ExploratoryDataAnalysis.R" imports the above CSV file and extracts the most prevalent
drug adverse effects in 21 countries.  It then calculates frequencies and proportions and save them
into CSV files called "CountryEventsProportions" corresponding to sets of 11, 21, 28 & 48 adverse effects.
These files are much smaller and are included in this repository.

Finally the file called "CountryEventAnalysis.R" analyses this dataset and creates the figures contained
in the presentation.
