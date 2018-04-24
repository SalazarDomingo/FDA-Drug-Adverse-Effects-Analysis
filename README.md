# FDA-Drug-Adverse-Effects-Analysis
This is a quick data analysis about differences in drug adverse effects prevalence across countries.

The motivation, work flow and results of this analysis is discussed in the powerpoint presentation called 
"FDA_DrugAdverseEffectsAnalysis.pptx". 

The data files used in this analysis were downloaded from the web page 
https://open.fda.gov/downloads/
of the OpenFDA project.  These files came in the json format and were stored in the json_files/ sub-folder.

The python files were used to process these json files into pickle dictionaries and then pick up the 
relevant fields from them to create and concatenate CSV files containing all this information.  The final
product is a file called "drug_adverse_effects.csv"

The file called "ExploratoryDataAnalysis.R" imports the above CSV file and extracts the most prevalent
drug adverse effects in 21 countries.  It then calculates frequencies and proportions and save them
into CSV files called "CountryEventsProportions" corresponding to sets of 11, 21, 28 & 48 adverse effects.

Finally the file called "CountryEventAnalysis.R" analyses this dataset and creates the figures contain
in the presentation.
