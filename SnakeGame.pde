boolean moveable = true, dead = false;
int numCols = 20, numRows = 20, ud = 0, lr = 0, headC = numCols/2, headR = numRows/2, snakeLength = 0, eyeSize, moveFrame = 0;
GridSquare[][] squares = new GridSquare[numCols][numRows];
ArrayList<Integer> oldC = new ArrayList<Integer>();
ArrayList<Integer> oldR = new ArrayList<Integer>();
ArrayList<Integer> snakeTail = new ArrayList<Integer>();
ArrayList<Integer> apples = new ArrayList<Integer>();

void setup() {
  int appleC = (int) (Math.random()*numCols), appleR = (int) (Math.random()*numRows);
  size(800, 800);
  frameRate(60);
  for(int c = 0; c < numCols; c++) {
    for(int r = 0; r < numRows; r++) {
      squares[c][r] = new GridSquare(c, r);
    }
  }
  while(appleC == headC && appleR == headR) {
    appleC = (int) (Math.random()*numCols);
    appleR = (int) (Math.random()*numRows);
  }
  apples.add(toI(appleC, appleR));
  eyeSize = 60/numCols;
}

void draw() {
  moveFrame++;
  snakeTail.clear();
  for(int i = oldC.size()-1; i >= oldC.size()-snakeLength; i--) {
    snakeTail.add(toI(oldC.get(i), oldR.get(i)));
  }
  for(int i = 0; i < numRows*numCols; i++) {
    squares[toRow(i)][toCol(i)].show();
  }
  if(moveFrame > 6) {
    move();
    moveFrame = 0;
  }
  fill(255);
  text(keyCode, 50, 50);
}

class GridSquare {
  int myCol, myRow;
  public GridSquare(int c, int r) {
    myCol = c;
    myRow = r;
  }
  
  public void show() {
    if((myCol == headC && myRow == headR) && dead) {fill(50);}
    else if(snakeTail.contains(toI(myCol, myRow)) && dead) {fill(100);}
    else if(myCol == headC && myRow == headR) {fill(0, 155, 0);}
    else if(snakeTail.contains(toI(myCol, myRow))) {fill(0, 255, 0);}
    else if(apples.contains(toI(myCol, myRow))) {fill(255, 0, 0);}
    else {fill(0, 100, 100);}
    rect(myCol*800/numCols, myRow*800/numRows, 800/numCols, 800/numRows);
    if(myCol == headC && myRow == headR && dead) {
      if(lr == 0) {
        x((myCol*800/numCols)+(400/numCols)-eyeSize*2, (myRow*800/numRows)+(400/numRows)+ud*eyeSize*2);
        x((myCol*800/numCols)+(400/numCols)+eyeSize*2, (myRow*800/numRows)+(400/numRows)+ud*eyeSize*2);
      } else {
        x((myCol*800/numCols)+(400/numCols)+lr*eyeSize*2, (myRow*800/numRows)+(400/numRows)-eyeSize*2);
        x((myCol*800/numCols)+(400/numCols)+lr*eyeSize*2, (myRow*800/numRows)+(400/numRows)+eyeSize*2);
      }
    } else if(myCol == headC && myRow == headR) {
      if(lr == 0) {
        fill(255);
        ellipse((myCol*800/numCols)+(400/numCols)-eyeSize*2, (myRow*800/numRows)+(400/numRows)+ud*eyeSize*2, eyeSize*2, eyeSize*2);
        ellipse((myCol*800/numCols)+(400/numCols)+eyeSize*2, (myRow*800/numRows)+(400/numRows)+ud*eyeSize*2, eyeSize*2, eyeSize*2);
        fill(0);
        ellipse((myCol*800/numCols)+(400/numCols)-eyeSize*2, (myRow*800/numRows)+(400/numRows)+ud*eyeSize*2, eyeSize, eyeSize);
        ellipse((myCol*800/numCols)+(400/numCols)+eyeSize*2, (myRow*800/numRows)+(400/numRows)+ud*eyeSize*2, eyeSize, eyeSize);
      } else {
        fill(255);
        ellipse((myCol*800/numCols)+(400/numCols)+lr*eyeSize*2, (myRow*800/numRows)+(400/numRows)-eyeSize*2, eyeSize*2, eyeSize*2);
        ellipse((myCol*800/numCols)+(400/numCols)+lr*eyeSize*2, (myRow*800/numRows)+(400/numRows)+eyeSize*2, eyeSize*2, eyeSize*2);
        fill(0);
        ellipse((myCol*800/numCols)+(400/numCols)+lr*eyeSize*2, (myRow*800/numRows)+(400/numRows)-eyeSize*2, eyeSize, eyeSize);
        ellipse((myCol*800/numCols)+(400/numCols)+lr*eyeSize*2, (myRow*800/numRows)+(400/numRows)+eyeSize*2, eyeSize, eyeSize);
      }
    }
  }
}

public void keyPressed() {
  if(keyCode == UP && !(ud == 1) && moveable && !dead) {
    lr = 0;
    ud = -1;
    moveable = false;
  } else if(keyCode == DOWN && !(ud == -1) && moveable && !dead) {
    lr = 0;
    ud = 1;
    moveable = false;
  } else if(keyCode == LEFT && !(lr == 1) && moveable && !dead) {
    ud = 0;
    lr = -1;
    moveable = false;
  } else if(keyCode == RIGHT && !(lr == -1) && moveable && !dead) {
    ud = 0;
    lr = 1;
    moveable = false;
  }
}

public boolean isValid(int c, int r) {
    if(c >= 0 && c < numCols && r >= 0 && r < numRows) {return true;} else {return false;}
}

public int toRow(int i) {return (i-(i%numRows))/numRows;}
public int toCol(int i) {return i%numRows;}
public int toI(int c, int r) {return r*numCols+c;}

public void move() {
  int appleC = (int) (Math.random()*numCols), appleR = (int) (Math.random()*numRows);
  if(isValid(headC+lr, headR+ud) && !dead) {
    oldC.add(headC);
    oldR.add(headR);
    headC += lr;
    headR += ud;
    for(int i = 0; i < apples.size(); i++) {
      if(headC == toCol(apples.get(i)) && headR == toRow(apples.get(i))) {
        snakeLength++;
        apples.remove(i);
        while((appleC == headC && appleR == headR) || snakeTail.contains(toI(appleC, appleR))) {
          appleC = (int) (Math.random()*numCols);
          appleR = (int) (Math.random()*numRows);
        }
        apples.add(toI(appleC, appleR));
      }
    }
    moveable = true;
    if(snakeTail.contains(toI(headC, headR)) && !(snakeTail.get(snakeLength-1) == toI(headC, headR))) {dead = true;}
  } else {
    dead = true;
  }
}

public void x(int x, int y) {
  stroke(255, 0, 0);
  line(x-eyeSize, y-eyeSize, x+eyeSize, y+eyeSize);
  line(x-eyeSize, y+eyeSize, x+eyeSize, y-eyeSize);
  stroke(0);
}
