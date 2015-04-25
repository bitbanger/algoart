
int numColors = 2048;
int colPtr = 0;

color[] colors = new color[numColors];

int colorconst = 25;
int dim = 600;
int check_until = 2000;

float zoom = 270;
float dimScale = (4.0/dim)/zoom;

boolean[][] colored = new boolean[dim][dim];
float cx = -0.425;
float cy = -0.01;


void setup(){
 size(dim + 150, dim + 150, P2D);
 background(0xFF, 0xFF, 0xFF);
 
colorMode(HSB);
//getImgColors("cezanne.jpg");
 for (int x = 0; x < dim; x++){
  for (int y = 0; y < dim; y++){
   colored[x][y] = false;
  } 
 }
}

void draw(){
    
for (int x = 0; x < dim; x++){
  for (int y = 0; y < dim; y++){
      double scaledx = (x - (dim/1.3))/zoom;
      double scaledy = (y - (dim/2.0))/zoom;
      double zx = 0;
      double zy = 0;
      double newzx = 0;
      double newzy = 0;
      int rescaledx = 0;
      int rescaledy = 0;
      int i = 0;
 
 stroke(random(100,150), random(255), random(255));
      if( colored[x][y] != true ){
        while( (zx * zx + zy * zy)  < 4 && (i < check_until)){ 
          i++;
                 
          newzy = 2.0* zx * zy + scaledy;
          newzx = zx * zx - zy*zy + scaledx;
          rescaledx = (int)(zx*zoom + dim/1.3);
          rescaledy = (int)(zy*zoom + dim/2.0);
 
          if((rescaledx < dim ) && (rescaledx > 0) && 
            (rescaledy < dim) && (rescaledy > 0)) {
 
          if( colored[rescaledx][rescaledy] != true ){
            line(x + 75, y + 75, rescaledx + 75, rescaledy + 75);
            colored[rescaledx][rescaledy] = true;
          }
            
          zy = newzy;
          zx = newzx;
          
            }
        }
 
    }
  }
}
save("mandeline3.png");
}

// Crawl image for a color pool
// Idea from j tarbell
void getImgColors(String file) {
  PImage img = loadImage(file);
  image(img, -300, -100);
  
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

color randColor() {
  return colors[int(random(colors.length))];
}

