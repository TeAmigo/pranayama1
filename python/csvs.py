#!/usr/bin/env python
# <2020-07-16 Thu 18:36> rpc - Being used by ~/share/EmacsLispRPC/prana/prana.el to implement the 4
# segment Power Breath based on Wim Hof prana method.

import csv
import tkinter
import matplotlib

root = tkinter.Tk()

#Currently /home/rick/share/notes/breath1.csv
global cfileName

def getCsvFilePath() :
    global cfileName
    return cfileName

def setCsvFilePath(filepath) :
    global cfileName
    cfileName = filepath
    
def insertrow(listin) :
    cfile = open(cfileName, 'a')
    csvfile = csv.writer(cfile, dialect='unix', quoting=csv.QUOTE_NONE)
    csvfile.writerow(listin)
    cfile.close()

    
# rrow = (07-22-20-11-51 10.3 22.2 30.4 40.7)
# cfileName = "/home/rick/share/notes/breath1.csv"
# cfile = open(cfileName, 'a')
# csvfile = csv.writer(cfile, dialect='unix')
# csvfile.writerow(rrow)
# cfile.close()



def createCsvWithHeaders(filename, headers) :
    '''Be very careful not to clobber existing files.'''
    global cfileName
    cfileName= "/home/rick/share/notes/" + filename
    cfile = open(cfileName, 'w')
    csvfile = csv.writer(cfile, dialect='unix')
    csvfile.writerow(headers)
    cfile.close()

def displayTable() :
    '''Doesn't display well. csv-mode is nice, might try som matplotlib.'''
    with open("/home/rick/share/notes/breath1.csv", newline = "") as file:
        reader = csv.reader(file)
        # r and c tell us where to grid the labels
        r = 0
        for col in reader:
            c = 0
            for row in col:
                # i've added some styling
                label = tkinter.Label(root, width = 10, height = 2, \
                                      text = row, relief = tkinter.RIDGE)
                label.grid(row = r, column = c)
                c += 1
                r += 1
    root.mainloop()

# headers = ["Initial", "Empty Hold", "InBreath", "In Hold"] 
# createCsvWithHeaders("breath1.csv", headers)

def testdummy():
    return "DateTime", "1", "2", "3", "4"

if __name__ == "__main__":
    print(testdummy())

