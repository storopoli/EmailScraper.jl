module EmailScraper

using HTTP

"""
    scrape_domain(x)

Returns yada yada.
"""
function scrape_domain(domain::String)
    body = request_body(domain)
    links = get_links(body, domain)
    emails = find_emails(body)
    bodies = vmap(request_body, links)
    return emails
end

export scrape_domain

end # module
