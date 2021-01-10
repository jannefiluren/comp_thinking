### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 328c490e-52a8-11eb-045a-bb9c8e209387
begin
	using PyPlot
	using PlutoUI
end

# ╔═╡ f21e3d62-52ad-11eb-2c95-496437dbd7a8
function with_pyplot(f::Function)
    f()
    fig = gcf()
    close(fig)
    return fig
end

# ╔═╡ 275928b0-52a8-11eb-1368-39e9a3b2c90a
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

# ╔═╡ 31bc27d0-52a8-11eb-3f2d-fb955ba9bc4e
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

# ╔═╡ 36089e90-52a8-11eb-1309-a30a83726b7d
begin
	T_1 = x -> sin(x)
	T_N = x -> 0
	D = 1
	δt = 0.001
	δx = 0.1
	N = 500
	
	T_init = zeros(N)
	x = δx/2:δx:δx*N
	
	t, T_all = evolve(diffusion, T_1, T_N, T_init, 100, D, δt, δx)
end

# ╔═╡ 40990790-52ae-11eb-1416-53249170acc7


# ╔═╡ 2fedc910-52ab-11eb-0f93-b7d316322e67
@bind i Slider(1:10:length(T_all), show_value=true)

# ╔═╡ 32aacd90-52a8-11eb-09c1-d396682422a6
with_pyplot() do

	plot(T_all[i])
	ylim([-1, 1])
	
end

# ╔═╡ Cell order:
# ╠═328c490e-52a8-11eb-045a-bb9c8e209387
# ╠═f21e3d62-52ad-11eb-2c95-496437dbd7a8
# ╠═275928b0-52a8-11eb-1368-39e9a3b2c90a
# ╠═31bc27d0-52a8-11eb-3f2d-fb955ba9bc4e
# ╠═36089e90-52a8-11eb-1309-a30a83726b7d
# ╠═32aacd90-52a8-11eb-09c1-d396682422a6
# ╠═40990790-52ae-11eb-1416-53249170acc7
# ╠═2fedc910-52ab-11eb-0f93-b7d316322e67
