for i in range(5):
    for j in range(5):
        s = ""
        for k in range(5):
            s = s + str((i,k)) + "*" + str((k,j))+ " + "
        print (i,j),"=",s
