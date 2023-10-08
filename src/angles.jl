using CrystallographyBase: MetricTensor
using LinearAlgebra: dot

import CrystallographyBase: lengthof

export angle, interplanar_spacing

"""
    angle(𝐚::AbstractVector, g::MetricTensor, 𝐛::AbstractVector)

Get the angle (in degrees) between two directions.
"""
angle(𝐱, 𝐲, g::MetricTensor) = acosd(dot(𝐱, g, 𝐲) / lengthof(𝐱, g) / lengthof(𝐲, g))

"""
    interplanar_spacing(𝐚::AbstractVector, g::MetricTensor)

Get the interplanar spacing from a `MetricTensor`.
"""
interplanar_spacing(𝐱::Union{ReciprocalMiller,ReciprocalMillerBravais}, g::MetricTensor) =
    inv(lengthof(𝐱, g))

lengthof(𝐱::AbstractMiller, g::MetricTensor) = sqrt(dot(𝐱, g, 𝐱))
function lengthof(𝐱::AbstractMillerBravais, g::MetricTensor)
    𝐱′ = convert(𝐱 isa MillerBravais ? Miller : ReciprocalMiller, 𝐱)
    return lengthof(𝐱′, g)
end
