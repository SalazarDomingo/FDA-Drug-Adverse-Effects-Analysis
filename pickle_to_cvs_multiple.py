# -*- coding: utf-8 -*-
"""
This script reads a given json file and save it as a pickle
dictionary in the folder 'obj/'.

@author: Domingo Salazar
"""

import numpy as np
from pandas import DataFrame
from itertools import chain

import pickle
import os
import glob
import json

def create_df(res):
    '''
    It extracts the relevant information from the dictionary 'res',
    and builds a dataframe out of it.
    '''
    
    # Creating lists with the single-field-per-report variables
    ReportID = [dic['safetyreportid'] for dic in res]
    Date     = [dic['receivedate'] for dic in res]
    Country  = [dic['occurcountry'] if 'occurcountry' in dic else 'NA'
                for dic in res]
    Patient  = [dic['patient'] for dic in res]
    Age      = [dic['patientonsetage'] if 'patientonsetage' in dic else 'NA'
                for dic in Patient]
    Sex      = [dic['patientsex'] if 'patientsex' in dic else 'NA'
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

    # Replicating the lists appropriately within the 
    # multiple-field-per-report lists
    lens1       = list(map(len, Event))
    lens2       = list(map(len, Route))
    lens        = [n1*n2 for n1, n2 in zip(lens1, lens2)]
    Events      = [l*n for l, n in zip(Event, lens2)]
    Outcomes    = [l*n for l, n in zip(Outcome, lens2)]
    Routes      = [l*n for l, n in zip(Route, lens1)]
    Substances  = [l*n for l, n in zip(Substance, lens1)]
    Indications = [l*n for l, n in zip(Indication, lens1)]

    # Creating a dataframe and saving it as a CSV file.
    df = DataFrame({
            'ReportID':    np.repeat(ReportID, lens),
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
                          "Route"]).reset_index(drop=True)
    df.index.name = "Index"

    # Re-coding Sex = 0 & "PRODUCT USED FOR UNKNOWN INDICATION" to NA
    df["Sex"].replace("0", "NA", inplace = True)
    df["Indication"].replace("PRODUCT USED FOR UNKNOWN INDICATION", "NA", 
      inplace = True)
    
    return df

#%% Main body

print('\nReading the pickle dictionaries and producing CSV files ...')
path = 'obj/'
for filename in glob.glob(os.path.join(path, '*.pkl')):
    print('\n   Processing pickle dictionary:   ', filename)
    with open(filename, 'rb') as f:
        drug_event = pickle.load(f)
    res = drug_event['results']
    df = create_df(res)
    df_name = 'csv_files/' + os.path.basename(filename).split('.')[0] + '.csv'
    df.to_csv(df_name)
    print('   Saved as a CSV file:', df_name)

print('\nJob done!\n')




