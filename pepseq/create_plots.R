library("JACUSAhelper2")
library("ggplot2")
library("GGally")
library("reshape2")

j <- read_jacusa("result")
j <- add_bc(j, aa = T)
j <- add_read_matrix(j)

# create p distribution
p_data <- data.frame(pvalue = j$pvalue)
sites <- nrow(p_data)
p <- ggplot(p_data, aes(x = pvalue)) + 
  geom_histogram() + 
  xlab("pvalue") + 
  ggtitle(paste0("Total sites: ", sites))
ggsave(filename = "pvalue_hist.png", p)

# scatterplot read arrest (RA) VS read through (RT) -> T = log((RA + 1) / (RT + 1))
# replicates
convert <- function(l) {
  d <- data.frame(l)
  d <- d + 1
  log(d$arrest / d$through)
}
rep_data <- data.frame(pvalue = j$pvalue,
                       allele1 = nchar(j$bc1),
                       allele2 = nchar(j$bc2),
                       base_call1 = j$bc1,
                       base_call2 = j$bc2,
                       value11 = convert(j$read_matrix1$reads11),
                       value12 = convert(j$read_matrix1$reads12),
                       value21 = convert(j$read_matrix2$reads21),
                       value22 = convert(j$read_matrix2$reads22),
                       stringsAsFactors = F)

rep_data_filtered <- subset(rep_data, pvalue <= 0.1)
filtered_sites <- nrow(rep_data_filtered)
# p <- ggpairs(rep_data_filtered, 
#              columns = 6:9, 
#              columnLabels = c("Condition R 1", "Cond. R 2", "Cond. C 1", "Cond. C 2"),
             title = paste0("Sites with pvalue <= 0.1 (filtered sites: ", filtered_sites, ", T = (RA + 1) / (RT + 1))")) +
  xlab("log (T)") + 
  ylab("log (T)")
ggsave(filename = "pairs.png", p)

rep_data_filtered$mean_value1 <- (rep_data_filtered$value11 + rep_data_filtered$value12) / 2
rep_data_filtered$mean_value2 <- (rep_data_filtered$value21 + rep_data_filtered$value22) / 2
p <- ggplot(rep_data_filtered, aes(x = mean_value1, y = mean_value2)) + 
  geom_point() + 
  xlab("mean log(T) Condition R") + 
  ylab("mean log(T) Cond. C") + 
  facet_grid(allele2 ~ allele1) + 
  ggtitle("Sites with pvalue <= 0.1 and number of observed alleles\n in cond. R and C (columns and rows)\n(T = (RA + 1) / (RT + 1))")
ggsave(filename = "alleles.png", p)

rep_data_filtered$misincorporation1 <- rep_data_filtered$allele1 - 1
rep_data_filtered$misincorporation2 <- rep_data_filtered$allele2 - 1

p <- ggplot(rep_data_filtered, aes(x = mean_value1, y = mean_value2)) + 
  geom_point() + 
  xlab("mean log(T) Condition R") + 
  ylab("mean log(T) Cond. C") + 
  facet_grid(. ~ allele1) + 
  ggtitle("Sites with pvalue <= 0.1 and increasing number of observed alleles\nin condition R (T = (RA + 1) / (RT + 1))")
ggsave(filename = "misincorporation_R.png", p)

p <- ggplot(rep_data_filtered, aes(x = mean_value1, y = mean_value2)) + 
  geom_point() + 
  xlab("mean log(T) Condition R") + 
  ylab("mean log(T) Cond. C") + 
  facet_grid(. ~ allele2) + 
  ggtitle("Sites with pvalue <= 0.1 and increasing number of observed alleles\nin condition C (T = (RA + 1) / (RT + 1))")
ggsave(filename = "misincorporation_C.png", p)

d <- melt(rep_data_filtered, measure.vars = c("value11", "value12", "value21", "value22"))
d$variable <- factor(d$variable, labels = c("R 1", "R 2", "C 1", "C 2"))
p <- ggplot(d, aes(x = value, colour = variable)) + 
  geom_density() + 
  xlab("log (T)") + 
  ggtitle("Sites with pvalue <= 0.1 in condition R and C (T = (RA + 1) / (RT + 1))") + 
  scale_color_discrete(name = "Samples")
ggsave(filename = "density.png", p)
