# import packages

from PIL import Image
import numpy as np
import os

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
            im = im.convert('RGBA')

            data = np.array(im)
            red, green, blue, alpha = data.T
            
            back = list(data[0][0])
            
            back_areas = (red == back[0]) & (blue == back[2]) & (green == back[1])
            
            data[..., :][back_areas.T] = (255, 255, 255, 0)

            positions_y = []
            i=0
            
            for el in data[0]:
                
                if el[3] != 0:
                    positions_y.append(i)
                i+=1
                
            positions_x = []
            i=0
            for el in data:    
                if el[0][3] != 0:
                    positions_x.append(i)        
                i+=1
                
            for i in positions_x:
                data[i] = (255,255,255,0)
                  
            for n in range(data.shape[0]):
                for j in positions_y:
                    data[n][j]=(255,255,255,0)
                    
            im2 = Image.fromarray(data)
            im2.save("png\\"+name+".png", "PNG")
            
            print(name+' OK')
            
  
    s = input("\n\nAnalysis completed successfully! Press Enter to quit.")
    
else:

    s = input("\n\nThe folder is empty. Press enter to quit.")