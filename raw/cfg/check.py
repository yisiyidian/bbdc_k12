
import json


words = set([])
for line in open("../tmp/allwords.json"):
	t = line.strip().split("\t")
	words.add(t[0])

print(len(words))

content = open("Level.json").read()
s = json.loads(content)
level_array = s["Levels"]["Level"]


wrongList = set([])
for level in level_array:
	word_content = level["word_content"]
	word = word_content.strip().split("|")
	tmp = []
	for w in word:
		if w in words:
			tmp.append(w)
		else:
			wrongList.add(w)
	if len(tmp) <= 0:
		print("error")
		exit()
	level["word_content"] = "|".join(tmp)


df = open("newLevel.json", "w")
json.dump(s, df)

df.close()





