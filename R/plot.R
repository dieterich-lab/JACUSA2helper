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