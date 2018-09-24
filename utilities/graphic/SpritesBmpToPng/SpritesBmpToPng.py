# IMPORT PACKAGES

from PIL import Image
import numpy as np
import os
from SpritesFunctions import SpritesFixer

dir_path = os.getcwd()

# READ LIST OF BMPS

Bmp_List = os.listdir(dir_path+'\\bmp')
N_bmp = len(Bmp_List)

if N_bmp > 0:
    AVVIO = input('Analyze these ' + str(N_bmp) + ' BMPs? y / n:  ')    
    if AVVIO == 'y' or AVVIO == 'Y':
        for BMP in Bmp_List:
            name = BMP[:-4]
            im = Image.open('bmp\\'+BMP)
            
            # FILE INFORMATIONS
            
            file = open("png\\"+name+"_NOTES.txt", "w")
            file.write("/* "+name+" */") 
            file.write("\n\n")
            
            # FUNCTION
            
            im_out = SpritesFixer(im)
            file.write("Cell width: "+str(im_out[1])+"\n")
            file.write("Cell height: "+str(im_out[2])+"\n")
            
            # SAVE PNG
            
            im_out[0].save("png\\"+name+".png", "PNG")
            
            print(name+' OK')
            file.close()
            
    s = input("\n\nAnalysis completed successfully! Press Enter to quit.")
else:
    s = input("\n\nThe folder is empty. Press enter to quit.")