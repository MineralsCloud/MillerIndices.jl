@testset "Test direction cosine in a tetragonal lattice" begin
    g = MetricTensor(2, 2, 3, 90, 90, 90)  # Primitive tetragonal
    @test g == MetricTensor(Lattice(diagm([2, 2, 3])))
    @test g == MetricTensor([2, 0, 0], [0, 2, 0], [0, 0, 3])
    a = [1, 2, 1]
    b = [0, 0, 1]
    @test directioncosine(a, g, b)^2 ≈ 9 / 29
end

# From https://ssd.phys.strath.ac.uk/wp-content/uploads/Crystallographic_maths.pdf
@testset "Find angle θ between [100] and [111] directions in GaN" begin
    a, c = 3.19u"angstrom", 5.19u"angstrom"
    g = MetricTensor(a, a, c, 90, 90, 120)
    @test directioncosine([1, 0, 0], g, [1, 1, 1]) == a / 2 / sqrt(a^2 + c^2)
end
