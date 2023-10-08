using Combinatorics: permutations
using StaticArrays: SVector

export Miller, MillerBravais, ReciprocalMiller, ReciprocalMillerBravais
export familyof, @m_str

"Represent the Miller indices or Miller–Bravais indices."
abstract type Indices <: AbstractVector{Int64} end
abstract type AbstractMiller <: Indices end
"""
    Miller(i, j, k)

Represent the Miller indices in the real space (crystal directions).
"""
struct Miller <: AbstractMiller
    data::SVector{3,Int64}
    Miller(data) = new(iszero(data) ? data : data .÷ gcd(data))
end
Miller(i, j, k) = Miller(Base.vect(i, j, k))
"""
    ReciprocalMiller(i, j, k)

Represent the Miller indices in the reciprocal space (planes).
"""
struct ReciprocalMiller <: AbstractMiller
    data::SVector{3,Int64}
    ReciprocalMiller(data) = new(iszero(data) ? data : data .÷ gcd(data))
end
ReciprocalMiller(i, j, k) = ReciprocalMiller(Base.vect(i, j, k))
abstract type AbstractMillerBravais <: Indices end
"""
    MillerBravais(i, j, k, l)

Represent the Miller–Bravais indices in the real space (crystal directions).
"""
struct MillerBravais <: AbstractMillerBravais
    data::SVector{4,Int64}
    function MillerBravais(data)
        @assert data[3] == -data[1] - data[2] "the 3rd index of `MillerBravais` should equal to the negation of the first two!"
        return new(iszero(data) ? data : data .÷ gcd(data))
    end
end
MillerBravais(i, j, k, l) = MillerBravais(Base.vect(i, j, k, l))
"""
    ReciprocalMillerBravais(i, j, k, l)

Represent the Miller–Bravais indices in the reciprocal space (planes).
"""
struct ReciprocalMillerBravais <: AbstractMillerBravais
    data::SVector{4,Int64}
    function ReciprocalMillerBravais(data)
        @assert data[3] == -data[1] - data[2] "the 3rd index of `MillerBravais` should equal to the negation of the first two!"
        return new(iszero(data) ? data : data .÷ gcd(data))
    end
end
ReciprocalMillerBravais(i, j, k, l) = ReciprocalMillerBravais(Base.vect(i, j, k, l))

const REGEX = r"([({[<])\s*([-+]?[0-9]+)[\s,]+([-+]?[0-9]+)[\s,]+([-+]?[0-9]+)?[\s,]+([-+]?[0-9]+)[\s,]*([>\]})])"

# This is a helper function and should not be exported!
function _m_str(s::AbstractString)
    matched = match(REGEX, strip(s))
    if matched === nothing
        throw(ArgumentError("not a valid expression!"))
    else
        brackets = first(matched.captures) * last(matched.captures)
        indices = map(filter(!isnothing, matched.captures[2:(end - 1)])) do index
            parse(Int64, index)
        end
        if brackets in ("()", "{}")
            if matched[4] === nothing
                return ReciprocalMiller(indices...)
            else
                return ReciprocalMillerBravais(indices...)
            end
        elseif brackets ∈ ("[]", "<>")
            if matched[4] === nothing
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
    familyof(x::Union{Miller,MillerBravais,ReciprocalMiller,ReciprocalMillerBravais})

List the all the directions/planes that are equivalent to `x` by symmetry.
"""
function familyof(mb::AbstractMillerBravais)
    perm = collect(permutations(mb[1:3]))  # Permute the first 3 indices for equivalent basis vectors
    negate = map(-, perm)  # Use negative indices
    pool = unique(append!(perm, negate))
    allowed = filter(_predicate, pool)
    return map(allowed) do x
        typeof(mb)(x..., mb[4])  # Add the 4th index back
    end
end
function familyof(m::AbstractMiller)
    mb = convert(m isa Miller ? MillerBravais : ReciprocalMillerBravais, m)  # Real or reciprocal space
    mbs = familyof(mb)
    return map(typeof(m), mbs)
end
_predicate(x) = x[3] == -x[1] - x[2]

Base.parent(x::Indices) = x.data

Base.size(::AbstractMiller) = (3,)
Base.size(::AbstractMillerBravais) = (4,)

Base.IndexStyle(::Type{<:Indices}) = IndexLinear()

Base.getindex(x::Indices, i::Int) = getindex(x.data, i)

Miller(x::MillerBravais) = Miller(2x[1] + x[2], 2x[2] + x[1], x[4])

ReciprocalMiller(x::ReciprocalMillerBravais) = ReciprocalMiller(x[1], x[2], x[4])

MillerBravais(x::Miller) = MillerBravais(2x[1] - x[2], 2x[2] - x[1], -x[1] - x[2], 3x[3])

ReciprocalMillerBravais(x::ReciprocalMiller) =
    ReciprocalMillerBravais(x[1], x[2], -x[1] - x[2], x[3])

# See https://docs.julialang.org/en/v1/manual/conversion-and-promotion/#Defining-New-Conversions
Base.convert(::Type{T}, x::T) where {T<:Indices} = x
Base.convert(::Type{Miller}, x::MillerBravais) = Miller(x)
Base.convert(::Type{ReciprocalMiller}, x::ReciprocalMillerBravais) = ReciprocalMiller(x)
Base.convert(::Type{MillerBravais}, x::Miller) = MillerBravais(x)
Base.convert(::Type{ReciprocalMillerBravais}, x::ReciprocalMiller) =
    ReciprocalMillerBravais(x)

Base.show(io::IO, x::Union{Miller,MillerBravais}) = print(io, '<', join(x.data, " "), '>')
Base.show(io::IO, x::Union{ReciprocalMiller,ReciprocalMillerBravais}) =
    print(io, '{', join(x.data, " "), '}')
