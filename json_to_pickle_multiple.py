#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
This script reads json files from the 'path' folder and save them
as a pickle dictionary in the folder 'obj/'.

@author: Domingo Salazar
"""

import pickle
import os
import glob
import json

def save_obj(obj, name):
    with open('obj/'+ name + '.pkl', 'wb') as f:
        pickle.dump(obj, f, pickle.HIGHEST_PROTOCOL)

# Path to the json files
path = 'json_files/'
print('\nTransforming all json files in', path)
print('to pickle dictionaires stored in obj/')

# Loading and converting the drug event files from json to a dictionary
for filename in glob.glob(os.path.join(path, '*.json')):
    print('\n   Processing file: ', filename)
    with open(filename, 'rt') as f:
        drug_event = json.load(f)
    obj_name = os.path.basename(filename).split('.')[0]
    save_obj(drug_event, obj_name)
    print('   Saved as a pickle dictionary: obj/', obj_name, '.pkl')

print('\nJob done!')







    
    