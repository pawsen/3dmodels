"""Sample code.

Filename:
   airplane.py

Author:
    Dormeletti Carlo (onekk)

Version:
    1.0

License:
    Creative Commons Attribution 3.0

Summary:
    This is sample code written for a FreeCAD Wiki page.
    It creates an airplane shaped solid using standard "Part WB" shapes.

"""

import FreeCAD
from FreeCAD import Placement, Rotation, Vector
import FreeCADGui

DOC_NAME = "Wiki_Example"
DOC = FreeCAD.newDocument(DOC_NAME)
FreeCAD.setActiveDocument(DOC.Name)

ROT0 = Rotation(0, 0, 0)
VEC0 = Vector(0, 0, 0)

# Helper function

def set_view():
    """Rearrange View."""
    if not FreeCAD.GuiUp:
        return
    doc = FreeCADGui.ActiveDocument
    if doc is None:
        return
    view = doc.ActiveView
    if view is None:
        return
    # Check if the view is a 3D view:
    if not hasattr(view, "getSceneGraph"):
        return
    view.viewAxometric()
    view.fitAll()

# Script functions

def my_cyl(name, ang, rad, hei):
    """Create a Cylinder."""
    obj = DOC.addObject("Part::Cylinder", name)
    obj.Angle = ang
    obj.Radius = rad
    obj.Height = hei

    DOC.recompute()

    return obj

def my_sphere(name, rad):
    """Create a Sphere."""
    obj = DOC.addObject("Part::Sphere", name)
    obj.Radius = rad

    DOC.recompute()

    return obj

def my_box2(name, len, wid, hei, cent=False, off_z=0):
    """Create a box with an optional z offset."""
    obj_b = DOC.addObject("Part::Box", name)
    obj_b.Length = len
    obj_b.Width = wid
    obj_b.Height = hei

    if cent is True:
        pos = Vector(len * -0.5, wid * -0.5, off_z)
    else:
        pos = Vector(0, 0, off_z)

    obj_b.Placement = Placement(pos, ROT0, VEC0)

    DOC.recompute()

    return obj_b

def mfuse_obj(name, objs):
    """Fuse multiple objects."""
    obj = DOC.addObject("Part::MultiFuse", name)
    obj.Shapes = objs
    obj.Refine = True
    DOC.recompute()

    return obj

def airplane():
    """Create an airplane shaped solid."""
    fuselage_length = 30
    fuselage_diameter = 5
    wing_span = fuselage_length * 1.75
    wing_width = 7.5
    wing_thickness = 1.5
    tail_height = fuselage_diameter * 3.0
    tail_position = fuselage_length * 0.70
    tail_offset = tail_position - (wing_width * 0.5)

    obj1 = my_cyl("main_body", 360, fuselage_diameter, fuselage_length)

    obj2 = my_box2("wings", wing_span, wing_thickness, wing_width, True, tail_offset)

    obj3 = my_sphere("nose", fuselage_diameter)
    obj3.Placement = Placement(Vector(0, 0, fuselage_length), ROT0, VEC0)

    obj4 = my_box2("tail", wing_thickness, tail_height, wing_width, False, 0)
    obj4.Placement = Placement(Vector(0, tail_height * -1, 0), ROT0, VEC0)

    objs = (obj1, obj2, obj3, obj4)

    obj = mfuse_obj("airplane", objs)
    obj.Placement = Placement(VEC0, Rotation(0, 0, -90), Vector(0, 0, tail_position))

    DOC.recompute()

    return obj

# objects definition

airplane()

set_view()
