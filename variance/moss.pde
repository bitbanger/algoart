import java.util.Iterator;

int xDim = 1440;
int yDim = 900;

int numCrackers = 10;

ArrayList<Cracker> crackers = new ArrayList<Cracker>();
ArrayList<Cracker> newCrackers = new ArrayList<Cracker>();

int numColors = 94000;
int colPtr = 0;
color[] colors = new color[numColors];

int[][] hit;

float ANG_VAR = 4;
float BRANCH_PROB = 1;

void setup() {
  int seed = int(random(10000));
  print(seed);
  
  randomSeed(seed);
  // randomSeed(659);
  // 4388 has a connected thing w/ branch prob 0.1, ang var 20deg
  // branch prob 1, ang var 1, seed 4388 is interesting
  // bp1, av10, s4388
  // bp0.2, av10, nc4, s9228
  // bp0.2, av10, nc4, s9288 is also cool
  // unless otherwise noted, all depths are 3
  
  // bp1, av4, nc3, s659, d6 is cool
  // bp1, av4, nc10, s83, d6
  
  size(xDim, yDim);
  background(0xFF, 0xFF, 0xFF);
  
  getImgColors("pol.png");
  
  color bgCol = color(0, 0, 0);
  bgCol = color(0xFF, 0xFF, 0xFF);
  fill(bgCol);
  rect(0, 0, xDim, yDim);
  
  hit = new int[xDim][yDim];
  for(int i = 0; i < xDim; ++i) {
    for(int j = 0; j < yDim; ++j) {
      hit[i][j] = 10001;
    }
  }
  
  for(int i = 0; i < numCrackers; ++i) {
    float x = random(xDim);
    float y = random(yDim);
    float v = 1.0;
    float theta = random(2*PI);
    float thetav = 1.0;
    
    Cracker c = new Cracker(x, y, v, theta, thetav, 6, 300);
    crackers.add(c);
  }
  
  /*for(int i = 0; i < numCrackers; ++i) {
    crackers.get(i).target = crackers.get((i+1)%crackers.size());
  }*/
}

void draw() {
  for(Iterator i = crackers.listIterator(); i.hasNext(); ) {
    Cracker c = (Cracker)i.next();
    if(c.life == 0) i.remove();
  }
  
  for(Cracker c : crackers) {
    c.move();
  }
  
  for(Cracker c : newCrackers) {
    crackers.add(c);
  }
  
  newCrackers.clear();
  
  // saveFrame();
}

/*void mouseClicked() {
  saveFrame();
}*/

color randColor() {
  return colors[int(random(colPtr-1))];
}

float ang(float t) {
  float n = t % 360;
  if(n < 0) return n + 360;
  return n;
}

// Crawl image for a color pool
// Idea from j tarbell
void getImgColors(String file) {
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
}

class Cracker {
  float x;
  float y;
  float v;
  float theta;
  float thetav;
  
  int lastX, lastY;
  
  float otheta;
  
  int life;
  
  int depth;
  
  color linec;
  
  Cracker target;
  
  Cracker(float x, float y, float v, float theta, float thetav, int depth, int life) {
    this.x = x;
    this.y = y;
    this.v = v;
    this.theta = theta;
    this.thetav = thetav;
    this.life = life;
    this.depth = depth;
    
    this.otheta = theta;
    
    float mag = random(100, 200);
    // this.linec = color(random(100, 200), random(100, 200), random(100, 200));
    this.linec = randColor();
  }
  
  void move() {
    /*float minT = (otheta-80) % 360;
    float maxT = (otheta+80) % 360;
    theta = max(minT, min(maxT, (theta+random(-5, 5)) % 360));*/
    theta = ang(theta+random(-ANG_VAR, ANG_VAR));
    
    x += v * cos(theta * PI/180);
    y += v * sin(theta * PI/180);
    
    if(x < 0 || x > xDim || y < 0 || y > yDim) {
      life = 0;
    }
    
    if(depth > 0 && random(1.0) < BRANCH_PROB && life > 0) {
      float ang = ang(otheta+CHILD_ANG);
      if(random(1.0) < 0.5) ang = (otheta-90)%360;
      Cracker child = new Cracker(x, y, 1.0, ang, 1.0, depth-1, int(life*0.25));
      child.lastX = lastX;
      child.lastY = lastY;
      newCrackers.add(child);
      
      // child.target = crackers.get(int(random(crackers.size())));
      child.target = this;
    }
    
    int nx = max(0, min(xDim-1, int(x)));
    int ny = max(0, min(yDim-1, int(y)));
    
    if(hit[nx][ny] > 10000 || abs(hit[nx][ny]-theta) < 5) {
    // if(hit[nx][ny] > 10000) {
      if(target != null && target.life > 0) {
        float dx = x-target.x;
        float dy = y-target.y;
        float dist = sqrt(dx*dx + dy*dy);
        
        if(dist < 200) {
          stroke(linec, 40 * (1 - dist*1.0/xDim));
          strokeWeight(2.5);
          float z = 0;
          fill(0, 0, 0, 0);
          float tx = min(x, target.x);
          float ty = min(y, target.y);
          float bx = max(x, target.x);
          float by = max(y, target.y);
          float w = bx-tx;
          float h = by-ty;
          
          float ang = atan2(dy, dx);
          
          // line(x, y, target.x, target.y);
          stroke(0, 0, 0, 80);
          strokeWeight(1);
          // point(x, y);
        }
        // point(x, y);
      }
      point(x, y);
      
      
      float mag = random(100, 256);
      
      /*if(target != null) {
        stroke(linec, 20);
        line(x, y, target.x, target.y);
      }*/
      
      /*if(random(1.0) < 0.1) {
        new Cell(nx, ny, depth+8, depth+4, theta);
        point(x, y);
      }*/
      
      
      hit[nx][ny] = int(theta);
    // } else if(nx != lastX && ny != lastY) {
    } else if(abs(hit[nx][ny]-theta) > 5) {
      life = 0;
    }
    
    lastX = nx;
    lastY = ny;
  }
}

