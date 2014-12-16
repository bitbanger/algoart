from math import *
from operator import concat
from random import randint, random, choice, uniform

import colorsys
import pysvg.structure
import pysvg.builders

import sys

img_side = 1024

img_xmid = img_side/2
img_ymid = img_side/2

starting_rad = 128

class Circle:
	__slots__ = ('x', 'y', 'rad', 'depth', 'children', 'ang')
	
	def __init__(self, x, y, rad, depth, ang):
		self.x = x
		self.y = y
		self.rad = rad
		self.depth = depth
		self.children = []
		self.ang = ang

circles = []

def rand_neg(n):
	return randint(0, n*2) - n

def random_neg(c):
	return c * (2 * random() - 1)

def rgb_to_hex(rgb):
	return "#" + reduce(concat, map(lambda x: "%02x" % x, rgb))

def make_child(circle):
	ang = uniform(pi*5.0/4, pi*7.0/4)
	if circle.ang != pi:
		# ang = random() * (1 * pi)
		if depth - circle.depth < 3: 
			# fray the edges
			ang = circle.ang + uniform(pi*-1.0/3, pi*1.0/3)
		else:
			ang = circle.ang + uniform(pi*-1.0/7, pi*1.0/7)
	# ang = uniform(2.0 * pi) if random() < 0.10 else uniform(.9 * pi, 1.1 * pi)
	dist = uniform(1.0, 2.8)
	px = (dist * circle.rad) * cos(ang) + circle.x
	py = (dist * circle.rad) * sin(ang) + circle.y
	
	return Circle(px, py, circle.rad * 0.7, circle.depth + 1, ang)

def make_tree(root, branch, depth):
	if depth == 0:
		return
	
	children = []
	
	for _ in range(branch):
		child = make_child(root)
		root.children.append(child)
		children.append(child)
		circles.append(child)
	
	for child in root.children:
		make_tree(child, branch, depth - 1)

# Add the root
root = Circle(img_xmid, img_ymid, starting_rad, 0, pi)
circles.append(root)

# Make the tree
depth = 6
branching_factor = 4
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
	# darkness = (float(circ.depth) / depth) * 255
	
	# light = float(circ.depth) / depth
	light = 0.5
	
	# hue = float(circ.y - bot_y) / (top_y - bot_y)
	
	hue = sqrt((circ.x - bot_x)**2 + (circ.y - bot_y)**2) / highest_dist
	hue += choice((-1, 1)) * random() * 0.25
	
	# sat = float(circ.depth) / depth
	sat = 0.5
	

	size_index = circ.rad*1.0 / starting_rad
	start_light = (1 - size_index)*0.4 + 0.5
	rgb = map(lambda x: int(255 * x), colorsys.hls_to_rgb(.96, min(1.0, start_light + random_neg(0.15)), 1))
	# rgb = (255, 183, 197)
	
	color = rgb_to_hex(rgb)
	
	cutoff = 3
	cutoff2 = 0

	if circ.depth > cutoff:
		# svg.addElement(sb.createCircle(circ.x - bot_x, circ.y - bot_y, circ.rad, strokewidth = 0, fill = color))
		svg.addElement(sb.createRect(circ.x - bot_x, circ.y - bot_y, circ.rad, circ.rad, strokewidth = 0, fill = color))
	elif circ.depth >= cutoff2:
		# svg.addElement(sb.createRect(circ.x - bot_x, circ.y - bot_y, circ.rad, circ.rad, strokewidth = 0, fill = 'brown'))
		for i in range(10):
			svg.addElement(sb.createRect(uniform(circ.x - bot_x, circ.x - bot_x + circ.rad), uniform(circ.y - bot_y, circ.y - bot_y + circ.rad), circ.rad*1.0/3, circ.rad*1.0/3, strokewidth = 0, fill = 'brown'))

# Hack fill opacity in because PySVG doesn't have it :(
xml = svg.getXML().replace("; \"", "; fill-opacity:0.5; \"")

filename = "angletree.svg"
if len(sys.argv) > 1:
	filename = sys.argv[1]

with open(filename, "w") as f:
	f.write(xml)

	
	
	
	
	
	
	
	
	
	
