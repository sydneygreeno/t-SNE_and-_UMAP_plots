##took more time (about 1 hour)
##slightly less readable

#import libraries
library(tsne)
library(plotly)

#randomization factor
set.seed(0)

#actual tsne
##in R will measure summary of data and epoch which indicates the number of passes of the entire training dataset the machine learning algorithm has completed
tsne <- tsne(cell_data)
tsne <- data.frame(tsne, initial_dims=2)

#bind to labels p
pdb <- cbind(tsne, cell_line_ancestry$p)

#error handling when neg will ignore all errors
options(warn = -1)

#actual plotting
fig2 <- plot_ly(data=pdb, x=~X1, y=~X2, type= "scatter", mode="markers", split= ~cell_line_ancestry$p)
fig2 <- fig2 %>%
  layout(title="t-SNE",legend=list(title=list(text="ancestry")))

fig2



