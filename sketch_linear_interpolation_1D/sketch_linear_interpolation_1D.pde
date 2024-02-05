//------------------------ Interpolation
float sampleOne;
float sampleTwo;
float continuity;
float domainPoint; 

int pixelSize = 5;

void setup() {
  colorMode(HSB, 255);
  size(800, 800);

  sampleOne = 0;
  sampleTwo = 387;

  /*
   the amount of new data points to interpolate
   It can not be 1 because 1/continuity = 1, and 1 means the sample f(X1)
   */
  continuity = 200;
  createCoordinatesSystem();
  drawInterpolatedLine();
}

void drawInterpolatedLine() {
  noStroke();
  noSmooth();
  println(sampleOne); // The sample f(Xo)
  fill(255, 0, 0);
  rect(sampleOne, 0, pixelSize, pixelSize);

  println(sampleTwo);//The sample f(X1)
  fill(0, 255, 0);
  rect(sampleTwo, 0, pixelSize, pixelSize);

  for (int i = 0; i < continuity-1; i++) {
    domainPoint = (i*(1 / continuity)) + (1 / continuity);
    //t starts from "+ (1 / continuity)" because 0 means f(X0)
    color c = color(int(linearInterpolation(domainPoint, 0, 119)), 255, 255);
    fill(c);
    //stroke(255);
    //point(linearInterpolation(t, sampleOne, sampleTwo), 0);
    rect(linearInterpolation(domainPoint, sampleOne, sampleTwo), 0, pixelSize, pixelSize);
    println("interpolated: "+linearInterpolation(domainPoint, sampleOne, sampleTwo));
  }
}

float linearInterpolation( float t, float startSample, float endSample) {
  /*
  Special case in which "t" belongs [0,1]
   (1-t)*f(X0) + t*f(X1)
   */
  float interpolated = ((1-t) * startSample) + (t*endSample);
  return interpolated;
}


void mousePressed() {
  createCoordinatesSystem();
  sampleTwo = globalMouseX();
  drawInterpolatedLine();
}


void draw() {
}

void createCoordinatesSystem() {
  background(0, 0, 0, 5);
  translate(width/2, height/2);
  scale(1, -1);
  createBackgroundGrid(20, 20, 40);
  stroke(0, 255, 255);
  line(-width, 0, width, 0); // X axis
  stroke(119, 255, 255);
  line(0, -height, 0, height); // Y axis
}

void createBackgroundGrid(int rows, int coloumns, int cellSize) {
  for (int j = 0; j < coloumns; j++) {
    for (int i = 0; i < rows; i++) {
      stroke(24);
      line(-width, (j*cellSize)-(height/2), width, (j*cellSize)-(height/2)); // X axis
      line((i*cellSize)-(width/2), -height, (i*cellSize)-(width/2), height); // Y axis
    }
  }
}

int globalMouseX() {
  return mouseX - (width/2);
}
int globalMouseY() {
  return -1*(mouseY - (height/2));
}
