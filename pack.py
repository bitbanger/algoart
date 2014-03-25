from math import *
from random import randint, random

import Image, ImageDraw

grace_border = 0
img_dim = (1024, 1024)
img_height = img_dim[0]
img_width = img_dim[1]

img_xmid = img_width/2
img_ymid = img_height/2

min_circ_rad = 150
max_circ_rad = 250

class Circle:
	__slots__ = ('x', 'y', 'rad', 'neighbors')
	def __init__(self, x, y, rad):
		self.x = x
		self.y = y
		self.rad = rad
		self.neighbors = 0

def draw_circle(x, y, rad, draw, color = "black"):
	draw.ellipse((x - rad, y - rad, x + rad, y + rad), fill = color)

def coll_dist(c1, c2):
	return sqrt((c1.x - c2.x)**2 + (c1.y - c2.y)**2) - (c1.rad + c2.rad)

def colliding(c1, c2):
	return coll_dist(c1, c2) < 0

# The radius c1 needs to be to kiss c2
def kiss_dist(c1, c2):
	return sqrt((c1.x - c2.x)**2 + (c1.y - c2.y)**2) - c2.rad

def point_in_circ(x, y, c):
	return sqrt((x - c.x)**2 + (y - c.y)**2) <= c.rad

def rand_color():
	return (randint(0, 256), randint(0, 256), randint(0, 256))

def rand_in_circle(x, y, rad):
	# First, generate random polar coordinates
	prad = random() * rad
	pang = random() * (2 * pi)
	
	px = prad * cos(pang)
	py = prad * sin(pang)
	
	return (px, py)
	

im = Image.new("RGB", img_dim, "white")

draw = ImageDraw.Draw(im)

# start coming up with circles

num_circles = 2000
circles = []

for i in range(num_circles):
	crand = rand_in_circle(img_xmid, img_ymid, img_xmid)
	x = crand[0] + img_xmid
	y = crand[1] + img_xmid
	# x = randint(grace_border, img_dim[0] - grace_border + 1)
	# y = randint(grace_border, img_dim[1] - grace_border + 1)
	while any([point_in_circ(x, y, c) for c in circles]):
		crand = rand_in_circle(img_xmid, img_ymid, img_xmid)
		x = crand[0] + img_xmid
		y = crand[1] + img_xmid

	max = randint(min_circ_rad, max_circ_rad)
	circ = Circle(x, y, max)
	
	min_dist = 1000000
	min_c = None
	for c in circles:
		cd = coll_dist(circ, c)
		if cd >= 0:
			continue
		circ.neighbors += 1
		if coll_dist(circ, c) < min_dist:
			min_dist = coll_dist(circ, c)
			min_c = c
	
	#if len(colliding) > 0:
	#	print "collided with " + str(len(colliding))
	
	if min_dist < 0:
		circ.rad = kiss_dist(circ, min_c)
	
	circles.append(circ)


# Note: put circles in big circles, see if perception is maintained?

max_neighbors = 0
for circ in circles:
	if circ.neighbors > max_neighbors:
		max_neighbors = circ.neighbors

for circ in circles:
	# The darkness is partially determined by its neighbors
	clr1 = 240 - int((float(circ.neighbors) / max_neighbors) * 240)
	# The other part is determined by its size
	clr2 = int((float(circ.rad) / max_circ_rad) * 15)
	
	clr = clr1 + clr2
	
	draw_circle(circ.x, circ.y, circ.rad - 1, draw, color = (clr, clr, clr))

# print ["%d, %d, %d" % (c.x, c.y, c.rad) for c in circles]


im.save("pack.png", "PNG")
