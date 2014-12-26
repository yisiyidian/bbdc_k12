
BASE_DIR_FOR_SCRIPT_SELF=$(cd "$(dirname "$0")"; pwd)
cd ${BASE_DIR_FOR_SCRIPT_SELF}/

RAW_CONFIGS=${BASE_DIR_FOR_SCRIPT_SELF}/../raw/cfg
RES_CFG=${BASE_DIR_FOR_SCRIPT_SELF}/../BeiBei2DXLua/res/cfg/

RAW_BOOKS=${BASE_DIR_FOR_SCRIPT_SELF}/../raw/book

TMP_DIR=${BASE_DIR_FOR_SCRIPT_SELF}/../raw/tmp
if [ ! -x ${TMP_DIR} ]; then
    mkdir ${TMP_DIR}
else
    rm -rf ${TMP_DIR}
    mkdir ${TMP_DIR}
fi

TMP_XXTEA_DIR=${BASE_DIR_FOR_SCRIPT_SELF}/../raw/tmp_xxtea
if [ ! -x ${TMP_XXTEA_DIR} ]; then
    mkdir ${TMP_XXTEA_DIR}
else
    rm -rf ${TMP_XXTEA_DIR}
    mkdir ${TMP_XXTEA_DIR}
fi

# python exportCfg_allwords.py ${RAW_CONFIGS}/allword.json ${TMP_DIR}/allwords.json
python exportCfg_newwords.py ${RAW_CONFIGS}/newword.json ${TMP_DIR}/newwords.json

python exportLevels.py  ${RAW_CONFIGS}/Level.json ${TMP_DIR}/ 'ncee'
python exportLevels.py  ${RAW_CONFIGS}/Level.json ${TMP_DIR}/ 'cet4'
python exportLevels.py  ${RAW_CONFIGS}/Level.json ${TMP_DIR}/ 'cet6'
python exportLevels.py  ${RAW_CONFIGS}/Level.json ${TMP_DIR}/ 'ielts'
python exportLevels.py  ${RAW_CONFIGS}/Level.json ${TMP_DIR}/ 'toefl'

python exportTextCodes.py ${RAW_CONFIGS}/text.json ${BASE_DIR_FOR_SCRIPT_SELF}/../BeiBei2DXLua/src/common/text.lua

# cp ${RAW_BOOKS}/*.book ${TMP_DIR}/ too slow for lua xxtea
cp ${RAW_CONFIGS}/books.json ${TMP_DIR}/
cp ${RAW_CONFIGS}/chapters.json ${TMP_DIR}/
# cp ${RAW_CONFIGS}/dailyCheckIn.json ${TMP_DIR}/
# cp ${RAW_CONFIGS}/energy.json ${TMP_DIR}/
# cp ${RAW_CONFIGS}/items.json ${TMP_DIR}/
cp ${RAW_CONFIGS}/review_boss.json ${TMP_DIR}/
# cp ${RAW_CONFIGS}/starRule.json ${TMP_DIR}/
cp ${RAW_CONFIGS}/text.json ${TMP_DIR}/

cd ${BASE_DIR_FOR_SCRIPT_SELF}/pack_files
./pack_files.sh -i ${TMP_DIR} -o ${TMP_XXTEA_DIR} -ek fuck2dxLua -es fuckXXTEA

cp -f ${TMP_XXTEA_DIR}/* ${RES_CFG}
cp ${RAW_BOOKS}/*.book ${RES_CFG}/
