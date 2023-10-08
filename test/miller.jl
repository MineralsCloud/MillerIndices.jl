@testset "Test `Indices` constructors" begin
    @test Miller([-1, 0, 1]) == Miller(-1, 0, 1)
    @test ReciprocalMiller(-1, 0, 1) == ReciprocalMiller([-1, 0, 1])
    @test MillerBravais([-2, 1, 1, 3]) == MillerBravais([-2, 1, 1, 3])
    @test ReciprocalMillerBravais([-2, 1, 1, 3]) == ReciprocalMillerBravais([-2, 1, 1, 3])
end

@testset "Test `@m_str` & `@mb_str`" begin
    @test m"[-1, 0, 1]" == Miller([-1, 0, 1])
    @test m"<2, -1, -1, 3>" == MillerBravais([2, -1, -1, 3])
    @test m"[  2,-1, -1,3  ]" == MillerBravais([2, -1, -1, 3])
    @test m"(-1, 0, 1  )" == ReciprocalMiller([-1, 0, 1])
    @test m"{  -1,0, 1}" == ReciprocalMiller([-1, 0, 1])
    @test m"(1, 0, -1, 0)" == ReciprocalMillerBravais(1, 0, -1, 0)
    @test m"{  1,0, -1, 0}" == ReciprocalMillerBravais(1, 0, -1, 0)
end

@testset "Test conversion between real `Miller` and `MillerBravais`" begin
    millerreal = [[1, 1, 1], [-1, 0, 1], [0, -1, 1], [-1, -1, 1], [1, 0, 1], [0, 1, 1]]
    millerbravaisreal = [
        [1, 1, -2, 3],
        [-2, 1, 1, 3],
        [1, -2, 1, 3],
        [-1, -1, 2, 3],
        [2, -1, -1, 3],
        [-1, 2, -1, 3],
    ]
    for (x, y) in zip(millerreal, millerbravaisreal)
        m = Miller(x)
        mb = MillerBravais(y)
        @test convert(MillerBravais, m) == mb
        @test convert(Miller, mb) == m
        @test convert(Miller, m) == m
        @test convert(MillerBravais, mb) == mb
        @test_throws MethodError convert(ReciprocalMiller, m)
        @test_throws MethodError convert(ReciprocalMillerBravais, mb)
        @test_throws MethodError convert(ReciprocalMillerBravais, m)
        @test_throws MethodError convert(ReciprocalMiller, mb)
    end
end

@testset "Test conversion between reciprocal `Miller` and `MillerBravais`" begin
    millerreciprocal = [
        [1, 0, 0], [0, 1, 0], [1, -1, 0], [-1, 0, 0], [0, -1, 0], [-1, 1, 0]
    ]
    millerbravaisreciprocal = [
        [1, 0, -1, 0],
        [0, 1, -1, 0],
        [1, -1, 0, 0],
        [-1, 0, 1, 0],
        [0, -1, 1, 0],
        [-1, 1, 0, 0],
    ]
    for (x, y) in zip(millerreciprocal, millerbravaisreciprocal)
        m = ReciprocalMiller(x)
        mb = ReciprocalMillerBravais(y)
        @test convert(ReciprocalMillerBravais, m) == mb
        @test convert(ReciprocalMiller, mb) == m
        @test convert(ReciprocalMiller, m) == m
        @test convert(ReciprocalMillerBravais, mb) == mb
        @test_throws MethodError convert(Miller, m)
        @test_throws MethodError convert(MillerBravais, mb)
        @test_throws MethodError convert(MillerBravais, m)
        @test_throws MethodError convert(Miller, mb)
    end
end

# From https://ssd.phys.strath.ac.uk/wp-content/uploads/Crystallographic_maths.pdf
@testset "Test conversion between reciprocal `Miller` and `MillerBravais`" begin
    millerreciprocal = [
        [1, 1, 0], [1, -2, 0], [-2, 1, 0], [-1, -1, 0], [-1, 2, 0], [2, -1, 0]
    ]
    millerbravaisreciprocal = [
        [1, 1, -2, 0],
        [1, -2, 1, 0],
        [-2, 1, 1, 0],
        [-1, -1, 2, 0],
        [-1, 2, -1, 0],
        [2, -1, -1, 0],
    ]
    for (x, y) in zip(millerreciprocal, millerbravaisreciprocal)
        m = ReciprocalMiller(x)
        mb = ReciprocalMillerBravais(y)
        @test convert(ReciprocalMillerBravais, m) == mb
        @test convert(ReciprocalMiller, mb) == m
        @test convert(ReciprocalMiller, m) == m
        @test convert(ReciprocalMillerBravais, mb) == mb
        @test_throws MethodError convert(Miller, m)
        @test_throws MethodError convert(MillerBravais, mb)
        @test_throws MethodError convert(MillerBravais, m)
        @test_throws MethodError convert(Miller, mb)
    end
end
@test convert(MillerBravais, Miller([1, 0, 0])) == MillerBravais([2, -1, -1, 0])

@testset "Test `familyof`" begin
    @testset "Test 1" begin
        m = Miller(-1, 0, 1)
        @test Set(familyof(m)) == Set(
            Miller.([[1, 1, 1], [-1, 0, 1], [0, -1, 1], [-1, -1, 1], [1, 0, 1], [0, 1, 1]])
        )
        mb = MillerBravais(-1, -1, 2, 3)
        @test Set(familyof(mb)) == Set(
            MillerBravais.([
                [1, 1, -2, 3],
                [-2, 1, 1, 3],
                [1, -2, 1, 3],
                [-1, -1, 2, 3],
                [2, -1, -1, 3],
                [-1, 2, -1, 3],
            ]),
        )
    end
    @testset "Test 2" begin
        m = ReciprocalMiller(0, 1, 0)
        @test Set(familyof(m)) == Set(
            ReciprocalMiller.([
                [1, 0, 0], [0, 1, 0], [1, -1, 0], [-1, 0, 0], [0, -1, 0], [-1, 1, 0]
            ]),
        )
        mb = ReciprocalMillerBravais(0, -1, 1, 0)
        @test Set(familyof(mb)) == Set(
            ReciprocalMillerBravais.([
                [1, 0, -1, 0],
                [0, 1, -1, 0],
                [1, -1, 0, 0],
                [-1, 0, 1, 0],
                [0, -1, 1, 0],
                [-1, 1, 0, 0],
            ]),
        )
    end
    @testset "Test 3" begin
        m = ReciprocalMiller(1, 1, 0)
        @test Set(familyof(m)) == Set(
            ReciprocalMiller.([
                [1, 1, 0], [1, -2, 0], [-2, 1, 0], [-1, -1, 0], [-1, 2, 0], [2, -1, 0]
            ]),
        )
        mb = ReciprocalMillerBravais(-2, 1, 1, 0)
        @test Set(familyof(mb)) == Set(
            ReciprocalMillerBravais.([
                [1, 1, -2, 0],
                [1, -2, 1, 0],
                [-2, 1, 1, 0],
                [-1, -1, 2, 0],
                [-1, 2, -1, 0],
                [2, -1, -1, 0],
            ]),
        )
    end
end
