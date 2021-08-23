function request_body(domain::String)
    headers = ["User-Agent" => "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"]
    url = startswith("http", domain) ? domain : "http://" * domain
    try
        r = HTTP.get(url, headers)
        r_parsed = parsehtml(String(r.body))
        return r_parsed.root[2] # <body>
    catch e
        # Throw an Error
        println("HTTP Get Error!")
    end
end

function valid_links!(link::String)
    # Make this a function that acts on a collection with @inbounds
    # and mutating stuff

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

function get_links(body::HTMLElement, domain::String)::Vector{String}
    # This function should get a String, then extract all links as a Vector/Set
    # and parse with valid_links!
    elements = eachmatch(Selector("a"), body)
    links = mapreduce(elem -> valid_links!(getattr(elem, "href")), vcat, elements)
    vfilter!(x -> x isa String && occursin(domain, x), links)
    return links
end
