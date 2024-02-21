//------------------------ Interpolation

int[] HSBcolorSamples = {360, 30, 240, 300, 180, 150};
UniformGrid uniformGrid;
int nx, ny;
Tool tool = new Tool();

float continuityField;
float domainPoint;

int dotSize = 20;
int rectSize = 200;

//Testing Matrixes
float[] point = new float[4]; //3D vector in affine coordinates [x,y,z,w]
float change = 0;
float delta = 0;
float[] reflectionMatrix = {0, -1, 1, -1, 0, 1, 0, 0, 1}; // Affine coordinate
float[] rotationMatrix = {cos(PI*change), -sin(PI*change), 0, sin(PI*change), cos(PI*change), 0, 0, 0, 1};
float[] matrix = {1, 0, 0, 1,
                  0, 1, 0, 1,
                  0, 0, 1, 1,
                  1, 1, 1, 1};

void setup() {
  size(800, 800, P3D);
  colorMode(HSB, 360, 100, 100);
  createCoordinatesSystem();


  int[] minPoint = {-320, -320};
  int[] maxPoint = {320, 320};
  nx = 8;
  ny = 8;
  uniformGrid = new UniformGrid(nx, ny, minPoint, maxPoint);

  for (int i = 0; i < uniformGrid.getSize(); i++) {
    float[] point = uniformGrid.getSamplePosition(i);
    fill(255);
    noStroke();
    ellipse(point[0], point[1], dotSize, dotSize);
  }
}

void mousePressed() {
  //createCoordinatesSystem();
  //sampleTwo = globalMouseX();
  //drawInterpolatedLine();
}


void draw() {
  background(0, 0, 0, .5);

  //Eye position: width/2, height/2, (height/2) / tan(PI/6)
  //Scene center: width/2, height/2, 0
  //Upwards axis: 0, 1, 0
  stroke(0, 100, 100);
  //rect();
  stroke(360, 0, 100);
  //line(0, 0, 200, 200, 0, 200);
  createCoordinatesSystem();
  //camera(width/2, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 0, 0);

  noFill();
  stroke(100);
  box(800);

  //Linear rotation matrix in affine coordinates
  change += PI * 0.009;
  //delta += 0.1;
  if (delta == 1) {
    delta = 0;
  }
  //println(delta);

  if (change >= (PI * 2)) {
    change = 0;
    println("Cycle ends");
  }
  rotationMatrix[0] = cos(change);
  rotationMatrix[1] = -sin(change);
  rotationMatrix[2] = 0;
  rotationMatrix[3] = sin(change);
  rotationMatrix[4] = cos(change);
  float[] anotherPoint = tool.applyMatrix3(point, rotationMatrix);

  matrix[3] = sin(change)*5;
  float[] yetAnotherPoint = tool.applyMatrix3(point, matrix);

  //animatedGrid();
  createPlane();
}

void createPlane() {

  float offSet = 0;
  float sample = 0;
  float scalar = 0.0001;
  float minium = 1;

  float[] vertexA = new float[3];
  float[] vertexB = new float[3];
  float[] vertexC = new float[3];
  for (int i = 0; i < uniformGrid.getSize(); i++) {

    //----------------------
    matrix[0] = 1;//cos(change + offSet);
    matrix[1] = 0;//-sin(change + offSet);

    matrix[3] = 0;//sin(change + offSet);
    matrix[4] = cos(change + offSet);//1

    sample = ((cos (change - offSet) * scalar ));
    uniformGrid.setSampleValue(i, sample);

    if ((i+nx) < (nx*ny)) {
      if ((i+1) % nx != 0) {
        float[] point = {0, 0, 0, 1};
        point[0] = uniformGrid.getSamplePosition(i)[0];
        point[1] = uniformGrid.getSamplePosition(i)[1];
        point[2] = uniformGrid.getSamplePosition(i)[2];

        float[] pointPrime = tool.applyMatrix4(point, matrix);

        float vectorMagnitud = sqrt(pow(pointPrime[0], 2)+pow(pointPrime[1], 2));

        vertexA = uniformGrid.getSamplePosition(i);
        vertexB = uniformGrid.getSamplePosition(i+1);
        vertexC = uniformGrid.getSamplePosition(i+nx);

        beginShape();//POINTS
        vertex(vertexA[0], vertexA[2]-100, vertexA[1]);
        vertex(vertexB[0], vertexB[2]-100, vertexB[1]);
        vertex(vertexC[0], vertexC[2]-100, vertexC[1]);
        endShape(CLOSE);//CLOSE
        offSet = (i*( PI/8 ));
      }
    }
  }
}

void animatedGrid() {
  //Applying matrix to the grid position.
  for (int i = 0; i < uniformGrid.getSize(); i++) {
    float[] point = {0, 0, 1};
    point[0] = uniformGrid.getSamplePosition(i)[0];
    point[1] = uniformGrid.getSamplePosition(i)[1];
    fill(255);
    noStroke();
    //anotherPoint = tool.applyMatrix3(point, rotationMatrix);
    //ellipse(anotherPoint[0], anotherPoint[1], dotSize, dotSize);
  }
  float offSet = 0;
  float sample = 0;
  float scalar = 10;
  float minium = 10;

  /*
  matrix[3] = sin(change)*5;
   
   matrix[0] = cos(change);
   matrix[1] = -sin(change);
   matrix[2] = 0;
   matrix[3] = sin(change);
   matrix[4] = cos(change);
   float[] yetAnotherPoint = tool.applyMatrix3(point, matrix);
   */
  for (int i = 0; i < uniformGrid.getSize(); i++) {
    matrix[0] = cos(change + offSet);
    matrix[1] = -sin(change + offSet);
    matrix[2] = 0;
    matrix[3] = sin(change + offSet);
    matrix[4] = cos(change + offSet);

    sample = ((cos (change - offSet) * scalar ));
    //sample = noise(delta - offSet )*minium;
    //(cos(change + (i/0.024) * 2) - (sin (change + (i*0.5)) * 8 ))+5;
    uniformGrid.setSampleValue(i, sample);
    //uniformGrid.setSampleValue(i, (sin(change + (i*0.001))*6)+3);
    float[] point = {0, 0, 1};
    point[0] = uniformGrid.getSamplePosition(i)[0];
    point[1] = uniformGrid.getSamplePosition(i)[1];

    float[] pointPrime = tool.applyMatrix3(point, matrix);
    offSet = (i*( PI/8 ));
    float vectorMagnitud = sqrt(pow(pointPrime[0], 2)+pow(pointPrime[1], 2));
    ellipse(point[0], point[1], (0.06*pointPrime[0]), (0.06*pointPrime[0]));
    //ellipse(point[0], point[1], (0.06*vectorMagnitud), (0.06*vectorMagnitud));
    //ellipse(point[0], point[1], uniformGrid.getSampleValue(i), uniformGrid.getSampleValue(i));
    //ellipse(point[0]+uniformGrid.getSampleValue(i), point[1]+uniformGrid.getSampleValue(i),uniformGrid.getSampleValue(i), uniformGrid.getSampleValue(i));
    //offSet += (i*0.00002);
  }
}

void createCoordinatesSystem() {
  //background(0, 0, 0, 5);
  translate(width/2, height/2);
  scale(1, -1);
  //createBackgroundGrid(20, 20, 40);
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
