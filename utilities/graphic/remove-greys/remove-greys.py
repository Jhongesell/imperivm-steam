from PIL import Image

name = input("Specify the BMP image name, without .BMP extension: ")

name2 = name + ".bmp"

try:
    im = Image.open(name2)
    im = im.convert('RGB')
    pix = list(im.getdata())
    w, h = im.size
    n = w*h
    
    
    new_pix = pix
    
    k=0
    for i in range(n):
        
        x = pix[i]
        
        if x[0] == x[1] and x[1] == x[2] and x[0] <= 254:
        
            new_pix[i]=((x[0],x[1],x[2]+1,255))
            k+=1
    
    
    new_im = Image.new('RGB', im.size, "white")
    
    
    new_im.putdata(new_pix)

    
    new_im.save(name+'_fixed.png')        
    
    print(str(k)+' colors have been fixed')
    
    input("OK!... Press Enter to close")
    
    
except:

    input("An error occurred... Press Enter to close")