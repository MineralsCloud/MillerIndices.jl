using CrystallographyBase: Lattice, MetricTensor
using LinearAlgebra: diagm
using Unitful: @u_str

# From Katayun Barmak's lecture notes
@testset "Test the angle between [1 2 1] and [0 0 1] directions in a tetragonal system" begin
    g = MetricTensor(2, 2, 3, 90, 90, 90)  # Primitive tetragonal
    @test g == MetricTensor(Lattice(diagm([2, 2, 3])))
    @test g == MetricTensor([2, 0, 0], [0, 2, 0], [0, 0, 3])
    a = Miller(1, 2, 1)
    b = Miller(0, 0, 1)
    θ = anglebtw(a, b, g)
    @test θ ≈ 56.14548518737948
    @test cosd(θ) ≈ sqrt(9 / 29)
end

# From https://ssd.phys.strath.ac.uk/wp-content/uploads/Crystallographic_maths.pdf
@testset "Test the angle between [1 0 0] and [1 1 1] directions in GaN" begin
    a, c = 3.19u"angstrom", 5.19u"angstrom"
    g = MetricTensor(a, a, c, 90, 90, 120)
    θ = anglebtw(Miller(1, 0, 0), Miller(1, 1, 1), g)
    @test θ ≈ 74.82193526845971
    @test cosd(θ) ≈ a / 2 / sqrt(a^2 + c^2)
end

# From Katayun Barmak's lecture notes
@testset "Test the length of the reciprocal lattice vector and the interplanar spacing" begin
    g = inv(MetricTensor(2, 4, 3, 90, 45, 90))  # Monoclinic
    l₁₀₂ = lengthof(ReciprocalMiller(1, 0, 2), g)  # The length of the reciprocal lattice vector 𝐛₁₀₂
    @test l₁₀₂ ≈ 0.6678920925619838
    @test interplanar_spacing(ReciprocalMiller(1, 0, 2), g) ≈ 1.4972478505683084
end

# From Katayun Barmak's lecture notes
@testset "Test angle between two plane normals" begin
    g = inv(MetricTensor(4, 6, 5, 90, 135, 90))  # Monoclinic
    𝐱 = ReciprocalMiller(1, 0, 1)
    𝐲 = ReciprocalMiller(-2, 0, 1)
    @test anglebtw(𝐱, 𝐲, g) ≈ 41.38888526317379
end
