"use strict";

// https://processing.org/reference/camera_.html
class Cam {

    constructor() {
        this.pos = createVector(0,0,0);
        this.poi = createVector(0,0,0);
        this.up = createVector(0,0,0);

        this.mouse = createVector(0,0,0);
        this.p3d;
        this.proj;
        this.cam;
        this.modvw;
        this.modvwInv;
        this.screen2Model;
        
        this.displayText = "";
        this.font;
        this.fontSize = 12;

        this.defaultPos();
        this.defaultPoi();
        this.defaultUp();
        this.init();
    }

    init() {
        this.p3d = p5.RendererGL;
        //proj = new PMatrix3D();
        this.cam = new PMatrix3D();
        //modvw = new PMatrix3D();
        this.modvwInv = new PMatrix3D();
        this.screen2Model = new PMatrix3D();
        
        this.font = createFont("Arial", this.fontSize);
    }
    
    screenToWorldCoords(p) {
        //proj = p3d.projection.get();
        this.cam = this.p3d.modelview.get(); //camera.get();
        //modvw = p3d.modelview.get();
        this.modvwInv = this.p3d.modelviewInv.get();
        this.screen2Model = this.modvwInv;
        this.screen2Model.apply(this.cam);
        var screen = [ this.p.x, this.p.y, this.p.z ];
        var model = [ 0, 0, 0 ];
        model = this.screen2Model.mult(screen, model);
        
        return createVector(model[0] + (this.poi.x - width/2), model[1] + (this.poi.y - height/2), model[2]);
    }
    
    screenToWorldMouse() {
        this.mouse = screenToWorldCoords(createVector(mouseX, mouseY, this.poi.z));
    }
    
    update() {
        this.screenToWorldMouse();
    }
    
    draw() {
        camera(this.pos.x, this.pos.y, this.pos.z, this.poi.x, this.poi.y, this.poi.z, this.up.x, this.up.y, this.up.z);
        this.drawText();
    }
    
    run() {
        this.update();
        this.draw();
    }
    
    move(x, y, z) {
        var p = createVector(x,y,z);
        this.pos = this.pos.add(p);
        this.poi = this.poi.add(p);
    }
    
    defaultPos() {
        this.pos.x = width/2.0;
        this.pos.y = height/2.0;
        this.pos.z = (height/2.0) / tan(PI*30.0 / 180.0);
    }
    
    defaultPoi() {
        this.poi.x = width/2.0;
        this.poi.y = height/2.0;
        this.poi.z = 0;
    }
    
    defaultUp() {
     this.up.x = 0;
     this.up.y = 1;
     this.up.z = 0;
    }
    
    reset() {
     this.defaultPos();
     this.defaultPoi();
     this.defaultUp();
    }
    
    drawText() {
        if (!this.displayText.equals("")) {
            push();    
            translate((this.pos.x - (width/2)) + (this.fontSize/2), (this.pos.y - (height/2)) + this.fontSize, this.poi.z);
            textFont(this.font, this.fontSize);
            text(this.displayText, 0, 0);
            pop();
        }
    }
    
}

// TODO
// https://processing.org/reference/frustum_.html
// https://processing.org/reference/beginCamera_.html
// https://processing.org/reference/endCamera_.html