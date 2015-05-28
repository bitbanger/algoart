import java.awt.Color;

int satconst = 150;
int colorconst = 45;
int brightconst = 100;
int xdim = 2000;
int ydim = 3000;
int check_until = 40;

double zoom = 0.83;
double dimScale = (4.0/xdim)/zoom;

double cx = .25;
double cy = -0.75;


void setup(){
 size(xdim, ydim, P2D);
 background(0xFF, 0xFF, 0xFF, 0xFF);
 
 colorMode(HSB);
}

void draw(){
  
for (int x = 0; x < xdim; x++){
  for (int y = 0; y < ydim; y++){
      double zx = (x - xdim/2)/(0.5*zoom*xdim);
      double zy = (y - ydim/2.0)/(0.5*zoom*xdim);
      
      double newzx = 0;
      double newzy = 0;
      int i = 0;
    while( (zx * zx + zy * zy)  < 4 && (i < check_until)){ 
      newzy = 3.0* zx* zx * zy - zy*zy*zy + cy;
      newzx = zx * zx *zx - 3* zy*zy *zx  + cx;
      //newzy = 2.0* zx * zy + cy;
      //newzx = zx * zx - zy*zy + cx;
      zy = newzy;
      zx = newzx;
      i ++;
    }
    //color c = color((i + colorconst) % 256, 255, 255 );
    color c = color((i*3 + colorconst) % 256, 255 - (i*6+satconst) %256, 
      255 );
    //color c = color.HSBtoRGB((i + colorconst) % 255, 255, 255* (i < check_until));
    
    if (i > (check_until - 1)){
      
      c = color((i + colorconst) % 256, 255, 0) ;
    }
    
    stroke(c); 
    point(x, y);
    
  }
}
save("sylvanprint.png");
}
