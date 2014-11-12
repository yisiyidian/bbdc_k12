baseDirForScriptSelf=$(cd "$(dirname "$0")"; pwd)
cd ${baseDirForScriptSelf}/

python exportCfg_allwords.py ${baseDirForScriptSelf}/../raw/cfg/allword.json ${baseDirForScriptSelf}/../BeiBei2DXLua/res/cfg/allwords

python exportLevels.py  ${baseDirForScriptSelf}/../raw/cfg/Level.json ${baseDirForScriptSelf}/../BeiBei2DXLua/res/cfg/ 'ncee'
python exportLevels.py  ${baseDirForScriptSelf}/../raw/cfg/Level.json ${baseDirForScriptSelf}/../BeiBei2DXLua/res/cfg/ 'cet4'
python exportLevels.py  ${baseDirForScriptSelf}/../raw/cfg/Level.json ${baseDirForScriptSelf}/../BeiBei2DXLua/res/cfg/ 'cet6'
python exportLevels.py  ${baseDirForScriptSelf}/../raw/cfg/Level.json ${baseDirForScriptSelf}/../BeiBei2DXLua/res/cfg/ 'ielts'
python exportLevels.py  ${baseDirForScriptSelf}/../raw/cfg/Level.json ${baseDirForScriptSelf}/../BeiBei2DXLua/res/cfg/ 'toefl'

python exportTextCodes.py  ${baseDirForScriptSelf}/../raw/cfg/text.json ${baseDirForScriptSelf}/../BeiBei2DXLua/src/common/text.lua

#books.json
#chapters.json
#dailyCheckIn.json
#energy.json
#items.json
#review_boss.json
#starRule.json
#text.json

#python encodeJson2Bin.py ${baseDirForScriptSelf}/../raw/cfg/ ${baseDirForScriptSelf}/../BeiBei2DXLua/res/cfg/