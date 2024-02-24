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
/*
4 pointa to render using 4 colors
 Given a linear index L = 0, get to the 4 points at once with offsets
 */
int[][] points = {{0, 0}, {100, 0}, {0, 100}, {100, 100}};// P00, P10, P01, P11;
int l = 0;

void setup() {
  //noCursor();
  size(800, 800);
  background(0, 0, 0, 5);
  createCoordinatesSystem();
  //print(matrix[0].length);

  pointsCloud = new int[int(random(100, 500))][2];

  for (int i = 0; i < pointsCloud.length; i++) {
    pointsCloud[i][0] = int(random(-250, 250));
    pointsCloud[i][1] = int(random(-250, 250));
    strokeCap(PROJECT);
    noSmooth();
    stroke(255);
    //point(pointsCloud[i][0], pointsCloud[i][1]);
  }

  minPoint[0] = -146;
  minPoint[1] = -9;
  maxPoint[0] = 329;
  maxPoint[1] = 234;

  /*
  minPoint[0] = 0;
   minPoint[1] = 0;
   maxPoint[0] = 60;
   maxPoint[1] = 60;*/

  nx = 4;
  ny = 4;
  //print(newPoint);
  noStroke();
  fill(255, 0, 0);
  ellipse(minPoint[0], minPoint[1], 10, 10);
  fill(0, 255, 0);
  ellipse(maxPoint[0], maxPoint[1], 10, 10);

  uniformGrid = createUniformSampleGrid(minPoint, maxPoint, nx, ny);
  strokeCap(PROJECT);
  noSmooth();
  stroke(255);
  for (int i =0; i < uniformGrid.length; i++) {
    point(uniformGrid[i][0], uniformGrid[i][1]);
  }

  linearIndexOffsetting();
}

void draw() {
}

void linearIndexOffsetting() {

  int nx = 2;

  int p00 = l;
  int p10 = floor(l/nx)*nx + ((l%nx)+1);//l+1;
  int p01 = (floor(l/nx)+1)*nx + (l%nx); //l+nx;
  int p11 = (floor(l/nx)+1)*nx + ((l%nx)+1);//l+nx+1;

  noStroke();
  fill(0);
  ellipse(points[p00][0], points[p00][1], 10, 10);

  fill(255, 0, 0);
  ellipse(points[p10][0], points[p10][1], 10, 10);

  fill(0, 255, 0);
  ellipse(points[p01][0], points[p01][1], 10, 10);

  fill(0, 0, 255);
  ellipse(points[p11][0], points[p11][1], 10, 10);
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

  minPoint[0] = -146;
  minPoint[1] = -9;
  maxPoint[0] = globalMouseX();
  maxPoint[1] = globalMouseY();

  background(0, 0, 0, 5);
  createCoordinatesSystem();
  //println(newPoint);
  noStroke();
  fill(255, 0, 0);
  ellipse(minPoint[0], minPoint[1], 10, 10);
  fill(0, 255, 0);
  ellipse(maxPoint[0], maxPoint[1], 10, 10);

  uniformGrid = createUniformSampleGrid(minPoint, maxPoint, nx, ny);
  strokeCap(PROJECT);
  noSmooth();
  stroke(255);
  for (int i =0; i < uniformGrid.length; i++) {
    point(uniformGrid[i][0], uniformGrid[i][1]);
  }
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
