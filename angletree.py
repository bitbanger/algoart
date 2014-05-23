from math import *
from operator import concat
from random import randint, random, choice, uniform

import colorsys
import pysvg.structure
import pysvg.builders

# Circle data container class
class Circle:
	__slots__ = ('x', 'y', 'rad', 'depth')
	
	def __init__(self, x, y, rad, depth):
		self.x = x
		self.y = y
		self.rad = rad
		self.depth = depth

# Size constants
img_side = 1024
img_xmid = img_side/2
img_ymid = img_side/2

# Starting circle size
starting_rad = 128

# A silly Pythonic way to convert an Iterable of RGB values into a hex string
def rgb_to_hex(rgb):
	return "#" + reduce(concat, map(lambda x: "%02x" % x, rgb))

# Places a single child node at some angle from the parent
# Currently, the angles are very restricted
def make_child(circle):
	# We'll generate polar coordinates
	ang = uniform(1.95 * pi, 2.15 * pi) if random() < 0.10 else uniform(.85 * pi, 1.15 * pi)
	px = (2 * circle.rad) * cos(ang) + circle.x
	py = (2 * circle.rad) * sin(ang) + circle.y
	
	return Circle(px, py, circle.rad * 0.55, circle.depth + 1)

# Makes an entire tree recursively and returns the list of circle structures
def make_tree(circlist, root, branch, depth):
	if depth == 0:
		return
	
	children = []
	
	for _ in range(branch):
		child = make_child(root)
		children.append(child)
		circlist.append(child)
	
	for child in children:
		make_tree(child, branch, depth - 1)

# Now, let's begin the fun!

circles = []

# Add the root
root = Circle(img_xmid, img_ymid, starting_rad, 0)
circles.append(root)

# Make the tree
depth = 6
branching_factor = 7
make_tree(root, branching_factor, depth)

# Make the SVG
svg = pysvg.structure.svg()
sb = pysvg.builders.ShapeBuilder()

# Extract the extreme circles on either dimension
bot_y = min(circles, key = lambda circ: circ.y).y
top_y = max(circles, key = lambda circ: circ.y).y

bot_x_circ = min(circles, key = lambda circ: circ.x - circ.rad)
bot_x = bot_x_circ.x - bot_x_circ.rad

bot_y_circ = min(circles, key = lambda circ: circ.y - circ.rad)
bot_y = bot_y_circ.y - bot_y_circ.rad

top_x_circ = max(circles, key = lambda circ: circ.x + circ.rad)
top_x = top_x_circ.x + top_x_circ.rad

# Extract the circle with highest distance from the x and y bounding circles
# We use the extreme circles to figure out where to render the image
highest_dist_circ = max(circles, key = lambda circ: sqrt((circ.x - bot_x)**2 + (circ.y-bot_y)**2))
highest_dist = sqrt((highest_dist_circ.x - bot_x)**2 + (highest_dist_circ.y - bot_y)**2)

# flip = False

# Calculate the color of each circle
for circ in circles:
	light = 0.5
	sat = 0.5
	
	# Hue is based on individual axis distance from the extreme circles
	hue = sqrt((circ.x - bot_x)**2 + (circ.y - bot_y)**2) / highest_dist
	
	# ...Plus a fudge factor of up to 25% of the RGB spectrum to either end
	hue += choice((-1, 1)) * random() * 0.25	
	
	# Calculate the actual RGB value from the HLS value
	# Sorry for the crazy map, but I love maps!
	rgb_list = map(lambda x: int(255 * x), colorsys.hls_to_rgb(hue, light, sat))	
	color = rgb_to_hex(rgb_list)
	
	# We're not going to render the huge circles this time.
	if(circ.depth > 2):
		svg.addElement(sb.createCircle((1.25*top_x - (circ.x - bot_x) if flip else circ.x - bot_x), circ.y - bot_y, circ.rad, strokewidth = 0, fill = color))
		# flip = not flip

# Hack fill opacity in because PySVG doesn't have it :(
xml = svg.getXML().replace("; \"", "; fill-opacity:0.75; \"")

# Write the file!
with open("angletree.svg", "w") as f:
	f.write(xml)

