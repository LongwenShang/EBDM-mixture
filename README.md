# ebdm-mixture: Estimating a Joint Distribution of a Continuous and a Binary Variable from Aggregated Summaries

This repository accompanies the 2-component Gaussian mixture extension of the R package **ebdm**, now available on CRAN.

The package implements a **Generalized Method of Moments** to estimate **group-specific means and variances** for a **two-component Gaussian mixture model** when only summary statistics are available. This is useful in privacy-preserving settings such as federated meta-analysis or clinical trial simulations (CTS) where only aggregated data are available.


The method is detailed in our manuscript:

---

## 🔍 Introduction

In many applied research settings such as clinical trial simulations, multi-cohort meta-analysis, or privacy-preserving subgroup analysis—access to individual-level data is often restricted. Researchers must rely on study-level summary statistics, including total sample sizes, overall means, and variances.

This creates a challenge when the underlying population is heterogeneous, such as when the outcome follows a two-group Gaussian mixture model stratified by a binary class label (e.g., treatment vs. control, male vs. female). Without access to individual labels or group-specific measurements, estimating the component-wise means and variances becomes statistically non-trivial.

The `est_mixture()` function in the `ebdm` package provides a **likelihood-based** and **GMM-based** solution for this problem, enabling the estimation of:
- Mean and variance for each latent component ($\mu_1, \mu_0, \sigma_1, \sigma_0$)
- Standard errors and confidence intervals for all parameters

By leveraging summary-level inputs from multiple independent studies, this method supports realistic mixture recovery in scenarios where data privacy, logistical constraints, or historical aggregation prevent access to full data.

---

## 📦 Installation

The `ebdm` package is available on CRAN. Install it using:

```r
install.packages("ebdm")
```

---

## 🌰 Usage Example

```r
# Load the package
library(ebdm)

# Load continuous example data
data(mixture_example)

# Estimate using GMM (recommended) with full summary statistics
result <- est_mixture(
  ni = mixture_example$ni,
  xbar = mixture_example$xbar,
  s2 = mixture_example$s2,
  mi = mixture_example$mi
)

print(result)
```

You can also use `method = "naive"` when sample variances are unavailable.

---

## 📈 Reproducing Simulation Studies

This repository includes the simulation code used in the manuscript. It evaluates estimation accuracy and CI coverage under various: True $\mu_1$ and $sigma_1$ values, Mixing proportions $\pi_i$, Number of studies (k) and Sample size ranges.

### Simulation Workflow Overview
| File            | Purpose                                                                  |
|-----------------|--------------------------------------------------------------------------|
| `main.R`        | Simulates 10000 replicate of one setting  |
| `submit.sh`     | Submits simulation jobs based on different settings on SLURM            |
| `results/`      | Stores raw outputs from each simulation replicate.                       |
| `merge_result.R`| Merges simulation outputs                                       |
| `eval.R`        | Summarizes coverage and plots        
### Run on SLURM Cluster Submit simulation jobs with:
```bash
for pi in 0.1 0.5 random; do
  for mu1 in 20 50; do
    for sigma1 in 1 5; do
      for K in 10 20 30 50 100; do
        for range in "100 200" "800 1000"; do
          n_low=$(echo $range | cut -d' ' -f1)
          n_high=$(echo $range | cut -d' ' -f2)
          echo "Submitting pi=$pi mu1=$mu1 sigma1=$sigma1 K=$K n=[$n_low,$n_high]"
          sbatch 1c1b.sh $pi $mu1 $sigma1 $K $n_low $n_high
        done
      done
    done
  done
done
```
### After Simulation: Merge and Evaluate
After all simulations are completed, run `merge_result.R` to merge the results. Then use `eval.R` to analyze the merged results and generate plots, which computes:
- Bias of point estimates
- Comparison of the two Methods
- Confidence interval coverage
- Plots in the manuscript
### Directory Structure
```
simulations/
├── main.R
├── submit.sh
├── results/
├── merge_result.R
└── eval.R
```
All simulation results are stored in `results/`. The seeds file ensures reproducibility.
### Session Information
The following R session information was recorded when reproducing the simulation results:
```r
R version 4.4.3 (2025-02-28)
Platform: x86_64-apple-darwin20
Running under: macOS Sequoia 15.5

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods  base     

other attached packages:
[1] MASS_7.3-65
```

## 📚 Citation

If you use this package or method in your work, please cite:









## 💬 Contact

For questions or feedback, please contact:
- 📧 **Xuekui Zhang** – xuekui@uvic.ca
- 📧 **Longwen Shang** – shanglongwen0918@gmail.com









