using MillerIndices
using Documenter

DocMeta.setdocmeta!(MillerIndices, :DocTestSetup, :(using MillerIndices); recursive=true)

makedocs(;
    modules=[MillerIndices],
    authors="singularitti <singularitti@outlook.com> and contributors",
    repo="https://github.com/MineralsCloud/MillerIndices.jl/blob/{commit}{path}#{line}",
    sitename="MillerIndices.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://MineralsCloud.github.io/MillerIndices.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Manual" => [
            "Installation guide" => "installation.md",
        ],
        "Public API" => "public.md",
        "Developer Docs" => [
            "Contributing" => "developers/contributing.md",
            "Style Guide" => "developers/style.md",
        ],
        "Troubleshooting" => "troubleshooting.md",
    ],
)

deploydocs(;
    repo="github.com/MineralsCloud/MillerIndices.jl",
    devbranch="main",
)
