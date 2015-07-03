
boolean paused = true; 


//int xdim = 1200;
//int ydim = 1200;
//int zdim = 250;


int xdim = 500;
int ydim = 500;
float stretch = xdim/100.;

int count = 0;
float beta = 8/3;
float rho = 28;
float sigma = 10;

float x0, y0, z0;

//float x = -5*stretch;
//float y = -8*stretch;
//float z = 0;

float x = -5;
float y = -8;
float z = 0;

float distance = 0.6;
   float dx = 0;
   float dy = 0;
   float dz = 0;
   float scale = 0;
   
int maxIt = 6000;

void setup(){
  size(xdim, ydim, P3D);
  
  x0 = xdim/2;
  y0 = ydim/2;
  z0 = 0;
  
 background(0xFF, 0xFF, 0xFF);
 frameRate(1000);
 smooth();
 colorMode(HSB);

}


void draw(){
  
  count ++;
  if (!paused) {
  translate( x0 - x0/3, y0 + y0/4, z0 - z0/2); 
  if (count == 700){
    fill(0xFF);
   rect(-xdim, -ydim, 2*xdim, 2*ydim); 
  }
  if (count > 700){
   rotateY((.12*ydim*2*PI)/height);
   rotateX((.04*xdim*2*PI)/width);
 }
  else {
    rotateY((0.145*ydim*2*PI) / height);
    rotateX((.8758*xdim*2*PI )/ width);
    }
    
     dx = sigma*(y - x);
     dy = x*(rho - z) - y;
     dz = x*y - beta*z;
  
     scale = (distance/sqrt(dx*dx + dy*dy + dz*dz));
     
     stroke ( (2*x + 2*y + 2*z + xdim -25 ) % 255 , 255, 255);
     line(stretch*x, stretch*y , stretch*z, stretch*(x + scale*dx), stretch*(y + scale*dy) , stretch*(z + scale*dz));
     x += scale*dx;
     y += scale*dy;
     z += scale*dz; 
  }
}

void mousePressed() {
  paused = !paused;
}

void keyPressed ()
{
  if(key == 's') save("LorenzAttractor.png");
}




