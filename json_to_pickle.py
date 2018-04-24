#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
This script reads json files from a folder and save them
as a pickle dictionary.

@author: Domingo Salazar
"""

import json
import pickle

def save_obj(obj, name):
    with open('obj/'+ name + '.pkl', 'wb') as f:
        pickle.dump(obj, f, pickle.HIGHEST_PROTOCOL)

# Path to the json files
filename = 'json_files/drug-event-2018-30.json'

# Loading and converting the drug event files from json to a dictionary
json_file = open(filename, 'rt')
drug_event = json.load(json_file)

# Saving dictionary as a pickle object
save_obj(drug_event, 'drug_event_2018_30')