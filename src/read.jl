"""    pfmread(File::String) 
Read a .pfm (Portable Float Map) image file and return the image as a `Float32`-Array.

`File` is the image, i.e. \"image.pfm\" """
function pfmread(File::String)
    
    #check the file ending
    if ~ismatch(r".pfm", File[end-3:end])
        error("Wrong file ending! Must be a .pfm file!")
    end
    
    
    # check the endian on the host system
    if isequal(ENDIAN_BOM, 0x01020304) 
        # big-endian machine
        hostendian="big-endian"
    elseif isequal(ENDIAN_BOM, 0x04030201) 
        # little-endian machine
        hostendian="little-endian"
    else
        error("Can't detect the endian of the host!")
    end
    
    # to read .pfm files
    f=open(File, "r")
    if ~isopen(f)
        error("Can't open the file!")
    end
    A=readbytes(f)
    close(f)
    
    # get the ending of the first, second and third "line"
    
    k=1
    del=zeros(Int, 3,1)
    for i=1:size(A,1)
        if isequal(0x0a, A[i,1]) && k <= 3
            del[k,1]=i
            #println(del[k,1])
            k+=1
        elseif k == 4
            break
        end
    end
    
    
    if k==1
        error("Input has no pfm header!")
    end
    
    
    # Check if grayscale or 3-channel RGB image
    if ascii(A[1:del[1,1]-1]) == "Pf"
        #println("grayscale image")
        color="grayscale"
    elseif ascii(A[1:del[1,1]-1]) == "PF"
        #println("3-channel RGB color image")
        color="RGB"
    else
        error("Incorrect type declaraction in line 1!")
    end
    
    # get the dimensions
    dim=ascii(A[del[1,1]+1:del[2,1]-1])
    if ismatch(r"\d+\s\d+", dim)
        # Parse the input for the image size
        m=match(r"(?P<width>\d+)\s(?P<height>\d+)", dim)
        width=parse(Int,m[:width])
        height=parse(Int, m[:height])
    else
        error("Incorrect declaration of the dimensions in line 2!")
    end
    
    byteorder=ascii(A[del[2,1]+1:del[3,1]-1])
    if ismatch(r"\d+.\d+", byteorder)
        line3=parse(Float64, byteorder)
    else
        error("Incorrect byte order in line 3!")
    end
    
    if line3 < 0.0 
        endian="little-endian"
    elseif line3 > 0.0
        endian="big-endian"
    else
        error("Incorrect byte order in line 3!")
    end
    
    # right declaration of the final image
    if mod((size(A,1)-del[3,1]),4) == 0
        
        
        
        if color=="grayscale"
            # prepare the image-matrix
            #Img=zeros(Float32, height, width);
            Img=Array{Float32}(height, width);
            
            fl32=reinterpret(Float32, A[del[3,1]+1:end])

            if (endian=="little-endian" && hostendian=="little-endian") || (endian=="big-endian" && hostendian=="big-endian")
                # do nothing
            elseif endian=="big-endian" && hostendian=="little-endian"
                
                for i=1:size(fl32,1)
                    fl32[i,1]=ntoh(fl32[i,1])
                end
            elseif endian=="little-endian" && hostendian=="big-endian"
                for i=1:size(fl32,1)
                    fl32[i,1]=ltoh(fl32[i,1])
                end
                
            end
            
            
            k=1
            for i=size(Img,1):-1:1
                for j=1:size(Img,2)
                    
                    Img[i,j]=fl32[k] 
                    k+=1  
               end
            end 
            return Img
                
        elseif color=="RGB"
            Img=Array{Float32}(height, width,3);
                
            
            fl32=reinterpret(Float32, A[del[3,1]+1:end])
             
            
            
            if (endian=="little-endian" && hostendian=="little-endian") || (endian=="big-endian" && hostendian=="big-endian")
                # do nothing
            elseif endian=="big-endian" && hostendian=="little-endian"
                
                for i=1:size(fl32,1)
                    fl32[i,1]=ntoh(fl32[i,1])
                end
            elseif endian=="little-endian" && hostendian=="big-endian"
                for i=1:size(fl32,1)
                    fl32[i,1]=ltoh(fl32[i,1])
                end
                
            end
            
            
            
                
            l=1
            for i=size(Img,1):-1:1
                for j=1:size(Img,2)
                    for k=1:size(Img,3)
                        Img[i,j,k]=fl32[l]
                        l+=1   
                    end
                end
            end 
            return Img
                
                
                
                
                
                
                
        end


    
    else
        error("wrong declaration of the image data. It must be a Float32 for each Pixel!")
    end

end


