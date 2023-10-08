# MillerIndices

Documentation for [MillerIndices](https://github.com/MineralsCloud/MillerIndices.jl).

`MillerIndices.jl` is a Julia package that provides a convenient way to handle Miller
indices and Miller–Bravais indices in crystallography.

See the [Index](@ref main-index) for the complete list of documented functions
and types.

The code, which is [hosted on GitHub](https://github.com/MineralsCloud/MillerIndices.jl), is tested
using various continuous integration services for its validity.

This repository is created and maintained by
[@singularitti](https://github.com/singularitti), and contributions are highly welcome.

## Package features

1. Representation of indices:

   - `Miller`: Represents the Miller indices in real space (crystal directions).
   - `ReciprocalMiller`: Represents the Miller indices in reciprocal space (planes).
   - `MillerBravais`: Represents the Miller–Bravais indices in real space (crystal directions).
   - `ReciprocalMillerBravais`: Represents the Miller–Bravais indices in reciprocal space (planes).

2. Macro for easy generation:

   ```julia
   m"[-1, 0, 1]"        # Miller
   m"<2, -1, -1, 3>"    # MillerBravais
   m"(-1, 0, 1)"        # ReciprocalMiller
   m"(1, 0, -1, 0)"     # ReciprocalMillerBravais
   ```

3. List equivalent directions/planes

4. Conversion between Miller and Miller-Bravais representations

5. Calculate angles between indices

6. Interplanar spacing calculation

## Installation

The package can be installed with the Julia package manager.
From [the Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/), type `]` to enter
the [Pkg mode](https://docs.julialang.org/en/v1/stdlib/REPL/#Pkg-mode) and run:

```julia-repl
pkg> add MillerIndices
```

Or, equivalently, via [`Pkg.jl`](https://pkgdocs.julialang.org/v1/):

```@repl
import Pkg; Pkg.add("MillerIndices")
```

## Documentation

- [**STABLE**](https://MineralsCloud.github.io/MillerIndices.jl/stable) — **documentation of the most recently tagged version.**
- [**DEV**](https://MineralsCloud.github.io/MillerIndices.jl/dev) — _documentation of the in-development version._

## Project status

The package is developed for and tested against Julia `v1.6` and above on Linux, macOS, and
Windows.

## Questions and contributions

You can post usage questions on
[our discussion page](https://github.com/MineralsCloud/MillerIndices.jl/discussions).

We welcome contributions, feature requests, and suggestions. If you encounter any problems,
please open an [issue](https://github.com/MineralsCloud/MillerIndices.jl/issues).
The [Contributing](@ref) page has
a few guidelines that should be followed when opening pull requests and contributing code.

## Manual outline

```@contents
Pages = [
    "man/installation.md",
    "man/examples.md",
    "man/troubleshooting.md",
    "developers/contributing.md",
    "developers/style-guide.md",
    "developers/design-principles.md",
]
Depth = 3
```

## Library outline

```@contents
Pages = ["lib/public.md", "lib/internals/abstract.md"]
```

### [Index](@id main-index)

```@index
Pages = ["lib/public.md"]
```
