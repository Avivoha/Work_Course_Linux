# Load required libraries
library(dplyr)
library(ggplot2)
library(DBI)
library(RSQLite)

# Connect to SQLite database
db <- dbConnect(RSQLite::SQLite(), "/app/data.db")

# Read data from database
data <- dbGetQuery(db, "SELECT * FROM specimens")

# Function to group by species and calculate mean weight
calculate_mean_weight <- function() {
  result <- data %>%
    group_by(species) %>%
    summarise(Mean_Weight = mean(weight, na.rm = TRUE))
  write.table(result, "/app/txt.outputs_R_5", append=TRUE, sep="\t", col.names=TRUE, row.names=FALSE)
  print(result)
}

# Function to calculate total weight by species
calculate_total_weight <- function() {
  result <- data %>%
    group_by(species) %>%
    summarise(Total_Weight = sum(weight, na.rm = TRUE))
  write.table(result, "/app/txt.outputs_R_5", append=TRUE, sep="\t", col.names=TRUE, row.names=FALSE)
  print(result)
}

# Function to sort data by weight
sort_by_weight <- function() {
  result <- data %>% arrange(desc(weight))
  write.table(result, "/app/txt.outputs_R_5", append=TRUE, sep="\t", col.names=TRUE, row.names=FALSE)
  print(result)
}

# Function to plot weight distribution by sex
plot_weight_distribution <- function() {
  plot <- ggplot(data, aes(x = sex, y = weight)) +
    geom_boxplot() +
    ggtitle("Weight Distribution by Sex")
  ggsave("/app/weight_distribution.png", plot = plot)
}

# Get command-line arguments
args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  cat("Usage: Rscript analysis.R <option>\n")
  cat("1 - Group by Species and Calculate Mean Weight\n")
  cat("2 - Calculate the Total Weight by Species\n")
  cat("3 - Sorting the Data by Weight\n")
  cat("4 - Plotting to Image Weight Distribution by Sex\n")
  quit(status=1)
}

choice <- as.integer(args[1])

# Execute the chosen function
if (!is.na(choice)) {
  if (choice == 1) {
    calculate_mean_weight()
  } else if (choice == 2) {
    calculate_total_weight()
  } else if (choice == 3) {
    sort_by_weight()
  } else if (choice == 4) {
    plot_weight_distribution()
  } else {
    cat("Invalid choice. Please use a number between 1 and 4.\n")
    quit(status=1)
  }
} else {
  cat("Invalid input. Please use a number between 1 and 4.\n")
  quit(status=1)
}

# Close database connection
dbDisconnect(db)
