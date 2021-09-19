function request_body(url::String)
    headers = [
        "User-Agent" => "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36",
    ]
    url = replace(url, "https://" => "http://")
    url = startswith("http://", url) ? url : "http://" * url
    try
        r = HTTP.get(url, headers)
        r_parsed = parsehtml(String(r.body))
        return r_parsed.root[2] # <body>
    catch e
        return HTMLElement(:body) # empty <body>
    end
end

function valid_link(link::String)
    # Make this a function that acts on a collection with @inbounds
    # and mutating stuff

    # RegExps
    ignore_extensions = r"""
        \.txt|\.doc|\.docx|\.docm|\.odt|\.pdf|\.rtf|\.csv|\.xls|\.xlsx|\.xlsm|\.ods|\.pps|\.ppt|\.pptx|\.ppsm|\.pptm|\.potx|\.odp|
        \.mp3|\.wma|\.wav|\.flac|\.midi|\.ogg|\.avi|\.divx|\.mov|\.jpeg|\.jpg|\.png|\.bmp|\.ico|\.svg|\.webp|\.gif|
        \.psd|\.heic|\.nef|\.crw|\.ai|\.id|\.exe|\.bat|\.ps1|\.dll|\.msi|\.sys|\.ttf|\.tif|\.otf|\.ini|\.src|\.inf|
        \.bin|\.zip|\.arj|\.rar|\.7z|\.iso|\.img|\.css|\.html|\.js|\.eml|\.msg|\@\@search|
        \.mp4|\.m4v|\.mov|\.mkv|\.flv|\.vob|\.ogm|\.asf|\.wmv|\.mpg|\.mpeg|\.mp4|\.3gp|\.3g2|\.mxf|\.rm|\.rmvb|\.mts|\.m2ts|\.m2t
     """
    ignore_domains = r"facebook|twitter|instagram|youtube|pinterest|google"
    valid_links = r"http[s]?:\/\/(?:[w]{3}\.)?(.*)(?<!\/)"
    # valid_links = r"(https?|ftp)://(www\d?|[a-zA-Z0-9]+)?\.[a-zA-Z0-9-]+(\:|\.)([a-zA-Z0-9.]+|(\d+)?)([/?:].*)?"
    # valid_links = r"|<a.*(?=href=\"([^\"]*)\")[^>]*>([^<]*)</a>|i"
    if contains(link, valid_links) &&
       !contains(link, ignore_extensions) &&
       !contains(link, ignore_domains)
        return link
    else
        return missing
    end
end

function get_links(body::HTMLElement)::Vector{String}
    elements = eachmatch(Selector("a"), body)
    if isempty(elements)
        return Vector{String}()
    else
        links = mapreduce(elem -> valid_link(getattr(elem, "href")), vcat, elements)
        return unique(skipmissing(links))
    end
end
