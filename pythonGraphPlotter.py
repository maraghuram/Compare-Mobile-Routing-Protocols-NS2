from matplotlib import pyplot as plt

fin=open('tput.txt')

lines=fin.readlines()
x=[]
y1=[]
y2=[]
y3=[]

for l in lines:
    l = l.split(' ')
    x += [float(l[0])]
    y1 += [float(l[1])]
    y2 += [float(l[2])]
    y3 += [float(l[3])]    

plt.figure(1)
plt.plot(x,y1,'ro')
#plt.plot(x,y2,'bs')
#plt.plot(x,y3,'g^')
plt.show()
fin.close()

