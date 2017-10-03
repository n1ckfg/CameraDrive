def setupControls():
    global delta, keyW, keyA, keyS, keyD, keyQ, keyE, keySpace
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
    if (k == 'w'):
        keyW = b 
    elif (k == 'a'):
        keyA = b
    elif (k == 's'):
        keyS = b            
    elif (k == 'd'):
        keyD = b
    elif (k == 'q'):
        keyQ = b
    elif (k == 'e'):
        keyE = b
    elif (k == ' '):
        keySpace = b

def updateControls():
    if (keyW):
        cam.move(0,0,-delta)
    if (keyS):
        cam.move(0,0,delta)
    if (keyA):
        cam.move(-delta,0,0)
    if (keyD):
        cam.move(delta,0,0)
    if (keyQ):
        cam.move(0,delta,0)
    if (keyE):
        cam.move(0,-delta,0)
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