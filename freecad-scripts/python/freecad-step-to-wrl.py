#!/usr/bin/env python

# Convert a step file (or other) into a wrl file (or other) with FreeCAD
# You must provide an absolute input and output file path (NO RELATIVE!)
# A freecad window will open, the conversion will happen, and it will 
# close.  The export requires gui functions it seems so this is unavoidable.

# PROTIP:
#  sudo startx -display :1 -- :1 vt8
#  CTRL-ALT-F8 to switch to the new X session on VT8 and run `xhost +` in the terminal
#  CTRL-ALT-F7 back to your normal X session and then
#  DISPLAY=:1 freecad-step-to-wrl.py [in] [out]
#  the freecad window will open on the new XSession so doesn't interrupt you
#  when you are doing a batch of them

# To allow relative file paths (untested)
# import os
# inputFile = os.path.abspath(sys.argv[1])
# outputFile = os.path.abspath(sys.argv[2])

import sys
inputFile  = sys.argv[1]
outputFile = sys.argv[2]
sys.path.append("/usr/lib/freecad/lib");

import FreeCADGui
FreeCADGui.showMainWindow()

import Import
import ImportGui
import Draft
FreeCAD.newDocument("Unnamed")
FreeCAD.setActiveDocument("Unnamed")
ImportGui.insert(inputFile,"Unnamed")
__objs__=[]
for part in FreeCAD.ActiveDocument.Objects:
    __objs__.append(part)
FreeCADGui.export(__objs__,outputFile)
del __objs__
FreeCAD.closeDocument("Unnamed")

