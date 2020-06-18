#' Plot association of biological aging measures with chronological age.
#'
#' @title plot_ba
#' @description Plot association of biological aging measures with chronological age.
#' @param data A dataset with projected biological aging measures for analysis.
#' @param agevar A character vector indicating the names of the biological aging measures.
#' @param label A character vector indicating the labels of the biological aging measures.
#' @note Chronological age and gender variables need to be named "age" and "gender".
#' @examples
#' #Plot age vs bioage
#' f1 = plot_ba(data = data, agevar = c("kdm", "phenoage", "hd"),
#'              label = c("Modified-KDM\nBiological\nAge",
#'                        "Modified-Levine\nPhenotypic\nAge",
#'                        "Homeostatic\nDysregulation"))
#'
#' f1
#'
#' @export
#' @import ggplot2
#' @import dplyr
#' @importFrom tidyr pivot_longer


plot_ba = function(data, agevar, label) {

  cor_label = data %>%
    pivot_longer(all_of(agevar), names_to = "method", values_to = "measure") %>%
    mutate(method = factor(method, levels = agevar, labels = label)) %>%
    group_by(method) %>%
    summarise(cor(measure, age ,use="complete.obs"))

  colnames(cor_label) = c("method","r")
  cor_label$r = round(cor_label$r, 3)
  cor_label$r = paste0("r = ", cor_label$r)

  plot = data %>%
    pivot_longer(all_of(agevar), names_to = "method", values_to = "measure") %>%
    mutate(method = factor(method, levels = agevar, labels = label)) %>%
    ggplot(., aes(x = age,y = measure, group = method, colour = as.factor(gender))) +
    geom_point(shape = 1) +
    geom_smooth(method = lm, color = "white", linetype = "dashed", size = 1) +
    facet_wrap(~ method, scales = "free") +
    scale_color_manual(values = c("#7294D4", "#E6A0C4"), name = "Gender", labels = c("Men", "Women")) +
    guides(colour = guide_legend(override.aes = list(alpha = 1, size = 3))) +
    scale_x_continuous(name ="Chronological Age") +
    scale_y_continuous(name ="Biological Age Measures") +
    geom_label(data = cor_label, aes(label = r),
               x = Inf, y = -Inf, hjust=1, vjust=0,
               label.size=0, inherit.aes = FALSE, size = 5,alpha = 0.2)+
    theme_bw() +
    theme(axis.text = element_text(size = 14), axis.text.x = element_text(size = 14), axis.text.y = element_text(size = 14),
          axis.title = element_text(size = 14, face = "bold"), axis.line = element_line(colour = "black"),
          legend.title = element_text(size=13, face = "bold"), legend.text = element_text(size = 13),
          strip.background = element_rect(fill = "white"), strip.text = element_text(size=14,face = "bold"),
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.border = element_blank(),
          panel.background = element_blank())

  return(plot)


}
