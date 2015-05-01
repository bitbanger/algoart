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
      //newzy = 3.0* zx* zx * zy - zy*zy*zy + scaledy;
      //newzx = zx * zx *zx - 3* zy*zy *zx + scaledx;
      Complex z = new Complex(zx, zy);
      //z^3
      newzy = 3.0* zx* zx * zy - zy*zy*zy;
      newzx = zx * zx *zx - 3* zy*zy *zx;
     Complex z3 = z.times(z.times(z));
     Complex expz3 = z3.cexp();
      //exp(z^3)
     zx = exp(newzx)*cos(newzy) + cx;
     zy = exp(newzx)*sin(newzy) + cy;
   //  zx = (float)(expz3.re());
   //  zy = (float)(expz3.im());
   //  println("x = %d, y= %d \n", x, y);
   //  println("x = %d, y= %d \n", x, y);
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

/*************************************************************************
 *  Compilation:  javac Complex.java
 *  Execution:    java Complex
 *
 *  Data type for complex numbers.
 *
 *  The data type is "immutable" so once you create and initialize
 *  a Complex object, you cannot change it. The "final" keyword
 *  when declaring re and im enforces this rule, making it a
 *  compile-time error to change the .re or .im fields after
 *  they've been initialized.
 *
 *  % java Complex
 *  a            = 5.0 + 6.0i
 *  b            = -3.0 + 4.0i
 *  Re(a)        = 5.0
 *  Im(a)        = 6.0
 *  b + a        = 2.0 + 10.0i
 *  a - b        = 8.0 + 2.0i
 *  a * b        = -39.0 + 2.0i
 *  b * a        = -39.0 + 2.0i
 *  a / b        = 0.36 - 1.52i
 *  (a / b) * b  = 5.0 + 6.0i
 *  conj(a)      = 5.0 - 6.0i
 *  |a|          = 7.810249675906654
 *  tan(a)       = -6.685231390246571E-6 + 1.0000103108981198i
 *
 *************************************************************************/

class Complex {
    private final double re;   // the real part
    private final double im;   // the imaginary part

    // create a new object with the given real and imaginary parts
    public Complex(double real, double imag) {
        re = real;
        im = imag;
    }

    // return a string representation of the invoking Complex object
    public String toString() {
        if (im == 0) return re + "";
        if (re == 0) return im + "i";
        if (im <  0) return re + " - " + (-im) + "i";
        return re + " + " + im + "i";
    }

    // return abs/modulus/magnitude and angle/phase/argument
    public double abs()   { return Math.hypot(re, im); }  // Math.sqrt(re*re + im*im)
    public double phase() { return Math.atan2(im, re); }  // between -pi and pi

    // return a new Complex object whose value is (this + b)
    public Complex plus(Complex b) {
        Complex a = this;             // invoking object
        double real = a.re + b.re;
        double imag = a.im + b.im;
        return new Complex(real, imag);
    }

    // return a new Complex object whose value is (this - b)
    public Complex minus(Complex b) {
        Complex a = this;
        double real = a.re - b.re;
        double imag = a.im - b.im;
        return new Complex(real, imag);
    }

    // return a new Complex object whose value is (this * b)
    public Complex times(Complex b) {
        Complex a = this;
        double real = a.re * b.re - a.im * b.im;
        double imag = a.re * b.im + a.im * b.re;
        return new Complex(real, imag);
    }

    // scalar multiplication
    // return a new object whose value is (this * alpha)
    public Complex times(double alpha) {
        return new Complex(alpha * re, alpha * im);
    }

    // return a new Complex object whose value is the conjugate of this
    public Complex conjugate() {  return new Complex(re, -im); }

    // return a new Complex object whose value is the reciprocal of this
    public Complex reciprocal() {
        double scale = re*re + im*im;
        return new Complex(re / scale, -im / scale);
    }

    // return the real or imaginary part
    public double re() { return re; }
    public double im() { return im; }

    // return a / b
    public Complex divides(Complex b) {
        Complex a = this;
        return a.times(b.reciprocal());
    }

    // return a new Complex object whose value is the complex exponential of this
    public Complex cexp() {
        return new Complex(Math.exp(re) * Math.cos(im), Math.exp(re) * Math.sin(im));
    }

    // return a new Complex object whose value is the complex sine of this
    public Complex csin() {
        return new Complex(Math.sin(re) * Math.cosh(im), Math.cos(re) * Math.sinh(im));
    }

    // return a new Complex object whose value is the complex cosine of this
    public Complex ccos() {
        return new Complex(Math.cos(re) * Math.cosh(im), -Math.sin(re) * Math.sinh(im));
    }

    // return a new Complex object whose value is the complex tangent of this
    public Complex ctan() {
        return csin().divides(ccos());
    }
    


    // a static version of plus
    public Complex plus(Complex a, Complex b) {
        double real = a.re + b.re;
        double imag = a.im + b.im;
        Complex sum = new Complex(real, imag);
        return sum;
    }

}
