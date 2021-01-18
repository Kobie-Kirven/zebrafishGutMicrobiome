import urllib.request

with open('weka_output.txt') as fn:
	ecs = [line.strip('\n').split(' ')[-1] for line in fn.readlines()]

	for ec in ecs[:10]:
		print(ec)