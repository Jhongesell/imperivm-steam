# import packages

from PIL import Image
import numpy as np
import os
from SpritesFunctions import SpritesFixer

dir_path = os.getcwd()

# list of BMPs

Bmp_List = os.listdir(dir_path+'\\bmp')
N_bmp = len(Bmp_List)

if N_bmp > 0:

    AVVIO = input('Analyze these ' + str(N_bmp) + ' BMPs? y / n:  ')
    
    if AVVIO == 'y' or AVVIO == 'Y':

        for BMP in Bmp_List:
            
            name = BMP[:-4]
            
            im = Image.open('bmp\\'+BMP)
            
            im_out = SpritesFixer(im)
            
            im_out.save("png\\"+name+".png", "PNG")
            
            print(name+' OK')
            
  
    s = input("\n\nAnalysis completed successfully! Press Enter to quit.")
    
else:

    s = input("\n\nThe folder is empty. Press enter to quit.")