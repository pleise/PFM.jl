module PFM

using Compat
import Compat: UTF8String, ASCIIString

include("read.jl")
include("write.jl")

export pfmwrite, pfmread


end
