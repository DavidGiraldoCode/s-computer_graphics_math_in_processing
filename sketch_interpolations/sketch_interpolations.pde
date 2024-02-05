float[] point = new float[3];
float[][] matrix = {{0, -1, 30}, {-1, 0, 30}, {0, 0, 1}};

//float[] rotatedPoint = new float[3];
//float delta = 0;
//float[][] rotationMatrix = {{cos(PI*delta), -sin(PI*delta), 0}, {sin(PI*delta), cos(PI*delta), 0}, {0, 0, 1}};
int[] minPoint = new int[2];
int[] maxPoint = new int[2];
int nx, ny;
int[][] uniformGrid;

int[][] pointsCloud;
//------------------------ Interpolation
float sampleOne;
float sampleTwo;
float continuity;

void setup() {
  //noCursor();
  sampleOne = 14;
  sampleTwo = 387;
  continuity = 20; // the amount of new data points to interpolate
  size(800, 800);
  background(0, 0, 0, 5);
  createCoordinatesSystem();
  drawInterpolatedLine();
}

void drawInterpolatedLine() {
  noStroke();
  noSmooth();
  println(sampleOne); // The sample f(Xo)
  for (int i = 0; i < continuity; i++) {
    float t = i*(1 / continuity);
    ellipse(linearInterpolation(t, sampleOne, sampleTwo), 0, 10, 10);
    println("interpolated: "+linearInterpolation(t, sampleOne, sampleTwo));
  }
  fill(255, 0, 0);
  ellipse(sampleOne, 0, 10, 10);
  fill(0, 255, 0);
  ellipse(sampleTwo, 0, 10, 10);
  println(sampleTwo);//The sample f(Xo)
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
  background(0, 0, 0, 5);
  createCoordinatesSystem();
  sampleTwo = globalMouseX();
  drawInterpolatedLine();
}


float scalarField(float x, float y) {

  float result = 2*(x*y) + (4*(y*y));
  return result;
}

float field(float x, float y) {

  float result = (x * x) + (x*y);
  return result;
}

float cuadraticCurve(float base) { //, int m, int c
  float exponent = 3;
  float result = 1;
  while (exponent != 0) {

    result *= base;
    exponent--;
  }
  return result; //m*x + c;
}




void draw() {
}

void createCoordinatesSystem() {
  translate(width/2, height/2);
  scale(1, -1);
  createGrid(20, 20, 40);
  stroke(255, 0, 0);
  line(-width, 0, width, 0); // X axis
  stroke(0, 255, 0);
  line(0, -height, 0, height); // Y axis
}

int[][] createUniformSampleGrid(int[] minPoint, int[] maxPoint, int nx, int ny) {

  int[][] uniformGrid = new int[(nx*ny)][2];
  int nCols = nx - 1; //number of rows
  int nRows = ny - 1; //number of columns

  int xMin =  minPoint[0];
  int yMin =  minPoint[1];

  int xMax =  maxPoint[0];
  int yMax =  maxPoint[1];

  int dx = (xMax - xMin) / nCols;
  int dy = (yMax - yMin) / nRows;

  for (int j = 0; j < ny; j++) {
    for (int i = 0; i < nx; i++) {
      println("j: "+j+" i: "+i );

      uniformGrid[(j*nx)+i][0] = (i*dx) + xMin;
      uniformGrid[(j*nx)+i][1] = (j*dy) + yMin;

      println("uniformGrid["+((j*nx)+i)+"][0] = "+((i*dx) + xMin));
      println("uniformGrid["+((j*nx)+i)+"][1] = "+((j*dy) + yMin));
      println("-----------------");
    }
  }

  return uniformGrid;
}


int globalMouseX() {
  return mouseX - (width/2);
}
int globalMouseY() {
  return -1*(mouseY - (height/2));
}

void createGrid(int rows, int coloumns, int cellSize) {
  for (int j = 0; j < coloumns; j++) {
    for (int i = 0; i < rows; i++) {
      stroke(24);
      line(-width, (j*cellSize)-(height/2), width, (j*cellSize)-(height/2)); // X axis
      line((i*cellSize)-(width/2), -height, (i*cellSize)-(width/2), height); // Y axis
    }
  }
}

/*
int getY(int x) { //, int m, int c
 return -x + 30; //m*x + c;
 }
 
 float[] getNewPoint(float[][] matrix, float[] point) {
 float[] newPoint = new float[3];
 for (int mRow=0; mRow < matrix.length; mRow++) {
 for (int mCol=0; mCol < matrix[mRow].length; mCol++) {
 newPoint[mRow] += point[mCol] * matrix[mRow][mCol];
 }
 }
 return newPoint;
 }*/
