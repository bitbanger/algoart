float rm(float n, float mag) {
  return random(n-mag, n+mag);
}

void drawRandBezVertex(float x, float y, float mag) {
  bezierVertex(rm(x,mag),
               rm(y,mag),
               rm(x,mag),
               rm(y,mag),
               rm(x,mag),
               rm(y,mag));
}

void drawBezStar(float x, float y, float size) {
  beginShape();
  vertex(x, y);
  drawRandBezVertex(x, y, size);
  drawRandBezVertex(x, y, size);
  endShape();
}

void drawCaterpillar(float red, float green, float blue) {
  float x2 = random(0, 512), y2 = random(0, 512), x3 = random(0, 512), y3 = random(0, 512);
  float x1, y1, x4, y4;
  if(random(1.0) < 0.5) {
    x1 = 0;
    y1 = random(512);
  }
  else {
    x1 = random(512);
    y1 = 0;
  }
  if(random(1.0) < 0.5) {
    x4 = 512;
    y4 = random(512);
  }
  else {
    x4 = random(512);
    y4 = 512;
  }
  
  // Tunables
  int steps = 20000;
  int sineSteps = 2000;
  float mag = 1.0;
  
  int dir = 1;
  for(int i = 0; i <= steps; ++i) {
    if(random(1.0) < 0.1 || (red+green+blue > 650) || (red+green+blue < 60)) {
      dir *= -1;
    }
    
    red += mag * dir;
    green += mag * dir;
    blue += mag * dir;
    fill(red, green, blue);
    
    float t = i / float(steps);
    float x = bezierPoint(x1, x2, x3, x4, t);
    float y = bezierPoint(y1, y2, y3, y4, t);
    drawBezStar(x, y, 20 * sin(((i%sineSteps) / float(sineSteps)) * PI));
  }
}

void setup() {
  background(255, 255, 255);
  size(512, 512);
  
  noStroke();
  
  int[] reds = {72, 216, 240, 240, 72, 240, 59, 255};
  int[] greens = {0, 72, 144, 168, 0, 192, 26, 213};
  int[] blues = {0, 48, 72, 96, 0, 96, 2, 0};
  
  for(int i = 0; i < reds.length; ++i) {
    drawCaterpillar(reds[i], greens[i], blues[i]);
  }
  
  save("autumn.png");
}

