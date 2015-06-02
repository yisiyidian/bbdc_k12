import os
imagePath = '/Users/yehanjie/workspace/bbdc/bbdc_k12/BeiBei2DXLua/res/image'
os.chdir(imagePath)

luaPath = '/Users/yehanjie/workspace/bbdc/bbdc_k12/BeiBei2DXLua/src/view'

def findImage(imageName,luaDir):
	for parent, dirnames, filenames in os.walk(luaDir):
	    for filename in filenames:
	    	fullPath = os.path.join(parent, filename)
	    	if filename.find('.lua') > 0:
	    		file = open(fullPath)
	    		while 1:
					line = file.readline()
					if not line:
						break
					if line.find(imageName) > 0:
						# print line
						return 1
	return 0

for parent, dirnames, filenames in os.walk(imagePath):
  for filename in filenames:
    fullPath = os.path.join(parent, filename)
    if filename.find('.png') > 0:
      if findImage(filename,luaPath) != 1:  
        print filename
        print fullPath
        print "is nil"