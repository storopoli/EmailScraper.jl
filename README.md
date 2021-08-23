# EmailScraper.jl

![GitHub](https://img.shields.io/github/license/LabCidades/email-scraper)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)

A general-purpose email scrapper to extract email addresses from urls.

## Usage

`EmailScraper.jl` exports only one function:

```
scrape_emails(url; depth=3)
```
