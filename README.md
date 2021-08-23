# EmailScraper.jl

![GitHub](https://img.shields.io/github/license/LabCidades/email-scraper)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)

A general-purpose email scrapper with multithread capabilities that crawles domains to extract email addresses from the domain's websites.

## Usage

`EmailScraper.jl` exports only one function:

```
scrape_emails(url; depth=3, follow_external=false)
```

## Notes

1.  RegEx to clean url:

    ```
    http[s]?:\/\/(?:[w]{3}\.)?(.*)(?<!\/)
    ```

2. RegEx for Email:

    ```
    ([a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+)
    ```
