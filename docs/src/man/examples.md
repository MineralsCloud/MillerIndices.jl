# Examples

```@contents
Pages = ["examples.md"]
Depth = 2
```

## Representing Miller and Miller–Bravais indices

This section demonstrates how to create various indices using the package.

```@repl millerindices
using MillerIndices
Miller(1, 2, 3)  # Create Miller indices in real space
ReciprocalMiller(1, 2, 3)  # Create Miller indices in reciprocal space
MillerBravais(2, -1, -1, 3)  # Create Miller–Bravais indices in real space
ReciprocalMillerBravais(1, 0, -1, 0)  # Create Miller–Bravais indices in reciprocal space
```

## Generating indices from strings

Utilize the `m_str` macro to rapidly generate indices from a string format.

```@repl millerindices
m"[-1, 0, 1]"  # Generate Miller indices from a string
m"<2, -1, -1, 3>"  # Generate Miller–Bravais indices from a string
```

## Converting between Miller and Miller–Bravais indices

Switch between different index notations seamlessly.

```@repl millerindices
MillerBravais(Miller(-1, 0, 1))
Miller(MillerBravais(-2, 1, 1, 3))
```

## Finding equivalent directions/planes

Discover how to determine all directions/planes equivalent to a given index by symmetry.

```@repl millerindices
familyof(Miller(-1, 0, 1))
familyof(MillerBravais(-1, -1, 2, 3))
```

## Angle calculation

Determine the angle between two vectors using a metric tensor.

1. [Test the angle between ``[1 2 1]`` and ``[0 0 1]`` directions in gallium nitride](https://ssd.phys.strath.ac.uk/wp-content/uploads/Crystallographic_maths.pdf):

   ```@repl millerindices
   using CrystallographyBase, Unitful
   a, c = 3.19u"angstrom", 5.19u"angstrom"
   g = MetricTensor(a, a, c, 90, 90, 120)
   θ = anglebtw(Miller(1, 0, 0), Miller(1, 1, 1), g)
   ```

2. The length of the reciprocal lattice vector and the interplanar spacing:

   ```@repl millerindices
   g = inv(MetricTensor(2, 4, 3, 90, 45, 90))
   lengthof(ReciprocalMiller(1, 0, 2), g)
   interplanar_spacing(ReciprocalMiller(1, 0, 2), g)
   ```

3. Calculate the angle between two plane normals:

   ```@repl millerindices
   g = inv(MetricTensor(4, 6, 5, 90, 135, 90))  # Monoclinic
   𝐱 = ReciprocalMiller(1, 0, 1)
   𝐲 = ReciprocalMiller(-2, 0, 1)
   anglebtw(𝐱, 𝐲, g)
   ```
