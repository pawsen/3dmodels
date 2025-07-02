# Use cleanedges formerly in PathUtils for the approxiamtion
''' Approxamation of wires containing bezier curves by arcs

wire2sketch.py
https://forum.freecad.org/viewtopic.php?p=498691#p498691
'''

import FreeCAD
from DraftGeomUtils import geomType
import Draft

def cleanedges(splines, precision):
    '''cleanedges([splines],precision). Convert BSpline curves, Beziers, to arcs that can be used for cnc paths.
    Returns Lines as is. Filters Circle and Arcs for over 180 degrees. Discretizes Ellipses. Ignores other geometry. '''
    edges = []
    for spline in splines:
        if geomType(spline) == "BSplineCurve":
            arcs = spline.Curve.toBiArcs(precision)
            for i in arcs:
                edges.append(Part.Edge(i))

        elif geomType(spline) == "BezierCurve":
            newspline = spline.Curve.toBSpline()
            arcs = newspline.toBiArcs(precision)
            for i in arcs:
                edges.append(Part.Edge(i))

        elif geomType(spline) == "Ellipse":
            edges = curvetowire(spline, 1.0)  # fixme hardcoded value

        elif geomType(spline) == "Circle":
            # arcs = PathUtils.filterArcs(spline)
            # for i in arcs:
            #     edges.append(Part.Edge(i))
            edges.append(spline)

        elif geomType(spline) == "Line":
            edges.append(spline)

        elif geomType(spline) == "LineSegment":
            edges.append(spline)

        else:
            pass

    return edges

def shape2Sketch(shape):
  # replace shape.edges with arcs
  global test
  newEdges = cleanedges(shape.Edges,0.02)
  wire = Part.Wire([Part.Edge(i) for i in newEdges])
  sketch = Draft.makeSketch(wire,autoconstraints=True,delete=True)
  
selection = FreeCADGui.Selection.getSelectionEx()
for s in selection:
  shape2Sketch(s.Object.Shape)
