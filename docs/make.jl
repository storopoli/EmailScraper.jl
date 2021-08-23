using Documenter, EmailScraper

makedocs(
    sitename="EmailScraper.jl",
    authors = "Jose Storopoli",
    modules=[EmailScraper],
    pages=[
    "Home" =>"index.md",
    ],
)

deploydocs(
    repo = "github.com/storopoli/EmailScraper.jl.git",
    target = "build",
    devbranch = "main"
)
