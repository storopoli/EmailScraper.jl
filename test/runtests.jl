using EmailScraper
using Cascadia
using Gumbo
using HTTP
using Test

const BODY = parsehtml("""
                       <body class="d-flex h-100 text-center text-white bg-dark">
                       <div class="cover-container d-flex w-100 h-100 p-3 mx-auto flex-column">
                       <header class="mb-auto"><div><h3 class="float-md-start mb-0 " id="toptitle">
                       <a href="/">Jose Storopoli</a></h3></div></header><main class="px-3">
                       <div class="cover-mug"><img alt="" src="/assets/cover/pp.jpeg"/></div>
                       <div class="cover-lead lead">
                       <p>Associate Professor and Researcher of the <a href="https://uninove.br/ppgi">
                       Department of Computer Science</a> at <a href="https://uninove.br">
                       Universidade Nove de Julho - UNINOVE</a> located in São Paulo - Brazil.</p>
                       <p>Teaches undergraduate and graduate courses in Data Science, Statistics, Bayesian Statistics, Machine Learning and Deep Learning using <code>Julia</code>
                       , <code>R</code>, <code>Python</code>, and <code>Stan
                       </code>. Contributor to <code>Julia</code>, <code>R</code> and <code>
                       Stan</code> ecosystems. Proficient in <code>C</code>/<code>C++</code> and <code>
                       Rust</code>. Has published <code>Julia</code>, <code>Rust</code>, <code>R
                       </code>, and <code>Python</code> packages in official repositories/registries.</p><p>
                       Researches, publishes and advises PhD candidates on topics about Bayesian Statistical Modeling and Machine Learning applied to Decision Making. Principal Investigator of <a href="https://github.com/LabCidades">
                       LabCidades - Smart City Research Lab at UNINOVE</a>.</p><p>
                       Coauthor of <a href="https://juliadatascience.io/">Julia Data Science upcoming book
                       </a>. Certified <a href="https://education.rstudio.com/trainers/people/storopoli+jose/">
                       RStudio Tidyverse Instructor</a>.</p></div><p class="lead">
                       <a class="btn btn-outline-dark btn btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://storopoli.github.io/CV/CV.pdf"><i class="ai ai-cv ai-2x"></i></a>
                       <a class="btn btn-outline-dark btn btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://github.com/storopoli"><i class="fab fa-github fa-2x"></i></a>
                       <a class="btn btn-outline-dark btn btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://twitter.com/JoseStoropoli"><i class="fab fa-twitter fa-2x"></i></a>
                       <a class="btn btn-outline-dark btn btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://www.linkedin.com/in/storopoli"><i class="fab fa-linkedin fa-2x"></i></a>
                       <a class="btn btn-outline-dark btn btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://www.youtube.com/channel/UCXJBhNvt4HUtPr0tR7w1r0g"><i class="fab fa-youtube fa-2x"></i></a>
                       <a class="btn btn-outline-dark btn btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="mailto:thestoropoli@gmail.com"><i class="fas fa-paper-plane fa-2x"></i></a>
                       <a class="btn btn-outline-dark btn btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://orcid.org/0000-0002-0559-5176"><i class="ai ai-orcid ai-2x"></i></a>
                       <a class="btn btn-outline-dark btn btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://scholar.google.com/citations?user=xGU7H1QAAAAJ&amp;hl=en"><i class="ai ai-google-scholar ai-2x"></i></a>
                       <a class="btn btn-outline-dark btn btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="http://lattes.cnpq.br/2281909649311607"><i class="ai ai-lattes ai-2x"></i></a></p><br/><p class="lead">
                       <a class="btn btn-custom btn-outline-dark btn btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://juliadatascience.io"><img height="30" src="../assets/icons/julia-dots.svg"/><br/><br/> Julia for Data Science Book </a>
                       <a class="btn btn-custom btn-outline-dark btn btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://storopoli.io/Bayesian-Julia"><img height="30" src="../assets/icons/julia-dots.svg"/><br/><br/> Bayesian Statistics using Julia and Turing </a>
                       <a class="btn btn-custom btn-outline-dark btn btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://storopoli.io/Computacao-Cientifica"><img height="30" src="../assets/icons/julia-dots.svg"/><br/> Ciência de Dados e Computação Científica com Julia </a>
                       <a class="btn btn-custom btn-outline-dark btn btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://github.com/storopoli/EmailScraper.jl"><img height="30" src="../assets/icons/julia-dots.svg"/><br/><br/> EmailScraper.jl </a>
                       <a class="btn btn-custom btn-outline-dark btn btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://storopoli.io/Turing-Workshop"><img height="30" src="../assets/icons/julia-dots.svg"/><br/> Workshop of Bayesian Inference with Julia and Turing </a>
                       <a class="btn btn-custom btn-outline-dark btn btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://storopoli.io/Estatistica-Bayesiana"><img height="30" src="../assets/icons/R.svg"/><br/><br/> Estatística Bayesiana com R e Stan </a>
                       <a class="btn btn-custom btn-outline-dark btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://github.com/storopoli/ciencia-de-dados"><img height="30" src="../assets/icons/Python.svg"/><br/> Ciência de Dados pandas, Scikit-Learn, TensorFlow e PyTorch </a>
                       <a class="btn btn-custom btn-outline-dark btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://crates.io/crates/bibjoin"><img height="30" src="../assets/icons/Rust.svg"/><br/><br/> bibjoin </a>
                       <a class="btn btn-custom btn-outline-dark btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://storopoli.io/Estatistica"><img height="30" src="../assets/icons/R.svg"/><br/><br/> Estatística com R </a>
                       <a class="btn btn-custom btn-outline-dark btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://storopoli.io/Linguagem-R"><img height="30" src="../assets/icons/R.svg"/><br/><br/> Ciência de Dados com R e tidyverse </a>
                       <a class="btn btn-custom btn-outline-dark btn-secondary align-items-center fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://storopoli.io/Rcpp"><img height="30" src="../assets/icons/R.svg"/><br/><br/> Rcpp </a>
                       <a class="btn btn-custom btn-outline-dark btn-secondary align-items-center fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://cran.r-project.org/web/packages/FactorAssumptions/index.html"><img height="30" src="../assets/icons/R.svg"/><br/><br/> FactorAssumptions </a>
                       <a class="btn btn-custom btn-outline-dark btn-secondary fw-bold border-camb bg-oxb text-camb mb-2"
                       href="https://pypi.org/project/bibexcel/"><img height="30" src="../assets/icons/Python.svg"/><br/><br/> bibexcel </a></p><br/></main><footer class="mt-auto text-white-50">
                       <p> Website built with <a href="https://franklinjl.org/">Franklin.jl</a> and the <a href="https://julialang.org">Julia programming language</a>. </p></footer></div></body>
                       """).root[2]

@testset "EmailScraper" begin
    @testset "Domain" begin
        @testset "request_body" begin
            @test EmailScraper.request_body("storopoli.io") isa HTMLElement
            @test isempty(text(EmailScraper.request_body("string")))
        end

        @testset "valid_links" begin
            @test EmailScraper.valid_link("https://julialang.org") ==
                  "https://julialang.org"
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
            @test EmailScraper.extract_emails("LOREMIPUSM hello@hello.com LoReM Ipsum") ==
                  ["hello@hello.com"]
            @test EmailScraper.extract_emails(
                "LOREMIPUSM hello@hello.com ### !! LoReM hello@hello.com Ipsum"
            ) == ["hello@hello.com"]
            @test EmailScraper.extract_emails(
                "LOREMIPUSM hello@hello.com LoReM## !! @ hello2@hello.com Ipsum"
            ) == ["hello@hello.com", "hello2@hello.com"]
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
        @test scrape_url("http://www.webscraper.io/test-sites/e-commerce/allinone") ==
              String[]
        @test scrape_url("storopoli.io") == ["thestoropoli@gmail.com"]
        @test "contact@julialang.org" in scrape_url("julialang.org/about/help/")
    end
end # EmailScraper
