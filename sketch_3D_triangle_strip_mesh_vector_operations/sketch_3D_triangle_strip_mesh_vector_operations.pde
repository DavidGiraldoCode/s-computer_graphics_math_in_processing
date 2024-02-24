float[] P00, P10, P01, P11;
int l =0;
//float[] vectorA, vectorB, vectorC, vectorD, crossBA, crossDC, ABNorm;
float[] translationMatrix = {
  1, 0, 0, 1,
  0, 1, 0, 1,
  0, 0, 1, 1,
  1, 1, 1, 1};

Tools tools = new Tools();
UniformGrid pointsGrid;
int nx, ny = 0;
int[] minPoint = {100, 100};
int[] maxPoint = {1200, 600};
int triangleCounter = 0;
void setup() {
  size(1280, 720, P3D);
  nx = 12;
  ny = 6;
  pointsGrid = new UniformGrid(nx, ny, minPoint, maxPoint);
}

void triangleMesh() {
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
        float[] vectorA, vectorB, vectorC, vectorD, crossBA, crossDC, ABNorm;

        vectorA = tools.vectorSubstraction(vertices[1], vertices[0]); //(P10, P00)
        vectorB = tools.vectorSubstraction(vertices[2], vertices[0]);//(P01, P00)
        vectorC = tools.vectorSubstraction(vertices[2], vertices[3]);//(P01, P11)
        vectorD = tools.vectorSubstraction(vertices[1], vertices[3]);//(P10, P11)

        crossBA = tools.crossProduct(vectorB, vectorA);
        crossDC = tools.crossProduct(vectorD, vectorC);

        tools.vertorNorm(crossBA, P00);
        tools.vertorNorm(crossDC, P11);

        //stroke(0);
        displayTriangle(trianglesTable[0], vertices);
        displayTriangle(trianglesTable[1], vertices);
        ellipse(pointsGrid.getSamplePosition(i)[0], pointsGrid.getSamplePosition(i)[1], 10, 10);
      }
    }
  }
  println("nx: "+nx+" ny:"+ny+" nx*ny:"+nx*ny+" *2: "+(nx*ny)*2);
  println("cells: "+(nx-1)*(ny-1)+" *2: "+(nx-1)*(ny-1)*2+" triangleCounter:"+ triangleCounter );
}

//float[] pointTest = {0, 0, 0, 1};
void draw() {
  basicSetUp();
  triangleMesh();
  /*
   //P11[0] = mouseX;
   //P11[1] = mouseY;
   
   vectorA = tools.vectorSubstraction(P10, P00);
   vectorB = tools.vectorSubstraction(P01, P00);
   vectorC = tools.vectorSubstraction(P01, P11);
   vectorD = tools.vectorSubstraction(P10, P11);
   
   crossBA = tools.crossProduct(vectorB, vectorA);
   crossDC = tools.crossProduct(vectorD, vectorC);
   tools.vertorNorm(crossBA, P00);
   tools.vertorNorm(crossDC, P11);
   
   //displayTriangle(P00, P10, P01);
   //displayTriangle(P11, P01, P10);
   
   translationMatrix[3] = mouseX;
   translationMatrix[7] = mouseY;
   
   float[] newPoint = tools.applyMatrix4(pointTest, translationMatrix);
   
   fill(255, 100, 100);
   ellipse(newPoint[0], newPoint[1], 10, 10);
   
   */
}

void displayTriangle(int[] triangleIndexs, float[][] vertices) {
  //new (float[][] triangleIndex, float[][] vertices);
  //OLD (float[] A, float[] B, float[] C)
  stroke(0);
  //noStroke();
  fill(255);
  beginShape(TRIANGLES);
  vertex(vertices[triangleIndexs[0]][0], vertices[triangleIndexs[0]][1], vertices[triangleIndexs[0]][2]);
  vertex(vertices[triangleIndexs[1]][0], vertices[triangleIndexs[1]][1], vertices[triangleIndexs[1]][2]);
  vertex(vertices[triangleIndexs[2]][0], vertices[triangleIndexs[2]][1], vertices[triangleIndexs[2]][2]);
  //vertex(B[0], B[1], B[2]);
  //vertex(C[0], C[1], C[2]);
  endShape();
}

void linearIndexOffsetting() {
  //int nx = 2;
  int p00 = l;
  int p10 = floor(l/nx)*nx + ((l%nx)+1);//l+1;
  int p01 = (floor(l/nx)+1)*nx + (l%nx); //l+nx;
  int p11 = (floor(l/nx)+1)*nx + ((l%nx)+1);//l+nx+1;
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
