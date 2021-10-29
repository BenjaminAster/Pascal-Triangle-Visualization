

//int wWidth = 800; // the width of the window
//int wHeight = 600; // the height of the window


int minSideLength;
int maxSideLength;

float squareSize = 20;
int modulo = 6;
int pascalSize;

boolean enableSingleModuloView = true;
int showOnly = 0;
boolean currentlyCalculating = false;
long lastKeyPress = -1;
boolean calculate = false;

int[][] pascalTriangle;

void setup() {
	size(document.documentElement.clientWidth, document.documentElement.clientHeight);
	
  minSideLength = min(width, height);

  pascalSize = int(minSideLength / squareSize);
  pascalTriangle = new int[pascalSize][pascalSize];
  noStroke();

	smooth();

  colorMode(HSB);
  textAlign(LEFT, TOP);
  textSize(20);

  PFont CalibriBold = createFont("Calibri Bold", 1);
  textFont(CalibriBold);

  drawTriangle();

  noStroke();
}

color calculateColor(float _colorVal) {
  colorMode(HSB);
  return color(1.0 * _colorVal, map(_colorVal % 16, 0, 15, 80, 255), map(_colorVal % 4, 0, 3, 120, 255));
}

void drawTriangle() {
  background(0);
  noStroke();
  for (int row = 0; row < pascalSize; row++) {

    for (int clm = 0; clm <= row; clm++) {

      if (clm == 0 || clm == row) {
        pascalTriangle[row][clm] = 1;
      } else {
        pascalTriangle[row][clm] = (pascalTriangle[row - 1][clm - 1] + pascalTriangle[row - 1][clm]) % modulo;
      }

      if (enableSingleModuloView == false) {
        fill(map(pascalTriangle[row][clm] % modulo, 0, modulo, 0, 255), 255, 255 );
        // print((pascalTriangle[row][clm]) + " % modulo = " + (pascalTriangle[row][clm] % modulo) + ", \n");
        rect(width / 2.0 + (clm - (row + 1)/2.0) * squareSize, row * squareSize, squareSize, squareSize);
      } else {
        if (showOnly == pascalTriangle[row][clm]) {
          fill(255);
          rect(width / 2.0 + (clm - (row + 1)/2.0) * squareSize, row * squareSize, squareSize, squareSize);
        }

      }
    }

    if (enableSingleModuloView == true) {
      fill(#FF0000);
      rect(0, row * squareSize, width / 2.0 - squareSize * (row + 1) / 2.0, squareSize);
      rect(width / 2.0 + squareSize * (row + 1) / 2.0, row * squareSize, width - width / 2.0 - squareSize * (row + 1) / 2.0, squareSize);
    }

    fill(255);
    textAlign(RIGHT, CENTER);
    textSize(squareSize);
    text(row, width / 2.0 - squareSize * (row + 1.25) / 2.0, (row + 0.5) * squareSize);
  }


  textAlign(LEFT, TOP);
  textSize(width / 50);
  fill(255);
  if (enableSingleModuloView == true) {
    text(("modulo = " + modulo + " (up & down arrow)\nsquare size = " + int(squareSize * 100.0) / 100.0 + " (left & right arrow)\nshow only = " + showOnly + " (W & S)\nPress V to enable color view"), 10, 10);

    textAlign(RIGHT, CENTER);
    for (int i = 0; i < modulo; i++) {
      noStroke();
      if (i == showOnly) {

        fill(255);
      } else {

        fill(0);
      }
      rect(1.0 * width - height / 20, 1.0 * i * height / modulo, 1.0 * height / 20, 1.0 * height / modulo);
      fill(255);
      if (modulo < 40) {
        textSize(1.0 * height / 40);
      } else {
        textSize(1.0 * height / modulo);
      }
      text(i + " = ", width - height / 20, (i + 0.5) * height / modulo);
    }
  } else {
    text(("modulo = " + modulo + " (up & down arrow)\nsquare size = " + int(squareSize * 100.0) / 100.0) + " (left & right arrow)\nPress V to enable modulo view", 10, 10);
    textAlign(RIGHT, CENTER);
    for (int i = 0; i < modulo; i++) {
      noStroke();
      fill(map(i, 0.0, modulo, 0.0, 255.0), 255, 255);
      
      rect(1.0 * width - height / 20.0, 1.0 * i * height / modulo, 1.0 * height / 20.0, 1.0 * height / modulo);
      fill(255);
      if (modulo < 40) {
        textSize(1.0 * height / 40.0);
      } else {
        textSize(1.0 * height / modulo);
      }
      text(i + " = ", width - height / 20.0, (i + 0.5) * height / modulo);
    }
  }
}


void draw() {
  if (keyPressed == true) {
    if (lastKeyPress == -1) {
      calculate = true;
      lastKeyPress = millis() + 300;
    } else if (millis() - lastKeyPress > 50) {
      calculate = true;
      lastKeyPress = millis();
    }

    if (calculate == true) {
      if (keyCode == UP) {
        modulo++;
      } else if (keyCode == DOWN) {
        modulo--;
      } else if (keyCode == RIGHT) {
        squareSize *= 1.3;
      } else if (keyCode == LEFT) {
        squareSize /= 1.3;
      } else if (key == 'w') {
        enableSingleModuloView = true;
        showOnly++;
      } else if (key == 's') {
        enableSingleModuloView = true;
        showOnly--;
      } else if (key == 'v') {
        enableSingleModuloView = !enableSingleModuloView;
      }

      if (modulo <= 0) {
        modulo = 1;
      }
      if (squareSize <= 0) {
        squareSize = 1;
      }

      showOnly += modulo;
      showOnly %= modulo;



      pascalSize = int(minSideLength / squareSize) + 1;
      pascalTriangle = new int[pascalSize][pascalSize];
      drawTriangle();
      calculate = false;
    }
  } else {
    lastKeyPress = -1;
  }
}