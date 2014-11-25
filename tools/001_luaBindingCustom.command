
BASE_DIR_FOR_SCRIPT_SELF=$(cd "$(dirname "$0")"; pwd)
cd ${BASE_DIR_FOR_SCRIPT_SELF}/../BeiBei2DXLua/frameworks/cocos2d-x/tools/tolua 
python cx_common_genbindings.py


