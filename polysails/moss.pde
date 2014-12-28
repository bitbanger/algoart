import java.util.Iterator;

int dim = 800;

int numCrackers = 8;

ArrayList<Cracker> crackers = new ArrayList<Cracker>();
ArrayList<Cracker> newCrackers = new ArrayList<Cracker>();

int numColors = 5000;
int colPtr = 0;
color[] colors = new color[numColors];

int[][] hit;

void setup() {
  int seed = int(random(10000));
  print(seed);
  
  randomSeed(seed);
  randomSeed(4388);
  
  size(dim, dim);
  background(0xFF, 0xFF, 0xFF);
  
  getImgColors("colors.png");
  
  fill(0xFF, 0xFF, 0xFF);
  rect(0, 0, dim, dim);
  
  hit = new int[dim][dim];
  for(int i = 0; i < dim; ++i) {
    for(int j = 0; j < dim; ++j) {
      hit[i][j] = 10001;
    }
  }
  
  for(int i = 0; i < numCrackers; ++i) {
    float x = random(dim);
    float y = random(dim);
    float v = 1.0;
    float theta = random(2*PI);
    float thetav = 1.0;
    
    Cracker c = new Cracker(x, y, v, theta, thetav, 3, 300);
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
  
  saveFrame();
}

color randColor() {
  return colors[int(random(colPtr-1))];
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
    float minT = (otheta-10) % 360;
    float maxT = (otheta+10) % 360;
    theta = max(minT, min(maxT, (theta+random(-5, 5)) % 360));
    
    x += v * cos(theta * PI/180);
    y += v * sin(theta * PI/180);
    
    if(x < 0 || x > dim || y < 0 || y > dim) {
      life = 0;
    }
    
    if(depth > 0 && random(1.0) < 0.01) {
      float ang = (otheta+90)%360;
      if(random(1.0) < 0.5) ang = (otheta-90)%360;
      Cracker child = new Cracker(x, y, 1.0, ang, 1.0, depth-1, int(life*0.25));
      newCrackers.add(child);
      
      // child.target = crackers.get(int(random(crackers.size())));
      child.target = this;
    }
    
    int nx = max(0, min(dim-1, int(x)));
    int ny = max(0, min(dim-1, int(y)));
    
    if(hit[nx][ny] > 10000 || abs(hit[nx][ny]-otheta) < 5) {
      
      if(target != null && target.life > 0) {
        float dx = x-target.x;
        float dy = y-target.y;
        float dist = sqrt(dx*dx + dy*dy);
        
        if(dist < 200) {
          stroke(linec, 40 * (1 - dist*1.0/dim));
          strokeWeight(2.5);
          float z = 0;
          line(x, y, target.x+random(-z,z), target.y+random(-z,z));
          stroke(0, 0, 0, 80);
          strokeWeight(1);
          point(x, y);
        }
      }
      
      
      float mag = random(100, 256);
      
      /*if(target != null) {
        stroke(linec, 20);
        line(x, y, target.x, target.y);
      }*/
      
      /*if(random(1.0) < 0.1) {
        new Cell(nx, ny, depth+8, depth+4, theta);
        point(x, y);
      }*/
      
      
      hit[nx][ny] = int(otheta);
    } else if(abs(hit[nx][ny]-otheta) > 2) {
      life = 0;
    }
  }
}

