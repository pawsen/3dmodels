import FreeCAD as App
import Part

def my_create_line(pt1, pt2, obj_name):
    """Instead of doing``

    line = my_create_line((0, 0, 0), (0, 10, 0), "LineName")
    line = Part.LineSegment()
    line.StartPoint = (0.0, 0.0, 0.0)
    line.EndPoint = (1.0, 1.0, 1.0)
    obj = doc.addObject("Part::Feature", "Line")
    obj.Shape= line.toShape()
    """
    obj = App.ActiveDocument.addObject("Part::Line", obj_name)
    obj.X1 = pt1[0]
    obj.Y1 = pt1[1]
    obj.Z1 = pt1[2]

    obj.X2 = pt2[0]
    obj.Y2 = pt2[1]
    obj.Z2 = pt2[2]

    App.ActiveDocument.recompute()
    return obj

def my_create_circle(rad, obj_name):
    """Instead of doing

    circle = Part.Circle()
    circle.Radius = 10.0
    obj = doc.addObject("Part::Feature", "Circle")
    obj.Shape = circle.toShape()
    """
    obj = App.ActiveDocument.addObject("Part::Circle", obj_name)
    obj.Radius = rad

    App.ActiveDocument.recompute()
    return obj


doc = App.newDocument()

line = my_create_line((0, 0, 0), (0, 10, 0), "LineName")
circle = my_create_circle(5.0, "CircleName")
doc.recompute()
doc.saveAs("test01.FCStd")
