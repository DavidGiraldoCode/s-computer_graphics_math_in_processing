UniformGrid uniformGrid;
int nx, ny;
Tool tool = new Tool();

float continuityField;
float domainPoint;

int dotSize = 20;
int rectSize = 200;

//Testing Matrixes
float[] bZero = {0, 0, 0};
float[] bOne = {100, 100, 0};
float[] bTwo = {0, 200, 0};
float t, x, y;
float[][] points = {{0, 0}, {0, 270}, {270, 270}, {270, 0}};
float[][] pointsXPrime = new float[4][4];
float[][] pointsYPrime = new float[4][4];

void setup() {
  colorMode(HSB, 360, 100, 100);
  size(800, 800);
  background(0, 0, 0);
  createCoordinatesSystem();

  for (int i = 0; i < points.length; i++) {
    ellipse(points[i][0], points[i][1], 10, 10);
  }

  casteljeaBezier(0.3, points);
}

void mousePressed() {
  background(0, 0, 0);
  createCoordinatesSystem();
  casteljeaParabola();
}

void casteljeaParabola() {
  ellipse(bZero[0], bZero[1], 10, 10);
  bOne[0] = globalMouseX();
  bOne[1] = globalMouseY();
  ellipse(bOne[0], bOne[1], 10, 10);
  ellipse(bTwo[0], bTwo[1], 10, 10);

  for (int i = 0; i < 100; i++) {
    t = ((i+1) / 100.0);
    x = (pow((1-t), 2)*bZero[0]) + (2*t*(1-t)*bOne[0]) + (pow(t, 2)*bTwo[0]);
    y = (pow((1-t), 2)*bZero[1]) + (2*t*(1-t)*bOne[1]) + (pow(t, 2)*bTwo[1]);
    println(i);
    println("t: "+t+" x:"+x+" y:"+y);
    ellipse(x, y, 2, 2);
  }
}

void casteljeaBezier(float t, float[][] points) {

  int n = points.length;
  float [][] bezierPoints = new float [n*n][2];
  float[][] bezierXpoints = new float[n][n];
  float[][] bezierYpoints = new float[n][n];

  bezierXpoints[0][0] = points[0][0];
  bezierXpoints[0][1] = points[1][0];
  bezierXpoints[0][2] = points[2][0];
  bezierXpoints[0][3] = points[3][0];

  bezierYpoints[0][0] = points[0][1];
  bezierYpoints[0][1] = points[1][1];
  bezierYpoints[0][2] = points[2][1];
  bezierYpoints[0][3] = points[3][1];

  println(bezierXpoints[0][2], bezierYpoints[0][2]);
  // r E [1, n]
  // i E [0, n-1]
  for (int r = 1; r < n; r++) {
    for (int i = 0; i < (n-r); i++) {
      int linearIndex = ((r-1)*n) + i;
      bezierPoints[linearIndex][0]= ((1-t)*bezierXpoints[r-1][i]) + (t * bezierXpoints[r-1][i+1]);
      bezierPoints[linearIndex][0]= 0;

      bezierXpoints[r][i] = ((1-t)*bezierXpoints[r-1][i]) + (t * bezierXpoints[r-1][i+1]);
      bezierYpoints[r][i] = ((1-t)*bezierYpoints[r-1][i]) + (t * bezierYpoints[r-1][i+1]);

      fill(360, 100, 100);
      ellipse(bezierXpoints[i][r], bezierYpoints[i][r], 5, 5);
      println("r:"+r+" i:"+i+" - X:"+bezierXpoints[r-1][i]+" Y:"+bezierYpoints[r-1][i]);
    }
  }
}

void draw() {
  //background(0, 0, 0, .5);
  //createCoordinatesSystem();
}

void createCoordinatesSystem() {
  //background(0, 0, 0, 5);
  translate(width/2, height/2);
  scale(1, -1);
  createBackgroundGrid(20, 20, 40);
  stroke(0, 255, 255);
  line(-width, 0, width, 0); // X axis
  stroke(119, 255, 255);
  line(0, -height, 0, height); // Y axis
  noStroke();
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


/*
/*
 //the amount of new data points to interpolate
 //It can not be 1 because 1/continuity = 1, and 1 means the sample f(X1)
 continuityField = 40;
 createCoordinatesSystem();
 int[] min = {-380, 0};
 int[] max = {380, 0};
 //uniformGrid = createUniformSampleGrid(min, max, HSBcolorSamples.length, 1);
 uniformGrid = new UniformGrid(6, 1, min, max);
 
 for (int i = 0; i < uniformGrid.getSize(); i++) {
 //Sample f(X0);
 color c = color(HSBcolorSamples[i], 255, 255);
 fill(c);
 stroke(360, 0, 100);
 int[] point = uniformGrid.getSamplePosition(i);
 rect(point[0], point[1], rectWidth, rectHeigth);
 //interpolation.
 if (i+1 != uniformGrid.getSize()) {
 for (int j = 0; j < continuityField-1; j++) {
 domainPoint = (j* (1/continuityField) + (1/continuityField));
 color cField = color(int(linearInterpolation(domainPoint, HSBcolorSamples[i], HSBcolorSamples[i+1])), 255, 255);
 fill(cField);
 float xField = linearInterpolation(domainPoint, uniformGrid.getSamplePosition(i)[0], uniformGrid.getSamplePosition(i+1)[0]);
 float yField = uniformGrid.getSamplePosition(i)[1];
 noStroke();
 rect(int(xField), int(yField), rectWidth, rectHeigth);
 }
 }
 }
 */
/*
int[][] createUniformSampleGrid(int[] minPoint, int[] maxPoint, int nx, int ny) {
 
 int[][] uniformGrid = new int[(nx*ny)][2];
 int nCols = nx - 1; //number of rows
 int nRows = ny - 1; //number of columns
 
 int xMin =  minPoint[0];
 int yMin =  minPoint[1];
 
 int xMax =  maxPoint[0];
 int yMax =  maxPoint[1];
 
 int dx = (xMax - xMin) / nCols;
 int dy = 0;
 if (ny > 1) {
 dy = (yMax - yMin) / nRows;
 }
 
 
 for (int j = 0; j < ny; j++) {
 for (int i = 0; i < nx; i++) {
 println("j: "+j+" i: "+i );
 
 uniformGrid[(j*nx)+i][0] = (i*dx) + xMin;
 if (ny > 1) {
 uniformGrid[(j*nx)+i][1] = (j*dy) + yMin;
 } else {
 uniformGrid[(j*nx)+i][1] = yMin;
 }
 println("uniformGrid["+((j*nx)+i)+"][0] = "+((i*dx) + xMin));
 println("uniformGrid["+((j*nx)+i)+"][1] = "+((j*dy) + yMin));
 println("-----------------");
 }
 }
 
 return uniformGrid;
 }
 */
/*
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
 }*/
