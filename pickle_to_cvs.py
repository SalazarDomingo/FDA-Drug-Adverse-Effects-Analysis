# -*- coding: utf-8 -*-
"""
This script reads a given json file and save it as a pickle
dictionary in the folder 'obj/'.

@author: Domingo Salazar
"""

import pickle
import numpy as np
from pandas import DataFrame
from itertools import chain

def load_obj(name):
    with open('obj/' + name + '.pkl', 'rb') as f:
        return pickle.load(f)

# Loading the pickle dictionary
drug_event = load_obj('drug_event_2018_30')

# Slicing the dictionary and selecting items from it
#res = drug_event['results'][0:2]

#%%
# Creating lists with the single-field-per-report variables [0:150000]
res = drug_event['results']
ReportID    = [dic['safetyreportid'] for dic in res]
Date        = [dic['receivedate'] for dic in res]
Country     = [dic['occurcountry'] if 'occurcountry' in dic else 'NA'
               for dic in res]
Patient     = [dic['patient'] for dic in res]
Age         = [dic['patientonsetage'] if 'patientonsetage' in dic else 'NA'
               for dic in Patient]
Sex         = [dic['patientsex'] if 'patientsex' in dic else 'NA'
               for dic in Patient]

# Creating lists with the multiple-field-per-report variables
Event       = [[r['reactionmeddrapt']
                for r in dic['reaction']] for dic in Patient] 
Outcome     = [[r['reactionoutcome'] if 'reactionoutcome' in r else 'NA'
                for r in dic['reaction']] for dic in Patient]
Route       = [[r['drugadministrationroute']
                if 'drugadministrationroute' in r else 'NA'
                for r in dic['drug']] for dic in Patient]
Substance   = [[r['activesubstance']['activesubstancename']
                if 'activesubstance' in r else 'NA'
                for r in dic['drug']] for dic in Patient]
Indication  = [[r['drugindication'] if 'drugindication' in r else 'NA'
                for r in dic['drug']] for dic in Patient]      

## Creating a dictionary with the data
#Fields = {'ReportID': ReportID, 'Date': Date, 'Country': Country,
#          'Age': Age, 'Sex': Sex, 'Event': Event, 'Outcome': Outcome,
#          'Route': Route, 'Substance': Substance, 'Indication': Indication}
#
#print('Dicitionary\n', Fields)

# Computing and checking the length of the various lists
lens1  = list(map(len, Event))
lens1a = list(map(len, Outcome))
lens2  = list(map(len, Route))
lens2a = list(map(len, Substance))
lens2b = list(map(len, Indication))
#print('lens:\n', lens1, lens1a, lens2, lens2a, lens2b)

# Replicating the lists appropriately within the 
# multiple-field-per-report lists
lens        = [n1*n2 for n1, n2 in zip(lens1, lens2)]
Events      = [l*n for l, n in zip(Event, lens2)]
Outcomes    = [l*n for l, n in zip(Outcome, lens2)]
Routes      = [l*n for l, n in zip(Route, lens1)]
Substances  = [l*n for l, n in zip(Substance, lens1)]
Indications = [l*n for l, n in zip(Indication, lens1)]

## Checking the final length of two of the multiple-field-per-report lists
#print('\nTotal lens:\n', len(ReportID), list(map(len, Outcomes)),
#      list(map(len, Substances)))

#%% Creating a dataframe and saving it as a CSV file.
df = DataFrame(
        {'ReportID':    np.repeat(ReportID, lens),
         'Date':        np.repeat(Date, lens),
         'Country':     np.repeat(Country, lens),
         'Age':         np.repeat(Age, lens),
         'Sex':         np.repeat(Sex, lens),
         'Indication':  list(chain.from_iterable(Indications)), 
         'Event':       list(chain.from_iterable(Events)),
         'Outcome':     list(chain.from_iterable(Outcomes)),
         'Substance':   list(chain.from_iterable(Substances)),
         'Route':       list(chain.from_iterable(Routes))
         }, columns = ["ReportID", "Date", "Country", "Sex", "Age",
                       "Indication", "Event", "Outcome", "Substance",
                       "Route"]
        ).reset_index(drop=True)

df.index.name = "Index"

# Re-coding Sex = 0 & "PRODUCT USED FOR UNKNOWN INDICATION" to NA
df["Sex"].replace("0", "NA", inplace = True)
df["Indication"].replace("PRODUCT USED FOR UNKNOWN INDICATION", "NA", 
                         inplace = True)

df.to_csv('csv_files/drug_adverse_effects_2018_30.csv')

