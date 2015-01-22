import java.util.Iterator;

final int M_CIRC = 0;
final int M_RECT = 1;
final int M_LINE = 2;

int mode = M_RECT;

int xDim = 1920;
int yDim = 1080;

float SCALE_FAC = 1;

int numCrackers = 0;

ArrayList<Cracker> crackers = new ArrayList<Cracker>();
ArrayList<Cracker> newCrackers = new ArrayList<Cracker>();

int numColors = 94000;
int colPtr = 0;
color[] colors = new color[numColors];

int[][] hit;

int NO_SEED = -1;

float ANG_VAR = 0;
float BRANCH_PROB = 0.1;
// float CHILD_ANG = random(-90, 90);
float CHILD_ANG_B1 = -90;
float CHILD_ANG_B2 = 90;
float LIFE_DECAY = 0.1;
float DIST_LIMIT = 100;
float COLLISION_IGNORE_RATE = 0;
float COL_VAR = 10;
float VEL = 1;
int LIFE = 100;
boolean LINEAGE_COLORING = true;
final float GHOST_DECAY = 50;
float ghostDecay = GHOST_DECAY;

int DEPTH = 1;
int COOLDOWN = 20;
int SEED = NO_SEED;

// BEAUTIFUL: 
// lineage color
// av1 bp0.3 cab190 cab290 ld0.5 dl100 cir 0 colv 10 vel1 life100 s9416 nc2 colpol,94kcol
// ... ellipse as dist alpha 1, line to target
// ALSO GOOD: same as above but w/ bp0.1, bp0.05

// colpol.png, av1, bp0.02, ca [-30, 30], d6, cd5, s8756 is awesome

boolean paused = false;

boolean sketchFullScreen() {
  return true;
}

void keyPressed() {
  switch(key) {
    case '1':
      mode = M_RECT;
      break;
    case '2':
      mode = M_CIRC;
      break;
    case '3':
      mode = M_LINE;
      break;
    case 't':
      ghostDecay = GHOST_DECAY - ghostDecay;
  }
}

void setup() {
  int seed = int(random(10000));
  println(seed);
  
  randomSeed(seed);
  
  frameRate(60);
  
  if(SEED != NO_SEED) {
    randomSeed(SEED);
    println("seeding w/ " + SEED);
  }
  // 4388 has a connected thing w/ branch prob 0.1, ang var 20deg
  // branch prob 1, ang var 1, seed 4388 is interesting
  // bp1, av10, s4388
  // bp0.2, av10, nc4, s9228
  // bp0.2, av10, nc4, s9288 is also cool
  // unless otherwise noted, all depths are 3
  // unless otherwise noted, all child angles are constant +90
  
  // bp1, av4, nc3, s659, d6 is cool
  // bp1, av4, nc10, s83, d6
  
  size(int(xDim*SCALE_FAC), int(yDim*SCALE_FAC));
  background(0xFF, 0xFF, 0xFF);
  
  getImgColors("pol.png");
  
  color bgCol = color(2, 2, 2);
  // bgCol = color(0xFF, 0xFF, 0xFF);
  fill(bgCol);
  rect(0, 0, int(xDim*SCALE_FAC), int(yDim*SCALE_FAC));
  
  hit = new int[xDim][yDim];
  for(int i = 0; i < xDim; ++i) {
    for(int j = 0; j < yDim; ++j) {
      hit[i][j] = 10001;
    }
  }
  
  for(int i = 0; i < numCrackers; ++i) {
    float x = random(xDim);
    float y = random(yDim);
    float v = VEL;
    float theta = random(2*PI);
    theta = 0;
    float thetav = 1.0;
    int life = LIFE;
    
    Cracker c = new Cracker(xDim/2, yDim/2, v, theta, thetav, DEPTH, life);
    c.myMode = mode;
    crackers.add(c);
  }
  
  /*for(int i = 0; i < numCrackers; ++i) {
    crackers.get(i).target = crackers.get((i+1)%crackers.size());
  }*/
}

void mouseClicked() {
  // paused = !paused;
}

float lastMX = 0;
float lastMY = 0;

void mouseDragged() {
  float theta = 0;
  if(lastMX != 0 && lastMY != 0) {
    float dx = lastMX - mouseX;
    float dy = lastMY - mouseY;
    theta = atan2(dy, dx) * 180/PI;
  }
  lastMX = mouseX;
  lastMY = mouseY;
  Cracker c = new Cracker(mouseX, mouseY, 1, theta, 0, 4, LIFE);
  c.myMode = mode;
  println(mode);
  newCrackers.add(c);
}

void draw() {
  // println(crackers.size());
  
  if(paused) return;
  
  scale(SCALE_FAC);
  
  if(mousePressed) {
    Cracker c = new Cracker(mouseX, mouseY, 1, 0, 0, 3, LIFE);
    c.myMode = mode;
    newCrackers.add(c);
  }
  
  fill(0, 0, 0, ghostDecay);
  rect(-1, -1, xDim, yDim);
  
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

float dist(Cracker a, Cracker b) {
  float dx = a.x - b.x;
  float dy = a.y - b.y;
  return sqrt(dx*dx + dy*dy);
}

class Cracker {
  float x;
  float y;
  float v;
  float theta;
  float thetav;
  
  int lastX, lastY;
  
  float otheta;
  
  float angVar;
  
  int life;
  
  int cooldown;
  
  int depth;
  
  color linec;
  
  int myMode;
  
  Cracker target;
  
  Cracker(float x, float y, float v, float theta, float thetav, int depth, int life) {
    this.x = x;
    this.y = y;
    this.v = v;
    this.theta = theta;
    this.thetav = thetav;
    this.life = life;
    this.depth = depth;
    
    this.angVar = ANG_VAR;
    
    this.cooldown = COOLDOWN;
    
    this.otheta = theta;
    
    this.myMode = M_RECT;
    
    float mag = random(100, 200);
    // this.linec = color(random(100, 200), random(100, 200), random(100, 200));
    this.linec = randColor();
  }
  
  void move() {
    if(life <= 0) return;
    // --life;
    /*float minT = (otheta-80) % 360;
    float maxT = (otheta+80) % 360;
    theta = max(minT, min(maxT, (theta+random(-5, 5)) % 360));*/
    theta = ang(theta+random(-angVar, angVar));
    // theta = ang(theta+angVar);
    
    x += v * cos(theta * PI/180);
    y += v * sin(theta * PI/180);
    
    if(x < 0 || x > xDim || y < 0 || y > yDim) {
      life = 0;
    }
    
    if((depth > 0 && random(1.0) < BRANCH_PROB && life > 0)) {
      float ang = ang(otheta+random(CHILD_ANG_B1, CHILD_ANG_B2));
      if(random(1.0) < 0.5) ang = (otheta-90)%360;
      Cracker child = new Cracker(x, y, v, ang, 1.0, depth-1, int(life*LIFE_DECAY));
      child.lastX = lastX;
      child.lastY = lastY;
      child.myMode = myMode;
      
      if(LINEAGE_COLORING) {
        float d = COL_VAR;
        float red = constrain(red(linec)+random(-d, d), 0, 0xFF);
        float green = constrain(green(linec)+random(-d, d), 0, 0xFF);
        float blue = constrain(blue(linec)+random(-d, d), 0, 0xFF);
        child.linec = color(red, green, blue);
      } else {
        child.linec = randColor();
      }
      
      newCrackers.add(child);
      
      // child.target = crackers.get(int(random(crackers.size())));
      child.target = this;
    }
    
    int nx = max(0, min(xDim-1, int(x)));
    int ny = max(0, min(yDim-1, int(y)));
    
    float dist = 1.0;
    if(cooldown > 0 || false && (hit[nx][ny] > 10000 || abs(hit[nx][ny]-theta) < 5)) {
      if(cooldown > 0) --cooldown;
    // if(hit[nx][ny] > 10000) {
      // if(target != null && target.life > 0) {
      if(target != null) {
        float dx = x-target.x;
        float dy = y-target.y;
        dist = sqrt(dx*dx + dy*dy);
        
        if(dist < DIST_LIMIT) {
          stroke(linec, 40 * (1 - dist*1.0/DIST_LIMIT));
          // stroke(0, 0, 0, 0);
          // fill(linec, 40 * (1 - dist*1.0/DIST_LIMIT));
          strokeWeight(1.5);
          float z = 0;
          // fill(0, 0, 0, 0);
          float tx = min(x, target.x);
          float ty = min(y, target.y);
          float bx = max(x, target.x);
          float by = max(y, target.y);
          float w = bx-tx;
          float h = by-ty;
          
          float ang = atan2(dy, dx);
          
          float d = 1;
          // line(x, y, target.x, target.y);
          // stroke(linec, 256);
          rectMode(CORNERS);
          // rect(x, y, target.x, target.y);
          
          switch(myMode) {
            case M_LINE:
              line(x+random(-d, d), y+random(-d, d), target.x+random(-d, d), target.y+random(-d, d));
              // bezier(x, y, x+random(-d, d), y+random(-d, d), target.x+random(-d, d), target.y+random(-d, d), target.x, target.y);
              break;
            case M_RECT:
              rect(x, y, target.x, target.y);
              break;
            case M_CIRC:
              ellipse(x, y, dist, dist);
              break;
          }
          
          // bezier(x, y, x+random(-d, d), y+random(-d, d), target.x+random(-d, d), target.y+random(-d, d), target.x, target.y);
          // point(x, y);
          
          /*line(target.x, target.y, x, target.y);
          line(target.x, target.y, target.x, y);
          line(x, y, target.x, y);
          line(x, y, x, target.y);*/
          
          stroke(0, 0, 0, 0);
          fill(linec, 1);
          // ellipse(x, y, DIST_LIMIT/dist, DIST_LIMIT/dist);
          stroke(0, 0, 0, 80);
          strokeWeight(1);
        }
      }
      // fill(linec, 255);
      stroke(linec, 40);
      // point(x, y);
      // float m = constrain(10.0/dist, 0.1, 10.0);
      // ellipse(x, y, m, m);
      
      
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
    } else if(random(1.0) > COLLISION_IGNORE_RATE && abs(hit[nx][ny]-theta) > 5) {
      life = 0;
    }
    
    lastX = nx;
    lastY = ny;
  }
}

