/* Brute force approach to vector fields interpolation of scattred data
 *
 *
 Log 2024 05 2
 I created a gaussian elimination def in C# with ChatGPT to compute the
 lamdas of the systems of lienar equations. Then pass them here.
 double[,] matrixX = {
 {0,     2.82,  2,   1 }, //LambaX1 = -0.427
 {2.82,  0,     2,   0 }, //LambaX2 = -0.072
 {2,     2,     0,   -1 }, //LambaX3 = 0.60
 };
 double[,] matrixY = {
 {0,     2.82,  2,   2 }, //LambaY1 = 0.322
 {2.82,  0,     2,   1 }, //LambaY2 = 0.677
 {2,     2,     0,   2 }, //LambaY3 = 0.045
 };
 Now the vectors seems to behaive properly.
 
 */
float[] B00 = {-360, -360}; //Boundari point
float[] B10 = {360, -360}; //Boundari point
float[] B01 = {-360, 360}; //Boundari point
float[] B11 = {360, 360}; //Boundari point
float[] BoundVector = {0, 0};

float[] P1 = {200, 200}; //Source points
float[] P2 = {-200, -200}; //Source points
float[] P3 = {0, 0}; //Source points

float[] V1 = {50, 100}; //Vector at source points
float[] V2 = {-20, 60}; //Vector at source points
float[] V3 = {80, 0}; //Vector at source points

float[] P  = new float[2]; //Any point and Interpolated Vector
float[] V  = new float[2]; //Any point and Interpolated Vector

int l =0;

Tools tools = new Tools();
UniformGrid pointsGrid;

int nx, ny = 0;
int[] minPoint;
int[] maxPoint;

float change = 0;
float offSet = 0;
float sample = 0;
float scalar = 0.03;
float minium = 600;

void setup() {
  size(800, 800);
  //colorMode(HSB, 360, 100, 100);
  background(0, 0, 0);
  createCoordinatesSystem();

  minPoint = new int[2];
  maxPoint = new int[2];

  nx = 32;
  ny = 32;
  minPoint[0]=-360;
  minPoint[1]=-360;

  maxPoint[0]=360;
  maxPoint[1]=360;

  pointsGrid = new UniformGrid(nx, ny, minPoint, maxPoint);

  renderSourceVectorAtPoint(B00, BoundVector);
  renderSourceVectorAtPoint(B01, BoundVector);
  renderSourceVectorAtPoint(B10, BoundVector);
  renderSourceVectorAtPoint(B11, BoundVector);

  renderSourceVectorAtPoint(P1, V1);
  renderSourceVectorAtPoint(P2, V2);
  renderSourceVectorAtPoint(P3, V3);

  //computeRBD_BruteForce(P);
  renderVectorFieldGrid();
}

void renderSourceVectorAtPoint(float[] point, float[] vector)
{
  stroke(255);
  pushMatrix();
  translate(point[0], point[1]);
  line(0, 0, vector[0], vector[1]);
  ellipse(vector[0], vector[1], 10, 10);
  popMatrix();
}

void renderAnyVectorAtAnyPoint(float[] point, float[] vector)
{
  float[] plotVector = vector;//tools.vertorNorm(vector);
  float scalar = 0.5;
  int val = (int)map(tools.vectorMagnitud(vector), 0, 200, 0, 255);
  stroke(val+100);
  pushMatrix();
  translate(point[0], point[1]);
  line(0, 0, plotVector[0]*scalar, plotVector[1]*scalar);
  popMatrix();
}

void computeRBD_BruteForce(float[] point)
{
  /*
   Logs 2024 05 1
   - It does not yield the desired outcome
   Vector is getting shorter the closer they get to the source
   and it shoudl the the opposite.
   
   Logs 2024 05 1
   - Computing the interpolant for each v-coordinate to find lamba
   for each coordinate. This works.
   But there are some wird behaviors sucha as the V vector growing to much when going far away from V1
   [Phi]matrix x [LamdaX]vector = [x-sourceVectorCoordinates]
   [Phi]matrix x [LamdaY]vector = [x-sourceVectorCoordinates]
   */

  // Computed by hand

  float[] Xlamdas = {
    -0.013,
    -0.059,
    0.035,
    0.054,
    -0.303,
    -0.058,
    0.342
  };

  float[] Ylamdas = {
    0.025,
    0.090,
    0.036,
    0.093,
    -0.171,
    0.073,
    -0.192
  };

  float[][] distances = new float[7][2];
  float[] radious = {0, 0, 0, 0, 0, 0, 0};
  float[] RBFs = {0, 0, 0, 0, 0, 0, 0};
  float[][] vectors = {B00, B01, B10, B11, P1, P2, P3};
  float interpolantX = 0;
  float interpolantY = 0;

  for (int i = 0; i < 7; i++)
  {
    distances[i] = tools.vectorSubstraction(P, vectors[i]);
    radious[i] = tools.vectorMagnitud(distances[i]);
    RBFs[i] = radious[i];
    interpolantX += Xlamdas[i] * RBFs[i];
    interpolantY += Ylamdas[i] * RBFs[i];
  }
  float[] InterpolatedVector = {interpolantX, interpolantY};
  renderAnyVectorAtAnyPoint(point, InterpolatedVector);
  /*
  float[] distanceV1 = tools.vectorSubstraction(P, P1);
   float r1 = tools.vectorMagnitud(distanceV1);
   float RBF1 = 1/r1;//pow(2.7,2/r1);//pow(r1,2) * log10(r1);//r1;//pow(r1,2) * log10(r1);
   
   float[] distanceV2 = tools.vectorSubstraction(P, P2);
   float r2 = tools.vectorMagnitud(distanceV2);
   float RBF2 = 1/r2;//pow(2.7,2/r2);;//pow(r2,2) * log10(r2);//r2;// ;
   
   float[] distanceV3 = tools.vectorSubstraction(P, P3);
   float r3 = tools.vectorMagnitud(distanceV3);
   float RBF3 = 1/r3;//pow(2.7,2/r3);//pow(r3,2) * log10(r3);//r2;//
   */
  //float interpolantX = (lamdaX1 * RBF1) + (lamdaX2 * RBF2) + (lamdaX3 * RBF3);
  //float interpolantY = (lamdaY1 * RBF1) + (lamdaY2 * RBF2) + (lamdaY3 * RBF3);
}
// Calculates the base-10 logarithm of a number
float log10 (float x) {
  return (log(x) / log(10));
}

float[] matrix = {
  1, 0, 0, 0,
  0, 1, 0, 0,
  0, 0, 1, 0,
  0, 0, 0, 1};

void draw() {
}

float[] setVectorAtPoint(float[] point)
{
float[] Xlamdas = {
    -0.069,
    0.031,
    0.031,
    0.084,
    -0.068,
    0.209,
    -0.246
};

float[] Ylamdas = {
    0.104,
    0.034,
    0.034,
    0.193,
    -0.409,
    -0.250,
    0.265
};



  float[][] distances = new float[7][2];
  float[] radious = {0, 0, 0, 0, 0, 0, 0};
  float[] RBFs = {0, 0, 0, 0, 0, 0, 0};
  float[][] sourcePoints = {B00, B01, B10, B11, P1, P2, P3};
  float interpolantX = 0;
  float interpolantY = 0;

  for (int i = 0; i < 7; i++)
  {
    distances[i] = tools.vectorSubstraction(point, sourcePoints[i]);
    radious[i] = tools.vectorMagnitud(distances[i]);
    RBFs[i] = radious[i];
    interpolantX += Xlamdas[i] * RBFs[i];
    interpolantY += Ylamdas[i] * RBFs[i];
  }
  float[] InterpolatedVector = {interpolantX, interpolantY};
  
  return InterpolatedVector;
}

float[] setVectorAtPointWithOutBounds(float[] point) {

  float lamdaX1 = -0.427;
  float lamdaX2 = -0.072;
  float lamdaX3 = 0.60;

  float lamdaY1 = 0.322;
  float lamdaY2 = 0.677;
  float lamdaY3 = 0.045;

  float[] distanceV1 = tools.vectorSubstraction(point, P1);
  float r1 = tools.vectorMagnitud(distanceV1);
  float RBF1 = r1;//pow(r1,2) * log10(r1);

  float[] distanceV2 = tools.vectorSubstraction(point, P2);
  float r2 = tools.vectorMagnitud(distanceV2);
  float RBF2 = r2;// pow(r2,2) * log10(r2);

  float[] distanceV3 = tools.vectorSubstraction(point, P3);
  float r3 = tools.vectorMagnitud(distanceV3);
  float RBF3 = r2;// pow(r2,2) * log10(r2);

  float interpolantX = (lamdaX1 * RBF1) + (lamdaX2 * RBF2) + (lamdaX3 * RBF3);
  float interpolantY = (lamdaY1 * RBF1) + (lamdaY2 * RBF2) + (lamdaY3 * RBF3);

  float[] InterpolatedVector = {interpolantX, interpolantY};

  return InterpolatedVector;
}

void renderVectorFieldGrid() {
  println(pointsGrid.getSamplePosition(0));

  for (int i = 0; i < pointsGrid.getSize(); i++)
  {

    fill(255);
    noStroke();
    float x = pointsGrid.getSamplePosition(i)[0];
    float y = pointsGrid.getSamplePosition(i)[1];

    float[] point = {x, y};
    float[] vector = setVectorAtPoint(point);
    renderAnyVectorAtAnyPoint(point, vector);
    ellipse(x, y, 1, 1);
  }
}

void mousePressed() {
  background(0, 0, 0);
  createCoordinatesSystem();

  renderSourceVectorAtPoint(P1, V1);
  renderSourceVectorAtPoint(P2, V2);
  renderSourceVectorAtPoint(P3, V3);

  P[0] = globalMouseX();
  P[1] = globalMouseY();

  computeRBD_BruteForce(P);
}

void createCoordinatesSystem() {
  //background(0, 0, 0, 5);
  translate(width/2, height/2);
  scale(1, -1);
  createBackgroundGrid(20, 20, 50);
  stroke(255, 0, 0);
  line(-width, 0, width, 0); // X axis
  stroke(0, 255, 0);
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
