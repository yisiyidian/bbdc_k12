import shutil
import os.path

print '''Make sure you have 'BookSoundBag' folder in the project root directory, 
the 'BookSoundBag' folder should contain the sounds video.
For example:
the 'cet4' sounds should under the path of BeiBeiDanCiX/BookSoundBag/cet4/ '''

wordAmount = int(raw_input("Please input how many words you want to get: "))

bookList = ['cet4', 'cet6','gmat','gre','ielts','middle','ncee','primary','pro4','pro8','sat','toefl']

for bookRaw in bookList:
    path = "../raw/book/" + bookRaw + ".book"
    print "the path is %s" % path
    with open(path,'r') as book:
        index = 0
        while index<wordAmount:
            line = book.readline()
            line = line.strip('\n')
            enSoundPath = "../BookSoundBag/" + bookRaw + "/en_" + line+ ".mp3"
            usSoundPath = "../BookSoundBag/" + bookRaw + "/us_" + line + ".mp3"
            enDstPath = "../BookSoundBag/words/" + "/en_" + line + ".mp3"
            usDstPath = "../BookSoundBag/words/" + "/us_" + line + ".mp3"

            if(os.path.exists(enSoundPath) == False):
                print "Can not find the en sounds under the path: %s"%enSoundPath
            else:
                shutil.copyfile(enSoundPath, enDstPath)

            if(os.path.exists(usSoundPath)==False):
                print "Can not find the us sounds under the path %s"%usSoundPath
            else:
                shutil.copyfile(usSoundPath, usDstPath)
            index+=1
            if not line:

                break
