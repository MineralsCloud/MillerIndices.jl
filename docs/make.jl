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
    ],
)

deploydocs(;
    repo="github.com/MineralsCloud/MillerIndices.jl",
    devbranch="main",
)
