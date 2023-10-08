using CrystallographyBase: MetricTensor
using LinearAlgebra: dot

import CrystallographyBase: lengthof

export anglebtw, interplanar_spacing, lengthof

"""
    anglebtw(x::Miller, y::Miller, g::MetricTensor)
    anglebtw(x::MillerBravais, y::MillerBravais, g::MetricTensor)
    anglebtw(x::ReciprocalMiller, y::ReciprocalMiller, g::MetricTensor)
    anglebtw(x::ReciprocalMillerBravais, y::ReciprocalMillerBravais, g::MetricTensor)

Calculate the angle (in degrees) between two directions by:

```math
\\cos\\theta = \\frac{\\mathbf{x} \\cdot \\mathbf{y}}{\\lvert\\mathbf{x}\\rvert \\lvert\\mathbf{y}\\rvert}
             = \\frac{\\sum_{ij} x_i g_{ij} y_j}{\\sqrt{\\sum_{ij} x_i g_{ij} x_j} \\sqrt{\\sum_{ij} y_i g_{ij} y_j}}.
```

!!! note
    For the angle between two plane normals, the result is ``180 - \\theta``.
"""
anglebtw(x::Miller, y::Miller, g::MetricTensor) =
    acosd(dot(x, g, y) / lengthof(x, g) / lengthof(y, g))
anglebtw(x::ReciprocalMiller, y::ReciprocalMiller, g::MetricTensor) =
    180 - acosd(dot(x, g, y) / lengthof(x, g) / lengthof(y, g))
anglebtw(x::MillerBravais, y::MillerBravais, g::MetricTensor) =
    anglebtw(convert(Miller, x), convert(Miller, y), g)
anglebtw(x::ReciprocalMillerBravais, y::ReciprocalMillerBravais, g::MetricTensor) =
    anglebtw(convert(ReciprocalMiller, x), convert(ReciprocalMiller, y), g)

"""
    interplanar_spacing(x::Union{ReciprocalMiller,ReciprocalMillerBravais}, g::MetricTensor)

Calculate the interplanar spacing by:

```math
d_{h\\ k \\ l} = \\frac{1}{\\lvert \\mathbf{x}_{h\\ k \\ l}\\rvert}.
```
"""
interplanar_spacing(x::Union{ReciprocalMiller,ReciprocalMillerBravais}, g::MetricTensor) =
    inv(lengthof(x, g))

"""
    lengthof(x::Union{AbstractMiller,AbstractMillerBravais}, g::MetricTensor)

Calculate the magnitude of a given indices with respect to a specified metric tensor.
"""
lengthof(x::AbstractMiller, g::MetricTensor) = sqrt(dot(x, g, x))
function lengthof(x::AbstractMillerBravais, g::MetricTensor)
    x′ = convert(x isa MillerBravais ? Miller : ReciprocalMiller, x)
    return lengthof(x′, g)
end
