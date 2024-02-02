float[] point = new float[3];
float[][] matrix = {{0, -1, 30}, {-1, 0, 30}, {0, 0, 1}};

float[] rotatedPoint = new float[3];
float delta = 0;
float[][] rotationMatrix = {{cos(PI*delta), -sin(PI*delta), 0}, {sin(PI*delta), cos(PI*delta), 0}, {0, 0, 1}};

void setup() {
  size(800, 800);
  print(matrix[0].length);
}

void draw() {
  background(0, 0, 0, 5);
  createCoordinatesSystem();
  stroke(255);
  line(-300, getY(-300), 300, getY(300));

  point[0] = globalMouseX();
  point[1] = globalMouseY();
  point[2] = 1; // Affine coordinate

  noStroke();
  fill(255);
  ellipse(point[0], point[1], 10, 10);
  float[] newPoint = getNewPoint(matrix, point);
  fill(255, 0, 0);
  ellipse(newPoint[0], newPoint[1], 8, 8);

  float[] p = {50, 0, 1};
  delta = map (globalMouseX(), -width/2 , width/2, 0, 1);
  
  println(delta);
  rotationMatrix[0][0] = cos(PI/delta);
  rotationMatrix[0][1] = -sin(PI/delta);
  rotationMatrix[1][0] = sin(PI/delta);
  rotationMatrix[1][1] = cos(PI/delta);
  rotatedPoint = getNewPoint(rotationMatrix, p);
  fill(0, 255, 0);
  ellipse(rotatedPoint[0], rotatedPoint[1], 8, 8);

  //print(newPoint);
}

void createCoordinatesSystem() {
  translate(width/2, height/2);
  scale(1, -1);
  createGrid(20, 20, 40);
  noCursor();
  stroke(255, 0, 0);
  line(-width, 0, width, 0); // X axis
  stroke(0, 255, 0);
  line(0, -height, 0, height); // Y axis
}

float globalMouseX() {
  return mouseX - (width/2);
}
int globalMouseY() {
  return -1*(mouseY - (height/2));
}

void createGrid(int rows, int coloumns, int cellSize) {
  for (int j = 0; j < coloumns; j++) {
    for (int i = 0; i < rows; i++) {
      stroke(50);
      line(-width, (j*cellSize)-(height/2), width, (j*cellSize)-(height/2)); // X axis
      line((i*cellSize)-(width/2), -height, (i*cellSize)-(width/2), height); // Y axis
    }
  }
}

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
}
