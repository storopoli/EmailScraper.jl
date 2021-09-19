function extract_emails(str::String)
    # this might be better
    # eachmatch_string(regex, str) = (String(i.match) for i in eachmatch(regex, str))
    return unique(
        String.(
            SubString.(
                str, findall(r"([a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+)", str)
            ),
        ),
    )
end

function valid_email(str::String)
    ending = String(last(split(str, '.')))
    if str == ""
        return false
    elseif length(split(str, '.')) < 2
        return false
    elseif !(ending in TLDs)
        return false
    else
        return true
    end
end

function find_emails(body::HTMLElement)::Vector{String}
    emails = Vector{Union{String,Missing}}()
    elements_p = eachmatch(
        Selector("p:matches([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6})"), body
    )
    elements_a = eachmatch(Selector("a[href^=\"mailto:\"]"), body)
    if length(elements_p) > 0
        emails_p = mapreduce(elem -> extract_emails(nodeText(elem)), vcat, elements_p)
        emails = vcat(emails, emails_p)
        filter!(x -> x isa String, emails)
    end
    if length(elements_a) > 0
        emails_a = mapreduce(
            elem -> extract_emails(getattr(elem, "href")), vcat, elements_a
        )
        emails = vcat(emails, emails_a)
        filter!(x -> x isa String, emails)
    end
    return unique(skipmissing(emails))
end
