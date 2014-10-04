import sys

reload(sys)
sys.setdefaultencoding( "utf-8" )

import json



content = open('allword.json').read()

a = json.loads(content)




df = open("1.json", "w")

for w in a:	
	b = []
	b.append(w)
	b.append(a[w]["sound_en"])
	b.append(a[w]["sound_us"])
	b.append(a[w]["meaning"])
	b.append(a[w]["small_meaning"])
	b.append(a[w]["sentence_en"])
	b.append(a[w]["sentence_cn"])
	df.write("%s\n"%"\t".join(b))

df.close()
