baseDirForScriptSelf=$(cd "$(dirname "$0")"; pwd)
cd ${baseDirForScriptSelf}/

python exportCfg_allwords.py ${baseDirForScriptSelf}/../raw/cfg/allword.json ${baseDirForScriptSelf}/../BeiBei2DXLua/res/cfg/allwords
python exportLevels.py  ${baseDirForScriptSelf}/../raw/cfg/Level.json ${baseDirForScriptSelf}/../BeiBei2DXLua/res/cfg/ 'ncee'
python exportLevels.py  ${baseDirForScriptSelf}/../raw/cfg/Level.json ${baseDirForScriptSelf}/../BeiBei2DXLua/res/cfg/ 'cet4'
python exportLevels.py  ${baseDirForScriptSelf}/../raw/cfg/Level.json ${baseDirForScriptSelf}/../BeiBei2DXLua/res/cfg/ 'cet6'
python exportLevels.py  ${baseDirForScriptSelf}/../raw/cfg/Level.json ${baseDirForScriptSelf}/../BeiBei2DXLua/res/cfg/ 'ielts'
python exportLevels.py  ${baseDirForScriptSelf}/../raw/cfg/Level.json ${baseDirForScriptSelf}/../BeiBei2DXLua/res/cfg/ 'toefl'