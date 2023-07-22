
"""
This file includes common interfaces and wrappers to integration routines
that are used in the package.

The centralisation of these routines should simplify replacing and fine-
tuning integration routines.
"""

"""
    _intersect_interval(s::ModelTime, t::ModelTime, grid::AbstractVector)

calculate the effective integration grid.
"""
function _intersect_interval(s::ModelTime, t::ModelTime, grid::AbstractVector)
    g = union([s, t], grid)
    sort!(g)
    g = g[ g .≥ s ]
    g = g[ g .≤ t ]
    if length(g) == 1
        g = [ g[1], g[1] ]
    end
    return g
end


"""
    _scalar_integral(f::Function, s::ModelTime, t::ModelTime)

Calculate the integral for a scalar function f in the range [s,t].
"""
function _scalar_integral(f::Function, s::ModelTime, t::ModelTime, grid::Union{AbstractVector, Nothing} = nothing)
    if isnothing(grid)
        return quadgk(f, s, t)[1]
    end
    grid = _intersect_interval(s, t, grid)
    return sum([
        quadgk(f, l, u)[1]
        for (l, u) in zip(grid[1:end-1], grid[2:end])
    ])
end

"""
    _vector_integral(f::Function, s::ModelTime, t::ModelTime)

Calculate the integral for a vector-valued function f in the range [s,t].
"""
function _vector_integral(f::Function, s::ModelTime, t::ModelTime, grid::Union{AbstractVector, Nothing} = nothing)
    if isnothing(grid)
        return quadgk(f, s, t)[1]
    end
    grid = _intersect_interval(s, t, grid)
    return sum([
        quadgk(f, l, u)[1]
        for (l, u) in zip(grid[1:end-1], grid[2:end])
    ])
end
