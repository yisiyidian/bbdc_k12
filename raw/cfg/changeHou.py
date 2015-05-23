
import os
import sys
import collections

if len(sys.argv) < 3:
	print 'argv[1]: originBook'
	print 'argv[2]: processedBook'
	exit()

# bookKeyList = ['primary_1', 'primary_2', 'primary_3', 'primary_4', 'primary_5', 'primary_6', 'primary_7', 'primary_8'
#         , 'junior_1', 'junior_2', 'junior_3', 'junior_4', 'junior_5', 'senior_1', 'senior_2', 'senior_3', 'senior_4'
#         , 'senior_5', 'senior_6', 'senior_7', 'senior_8', 'senior_9', 'senior_10', 'senior_11']

# for bookKey in bookKeyList:
	# print 'bookKey',bookKey
book = open(sys.argv[1],'r')
bookDic = {}
for line in book:
	content = line.strip().split('|')
	if not bookDic.has_key(content[1]):
		bookDic[content[1]] = []
	bookDic[content[1]].append(content[0])
# print bookDic
#keyList=['1A','1B','2A','2B','3A','3B','4A','4B','5A','5B','6A','6B','7A','7B','8A','8B','9A','9B','10A','10B','11A','11B','12A','12B']
keyList=['9A','9B','10A','10B','11A','11B','12A','12B']
# compute book new dict
newbookFile = open(sys.argv[2],'w')

current_unitID = 1
for key in keyList:
# bookDic = collections.OrderedDict(sorted(bookDic.items(), key=lambda d:d[0]))
# for unitID in bookDic:
	word_index = 0
	# print bookDic[unitID]
	# print unitID, current_unitID

	W = len(bookDic[key])
	# print 'W:',W
	A = int(round(float(W) / 10))
	if W < 15:
		A = 1
	B = int(round(float(W) / A))
	X = B
	if W - B * A > 0:
		Y = X + 1
	else:
		Y = X - 1
	Z = abs(W-B*A)
	subUnit = 1
	# print 'A:',A,'Z:',Z,'B:',B,'Y:',Y
	for i in range(0, A-Z):
		combine = []
		for j in range(0, B):
			word_content = bookDic[key][word_index].split()
			if len(word_content) > 1:
				combine.append(bookDic[key][word_index])
			else:
				out_str = str(current_unitID) + '\t' + bookDic[key][word_index] + '\t' + str(key) + '_' + str(subUnit) + '\t' + str(A) + '\n'
				newbookFile.write(out_str)
			word_index += 1
		# write combine
		for words in combine:
			out_str = str(current_unitID) + '\t' + words + '\t' + str(key) + '_' + str(subUnit) + '\t' + str(A) + '\n'
			newbookFile.write(out_str)
		subUnit += 1
		current_unitID += 1
	for i in range(0, Z):
		combine = []
		for j in range(0, Y):
			word_content = bookDic[key][word_index].split()
			if len(word_content) > 1:
				combine.append(bookDic[key][word_index])
			else:
				out_str = str(current_unitID) + '\t' + bookDic[key][word_index] + '\t' + str(key) + '_' + str(subUnit) + '\t' + str(A) + '\n'
				newbookFile.write(out_str)
			word_index += 1
		# write combine
		for words in combine:
			out_str = str(current_unitID) + '\t' + words + '\t' + str(key) + '_' + str(subUnit) + '\t' + str(A) + '\n'
			newbookFile.write(out_str)
		subUnit += 1
		current_unitID += 1 
	
