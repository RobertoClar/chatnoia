#!/usr/bin/env python
# coding: utf-8
#2022_12_24_09_32_39


import json
with open("chat.json") as f:
    data = json.load (f)
import pandas as pd
norma = pd.json_normalize(data, max_level=1)
limpa = norma[['author.id', 'author.name', 'message', 'timestamp', 'author.images']]
#limpa.to_excel('chat.xlsx', sheet_name='chat')
with pd.ExcelWriter("chatnoia.xlsx", engine="openpyxl", mode="a", if_sheet_exists="overlay") as writer:
      limpa.to_excel(writer, 'dadosbrutos', index=False)




