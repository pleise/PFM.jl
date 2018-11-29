using PFM
using Test


@test begin
	if isfile("test.pfm")
		rm("test.pfm")
	end
	
	pfmwrite("test.pfm", [0.4 0.2; 0.1 0.3])
	
	sleep(0.5)

	return convert(Array{Float32}, [0.4 0.2; 0.1 0.3]) == pfmread("test.pfm")
end


@test begin 
	C = rand(Float64, 10,10)

	if isfile("test.pfm")
		rm("test.pfm")
	end
	pfmwrite("test.pfm", C)
	sleep(0.5)
	B = pfmread("test.pfm")
	rm("test.pfm")
	return convert(Array{Float32}, C) == B
end

@test begin 
	C = rand(Float64, 2,2,1)

	if isfile("test.pfm")
		rm("test.pfm")
	end
	pfmwrite("test.pfm", C, "big-endian")
	sleep(0.5)
	B = pfmread("test.pfm")
	rm("test.pfm")
	return convert(Array{Float32}, C) == B
end

@test begin 
	C = rand(Float64, 5,5,3)

	if isfile("test.pfm")
		rm("test.pfm")
	end
	pfmwrite("test.pfm", C, "little-endian")
	sleep(0.5)
	B = pfmread("test.pfm")
	rm("test.pfm")
	return convert(Array{Float32}, C) == B
end

if isfile("test.pfm")
	rm("test.pfm")
end


