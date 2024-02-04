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

void setup() {
  //noCursor();
  size(800, 800);
  background(0, 0, 0, 5);
  createCoordinatesSystem();
  stroke(255);
  noSmooth();
  for (int i = 0; i < 100; i++) {
    //println(cuadraticCurve((i*4)));
    //point(int(i*2), cuadraticCurve(i*0.2));
    //point((i*0.8), field((i*0.2),i));
    
    point((i*0.4) , scalarField((i*0.4),(i*0.1)));
  }
  //print(matrix[0].length);
}


float scalarField(float x, float y){
  
  float result = 2*(x*y) + (4*(y*y));
  return result;
}

float field(float x, float y){
  
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

void mousePressed() {
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
