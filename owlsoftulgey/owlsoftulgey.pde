import java.awt.Color;


int colorconst = 125;
int dim = 5000;
int check_until = 100;

float zoom = 0.60;
float dimScale = (4.0/dim)/zoom;

float cx = -.621;
float cy = 0.00;



void setup(){
 size(dim, dim,P2D);
 color bgCol = color(255, 255, 255);
 fill(bgCol);
 rect(0, 0, dim, dim);
 colorMode(HSB);
 noLoop();
}

void draw(){
  
for (int x = 0; x < dim; x++){
  for (int y = 0; y < dim; y++){
      float zx = (x - dim/2)/(0.5*zoom*dim);
      float zy = (y - dim/2.0)/(0.5*zoom*dim);
     
      float newzx = 0;
      float newzy = 0;
      int i = 0;
    while( (zx * zx + zy * zy)  < 4 && (i < check_until)){ 
    
      //z^3
      newzy = 3.0* zx* zx * zy - zy*zy*zy;
      newzx = zx * zx *zx - 3* zy*zy *zx;
 
      //exp(z^3)
      zx = exp(newzx)*cos(newzy) + cx;
      zy = exp(newzx)*sin(newzy) + cy;
 
      i ++;
    }
    color c ; 
    
    //color c = color.HSBtoRGB((i + colorconst) % 255, 255, 255* (i < check_until));
    if (i < 35){
      c = color((i*10 ) % 256, 255, (255 - i*5)%256 );
    }
  //  else if (i < 10){
  //    c = color((i + 30) % 256, 255, 255 );
  //  }
  //  else if (i < 20){
  //    c = color((i + colorconst) % 256, 255, 230 );
  //  }
    
    else if (i > (check_until - 1)){
      c = color((i*10 + colorconst) % 256, 255, 0) ;
    }
    else if ( i < 55){
    //  c = color(255 - ((i*2 + 85) % 256), max(i+170, 200),
    //   35 + i*2); 
    c = color((i*10 % 256), max(i+170, 200),
      (i*6 - 150) % 256); 
    }
    else {
      //c = color((i*2+200) % 256, 200, 200);
     // c = color(255 - ((i*2+200) % 256), 200, 200);
     
     //  c = color(255 - ((i*2+75) % 256), 200, 200);
     //this is best so far
      c = color((i*5) % 256, max(i+150, 200),
        max(i+150, 230));
     
    }
 
    stroke(c); 
    point(x, y);
    
  }
}







save("owlsoftulgey.png");
}

