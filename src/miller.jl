using Combinatorics: permutations
using StaticArrays: SVector

export Miller, MillerBravais, ReciprocalMiller, ReciprocalMillerBravais
export family, @m_str

"Represent the Miller indices or Miller–Bravais indices."
abstract type Indices <: AbstractVector{Int64} end
abstract type AbstractMiller <: Indices end
"""
    Miller(i, j, k)

Represent the Miller indices in the real space (crystal directions).
"""
struct Miller <: AbstractMiller
    data::SVector{3,Int64}
    Miller(v) = new(iszero(v) ? v : v .÷ gcd(v))
end
Miller(i, j, k) = Miller(Base.vect(i, j, k))
"""
    ReciprocalMiller(i, j, k)

Represent the Miller indices in the reciprocal space (planes).
"""
struct ReciprocalMiller <: AbstractMiller
    data::SVector{3,Int64}
    ReciprocalMiller(v) = new(iszero(v) ? v : v .÷ gcd(v))
end
ReciprocalMiller(i, j, k) = ReciprocalMiller(Base.vect(i, j, k))
abstract type AbstractMillerBravais <: Indices end
"""
    MillerBravais(i, j, k, l)

Represent the Miller–Bravais indices in the real space (crystal directions).
"""
struct MillerBravais <: AbstractMillerBravais
    data::SVector{4,Int64}
    function MillerBravais(v)
        @assert v[3] == -v[1] - v[2] "the 3rd index of `MillerBravais` should equal to the negation of the first two!"
        return new(iszero(v) ? v : v .÷ gcd(v))
    end
end
MillerBravais(i, j, k, l) = MillerBravais(Base.vect(i, j, k, l))
"""
    ReciprocalMillerBravais(i, j, k, l)

Represent the Miller–Bravais indices in the reciprocal space (planes).
"""
struct ReciprocalMillerBravais <: AbstractMillerBravais
    data::SVector{4,Int64}
    function ReciprocalMillerBravais(v)
        @assert v[3] == -v[1] - v[2] "the 3rd index of `MillerBravais` should equal to the negation of the first two!"
        return new(iszero(v) ? v : v .÷ gcd(v))
    end
end
ReciprocalMillerBravais(i, j, k, l) = ReciprocalMillerBravais(Base.vect(i, j, k, l))

const REGEX = r"([({[<])\s*([-+]?[0-9]+)[\s,]+([-+]?[0-9]+)[\s,]+([-+]?[0-9]+)?[\s,]+([-+]?[0-9]+)[\s,]*([>\]})])"

# This is a helper function and should not be exported!
function _m_str(s::AbstractString)
    m = match(REGEX, strip(s))
    if m === nothing
        throw(ArgumentError("not a valid expression!"))
    else
        brackets = first(m.captures) * last(m.captures)
        indices = map(filter(x -> x !== nothing, m.captures[2:(end - 1)])) do index
            parse(Int64, index)
        end
        if brackets in ("()", "{}")
            if m[4] === nothing
                return ReciprocalMiller(indices...)
            else
                return ReciprocalMillerBravais(indices...)
            end
        elseif brackets ∈ ("[]", "<>")
            if m[4] === nothing
                return Miller(indices...)
            else
                return MillerBravais(indices...)
            end
        else
            @assert false "this should never happen!"
        end
    end
end

"""
    m_str(s)

Generate the Miller indices or Miller–Bravais indices quickly.

# Examples
```jldoctest
julia> m"[-1, 0, 1]"
3-element Miller:
 -1
  0
  1

julia> m"<2, -1, -1, 3>"
4-element MillerBravais:
  2
 -1
 -1
  3

julia> m"(-1, 0, 1)"
3-element ReciprocalMiller:
 -1
  0
  1

julia> m"(1, 0, -1, 0)"
4-element ReciprocalMillerBravais:
  1
  0
 -1
  0
```
"""
macro m_str(s)  # See https://github.com/JuliaLang/julia/blob/v1.9.3/base/regex.jl#L112
    return _m_str(s)
end

"""
    family(x::Union{Miller,MillerBravais,ReciprocalMiller,ReciprocalMillerBravais})

List the all the directions/planes that are equivalent to `x` by symmetry.
"""
function family(mb::AbstractMillerBravais)
    perm = collect(permutations(mb[1:3]))  # Permute the first 3 indices for equivalent basis vectors
    negate = map(-, perm)  # Use negative indices
    pool = unique(append!(perm, negate))
    allowed = filter(_predicate, pool)
    return map(allowed) do x
        typeof(mb)(x..., mb[4])  # Add the 4th index back
    end
end
function family(m::AbstractMiller)
    mb = convert(typeof(m) <: Miller ? MillerBravais : ReciprocalMillerBravais, m)  # Real or reciprocal space
    vec = family(mb)
    return map(Base.Fix1(convert, typeof(m)), vec)
end
_predicate(v) = v[3] == -v[1] - v[2]

Base.parent(x::Indices) = x.data

Base.size(::AbstractMiller) = (3,)
Base.size(::AbstractMillerBravais) = (4,)

Base.IndexStyle(::Type{<:Indices}) = IndexLinear()

Base.getindex(x::Indices, i::Int) = getindex(x.data, i)

Miller(mb::MillerBravais) = Miller(2 * mb[1] + mb[2], 2 * mb[2] + mb[1], mb[4])

ReciprocalMiller(mb::ReciprocalMillerBravais) = ReciprocalMiller(mb[1], mb[2], mb[4])

MillerBravais(m::Miller) =
    MillerBravais(2 * m[1] - m[2], 2 * m[2] - m[1], -(m[1] + m[2]), 3 * m[3])

ReciprocalMillerBravais(m::ReciprocalMiller) =
    ReciprocalMillerBravais(m[1], m[2], -(m[1] + m[2]), m[3])

# See https://docs.julialang.org/en/v1/manual/conversion-and-promotion/#Defining-New-Conversions
Base.convert(::Type{T}, x::T) where {T<:Indices} = x
Base.convert(::Type{Miller}, mb::MillerBravais) = Miller(mb)
Base.convert(::Type{ReciprocalMiller}, mb::ReciprocalMillerBravais) = ReciprocalMiller(mb)
Base.convert(::Type{MillerBravais}, m::Miller) = MillerBravais(m)
Base.convert(::Type{ReciprocalMillerBravais}, m::ReciprocalMiller) =
    ReciprocalMillerBravais(m)

Base.show(io::IO, x::Union{Miller,MillerBravais}) = print(io, '<', join(x.data, " "), '>')
Base.show(io::IO, x::Union{ReciprocalMiller,ReciprocalMillerBravais}) =
    print(io, '{', join(x.data, " "), '}')
