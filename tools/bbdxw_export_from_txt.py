#coding=utf-8
import sys
import chardet

reload(sys)
sys.setdefaultencoding('utf8')

def exportWordFromTxt(txtPath):
    try:
        f = open(txtPath, 'r')
        result = ""
        while 1:
            line = f.readline()
            if line:
                items = line.split('\t')
                worditem = ''
                if len(items) == 8:
                    worditem = makeitem(items[0], items[1], items[2], items[3], items[4], items[5], items[6], "", "")
                    pass
                else:
                    worditem = makeitem(items[0], items[1], items[2], items[3], items[4], items[5], items[6], items[7],
                                        items[8])
                    pass
                result = result + worditem + "\n"

                # print(worditem)
            else:
                break
        pass
        #store file to disk
        luafile = open("result.txt","w")
        luafile.write(result)
        luafile.flush()
        luafile.close()
    finally:
        if f:
            f.close()

def makeitem(word, sm1, sm2, mean1, mean2, eng1, ch1, eng2, ch2):
    if not eng2:
        eng2 = ""
        ch2 = ""

    sp = "\',\'"
    eng1 = eng1.replace("\'", "\\\'")
    eng2 = eng2.replace("\'", "\\\'")
    if eng2 != "":
        re = "".join(
            ["M.allwords[\"", word, "\"]={\"", word, "\",\"", sm1, "\",\"", sm2, "\",'", mean1, sp, mean2, sp, eng1, sp, ch1, eng2,
             ch2, "'}"])
    else:
        re = "".join(
            ["M.allwords[\"", word, "\"]={\"", word, "\",\"", sm1, "\",\"", sm2, "\",'", mean1, sp, mean2, sp, eng1, sp, ch1, "'}"])
    return re

def getFileEncode(filepath):
    file = open(filepath, 'r')
    f = file.read()
    en = chardet.detect(f)
    print en


def main(argv):
    if len(argv) == 2:
        exportWordFromTxt(argv[1])
    else:
        filepath = "words.txt"
        # print 'input txt file path!'
        exportWordFromTxt(filepath)

if __name__ == '__main__':
    main(sys.argv)