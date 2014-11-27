userId="54770541e4b0a08f8e68b6d8"
chapterKey="chapter0"
bookKey="ncee"
levelKey="level0"

curl -X POST \
  -H "X-AVOSCloud-Application-Id: gqzttdmaxmb451s2ypjkkdj91a0m9izsk069hu4wji3tuepn" \
  -H "X-AVOSCloud-Application-Key: x6uls40kqxb3by8uig1b42v9m6erd2xd6xqtw1z3lpg4znb3" \
  -H "Content-Type: application/json" \
  -d '{"isPassed":1,"isPlayed":1,"userId":"${userId}","isLevelUnlocked":1,"version":0,"stars":0,"chapterKey":"${chapterKey}","bookKey":"${bookKey}","levelKey":"${levelKey}"}' \
  https://leancloud.cn/1.1/classes/DataLevel