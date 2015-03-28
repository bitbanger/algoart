import java.util.Iterator;

int xDim = 800;
int yDim = 800;

int numCrackers = 10;

ArrayList<Cracker> crackers = new ArrayList<Cracker>();
ArrayList<Cracker> newCrackers = new ArrayList<Cracker>();

int numColors = 94000;
int colPtr = 0;
color[] colors = new color[numColors];

int[][] hit;

int NO_SEED = -1;

float ANG_VAR = 10;
float BRANCH_PROB = 0.01;
// float CHILD_ANG = random(-90, 90);
float CHILD_ANG_B1 = 90;
float CHILD_ANG_B2 = 90;
float LIFE_DECAY = 0.5;
float DIST_LIMIT = 100;
float COLLISION_IGNORE_RATE = 1.0;
float COL_VAR = 20;
float VEL = 1;
int LIFE = 10000;
boolean LINEAGE_COLORING = false;

int DEPTH = 6;
int COOLDOWN = 10;
int SEED = 9416;

float bhX = xDim*1.0/2;
float bhY = yDim*1.0/2;

// BEAUTIFUL: 
// lineage color
// av1 bp0.3 cab190 cab290 ld0.5 dl100 cir 0 colv 10 vel1 life100 s9416 nc2 colpol,94kcol
// ... ellipse as dist alpha 1, line to target
// ALSO GOOD: same as above but w/ bp0.1, bp0.05

// colpol.png, av1, bp0.02, ca [-30, 30], d6, cd5, s8756 is awesome

boolean paused = false;

float pareto(float min, float max, float alpha) {
  return min(max, min / pow(random(1), 1.0/alpha));
}

void setup() {
  int seed = int(random(10000));
  println(seed);
  
  bhX = xDim*1.0/2 + random(-100, 100);
  bhY = yDim*1.0/2 + random(-100, 100);
  
  randomSeed(seed);
  
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
  
  size(xDim, yDim);
  background(0xFF, 0xFF, 0xFF);
  
  frameRate(1200);
  
  getImgColors("pol.png");
  
  color bgCol = color(0, 0, 0);
  // bgCol = color(0xFF, 0xFF, 0xFF);
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
    
    // polar random x, y
    /*float prad = sqrt(random(1.0)) * 10;
    float pang = random(1.0) * (2 * PI);
    x = xDim*1.0/2 + prad * cos(pang);
    y = xDim*1.0/2 + prad * sin(pang);*/
    
    float v = VEL;
    float theta = random(2*PI);
    float thetav = 1.0;
    int life = LIFE;
    
    Cracker c = new Cracker(x, y, v, theta, thetav, DEPTH, life);
    crackers.add(c);
  }
  
  /*for(int i = 0; i < numCrackers; ++i) {
    crackers.get(i).target = crackers.get((i+1)%crackers.size());
  }*/
}

void mouseClicked() {
  paused = !paused;
}

void draw() {
  if(paused) return;
  
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
  
  float angVar;
  
  int life;
  
  int cooldown;
  
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
    
    this.angVar = ANG_VAR;
    
    this.cooldown = COOLDOWN;
    
    this.otheta = theta;
    
    float mag = random(100, 200);
    // this.linec = color(random(100, 200), random(100, 200), random(100, 200));
    this.linec = randColor();
  }
  
  void move() {
    /*float minT = (otheta-80) % 360;
    float maxT = (otheta+80) % 360;
    theta = max(minT, min(maxT, (theta+random(-5, 5)) % 360));*/
    theta = ang(theta+random(-angVar, angVar));
    
    x += v * cos(theta * PI/180);
    y += v * sin(theta * PI/180);
    
    if(life > 0) --life;
    
    if(x < 0 || x > xDim || y < 0 || y > yDim) {
      life = 0;
    }
    
    if((depth > 0 && random(1.0) < BRANCH_PROB && life > 0)) {
      float ang = ang(otheta+random(CHILD_ANG_B1, CHILD_ANG_B2));
      if(random(1.0) < 0.5) ang = (otheta-90)%360;
      Cracker child = new Cracker(x, y, v, ang, 1.0, depth-1, int(life*LIFE_DECAY));
      child.lastX = lastX;
      child.lastY = lastY;
      
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
    
    if(true || cooldown > 0 || (hit[nx][ny] > 10000 || abs(hit[nx][ny]-theta) < angVar*1.1)) {
      if(cooldown > 0) --cooldown;
    // if(hit[nx][ny] > 10000) {
      // if(target != null && target.life > 0) {
      if(target != null && target.life > 0) {
        float dx = x-target.x;
        float dy = y-target.y;
        float dist = sqrt(dx*dx + dy*dy);
        
        if(true || dist < DIST_LIMIT) {
          // stroke(linec, 40 * (1 - dist*1.0/DIST_LIMIT));
          float dcx = abs(bhX - x);
          float dcy = abs(bhY - y);
          float distc = sqrt(dcx*dcx + dcy*dcy) + random(-10, 10);
          stroke(linec, 20 * distc/(xDim*1.0/2));
          strokeWeight(1.5);
          float z = 0;
          fill(0, 0, 0, 0);
          float tx = min(x, target.x);
          float ty = min(y, target.y);
          float bx = max(x, target.x);
          float by = max(y, target.y);
          float w = bx-tx;
          float h = by-ty;
          
          float ang = atan2(dy, dx);
          
          float d = 1;
          // line(x, y, target.x, target.y);
          // line(x+random(-d, d), y+random(-d, d), target.x+random(-d, d), target.y+random(-d, d));
          // bezier(x, y, x+random(-d, d), y+random(-d, d), target.x+random(-d, d), target.y+random(-d, d), target.x, target.y);
          point(x, y);
          stroke(0, 0, 0, 0);
          fill(linec, 2);
          // ellipse(x, y, DIST_LIMIT/dist, DIST_LIMIT/dist);
          stroke(0, 0, 0, 80);
          strokeWeight(1);
        }
      }
      // stroke(linec, 80);
      // point(x, y);
      
      
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
    } else if(abs(hit[nx][ny]-theta) > angVar*1.1) {
      // life = 0;
    }
    
    lastX = nx;
    lastY = ny;
  }
}

