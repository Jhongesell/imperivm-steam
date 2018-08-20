from PIL import Image

name = input("Specify the PNG image name, without .png extension: ")

name = name + ".png"

try:
    im = Image.open(name)

    pix = list(im.getdata())
    w, h = im.size
    n = w*h

    new_pix = [(0,255,0,255)]*n

    for i in range(n):
        x = pix[i]
        if x[0]==x[1] and x[1]==x[2]:
            new_pix[i] = pix[i]
            
    new_im = Image.new('RGB', im.size, "white")

    new_im.putdata(new_pix)

    new_im.save('greys.png')        

    input("OK! Press Enter to close")
    
except:

    input("An error occurred... Press Enter to close")