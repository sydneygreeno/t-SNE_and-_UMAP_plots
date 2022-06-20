cell_data <- cell_line_ancestry
View(cell_line_ancestry)
cell_data <- cell_line_ancestry[, c(35:41)]
library(plotly)
library(umap)
cell_umap = umap(cell_data)
layout <- cell_umap[["layout"]]
layout <-data.frame(layout)
final <- cbind(layout, cell_line_ancestry$p)
fig <- plot_ly(final, x = ~X1, y= ~X2, color = ~cell_line_ancestry$p,type= 'scatter', mode="markers")%>%
  layout(title= "UMAP", legend=list(title=list(text="ancestry")))
fig