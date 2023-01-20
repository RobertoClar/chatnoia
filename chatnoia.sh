#!/bin/bash

#Checa as dependências e instala
deps_check(){
deps=(
xclip
chat_downloader
yt-dlp
pip3
)
for dep in "${deps[@]}"
do
if command -v "$dep" >/dev/null 2>&1 ; then
echo "$dep encontrado"
else
echo "$dep não encontrado"
sudo apt-get install -y "$dep"
fi
done

#Pip
pydeps=(
pandas
numpy
openpyxl
)
for pyd in "${pydeps[@]}"
do
if pip3 show "$pyd" &> /dev/null; then
echo "$pyd encontrado"
else
echo "$pyd não encontrado"
pip3 install "$pyd"
fi
done
}

#Entra na pasta de chats
pasta="$( dirname -- "$0"; )"
cd "$pasta" || return

#Pega a área de transferência
url=$(xclip -selection c -o)

#Checa se é uma url válida
if [[ "$url" != *"you"* ]];
then
echo "1 Sua área de transferência não contém url do Youtube válida :("
exit
fi
echo "Url é do Youtube"

if [[ "$url" != *"="* ]];
then
echo "2 Sua área de transferência não contém url do Youtube válida :("
exit
fi
echo "Url válida"

#Preparação
canal=$(yt-dlp "$url" -o '%(uploader)s' --get-filename | iconv -t 'ascii//TRANSLIT')

#Pasta do canal
if [ -d "$canal" ]; then
cd "${canal}" || return
echo "Pasta $canal já existe"
else
mkdir -m 777 "${canal}"
cd "${canal}" || return
echo "Começando."
fi

#Cria pasta com a data atual
chatdata=$(date +%Y%m%d)

#Pasta da data
if [ -d "$chatdata" ]; then
cd "${chatdata}" || return
echo "Pasta $chatdata já existe"
else
mkdir -m 777 "${chatdata}"
cd "${chatdata}" || return
echo "Começando.."
fi

#Variáveis
titulo=$(yt-dlp --get-title "$url" | iconv -t 'ascii//TRANSLIT')

ide=$(yt-dlp "$url" -o '%(id)s' --get-filename)

data=$(yt-dlp "$url" -o '%(upload_date)s' --get-filename)

titulo="$data"_"$canal"_"$titulo"_"$ide"

#Checa se já existe
if [ -f "$titulo.txt" ]; then
echo "$titulo.txt já existe"
exit
else 
echo "Começando..."
fi

#Roda o programa principal
#Será gerado também um txt simplificado com a saída do terminal
chat_downloader "$url" --message_groups "messages superchat" --output chat.json 2>&1 | tee "$titulo".txt

#Verifica se há o replay ou apaga
if grep -q "Video does not have a chat replay" "$titulo.txt"; then
rm -rf "$titulo.txt"
cd "$PWD/$canal" || return
#rm -rf "$chatdata"
echo "Mas o vídeo não tem chat :("
cd "$PWD" || return
exit
fi

limpaemotes(){
#Limpa emotes
arquivo="chat.json"
#verifica se o arquivo existe
if [[ -f "$arquivo" ]]; then
while
read -r A B;
do
#Substitui emocodes pelo emotes
#Alguns foram substituídos por 💩 pois não tive paciência de procurar
sed -i "s/${A}/${B}/g" "$titulo".txt;
sed -i "s/${A}/${B}/g" chat.json;
done<<EOF
:1st_place_medal: 🥇
:alien: 👽
:ambulance: 🚑
:angry_face: 😠
:astonished_face: 😲
:baby: 👶
:baby_bottle: 🍼
:backhand_index_pointing_left: 👈
:backhand_index_pointing_right: 👉
:balance_scale: ⚖
:balloon: 🎈
:battery: 🔋
:beaming_face_with_smiling_eyes: 😁
:beer_mug: 🍺
:bell: 🔔
:beverage_box: 🧃
:bison: 🐂
:blue_heart: 💙
:body-blue-raised-arms: 🙋‍♂️ 
:bomb: 💣
:bouquet: 💐
:boxing_glove: 🥊
:boy: 👦
:brain: 🧠
:buffering: ⌛
:bullseye: 🎯
:bus: 🚌
:call_me_hand: 🤙
:camera: 📷
:camera_with_flash: 📸
:castle: 🏰
:cat_with_tears_of_joy: 😹
:chicken: 🐔
:cigarette: 🚬
:clap: 👏
:clapping_hands: 👏
:clinking_beer_mugs: 🍻
:clipboard: 📋
:clown_face: 🤡
:coffin: ⚰
:cold_face: 🥶
:collision: 💥
:confused_face: 😕
:construction: 🚧
:cookie: 🍪
:cow: 🐂
:cow: 🐄
:crab: 🦀
:crown: 👑
:dashing_away: 💨
:deciduous_tree: 🌳
:disappointed_face: 😞
:disguised_face: 🥸
:dog: 🐕
:dog2: ✖️
:dog2: 🐕
:dolphin: 🐬
:dothefive: 5️⃣
:double_exclamation_mark: ‼
:drooling_face: 🤤
:earth_africa: 🌍
:earth_americas: 🌎
:eggplant: 🍆
:elbowcough: 💪
:exclamation_question_mark: ⁉
:exploding_head: 🤯
:expressionless_face: 😑
:eye: 👁
:eyes: 👀
:eyes-pink-heart-shape: 😍
:face_blowing_a_kiss: 😘
:face-blue-smiling: 😍
:face-fuchsia-poop-shape: 💩
:face-fuchsia-wide-eyes: 💩
:face-orange-raised-eyebrow: 💩
:face-purple-crying: 😢
:face-purple-smiling-fangs: 💩
:face-purple-smiling-tears: 💩
:face-purple-wide-eyes: 💩
:face_savoring_food: 😋
:face_screaming_in_fear: 😱
:face-turquoise-covering-eyes: 💩
:face-turquoise-drinking-coffee: 💩
:face_vomiting: 🤮
:face_with_hand_over_mouth: 🤭
:face_with_head_bandage: 🤕
:face_with_monocle: 🧐
:face_with_open_mouth: 😮
:face_without_mouth: 😶
:face_with_raised_eyebrow: 🤨
:face_with_rolling_eyes: 🙄
:face_with_spiral_eyes: 😵‍💫
:face_with_tears_of_joy: 😂
:face_with_tongue: 😛
:fire: 🔥
:fish: 🐟
:flexed_biceps: 💪
:flushed_face: 😳
:folded_hands: 🙏
:fried_shrimp: 💩
:frog: 🐸
:full_moon_face: 🌝
:garlic: 🧄
:gem_stone: 💎
:ghost: 👻
:glass_of_milk: 🥛
:globe_showing_americas: 🌎
:globe_showing_asia_australia: 🌏
:globe_showing_europe_africa: 🌍
:globe_with_meridians: 🌐
:goat: 🐐
:goat-turquoise-white-horns: 💩
:goblin: 💩
:goodvibes: ✌️
:grimacing_face: 😬
:grinning_face: 😀
:grinning_face_with_big_eyes: 😃
:grinning_face_with_smiling_eyes: ✖️
:grinning_face_with_smiling_eyes: 😁
:grinning_face_with_sweat: 😅
:grinning_squinting_face: 😆
:hand-orange-covering-eyes: 💩
:hand-pink-waving: 💩
:hand-purple-blue-peace: 💩
:handshake: 🤝
:hand_with_fingers_splayed: 🖐
:heart_on_fire: ❤‍🔥
:herb: 🌿
:hibiscus: 🌺
:horse: 🐎
:hourglass_done: 💩
:hourglass_not_done: 💩
:house_with_garden: 🏡
:hugging_face: 🤗
:hushed_face: 😯
:hydrate: 💩
:kiss: 💋
:kissing_face: 💩
:kissing_face_with_closed_eyes: 😚
:knocked_out_face: 😵
:left_facing_fist: 🤛
:leopard: 🐆
:lollipop: 🍭
:loudly_crying_face: 😭
:loudspeaker: 📢
:love_you_gesture: 💩
:lying_face: 🤥
:magnifying_glass_tilted_right: 🔎
:man_facepalming: 🤦‍♂
:man_shrugging: 🤷‍♂
:man_swimming: 🏊‍♂
:man_zombie: 🧟‍♂
:microphone: 🎤
:middle_finger: 🖕
:military_medal: 💩
:money_bag: 💩
:money_mouth_face: 🤑
:money_with_wings: 💸
:mouth: 👄
:movie_camera: 🎥
:multiply: ✖️
:musical_note: 🎵
:musical_notes: 🎶
:musical_score: 🎼
:national_park: 🏞
:nerd_face: 🤓
:neutral_face: 😐
:night_with_stars: 🌃
:office_building: 🏢
:ogre: 💩
:ok_hand: 💩
:oncoming_fist: 👊
:oops: 🤭
:oops: ✖️
:open_hands: 👐
:ox: 🐂
:partying_face: ✖️
:partying_face: 💩
:pear: 🍐
:pensive_face: 😔
:person_facepalming: 🤦
:person_fencing: 🤺
:person_gesturing_ok: 🙆
:person_raising_hand: 🙋
:person_running: 🏃
:person_shrugging: 🤷
:person_swimming: 🏊
:person_taking_bath: 🛀
:petri_dish: 🧫
:pig: 🐷
:pile_of_poo: 💩
:pill: 💊
:pizza: 🍕
:planet-orange-purple-ring: 💩
:point_left: 👈
:point_right: 👉
:poodle: 🐩
:popcorn: 🍿
:potato: 🥔
:pouting_face: 😡
:prohibited: 🚫
:purple_heart: 💜
:racehorse: 🐎
:radio: 📻
:raised_fist: ✊
:raised_hand: ✋
:raising_hands: 🙌
:recycling_symbol: 💩
:red_exclamation_mark: ❗
:red_heart: ❤
:red_question_mark: ❓
:relieved_face: 😌
:revolving_hearts: 💞
:right_facing_fist: 🤜
:robot: 🤖
:rolling_on_the_floor_laughing: 🤣
:rose: 🌹
:sad_but_relieved_face: 😥
:sailboat: ⛵
:scissors: ✂
:scroll: 📜
:see_no_evil_monkey: 🙈
:selfie: 🤳
:sheaf_of_rice: 🌾
:shushing_face: 🤫
:sign_of_the_horns: 🤘
:skull: 💀
:sleeping_face: 😴
:sleepy_face: 😪
:slightly_frowning_face: 🙁
:slightly_smiling_face: 🙂
:small_airplane: 🛩
:smiling_cat_with_heart_eyes: 😻
:smiling_face: 😍
:smiling_face_with_halo: 😇
:smiling_face_with_heart_eyes: 😍
:smiling_face_with_hearts: 😍
:smiling_face_with_horns: 😈
:smiling_face_with_smiling_eyes: 😊
:smiling_face_with_sunglasses: 😎
:smiling_face_with_tear: 💩
:smirking_face: 😏
:snake: 🐍
:sneezing_face: 🤧
:soccer_ball: ⚽
:socialdist: ✖️
:softball: ⚽
:sparkles: ✨
:sparkling_heart: 💖
:speaking_head: 🗣
:speak_no_evil_monkey: 🙊
:sports_medal: 💩
:spouting_whale: 🐳
:squinting_face_with_tongue: 😝
:star_struck: 🤩
:sun: ☀
:sweat_droplets: 💦
:syringe: 💉
:tangerine: 🍊
:test_tube: 🧪
:thermometer: 🌡
:thinking_face: 🤔
:thought_balloon: 💭
:thumbs_up: 👍
:toilet: 🚽
:triangular_ruler: 📐
:trident_emblem: 🔱
:trophy: 💩
:tulip: 🌷
:turtle: 🐢
:two_hearts: 💕
:unamused_face: 😒
:unicorn: 💩
:upside_down_face: 🙃
:v: ✌
:victory_hand: ✌
:warning: ⚠
:washhands: 💩
:water_pistol: 🔫
:water_wave: 🌊
:waving_hand: 👋
:weary_cat: 🙀
:weary_face: 😩
:white_exclamation_mark: ❕
:winking_face: 😉
:winking_face_with_tongue: 😜
:woman_cartwheeling: 🤸‍♀️
:woman_dancing: 💃
:woman_genie: 💩
:woman_in_lotus_position: 🧘‍♀
:woman_raising_hand: 🙋‍♀
:womans_sandal: 👡
:woozy_face: 💩
:yougotthis: 💩
:yt: ▶️
:zany_face: 🤪
:zzz: 😴
EOF
fi
}
#Chama a função limpaemotes
limpaemotes

#Template e miniatura
wget -qO chatnoia.xlsx https://github.com/RobertoClar/chatnoia/raw/main/chatnoia.xlsx
wget -qO "$ide".jpg https://img.youtube.com/vi/"$ide"/maxresdefault.jpg

#Processa o json para dataframe e excel usando template
python3 - << EOF
import json
with open("chat.json") as f:
    data = json.load (f)
import pandas as pd
norma = pd.json_normalize(data, max_level=1)
limpa = norma[['author.id', 'author.name', 'message', 'timestamp', 'author.images']]
#limpa.to_excel('chat.xlsx', sheet_name='chat')
with pd.ExcelWriter("chatnoia.xlsx", engine="openpyxl", mode="a", if_sheet_exists="overlay") as writer:
      limpa.to_excel(writer, 'dadosbrutos', index=False)
EOF

#Renomeia arquivo final
mv chat.json "$titulo".json
mv chatnoia.xlsx "$titulo".xlsx

echo "Acabou"
