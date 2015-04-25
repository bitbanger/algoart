
double sigma = 10.0;
double rho = 28.0;
double beta = 8/3.0 ;


double calcdxdt (double x, double y, double z){
  return sigma*(y - z);  
}

double calcdydt (double x, double y, double z){
  return x*(rho-z) - y;
}

double calcdzdt (double x, double y, double z){
  return x*y - beta*z;
}

double calcddxdt (double x, double y, double z, double dxdt, double dydt, double dzdt){
  return sigma*(dydt - dxdt);
}

double calcddydt (double x, double y, double z, double dxdt, double dydt, double dzdt){
  return dxdt*(rho-z) - x*(dzdt) - dydt;
}

double calcddzdt (double x, double y, double z, double dxdt, double dydt, double dzdt){
  return x*dydt + y*dxdt - beta*dzdt;
}

double [] rk4(double step, double x, double y, double z, double dxdt, double dydt, double dzdt){
 
  // step 1
  double dx1 = step*dxdt;
  double ddxdt1 = step*calcddxdt(step, x, y, z, dxdt, dydt, dzdt);
  
  double dy1 = step*dxdt;
  double ddxdt1 = step*calcddydt(step, x, y, z, dxdt, dydt, dzdt);
 
  double dz1 = step*dxdt;
  double ddzdt1 = step*calcddzdt(step, x, y, z, dxdt, dydt, dzdt);
 
 // step 2
  double dx2 = step*dxdt;
  double ddxdt2 = step*calcddxdt(step, x, y, z, dxdt, dydt, dzdt);
  
  double dy2 = step*dxdt;
  double ddxdt2 = step*calcddydt(step, x, y, z, dxdt, dydt, dzdt);
 
  double dz3 = step*dxdt;
  double ddzdt3 = step*calcddzdt(step, x, y, z, dxdt, dydt, dzdt);
  
}





