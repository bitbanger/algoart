import java.awt.Color;
//real component
double r;
//imaginary component
double im;

// R(P(r + im))
double pr;
// I(P(r + im))
double pim;
int satconst = 30;
int colorconst = 70;
int brightconst = 0;
int dim = 750;
int check_until = 2000;

double zoom = 0.7;
double dimScale = (4.0/dim)/zoom;

double gx = -.123;
double gy = 0.745;


void setup(){
 size(dim, dim, P2D);
 colorMode(HSB);
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
      //newzy = gx*zy - gy*zx;
      //newzx = - gy*zy + zx*gx;
      newzy = 2.0* zx * zy + gy;
      newzx = zx * zx - zy*zy + gx;
      zy = newzy;
      zx = newzx;
      i ++;
    }
    //color c = color((i + colorconst) % 256, 255, 255 );
    color c = color((i + colorconst) % 256, 255 - (i +satconst) %256, 
      255 );
    //color c = color.HSBtoRGB((i + colorconst) % 255, 255, 255* (i < check_until));
    
    if (i > (check_until - 1)){
      
      c = color((i + colorconst) % 256, 255, 0) ;
    }
    
    stroke(c); 
    point(x, y);
    
  }
}
save("sylvan1.png");
}
