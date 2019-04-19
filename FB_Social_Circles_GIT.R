#########################
####REQUIRED PACKAGES####
#========================
library(igraph)

network_matrix <- read.csv("network_GIT_final.csv")
association <- read.csv("association_GIT_final.csv")

rownames(network_matrix) <- network_matrix$X
network_matrix <- network_matrix[,-1]
colnames(network_matrix) <- rownames(network_matrix)


########################
####NETWORK ANALYSIS####
#=======================

#To run the full network analysis
network_matrix1 <- network_matrix
association1 <- association


#Remove one node
delete.name <- 'Friend321'
network_matrix1 <- network_matrix[-which(rownames(network_matrix) == delete.name),
                                  -which(colnames(network_matrix) == delete.name)]
association1 <- association[association$Friend != delete.name,]

#To remove additional nodes, repeat the next three lines but with different names
delete.name <- 'Friend321'
network_matrix1 <- network_matrix1[-which(rownames(network_matrix1) == delete.name),
                                   -which(colnames(network_matrix1) == delete.name)]
association1 <- association1[association1$Friend != delete.name,]


#Run the analysis
FB.edges <- graph_from_adjacency_matrix(as.matrix(network_matrix1), mode = "undirected", weighted = TRUE)

FB.degree <- degree(FB.edges)                      #Calculate the number of connections each node has
FB.between <- betweenness(FB.edges)                #Calculate the number of shortest paths running through each node
FB.eigencent <- eigen_centrality(FB.edges)$vector  #Calculate the degree in which one node is connected to all other nodes via different pathways

set.seed(1)
FB.cluster <- cluster_spinglass(FB.edges)          #Calculate clustering within network (only able to when there is one network only)

network.analyses <- lapply(communities(FB.cluster), function(x){                    #Take cluster lists and organize them into an easy-to-read table
  data.frame(name = x,                                                              #Add name of each node
             network = association$Network[match(x,association$Friend)],            #Add the social group this node is from
             rownum = association$num[match(x, association$Friend)],                #Add rownumber from the 'association' dataset
             degree = as.numeric(FB.degree[match(x, names(FB.degree))]),            #Add the degree of each node
             betweenness = as.numeric(FB.between[match(x, names(FB.between))]),     #Add the betweenness of each node
             eigencent = as.numeric(FB.eigencent[match(x, names(FB.eigencent))]))}) #Add the eigenvector centrality of each node

#Sort the network out by degree, betweenness, or eigenvector centrality
(network.analyses <- lapply(network.analyses, function(x)x[order(x[,4]),]))         #Sort by degree          
(network.analyses <- lapply(network.analyses, function(x)x[order(x[,5]),]))         #Sort by betweenness
(network.analyses <- lapply(network.analyses, function(x)x[order(x[,6]),]))         #Sort by eigenvector centrality


par(mfrow = c(1,2), mar = c(1,2,2,2))

#Plot nodes with clusters
set.seed(1)
plot.igraph(FB.edges, layout = layout_nicely,
            vertex.color = factor(association1$Network), 
            vertex.label = NA, 
            palette = rainbow(length(unique(association1$Network))),
            vertex.size = 2, edge.color = NA,
            mark.groups = communities(FB.cluster), 
            mark.label = T, mark.col = rainbow(length(communities(FB.cluster)), alpha = 0.4), 
            mark.lwd = 1.5, mark.border = rainbow(length(communities(FB.cluster))))
legend(title = 'Cluster groups', 'topright', legend = names(communities(FB.cluster)), 
       fill = rainbow(length(communities(FB.cluster))), bty = 'n', ncol = 3, cex = 0.8)

#Plot nodes with edges showing degree
set.seed(1)
plot.igraph(FB.edges, layout = layout_nicely,
            vertex.color = factor(association1$Network), 
            vertex.label = NA, 
            palette = rainbow(length(unique(association1$Network))),
            vertex.size = (20*FB.degree)/max(FB.degree),
            mark.border = rainbow(length(communities(FB.cluster))))
legend(title = 'Node groups', 'topright', legend = levels(factor(association1$Network)), 
       fill = rainbow(length(unique(association1$Network))), bty = 'n', ncol = 2, cex = 0.8)
