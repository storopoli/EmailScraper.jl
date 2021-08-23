using EmailScraper
using Cascadia
using Gumbo
using HTTP
using Test

BODY = EmailScraper.request_body("storopoli.io")

@testset "EmailScraper" begin

    @testset "Domain" begin

        @testset "request_body" begin
            @test EmailScraper.request_body("storopoli.io") isa HTMLElement
            @test EmailScraper.request_body("string") |> text |> isempty
        end

        @testset "valid_links" begin
            @test EmailScraper.valid_link("https://julialang.org") == "https://julialang.org"
            @test EmailScraper.valid_link("https://julialang.org/temp.doc") isa Missing
            @test EmailScraper.valid_link("https://julialang.org/temp.docx") isa Missing
            @test EmailScraper.valid_link("https://julialang.org/temp.@@search") isa Missing
            @test EmailScraper.valid_link("https://facebook.com") isa Missing
            @test EmailScraper.valid_link("https://facebook.com") isa Missing
        end

        @testset "get_links" begin
            @test "https://github.com/storopoli" in EmailScraper.get_links(BODY)
            # if it returns true
        end

    end # Links

    @testset "Emails" begin


         @testset "extract_email" begin
            @test EmailScraper.extract_emails("LOREMIPUSM hello@hello.com LoReM Ipsum") == ["hello@hello.com"]
            @test EmailScraper.extract_emails("LOREMIPUSM hello@hello.com ### !! LoReM hello@hello.com Ipsum") == ["hello@hello.com"]
            @test EmailScraper.extract_emails("LOREMIPUSM hello@hello.com LoReM## !! @ hello2@hello.com Ipsum") == ["hello@hello.com", "hello2@hello.com"]
        end

        @testset "valid_email" begin
            @test EmailScraper.valid_email("hello@hello.com") == true
            @test EmailScraper.valid_email("hello@hello.com.br") == true
            @test EmailScraper.valid_email("hello@hello.co.uk") == true
            @test EmailScraper.valid_email("hello@hello.png") == false
            @test EmailScraper.valid_email("hello@hello.pdf") == false
            @test EmailScraper.valid_email("hello@hello.xpto") == false
        end

    end # Emails

    @testset "scrape_url" begin
        @test scrape_url("http://www.webscraper.io/test-sites/e-commerce/allinone") == String[]
        @test scrape_url("storopoli.io") == ["thestoropoli@gmail.com"]
        @test "contact@julialang.org" in scrape_url("julialang.org/about/help/")
    end # main function

end # EmailScraper
