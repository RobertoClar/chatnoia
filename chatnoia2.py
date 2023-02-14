#!/usr/bin/env python3
#
# 2023_02_14_14_46_06
#

import pandas as pd
import json
from flatten_json import flatten
import os

with open("chat.json") as f:
	chat = json.load (f)

plano = [flatten(d) for d in chat]
df1 = pd.DataFrame(plano)

limpa = df1.rename(columns={"author_id": "Autor", "author_images_0_url": "Foto", "author_name": "Nome", "message": "Mensagem", "timestamp": "Timestamp", "time_text": "Tempo"})
limpa = limpa[['Autor', 'Foto', 'Nome', 'Mensagem', 'Timestamp', 'Tempo']]

limpa.insert(0, 'Nome_da_live', os.environ["titulo"])
limpa.insert(0, 'Data_da_live', os.environ["data"])
limpa.insert(0, 'ID_da_live', os.environ["ide"])

nomedoarquivo = os.environ["ide"]+".csv"
limpa.to_csv(nomedoarquivo)

#my_df = pd.read_feather(nomedoarquivo)



