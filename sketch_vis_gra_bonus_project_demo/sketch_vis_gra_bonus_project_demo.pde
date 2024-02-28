float[] P00, P10, P01, P11;
int l =0;

Tools tools = new Tools();
UniformGrid pointsGrid;
//float[] trianglesTable;
int nx, ny = 0;
int[] minPoint;
int[] maxPoint;
int triangleCounter = 0;

//Move Sphere
int location;
float[] normalAtLocation = new float[4];
PShape ship;

int scene = 4;
boolean doSampling = false;
boolean showStrokes = true;
boolean showNormals = true;

float change = 0;
float offSet = 0;
float sample = 0;
float scalar = 0.03;
float minium = 600;

void setup() {
  minPoint = new int[2];
  maxPoint = new int[2];
  //"19292_Cat_boat_v1.obj"
  //"19291_Cabin_cruise_v2_NEW.obj"
  //"15211_Wakeboard_v1_NEW.obj"
  ship = loadShape("Boat Texture 1.obj");
  size(1280, 720, P3D);
  switch(scene) {
  case 0: //One triangle, flat, with strokes
    nx = 2;//32;
    ny = 2;//24;
    minPoint[0]=100;
    minPoint[1]=100;

    maxPoint[0]=800;
    maxPoint[1]=600;

    break;
  case 1: //Triangular mesh on a rectilinear grid - flat
    showStrokes = true;
    nx = 4;//32;
    ny = 4;//24;
    minPoint[0]=100;
    minPoint[1]=100;

    maxPoint[0]=1200;
    maxPoint[1]=800;
    break;
  case 2: //Triangular mesh on a rectilinear grid - with sin() samples
    showStrokes = true;
    doSampling = true;

    scalar = 0.05;
    nx = 4;//32;
    ny = 4;//24;
    minPoint[0]=100;
    minPoint[1]=100;

    maxPoint[0]=1200;
    maxPoint[1]=800;
    break;
  case 3: //Triangular mesh on a rectilinear grid - with sin() samples
    showStrokes = true;
    showNormals = true;
    doSampling = true;
    nx = 16;
    ny = 16;
    minPoint[0]=-10;
    minPoint[1]=-500;
    maxPoint[0]=1200;
    maxPoint[1]=1200;
    break;
  case 4: //Triangular mesh on a rectilinear grid - with sin() samples
    showStrokes = false;
    showNormals = false;
    doSampling = true;
    nx = 32;//32;
    ny = 32;//24;
    minPoint[0]=-10;
    minPoint[1]=-500;

    maxPoint[0]=1200;
    maxPoint[1]=1200;
    break;
  }

  location = ((ny/2)*nx)+(nx/2);
  pointsGrid = new UniformGrid(nx, ny, minPoint, maxPoint);
  //trianglesTable = new float[(nx-1)*(ny-1)];
  basicSetUp();
  if (doSampling) {
    samplingMesh();
  }
  triangleMesh();
}

float[] matrix = {
  1, 0, 0, 0,
  0, 1, 0, 0,
  0, 0, 1, 0,
  0, 0, 0, 1};

void samplingMesh() {

  change += PI * 0.01;

  if (change >= (PI * 2)) {
    change = 0;
    //println("Cycle ends");
  }

  for (int linearIndex = 0; linearIndex < pointsGrid.getSize(); linearIndex++) {
    matrix[0] = cos(change + offSet);
    matrix[1] = 0;
    matrix[2] = sin(change + offSet);
    matrix[3] = 0;

    matrix[4] = 0;
    matrix[5] = 1;
    matrix[6] = 0;
    matrix[7] = 0;

    matrix[8] = -sin(change + offSet);
    matrix[9] = 0;
    matrix[10] = cos(change + offSet);
    matrix[7] = 0;

    float[] point = {1, 1, 1, 1};
    //point[1] = pointsGrid.getSamplePosition(linearIndex)[1];
    point = pointsGrid.getSamplePosition(linearIndex);

    float[] pointPrime = tools.applyMatrix4(point, matrix);
    //sample = ((sin((change) - offSet) * scalar ));
    sample = (pointPrime[0]-offSet)*scalar;//[0]*scalar;
    pointsGrid.setYSamplePosition(linearIndex, (minium + sample));

    offSet = linearIndex * (PI / 8) ;//PI + (linearIndex*0.05); //(PI / (linearIndex);// /( PI * -0.5));
  }
}

void triangleMesh() {

  //triangleCounter = 0;
  for (int i = 0; i < pointsGrid.getSize(); i++) {
    int linearIndex = i;
    if ((floor(linearIndex/nx)+1)*nx + ((linearIndex%nx)+1) < pointsGrid.getSize()) {
      if (((linearIndex%nx)+1) < nx) {
        int a = linearIndex; //p00
        int b = floor(linearIndex/nx)*nx + ((linearIndex%nx)+1);//p10 l+1;
        int c = (floor(linearIndex/nx)+1)*nx + (linearIndex%nx); //p01 l+nx;
        int d = (floor(linearIndex/nx)+1)*nx + ((linearIndex%nx)+1);// p11 l+nx+1;
        float[] baricenterOne = new float[4];
        float[] baricenterTwo = new float[4];

        float[][] vertices = new float[4][4];
        vertices[0] = pointsGrid.getSamplePosition(a);
        vertices[1] = pointsGrid.getSamplePosition(b);
        vertices[2] = pointsGrid.getSamplePosition(c);
        vertices[3] = pointsGrid.getSamplePosition(d);

        int[][] trianglesTable = {{0, 1, 2}, {3, 2, 1}};
        //triangleCounter +=2;
        float[] vectorA, vectorB, vectorC, vectorD, crossBA, crossDC, ABNorm, DCNorm;

        vectorA = tools.vectorSubstraction(vertices[1], vertices[0]);//(P10, P00)
        vectorB = tools.vectorSubstraction(vertices[2], vertices[0]);//(P01, P00)
        vectorC = tools.vectorSubstraction(vertices[2], vertices[3]);//(P01, P11)
        vectorD = tools.vectorSubstraction(vertices[1], vertices[3]);//(P10, P11)

        crossBA = tools.crossProduct(vectorB, vectorA);
        crossDC = tools.crossProduct(vectorD, vectorC);

        ABNorm = tools.vertorNorm(crossBA);
        if (linearIndex == location) {
          normalAtLocation = ABNorm;
        }
        DCNorm = tools.vertorNorm(crossDC);

        displayTriangle(trianglesTable[0], vertices);
        displayTriangle(trianglesTable[1], vertices);
        stroke(0, 0, 255);

        baricenterOne = tools.findTriangleBarycenter(vertices[0], vertices[1], vertices[2]);
        baricenterTwo = tools.findTriangleBarycenter(vertices[3], vertices[2], vertices[1]);
        if (showNormals) {
          displayNormals(ABNorm, baricenterOne);
          displayNormals(DCNorm, baricenterTwo);
        }
      }
    }
  }
  //println("nx: "+nx+" ny:"+ny+" nx*ny:"+nx*ny+" *2: "+(nx*ny)*2);
  //println("cells: "+(nx-1)*(ny-1)+" *2: "+(nx-1)*(ny-1)*2+" triangleCounter:"+ triangleCounter );

  /*for (int i = 0; i < pointsGrid.getSize(); i++) {
   displayTriangle(trianglesTable[0], vertices);
   displayTriangle(trianglesTable[1], vertices);
   ellipse(pointsGrid.getSamplePosition(i)[0], pointsGrid.getSamplePosition(i)[1], 10, 10);
   stroke(0, 0, 255);
   displayNormals(ABNorm, vertices[0]);
   displayNormals(DCNorm, vertices[3]);
   }*/
  if (scene > 2) {
    float x = pointsGrid.getSamplePosition(location)[0];
    float y = pointsGrid.getSamplePosition(location)[1];
    float z = pointsGrid.getSamplePosition(location)[2];
    float normalLenght = sqrt(pow(normalAtLocation[0],2)+pow(normalAtLocation[1],2)+pow(normalAtLocation[2],2));
    //float theta = (normalAtLocation[0]+normalAtLocation[1]+normalAtLocation[2]);
    float theta = acos(-1*normalAtLocation[1]);
    println(theta);
    noStroke();
    fill(255, 255, 20);
    pushMatrix();
    translate(100, 100, -100);
    sphereDetail(8);
    sphere(40);
    scale(0.4);
    popMatrix();
    //+theta*0.5
    fill(255);

    pushMatrix();
    //translate(x+50, y+20, z);
    translate(x+50, y+10, z); // ---------------------------- 
    //rotateZ((PI/6)+(theta*0.5));
    rotateZ(theta*0.5); // ---------------------
    rotateY(PI*(mouseX * 0.001));
    rotateX(PI);
    //sphereDetail(4);
    //sphere(25);
    scale(0.5);
    shape(ship, 0, 0);
    popMatrix();
  }
}

//float[] pointTest = {0, 0, 0, 1};
void draw() {
  if (scene > 2) {
    basicSetUp();
    if (doSampling) {
      samplingMesh();
    }
    triangleMesh();
  }
  //translate(width/2, height/2 );
  //scale(0.4);
  //shape(ship, 0, 0);
}

void keyPressed() {
  //int linearIndex = (y*nx)+x;

  int x = location%nx;
  int z = floor(location/nx);

  switch(keyCode) {
  case UP:
    z++;
    break;
  case DOWN:
    z--;
    break;
  case RIGHT:
    x++;
    break;
  case LEFT:
    x--;
    break;
  }
  location = (z*nx)+x;
  /*float[] spherePos = pointsGrid.getSamplePosition(location);
   noStroke();
   fill(255);
   pushMatrix();
   translate(spherePos[0], spherePos[1], spherePos[2]);
   sphereDetail(4);
   sphere(20);
   popMatrix();*/
}



void displayTriangle(int[] triangleIndexs, float[][] vertices) {
  //stroke(0);
  if (showStrokes) {
    stroke(0);
  } else {
    noStroke();
  }
  fill(0, 100, (vertices[0][1]*0.5));
  beginShape(TRIANGLES);
  vertex(vertices[triangleIndexs[0]][0], vertices[triangleIndexs[0]][1], vertices[triangleIndexs[0]][2]);
  vertex(vertices[triangleIndexs[1]][0], vertices[triangleIndexs[1]][1], vertices[triangleIndexs[1]][2]);
  vertex(vertices[triangleIndexs[2]][0], vertices[triangleIndexs[2]][1], vertices[triangleIndexs[2]][2]);
  endShape();
}

void lines(float[] origin) {
  stroke(0, 255, 0);
  beginShape(LINES);
  vertex(origin[0], origin[1], origin[2]);
  vertex(origin[0], origin[1]-100, origin[2]);
  endShape();
}

void displayNormals(float[] normalVector, float[] origin) {
  float xo, yo, zo, xn, yn, zn;
  float scalarFactor = 20;

  xo = origin[0];
  yo = origin[1];
  zo = origin[2];

  xn = normalVector[0]*scalarFactor;
  yn = normalVector[1]*scalarFactor;
  zn = normalVector[2]*scalarFactor;
  beginShape(LINES);
  vertex(xo, yo, zo);
  vertex(xo+xn, yo+yn, zo+zn);
  endShape();
}

void basicSetUp() {
  background(255);
  if (scene > 3) {
    ambientLight(200, 200, 200, 0, 0, 0);
    pointLight(255, 255, 255, width/2, -height, 0);
  }
  pushMatrix();
  translate(width/2, height/2, -200);
  noStroke();
  fill(255);
  //sphere(200);
  stroke(80);
  noStroke();
  fill(0, 150, 255);
  //sphereDetail(16);
  //box(1280, 720, 500);
  sphere(900);
  popMatrix();
}
