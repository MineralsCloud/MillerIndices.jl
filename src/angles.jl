using CrystallographyBase: MetricTensor
using LinearAlgebra: dot

import CrystallographyBase: lengthof

export angle, interplanar_spacing

"""
    angle(𝐱, 𝐲, g::MetricTensor)

Calculate the angle (in degrees) between two directions by:

```math
\\cos\\theta = \\frac{\\mathbf{x} \\cdot \\mathbf{y}}{\\lvert\\mathbf{x}\\rvert \\lvert\\mathbf{y}\\rvert}
             = \\frac{\\sum_{ij} x_i g_{ij} y_j}{\\sqrt{\\sum_{ij} x_i g_{ij} x_j} \\sqrt{\\sum_{ij} y_i g_{ij} y_j}}.
```
"""
angle(𝐱, 𝐲, g::MetricTensor) = acosd(dot(𝐱, g, 𝐲) / lengthof(𝐱, g) / lengthof(𝐲, g))

"""
    interplanar_spacing(𝐱::Union{ReciprocalMiller,ReciprocalMillerBravais}, g::MetricTensor)

Calculate the interplanar spacing by:

```math
d_{h\\ k \\ l} = \\frac{1}{\\lvert \\mathbf{x}_{h\\ k \\ l}\\rvert}.
```
"""
interplanar_spacing(𝐱::Union{ReciprocalMiller,ReciprocalMillerBravais}, g::MetricTensor) =
    inv(lengthof(𝐱, g))

lengthof(𝐱::AbstractMiller, g::MetricTensor) = sqrt(dot(𝐱, g, 𝐱))
function lengthof(𝐱::AbstractMillerBravais, g::MetricTensor)
    𝐱′ = convert(𝐱 isa MillerBravais ? Miller : ReciprocalMiller, 𝐱)
    return lengthof(𝐱′, g)
end
