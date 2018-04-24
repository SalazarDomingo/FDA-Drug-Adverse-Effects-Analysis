# -*- coding: utf-8 -*-
"""
This script concatenates all CSV files found in csv_files/ to a file
called drug_adverse_effects.csv

@author: Domingo Salazar
"""

import pandas as pd
import os
import glob

with open('drug_adverse_effects.csv', 'rt') as f:
    drug_event = pd.read_csv(f)

print('\nReading the CSV files and concatenating them ...')
#path = 'csv_files/'
path = 'csv_files/'
for filename in glob.glob(os.path.join(path, '*.csv')):
    print('   Concatenating:', filename)
    with open(filename, 'rt') as f:
        df = pd.read_csv(f)
    if 'Index' in df.columns:
        df = df.drop(['Index'], axis = 'columns')
    drug_event = pd.concat([drug_event, df])

print('\n    Saving concatenated CSV file ...')
drug_event.index.name = 'Index'
csv_name = path + 'drug_adverse_effects.csv'
drug_event.to_csv(csv_name)
print('    Saved CSV file:', csv_name)
print('\nJob done!\n')