int dim = 800;

int numCircles = 30;

ArrayList<Circle> circles = new ArrayList<Circle>();

int numColors = 5000;
int colPtr = 0;
color[] colors = new color[numColors];

boolean paused = false;

void setup() {
  int seed = int(random(10000));
  print(seed);
  randomSeed(seed);
  randomSeed(5714);
  
  frameRate(60 * 14);
  
  size(dim, dim);
  background(0xFF, 0xFF, 0xFF);
  
  getImgColors("colors.png");
  fill(0xFF, 0xFF, 0xFF);
  // fill(0, 0, 0);
  rect(0, 0, dim, dim);
  
  for(int i = 0; i < numCircles; ++i) {
    float x = random(dim);
    float y = random(dim);
    float v = 1;
    float rad = 150;
    float theta = random(360);
    float thetav = 0.0;
    float alpha = 1;
    // color col = color(random(100, 200), random(100, 200), random(100, 200));
    color col = randColor();
    if(random(1.0) < 0.5) {
      // rad = 100;
      // col = color(0xFF, 0xFF, 0xFF);
      // alpha = 256;
    }
    
    Circle c = new Circle(x, y, rad, v, theta, thetav, col, alpha);
    circles.add(c);
  }
}

void draw() {
  if(!paused) {
    fill(0xFF, 0xFF, 0xFF, 256);
    // rect(0, 0, dim, dim);
    
    for(Circle c : circles) {
      c.draw();
    }
  }
}

void mousePressed() {
  paused = !paused;
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

class Circle {
  float x;
  float y;
  float v;
  
  float theta;
  float thetav;
  
  float rad;
  
  color col;
  
  float alpha;
  
  int cooldown;
  
  Circle(float x, float y, float rad, float v, float theta, float thetav, color col, float alpha) {
    this.x = x;
    this.y = y;
    this.rad = rad;
    this.v = v;
    this.theta = theta;
    this.thetav = thetav;
    this.col = col;
    this.alpha = alpha;
    
    float mag = random(256);
  }
  
  void draw() {
    float xprime = x;
    float yprime = y;
    
    xprime += v * cos(theta * PI/180);
    yprime += v * sin(theta * PI/180);
    
    stroke(0, 0, 0, 0);
    fill(0, 0, 0, 256);
    
    // ellipse(x, y, rad*2, rad*2);
    
    for(Circle c : circles) {
      if(c == this) continue;
      
      float dx = x-c.x;
      float dy = y-c.y;
      float dist = sqrt(dx*dx + dy*dy);
      
      float maxDist = rad+c.rad;
      
      if(dist < maxDist) {
        // move away
        float ang = (atan2(dy, dx) * 180/PI) % 360;
        float vel = 0.3;
        xprime += vel * cos(ang * PI/180);
        yprime += vel * sin(ang * PI/180);
        
        
        // change direction
        float distRel = 1.5 - dist*1.0/maxDist;
        float distInv = 1.5 * dist*1.0/maxDist;
        
        // fill(0xFF * distRel, 0xB7 * distRel, 0xC5 * distRel, 10);
        // col = color(256*distInv, 256*distInv, 256*distInv);
        // stroke(0, 0, 0, 10);
        
        
        // ellipse(x+dx*1.0/2, y+dy*1.0/2, rad*distRel, rad*distRel);
        //fill(0xFF, 0xFF, 0xFF, 256);
        //stroke(0, 0, 0, 0);
        
        stroke(col, alpha);
        strokeWeight(3);
        // ellipse(x+dx*1.0/2, y+dy*1.0/2, rad, rad);
        // strokeWeight(3 * distRel);
        // stroke(col, alpha);
        line(x, y, c.x, c.y);
        // point(x, y);
        
        
        // theta = (theta+1) % 360;
        // theta = (theta+1) % 360;
      }
      
      /*if(xprime < 0 || x > dim || y < 0 || y > dim) {
        theta = (theta+90+random(-15, 15)) % 360;
      }*/
      
      xprime = max(0, min(dim, xprime));
      yprime = max(0, min(dim, yprime));
      
      x = xprime;
      y = yprime;
    }
  }
}

