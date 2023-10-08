using CrystallographyBase: MetricTensor
using LinearAlgebra: norm, dot

export angle, directionangle, interplanar_spacing

"""
    angle(𝐚::AbstractVector, g::MetricTensor, 𝐛::AbstractVector)

Get the angle between two directions.
"""
angle(𝐚, g::MetricTensor, 𝐛) = dot(𝐚, g, 𝐛) / (norm(𝐚, g) * norm(𝐛, g))

"""
    directionangle(𝐚::AbstractVector, g::MetricTensor, 𝐛::AbstractVector)

Get the direction angle of two vectors and a `MetricTensor`.
"""
directionangle(𝐚::AbstractVector, g::MetricTensor, 𝐛::AbstractVector) =
    acosd(angle(𝐚, g, 𝐛))

"""
    interplanar_spacing(𝐚::AbstractVector, g::MetricTensor)

Get the interplanar spacing from a `MetricTensor`.
"""
interplanar_spacing(𝐚::AbstractVector, g::MetricTensor) = inv(norm(𝐚, g))
