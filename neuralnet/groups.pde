import java.util.Iterator;

//
// Global data
//
int dim = 800;

int numDots = 27;
ArrayList<Dot> dots;
ArrayList<Dot> newDots;

int numColors = 5000;
int colPtr = 0;
color[] colors = new color[numColors];

int[][] hit;

float[] inToHid = new float[]{0.18981813765736866, 0.030731705669114144, 0.1986904812049287, 0.12850730726590118, 0.010648414110282079, 0.1761461180637431, 0.15346493945051803, 0.13626466734804055, 0.40713311054752144, 0.050677169526390085, 0.45026837304438366, 0.2559445740569194, 0.09994963019396634, 0.22644670025134545, 0.20903275915077946, 0.24440986443475796, 0.14045717017143336, 0.02062312621291193, 0.16247323807502845, 0.0933575487313544, 0.09768749967023461, 0.02225399245147552, 0.02931514107208695, 0.06029647519286737, 0.19615268262521576, 0.06439428394498083, 0.239816075872372, 0.12476123561794254, 0.10238552256709403, 0.08624718045049756, 0.07206398495098133, 0.1168758285019513, 0.388141483216621, 0.1499900314371917, 0.4937250690242471, 0.21624089615007236, 0.3509737565706191, 0.032531285262359586, 0.0005041662164881332, 0.1648800541552914, 0.10972829874496573, 0.35826946407596816, 0.03520796173175212, 0.03729329371753804, 0.20282715957048014, 0.29176830030936646, 0.2500087842542739, 0.10165301002452645, 0.3059378939747532, 0.03361573735498531, 0.34562344032038383, 0.20616316438838897, 0.07512413191987459, 0.21600637522394156, 0.20339485584200484, 0.21417745362758325, 0.18518817454263267, 0.44753856717823776, 0.30437127900475675, 0.10487726470380096, 0.36170309843075454, 0.13925257908805436, 0.096848829557112, 0.0705965052092684, 0.1537625728870098, 0.05760232511144426, 0.1321143744954906, 0.1264260495039196, 0.05066850231115407, 0.17211191528387998, 0.14814044770582546, 0.12264959831759358, 0.8480797227918369, 0.36410689047533656, 1.0, 0.4970367676808882, 0.4518917867431312, 0.29569394147357264, 0.265465693460285, 0.46687764229071643, 0.41698319189091804, 0.365410629439868, 0.5262268604490663, 0.26329467624591757, 0.35211914488014506, 0.05931933208187181, 0.0302442285867812, 0.21313174461970597, 0.1590085535798199, 0.08505032027005172, 0.16268638830548973, 0.12866168492005395, 0.061614461287845194, 0.20278756874351156, 0.17322091394228362, 0.14738195882328775, 0.05629026055913863, 0.1451410977722739, 0.031436116189726686, 0.03288169381527386, 0.007302578013193122, 0.07076840708692758, 0.060221734695934295, 0.0067305165018780215, 0.011062011090771063, 0.019946425475316727, 0.013282349188335539, 0.008069531665063528, 0.026958594840192942, 0.03122120721048031, 0.02704310335196135, 0.004751797589929603, 0.33581725177940147, 0.06965975005598579, 0.34182186053630786, 0.15321433672794205, 0.09500383881717743, 0.16928149380378255, 0.15512113673273495, 0.1663256191279696, 0.3881471137433071, 0.004798790345238464, 0.4360902386924505, 0.20776084215167656, 0.12558519044446734, 0.203920557241459, 0.17720745336478316, 0.22323484538364946, 0.220766308608611, 0.003922819574428598, 0.24260464166195742, 0.11795540924002834, 0.0825078780874313, 0.13985948660047892, 0.12312427069654135, 0.12248622447361188, 0.08295894021290401, 0.08870259620042698, 0.05697640033697627, 0.0005492104299775112, 0.003996724982010468, 0.05914053439063069, 0.034080198868684214, 0.027086578609699978, 0.19401735915417798, 0.1531064457143398, 0.2553379955190877, 0.05347855267222962, 0.2729859008195504, 0.08438218552474086, 0.060104898103978975, 0.029358287355232677, 0.21728415050137184, 0.21392382686932632, 0.32079146377738577, 0.10097338647420202, 0.2866970936954689, 0.06807308028869141, 0.0392205027999597, 0.08489204553225996, 0.7180071797186557, 0.03635476716260135, 0.8003798239426672, 0.369191281378688, 0.2591418401667071, 0.36092614901240755, 0.33179641042915764, 0.3777142918671952, 0.3678784956128518, 0.18929546029359542, 0.43558398475258436, 0.21446271255823435, 0.2549235254906406, 0.06714675109942994, 0.078671996375611, 0.1956570444424051, 0.16238263088042243, 0.7805361524161558, 0.3221428914050187, 0.10698241108237462, 0.5244594191429733, 0.43427510872325603, 0.370276555907796, 0.03688106324689649, 0.0986742336559001, 0.012054084587136697, 0.09980560258662095, 0.0395092412695742, 0.015767031024164085, 0.06898854066351823, 0.08060415272979511, 0.059400019427215, 0.15749500474223202, 0.7021201615381658, 0.2938185458895327, 0.1091711423132828, 0.4544031661324605, 0.3698912380894274, 0.31968497038703575, 0.044956491148894294, 0.04053270653382386, 0.588661797024473, 0.05921765362692782, 0.01247021214141722, 0.3525696123207767, 0.45515241842065907, 0.38871386104966005, 0.07365671544250645, 0.018554976823170553, 0.026240481262499216, 0.0043269775146751455, 0.27773871063899663, 0.1481748508565214, 0.0879671228865233, 0.0928200042465559, 0.24691728347610348};
float[] hidToOut = new float[]{0.6626259334351166, 0.47798847453207194, 0.6335595405031774, 0.6010047106293999, 0.7860568928356251, 0.3873896125350664, 1.0, 0.501860980275923, 0.584276986499656, 0.15120827809374127, 0.08180805716584832, 0.4917882043184251, 0.9178262380390797, 0.1217833186430186, 0.08453828960851935, 0.7507708107654208, 0.6051599610355606, 0.5360879953251675, 0.5624484892488768, 0.5258193914826932, 0.4633082752876602, 0.0594707027910801, 0.1862661463062515, 0.5268435055645853};

//
// Event methods
//
void setup() {
  size(dim, dim);
  background(0xFF, 0xFF, 0xFF);
  
  getImgColors("pollockShimmering.jpg");
  
  // fill(0xFF, 0xFF, 0xFF, 0xFF);
  fill(0, 0, 0, 0xFF);
  rect(0, 0, dim, dim);
  
  /*int numSuns = 5;
  float maxLen = 1000;
  for(int i = 1; i <= numSuns; ++i) {
    float x = 0, y = 0;
    if(random(1.0) < 0.5) x = 0; else x = dim/2;
    if(random(1.0) < 0.5) y = 0; else y = dim/2;
    float mag = random(80);
    Sunmaker s = new Sunmaker(x, y, i * (maxLen/numSuns), color(mag, mag, mag), 130);
    s.setup();
  }*/
  
  hit = new int[dim][dim];
  for(int i = 0; i < dim; ++i) {
    for(int j = 0; j < dim; ++j) {
      hit[i][j] = 10001;
    }
  }
  
  int topThick = 6;
  
  dots = new ArrayList<Dot>();
  newDots = new ArrayList<Dot>();
  for(int i = 0; i < 27; ++i) {
    float space = (dim-100)*1.0 / 27;
    float x = i * space + 50;
    float y = 0;
    float v = random(1, 2);
    float theta = random(360);
    theta = random(90);
    color c = randColor();
    // c = color(0xFF, 0xFF, 0xFF);
    
    for(int j = 0; j < 8; ++j) {
      int ind = i*8+j;
      float weight = inToHid[ind];
      
      float ty = dim/2 + random(30);
      float tx = (j+1) * dim*1.0/8 - dim*1.0/16;
      float dy = y-ty;
      float dx = x-tx;
      float ang = (atan2(dy, dx) + PI) % TWO_PI;
      ang = (ang * 180/PI);
      if(ang < 0) ang += 360;
      float dist = sqrt(dx*dx + dy*dy);
      Dot d = new Dot(x, y, v, ang, c, dist/2, 0);
      d.bigThick = weight*topThick;
      d.tx = tx;
      d.ty = ty;
      d.maxDistt = dist;
      dots.add(d);
    }
  }
  
  for(int i = 0; i < 8; ++i) {
    float space = (dim)*1.0 / 8;
    float x = (i+1) * space - dim*1.0/16;
    float y = dim/2;
    float v = random(1, 2);
    float theta = random(360);
    theta = random(90);
    color c = randColor();
    // c = color(0xFF, 0xFF, 0xFF);
    
    for(int j = 0; j < 3; ++j) {
      int ind = i*3+j;
      float weight = hidToOut[ind];
      
      float ty = dim;
      float tx = (j+1) * dim*1.0/3 - dim*1.0/6;
      float dy = y-ty;
      float dx = x-tx;
      float ang = (atan2(dy, dx) + PI) % TWO_PI;
      ang = (ang * 180/PI);
      if(ang < 0) ang += 360;
      float dist = sqrt(dx*dx + dy*dy);
      Dot d = new Dot(x, y, v, ang, c, dist/2, 0);
      d.bigThick = weight*topThick;
      d.tx = tx;
      d.ty = ty;
      d.maxDistt = dist;
      dots.add(d);
    }
  }
  
  /*for(int i = 0; i < 8; ++i) {
    float space = (dim-100)*1.0 / 8;
    float x = i * space + 50;
    float y = dim/2;
    float v = random(1, 2);
    float theta = random(360);
    theta = random(90);
    color c = randColor();
    // c = color(0xFF, 0xFF, 0xFF);
    Dot d = new Dot(x, y, v, theta, c, random(80, 130), 0);
    dots.add(d);
  }*/
  
  Dot t1 = new Dot(dim/2, dim/2, 1, 0, randColor(), 500, 0);
  Dot t2 = new Dot(dim/2, dim/2, 3, 45, randColor(), 500, 0);
  Dot t3 = new Dot(dim/2, dim/2, 3, 180, randColor(), 500, 0);
  Dot t4 = new Dot(dim/2, dim/2, 3, 270, randColor(), 500, 0);
  t2.target = t3;
  t3.target = t4;
  t1.invis = true;
  t2.invis = true;
  t3.invis = true;
  t4.invis = true;
  
  /*for(int i = 0; i < dots.size(); ++i) {
    Dot d = dots.get(i);
    float r = random(1.0);
    if(r < 0.25) d.target = t2;
    else if(r < 0.5) d.target = t2;
    else if(r < 0.75) d.target = t2;
    else d.target = t2;
    // d.target = dots.get(int(random(dots.size())));
    // d.target = dots.get((i+1) % dots.size());
  }*/
  
  dots.add(t1);
  dots.add(t2);
  dots.add(t3);
  dots.add(t4);
}

void draw() {
  /*fill(0xFF, 0xFF, 0xFF, 256);
  rect(0, 0, dim, dim);*/
  
  for(Iterator i = dots.listIterator(); i.hasNext(); ) {
    Dot d = (Dot)i.next();
    if(d.ink3 == 0) i.remove();
  }
  
  for(Dot d : dots) {
    d.draw();
  }
  
  for(Dot d : newDots) {
    dots.add(d);
  }
  newDots.clear();
  
  for(Dot a : dots) {
    for(Dot b : dots) {
      // if(int(a.x) == int(b.x) && int(a.y) == int(b.y)) {
      float dx = a.x - b.x;
      float dy = a.y - b.y;
      float dist = sqrt(dx*dx + dy*dy);
      
      if(dist < 10) {
        color c1 = a.c;
        color c2 = b.c;
        color c3 = color((red(c1)+red(c2))*1.0/2, (green(c1)+green(c2))*1.0/2, (blue(c1)+blue(c2))*1.0/2);
        a.c = c3;
        b.c = c3;
      }
    }
  }
}

float pareto(float min, float alpha) {
  return min / pow(random(1), 1.0/alpha);
}

//
// Color methods
// (Idea from j tarbell)
//
color randColor() {
  return colors[int(random(colPtr))];
}

void getImgColors(String file) {
  PImage img = loadImage(file);
  image(img, 0, 0);
  
  trucking:
  for(int i = 0; i < img.width; ++i) {
    for(int j = 0; j < img.height; ++j) {
      color col = get(i, j);
      
      // Is this a unique color?
      for(int k = 0; k < colPtr; ++k) {
        if(colors[k] == col) {
          continue trucking; // :)
        }
      }
      
      // Add it to the pool
      if(colPtr < colors.length) {
        colors[colPtr] = col;
        ++colPtr;
      }
    }
  }
}

//
// Dot class def
//
class Dot {
  float x;
  float y;
  float sx;
  float sy;
  float v;
  float theta;
  float otheta;
  
  float bigThick, minThick, maxThick;
  
  float totalInk;
  float ink1, max1;
  float ink2, max2;
  float ink3, max3;
  
  float tx;
  float ty;
  float maxDistt;
  
  int depth;
  
  boolean invis;
  
  float startLast;
  
  
  
  color c;
  
  Dot target;
  
  Dot(float x, float y, float v, float theta, color c, float totalInk, int depth) {
    this.x = x;
    this.y = y;
    this.sx = x;
    this.sy = y;
    this.v = v;
    this.theta = theta;
    this.otheta = theta;
    
    this.invis = false;
    
    this.totalInk = totalInk;
    
    this.ink1 = totalInk/3;
    this.max1 = ink1;
    this.ink2 = totalInk/3;
    this.max2 = ink2;
    this.ink3 = totalInk/3;
    this.max3 = ink3;
    
    this.depth = depth;
    
    this.minThick = 1;
    this.maxThick = 1;
    this.bigThick = random(minThick, maxThick);
    
    this.c = c;
  }
  
  void draw() {
    if(x < 0 || x > dim || y < 0 || y > dim) {
      // theta = (theta+90) % 360;
      ink1 = 0;
      ink2 = 0;
      ink3 = 0;
    }
    
    /*if(target != null) {
      float dx = target.x - x;
      float dy = target.y - y;
      otheta = atan2(dy, dx) * 180/PI;
      theta = otheta;
    } else {
      theta = (theta+10) % 360;
      // if(theta < 0) theta = 360 - theta;
    }*/
    
    float bound = 12;
    float var = 2;
    float tMin = otheta - bound;
    float tMax = otheta + bound;
    theta = constrain((theta+random(-var, var))%360, tMin, tMax);
    
    x += v * cos(theta * PI/180);
    y += v * sin(theta * PI/180);
    
    
    /*if(ink > 0) {
      stroke(0, 0, 0, random(10, 80));
      strokeWeight(2);
      // float d = random(3, 7) * (ink/maxInk);
      float d = random(3, 5) * (ink/maxInk);
      // for(int i = 0; i < 100 * (ink/maxInk); ++i) {
      for(int i = 0; i < 100 * (ink/maxInk); ++i) {
        point(x+random(-d, d), y+random(-d, d));
      }
      --ink;
    }*/
    
    
    
    
    int nx = max(0, min(dim-1, int(x)));
    int ny = max(0, min(dim-1, int(y)));
    
    float d = 0.3;
    // Idea for using theta to discriminate in collision detection from j tarbell
    //if(hit[nx][ny] > 10000 || abs(hit[nx][ny]-otheta) < 5) {
        if(!invis) {
        fill(0, 0, 0, 0);
        stroke(c, 10);
        strokeWeight(1.5);
        int dotsPer = 0;
        // float thickness = random(bigThick * 0.9, bigThick * 1.1);
        float thickness = random(bigThick * 1, bigThick * 1);
        
        float dtx = tx-x;
        float dty = ty-y;
        float distt = sqrt(dtx*dtx + dty*dty);
        
        // float rat = maxDistt - distt;
        float rat = (y-sy)/(ty-sy);
        if(rat < 1.0/3) {
          float limit = 1.0/3;
          d = thickness * (rat/limit);
          dotsPer = int(75 * (rat/limit));
        } else if(rat < 2.0/3) {
          d = thickness;
          dotsPer = 75;
          startLast = rat;
        } else {
          float limit = 1;
          float scale = (rat - startLast) / (1 - startLast);
          
          d = thickness * (1 - scale);
          dotsPer = int(100 * (1 - scale));
        }
        
        if(y > ty) ink3 = 0;
        
        /*if(distt < 10 || y-ty > 30) {
          ink3 = 0;
          return;
        }*/
        
        float fac = bigThick * (minThick/maxThick);
        dotsPer *= fac;
        
        for(int i = 0; i < dotsPer; ++i) {
          point(x+random(-d, d), y+random(-d,d));
        }
      }
      // hit[nx][ny] = int(otheta);
    //} else if(abs(hit[nx][ny]-otheta) > 2) {
      // COLLISION W/ OTHER
      // ink3 = 0;
   // }
    
    if(random(1.0) < 0.01 && depth > 0 && ink3 > 0) {
      /*float newTheta = (theta+90) % 360;
      if(random(1.0) < 0.5) newTheta = (theta-90) % 360;*/
      float newTheta = (theta+random(-90, 90)) % 360;
      if(newTheta < 0) newTheta = 360 - newTheta;
      Dot child = new Dot(x, y, v, newTheta, randColor(), totalInk/2, depth-1);
      child.x += d * cos(newTheta * PI/180);
      child.y += d * sin(newTheta * PI/180);
      child.bigThick = d;
      child.ink1 = 0;
      newDots.add(child);
    }
  }
}

