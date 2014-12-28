import java.util.Iterator;

int dim = 800;

int numInitPavers = 10;

int numColors = 8000;

color[] colors = new color[numColors];
int colPtr = 0;

ArrayList<Paver> pavers = new ArrayList<Paver>();
ArrayList<Paver> newPavers = new ArrayList<Paver>();

int[][] hit;

void setup() {
  randomSeed(43645);
  
  size(dim, dim);
  background(0xFF, 0xFF, 0xFF);
  
  getImgColors("stripes.png");
  
  fill(0xFF, 0xFF, 0xFF);
  rect(0, 0, dim, dim);
  
  hit = new int[dim][dim];
  for(int i = 0; i < dim; ++i) {
    for(int j = 0; j < dim; ++j) {
      hit[i][j] = 10001;
    }
  }
  
  for(int i = 0; i < numInitPavers; ++i) {
    Paver p = new Paver(random(dim), random(dim), random(360), 1, 800, 6);
    p.pcolor = randColor(0);
    pavers.add(p);
  }
}

void draw() {
  // Reap dead pavers
  for(Iterator i = pavers.listIterator(); i.hasNext(); ) {
    Paver p = (Paver)i.next();
    if(p.life == 0) i.remove();
  }
  
  // Draw an iteration
  for(Paver p : pavers) {
    p.move();
  }
  
  // Transfer new children to paver list
  for(Paver p : newPavers) {
    pavers.add(p);
  }
  
  newPavers.clear();
  
  // saveFrame();
}

color randColor(int colGroup) {
  return colors[int(random(colPtr))];
}

// Crawl image for a color pool
// Idea from j tarbell
color[] getImgColors(String file) {
  PImage img = loadImage(file);
  image(img, 0, 0);
  
  trucking:
  for(int i = 0; i < img.width; ++i) {
    for(int j = 0; j < img.height; ++j) {
      color col = get(i, j);
      
      // Is this a unique color?
      for(int k = 0; k < colPtr; ++k) {
        if(colors[k] == col) {
          continue trucking; // :)
        }
      }
      
      // Add it to the pool
      if(colPtr < colors.length) {
        colors[colPtr] = col;
        ++colPtr;
      }
    }
  }
  
  return colors;
}

class Paver {
  color c = color(0xFF, 0xFF, 0xFF);
  float a;
  float w;
  
  float x;
  float y;
  float theta;
  float vel;
  
  int life;
  
  boolean painter;
  
  int depth;
  
  Paver parent;
  
  ArrayList<Paver> children;
  
  color pcolor;
  
  Paver(float x, float y, float theta, float vel, int life, int depth) {
    this.c = color(0x00, 0x00, 0x00);
    this.a = 256;
    this.w = 1.2;
    
    this.x = x;
    this.y = y;
    this.theta = theta;
    this.vel = vel;
    
    this.life = life;
    
    this.depth = depth;
    
    children = new ArrayList<Paver>();
  }
  
  Paver mostRecentChild() {
    if(children.size() == 0) return null;
    
    synchronized(children) {
      return children.get(children.size()-1);
    }
  }
  
  void move() {
    if(life > 0) {
      x += vel * cos(theta * PI/180);
      y += vel * sin(theta * PI/180);
      
      float z = 0.33;
      
      int nx = max(0, min(dim-1, int(x+random(-z,z))));
      int ny = max(0, min(dim-1, int(y+random(-z,z))));
      
      if(hit[nx][ny] > 10000 || abs(hit[nx][ny]-theta) < 5) {
        strokeWeight(w);
        stroke(c, a);
        point(x, y);
        
        hit[nx][ny] = int(theta);
      } else if(abs(hit[nx][ny]-theta) > 2) {
        life = 0;
        return;
      }
      
      // Always paint
      if(depth <= 2 && !painter) {
        Paver painter = new Paver(x, y, (theta+90)%360, 0.4, int(random(20, 30)), 0);
        painter.painter = true;
        // painter.c = randColor(colGroup);
        // painter.c = color(random(256), random(256), random(256));
        painter.c = pcolor;
        painter.a = 45;
        painter.w = 2;
        newPavers.add(painter);
      }
      
      // Sometimes branch
      if(random(1.0) < 0.1 && depth > 0) {
        float newTheta = (theta+90)%360;
        if(random(1.0) < 0.5) newTheta = (theta-90)%360;
        Paver child = new Paver(x, y, newTheta, vel, int(life * 0.4), depth-1);
        child.pcolor = pcolor;
        child.parent = mostRecentChild();
        newPavers.add(child);
        
        synchronized(children) {
          children.add(child);
        }
      }
      
      --life;
    }
  }
}
