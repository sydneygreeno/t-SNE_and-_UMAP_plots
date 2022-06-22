##trying different parameters/methods


#### NONE OF THIS WORKED DO NOT USE THE SAME METHOD FOR RTSNE--
##
#
#trying Rtsne instead of tsne (uses c++ insted of interpreting)
install.package("Rtsne")
library(Rtsne)
library(plotly)
set.seed(0)
tsne <- Rtsne(cell_data)
tsne <- data.frame(tsne, initial_dims=2)
pdb <- cbind(tsne, cell_line_ancestry$p)
options(warn = -1)
fig3 <- plot_ly(data=pdb, x=~X1, y=~X2, type= "scatter", mode="markers", split= ~cell_line_ancestry$p)
fig3 <- fig3 %>%
  layout(title="R t-SNE",legend=list(title=list(text="ancestry")))
fig3
#result was a much faster graph


#want to eliminate cell from the data and eliminate the PCA parameter

cell_data2 <- cell_line_ancestry[-c(1:1383),]
View(cell_data2)
cell_data_data <-cell_data2[,c(35:41)]
View(cell_data_data)


library(Rtsne)
library(plotly)

tsne <- Rtsne(cell_data_data, pca=FALSE, pca_center=FALSE, check_duplicates=FALSE)
tsne <- data.frame(tsne)
pdb <- cbind(tsne, cell_data2$p)
options(warn = -1)
fig4 <- plot_ly(data=pdb, x=~X1, y=~X2, type= "scatter", mode="markers", split= ~cell_data2$p)
fig4 <- fig4 %>%
  layout(title="R t-SNE NO CELL VER",legend=list(title=list(text="ancestry")))
fig4

library(Rtsne)
set.seed(0)
tSNE_fit <- cell_line_ancestry %>%
  cell_line_ancestry[,c(35:41)] %>%
  scale() %>%
  Rtsne()

tSNE_df <- tSNE_fit$Y %>%
  as.data.frame() %>%
  rename(tSNE1="V1",
         tSNE2="V2")

tSNE_df <- tSNE-df %>%
  cbind(tSNE_df, cell_line_ancestry$p)

tSNE_df %>%
  ggplot(aes(x=tSNE1, y=tSNE2,
             color=cell_line_ancestry$p))+
  geom_point()+
  theme(legeng.position="bottom")

















