library(tsne)
library(plotly)
set.seed(0)
tsne <- tsne(cell_data)
tsne <- data.frame(tsne, initial_dims=2)
pdb <- cbind(tsne, cell_line_ancestry$p)
options(warn = -1)
fig2 <- plot_ly(data=pdb, x=~X1, y=~X2, type= "scatter", mode="markers", split= ~cell_line_ancestry$p)
fig2 <- fig2 %>%
  layout(title="t-SNE",legend=list(title=list(text="ancestry")))
fig2
