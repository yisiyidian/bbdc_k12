baseDirForScriptSelf=$(cd "$(dirname "$0")"; pwd)
cd ${baseDirForScriptSelf}/

python exportCfg_allwords.py ${baseDirForScriptSelf}/../raw/cfg/allword.json ${baseDirForScriptSelf}/../BeiBei2DXLua/res/cfg/allwords
