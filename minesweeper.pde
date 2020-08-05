import java.util.*; //<>//
int[][] values;
ArrayList<ArrayList<Integer>> flagged = new ArrayList<ArrayList<Integer>>();
ArrayList<ArrayList<Integer>> uncovered = new ArrayList<ArrayList<Integer>>();
ArrayList<ArrayList<Integer>> mineLocations = new ArrayList<ArrayList<Integer>>();
ArrayList<Integer> dims = new ArrayList<Integer>(3);
boolean release = false;
PImage mine; 
PImage tile; 
PImage flag; 
PImage unc; 
PImage[] nums;
int[][] colors = {{0, 0, 255}, {0, 128, 0}, {255, 0, 0}, {0, 0, 128}, {128, 0, 0}, {0, 128, 128}, {0, 0, 0}, {128, 128, 128}};
boolean gameOver;
boolean menu;
boolean win = false;
boolean invalid = false;
int count = 0;
int selection = -1;
int framesOfInvalid = 0;
void setup() {
  surface.setSize(500, 500);
  menu = true;
  surface.setResizable(true);
  mine = loadImage("mine.jpg");
  tile = loadImage("tile.jpg");
  flag = loadImage("flag.jpg");
  unc = loadImage("tile_uncovered.jpg");
  nums = new PImage[8];
  for (int i = 0; i < nums.length; i++) {
    nums[i] = loadImage((i + 1) + ".jpg");
  }
}
void draw() {
  count = (count + 1) % 60;
  if (menu) {
    textFont(createFont("mine-sweeper.ttf", 9));
    surface.setSize(500, 500);
    background(192);
    textSize(20);
    fill(255, 0, 0);
    text("Minesweeper", 125, 50);
    fill(0);
    textSize(7);
    text("by Luke Knight", 375, 50);
    textSize(12);
    text("Rows", 75, 125);
    text("Mines", 220, 125);
    text("Columns", 355, 125);
    strokeWeight(2);
    for (int i = 0; i < 3; i++) {
      dims.add(0);
    }
    fill(0, 255, 0);
    rect(100, 300, 300, 100);
    fill(255);
    triangle(125, 320, 185, 350, 125, 380);
    textSize(35);
    fill(0);
    text("Start", 205, 365);
    fill(192);
    if (selection == 0 && count < 30) { 
      stroke(255, 0, 0);
    }
    rect(50, 140, 100, 50);
    stroke(0);
    if (selection == 1 && count < 30) { 
      stroke(255, 0, 0);
    }
    rect(185, 140, 130, 50);
    stroke(0);
    if (selection == 2 && count < 30) { 
      stroke(255, 0, 0);
    }
    rect(350, 140, 100, 50);
    stroke(0);
    if(invalid && framesOfInvalid <= 255) {
      fill(255, 0, 0, 255 - framesOfInvalid);
      textSize(15);
      text("Invalid Parameters", 50, 450);
      framesOfInvalid++;
    }
    if (selection >= 0) {
      if (release) {
        try {
          Integer.parseInt(Character.toString(key));
          if (Integer.toString(dims.get(selection)).length() < 2 || (selection == 1 && Integer.toString(dims.get(selection)).length() < 3)) {
            dims.set(selection, (int)(dims.get(selection) * 10 + Integer.parseInt(Character.toString(key))));
          }
        }
        catch(NumberFormatException e) {
          if (key == BACKSPACE) {
            dims.set(selection, dims.get(selection) / 10);
          } else if (key == ENTER || key == RETURN) {
            selection = -1;
          }
        }
      }
    }
    fill(0);
    textSize(35);
    text(dims.get(0), 60, 182);
    text(dims.get(1), 195, 182);
    text(dims.get(2), 360, 182);
    release = false;
  } else {
    surface.setSize(dims.get(2) * 25 + 100, dims.get(0) * 25 + 100);
    background(192);
    for (int i = 50; i < dims.get(2) * 25 + 50; i += 25) {
      for (int j = 50; j < dims.get(0) * 25 + 50; j += 25) {
        ArrayList<Integer> check = new ArrayList<Integer>();
        check.add((i - 50) / 25); 
        check.add((j - 50) / 25);
        if (gameOver && !win) {
          fill(255, 100, 100);
          textSize(14);
          text("Game over, click to restart", 75, 25);
          if(flagged.contains(check) || mineLocations.contains(check)) {
            for (ArrayList<Integer> mi : mineLocations) {
              if (!flagged.contains(mi)) {
                image(mine, i, j);
              }
              for (ArrayList<Integer> fl : flagged) {
                if (!mineLocations.contains(fl)) {
                  image(mine, i, j);
                  stroke(255, 0, 0);
                  line(fl.get(0) * 25 + 50, fl.get(1) * 25 + 50, fl.get(0) * 25 + 75, fl.get(1) * 25 + 75);
                  line(fl.get(0) * 25 + 75, fl.get(1) * 25 + 50, fl.get(0) * 25 + 50, fl.get(1) * 25 + 75);
                }
              }
            }
          }
          else {
            if (uncovered.contains(check) && values[(i - 50) / 25][(j - 50) / 25] == 0) {
              image(unc, i, j);
            } else if (uncovered.contains(check)) {
              //print(values[(j - 50) / 25][(i - 50) / 25] + "\n");
              image(nums[values[(i - 50) / 25][(j - 50) / 25] - 1], i, j);
            } else if (!uncovered.contains(check) && !flagged.contains(check)) {
              image(tile, i, j);
            }
            check = new ArrayList<Integer>();
          }
        }
        else if(gameOver && win) {
          fill(255, 100, 100);
          textSize(15);
          text("Congratulations, you won!", 75, 25);
          if (flagged.contains(check)) {
            image(flag, i, j);
          } else if (uncovered.contains(check) && values[(i - 50) / 25][(j - 50) / 25] == 0) {
            image(unc, i, j);
          } else if (uncovered.contains(check)) {
            //print(values[(j - 50) / 25][(i - 50) / 25] + "\n");
            image(nums[values[(i - 50) / 25][(j - 50) / 25] - 1], i, j);
          } else if (!uncovered.contains(check) && !flagged.contains(check)) {
            image(tile, i, j);
          }
          check = new ArrayList<Integer>();
        }
        else {
          if (flagged.contains(check)) {
            image(flag, i, j);
          } else if (uncovered.contains(check) && values[(i - 50) / 25][(j - 50) / 25] == 0) {
            image(unc, i, j);
          } else if (uncovered.contains(check)) {
            //print(values[(j - 50) / 25][(i - 50) / 25] + "\n");
            image(nums[values[(i - 50) / 25][(j - 50) / 25] - 1], i, j);
          } else if (!uncovered.contains(check) && !flagged.contains(check)) {
            image(tile, i, j);
          }
          check = new ArrayList<Integer>();
          fill(255, 100, 100);
          textSize(20);
          text("Remaining Flags: " + (dims.get(1) - flagged.size()), 50, 35);
        }
      }
    }
    /*for (int j = 0; j < values[0].length; j++) {
      for (int k = 0; k < values.length; k++) {
        fill(0);
        textSize(11);
        text(values[k][j], 68 + 25 * k,62 + 25 * j);
      }
    }*/
  }
}
void gameSetup() {
  values = new int[dims.get(2)][dims.get(0)];
  mineLocations = new ArrayList<ArrayList<Integer>>();
  values = genMines(dims.get(2), dims.get(0), dims.get(1));
  uncovered = new ArrayList<ArrayList<Integer>>();
  flagged = new ArrayList<ArrayList<Integer>>();
  win = false;
}
void keyReleased() {
  release = true;
}
int[][] genMines(int len, int wid, int mines) {
  int[] mineLoc = new int[mines];
  for (int i = 0; i < mines; i++) {
    int rand = (int)(Math.random() * len * wid);
    while (contains(mineLoc, rand)) {
      rand = (int)(Math.random() * len * wid);
    }
    mineLoc[i] = rand;
  }
  int[][] locations = new int[len][wid];
  for (int i : mineLoc) {
    locations[i % len][i / len] = -1;
  }
  int[][] finalArr = new int[len][wid];
  for (int i = 0; i < locations.length; i++) {
    for (int j = 0; j < locations[i].length; j++) {
      finalArr[i][j] = locations[i][j];
    }
  }
  for (int i = 0; i < locations.length; i++) {
    for (int j = 0; j < locations[i].length; j++) {
      if (locations[i][j] == -1) {
        continue;
      } else {
        int counting = 0;
        for (int k = -1; k < 2; k++) {
          for (int l = -1; l < 2; l++) {
            if (!(k == 0 && k == l)) {
              try {
                if (locations[i + k][j + l] == -1) {
                  counting++;
                }
              }
              catch(IndexOutOfBoundsException e) {
                continue;
              }
            }
          }
        }
        finalArr[i][j] = counting;
      }
    }
  }
  for (int i = 0; i < finalArr.length; i++) {
    for (int j = 0; j < finalArr[i].length; j++) {
      ArrayList<Integer> index = new ArrayList<Integer>();
      if (finalArr[i][j] == -1) {
        index.add(i); 
        index.add(j);
        mineLocations.add(index);
      }
    }
  }
  return finalArr;
}
boolean contains(int[] arr, int find) {
  for (int i : arr) {
    if (i == find) {
      return true;
    }
  }
  return false;
}
ArrayList<ArrayList<Integer>> borderChunk = new ArrayList<ArrayList<Integer>>();
void mousePressed() {
  if (menu == false) {
    if (mouseButton == LEFT) {
      ArrayList<Integer> check = new ArrayList<Integer>();
      check.add((mouseX - 50) / 25); 
      check.add((mouseY - 50) / 25);
      if (gameOver) {
        menu = true;
        gameOver = false;
      } else if (mouseX >= dims.get(2) * 25 + 50 || mouseX < 50 || mouseY < 50 || mouseY >= dims.get(0) * 25 + 50) {
      } else if (flagged.contains(check)) {
      } else if (values[(mouseX - 50) / 25][(mouseY - 50) / 25] < 0) {
        gameOver = true;
      } else if (values[check.get(0)][check.get(1)] == 0) {
        fill(0, 255, 0);
        findZeros(check.get(0), check.get(1));
        ArrayList<ArrayList<Integer>> chunk = zeroChunk;
        zeroChunk = new ArrayList<ArrayList<Integer>>();
        borderChunk = new ArrayList<ArrayList<Integer>>();
        for (int i = 0; i < values.length; i++) {
          for (int j = 0; j < values[i].length; j++) {
            ArrayList<Integer> index = new ArrayList<Integer>();
            index.add(i); 
            index.add(j);
            if (borderingZero(index, chunk) && values[i][j] > 0) {
              borderChunk.add(index);
            }
          }
        }
        for (int i = 0; i < chunk.size(); i++) {
          uncovered.add(chunk.get(i));
        }
        for (int i = 0; i < borderChunk.size(); i++) {
          uncovered.add(borderChunk.get(i));
        }
        print("0");
      } else {
        ArrayList<Integer> addList = new ArrayList<Integer>();
        addList.add((mouseX - 50) / 25); 
        addList.add((mouseY - 50) / 25);
        uncovered.add(addList);
      }
    } else if (mouseButton == RIGHT) {
      ArrayList<Integer> check = new ArrayList<Integer>();
      check.add((mouseX - 50) / 25); 
      check.add((mouseY - 50) / 25);
      if (gameOver) {
        menu = true;
        gameOver = false;
      } else if (mouseY < 50 || mouseY >= dims.get(0) * 25 + 50 || mouseX < 50 || mouseX >= dims.get(2) * 25 + 50) {
      } else if (flagged.contains(check)) {
        int index = flagged.indexOf(check);
        flagged.remove(index);
      } else if (!uncovered.contains(check)) {
        if (flagged.size() < dims.get(1) - 1) {
          ArrayList<Integer> flag = new ArrayList<Integer>();
          flag.add((mouseX - 50) / 25); 
          flag.add((mouseY - 50) / 25);
          flagged.add(flag);
        } else if (flagged.size() == dims.get(1) - 1) {
          ArrayList<Integer> flag = new ArrayList<Integer>();
          flag.add((mouseX - 50) / 25); 
          flag.add((mouseY - 50) / 25);
          flagged.add(flag);
          boolean changeWin = true;
          for (ArrayList<Integer> i : flagged) {
            if (!mineLocations.contains(i)) {
              changeWin = false;
            }
            if(changeWin) {
              win = true;
            }
          }
          if (win) {
            gameOver = true;
          }
        }
      }
    }
  } else {
    if (mouseButton == LEFT) {
      if (mouseX >= 100 && mouseX <= 400 && mouseY >= 300 && mouseY <= 400) {
        invalid = false;
        if(dims.get(0) != 0 && dims.get(1) <= dims.get(0) * dims.get(2) && dims.get(2) != 0) {
          menu = false;
          gameSetup();
          selection = -1;
          framesOfInvalid = 0;
        }
        else {
          framesOfInvalid = 0;
          invalid = true;
        }
      } else if (mouseX >= 50 && mouseX <= 150 && mouseY >= 140 && mouseY <= 190) {
        selection = 0;
      } else if (mouseX >= 200 && mouseX <= 300 && mouseY >= 140 && mouseY <= 190) {
        selection = 1;
      } else if (mouseX >= 350 && mouseX <= 450 && mouseY >= 140 && mouseY <= 190) {
        selection = 2;
      } else {
        selection = -1;
      }
    }
  }
}
ArrayList<ArrayList<Integer>> zeroChunk = new ArrayList<ArrayList<Integer>>();
void findZeros(int x, int y) {
  ArrayList<Integer> index = new ArrayList<Integer>();
  index.add(x); 
  index.add(y);
  if (!zeroChunk.contains(index)) {
    zeroChunk.add(index);
    try {
      if (values[x - 1][y] == 0) {
        findZeros(x - 1, y);
      }
    }
    catch(IndexOutOfBoundsException e){
    }
    try {
      if (values[x + 1][y] == 0) {
        findZeros(x + 1, y);
      }
    }
    catch(IndexOutOfBoundsException e){
    }
    try {
      if (values[x][y + 1] == 0) {
        findZeros(x, y + 1);
      }
    }
    catch(IndexOutOfBoundsException e){
    }
    try {
      if (values[x][y - 1] == 0) {
        findZeros(x, y - 1);
      }
    }
    catch(IndexOutOfBoundsException e){
    }
  }
}
void resetRemaining() {
  fill(192);
  noStroke();
  rect(25, 0, 250, 45);
  stroke(0);
}
boolean borderingZero(ArrayList<Integer> index, ArrayList<ArrayList<Integer>> chunk) {
  ArrayList<ArrayList<Integer>> all = new ArrayList<ArrayList<Integer>>();
  ArrayList<Integer> add = new ArrayList<Integer>();
  boolean contains = false;
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      if (i == 0 && j == 0) {
        continue;
      } else {
        add = new ArrayList<Integer>();
        add.add(index.get(0) + i); 
        add.add(index.get(1) + j);
        all.add(add);
      }
    }
  }
  for (int i = 0; i < 8; i++) {
    if (chunk.contains(all.get(i))) {
      contains = true;
    }
  }
  return contains;
}
