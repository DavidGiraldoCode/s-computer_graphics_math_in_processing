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
float[] P1 = {100, 100}; //Source points
float[] P2 = {-100, -100}; //Source points
float[] P3 = {100, -100}; //Source points
float[] V1 = {100, 200}; //Vector at source points
float[] V2 = {0, 100}; //Vector at source points
float[] V3 = {-100, 200}; //Vector at source points

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
  minPoint[0]=-400;
  minPoint[1]=-400;

  maxPoint[0]=400;
  maxPoint[1]=400;

  pointsGrid = new UniformGrid(nx, ny, minPoint, maxPoint);

  renderSourceVectorAtPoint(P1, V1);
  renderSourceVectorAtPoint(P2, V2);
  renderSourceVectorAtPoint(P3, V3);
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
  float[] plotVector = tools.vertorNorm(vector);
  float scalar = 8;
  int val = (int)map(tools.vectorMagnitud(vector), 0, 500, 0, 255);
  stroke(val, val, 255);
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
  
            
  float lamdaX1 = -0.427;
  float lamdaX2 = -0.072;
  float lamdaX3 = 0.60;
            
  float lamdaY1 = 0.322;
  float lamdaY2 = 0.677;
  float lamdaY3 = 0.045;
  
  float[] distanceV1 = tools.vectorSubstraction(P, P1);
  float r1 = tools.vectorMagnitud(distanceV1);
  float RBF1 = r1;//pow(r1,2) * log10(r1);

  float[] distanceV2 = tools.vectorSubstraction(P, P2);
  float r2 = tools.vectorMagnitud(distanceV2);
  float RBF2 = r2;// pow(r2,2) * log10(r2);
  
  float[] distanceV3 = tools.vectorSubstraction(P, P3);
  float r3 = tools.vectorMagnitud(distanceV3);
  float RBF3 = r2;// pow(r2,2) * log10(r2);

  float interpolantX = (lamdaX1 * RBF1) + (lamdaX2 * RBF2) + (lamdaX3 * RBF3);
  float interpolantY = (lamdaY1 * RBF1) + (lamdaY2 * RBF2) + (lamdaY3 * RBF3);

  float[] InterpolatedVector = {interpolantX, interpolantY};

  renderAnyVectorAtAnyPoint(point, InterpolatedVector);
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

float[] setVectorAtPoint(float[] point){
  
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

void renderVectorFieldGrid(){
  println(pointsGrid.getSamplePosition(0));
  
  for(int i = 0; i < pointsGrid.getSize(); i++)
  {
    
    fill(255);
    noStroke();
    float x = pointsGrid.getSamplePosition(i)[0];
    float y = pointsGrid.getSamplePosition(i)[1];
    
    float[] point = {x , y};
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
