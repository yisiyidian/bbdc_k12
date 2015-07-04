local SkillConfig = {}
--type分为attack和buff
SkillConfig['0'] = {name = '无',skillType = 'attack',attack = 0,buff = 0.0, describe = '',effectFile = ''}
SkillConfig['1'] = {name = '普通攻击',skillType = 'attack',attack = 5,buff = 0.0, describe = '普通攻击:对当前boss造成小幅伤害',effectFile = 'image/summarybossscene/been_complete_studys.png'}
SkillConfig['2'] = {name = '浑身一击',skillType = 'attack',attack = 20,buff = 0.0, describe = '浑身一击：使出全身力量，对boss造成较大伤害',effectFile = 'image/summarybossscene/been_complete_studys.png'}
SkillConfig['3'] = {name = '提升力量',skillType = 'buff',attack = 0,buff = 0.25, describe = '提升力量：对boss伤害提高25%',effectFile = 'image/summarybossscene/been_complete_studys.png'}
return SkillConfig