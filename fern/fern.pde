import java.awt.Color;
//real component
double r;
//imaginary component
double im;

// R(P(r + im))
double pr;
// I(P(r + im))
double pim;

int colorconst = 240;
int dim = 3000;
int ydim = int(dim*1.25*1.5);
int check_until = 55*dim;

float zoom = 2;
float dimScale = (4.0/dim)/zoom;

float px, py, childpx, childpy = 0; 

int counter = 0;


void setup(){
 size(dim, ydim, P2D);
 
// PImage img = loadImage("fernback.jpg");
 
 colorMode(HSB);
 background(28, 50, 00);
 //background(img);
 noLoop();
}

void draw(){
  
    while (counter < check_until){
    float transform = random(1.0);
    //stem
    if (transform < 0.01){
      childpx = 0;
      //0.16
      childpy = (0.16*py);
    }
    //
    else if (transform < 0.86){
      // + 0
      childpx = (0.85*px + 0.04*py);
      // + 250
      //-0.04, 0.85
      childpy = (-.04*px + 0.85*py + 1.6) + ydim/(1.2*6);  
    }
    //left
    else if (transform < .93){
      // + 0
     childpx = 0.2*px - 0.27*py;
     // + 175
     //.23, .22, 1.6
     childpy = (0.23*px + 0.22*py + 1.6) + (ydim*175/(1.2*1500)); 
    }
    
    //right
    else if (transform < 1.0){
      //-.15, 0.28
      //-.5 is a beautiful curl
      childpx = (-.15*px + 0.28*py);
      // + 50
      //.26, .24, .44
      childpy = (.26*px + 0.24*py + 0.44) + (ydim*50/(1.2*1500));  
    }
    
    px = childpx;
    py = childpy;
    color c = color(py/(3.5*(dim)) * 256 + 30*ydim/(2.5*1500), 
              min( 0.4*255 + ((ydim - py)/ydim)*255, 256) , 255 );
    counter ++;
    stroke(c); 
    fill(c);
    ellipse(px + dim/2, .95*ydim - py, 3, 3);
    
  }
  save("fern.png");
}


