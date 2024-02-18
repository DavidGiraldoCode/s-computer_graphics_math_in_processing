//------------------------ Interpolation
int[] HSBcolorSamples = {360, 30, 240, 300, 180, 150};
int[][] uniformGrid;

float continuityField;
float domainPoint;

int rectWidth = 5;
int rectHeigth = 200;

void setup() {
  colorMode(HSB, 360, 100, 100);
  size(800, 800);
  /*
   the amount of new data points to interpolate
   It can not be 1 because 1/continuity = 1, and 1 means the sample f(X1)
   */
  continuityField = 40;
  createCoordinatesSystem();
  int[] min = {-380, 0};
  int[] max = {380, 0};
  uniformGrid = createUniformSampleGrid(min, max, HSBcolorSamples.length, 1);

  for (int i = 0; i < uniformGrid.length; i++) {
    //Sample f(X0);
    color c = color(HSBcolorSamples[i], 255, 255);
    fill(c);
    stroke(360, 0, 100);
    rect(int(uniformGrid[i][0]), int(uniformGrid[i][1]), rectWidth, rectHeigth);
    //interpolation.
    if (i+1 != uniformGrid.length) {
      for (int j = 0; j < continuityField-1; j++) {
        domainPoint = (j* (1/continuityField) + (1/continuityField));
        color cField = color(int(linearInterpolation(domainPoint, HSBcolorSamples[i], HSBcolorSamples[i+1])), 255, 255);
        fill(cField);
        float xField = linearInterpolation(domainPoint, uniformGrid[i][0], uniformGrid[i+1][0]);
        float yField = uniformGrid[i][1];
        noStroke();
        rect(int(xField), int(yField), rectWidth, rectHeigth);
      }
    }
  }
}

void drawInterpolatedLine() {
  /*noStroke();
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
   }*/
}

float linearInterpolation( float t, float startSample, float endSample) {
  /*
  Special case in which "t" belongs [0,1]
   (1-t)*f(X0) + t*f(X1)
   */
  float interpolated = ((1-t) * startSample) + (t*endSample);
  return interpolated;
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

void mousePressed() {
  //createCoordinatesSystem();
  //sampleTwo = globalMouseX();
  //drawInterpolatedLine();
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