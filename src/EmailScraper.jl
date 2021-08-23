module EmailScraper

using Cascadia
using Gumbo
using HTTP

include("TLDs.jl")
include("domain.jl")
include("email.jl")

"""
    scrape_url(url::String)

Scrapes a `url` and returns all email adresses found in links and in text.

# Arguments
- `url::String`: the desired url to scrape.

# Examples
```julia-repl
julia> scrape_url("julialang.org/about/help/")
2-element Vector{String}:
 "contact@julialang.org"
 "logan@julialang.org"
```
"""
function scrape_url(url::String)
    body = request_body(url)
    links = get_links(body)
    emails = find_emails(body)
    return emails
end

export scrape_url

end # module
