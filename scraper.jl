using Core:Vector
using Cascadia
using Gumbo
using HTTP
using LoopVectorization


function request_body(domain::String)
    headers = ["User-Agent" => "Mozilla/5.0"]
    url = startswith("http", domain) ? domain : "http://" * domain
    try
        r = HTTP.get(url, headers)
        r_parsed = parsehtml(String(r.body))
        return r_parsed.root[2] # <body>
    catch e
        println("HTTP Get Error!")
    end
end

function valid_link!(link::String)
    # RegExps
    ignore_extensions = r"""
        \.txt|\.doc|\.docx|\.docm|\.odt|\.pdf|\.rtf|\.csv|\.xls|\.xlsx|\.xlsm|\.ods|\.pps|\.ppt|\.pptx|\.ppsm|\.pptm|\.potx|\.odp|
        \.mp3|\.wma|\.wav|\.flac|\.midi|\.ogg|\.avi|\.divx|\.mov|\.jpeg|\.jpg|\.png|\.bmp|\.ico|\.svg|\.webp|\.gif|
        \.psd|\.heic|\.nef|\.crw|\.ai|\.id|\.exe|\.bat|\.com|\.ps1|\.dll|\.msi|\.sys|\.ttf|\.tif|\.otf|\.ini|\.src|\.inf|
        \.bin|\.zip|\.arj|\.rar|\.7z|\.iso|\.img|\.css|\.html|\.js|\.eml|\.msg|@@search|
        \.mp4|\.m4v|\.mov|\.mkv|\.flv|\.vob|\.ogm|\.asf|\.wmv|\.mpg|\.mpeg|\.mp4|\.3gp|\.3g2|\.mxf|\.rm|\.rmvb|\.mts|\.m2ts|\.m2t
     """
    ignore_domains = r"facebook|twitter|instagram|youtube|pinterest|google"
    valid_links = r"http[s]?:\/\/(?:[w]{3}\.)?(.*)(?<!\/)"
    link = occursin(valid_links, link) &&
        !occursin(ignore_extensions, link) &&
        !occursin(ignore_domains, link) ?
        link :
        missing
end

function extract_email(str::String)
    # this might be better
    # eachmatch_string(regex, str) = (String(i.match) for i in eachmatch(regex, str))
    return String.(SubString.(str, findall(r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}", str)))
end

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

function get_links(body::HTMLElement, domain::String)::Vector{String}
    elements = eachmatch(Selector("a"), body)
    links = vmapreduce(elem -> valid_link!(getattr(elem, "href")), vcat, elements)
    vfilter!(x -> x isa String && occursin(domain, x), links)
    return links
end

function scrape_domain(domain::String)
    body = request_body(domain)
    links = get_links(body, domain)
    emails = find_emails(body)
    bodies = vmap(request_body, links)
    return emails
end
