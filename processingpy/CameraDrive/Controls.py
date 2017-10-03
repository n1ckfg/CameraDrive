delta = 50

keyW = False
keyA = False
keyS = False
keyD = False
keyQ = False
keyE = False
keySpace = False

def keyPressed():
    checkKeyChar(key, True)

def keyReleased():
    checkKeyChar(key, False)

def checkKeyChar(k, b):
    switch (k):
        case 'w':
            return keyW = b
        case 'a':
            return keyA = b
        case 's':
            return keyS = b            
        case 'd':
            return keyD = b
        case 'q':
            return keyQ = b
        case 'e':
            return keyE = b
        case ' ':
            return keySpace = b
        default:
            return b

def updateControls():
    if (keyW) cam.move(0,0,-delta)
    if (keyS) cam.move(0,0,delta)
    if (keyA) cam.move(-delta,0,0)
    if (keyD) cam.move(delta,0,0)
    if (keyQ) cam.move(0,delta,0)
    if (keyE) cam.move(0,-delta,0)
    #~    
    if (keySpace):
        cam.reset()
        #keysOff() 

def keysOff():
    keyW = False
    keyA = False
    keyS = False
    keyD = False
    keyQ = False
    keyE = False
    keySpace = False