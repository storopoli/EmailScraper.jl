function obfuscated_email(str::String)
    # .(AT|at|ETA|\[AT\]|\[at\]|\[eta\]). // replace for @
    # .(DOT|dot|\[DOT\]|\[dot\]).   // replace for .
    return nothing
end

function extract_email(str::String)
    # this might be better
    # eachmatch_string(regex, str) = (String(i.match) for i in eachmatch(regex, str))
    return String.(SubString.(str, findall(r"([a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+)", str)))
end

function valid_email(str::String)
    return true
end

# I don't think I need this function anymore
function find_emails(body::HTMLElement)::Vector{Union{String,Missing}}
    emails = Vector{Union{String,Missing}}()
    elements_p = eachmatch(Selector("p:matches([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6})"), body)
    elements_a = eachmatch(Selector("a[href^=\"mailto:\"]"), body)
    if length(elements_p) > 0
        emails_p = vmapreduce(elem -> extract_email!(nodeText(elem)), vcat, elements_p)
        emails = vcat(emails, emails_p)
        vfilter!(x -> x isa String, emails)
    end
    if length(elements_a) > 0
        emails_a = vmapreduce(elem -> extract_email!(getattr(elem, "href")), vcat, elements_a)
        emails = vcat(emails, emails_a)
        vfilter!(x -> x isa String, emails)
    end
    return emails
end
