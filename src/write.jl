""" 
    pfmwrite(File::String, Img::Array{Float32}) 
    pfmwrite(File::String, Img::Array{Float64}) 
    pfmwrite(File::String, Img::Array{Float32}, Endian::String)
    pfmwrite(File::String, Img::Array{Float64}, Endian::String)

Write an `Array` to a .pfm (Portable Float Map) image file.

`File` is the image file, i.e. \"image.pfm\". `Img` is the Image to save.
`Endian` is either \"little-endian\" or \"big-endian\".
"""
function pfmwrite(File::String, Img::Array{Float64})
    
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
    
    f=open(File,"w")
    
    if ~isopen(f)
        error("Can't open the file!")
    end

    if length(size(Img)) == 3 && size(Img,3)==3
         
        #println("Write PF")
        write(f, "PF\n")
        
        # write the size
        write(f, "$(size(Img,2)) $(size(Img,1))\n")
        
        
        if hostendian == "little-endian"
            #write little endian
            write(f, "-1.0\n")
        elseif hostendian == "big-endian"
            write(f, "1.0\n")
        end
        
        # Write the image data in the host-endian format
        
        for i=size(Img,1):-1:1
            for j=1:size(Img,2)
                for k=1:size(Img,3)
                    write(f, Float32(Img[i,j,k]))
                end
            end
        end 
    elseif length(size(Img)) == 2 || (length(size(Img)) == 3 && size(Img,3)==1)
        #println("write Pf")
        write(f, "Pf\n")
        
        # write the size
        write(f, "$(size(Img,2)) $(size(Img,1))\n")
        
        if hostendian == "little-endian"
            #write little endian
            write(f, "-1.0\n")
        elseif hostendian == "big-endian"
            write(f, "1.0\n")
        end  
        # Write the image data in the host-endian format 
        for i=size(Img,1):-1:1
            for j=1:size(Img,2)
                write(f, Float32(Img[i,j]))
            end
        end      
    else
        error("The input can't be written to a .pmf file! Only NxN, NxNx1 or NxNx3 arrays can be stored in a .pmf file!")
    end  
    close(f)  
end

function pfmwrite(File::String, Img::Array{Float32})
    
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
 
    f=open(File,"w")
    if ~isopen(f)
        error("Can't open the file!")
    end
    

    if length(size(Img)) == 3 && size(Img,3)==3
         
        #println("Write PF")
        write(f, "PF\n")
        
        # write the size
        write(f, "$(size(Img,2)) $(size(Img,1))\n")
        
        
        if hostendian == "little-endian"
            #write little endian
            write(f, "-1.0\n")
        elseif hostendian == "big-endian"
            write(f, "1.0\n")
        end
        
        # Write the image data in the host-endian format
        
        for i=size(Img,1):-1:1
            for j=1:size(Img,2)
                #for k=1:size(Img,3)
                    write(f, Img[i,j,:])
                #end
            end
        end

    elseif length(size(Img)) == 2 || (length(size(Img)) == 3 && size(Img,3)==1)
        #println("write Pf")
        write(f, "Pf\n")
        
        # write the size
        write(f, "$(size(Img,2)) $(size(Img,1))\n")
        
        if hostendian == "little-endian"
            #write little endian
            write(f, "-1.0\n")
        elseif hostendian == "big-endian"
            write(f, "1.0\n")
        end
   
        # Write the image data in the host-endian format
        
        for i=size(Img,1):-1:1
            for j=1:size(Img,2)
                write(f, Img[i,j])
            end
        end
     
    else
        error("The input can't be written to a .pmf file! Only NxN, NxNx1 or NxNx3 arrays can be stored in a .pmf file!")
    end

    close(f)

end

function pfmwrite(File::String, Img::Array{Float32}, Endian::String)
    
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
    
    if ~isequal(Endian, "little-endian") &&  ~isequal(Endian, "big-endian")
        error("Endian must be either \"little-endian\" or \"big-endian\"")
    end
    
    f=open(File,"w")
    if ~isopen(f)
        error("Can't open the file!")
    end
    

    if hostendian==Endian
        if length(size(Img)) == 3 && size(Img,3)==3

            #println("Write PF")
            write(f, "PF\n")

            # write the size
            write(f, "$(size(Img,2)) $(size(Img,1))\n")


            if hostendian == "little-endian"
                #write little endian
                write(f, "-1.0\n")
            elseif hostendian == "big-endian"
                write(f, "1.0\n")
            end

            # Write the image data in the host-endian format

            for i=size(Img,1):-1:1
                for j=1:size(Img,2)
                    #for k=1:size(Img,3)
                        write(f, Img[i,j,:])
                    #end
                end
            end


        elseif length(size(Img)) == 2 || (length(size(Img)) == 3 && size(Img,3)==1)
            #println("write Pf")
            write(f, "Pf\n")

            # write the size
            write(f, "$(size(Img,2)) $(size(Img,1))\n")

            if hostendian == "little-endian"
                #write little endian
                write(f, "-1.0\n")
            elseif hostendian == "big-endian"
                write(f, "1.0\n")
            end


            # Write the image data in the host-endian format

            for i=size(Img,1):-1:1
                for j=1:size(Img,2)
                    write(f, Img[i,j])
                end
            end



        else
            error("The input can't be written to a .pmf file! Only NxN, NxNx1 or NxNx3 arrays can be stored in a .pmf file!")
        end
    
    
    elseif Endian=="big-endian" && hostendian == "little-endian"  
        
        if length(size(Img)) == 3 && size(Img,3)==3

            #println("Write PF")
            write(f, "PF\n")

            # write the size
            write(f, "$(size(Img,2)) $(size(Img,1))\n")

            # write big-endian to the pfm file
            write(f, "1.0\n")
                

            # Write the image data in the host-endian format

            for i=size(Img,1):-1:1
                for j=1:size(Img,2)
                    for k=1:size(Img,3)
                        write(f, hton(Img[i,j,k]))
                    end
                end
            end


        elseif length(size(Img)) == 2 || (length(size(Img)) == 3 && size(Img,3)==1)
            #println("write Pf")
            write(f, "Pf\n")

            # write the size
            write(f, "$(size(Img,2)) $(size(Img,1))\n")

            # write big-endian to the pfm file
            write(f, "1.0\n")
            


            # Write the image data in the big-endian format

            for i=size(Img,1):-1:1
                for j=1:size(Img,2)
                    write(f, hton(Img[i,j]))
                end
            end

        else
            error("The input can't be written to a .pmf file! Only NxN, NxNx1 or NxNx3 arrays can be stored in a .pmf file!")
        end
  
    elseif Endian=="little-endian" && hostendian == "big-endian"  
        
        if length(size(Img)) == 3 && size(Img,3)==3

            #println("Write PF")
            write(f, "PF\n")

            # write the size
            write(f, "$(size(Img,2)) $(size(Img,1))\n")

            # write little-endian to the pfm file
            write(f, "-1.0\n")
                

            # Write the image data in the little-endian format

            for i=size(Img,1):-1:1
                for j=1:size(Img,2)
                    for k=1:size(Img,3)
                        write(f, htol(Img[i,j,k]))
                    end
                end
            end


        elseif length(size(Img)) == 2 || (length(size(Img)) == 3 && size(Img,3)==1)
            #println("write Pf")
            write(f, "Pf\n")

            # write the size
            write(f, "$(size(Img,2)) $(size(Img,1))\n")

            # write little-endian to the pfm file
            write(f, "-1.0\n")
            


            # Write the image data in the host-endian format

            for i=size(Img,1):-1:1
                for j=1:size(Img,2)
                    write(f, htol(Img[i,j]))
                end
            end

        else
            error("The input can't be written to a .pmf file! Only NxN, NxNx1 or NxNx3 arrays can be stored in a .pmf file!")
        end
      
    end       
    close(f) 
end

function pfmwrite(File::String, Img::Array{Float64}, Endian::String)
    
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
    
    if ~isequal(Endian, "little-endian") &&  ~isequal(Endian, "big-endian")
        error("Endian must be either \"little-endian\" or \"big-endian\"")
    end
    
    f=open(File,"w")
    if ~isopen(f)
        error("Can't open the file!")
    end
    

    if hostendian==Endian
        if length(size(Img)) == 3 && size(Img,3)==3

            #println("Write PF")
            write(f, "PF\n")

            # write the size
            write(f, "$(size(Img,2)) $(size(Img,1))\n")


            if hostendian == "little-endian"
                #write little endian
                write(f, "-1.0\n")
            elseif hostendian == "big-endian"
                write(f, "1.0\n")
            end

            # Write the image data in the host-endian format

            for i=size(Img,1):-1:1
                for j=1:size(Img,2)
                    for k=1:size(Img,3)
                        write(f, Float32(Img[i,j,k]))
                    end
                end
            end


        elseif length(size(Img)) == 2 || (length(size(Img)) == 3 && size(Img,3)==1)
            #println("write Pf")
            write(f, "Pf\n")

            # write the size
            write(f, "$(size(Img,2)) $(size(Img,1))\n")

            if hostendian == "little-endian"
                #write little endian
                write(f, "-1.0\n")
            elseif hostendian == "big-endian"
                write(f, "1.0\n")
            end


            # Write the image data in the host-endian format

            for i=size(Img,1):-1:1
                for j=1:size(Img,2)
                    write(f, Float32(Img[i,j]))
                end
            end



        else
            error("The input can't be written to a .pmf file! Only NxN, NxNx1 or NxNx3 arrays can be stored in a .pmf file!")
        end
    
    
    elseif Endian=="big-endian" && hostendian == "little-endian"  
        
        if length(size(Img)) == 3 && size(Img,3)==3

            #println("Write PF")
            write(f, "PF\n")

            # write the size
            write(f, "$(size(Img,2)) $(size(Img,1))\n")

            # write big-endian to the pfm file
            write(f, "1.0\n")
                

            # Write the image data in the host-endian format

            for i=size(Img,1):-1:1
                for j=1:size(Img,2)
                    for k=1:size(Img,3)
                        write(f, hton(Float32(Img[i,j,k])))
                    end
                end
            end


        elseif length(size(Img)) == 2 || (length(size(Img)) == 3 && size(Img,3)==1)
            #println("write Pf")
            write(f, "Pf\n")

            # write the size
            write(f, "$(size(Img,2)) $(size(Img,1))\n")

            # write big-endian to the pfm file
            write(f, "1.0\n")
            


            # Write the image data in the big-endian format

            for i=size(Img,1):-1:1
                for j=1:size(Img,2)
                    write(f, hton(Float32(Img[i,j])))
                end
            end



        else
            error("The input can't be written to a .pmf file! Only NxN, NxNx1 or NxNx3 arrays can be stored in a .pmf file!")
        end
        
        
        
        
        
    elseif Endian=="little-endian" && hostendian == "big-endian"  
        
        if length(size(Img)) == 3 && size(Img,3)==3

            #println("Write PF")
            write(f, "PF\n")

            # write the size
            write(f, "$(size(Img,2)) $(size(Img,1))\n")

            # write little-endian to the pfm file
            write(f, "-1.0\n")
                

            # Write the image data in the little-endian format

            for i=size(Img,1):-1:1
                for j=1:size(Img,2)
                    for k=1:size(Img,3)
                        write(f, htol(Float32(Img[i,j,k])))
                    end
                end
            end


        elseif length(size(Img)) == 2 || (length(size(Img)) == 3 && size(Img,3)==1)
            write(f, "Pf\n")

            # write the size
            write(f, "$(size(Img,2)) $(size(Img,1))\n")

            # write little-endian to the pfm file
            write(f, "-1.0\n")

            # Write the image data in the host-endian format

            for i=size(Img,1):-1:1
                for j=1:size(Img,2)
                    write(f, htol(Float32(Img[i,j])))
                end
            end

        else
            error("The input can't be written to a .pmf file! Only NxN, NxNx1 or NxNx3 arrays can be stored in a .pmf file!")
        end
     
    end
        
    close(f)
   
end