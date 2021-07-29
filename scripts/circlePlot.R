
ipak = function(pkg){
  # helper function to check and install packages
  new.pkg = pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)){
    install.packages(new.pkg, dependencies = TRUE, repos = "http://cran.us.r-project.org")
  }
  # load all required packages
  sapply(pkg, require, character.only = TRUE, quietly = TRUE)
}

get_ct = function(ct){
  ct = read.table(ct, skip = 1)
  return(ct)
}

generate_circle_plot = function(ct, id, color = "purple", resid_offset = 1, color_labels = FALSE, width = 2, gaps = 1, scale_using_cs = FALSE){
  # Origin on top, then groups, then subgroups
  hierarchy = data.frame(from="origin", to=c(paste(rep("gap", gaps), 1:gaps, sep = ""), paste(ct$V2, ct$V1+resid_offset, sep = "")))
  info = data.frame(resid = ct$V1)
  ct = ct[ct$V5 != 0, ]
  # create a vertices data.frame. One line per object of our hierarchy, giving features of nodes.
  vertices = data.frame(name = unique(c(as.character(hierarchy$from), as.character(hierarchy$to))) )
  # Create a graph object with the igraph library
  mygraph = graph_from_data_frame( hierarchy, vertices=vertices )
  # customize vertices
  vertices$node_color = "black"
  vertices$node_color[grepl("gap", vertices$name)] = "white"
  vertices$size = 3
  vertices$size[grepl("origin", vertices$name)] = 0
  vertices$size[grepl("gap", vertices$name)] = 0
  vertices$resn = substr(vertices$name, 1, 1)
  vertices$color = "red"
  vertices$color[vertices$resn == "A"] = "orange"
  vertices$color[vertices$resn == "C"] = "red"
  vertices$color[vertices$resn == "G"] = "lightblue"
  vertices$color[vertices$resn == "U"] = "lightgreen"
  vertices$name[grepl("origin", vertices$name)] = ""
  vertices$name[grepl("gap", vertices$name)] = ""
  if (!color_labels){vertices$color = "black"}
  # make circle plot
  p = ggraph(mygraph, layout = 'dendrogram', circular = TRUE) + 
    geom_edge_diagonal(alpha=0.0) +
    geom_conn_bundle(data = get_con(from = ct$V1+gaps+1, to = ct$V5+gaps+1), alpha=1, width=width, tension = 1, colour = color) +
    geom_node_point(aes(filter = leaf, x = x*1.05, y=y*1.05), size = vertices$size[-1], colour = vertices$node_color[-1]) +
    geom_node_text(aes(label = substr(vertices$name, 1, 1), x = x*1.2, y=y*1.2), colour = vertices$color) +
    geom_node_text(aes(label = substr(vertices$name, 2, 3), x = x*1.35, y=y*1.35), colour = vertices$color) +
    theme_void()
  return(p)
}

packages <- c("optparse", "ggplot2", "igraph", "ggraph", "tidygraph")
suppressPackageStartupMessages(ipak(packages))

option_list = list(
  make_option(c("-i","--identification"), type = "character", default = "user",
              help = "name of output file"),
  make_option(c("-o","--output"), type = "character", default = "output.pdf",
              help = "name of output file")
)

parser = OptionParser(usage = "%prog [options] path_to_ct_file",
                      option_list = option_list)
arguments = parse_args(parser, positional_arguments = TRUE)
opt = arguments$options

if(length(arguments$args) != 1) {
  cat("Incorrect number of required positional arguments\n\n")
  print_help(parser)
  stop()
} else {
  cat("CirclePlotMaker\n")
  cat("Author: Aaron T. Frank\n")

  # get arguments
  ct_file_path = arguments$args[1]
  output_file_path = opt$output
  id = opt$identification
  
  # read in CT
  ct = get_ct(ct_file_path)
  
  # make and print circlePlot
  pdf(file = output_file_path, width = 1.7*5.027778, height = 1.7*4.763889)
  p = generate_circle_plot(ct, id, color = "grey", gaps = 1, scale_using_cs = FALSE, resid_offset = 0)
  print(p)
  dev.off()
}
