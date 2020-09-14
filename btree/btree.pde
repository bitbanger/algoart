
int Nx = 300;
int Ny = 300;

int Np = floor(0.03*Nx*Ny);

ArrayList<Particle> parts = new ArrayList<Particle>();

boolean sticky[][] = new boolean[Nx][Ny];
boolean paused = false;

void setup(){
  
  size(Nx, Ny);
  background(0x00, 0x00, 0x00);
  
  for (int i = 0; i < Np; i++){
    Particle p = new Particle((int)random(Nx), (int)random(Ny));
    parts.add(p); 
  }
  
  for (int i = 0; i < Nx; i++){
    for (int j = 0; j < Ny; j++){
      sticky[i][j] = false; 
    }  
  }
  
  sticky[floor(Nx/2)][floor(Ny/2)] = true;
  colorMode(HSB);
}

void draw(){
  fill(0xFF, 0xFF);
  rect(0, 0, Nx, Ny);
  for (int i = 0; i < parts.size(); i ++){
    
    Particle p = parts.get(i);
    
    if (sticky[p.x][p.y] == false){
    
      int direction = (int)random(1, 4);
       
      if( direction == 1){
        if (sticky[p.x][(p.y + 1) % Ny] == true){
          sticky[p.x][p.y] = true; 
      }
        p.y = (p.y + 1) % Ny;
      }
      else if (direction == 2){
        if (sticky[(p.x + 1) % Nx][p.y] == true){
          sticky[p.x][p.y] = true;  
        }
        p.x = (p.x + 1) % Nx;      
      }
      else if (direction == 3){
         if (sticky[p.x][(p.y - 1 + Ny) % Ny] == true){
          sticky[p.x][p.y] = true;    
        }
        p.y = (p.y + Ny - 1) % Ny;
      }
      else if (direction == 4){
        if (sticky[(p.x - 1 + Nx) % Nx][p.y] == true){
          sticky[p.x][p.y] = true;  
        }
        p.x = (p.x + Nx - 1) % Nx;        
      }
     }
   color c = color(p.x + p.y, 255, 255);
   fill(c);
   ellipse(p.x, p.y, 2, 2);   
  }
  
}


class Particle{

  public int x, y;
  Particle (int x, int y){
    this.x = x;
    this.y = y;
  }
  
}
