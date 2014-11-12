from xxtea import decrypt, encrypt

def encryptStr(srcStr):
    key = 'mycrush42mycrush42'

    enc = encrypt(srcStr, key)
    dec = decrypt(enc, key)

    # print len(enc), enc
    # print len(dec), dec
    assert srcStr == dec

    return enc
