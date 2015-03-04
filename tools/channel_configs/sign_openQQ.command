baseDirForScriptSelf=$(cd "$(dirname "$0")"; pwd)

jarsigner -verbose -sigalg SHA1withRSA \
    -digestalg SHA1 \
    -keystore $baseDirForScriptSelf/../beibei \
    -storepass Danci_beibei_ \
    $baseDirForScriptSelf/../../tmp_apk/android_openQQ/com.beibei.wordmaster.tencentmyapp.encrypted.apk  beibei
    