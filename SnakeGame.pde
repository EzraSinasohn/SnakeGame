
int numCols = 10, numRows = 10, ud = 0, lr = 0;
GridSquare[][] squares = new GridSquare[numCols][numRows];
ArrayList<Integer> oldX = new ArrayList<Integer>();
ArrayList<Integer> oldY = new ArrayList<Integer>();

void setup() {
  size(800, 800);
  frameRate(60);
  for(int c = 0; c < numCols; c++) {
    for(int r = 0; r < numRows; r++) {
      squares[c][r] = new GridSquare(c, r);
    }
  }
  squares[numCols/2][numRows/2].snakeHead = true;
}

void draw() {
  for(int c = 0; c < numCols; c++) {
    for(int r = 0; r < numRows; r++) {
      /*if(millis()%100 == 0) {*/move();//}
      squares[c][r].show();
    }
  }
}

class GridSquare {
  int myCol, myRow;
  boolean snakeHead, snakeTail;
  public GridSquare(int c, int r) {
    myCol = c;
    myRow = r;
  }
  
  public void show() {
    if(snakeHead) {fill(0, 150, 0);}
    else if(snakeTail) {fill(0, 255, 0);}
    else {fill(0, 100, 100);}
    rect(myCol*800/numCols, myRow*800/numRows, 800/numCols, 800/numRows);
  }
  
  public boolean isValid(int c, int r) {
    if(c < numCols && r < numRows) {return true;} else {return false;}
  }
}

public void keyPressed() {
  if(keyCode == UP && !(ud == 1)) {
    lr = 0;
    ud = -1;
  } else if(keyCode == DOWN && !(ud == -1)) {
    lr = 0;
    ud = 1;
  } else if(keyCode == LEFT && !(lr == 1)) {
    ud = 0;
    lr = -1;
  } else if(keyCode == RIGHT && !(lr == -1)) {
    ud = 0;
    lr = 1;
  }
}

public void move() {
    for(int c = 0; c < numCols; c++) {
      for(int r = 0; r < numRows; r++) {
        if(isValid(c+lr, r+ud) && snakeHead) {
          squares[c][r].snakeHead = false;
          squares[c+lr][r+ud].snakeHead = true;
          squares[c][r]snakeTail = true;
        }
      }
    }
  }


