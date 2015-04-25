from math import *
from operator import concat
from random import randint, random, choice, uniform

import colorsys
import pysvg.structure
import pysvg.builders

img_side = 1024

img_xmid = img_side/2
img_ymid = img_side/2

starting_rad = 10

class Circle:
	__slots__ = ('x', 'y', 'rad', 'depth')
	
	def __init__(self, x, y, rad, depth):
		self.x = x
		self.y = y
		self.rad = rad
		self.depth = depth

circles = []

def rgb_to_hex(rgb):
	return "#" + reduce(concat, map(lambda x: "%02x" % x, rgb))

def make_child(circle):

	transform = random()
        
        if (transform < .01):
                px = 0
                py = (0.16*circle.y)

        elif (transform < 0.86):
                px = (0.85*circle.x + 0.04*circle.y) 
                py = (-0.04*circle.x + 0.85*circle.y + 1.6) + 250

        elif (transform < .93):
                px = (0.2*circle.x - 0.26*circle.y) 
                py = (0.23*circle.x + 0.22*circle.y + 1.6) + 175

        elif (transform < 1.0 ):
                px = (-.15*circle.x + 0.28*circle.y) 
                py = (.26*circle.x + 0.24*circle.y + 0.44) + 50

	return Circle(px, py, circle.rad , circle.depth + 1)


def make_tree(root, branch, depth):
      
        children = []
        circles.append(root)
        children.append(root)
        for _ in range(depth):
                child = make_child(children[-1])
                children.append(child)
                circles.append(Circle(child.x * 5, child.y * 5, \
                                      child.rad, child.depth))

# Add the root
root = Circle(img_xmid, img_ymid, starting_rad, 0)
circles.append(root)

# Make the tree
depth = 75000
branching_factor = 1
make_tree(root, branching_factor, depth)

# Make the SVG
svg = pysvg.structure.svg()
sb = pysvg.builders.ShapeBuilder()

bot_y = min(circles, key = lambda circ: circ.y).y
top_y = max(circles, key = lambda circ: circ.y).y

bot_x_circ = min(circles, key = lambda circ: circ.x - circ.rad)
bot_x = bot_x_circ.x - bot_x_circ.rad

bot_y_circ = min(circles, key = lambda circ: circ.y - circ.rad)
bot_y = bot_y_circ.y - bot_y_circ.rad

highest_dist_circ = max(circles, key = lambda circ: sqrt((circ.x - bot_x)**2 + (circ.y-bot_y)**2))
highest_dist = sqrt((highest_dist_circ.x - bot_x)**2 + (highest_dist_circ.y - bot_y)**2)

for circ in circles:

	light = 0.5
       # hue = 1.17 + (float(circ.y - bot_y) /(2.5* (top_y - bot_y)))
        hue = 1.1 + (float(circ.y - bot_y) /(2.5* (top_y - bot_y)))
	sat = 0.5
	rgb = map(lambda x: int(255* x), colorsys.hls_to_rgb(hue, light, sat))
	color = rgb_to_hex(rgb)
	
	if(circ.depth > 2):
		svg.addElement(sb.createCircle(circ.x - bot_x, circ.y - bot_y, circ.rad, strokewidth = 0, fill = color))

# Hack fill opacity in because PySVG doesn't have it :(
xml = svg.getXML().replace("; \"", "; fill-opacity:0.75; \"")

with open("barnsley.svg", "w") as f:
	f.write(xml)

	
	
	
	
	
	
	
	
	
	
