class Cube:
    def __init__(self):
        self.pos = cam.mouse
        self.rot = PVector(-PI/random(3,6), PI/random(3,6), 0)
             
    def run():
        pushMatrix()
        translate(self.pos.x, self.pos.y, self.pos.z)
        rotateXYZ(self.rot.x, self.rot.y, self.rot.z)
        box(10)
        popMatrix()
    
    def rotateXYZ(x, y, z):
        rotateX(x)
        rotateY(y)
        rotateZ(z)
