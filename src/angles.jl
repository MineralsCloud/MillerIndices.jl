using CrystallographyBase: MetricTensor
using LinearAlgebra: norm, dot

import CrystallographyBase: lengthof

export angle, interplanar_spacing

"""
    angle(𝐚::AbstractVector, g::MetricTensor, 𝐛::AbstractVector)

Get the angle (in degrees) between two directions.
"""
angle(𝐚, g::MetricTensor, 𝐛) = acosd(dot(𝐚, g, 𝐛) / (norm(𝐚, g) * norm(𝐛, g)))

"""
    interplanar_spacing(𝐚::AbstractVector, g::MetricTensor)

Get the interplanar spacing from a `MetricTensor`.
"""
interplanar_spacing(𝐚::AbstractVector, g::MetricTensor) = inv(norm(𝐚, g))

lengthof(𝐱::AbstractMiller, g::MetricTensor) = sqrt(dot(𝐱, g, 𝐱))
function lengthof(𝐱::AbstractMillerBravais, g::MetricTensor)
    𝐱′ = convert(𝐱 isa MillerBravais ? Miller : ReciprocalMiller, 𝐱)
    return lengthof(𝐱′, g)
end
