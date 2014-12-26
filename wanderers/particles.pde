int dim = 700;

int numWanderers = 250;
int numColors = 2048;
int colPtr = 0;

color[] colors = new color[numColors];

ArrayList<Wanderer> wanderers = new ArrayList<Wanderer>();

boolean paused = true;

void setup() {
  size(dim, dim);
  background(0xFF, 0xFF, 0xFF);
  getImgColors("pollockShimmering.jpg");
  
  fill(0xFF, 0xFF, 0xFF);
  rect(0, 0, dim, dim);
  
  for(int i = 0; i < numWanderers; ++i) {
    // Initial placement in polar coordinates for circular boundaries
    /*float prad = sqrt(random(1.0)) * (dim*1.0/2);
    float pang = random(1.0) * (2 * PI);
    float x = dim*1.0/2 + prad * cos(pang);
    float y = dim*1.0/2 + prad * sin(pang);*/
    
    // Initial placement in Cartesian coordinates for rectangular boundaries
    float x = random(dim);
    float y = random(dim);
    
    wanderers.add(new Wanderer(randColor(), x, y, random(360), 1));
  }
  
  for(int i = 0; i < numWanderers; ++i) {
    // For some reason, no point convergence occurs unless we randomize targets
    // I think it's because someone needs to get themselves, but that seems unlikely to happen every time?
    wanderers.get(i).target = wanderers.get(int(random(wanderers.size())));
    // wanderers.get(i).target = wanderers.get((i+1) % wanderers.size());
  }
}

void draw() {
  // Stepwise canvas blanking to see only most recent lines
  // Alternatively, lower alpha value of 256 to have lines "fade" over time. I like 50
  /*fill(0xFF, 0xFF, 0xFF, 50);
  rect(0, 0, dim, dim);*/
  
  if(!paused) {
    for(Wanderer f : wanderers) {
      f.move();
      saveFrame();
    }
  }
}

void mousePressed() {
  paused = !paused;
}

color randColor() {
  return colors[int(random(colors.length))];
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

class Wanderer {
  color c;
  float x, y;
  float theta;
  float vel;
  Wanderer target;
  
  Wanderer(color c, float x, float  y, float theta, float vel) {
    this.c = c;
    this.x = x;
    this.y = y;
    this.theta = theta;
    this.vel = vel;
  }
  
  void move() {
    // Calculate angle to target
    float tdx = target.x - this.x;
    float tdy = target.y - this.y;
    float ttheta = atan2(tdy, tdx) * 180/PI;
    
    // Move toward target
    x += vel * cos(ttheta * PI/180);
    y += vel * sin(ttheta * PI/180);
    
    // Stay within frame, even if it means teleporting :)
    if(x <= 0 || x >= dim) {
      /*Wanderer w = new Wanderer(0xFF, random(dim), random(dim), 0.0, 0.0);
      Wanderer v = new Wanderer(0xFF, x, y, 0.0, vel-2);
      v.target = w;
      this.target = v;*/
      x = dim - x;
    }
    if(y <= 0 || y >= dim) {
      /*Wanderer w = new Wanderer(0xFF, random(dim), random(dim), 0.0, 0.0);
      Wanderer v = new Wanderer(0xFF, x, y, 0.0, vel-2);
      v.target = w;
      this.target = v;*/
      y = dim - y;
    }
    
    // Try to keep lines drawn at reasonable sizes
    float targetDist = sqrt(tdx*tdx + tdy*tdy);
    if(targetDist <= dim*0.75 && targetDist > 5) {
      stroke(c, 30);
      line(x, y, target.x, target.y);
    }
  }
}

