
#!/usr/bin/python

import json
import os
import re
import sys


print "huh"

scaleDictionary = {'scaleMembers': [1.0,1.25,1.5,2.0], 'name': 'meanpi'}
jsonRep = json.dumps(scaleDictionary)

print jsonRep

if os.environ.has_key("SCALA_DIR"):
  scalaDirectory = os.environ.get("SCALA_DIR")
else:
  sys.exit("No Scala Directory identified. Set $SCALA_DIR environment variable to the Scala Directory path")

print scalaDirectory

validFiles = 0
invalidFiles = 0

for filename in os.listdir(scalaDirectory):
    if filename.endswith(".scl"): 
        jsonConversionDict = {}
        description = ""
        filename = scalaDirectory + "/" + filename
        scalaFile = open(filename,"r")
        textOfFile = scalaFile.read()
        linesOfFile = textOfFile.split('\r\n')
        print "-- start --"
        index = 0
        for line in linesOfFile:
           line = line.replace("!","")
           line = line.replace("cents","")
           linesOfFile[index] = line
           if index == 0:
             line = line.replace(" ","")
             jsonConversionDict["scaleName"] = line
           
           r = jsonConversionDict.get('notelist',None)
           if r != None:
             line = line.replace(" ","")
             if len(line) > 0 and line != "2/1":
               r.append(line)

           r = jsonConversionDict.get('description', None) 
           if index > 0 and r == None:
             if line.replace(" ","").isdigit() == False:
              description += line
             elif index > 0 and line.replace(" ","").isdigit() == True:
              jsonConversionDict["numberOfNotes"] = line.replace(" ","")
              jsonConversionDict["description"] = description
              jsonConversionDict["notelist"] = ["1"] 
           index += 1

        print jsonConversionDict
        jsonRep = json.dumps(jsonConversionDict, ensure_ascii=False)
        print jsonRep
        jsonFile = jsonConversionDict["scaleName"].replace(".scl",".json")
        with open(jsonFile,"w") as f:
          f.write(jsonRep)

        continue       
    else:
        continue

print validFiles
print invalidFiles

    

