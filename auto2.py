x = input()

ff = x.split("_")
out = ""
for i in ff:
	out+=i

print(hex(int(out, base = 2)))
