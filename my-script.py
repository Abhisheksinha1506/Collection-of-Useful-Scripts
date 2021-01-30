n=15
for i in range(0,n):
	print (((n-(i+1))*' ')+(((2*i)+1)*'*'))
for i in range(1,n):
	print (((i)*' ')+(((((n-i)*2)-1)*'*')))