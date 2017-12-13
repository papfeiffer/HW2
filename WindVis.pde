// uwnd stores the 'u' component of the wind.
// The 'u' component is the east-west component of the wind.
// Positive values indicate eastward wind, and negative
// values indicate westward wind.  This is measured
// in meters per second.
Table uwnd;

// vwnd stores the 'v' component of the wind, which measures the
// north-south component of the wind.  Positive values indicate
// northward wind, and negative values indicate southward wind.
Table vwnd;

// An image to use for the background.  The image I provide is a
// modified version of this wikipedia image:
//https://commons.wikimedia.org/wiki/File:Equirectangular_projection_SW.jpg
// If you want to use your own image, you should take an equirectangular
// map and pick out the subset that corresponds to the range from
// 135W to 65W, and from 55N to 25N
PImage img;

HashMap<Float, float[]> particles = new HashMap<Float, float[]>();


void setup() {
  // If this doesn't work on your computer, you can remove the 'P3D'
  // parameter.  On many computers, having P3D should make it run faster
  size(700, 400, P3D);
  pixelDensity(displayDensity());
  
  img = loadImage("background.png");
  uwnd = loadTable("uwnd.csv");
  vwnd = loadTable("vwnd.csv");
  
  //Draw initial particles
  //drawParticles();
    particleList();
    
}


void draw() {
  background(255);
  image(img, 0, 0, width, height);
  drawMouseLine();
  
   for (HashMap.Entry me: particles.entrySet()) {
    float [] g = (float[]) me.getValue();
    beginShape(POINTS);
    vertex(g[0], g[1]);    
    endShape();
    }
    

      
      //float x = (float) me.getKey();
      //if (x != 0) {
      
      //particles.put(x-1, particles.remove(x));
      
      //}
    //}
      
    
    for (HashMap.Entry me: particles.entrySet()) {
      float x = (float) me.getKey();
  
 //     float [] coordinates = particles.remove(x);
   //   particles.put(x-1, coordinates);
      
      if (x == 0) {
        particles.remove(x);  //remove value for key x
        float [] newCoordinates = new float[2];
        float x1 = random(700);
        float y1 = random(400);
        newCoordinates[0] = x1;
        newCoordinates[1] = y1;
        float random = random(200); //new lifetime
        
        particles.put(random, newCoordinates);
              
      }
    }
  
}

void drawMouseLine() {
  // Convert from pixel coordinates into coordinates
  // corresponding to the data.
  float a = mouseX * uwnd.getColumnCount() / width;
  float b = mouseY * uwnd.getRowCount() / height;
  
  // Since a positive 'v' value indicates north, we need to
  // negate it so that it works in the same coordinates as Processing
  // does.
  float dx = readInterp(uwnd, a, b) * 10;
  float dy = -readInterp(vwnd, a, b) * 10;
  line(mouseX, mouseY, mouseX + dx, mouseY + dy);
}

// Reads a bilinearly-interpolated value at the given a and b
// coordinates.  Both a and b should be in data coordinates.
float readInterp(Table tab, float a, float b) {
  //tab = u component or v component
  //grid units
  
  //original values
  float x = a;
  float y = b;
  
  int x1 = int(a);
  int x2 = x1+1;
  int y1 = int(b);
  int y2 = y1+1;
  // TODO: do bilinear interpolation
  // 2D array
  //return readRaw(tab, x, y);
  float Q11 = readRaw(tab, x1, y1);
  float Q12 = readRaw(tab, x1, y2);
  float Q22 = readRaw(tab, x2, y2);
  float Q21 = readRaw(tab, x2, y1);
  
  return (1.0/((x2-x1)*(y2-y1))) * ((Q11*(x2-x)*(y2-y)) + 
          (Q21*(x-x1)*(y2-y)) + (Q12*(x2-x)*(y-y1)) + (Q22*(x-x1)*(y-y1)));
}

// Reads a raw value 
float readRaw(Table tab, int x, int y) {
  if (x < 0) {
    x = 0;
  }
  if (x >= tab.getColumnCount()) {
    x = tab.getColumnCount() - 1;
  }
  if (y < 0) {
    y = 0;
  }
  if (y >= tab.getRowCount()) {
    y = tab.getRowCount() - 1;
  }
  return tab.getFloat(y,x);
}

//Draw particles
//Use 2000 particles
//1. Assign all particles a random position and a random lifetime (0-200)
//2. With each draw frame, a particle's lifetime should be decreased by 1
//3. With each draw frame, we need to update the positions of all particles 
//   using Runge-Kutta (but use Euler first)
//3. When the lifetime gets to 0, the particle should be given a new random position 
//   and random lifetime

//Maybe use a particle class?

//beginShape(POINTS)
//Add particles to list in HashMap form
void particleList() {
  
  for(int i = 0; i < 2000; i++) {
    float[] miniList = new float[2];
    float x = random(700);
    float y = random(400);
    miniList[0] = x;
    miniList[1] = y;
    //beginShape(POINTS);
    //vertex(x, y);    
    //endShape();
    float lifetime = random(200);
    particles.put(lifetime, miniList);
    }  
}

void checkParticles() {
  
  
  
}