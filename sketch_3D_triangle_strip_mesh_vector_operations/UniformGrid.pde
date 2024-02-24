public class UniformGrid { 
  //2D [x,y] [colunms, rows]
  private int nx, ny, nCols, nRows, dx, dy;
  //private int[] minPoint, maxPoint;
  private float[][] samplePoints;
  private float[] sampleValues;

  public UniformGrid(int nx, int ny, int[] minPoint, int[] maxPoint) {
    this.nx = nx;
    this.ny = ny;
    //this.minPoint = minPoint;
    //this.maxPoint = maxPoint;
    nCols = nx - 1; //number of rows cells
    nRows = ny - 1; //number of columns cells
    samplePoints = new float[nx*ny][4]; //Store 3D vector in affine coordinate [x,y,z,w]
    sampleValues = new float[nx*ny];

    int xMin =  minPoint[0];
    int yMin =  minPoint[1];
    int xMax =  maxPoint[0];
    int yMax =  maxPoint[1];

    dx = (xMax - xMin) / nCols; // Call's width
    dy = 0;
    if (ny > 1) {
      dy = (yMax - yMin) / nRows; // Cell's height
    }

    for (int y = 0; y < ny; y++) {
      for (int x = 0; x < nx; x++) {

        int linearIndex = (y*nx)+x;

        samplePoints[linearIndex][0] = (x*dx) + xMin;
        //if (ny > 1) {
        samplePoints[linearIndex][1] = (y*dy) + yMin;
        //} else {
        //  samplePoints[linearIndex][1] = yMin;
        //}
        samplePoints[linearIndex][2] = 0;
        samplePoints[linearIndex][3] = 1;

        sampleValues[linearIndex] = 0;
        /*println("uniformGrid["+((y*nx)+x)+"][0] = "+((x*dx) + xMin));
        println("uniformGrid["+((y*nx)+x)+"][1] = "+((y*dy) + yMin));
        println("-----------------");*/
      }
    }
  }


  public float[] getSampleIndex(float[] point) {
    int linearIndex = int((point[1]*nx)+point[0]);
    return samplePoints[linearIndex];
  }

  public float[] getSamplePosition(int linearIndex) {
    //int[] coordinates = new int[2];
    //coordinates[0] = (int)(linearIndex % this.nx)*dx;
    //coordinates[1] = (int)(Math.floor(linearIndex / this.nx) % ny)*dy;
    return samplePoints[linearIndex];
  }

  public float getSamplePointValue(int[] point) {
    int linearIndex = (point[1]*nx)+point[0];
    return sampleValues[linearIndex];
  }
  
  public float getSampleValue(int linearIndex) {
    //int linearIndex = (point[1]*nx)+point[0];
    return sampleValues[linearIndex];
  }
  
  public int getSize() {
    return sampleValues.length;
  }
  public void setSampleValue(int linearIndex, float newValue) {
    sampleValues[linearIndex] = newValue;
  }
}
