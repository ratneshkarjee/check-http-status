                                    #########################
#===================================== URL Data Wrangling =======================================#
                                   #########################

# Editor: Ratnesh Karjee
# Email ID: ratnesh.karjee_phd23@ashoka.edu.in/ratneshkarjee@yahoo.com
# Github ID: https://github.com/ratneshkarjee 
# Position: Ph.D Student                                  

                                   
                                   
# Load Packages
library(httr)
library(doParallel)

# Set up parallel backend
cores <- detectCores()
cl <- makeCluster(cores - 1)  # One less than total cores to leave some for the main process
registerDoParallel(cl)

df <- read.csv('file_name.csv')


# Function to check URL status
check_url_status <- function(link) {
  tryCatch({
    status <- status_code(GET(link))
    return(ifelse(status == 200, "active", "not found"))
  }, error = function(e) {
    return("error")
  })
}

# Use 'foreach' to parallelize the loop
result_df <- foreach(i = 1:nrow(df), .packages = c("httr"), .combine = rbind) %dopar% {
  link <- df$URL[i]
  status <- check_url_status(link)
  data.frame(URL = link, Status = status, stringsAsFactors = FALSE)
}

# Stop the parallel back-end
stopCluster(cl)

# Print the results data frame
print(result_df)
combined_df <- cbind(df, result_df)


write.csv(combined_df, 'final_data.csv')