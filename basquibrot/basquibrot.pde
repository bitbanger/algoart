
int dim = 1000;
int check_until = 10;

float zoom = 200.0;
float dimScale = (4.0/dim)/zoom;

float cx = -0.425;
float cy = -0.01;

boolean colored[][] = new boolean[dim][dim];
int numColors = 2048;
int colPtr = 0;

color[] colors = new color[numColors];

void setup(){
 size(dim, dim, P2D);
// colorMode(HSB);
 noLoop();
 
 getImgColors("basquiat.jpg");
 background(0x00, 0x00, 0x00);
}

void draw(){
    
for (int x = 0; x < dim; x++){
  for (int y = 0; y < dim; y++){
    if (colored[x][y] == false){  
      float zx0 = (x - (dim/2.0))/zoom;
      float zy0 = (y - (dim/2.0))/zoom;
      
      float zx1 = zx0*zx0 - zy0*zy0 + zx0;
      float zy1 = 2*zx0*zy0 + zy0;
      int x1 = (int)(zx1*zoom + (dim/2.0));
      int y1 = (int)(zy1*zoom + (dim/2.0));
      
      float zx2 = zx1*zx1 - zy1*zy1 + zx0;
      float zy2 = 2*zx1*zy1 + zy0;
      int x2 = (int)(zx2*zoom + (dim/2.0));
      int y2 = (int)(zy2*zoom + (dim/2.0));
      
      float zx3 = zx2*zx2 - zy2*zy2 + zx0;
      float zy3 = 2*zx2*zy2 + zy0;
      int x3 = (int)(zx3*zoom + (dim/2.0));
      int y3 = (int)(zy3*zoom + (dim/2.0));
      
      color c = randColor();
      
      
      if( zx3*zx3 + zy3*zy3 < 4 ){
        stroke(c, 125);
        bezier(x, y, x1, y1, x2, y2, x3, y3);  
        colored[x][y] = true;
        colored[x1][y1] = true;
        colored[x2][y2] = true;
        colored[x3][y3] = true;
      }
      
      else if (zx2*zx2 + zy2*zy2 < 4){
        stroke(c, 80);
        bezier(x, y, x1, y1, x2, y2, floor(dim/2), floor(dim/2));
        colored[x][y] = true;
        colored[x1][y1] = true;
        colored[x2][y2] = true;
      }
      else if (zx1*zx1 + zy1*zy1 < 4){
        stroke(c, 80);
        noFill();
        ellipse( (x+x1)/2, (y+y1)/2, x1 - x, y1 - y); 
        colored[x][y] = true;
        colored[x1][y1] = true;
      }
      
    }
  }
}
save("basquibrot.png");
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

