# tests for feature pre-processing functions.

context("test feature pre-processing functions")

test_that("we can summarise expression at feature level", {
    data("sc_example_counts")
    data("sc_example_cell_info")
    example_sce <- SingleCellExperiment(
        assays = list(counts = sc_example_counts), 
        colData = sc_example_cell_info)
    effective_length <- rep(c(1000, 2000), times = 1000)
    tpm(example_sce) <- calculateTPM(example_sce, effective_length, 
                                        calc_from = "counts")
    
    fd <- data.frame(
        gene_id = rownames(example_sce),
        feature_id = paste("feature", rep(1:500, each = 4), sep = "_"))
    rownames(fd) <- rownames(example_sce)
    rowData(example_sce) <- fd
    
    ## tpm with scaled tpm counts
    example_sce_summarised <-
        summariseExprsAcrossFeatures(example_sce, exprs_values = "tpm")
    expect_that(example_sce_summarised, is_a("SingleCellExperiment"))    
    example_sce_summarised <-
        summariseExprsAcrossFeatures(example_sce, exprs_values = "tpm",
                                     scaled_tpm_counts = FALSE)
    expect_that(example_sce_summarised, is_a("SingleCellExperiment"))    

    ## counts 
    example_sce_summarised <-
        summariseExprsAcrossFeatures(example_sce, exprs_values = "counts")
    expect_that(example_sce_summarised, is_a("SingleCellExperiment"))
    
    ## exprs
    exprs(example_sce) <- log2(calculateCPM(example_sce) + 1)
    expect_error(summariseExprsAcrossFeatures(
        example_sce, exprs_values = "exprs"), "'arg' should be one of")
    
    ## errors
    example_sce2 <- SingleCellExperiment(
        assays = list(tpm = tpm(example_sce)), 
        colData = colData(example_sce), rowData = rowData(example_sce))
    expect_error(summariseExprsAcrossFeatures(example_sce2, exprs_values = "tpm"),
                 "lib_size argument")
    expect_error(summariseExprsAcrossFeatures(example_sce2, exprs_values = "tpm",
                                              lib_size = 1:10),
                 "lib_size argument must have length equal")

})

test_that("we can uniquify the feature names", {
    all.genes <- sample(c(LETTERS, LETTERS[1:5], NA, NA))
    all.ids <- paste0("GENE", seq_along(all.genes))
    out <- uniquifyFeatureNames(all.ids, all.genes)

    lost <- is.na(all.genes)
    expect_identical(out[lost], all.ids[lost])
    dup <- all.genes %in% all.genes[duplicated(all.genes)]
    expect_identical(out[!dup & !lost], all.genes[!dup & !lost])
    expect_identical(out[dup & !lost], paste0(all.genes, "_", all.ids)[dup & !lost])
})

