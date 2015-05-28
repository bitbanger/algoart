import java.awt.Color;

int colorconst = 240;
int dim = 2000;
int check_until = 200;

double zoom = 2;
double dimScale = (4.0/dim)/zoom;

double cx = -.4;
double cy = -0.6;


void setup(){
 size(dim, dim, P2D);
 background(0xFF, 0xFF, 0xFF);
 colorMode(HSB);
 noLoop();
}

void draw(){
  
for (int x = 0; x < dim; x++){
  for (int y = 0; y < dim; y++){
      double zx = (x - dim/2)/(0.5*zoom*dim);
      double zy = (y - dim/2.0)/(0.5*zoom*dim);
      
      double newzx = 0;
      double newzy = 0;
      int i = 0;
    while( (zx * zx + zy * zy)  < 4 && (i < check_until)){ 
      //newzy = 3.0* zx* zx * zy - zy*zy*zy + scaledy;
      //newzx = zx * zx *zx - 3* zy*zy *zx + scaledx;
      newzy = 2.0* zx * zy + cy;
      newzx = zx * zx - zy*zy + cx;
      zy = newzy;
      zx = newzx;
      i ++;
    }
    color c = color((i + colorconst) % 256, 255, 255 );
    
    //color c = color.HSBtoRGB((i + colorconst) % 255, 255, 255* (i < check_until));
    
    if (i > (check_until - 1)){
      
      c = color((i + colorconst) % 256, 255, 0) ;
    }
    stroke(c); 
    point(x, y);
    
  }
}
save("josephs_coat.png");
}
