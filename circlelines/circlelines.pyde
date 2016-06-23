from math import *
from random import *

class Circle:
    __slots__ = ('x', 'y', 'rad', 'depth')
    
    def __init__(self, x, y, rad, depth):
        self.x = x
        self.y = y
        self.rad = rad
        self.depth = depth

def make_child(circle, distance):
    ang = random() * (2*PI)
    px = (distance() * circle.rad) * cos(ang) + circle.x
    py = (distance() * circle.rad) * sin(ang) + circle.y
    
    return Circle(px, py, circle.rad * 0.5, circle.depth + 1)

planet_bf = 5
planet_depth = 5
galaxy_bf = 4
galaxy_depth = 3

def hex_to_rgb(x):
    l = map(lambda x: int(x, 16), [x[:2], x[2:4], x[4:]])
    return color(l[0], l[1], l[2])

colors = map(hex_to_rgb, ["E69616", "FFC872", "F1AF47", "B4720A", "8D5600", "E6AD16", "FFD872", "F1C247", "B4850A", "8D6600", "22319E", "616BBA", "404CA6", "16227C", "0B1561", "1A5397", "5881B3", "37669D", "103E76", "072D5C"])

def make_tree(root, branch, depth, circles, distance):
    if depth == 0:
        return
    
    children = []
    
    for _ in range(branch):
        child = make_child(root, distance)
        children.append(child)
        circles.append(child)
    
    for child in children:
        make_tree(child, branch, depth - 1, circles, distance)
    
    return

def planet(x, y, radius, bf, depth, repeat, recdepth, distance, show_all):
    for i in range(repeat):
        fill(choice(colors), 128)
        stroke(0, 0, 0, 0)
        root = Circle(x, y, radius, 0)
        circles = [root]
        make_tree(root, bf, depth, circles, distance)
        i = 0
        for c in circles:
            i += 1
            if c.depth == depth or show_all:
                if recdepth == 0:
                    ellipse(c.x, c.y, c.rad, c.rad)
                else:
                    planet(c.x, c.y, c.rad * 0.5, planet_bf, planet_depth, int(uniform(1, 20)), recdepth-1, lambda: uniform(0.5, 1), False)

xdim, ydim = 1024, 1024

def setup():
    background(0, 0, 0)
    
    size(xdim, ydim)
    
    planet(xdim*0.5, ydim*0.5, 320, galaxy_bf, galaxy_depth, 1, 1, lambda: 1.0, True)
