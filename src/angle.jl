using CrystallographyBase: MetricTensor
using LinearAlgebra: dot

import CrystallographyBase: lengthof

export anglebtw, interplanar_spacing

"""
    anglebtw(𝐱, 𝐲, g::MetricTensor)

Calculate the angle (in degrees) between two directions by:

```math
\\cos\\theta = \\frac{\\mathbf{x} \\cdot \\mathbf{y}}{\\lvert\\mathbf{x}\\rvert \\lvert\\mathbf{y}\\rvert}
             = \\frac{\\sum_{ij} x_i g_{ij} y_j}{\\sqrt{\\sum_{ij} x_i g_{ij} x_j} \\sqrt{\\sum_{ij} y_i g_{ij} y_j}}.
```
"""
anglebtw(𝐱::Miller, 𝐲::Miller, g::MetricTensor) =
    acosd(dot(𝐱, g, 𝐲) / lengthof(𝐱, g) / lengthof(𝐲, g))
anglebtw(𝐱::ReciprocalMiller, 𝐲::ReciprocalMiller, g::MetricTensor) =
    180 - acosd(dot(𝐱, g, 𝐲) / lengthof(𝐱, g) / lengthof(𝐲, g))
anglebtw(𝐱::MillerBravais, 𝐲::MillerBravais, g::MetricTensor) =
    anglebtw(convert(Miller, 𝐱), convert(Miller, 𝐲), g)
anglebtw(𝐱::ReciprocalMillerBravais, 𝐲::ReciprocalMillerBravais, g::MetricTensor) =
    anglebtw(convert(ReciprocalMiller, 𝐱), convert(ReciprocalMiller, 𝐲), g)

"""
    interplanar_spacing(𝐱::Union{ReciprocalMiller,ReciprocalMillerBravais}, g::MetricTensor)

Calculate the interplanar spacing by:

```math
d_{h\\ k \\ l} = \\frac{1}{\\lvert \\mathbf{x}_{h\\ k \\ l}\\rvert}.
```
"""
interplanar_spacing(𝐱::Union{ReciprocalMiller,ReciprocalMillerBravais}, g::MetricTensor) =
    inv(lengthof(𝐱, g))

"""
    lengthof(𝐱::Union{AbstractMiller,AbstractMillerBravais}, g::MetricTensor)

Calculate the magnitude of a given indices with respect to a specified metric tensor.
"""
lengthof(𝐱::AbstractMiller, g::MetricTensor) = sqrt(dot(𝐱, g, 𝐱))
function lengthof(𝐱::AbstractMillerBravais, g::MetricTensor)
    𝐱′ = convert(𝐱 isa MillerBravais ? Miller : ReciprocalMiller, 𝐱)
    return lengthof(𝐱′, g)
end
