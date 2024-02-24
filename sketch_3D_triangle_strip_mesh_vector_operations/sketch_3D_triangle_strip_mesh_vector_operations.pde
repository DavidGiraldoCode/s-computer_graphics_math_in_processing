float[] P00, P10, P01, P11;
int l =0;
//float[] vectorA, vectorB, vectorC, vectorD, crossBA, crossDC, ABNorm;
float[] translationMatrix = {
  1, 0, 0, 1,
  0, 1, 0, 1,
  0, 0, 1, 1,
  0, 0, 0, 1};

Tools tools = new Tools();
UniformGrid pointsGrid;
int nx, ny = 0;
int[] minPoint = {100, 10};//{100, 100};
int[] maxPoint = {1200, 800}; //{400,400};
int triangleCounter = 0;
void setup() {
  size(1280, 720, P3D);
  nx = 32;
  ny = 24;
  pointsGrid = new UniformGrid(nx, ny, minPoint, maxPoint);
  basicSetUp();
  triangleMesh();
}

void triangleMesh() {
  triangleCounter = 0;
  for (int i = 0; i < pointsGrid.getSize(); i++) {
    int linearIndex = i;
    if ((floor(linearIndex/nx)+1)*nx + ((linearIndex%nx)+1) < pointsGrid.getSize()) {
      if (((linearIndex%nx)+1) < nx) {
        int a = linearIndex; //p00
        int b = floor(linearIndex/nx)*nx + ((linearIndex%nx)+1);//p10 l+1;
        int c = (floor(linearIndex/nx)+1)*nx + (linearIndex%nx); //p01 l+nx;
        int d = (floor(linearIndex/nx)+1)*nx + ((linearIndex%nx)+1);// p11 l+nx+1;

        float[][] vertices = new float[4][4];
        vertices[0] = pointsGrid.getSamplePosition(a);
        vertices[1] = pointsGrid.getSamplePosition(b);
        vertices[2] = pointsGrid.getSamplePosition(c);
        vertices[3] = pointsGrid.getSamplePosition(d);

        int[][] trianglesTable = {{0, 1, 2}, {3, 2, 1}};
        triangleCounter +=2;
        float[] vectorA, vectorB, vectorC, vectorD, crossBA, crossDC, ABNorm, DCNorm;

        vectorA = tools.vectorSubstraction(vertices[1], vertices[0]);//(P10, P00)
        vectorB = tools.vectorSubstraction(vertices[2], vertices[0]);//(P01, P00)
        vectorC = tools.vectorSubstraction(vertices[2], vertices[3]);//(P01, P11)
        vectorD = tools.vectorSubstraction(vertices[1], vertices[3]);//(P10, P11)

        crossBA = tools.crossProduct(vectorB, vectorA);
        crossDC = tools.crossProduct(vectorD, vectorC);

        ABNorm = tools.vertorNorm(crossBA);
        DCNorm = tools.vertorNorm(crossDC);

        displayTriangle(trianglesTable[0], vertices);
        displayTriangle(trianglesTable[1], vertices);
        ellipse(pointsGrid.getSamplePosition(i)[0], pointsGrid.getSamplePosition(i)[1], 10, 10);
        stroke(0, 0, 255);
        displayNormals(ABNorm, vertices[0]);
        displayNormals(DCNorm, vertices[3]);
      }
    }
  }
  println("nx: "+nx+" ny:"+ny+" nx*ny:"+nx*ny+" *2: "+(nx*ny)*2);
  println("cells: "+(nx-1)*(ny-1)+" *2: "+(nx-1)*(ny-1)*2+" triangleCounter:"+ triangleCounter );

  for (int i = 0; i < pointsGrid.getSize(); i++) {
  }
}

//float[] pointTest = {0, 0, 0, 1};
void draw() {
}

void displayTriangle(int[] triangleIndexs, float[][] vertices) {
  stroke(0);
  fill(255);
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
  float scalarFactor = 100;

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
  background(0);
  //ambientLight(10, 10, 10, 0, 0, 0);
  //pointLight(255, 255, 255, width/2, -height, 0);
  pushMatrix();
  translate(width/2, height/2, -100);
  noStroke();
  fill(255);
  //sphere(200);
  stroke(80);
  noFill();
  box(1280, 720, 500);
  popMatrix();
}
