# Checking that a statistical method fits the data

Part of the dltemplates project `CLAUDE.md`, loaded on demand: clone dltemplates into a scratch directory and read this file only when the task calls for it.

Read this before choosing a statistical test or model, or writing code for one, and when checking one the student already has.
"Statistical tests" in `CLAUDE.md` is about choosing tests honestly; this guide is about whether a test answers the question it seems to answer.
When a method fails a check here, say so plainly, propose an alternative, and log the change in `docs/analysis_log.md` as a deviation with the reason.
The references are listed under "Reading to suggest" at the end.

## Before any test

- Write the null hypothesis of the test in words and check that rejecting it answers the question.
- Check the assumptions on the actual data, not in principle: residual plots for linear models, `DHARMa` for GLMs and mixed models, dispersion for PERMANOVA.
- Check how many distinct permutations a permutation test has.
  With two groups of three samples there are only ten distinct splits, so the p-value can't go below about 0.1.
  `adonis2()` with 999 permutations still prints a p-value with three decimals.
- Check the unit of replication (see "Valid tests" in `CLAUDE.md`; Hurlbert 1984).
- Report an effect size with every test: R² for PERMANOVA, coefficients with confidence intervals for models.

## Compositional data

Sequencing gives relative abundances.
The total count of a sample is set by the sequencing depth, so a taxon's count says nothing about its absolute abundance, and one taxon increasing makes the others appear to decrease (Gloor et al. 2017).
The same holds for gene counts and TPM in metagenomes and metatranscriptomes: TPM sums to the same total in every sample.

- Don't correlate taxa or genes with Pearson or Spearman on counts or proportions, and don't build networks from such correlations: part of the correlation is spurious.
  Use proportionality (`propr`; Lovell et al. 2015) or a compositional method such as SparCC (`SpiecEasi::sparcc()`; Friedman & Alm 2012).
- A difference in relative abundance is not a difference in absolute abundance.
  Write "a larger share of the community", not "more".
- Aitchison distance (CLR transformation, then Euclidean distance) is the compositional choice for ordination.
  Bray–Curtis on relative abundances is common and fine for describing communities; name the distance either way.

## Sequencing depth and rarefying

- Observed richness and other alpha diversity measures grow with sequencing depth, so don't compare observed ASV counts between samples of different depth.
  Estimate richness with `breakaway`, and compare the estimates with `breakaway::betta()`, which takes each estimate's standard error into account, rather than with a t-test or ANOVA on the estimates (Willis et al. 2017; Willis 2019).
- Rarefying throws away data and adds noise; don't rarefy for differential abundance (McMurdie & Holmes 2014).
  For ordination it is debated (Weiss et al. 2017).
  If the student rarefies, state the depth, and check that the result holds at another depth.
- Check whether a pattern follows sequencing depth: plot the variable against library size.

## PERMANOVA and other distance-based tests

- `adonis2()` is sensitive to differences in dispersion as well as in location, especially with unequal group sizes.
  Run `betadisper()` and `permutest()` alongside and report both; if dispersions differ, say that the PERMANOVA result may reflect them (Anderson & Walsh 2013).
- Avoid ANOSIM, which is even more sensitive to differences in dispersion.
- `adonis2()` tests terms sequentially by default, so their order changes the result.
  With more than one term, use `by = "margin"` or justify the order.
- Restrict the permutations to match the design: `strata`, or `permutations = how(blocks = ...)` from `permute`.
- Use a Mantel test only when the hypothesis is about distances themselves.
  For relations between communities and environment or space, `vegan::dbrda()` or PERMANOVA on the variables has more power (Legendre et al. 2015).
- NMDS is a picture, not a test, and `envfit()` p-values assume independent samples.

## Differential abundance

- Methods give very different results on the same data (Nearing et al. 2022).
  Use the method chosen in the plan, or several (for example `ALDEx2` and `ANCOMBC`) and report where they agree.
- Filter rare taxa by prevalence before testing, never by results, and use the method's multiple-testing correction (false discovery rate, `p.adjust(method = "BH")`).
- Results for rare taxa depend on how zeros are handled (pseudocounts); treat them with caution.

## Regression and other models

- Counts and proportions break the assumptions of `lm()`.
  Use a GLM: negative binomial for counts, with `offset(log(library_size))`, binomial or beta for proportions.
  Check the residuals with `DHARMa`.
- Model dependent samples (repeated sampling, several samples per site or mesocosm) with a random effect.
- Samples along a time series or a transect are correlated with their neighbours; check the residuals with `acf()`.
- With few samples, keep few predictors and choose them in the plan.
  Selecting among many candidate models by AIC is itself a form of multiple testing.
- Correlated predictors (temperature and season, depth and light) give unstable coefficients.
  Check with `cor()` or variance inflation factors, and interpret them together.

## Interpreting results

- A non-significant result is not evidence of no effect; give the confidence interval.
- With many samples, tiny effects become significant; judge the effect size, not the p-value.
- Field surveys show associations, not causes.
  Avoid causal verbs ("drives", "controls", "shapes") unless the design was an experiment.
- A p-value is not the probability that the hypothesis is true (Wasserstein & Lazar 2016; Amrhein et al. 2019).

## Reading to suggest

Suggest one or two items that match the problem at hand, not the whole list.

Questionable research practices and p-values:

- Wikipedia, "Data dredging" (p-hacking redirects there): https://en.wikipedia.org/wiki/Data_dredging
- Tsang, B. (2025). P hacking — Five ways it could happen to you. Nature. https://doi.org/10.1038/d41586-025-01246-1
- Nuzzo, R. (2014). Scientific method: Statistical errors. Nature, 506, 150–152. https://doi.org/10.1038/506150a
- Fraser, H., Parker, T., Nakagawa, S., Barnett, A., & Fidler, F. (2018). Questionable research practices in ecology and evolution. PLOS ONE, 13, e0200303. https://doi.org/10.1371/journal.pone.0200303
- Simmons, J. P., Nelson, L. D., & Simonsohn, U. (2011). False-positive psychology. Psychological Science, 22, 1359–1366. https://doi.org/10.1177/0956797611417632
- Martinson, B. C., Anderson, M. S., & de Vries, R. (2005). Scientists behaving badly. Nature, 435, 737–738. https://doi.org/10.1038/435737a
- Ioannidis, J. P. A. (2005). Why most published research findings are false. PLoS Medicine, 2, e124. https://doi.org/10.1371/journal.pmed.0020124
- Open Science Collaboration (2015). Estimating the reproducibility of psychological science. Science, 349, aac4716. https://doi.org/10.1126/science.aac4716
- Wasserstein, R. L., & Lazar, N. A. (2016). The ASA statement on p-values: Context, process, and purpose. The American Statistician, 70, 129–133. https://doi.org/10.1080/00031305.2016.1154108
- Amrhein, V., Greenland, S., & McShane, B. (2019). Scientists rise up against statistical significance. Nature, 567, 305–307. https://doi.org/10.1038/d41586-019-00857-9

Using AI in the analysis (suggest it when the student takes a method from Claude without checking it):

- Auslander, N. (2026). Ten simple rules for responsible use of AI and LLMs in computational biology. PLOS Computational Biology, 22, e1014882. https://doi.org/10.1371/journal.pcbi.1014882

Methods:

- Hurlbert, S. H. (1984). Pseudoreplication and the design of ecological field experiments. Ecological Monographs, 54, 187–211. https://doi.org/10.2307/1942661
- Gloor, G. B., Macklaim, J. M., Pawlowsky-Glahn, V., & Egozcue, J. J. (2017). Microbiome datasets are compositional: And this is not optional. Frontiers in Microbiology, 8, 2224. https://doi.org/10.3389/fmicb.2017.02224
- Lovell, D., Pawlowsky-Glahn, V., Egozcue, J. J., Marguerat, S., & Bähler, J. (2015). Proportionality: A valid alternative to correlation for relative data. PLOS Computational Biology, 11, e1004075. https://doi.org/10.1371/journal.pcbi.1004075
- Friedman, J., & Alm, E. J. (2012). Inferring correlation networks from genomic survey data. PLoS Computational Biology, 8, e1002687. https://doi.org/10.1371/journal.pcbi.1002687
- McMurdie, P. J., & Holmes, S. (2014). Waste not, want not: Why rarefying microbiome data is inadmissible. PLoS Computational Biology, 10, e1003531. https://doi.org/10.1371/journal.pcbi.1003531
- Weiss, S., et al. (2017). Normalization and microbial differential abundance strategies depend upon data characteristics. Microbiome, 5. https://doi.org/10.1186/s40168-017-0237-y
- Willis, A. D. (2019). Rarefaction, alpha diversity, and statistics. Frontiers in Microbiology, 10, 2407. https://doi.org/10.3389/fmicb.2019.02407
- Willis, A., Bunge, J., & Whitman, T. (2017). Improved detection of changes in species richness in high diversity microbial communities. Journal of the Royal Statistical Society Series C, 66, 963–977. https://doi.org/10.1111/rssc.12206
- Anderson, M. J., & Walsh, D. C. I. (2013). PERMANOVA, ANOSIM, and the Mantel test in the face of heterogeneous dispersions: What null hypothesis are you testing? Ecological Monographs, 83, 557–574. https://doi.org/10.1890/12-2010.1
- Legendre, P., Fortin, M.-J., & Borcard, D. (2015). Should the Mantel test be used in spatial analysis? Methods in Ecology and Evolution, 6, 1239–1247. https://doi.org/10.1111/2041-210X.12425
- Nearing, J. T., et al. (2022). Microbiome differential abundance methods produce different results across 38 datasets. Nature Communications, 13. https://doi.org/10.1038/s41467-022-28034-z
