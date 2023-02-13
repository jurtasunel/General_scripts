# vcfR Documentation: http://127.0.0.1:30284/library/vcfR/doc/intro_to_vcfR.html
# Regular expressions docs: https://evoldyn.gitlab.io/evomics-2018/ref-sheets/R_strings.pdf

### Libraries.
library(vcfR)
library(stringr)

### Load vcf file.
vcf_path = "/home/josemari/Desktop/Jose/Recombinants_analysis/Karen_Johnston_12012023/bam_files/L22IRL12528_S33_L001srtd.bam.vcf"
vcf_file <- read.vcfR(vcf_path)

variants <- list()
# Loop through the atttribute that contains depth and quality.
for (i in 1:nrow(vcf_file@fix)){
  
  # Get current iteration.
  current_call <- vcf_file@fix[i,]["INFO"]
  
  # Get depth and quality in different variables.
  mapq <- as.integer(gsub("MQ=", "", str_extract(current_call, "MQ=\\d*"), fixed = TRUE))
  depth <- as.integer(gsub("DP=", "", str_extract(current_call, "DP=\\d*"), fixed = TRUE))
 
  if (depth > 30){
    variants <- (variants, vcf_file@fix[i,])
  }
}

"\\d{2}\\D\\d{5,8}"

