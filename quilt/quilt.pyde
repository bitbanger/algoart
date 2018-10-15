import time
import traceback

x_dim = 800
y_dim = 800

initial_pop = 4
max_depth = 7
branch = 20
child_size_mult = 0.8
red_mutate = 40
green_mutate = 40
blue_mutate = 40

num = 0

class Square:

    def __init__(self, x, y, size, col):
        global num

        self.num = num
        num += 1
        self.x = x
        self.y = y
        self.size = size
        self.col = col
        self.weight = 1.0
        self.depth = 0
        
        self.child_idx = 0
        self.done_children = set()

        self.drawn = False
        
        self.drawing = True

        self.child_size = size
        self.children = []

    def add_child(self):
        if self.depth >= max_depth:
            return

        self.depth += 1

        for child in self.children:
            child.add_child()

        for _ in xrange(branch):
            child_x = self.x
            child_y = self.y
            if random(1.0) < 0.5:
                child_x += self.size
                child_x -= self.child_size
            if random(1.0) < 0.5:
                child_y += self.size
                child_y -= self.child_size
                
            
            red_mut = random(-red_mutate, red_mutate)
            green_mut = random(-green_mutate, green_mutate)
            blue_mut = random(-blue_mutate, blue_mutate)
            new_red = min(160, max(red(self.col) + red_mut, 0))
            new_green = min(160, max(green(self.col) + green_mut, 0))
            new_blue = min(160, max(blue(self.col) + blue_mut, 0))
            child = Square(child_x, child_y, self.child_size, color(new_red, new_green, new_blue))
            child.weight = random(0, 2.0)
            self.children.append(child)
            self.child_size *= child_size_mult


    def make_rect(self):
        if not self.drawn:
            strokeWeight(1)
            stroke(self.col, 128)
            fill(0xFF, 0xFF, 0xFF, random(10, 20))
            
            # rect(self.x, self.y, self.size, self.size, 3)
            ellipse(self.x+self.size*1.0/2, self.y+self.size*1.0/2, self.size, self.size)
            
            self.drawn = True

    def dfs_draw(self):
        for child in self.children:
            for d in child.draw(bfs=False):
                yield d
        
        self.make_rect()
        
        yield None
        

    def bfs_draw(self):
        while True:
            if len(self.children) == 0:
                yield None
                continue
            
            child = self.children[self.child_idx]
            
            try:
                next(child.draw(bfs=True))
            except:
                pass
            
            self.child_idx = (self.child_idx+1)%len(self.children)
            
            self.make_rect()
            
            yield None
    
    def draw(self, bfs=False):
        if bfs:
            return self.bfs_draw()
        else:
            return self.dfs_draw()

root = Square(0, 0, x_dim, color(0xFF, 0xFF, 0xFF))

setup_done = False
genny = None

def setup():
    global setup_done
    global genny

    size(x_dim, y_dim)
    fill(0xFF, 0xFF, 0xFF, 60)

    for i in xrange(initial_pop):
        root.add_child()

    print("done with setup")
    setup_done = True
    genny = root.draw(bfs=False)


done = 0

def draw():
    global setup_done
    global done
    global genny

    if setup_done and done == 0:
        try:
            next(genny)
        except:
            if done < 1:
                done += 1
                print "done with drawing"
