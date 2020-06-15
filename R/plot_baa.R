make_plot = function(axis_type, comp_df, dat, label,
                     scatter_cols, cor_zlim, white_borders = FALSE) {

  num_vars = length(levels(comp_df$x_var))

  ind_mat = matrix(
    seq(1, (1 + num_vars)^2),
    nrow = 1 + num_vars,
    ncol = 1 + num_vars
  )

  index_df = get_indexes(comp_df, ind_mat, num_vars, dat)
  index_df$x_var = factor(index_df$x_var, levels=unique(index_df$x_var))
  index_df$y_var = factor(index_df$y_var, levels=unique(index_df$y_var))

  data_lims = apply(dat, 2, range, na.rm = TRUE)

  label_ind = diag(ind_mat)
  names(label_ind) = levels(index_df$x_var)
  names(label_ind)[length(label_ind)] = tail(levels(index_df$y_var), 1)

  index_df$cor_cols = cor_colors(vals = index_df$cor, fix = 0, zlim = cor_zlim,
                                 pos_cols = NULL, neg_cols = NULL, na_col = NULL)

  layout_mat = ind_mat
  layout_mat = cbind(rep(0, nrow(layout_mat)), layout_mat)
  layout_mat = rbind(layout_mat, rep(0, ncol(layout_mat)))

  layout_height = c(rep(10, nrow(layout_mat) - 1), 3)
  layout_widths = c(3, rep(10, ncol(layout_mat) - 1))

  par(cex = 1, mar = rep(.35, 4), oma = rep(0, 4),
      xaxt = 'n', yaxt = 'n', lend = 1, ljoin = 1)

  if (white_borders == TRUE) {
    par(fg = 'white', col.axis = 'white')
  }

  layout(layout_mat, height = layout_height, widths = layout_widths)

  for (plt_ind in ind_mat) {

    if (plt_ind %in% index_df$scatter_ind) {
      ind = index_df[which(index_df$scatter_ind %in% plt_ind), ]

      xy_names = c(as.character(ind$x_var), as.character(ind$y_var))
      cur_dat = dat[, xy_names]
      names(cur_dat) = c("x", "y")

      cur_axtype = c(axis_type[xy_names[1]], axis_type[xy_names[2]])
      names(cur_axtype) = c("x", "y")

      xlim = data_lims[, as.character(ind$x_var)]
      ylim = data_lims[, as.character(ind$y_var)]
      plot_scatter(dat = cur_dat, scatter_cols, lm_col = ind$cor_cols, axis_type = cur_axtype,
                   xlim = xlim, ylim = ylim, x_axis = ind$x_axis, y_axis = ind$y_axis, plot_lm = TRUE)
    }
    else if (plt_ind %in% index_df$cor_ind) {
      ind = index_df[which(index_df$cor_ind %in% plt_ind), ]
      plot_cor(cor = ind$cor, col = ind$cor_col)
    }

    else if (plt_ind %in% label_ind) {
      cur_lab = names(label_ind[which(label_ind %in% plt_ind)])
      plot_label(lab = label[cur_lab])
    }
  }
}

get_indexes = function(comp_df, ind_mat, num_vars, dat) {

  ret = data.frame()
  cor_mat = cor(dat)

  for (x_var in levels(comp_df$x_var)) {

    cur_grp = comp_df[which(comp_df$x_var %in% x_var), c("x_var", "y_var")]
    cur_grp$x_var = factor(cur_grp$x_var)
    cur_grp$y_var = factor(cur_grp$y_var)

    x_ind = which(levels(comp_df$x_var) %in% x_var)

    if (x_ind == 1) {
      y_axis = TRUE
    }
    else {
      y_axis = FALSE
    }

    for (y_var in levels(cur_grp$y_var)) {
      y_ind = which(levels(cur_grp$y_var) %in% y_var)

      if (y_ind == nrow(cur_grp)) {
        x_axis = TRUE
      }
      else {
        x_axis = FALSE
      }

      num_skip = 1 + num_vars - nrow(cur_grp)

      scatter_ind = ind_mat[num_skip + y_ind, x_ind]

      num_vars = length(levels(comp_df$x_var))

      cor_ind = ind_mat[x_ind, num_skip + y_ind]

      cor = cor_mat[x_var, y_var]

      ret = rbind(ret, data.frame(
        "x_var" = x_var,
        "y_var" = y_var,
        "x_ind" = x_ind,
        "y_ind" = y_ind,
        "x_axis" = x_axis,
        "y_axis" = y_axis,
        "scatter_ind" = scatter_ind,
        "cor_ind" = cor_ind,
        "cor" = cor
      ))
    }
  }
  return(ret)
}

cor_colors = function(vals, fix = 0, zlim = cor_zlim,
                      pos_cols = NULL, neg_cols = NULL, na_col = NULL) {
  if (is.null(pos_cols)) {
    pos_cols = colorRamp(rev(hcl.colors(9, palette = "Reds")))
  }

  if (is.null(neg_cols)) {
    neg_cols = colorRamp(rev(hcl.colors(9, palette = "Blues")))
  }

  if (is.null(na_col)) {
    na_col = "grey50"
  }

  colmap = function(val) {
    if (val < zlim[1] | val > zlim[2]) {
      ret = na_col
    }
    else if (val >= fix) {
      ret = rgb(pos_cols(val / zlim[2]), maxColorValue = 255)
    }
    else {
      ret = rgb(neg_cols(val / zlim[1]), maxColorValue = 255)
    }
    return(ret)
  }
  return(sapply(vals, colmap))
}

plot_scatter = function(dat, scatter_cols, lm_col, axis_type,
                        xlim, ylim, x_axis = TRUE, y_axis = TRUE, plot_lm = TRUE) {
  get_labels = function(x) {
    plot_labels = seq(x[1], x[2], length.out = 100)
    ret = quantile(plot_labels, seq(0, 1, .2))[c(-1, -6)]
    return(round(ret, 1))
  }

  axis_cex = 1.2
  dat$col = densCols(dat, y = NULL, nbin = 256, colramp = colorRampPalette(scatter_cols))
  dat = dat[rev(order(dat$col)), ]

  plot(dat$x, dat$y, col = dat$col, pch = 20, cex = 4, xlab = NA, ylab = NA,
       xlim = xlim, ylim = ylim)

  if (x_axis == TRUE) {
    usr = par()$usr
    round_d = ifelse(axis_type['x'] == 'int', 0, 1)
    x_at = round(get_labels(usr[1:2]), round_d)
    axis(1, at = x_at, xaxt = 's', labels = FALSE)
    text(x = x_at, y = usr[3] - 0.1 * (usr[4] - usr[3]),
         labels = format(x_at), srt = 45, adj = 1, font = 1, cex = axis_cex, xpd = NA)
  }

  if (y_axis == TRUE) {
    round_d = ifelse(axis_type['y'] == 'int', 0, 1)
    y_at = round(get_labels(par()$usr[3:4]), round_d)
    axis(side = 2, at = y_at, labels = y_at, yaxt = 's', cex.axis = axis_cex, las=2)
  }

  if (plot_lm == TRUE) {
    abline(lm(y ~ x, dat), col = "#000000", lty = 2, lwd = 2.001)
    abline(lm(y ~ x, dat), col = lm_col, lty = 2, lwd = 2)
  }
  box()
}

plot_cor = function (cor, col) {

  plt_cor = round(cor, 2)

  if (plt_cor == 0) {
    plt_cor = abs(plt_cor)
  }

  plot(0, 0, type = 'n', main = '', xlab = '', ylab = '', xaxt = 'n', yaxt = 'n')
  rect(-2, -2, 2, 2, col = col, border = NA)
  text(0, 0, sprintf("%.02f", plt_cor), cex = 3, col = "black")
  box()
}

plot_label = function (lab) {
  plot(0, 0, type = 'n', main = '', xlab = '', ylab = '', xaxt = 'n', yaxt = 'n')
  text(0, 0, lab, cex = 1.5, col = "black")
  box()

}

#' Plot correlations between BAA and chronological age
#'
#' @title plot_baa
#' @description Plot correlations between biological age advancement (BAA) and chronological age
#' @param data The dataset for plotting corplot
#' @param agevar A character vector indicating the names of the interested biological aging measures
#' @param label A character vector indicating the labels of the biological aging measures
#'               Values should be formatted for displaying along diagonal of the plot
#'               Names should be used to match variables and order is preserved
#' @param axis_type A character vector indicating the axis type (int or float)
#'                  Use variable name to define the axis type
#' @examples
#' #Create corplot of BAA with chronologicl age
#' agevar = c("kdm_advance0",
#'            "phenoage_advance0",
#'            "kdm_advance",
#'            "phenoage_advance",
#'            "hd",
#'            "hd_log")
#'
#' label = c("kdm_advance0"="KDM\nBiological\nAge",
#'            "phenoage_advance0"="Levine\nPhenotypic\nAge",
#'            "kdm_advance"="Modified-KDM\nBiological\nAge",
#'            "phenoage_advance"="Modified-Levine\nPhenotypic\nAge",
#'            "hd" = "Mahalanobis\nDistance",
#'            "hd_log" = "Log\nMahalanobis\nDistance")
#'
#' axis_type = c("kdm_advance0"="float",
#'               "phenoage_advance0"="float",
#'               "kdm_advance"="float",
#'               "phenoage_advance"="flot",
#'               "hd"="flot",
#'               "hd_log"="float")
#'
#' f2 = plot_baa(data, agevar, labels, axis_type)
#'
#' f2
#'
#' @export
#' @import ggplot2

plot_baa = function(data, agevar, label, axis_type) {

  # Vector of colors for scatter plot DensCols
  scatter_cols = rev(hcl.colors(9, palette = "Blues"))[-(1:3)]

  # Correlation zlims
  cor_zlim = c(-1, 1)

  # Use complete dataset
  dat = data %>%
    select(all_of(agevar)) %>%
    na.omit() %>%
    as.data.frame()

  # Create column-wise comparisons
  comp_df = data.frame(t(combn(names(label), 2)))
  names(comp_df) = c("x_var", "y_var")
  comp_df$x_var = factor(comp_df$x_var, levels=unique(comp_df$x_var))
  comp_df$y_var = factor(comp_df$y_var, levels=unique(comp_df$y_var))


  # Make plots for both filenames
  make_plot(axis_type, comp_df, dat, label,
            scatter_cols, cor_zlim,
            white_borders=FALSE)


}

