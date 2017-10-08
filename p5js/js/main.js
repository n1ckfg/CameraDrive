"use strict";

var cam, cubes;

function setup() {
  createCanvas(1280, 720, WEBGL);
  cam = new Cam();
  cubes = [];
  noStroke();
}

function draw() {
  ambientLight(255);
  background(0);

  push();
  translate(width/2, height/2, 0);
  rotateX(-PI/6);
  rotateY(PI/3);
  box(100);
  pop();
  
  updateControls();
  cam.run();
  
  for (var i=0; i<cubes.size(); i++) {
    cubes[i].run();
  }
}

function mousePressed() {
  cubes.push(new Cube());
}


class Cube {
  
  constructor() {
    this.pos = cam.mouse;
    this.rot = createVector(-PI/random(3,6), PI/random(3,6), 0);
  }
  
  run() {
    push();
    translate(this.pos.x, this.pos.y, this.pos.z);
    rotateXYZ(this.rot.x, this.rot.y, this.rot.z);
    box(10);
    pop();
  }
  
  rotateXYZ(x, y, z){
    rotateX(x);
    rotateY(y);
    rotateZ(z);
  }
  
}