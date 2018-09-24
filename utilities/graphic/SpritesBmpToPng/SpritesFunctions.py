# IMPORT PACKAGES

from PIL import Image
from collections import Counter
import numpy as np


def SpritesFixer(pil_im):

    IMG = np.asarray(pil_im.convert('RGBA'))
    IMG_data = list(pil_im.getdata())

    # BASIC INFORMATIONS

    WIDTH = IMG.shape[1]
    HEIGHT = IMG.shape[0]
    DIRECTIONS = Counter(IMG_data[:WIDTH]).most_common()[1][1]+1
    FRAMES = Counter(list(map(tuple,IMG[:,:1].reshape(1,HEIGHT,4)[0]))).most_common()[1][1]+1
    CELL_WIDTH = int((WIDTH-DIRECTIONS+1)/DIRECTIONS)
    CELL_HEIGHT = int((HEIGHT-FRAMES+1)/FRAMES)

    # CALCOL0 AREA DI RITAGLIO

    pil_back = Image.new('RGBA', (CELL_WIDTH,CELL_HEIGHT), (255, 255, 255, 0))
    back = np.asarray(pil_back)
    back.setflags(write=1)

    D = {}

    for i in range(DIRECTIONS):
        for j in range(FRAMES):
            img = IMG[(j*CELL_HEIGHT+j):(j*CELL_HEIGHT+CELL_HEIGHT+j) , (i*CELL_WIDTH+i):(i*CELL_WIDTH+CELL_WIDTH+i)]
            img.setflags(write=1)       
            red, green, blue, alpha = img.T
            back = list(img[0][0])
            back_areas = (red == back[0]) & (blue == back[2]) & (green == back[1])
            img[..., :][back_areas.T] = (255, 255, 255, 0)
            D[(j,i)]=img
            pil_img = Image.fromarray(img)
            pil_back.paste(pil_img, (0, 0), pil_img)

    pasted0 = np.asarray(pil_back)  
    pasted1 = np.rot90(pasted0, 1)
    pasted2 = np.rot90(pasted0, 2)
    pasted3 = np.rot90(pasted0, 3)

    h0 = 0
    for row in pasted0:
        if sum(row)[3] == 0:
            h0+=1
        else: 
            break

    h1 = 0
    for row in pasted2:
        if sum(row)[3] == 0:
            h1+=1
        else: 
            break

    h1 = CELL_HEIGHT-h1        

    w0 = 0
    for row in pasted3:
        if sum(row)[3] == 0:
            w0+=1     
        else: 
            break

    w1 = 0
    for row in pasted1:
        if sum(row)[3] == 0:
            w1+=1
        else: 
            break
    w1 = CELL_WIDTH-w1       

    h = h1-h0
    w = w1-w0

    # CROP SPRITES

    for (k,v) in D.items():
        D[k]=v[h0:h1,w0:w1]

    # CREATE FINAL SPRITE
    
    W = w * FRAMES
    H = h * DIRECTIONS

    BACK = np.asarray(Image.new('RGBA', (W,H), (255, 255, 255, 0)))
    BACK.setflags(write=1)        

    for i in range(DIRECTIONS):
        for j in range(FRAMES):
            BACK[i*h:(i*h+h), j*w:(j*w+w)] = D[(j,i)]

    return [Image.fromarray(BACK), w, h]