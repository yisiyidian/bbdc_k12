import sys

origin = open('houhai.newbook','r')
after = open('houhai.after','w')
for line in origin:
	content = line.strip().split('\t')
	out_str = str(int(content[0])-50)+'\t'+'\t'.join(content[1:])+'\n'
	after.write(out_str)
