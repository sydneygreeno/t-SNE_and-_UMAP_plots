##took much less time than t-SNE

#import data
cell_data <- cell_line_ancestry
View(cell_line_ancestry) 

#only want numeric ancestry related values
cell_data <- cell_line_ancestry[, c(35:41)]

#import libraries to make plot
library(plotly)
library(umap)

#umap
cell_umap = umap(cell_data)
layout <- cell_umap[["layout"]]
layout <-data.frame(layout)

#need to bind for p column labels
final <- cbind(layout, cell_line_ancestry$p)

#design plot
fig <- plot_ly(final, x = ~X1, y= ~X2, color = ~cell_line_ancestry$p,type= 'scatter', mode="markers")%>%
  layout(title= "UMAP", legend=list(title=list(text="ancestry")))

fig



