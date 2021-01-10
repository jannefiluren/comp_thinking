function diffusion(T, T_1, T_N, D, t, δt, δx)

    N = length(T)
    T´ = similar(T)

    T[1] = T_1(t)
    T[N] = T_N(t)

    for i in 2:N-1
        T´[i] = T[i] + δt * D * (T[i-1] - 2T[i] + T[i+1]) / (δx^2)
    end

    T´[1] = T[1]
    T´[N] = T[N]

    return T´

end


function evolve(method, T_1, T_N, T_init, T_end, D, δt, δx)

    T = T_init
    t = [0.0]
    T_all = [T]

    while t[end] < T_end
		T´ = method(T, T_1, T_N, D, t[end], δt, δx)
        T = copy(T´)
        push!(t, t[end] + δt)
        push!(T_all, T)
    end

    return t, T_all
end

T_1 = x -> sin(x)
T_N = x -> 0
D = 1
δt = 0.001
δx = 0.1
N = 500

T_init = zeros(N)
x = δx/2:δx:δx*N

t, T_all = evolve(diffusion, T_1, T_N, T_init, 100, D, δt, δx)
