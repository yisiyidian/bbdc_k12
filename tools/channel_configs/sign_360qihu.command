baseDirForScriptSelf=$(cd "$(dirname "$0")"; pwd)

jarsigner -verbose -sigalg SHA1withRSA \
    -digestalg SHA1 \
    -keystore $baseDirForScriptSelf/../beibei \
    -storepass Danci_beibei_ \
    $baseDirForScriptSelf/../../tmp_apk/android_360qihu/com.beibei.wordmaster.k12.qihu.encrypted.apk  beibei
    