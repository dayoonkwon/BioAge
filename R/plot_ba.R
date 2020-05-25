#' Plot correlations between biological aging measures and chronological age
#'
#' @title plot_ba
#' @description Plot correlations between biological aging measures and chronological age
#' @param data The dataset for plotting correlations
#' @param agevar A character vector indicating the names of the biological aging measures
#' @note Chronological age and gender variables need to be named "age" and "gender"
#' @examples
#' #Calculate phenoage
#' f1 = plot_ba(data = data, agevar = c("bioage", "phenoage", "hd"))
#'
#' f1
#'
#' @export
#' @import ggplot2
#' @import dplyr
#' @importFrom tidyr gather


plot_ba = function(data, agevar) {

  cor_label = data %>%
    gather(., method, measure, agevar) %>%
    group_by(as.factor(method)) %>%
    summarise(cor(measure, age ,use="complete.obs"))

  colnames(cor_label) = c("method","r")
  cor_label$r = round(cor_label$r, 3)
  cor_label$r = paste0("r = ", cor_label$r)

  data %>%
    gather(., method, measure, agevar) %>%
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


}
