/* Brute force approach to vector fields interpolation of scattred data
 *
 *
 *
 */
float[] P1 = {-100, -200}; //Source points
float[] P2 = {100, 100}; //Source points
float[] V1 = {0, 100}; //Vector at source points
float[] V2 = {100, 0}; //Vector at source points

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

  nx = 2;//32;
  ny = 2;//24;
  minPoint[0]=100;
  minPoint[1]=100;

  maxPoint[0]=800;
  maxPoint[1]=600;

  pointsGrid = new UniformGrid(nx, ny, minPoint, maxPoint);

  renderSourceVectorAtPoint(P1, V1);
  renderSourceVectorAtPoint(P2, V2);
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
  stroke(0, 0, 255);
  pushMatrix();
  translate(point[0], point[1]);
  line(0, 0, vector[0], vector[1]);
  ellipse(vector[0], vector[1], 10, 10);
  popMatrix();
}

void computeRBD_BruteForce(float[] point)
{
  println("computeRBD_BruteForce at: " + point);
  // Hardcoded field cooheficients for P1 and V1
  float lamda1x = V1[0]*0.01;
  float lamda1y = V1[1]*0.01;
  // Hardcoded field cooheficients for P2 and V2
  float lamda2x = V2[0]*0.01;
  float lamda2y = V2[1]*0.01;
  
  float[] distanceV1 = tools.vectorSubstraction(P, P1);
  float r1 = tools.vectorMagnitud(distanceV1);

  float[] distanceV2 = tools.vectorSubstraction(P, P2);
  float r2 = tools.vectorMagnitud(distanceV2);

  float interpolantX = (r1 * lamda1x) + (r2 * lamda2x);
  float interpolantY = (r1 * lamda1y) + (r2 * lamda2y);

  float[] InterpolatedVector = {interpolantX, interpolantY};

  renderAnyVectorAtAnyPoint(point, InterpolatedVector);
}

/* psudo code
 
 lamda1x = 0.1;
 lamda1y = 0.5;
 
 lamda2x = 0.5;
 lamda2y = 0.1;
 
 distanceV1 = vectorSubstraction(P, P1);
 r1 = vectorMagnitud(distanceV);
 
 distanceV2 = vectorSubstraction(P, P2);
 r2 = vectorMagnitud(distanceV);
 
 interpolantX = (r1 * lamda1x) + (r2 * lamda2x);
 interpolantY = (r1 * lamda1y) + (r2 * lamda2x);
 
 float[] InterpolatedVector = {interpolantX, interpolantY}
 
 renderAnyVectorAtAnyPoint(P, InterpolatedVector);
 
 
 */
float[] matrix = {
  1, 0, 0, 0,
  0, 1, 0, 0,
  0, 0, 1, 0,
  0, 0, 0, 1};

void draw() {
}

void mousePressed() {
  background(0, 0, 0);
  createCoordinatesSystem();
  
  renderSourceVectorAtPoint(P1, V1);
  renderSourceVectorAtPoint(P2, V2);
  
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
