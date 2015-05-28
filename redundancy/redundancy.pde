import java.util.ArrayList;
import java.util.Stack;

//int xdim = 1600;
int ydim = 5000;
int xdim = 8000;
//int ydim = 00;
//int xdim = 4000;
int iterations = 8;
//in radians
//float bend = .43633;
float bend = .43633;
//initial angle
float a0 = 1.1344;

float x = ydim/10;
float y = 0;
float x2 = xdim - (ydim/10.);
float y2 = ydim;

int depth = 1;
int depth2 = 1;

float len = ydim / 570.0;

//float len = 1;
float decay = 1;

Stack<Float> xcoords = new Stack<Float>();
Stack<Float> ycoords = new Stack<Float>();
Stack<Float> angles = new Stack<Float>();
Stack<Float> x2coords = new Stack<Float>();
Stack<Float> y2coords = new Stack<Float>();
Stack<Float> angles2 = new Stack<Float>();

void setup(){
  size(xdim, ydim);
  background(0x00, 0x00, 0x00);
  colorMode(HSB);
  
  noLoop(); 
}

void draw(){
  float x1 = x;
  float y1 = y;
  float x3 = x2;
  float y3 = y2;
  float angle = a0;
  float angle2 = a0;
  color c = color(150, 255, 255);

  
  String instrct = "x";
  for (int i = 0; i < iterations; i++){
    instrct = production(instrct);
  }
  
  int count = 0;
  for (char var: instrct.toCharArray()){
    
    if (var == 'f'){
      x1 = x + len*cos(angle);

      y1 = y + len*sin(angle);
      if (depth ==1){
        strokeWeight(8);
        c = color(31, 75, 65);  
      }
      else if (depth <=4 ){
        strokeWeight(2);
        c = color(31, 75, 65);  
      }
      else {
        strokeWeight(4);
    //    c = color( (200 + 30*depth) % 255, 255 - 15*depth, min(155 + 10*depth, 255));
        c = color ( 105, 255 - 17*depth, min(120 + 10*depth, 255));
     //c = color(50 + 20*depth, 255, 255);
      }
     stroke(c);
      line(x, y, x1 , y1);
      x = x1;
      y = y1;
      println("x %.2f, y %.2f \n", x, y);
      count ++;      
    }
    
    else if (var == '-'){
      angle += bend;  
    }
    else if (var == '+'){
      angle -= bend;  
    }
    else if (var == '['){
      depth += 1; 
      xcoords.push(x);
      ycoords.push(y);
      angles.push(angle);  
    }
    else if (var == ']'){
      x = xcoords.pop();
      y = ycoords.pop();
      angle = angles.pop();
      depth -= 1;  
    }
  }
   count = 0;
   for (char var: instrct.toCharArray()){
    
    if (var == 'f'){
      x3 = x2 - len*cos(angle2);

      y3 = y2 - len*sin(angle2);
      if (depth2 ==1){
        strokeWeight(8);
        c = color(31, 75, 65);  
      }
      else if (depth2 <=4 ){
        strokeWeight(4);
        c = color(31, 75, 65);  
      }
      else {
        strokeWeight(4);
//        c = color( (200 + 30*depth2) % 255, 255 - 15*depth2, min(155 + 10*depth2, 255));
        c = color ( 25, 255 - 17*depth2, min(120 + 10*depth2, 255));
   //  c = color ( 50, 255 - 15*depth2, min(155 + 10*depth2, 255));

      }
     stroke(c);
      line(x2, y2, x3 , y3);
      x2 = x3;
      y2 = y3;
      
      count ++;      
    }
    
    else if (var == '-'){
      angle2 += bend;  
    }
    else if (var == '+'){
      angle2 -= bend;  
    }
    else if (var == '['){
      depth2 += 1; 
      x2coords.push(x2);
      y2coords.push(y2);
      angles2.push(angle2);  
    }
    else if (var == ']'){
      x2 = x2coords.pop();
      y2 = y2coords.pop();
      angle2 = angles2.pop();
      depth2 -= 1;  
    }
  }
save("language.png");  
}

String production(String instrct){
  StringBuilder res = new StringBuilder();
  for (char var: instrct.toCharArray()){
    if ( var == 'x' ){
      res.append("f-[[x]+x]+f[+fx]-x");
    }
    else if (var == 'f' ){
      res.append("ff");
    }
    else if (var == '-'){
      res.append("-");  
    }
    else if (var == '+'){
      res.append("+");  
    }
    else if (var == '['){
      res.append("[");  
    }
    else if (var == ']'){
      res.append("]");  
    }
  }
  return res.toString();
}


