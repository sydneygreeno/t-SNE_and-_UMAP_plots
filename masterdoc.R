##   masterdoc of my work   ##

# the rest of it is on github


#PCA is an unsupervised machine learning technique that finds principal components
#the overall goal is to explain most of the variability in a data set with fewer variables than the original dataset

#pass numerical components into prcomp(), set args center and scale to TRUE
#obtain principal components
data(iris)
iris.pca <- prcomp(iris[,c(1:4)], center=TRUE, scale.=TRUE)
summary(iris.pca)

#plot results of PCA using a biplot
library(ggbiplot)


#need to interpret results by adjusting the arguments
ggbiplot(iris.pca, labels=iris$Species)
ggbiplot(iris.pca, ellipse=TRUE,)
ggbiplot(iris.pca, ellipse=TRUE, labels=iris$Species, obs.scale=1, var.scale=1)
ggbiplot(iris.pca, ellipse=TRUE, groups=iris$Species, obs.scale=1, var.scale=1)

#final
ggbiplot(iris.pca, ellipse=TRUE, groups=iris$Species, obs.scale=1, var.scale=1) + scale_colour_manual(name="origin", values= c("forest green", "red3", "dark blue")) +
  + ggtitle("PCA model of Iris Dataset") + theme_minimal() + theme(legend.position= "bottom")


#UMAP is an algorithm for dimensional reduction 
#as the number of data points increase UMAP becomes more efficient than t-SNE

##practical demonstration using the iris dataset

library(plotly)
library(umap)
iris.data = iris[, grep("Sepal|Petal", colnames(iris))]
iris.labels = iris[, "Species"]
iris.umap = umap(iris.data, n_components = 2, random_state = 15)
layout <- iris.umap[["layout"]]

layout<-data.frame(layout)
final <- cbind(layout, iris$Species)
fig <- plot_ly(final, x = ~X1, y= ~X2, color = ~iris$Species, colors= c("#636EFA", "#EF553B", "#00CC96"), type= 'scatter', mode="markers")%>%
  + layout(plot_bgcolor="#e5ecf6", legend=list(title=list(text="species")), xaxis= list(title="0"), yaxis=list(title="1"))
fig

iris.umap= umap(iris.data, n_components=3, random_state=15)
layout<- iris.umap[["layout"]]
layout<- data.frame(layout)
final<- cbind(layout,iris$Species)

fig2<- plot_ly(final, x = ~X1, y= ~X2, z= ~X3, color= ~iris$Species, colors= c("#636EFA", "#EF553B", "#00cc96"))
fig2 <- fig2 %>% add_markers()
fig2 <- fig2 %>% layout(scene = list(xaxis = list(title="0"), yaxis = list(title="1"), zaxis = list(title="2")))
fig2

#umap of cell line ancestry
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


#take away cell data

cell_data2<-filter(cell_line_ancestry, p != "cell")
cell_data_data<-cell_data2[,c(35:41)]

View(cell_data2)

#tsne of cell line ancestry data
#changed iter to 900 and perplexity to 60
library(tsne)
library(plotly)
set.seed(0)
tsne <- tsne(cell_data_data, max_iter=900, perplexity= 60)
tsne <- data.frame(tsne, initial_dims=2)
pdb <- cbind(tsne, cell_data2$p)
options(warn = -1)
fig2 <- plot_ly(data=pdb, x=~X1, y=~X2, type= "scatter", mode="markers", split= ~cell_data2$p)
fig2 <- fig2 %>%
  layout(title="t-SNE NO CELL VER",legend=list(title=list(text="ancestry")))
fig2

##Rtsne is different from tsne in that it doesnt go thru the R interpreter so it runs faster yaya


#this is the debugged code that actually works from my testing parameters file
library(Rtsne)
library(plotly)
set.seed(0)

#the problem was that a data frame and a matrix are different in R and i didnt account for that
tsne <- Rtsne(cell_data_data, pca=FALSE, pca_center=FALSE, check_duplicates=FALSE)
pdb <- cbind(tsne$Y, cell_data2$p)
pdb <- data.frame(tsne$Y, p=cell_data2$p)
#this figure gives an okay rtsne plot, but it can be way better by setting parameters
options(warn = -1)
fig4 <- plot_ly(data=pdb, x=~X1, y=~X2, type= "scatter", mode="markers", split= ~cell_data2$p)
fig4 <- fig4 %>%
  layout(title="R t-SNE NO CELL VER",legend=list(title=list(text="ancestry")))
fig4


##this is me now using this algorithm to test different parameters and graphs
#perplexity is up to 50

#these parameters are the best i got so far
set.seed(0)
tsne <- Rtsne(cell_data_data, check_duplicates=FALSE, perplexity=30, max_iter=1000, theta=0.9)
pdb <- cbind(tsne$Y, cell_data2$p)
pdb <- data.frame(tsne$Y, p=cell_data2$p)
options(warn = -1)
fig5 <- plot_ly(data=pdb, x=~X1, y=~X2, type= "scatter", mode="markers", split= ~cell_data2$p)
fig5 <- fig5 %>%
  layout(title="R t-SNE NO CELL VER",legend=list(title=list(text="ancestry")))
fig5


##more testing
#seeds that produce decent results-- 0, 60, 33, 32,28, 27, 18, 12, 10, 3, 95

set.seed(79)
tsne <- Rtsne(cell_data_data, check_duplicates=FALSE, perplexity=30, max_iter=1000, theta=0.9)
pdb <- cbind(tsne$Y, cell_data2$p)
pdb <- data.frame(tsne$Y, p=cell_data2$p)
options(warn = -1)
fig6 <- plot_ly(data=pdb, x=~X1, y=~X2, type= "scatter", mode="markers", split= ~cell_data2$p)
fig6 <- fig6 %>%
  layout(title="R t-SNE NO CELL VER",legend=list(title=list(text="ancestry")))
fig6

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
set.seed(0)
tsne <- Rtsne(cell_data_data, pca=FALSE, pca_center=FALSE, check_duplicates=FALSE)
pdb <- cbind(tsne$Y, cell_data2$p)
pdb <- data.frame(tsne$Y, p=cell_data2$p)

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




# the stuff that actually worked
library(Rtsne)
library(plotly)
library(dbscan)
library(RColorBrewer)

RColorBrewer::display.brewer.all()

cell_data_data<-cell_data2[,c(35:41)]

set.seed(60)
tsne <- Rtsne(cell_data_data, check_duplicates=FALSE, perplexity=30, max_iter=1000, theta=0.9)
pdb <- cbind(tsne$Y, cell_data2$p)
pdb <- data.frame(tsne$Y, p=cell_data2$p)
options(warn = -1)
fig6 <- plot_ly(data=pdb, x=~X1, y=~X2, type= "scatter", mode="markers", color= ~cell_data2$p, colors= "Set2")
fig6 <- fig6 %>%
  layout(title="R t-SNE NO CELL VER",legend=list(title=list(text="Ancestry Population")))
fig6
dbscan_res <- dbscan(tsne$Y, eps=2, minPts=3)
fig6 <- plot_ly(data=pdb, x=~X1, y=~X2, type= "scatter", mode="markers", color=~cell_data2$sp, colors="Accent")
fig6 <- fig6 %>%
  layout(title="DBSCAN",legend=list(title=list(text="Ancestry Subpopulation")))
fig6

####


rownames(cell_data_data) <- cell_data2$id

names(dbscan_res$cluster) <- rownames(cell_data_data)

clusters <- tibble::enframe(dbscan_res$cluster)

cluster_assign <- 
  dplyr::left_join(clusters, cell_data2, by=c("name"="id"))|>
  dplyr::select(name, value, sp) |>
  dplyr::group_by(value, sp) |>
  dplyr::summarise(n=dplyr::n()) |>
  dplyr::group_by(value) |>
  dplyr::mutate(max=max(n)) |>
  dplyr::filter(n==max)

assignments <- dplyr::left_join(clusters, cell_data2, by=c("name"="id"))|>
  dplyr::select(name, value, sp) |>
  dplyr::group_by(value, sp) |>
  dplyr::left_join(cluster_assign, by=c("value"="value")) |>
  dplyr::mutate(matches= sp.x==sp.y) |>
  dplyr::filter(matches==TRUE) |>
  dplyr::ungroup() |>
  dplyr::count()
assignments


##have to work on colors, shapes, size etcetc
##bc its numbers its making the gradient












