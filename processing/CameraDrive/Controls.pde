float deltaOrig = 10;
//float deltaFast = 10;
float delta = deltaOrig;

boolean keyW = false;
boolean keyA = false;
boolean keyS = false;
boolean keyD = false;
boolean keyQ = false;
boolean keyE = false;
boolean keySpace = false;

void keyPressed() {
  checkKeyChar(key, true);
}

void keyReleased() {
  checkKeyChar(key, false);
}

boolean checkKeyChar(char k, boolean b) {
  switch (k) {
    case 'w':
      return keyW = b;
    case 'a':
      return keyA = b;
    case 's':
      return keyS = b;      
    case 'd':
      return keyD = b;
    case 'q':
      return keyQ = b;
    case 'e':
      return keyE = b;
    case ' ':
      return keySpace = b;
    default:
      return b;
  }
}

/*
boolean checkKeyCode(int k, boolean b) {
  switch (k) {
    case SHIFT:
      return keyShift = b;
    default:
      return b;
  }
}
*/

void updateControls() {

  if (keyW) cam.moveForward();
  if (keyS) cam.moveBack();
  if (keyA) cam.moveLeft();
  if (keyD) cam.moveRight();
  if (keyQ) cam.moveDown();
  if (keyE) cam.moveUp();
  
  /*
  if (keyW) cam.move(new PVector(0, 0, -delta));
  if (keyS) cam.move(new PVector(0, 0, delta));
  if (keyA) cam.move(new PVector(-delta, 0, 0));
  if (keyD) cam.move(new PVector(delta, 0, 0));
  if (keyQ) cam.move(new PVector(0, delta, 0));
  if (keyE) cam.move(new PVector(0, -delta, 0));
  */
  
  if (keySpace) {
    cam.reset();
    //keysOff();  
  }
}

void keysOff() {
  keyW = false;
  keyA = false;
  keyS = false;
  keyD = false;
  keyQ = false;
  keyE = false;
  keySpace = false;
}