# PFM interface for the Julia language

[![Build Status](https://travis-ci.org/pleise/PFM.jl.svg?branch=master)](https://travis-ci.org/pleise/PFM.jl)

Portable Float Map (PFM) is a graphic image file format. This package provides an interface to read and write .pfm image files in [Julia]. The PFM format is used to store only ```Float32``` Arrays. Therefore every ```Float64``` Array will be converted automatically.

## Installation
```julia
Pkg.clone("git://github.com/pleise/PFM.jl.git")
```

## Basic usage

Load the package with:
```julia
using PFM
```
To read the image ```example.pfm``` enter the following command:
```julia
A=pfmread("example.pfm")
```
To save an array with type ```Array{Float32}``` or ```Array{Float64}``` enter:
```julia
pfmwrite("example.pfm", A)
```












[Julia]: http://julialang.org "Julia"
