public class UniformGrid {
  //2D [x,y] [colunms, rows]
  private int nx, ny, nCols, nRows, dx, dy;
  //private int[] minPoint, maxPoint;
  private float[][] samplePoints;//holds 3D coordinates in space
  private float[] sampleValues;//holds an scalar value

  public UniformGrid(int nx, int ny, int[] minPoint, int[] maxPoint) {
    if (nx <= 1) {
      this.nx = 2;
    } else {
      this.nx = nx;
    }
    if (ny <= 1) {
      this.ny = 2;
    } else {
      this.ny = ny;
    }

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

    float offSet = 0;
    float sample = 0;
    float scalar = 20;
    float minium = 10;

    for (int y = 0; y < ny; y++) {
      for (int x = 0; x < nx; x++) {

        int linearIndex = (y*nx)+x;

        samplePoints[linearIndex][0] = (x*dx) + xMin;
        //if (ny > 1) {

        sample = ((cos((linearIndex * 0.01) - offSet) * scalar ));
        samplePoints[linearIndex][1] = (y*dy) + yMin;//((y*dy) + yMin)*-1;

        //samplePoints[linearIndex][1] = 600 + random(-50, 50);//(y*dy) + yMin;//((y*dy) + yMin)*-1;
        offSet = (linearIndex*( PI/4 ));
        //} else {
        //  samplePoints[linearIndex][1] = yMin;
        //}
        samplePoints[linearIndex][2] = ((y*dy) + yMin)*-1;
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
    if (linearIndex > samplePoints.length) {
      return samplePoints[samplePoints.length-1];
    } else if (linearIndex < 0) {
      return samplePoints[0];
    }
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
  public void setSamplePosition(int linearIndex, float[] newValue) {
    samplePoints[linearIndex] = newValue;
  }

  public void setYSamplePosition(int linearIndex, float newValue) {
    samplePoints[linearIndex][1] = newValue;
  }
}
