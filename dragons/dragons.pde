import java.awt.Color;


int colorconst = 125;
int dim =5000;
int check_until = 2000;

double zoom = 1;
double dimScale = (4.0/dim)/zoom;

double cx = -.8214;
double cy = 0.2;


void setup(){
 size(dim + 100, dim + 100,P2D);
 color bgCol = color(255, 255, 255);
 fill(bgCol);
 rect(0, 0, dim + 100, dim + 100);
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

      newzy = 2.0* zx * zy + cy;
      newzx = zx * zx - zy*zy + cx;
      zy = newzy;
      zx = newzx;
      i ++;
    }
    color c ; 
    

    if (i < 35){
      c = color((i + colorconst) % 256, 255, (255 - i*5)%256 );
    }

    
    else if (i > (check_until - 1)){
      c = color((i + colorconst) % 256, 255, 0) ;
    }
    else if ( i < 55){
    c = color(255 - ((i*2 + 85) % 256), max(i+170, 200),
      (i*6 - 150) % 256); 
    }
    else {
      c = color(255 - ((i+150) % 256), max(i+150, 200),
        max(i+150, 230));
     
    }
    stroke(c); 
    point(x + 50, y + 50);
    
  }
}
save("dragons.png");
}
