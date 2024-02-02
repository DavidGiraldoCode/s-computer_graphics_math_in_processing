int[] point = new int[3];
int[][] matrix = {{0,-1,30},{-1,0,30},{0,0,1}};

void setup() {
  size(800, 800);
  print(matrix[0].length);
}

void draw() {
  createCoordinatesSystem();
  stroke(255);
  line(-300, getY(-300), 300, getY(300));

  point[0] = globalMouseX();
  point[1] = globalMouseY();
  point[2] = 1;
  
  noStroke();
  fill(255);
  ellipse(point[0], point[1], 10, 10);
  int[] newPoint = getNewPoint(matrix, point);
  fill(255,0,0);
  ellipse(newPoint[0], newPoint[1], 8, 8);
  //print(newPoint);
}

void createCoordinatesSystem() {
  background(0, 0, 0, 0.1);
  translate(width/2, height/2);
  scale(1, -1);
  createGrid(10, 10, 50);
  //noStroke();
  //ellipse(mouseX - (width/2), -1*(mouseY - (height/2)), 24, 24);
  noCursor();
  stroke(255, 0, 0);
  line(-width, 0, width, 0); // X axis
  stroke(0, 255, 0);
  line(0, -height, 0, height); // Y axis
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
      stroke(100);
      line(-width, j*cellSize, width, j*cellSize); // X axis
      line(i*cellSize, -height, i*cellSize, height); // Y axis
    }
  }
}

int getY(int x) {
  return -x + 30;
}

int[] getNewPoint(int[][] matrix, int[] point) {
  int[] newPoint = new int[3];

  for (int mRow=0; mRow < matrix.length; mRow++) {
    for (int mCol=0; mCol < matrix[mRow].length; mCol++) {
      newPoint[mRow] += point[mCol] * matrix[mRow][mCol];
    }
  }
  return newPoint;
}
