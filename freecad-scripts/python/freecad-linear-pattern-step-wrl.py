#!/usr/bin/env python

# Use FreeCAD to take an input STEP file and create a series of files which
# contain a series of copies of that file. For example creating a series of PCB
# headers, your initial step file is a single pole of the header (or 2 poles in
# the case of a double row) and then it will create files for 1x2, 1x3, 1x4 and
# so forth.
#
# Take an input step file and duplicate it along the X axis
# creating files named by the pattern
#
#  Example:
#    ./freecad-linear-pattern-step-wrl.py /tmp/hdr-1x1t_2.54.step "/tmp/hdr-1x%dt_2.54.wrl"
#    Where "%d" will be replaced by the copy number...
#    will generate hdr-1x1t_2.54.wrl
#                  hdr-1x2t_2.54.wrl
#                  hdr-1x3t_2.54.wrl
#                  hdr-1x4t_2.54.wrl
#                  ...
#                  hdr-1x40t_2.54.wrl
#
#   You can also use .step or other supported FreeCAD file extensions for
#   the output (not sure about the input), STEP is pretty bloated for output
#   though, so you might want to use wrl.

import sys
import shutil
inputFile  = sys.argv[1]
outputFilePattern = sys.argv[2]
sys.path.append("/usr/lib/freecad/lib");
maxCount = 40

import FreeCADGui
FreeCADGui.showMainWindow()

import Import
import ImportGui
import Draft
FreeCAD.newDocument("Unnamed")
FreeCAD.setActiveDocument("Unnamed")
ImportGui.insert(inputFile,"Unnamed")

# Prepare copies of the files which are offset by each pitch
for x in range(2,maxCount+1):
  offset   = 2.54 * (x - 1)
  outputTo = (outputFilePattern % (x)).replace('.', '_') + '.step'

  __objs__=[]
  for part in FreeCAD.ActiveDocument.Objects:
    part.Placement=App.Placement(App.Vector(offset,0,0),App.Rotation(0,0,0,1))
    __objs__.append(part)

  #FreeCADGui.export(__objs__,outputFile)
  ImportGui.export(__objs__,outputTo)
  del __objs__

# Reset the initial one back to 0
__objs__=[]
for part in FreeCAD.ActiveDocument.Objects:
  part.Placement=App.Placement(App.Vector(0,0,0),App.Rotation(0,0,0,1))
  __objs__.append(part)
del __objs__


for x in range(1,maxCount+1):

  # Do not overwrite the input file
  if ((outputFilePattern % (x)) == inputFile):
    continue

  # We already have the first pin, insert from pin 2 onwards
  if x > 1:
    pinFile = (outputFilePattern % (x)).replace('.', '_') + '.step'
    ImportGui.insert(pinFile,"Unnamed")

  __objs__=[]
  for part in FreeCAD.ActiveDocument.Objects:
    __objs__.append(part)

  if outputFilePattern.find('.wrl'):
    FreeCADGui.export(__objs__, '/tmp/tmp.wrl')
    shutil.move('/tmp/tmp.wrl', outputFilePattern % (x))
  else:
    ImportGui.export(__objs__,pinFile)
    shutil.move(pinFile, outputFilePattern % (x))
  del __objs__

FreeCAD.closeDocument("Unnamed")
