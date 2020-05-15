#' Plot Correlations Between Biological Aging Measures and Chronological Age
#'
#' @title plot_ba
#' @description Plot Correlations Between Biological Aging Measures and Chronological Age
#' @param data The dataset for plotting correlations
#' @param variables A character vector indicating the names of the biological aging measures
#' @examples
#' #Calculate phenoage
#' f1 = plot_ba(data = data, variables = c("bioage", "phenoage", "hd"))
#'
#' f1
#'
#' @export
#' @import ggplot2
#' @import dplyr
#' @importFrom tidyr gather


plot_ba = function(data, variables) {

  data %>%
    gather(., method, measure, variables) %>%
    ggplot(., aes(x = age,y = measure, group = method, colour = as.factor(gender))) +
    geom_point(shape = 1) +
    geom_smooth(method = lm, color = "white", linetype = "dashed", size = 1) +
    facet_wrap(~ method, scales = "free") +
    scale_color_manual(values = c("#7294D4", "#E6A0C4"), name = "Gender", labels = c("Men", "Women")) +
    guides(colour = guide_legend(override.aes = list(alpha = 1, size = 3))) +
    scale_x_continuous(name ="Chronological Age") +
    scale_y_continuous(name ="Biological Age Measures") +
    theme_bw() +
    theme(axis.text = element_text(size = 14), axis.text.x = element_text(size = 14), axis.text.y = element_text(size = 14),
          axis.title = element_text(size = 14, face = "bold"), axis.line = element_line(colour = "black"),
          legend.title = element_text(size=13, face = "bold"), legend.text = element_text(size = 13),
          strip.background = element_rect(fill = "white"), strip.text = element_text(size=14,face = "bold"),
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.border = element_blank(),
          panel.background = element_blank())


}
