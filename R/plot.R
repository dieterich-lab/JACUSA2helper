# Helper function
paper_theme <- function(...) {
  # use theme_get() to see available options
  ggplot2::theme(plot.title = ggplot2::element_text(face = "bold", size = 20), 
                 axis.title.x = ggplot2::element_text(face = "bold", size = 16),
                 axis.title.y = ggplot2::element_text(face = "bold", size = 16, angle = 90),
                 panel.grid.major = ggplot2::element_blank(), # switch off major gridlines
                 panel.grid.minor = ggplot2::element_blank(), # switch off minor gridlines 
                 ...
  )
}

# TODO 
# add nice color
# make nice condition, replicate combination
plot_bc_sub_ecdf <- function(r, conditions = NULL) {
  d <- r[, c("id", "condition", "replicate", paste0("bc_", c("A", "C", "G", "T")))]
  d$bc <- rowSums(d[, paste0("bc_", c("A", "C", "G", "T"))])
  p <- ggplot(d, aes(x = bc, colour = condition, linetype = replicate)) + 
    stat_ecdf(geom = "step")
  p
}

plot_bc_sub_scatter <- function(r, conditions) {
  # select condition
  r <- r[, c("id", "condition", "replicate", paste0("bc_", c("A", "C", "G", "T")))]
  r$bc <- rowSums(r[, paste0("bc_", c("A", "C", "G", "T"))])
  r <- r[, c("id", "condition", "replicate", "bc")]
  r <- reshape2::dcast(r, id ~ replicate, fill = 0, value.var = "bc", fun.aggregate = sum)
  r
}

# TODO colors for condition
plot_bc_sub_fraction <- function(r, condition1 = "cond. A", condition2 = "cond. B") {
  d <- r[, c("id", "condition", "replicate", "end", "bc_position")]
  # distance from read arrest position to base sub.
  # NA if no base sub. exists
  d$distance <- d$bc_position - d$end
  # indicates if read arrest position has base sub. at all
  d$has_base_sub <- ifelse(is.na(d$distance), FALSE, TRUE)
  # calculate fraction of read arrest position with and without base sub.
  d <- d %>% group_by(condition, replicate, has_base_sub) %>% 
    summarise(count = n()) %>% 
    mutate(fraction = count / sum(count))
  # nice labels
  d$condition <- factor(d$condition, levels = c(1, 2), labels = c(condition1, condition2))
  d$replicate <- as.character(d$replicate)
  # retain only fraction of read arrest position with base sub.
  d <- filter(d, has_base_sub == T)
  
  # plot
  p <- ggplot(d, aes(x = replicate, y = fraction, fill = condition, label = scales::percent(fraction))) + 
    ylab("% of RA pos.\nwith base sub.") + 
    scale_y_continuous(labels = scales::percent) +
    geom_bar(stat = "identity") +
    geom_text(size = 3, position = position_stack(vjust = 1)) +
    facet_grid(. ~ condition) + 
    theme(legend.title = element_blank(), legend.position = "bottom")
  p
}

# TODO colors for condition
plor_bc_sub_distance <- function(r, condition1 = "cond. A", condition2 = "cond. B", max_distance = 200) {
  d <- r[, c("id", "condition", "replicate", "end", "bc_position")]
  # retain only fraction of read arrest position with base sub.
  d <- filter(d, ! is.na(bc_position))
  # distance from read arrest position to base sub.
  d$distance <- d$bc_position - d$end
  # filter max_distance
  d <- filter(d, distance <= max_distance)
  # bin
  d <- d %>% group_by(condition, replicate, distance) %>% summarise(count = n())
  # nice labels
  d$condition <- factor(d$condition, levels = c(1, 2), labels = c(condition1, condition2))
  d$replicate <- as.character(d$replicate)
  # plot
  d$sample <- interaction(d$condition, d$replicate, sep = " ")
  p <- ggplot(d, aes(x = distance, y = count, colour = sample, linetype = sample)) + 
    geom_line() +
    xlab("position of base sub.\nrelative to read arrest") + 
    scale_colour_manual("", values = c(1, 2, 1, 2)) + 
    scale_linetype_manual("", values = c(1, 1, 2, 2)) +
    theme(legend.title = element_blank(), legend.position = "bottom")
  p
}