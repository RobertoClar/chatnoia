#!/bin/bash
#
# 2023_02_14_14_46_06
#

#Entra na pasta de chats
pasta="$( dirname -- "$0"; )"
cd "$pasta" || return
raiz="$PWD"
source limpaemotes.sh

#Pega a área de transferência
#url=$(xclip -selection c -o)
url=$1
export url

#Preparação
canal=$(youtube-dl "$url" -o '%(uploader)s' --get-filename | iconv -t 'ascii//TRANSLIT')
export canal

#Pasta do canal
if [ -d "$canal" ]; then
cd "${canal}" || return
echo "Pasta $canal já existe"
else
mkdir -m 777 "${canal}"
cd "${canal}" || return
echo "Começando."
fi

#Variáveis
titulo=$(youtube-dl --get-title "$url" | iconv -t 'ascii//TRANSLIT')
export titulo

ide=$(youtube-dl "$url" -o '%(id)s' --get-filename)
export ide

data=$(youtube-dl "$url" -o '%(upload_date)s' --get-filename)
export data

#Verifica se o título contém barras /
if [[ "$titulo" == *\/* ]] || [[ "$titulo" == *\\* ]]
then
titulo=$(echo $titulo | sed 's|/||g')
fi

titulocheio="$data"_"$ide"_"$canal"_"$titulo"
export titulocheio

#Checa se já existe
if [ -f "$titulocheio.txt" ]; then
echo "$titulocheio.txt já existe"
sleep 5
exit
else 
echo "Começando..."
fi

#Roda o programa principal
#Será gerado também um txt simplificado com a saída do terminal
chat_downloader "$url" --message_groups "messages superchat" --output chat.json 2>&1 | tee "$titulocheio".txt

#Verifica se há o replay ou apaga
if grep -q "Video does not have a chat replay" "$titulocheio.txt"; then
rm -rf "$titulocheio.txt"

cd "$pasta" || return
echo "Mas o vídeo não tem chat :("
cd "$pasta" || return
sleep 5
exit
fi

#Verifica se há o replay ou apaga
if grep -q "Live chat replay is not available for this video" "$titulocheio.txt"; then
rm -rf "$titulocheio.txt"
cd "$pasta" || return
#rm -rf "$chatdata"
echo "Mas o vídeo não tem chat :("
cd "$pasta" || return
sleep 5
exit
fi

#Template e miniatura
#wget -qO chat_youtube.xlsx https://github.com/RobertoClar/chatnoia/raw/main/chatnoia.xlsx
#wget -qO "$ide".jpg https://img.youtube.com/vi/"$ide"/maxresdefault.jpg

cd "$pasta"

#Chama a função limpaemotes
limpaemotes

python3 "$raiz"/chatnoia2.py

rm -rf chat.json

#Renomeia arquivo final
#mv chat.json "$titulocheio".json
#mv chat_youtube.xlsx "$canal".xlsx
#rm -rf "$titulocheio".json


echo "Acabou"

<<BUSCA

buscaum = df.query("Nome == 'NOME'")
print (busca)
buscadois = buscaum[buscaum["Mensagem"].str.contains("PALAVRA")]
buscadois.head()

BUSCA

echo "Acabou"
