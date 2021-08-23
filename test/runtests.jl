using EmailScraper
using Test

const BODY = """
    HTML String
    """

@testset "EmailScraper" begin

    @testset "Domain" begin

        @testset "request_body" begin
            @test 1 == 1
            @test BODY == """
            HTML String
            """
            # test strings:
            # with http
            # without http
            # with https
            # with www
            # test Throw Error with invalid link
        end
        @testset "valid_links!" begin
            # test ignored_extensions
            # test ignored_domains
        end

        @testset "get_links" begin
            # test with a nice scraping friendly link in the web
        end

    end # Links

    @testset "Emails" begin

        @testset "obfuscated_email" begin
            # test obfuscated emails (AT DOT etc.)
        end

         @testset "extract_email" begin
            # test if parsers a regular emails
            # test inside a nasty String
            # test obfuscated emails (AT DOT etc.)
        end

        @testset "valid_email" begin
            # test with known TLDs
            # test with unknown TLDs
        end

        @testset "find_emails" begin
            # test with a HTML body full string
        end

    end # Emails

    @testset "scrape_domain" begin
        # test with a nice scraping friendly link in the web
    end # main function

end # EmailScraper
