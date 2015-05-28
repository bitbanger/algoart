
boolean paused = true; 

float stretch = 10;
int xdim = 1000;
int ydim = 1000;
int zdim = 250;

float beta = 8/3;
float rho = 28;
float sigma = 10;

float x0, y0, z0;

float x = -5*stretch;
float y = -8*stretch;
float z = 0;

float distance = 0.75;
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
 frameRate(300);
  smooth();
pushMatrix();
}


void draw(){
  
  
  if (!paused) {
 // fill(0xFF, 10);
 // rect(0, 0, xdim, ydim); 
  translate( x0, y0, z0); 
  

  rotateX(mouseY * 2*PI / height);
  rotateY(mouseX * 2*PI / width); 
  
   //lorenzParticle p = new lorenzParticle(100.0, 100.0, 100.0, 0.0, 0.0, 0.0, sigma, rho, beta);
   
   //for (int i = 0; i < maxIt; i++){
   //  p.move();
   //}
   

   
   
   //for (int i = 0; i < maxIt; i++ ){
     dx = sigma*(y - x);
     dy = x*(rho - z) - y;
     dz = x*y - beta*z;
  
     scale = distance/sqrt(dx*dx + dy*dy + dz*dz);
     colorMode(HSB);
     stroke ( (2*x + 2*y + 2*z + stretch*xdim + 50) % 255 , 255, 255);
    // stroke( frameCount % 255);
 //    stroke ( (mouseX) % 255, (mouseX + mouseY) % 255, (mouseY) % 255);
     //line(x, y, z, x + scale*dx, y + scale*dy, z + scale*dz);
     line(stretch*x - 200, stretch*y, stretch*z, stretch*(x + scale*dx) - 200, stretch*(y + scale*dy), stretch*(z + scale*dz));
     x += scale*dx;
     y += scale*dy;
     z += scale*dz;

     saveFrame(); 
   

  }
}

void mousePressed() {
  paused = !paused;
}

void keyPressed ()
{
  if(key == 's') save("LorenzAttractor.png");
}

class lorenzParticle{
  
  float sigma;
  float rho;
  float beta;
  float x, y, z;
  float dxdt, dydt, dzdt;
  float timestep = 10;
  
  lorenzParticle(float x, float y, float z, float dxdt, float dydt, float dzdt, float sigma, float rho, float beta){
    this.sigma = sigma;
    this.rho = rho;
    this.beta = beta;
    this.x = x;
    this.y = y;
    this.z = z;
    this.dxdt = dxdt;
    this.dydt = dydt;
    this.dzdt = dzdt;
    
  }
  
  float calcdxdt (float x, float y, float z){
    return sigma*(y - z);  
  }

  float calcdydt (float x, float y, float z){
    return x*(rho-z) - y;
  }

float calcdzdt (float x, float y, float z){
  return x*y - beta*z;
}

float calcddxdt (float x, float y, float z, float dxdt, float dydt, float dzdt){
  return sigma*(dydt - dxdt);
}

float calcddydt (float x, float y, float z, float dxdt, float dydt, float dzdt){
  return dxdt*(rho-z) - x*(dzdt) - dydt;
}

float calcddzdt (float x, float y, float z, float dxdt, float dydt, float dzdt){
  return x*dydt + y*dxdt - beta*dzdt;
}

float [] rk4(float step, float x, float y, float z, float dxdt, float dydt, float dzdt){
 
  // step 1
  float dx1 = step*dxdt;
  float ddxdt1 = step*calcddxdt( x, y, z, dxdt, dydt, dzdt);
  
  float dy1 = step*dydt;
  float ddydt1 = step*calcddydt( x, y, z, dxdt, dydt, dzdt);
 
  float dz1 = step*dzdt;
  float ddzdt1 = step*calcddzdt( x, y, z, dxdt, dydt, dzdt);
 
 // step 2
  float dx2 = step*(dxdt + ddxdt1/2.);
  float ddxdt2 = step*calcddxdt( x + dx1/2., y + dy1/2., 
    z + dz1/2., dxdt + ddxdt1/2., dydt + ddydt1/2., dzdt + ddzdt1/2.);
  
  float dy2 = step*(dydt + ddydt1/2.);
  float ddydt2 = step*calcddydt( x + dx1/2., y + dy1/2., 
    z + dz1/2., dxdt + ddxdt1/2., dydt + ddydt1/2., dzdt + ddzdt1/2.);
 
 float dz2 = step*(dzdt + ddzdt1/2.);
  float ddzdt2 = step*calcddzdt( x + dx1/2., y + dy1/2., 
    z + dz1/2., dxdt + ddxdt1/2., dydt + ddydt1/2., dzdt + ddzdt1/2.);
 
  
  // step 3
  
  float dx3 = step*(dxdt + ddxdt2/2.);
  float ddxdt3 = step*calcddxdt( x + dx2/2., y + dy2/2., 
    z + dz2/2., dxdt + ddxdt2/2., dydt + ddydt2/2., dzdt + ddzdt2/2.);
  
  float dy3 = step*(dydt + ddydt2/2.);
  float ddydt3 = step*calcddydt( x + dx2/2., y + dy2/2., 
    z + dz2/2., dxdt + ddxdt2/2., dydt + ddydt2/2., dzdt + ddzdt2/2.);
 
  float dz3 = step*(dzdt + ddzdt2/2.);
  float ddzdt3 = step*calcddzdt( x + dx2/2., y + dy2/2., 
    z + dz2/2., dxdt + ddxdt2/2., dydt + ddydt2/2., dzdt + ddzdt2/2.);
  
  // step 4
  float dx4 = step*(dxdt + ddxdt3);
  float ddxdt4 = step*calcddxdt( x + dx3, y + dy3, z + dz3, 
    dxdt + ddxdt3, dydt + ddydt3, dzdt + ddzdt3);
    
  float dy4 = step*(dydt + ddydt3);
  float ddydt4 = step*calcddydt( x + dx3, y + dy3, z + dz3, 
    dxdt + ddxdt3, dydt + ddydt3, dzdt + ddzdt3);
    
  float dz4 = step*(dzdt + ddzdt3);
  float ddzdt4 = step*calcddzdt( x + dx3, y + dy3, z + dz3, 
    dxdt + ddxdt3, dydt + ddydt3, dzdt + ddzdt3);
  
  // weighted average of k's
  float dx = (dx1 + 2*dx2 + 2*dx3 + dx4)/6;
  float dy = (dy1 + 2*dy2 + 2*dy3 + dy3)/6;
  float dz = (dz1 + 2*dz2 + 2*dz3 + dz4)/6;
  
  float ddxdt = (ddxdt1 + 2*ddxdt2 + 2*ddxdt3 + ddxdt4)/6;
  float ddydt = (ddydt1 + 2*ddydt2 + 2*ddydt3 + ddydt4)/6;
  float ddzdt = (ddzdt1 + 2*ddzdt2 + 2*ddzdt3 + ddzdt4)/6;
  
  float nextsteps[] = {dx, dy, dz, ddxdt, ddydt, ddzdt};
  return nextsteps;
}
  void move(){
    float steps[] = rk4( timestep, x, y, z, dxdt, dydt, dzdt );
    
    float oldx = x;
    float oldy = y;
    float oldz = z;
    
    x += steps[0];
    y += steps[1];
    z += steps[2];
    
    dxdt += steps[3];
    dydt += steps[4];
    dzdt += steps[5]; 
    
    println(" x is %.2f, y is %.2f z is %.2f \n", x, y, z);
    stroke( 50, 255, 255);
    line( oldx, oldy, oldz, x, y, z);
    
  }  
}






