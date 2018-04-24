########
#    Analysis of the relation between countries and adverse drug events
# reported to the FDA.
########

# Clear work space
rm(list=ls())  # Remove all objects.

# Loading the CSV data set
cep_11 <- read.table("CountryEventsProportions_11.csv", sep = ",", header = TRUE)
cep_21 <- read.table("CountryEventsProportions_21.csv", sep = ",", header = TRUE)
cep_28 <- read.table("CountryEventsProportions_28.csv", sep = ",", header = TRUE)
cep_42 <- read.table("CountryEventsProportions_42.csv", sep = ",", header = TRUE)

##############
# Correlations
##############
library(data.table)
library(lattice)

### Correlations for the 11 Adverse Events
c = cor(cep_11[2:ncol(cep_11)])

#  Maximum correlations dot plots
top_corr<- as.data.frame(setDT(melt(c))[Var1 != Var2, .SD[which.max(value)], keyby=Var1])
max.rel <- paste0(top_corr$Var1, ':', top_corr$Var2)
max.val <- top_corr$value
names(max.val) <- max.rel
max.ord = order(names(max.val), decreasing = TRUE)
dotplot(max.val[max.ord], type=c("p"), cex=2, xlim=c(0, 1),
        main = 'Strongest Positive Correlations Between Adverse Events',
        xlab = "Positive Correlation Value")


#  Minimum correlations dot plots
bottom_corr <- as.data.frame(setDT(melt(c))[Var1 != Var2, .SD[which.min(value)], keyby=Var1])
min.rel <- paste0(bottom_corr$Var1, ':', bottom_corr$Var2)
min.val <- bottom_corr$value
names(min.val) <- min.rel
min.ord = order(names(min.val), decreasing = TRUE)
dotplot(min.val[min.ord], type=c("p"), cex=2, xlim=c(-1, 0),
        main = 'Strongest Negative Correlations Between Adverse Events',
        xlab = "Negative Correlation Value")

### Correlations for the 21 Adverse Events
c = cor(cep_21[2:ncol(cep_21)])

#  Maximum correlations dot plots
top_corr<- as.data.frame(setDT(melt(c))[Var1 != Var2, .SD[which.max(value)], keyby=Var1])
max.rel <- paste0(top_corr$Var1, ':', top_corr$Var2)
max.val <- top_corr$value
names(max.val) <- max.rel
max.ord = order(names(max.val), decreasing = TRUE)
dotplot(max.val[max.ord], type=c("p"), cex=2, xlim=c(0, 1),
        main = 'Strongest Positive Correlations Between Adverse Events',
        xlab = "Positive Correlation Value")


#  Minimum correlations dot plots
bottom_corr <- as.data.frame(setDT(melt(c))[Var1 != Var2, .SD[which.min(value)], keyby=Var1])
min.rel <- paste0(bottom_corr$Var1, ':', bottom_corr$Var2)
min.val <- bottom_corr$value
names(min.val) <- min.rel
min.ord = order(names(min.val), decreasing = TRUE)
dotplot(min.val[min.ord], type=c("p"), cex=2, xlim=c(-1, 0),
        main = 'Strongest Negative Correlations Between Adverse Events',
        xlab = "Negative Correlation Value")

### Correlations for the 28 Adverse Events
c = cor(cep_28[2:ncol(cep_28)])

#  Maximum correlations dot plots
top_corr<- as.data.frame(setDT(melt(c))[Var1 != Var2, .SD[which.max(value)], keyby=Var1])
max.rel <- paste0(top_corr$Var1, ':', top_corr$Var2)
max.val <- top_corr$value
names(max.val) <- max.rel
max.ord = order(names(max.val), decreasing = TRUE)
dotplot(max.val[max.ord], type=c("p"), cex=2, xlim=c(0, 1),
        main = 'Strongest Positive Correlations Between Adverse Events',
        xlab = "Positive Correlation Value")


#  Minimum correlations dot plots
bottom_corr <- as.data.frame(setDT(melt(c))[Var1 != Var2, .SD[which.min(value)], keyby=Var1])
min.rel <- paste0(bottom_corr$Var1, ':', bottom_corr$Var2)
min.val <- bottom_corr$value
names(min.val) <- min.rel
min.ord = order(names(min.val), decreasing = TRUE)
dotplot(min.val[min.ord], type=c("p"), cex=2, xlim=c(-1, 0),
        main = 'Strongest Negative Correlations Between Adverse Events',
        xlab = "Negative Correlation Value")

### Correlations for the 42 Adverse Events
c = cor(cep_42[2:ncol(cep_42)])

#  Maximum correlations dot plots
top_corr<- as.data.frame(setDT(melt(c))[Var1 != Var2, .SD[which.max(value)], keyby=Var1])
max.rel <- paste0(top_corr$Var1, ':', top_corr$Var2)
max.val <- top_corr$value
names(max.val) <- max.rel
max.ord = order(names(max.val), decreasing = TRUE)
dotplot(max.val[max.ord], type=c("p"), cex=2, xlim=c(0, 1),
        main = 'Strongest Positive Correlations Between Adverse Events',
        xlab = "Positive Correlation Value")


#  Minimum correlations dot plots
bottom_corr <- as.data.frame(setDT(melt(c))[Var1 != Var2, .SD[which.min(value)], keyby=Var1])
min.rel <- paste0(bottom_corr$Var1, ':', bottom_corr$Var2)
min.val <- bottom_corr$value
names(min.val) <- min.rel
min.ord = order(names(min.val), decreasing = TRUE)
dotplot(min.val[min.ord], type=c("p"), cex=2, xlim=c(-1, 0),
        main = 'Strongest Negative Correlations Between Adverse Events',
        xlab = "Negative Correlation Value")


#########
# Heat Maps
#########
library(gplots)
library(RColorBrewer)

# creates a color palette from red to green
my_palette <- colorRampPalette(c("red", "yellow", "green"))(n = 299)

# creates a 5 x 5 inch image
# png("figures/heatmap_cep_11.png",   # create PNG for the heat map        
#     width = 5*300,                  # 5 x 300 pixels
#     height = 5*300,
#     res = 300,                      # 300 pixels per inch
#     pointsize = 8)                  # smaller font size

lmat = rbind(c(0,3),c(2,1),c(0,4))    # Color key below the heatmap
lwid = c(1.5,6)
lhei = c(1.5,3,1)
 
### Heatmap for 11 Events
rnames_11 <- cep_11[,1]                          
mat_cep_11 <- data.matrix(cep_11[,2:ncol(cep_11)])
rownames(mat_cep_11) <- rnames_11

heatmap.2(mat_cep_11,
          main = "Adverse Events in Each Country",
          notecol="black", density.info="none", trace="none",
          margins =c(12,9), col=my_palette, dendrogram="both",
          lwid = c(1.5,5), lhei = c(1.5,6))

dev.off()

### Heatmap for 21 Events
rnames_21 <- cep_21[,1]                          
mat_cep_21 <- data.matrix(cep_21[,2:ncol(cep_21)])
rownames(mat_cep_21) <- rnames_21

heatmap.2(mat_cep_21,
          main = "Adverse Events in Each Country",
          notecol="black", density.info="none", trace="none",
          margins =c(12,9), col=my_palette, dendrogram="both",
          lwid = c(1.5,5), lhei = c(1.5,6))

dev.off()

### Heatmap for 28 Events
rnames_28 <- cep_28[,1]                          
mat_cep_28 <- data.matrix(cep_28[,2:ncol(cep_28)])
rownames(mat_cep_28) <- rnames_28

heatmap.2(mat_cep_28,
          main = "Adverse Events in Each Country",
          notecol="black", density.info="none", trace="none",
          margins =c(12,9), col=my_palette, dendrogram="both",
          lwid = c(1.5,5), lhei = c(1.5,6))

dev.off()

### Heatmap for 28 Events
rnames_42 <- cep_42[,1]                          
mat_cep_42 <- data.matrix(cep_42[,2:ncol(cep_42)])
rownames(mat_cep_42) <- rnames_42

heatmap.2(mat_cep_42,
          main = "Adverse Events in Each Country",
          notecol="black", density.info="none", trace="none",
          margins =c(12,9), col=my_palette, dendrogram="both",
          lwid = c(1.5,5), lhei = c(1.5,6))

dev.off()

###########
# Particioning around Medoids.  Best number of clusters: 2
###########
library(cluster)
fit.pam <- pam(cep_11, k = 2, stand = TRUE)
fit.pam$medoids
summary(fit.pam)
clusplot(fit.pam, main = "Bivariate Country Cluster Plot", labels = 2)


##############
# PCA Analysis
##############
library(psych)
fa.parallel(cep, fa = "pc", n.iter = 100, show.legend = FALSE,
            main = "Scree Plot with Parallel Analysis")
pc.fa <- principal(cep, nfactors = 2)
pc.fa

# Plotting PCA
library(ggfortify)
pc <- prcomp(cep)
plot(pc, type = 'l')
summary(pc)
autoplot(prcomp(cep), label = TRUE)



##########
#  Decision Trees
##########
library(rpart)
set.seed(1234)
dtree <- rpart(Country ~ ., data = cep_11, method = "class")
dtree$cptable
plotcp(dtree)
# Very poor performance.


#########
# Random Forests
#########
library(randomForest)
set.seed(1234)
fit.forest <- randomForest(Country ~ ., data = cep_11)
fit.forest
# Very poor performance.


##########
# Support Vector Machines
##########
library(e1071)
set.seed(1234)
fit.svm <- svm(Country ~ ., data = cep)
fit.svm
# Performanced to be determined.
