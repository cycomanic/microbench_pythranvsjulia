using LoopVectorization: @tturbo
using BenchmarkTools

function eval_exp(N)
    a = range(0, stop=2*pi, length=N)
    A = Matrix{ComplexF64}(undef, N, N)
    @inbounds Threads.@threads for j in 1:N
        for i in 1:N
            A[i,j] = exp(100*im*sqrt(a[i]^2 + a[j]^2))
        end
    end
    return A
end

function eval_exp_tweaked_4_serial(N) # ... and range collected
    a = collect(range(0, stop=2*pi, length=N))
    A = Matrix{ComplexF64}(undef, N, N)
    for (j,aj) in pairs(a)
        for i in eachindex(a)
            @inbounds A[i,j] = cis(100*sqrt(a[i]^2 + aj^2))
        end
    end
    return A
end

function eval_exp_tweaked_4_parallel(N) # ... and range collected
    a = collect(range(0, stop=2*pi, length=N))
    A = Matrix{ComplexF64}(undef, N, N)
    Threads.@threads for j in eachindex(a)
        for i in eachindex(a)
            @inbounds A[i,j] = cis(100*sqrt(a[i]^2 + a[j]^2))
        end
    end
    return A
end

function eval_exp_tturbo(N)
    A = Matrix{Complex{Float64}}(undef, N, N)
    a = range(0, stop=2*pi, length=N)
    _A = reinterpret(reshape, Float64, A)
    @tturbo for i in 1:N, j in 1:N
        Aij_im, Aij_re = sincos(100*sqrt(a[i]^2 + a[j]^2))
        _A[1,i,j] = Aij_re
        _A[2,i,j] = Aij_im
    end
    A
end

print(string("running loop on ", Threads.nthreads(), " threads \n"))
for N in [1000,2000,4000]
    @show N
    A = @btime eval_exp($N)
    B = @btime eval_exp_tweaked_4_serial($N)
    B2 = @btime eval_exp_tweaked_4_parallel($N)
    C = @btime eval_exp_tturbo($N)
    println()
end
