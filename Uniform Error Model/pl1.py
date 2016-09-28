from matplotlib import pyplot as plt

fin=open('jitter.txt')

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
plt.xlabel('Error Rate')
plt.ylabel('Average Jitter')
#plt.axis([0.04,0.20,95,100])
ax=plt.subplot(111)
l1=ax.plot(x,y1,color='red',label='AODV')
l2=ax.plot(x,y2,color='blue',label='DSDV')
l3=ax.plot(x,y3,color='orange',label='DSR')
box = ax.get_position()
ax.set_position([box.x0, box.y0, box.width * 0.85, box.height])

# Put a legend to the right of the current axis
ax.legend(loc='lower left', bbox_to_anchor=(1, 0.5))
#plt.legend()
plt.show()
fin.close()

