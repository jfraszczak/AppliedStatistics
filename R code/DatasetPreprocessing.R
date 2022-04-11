install.packages("plyr")
install.packages("tidyverse")

library(plyr)
library(tidyverse)

loadDataset<-function(dataset_name){
  dataset = read.csv(dataset_name, header=T)
  dataset
}

scale_and_filter_dataset<-function(dataset){
  source("DatasetInformation.R")
  idx=array(unlist(indexes))#create an array of all the elements in the list indexes
  info=array(unlist(scale.info))#create an array of all the elements in the list scale.info
  
  m=length(info)
  
  dataset.scaled<-data.frame(
    matrix(, nrow = nrow(dataset), ncol=0)
  )
  
  for(i in 1:m){
    #scaled by population if in scale.info has 0
    if(info[i]==0){
      dataset.scaled = cbind( dataset.scaled, dataset[idx[i]]/dataset[, 'population'] )
    }else{ 
      dataset.scaled = cbind( dataset.scaled, dataset[idx[i]] )
    }
  }

  dataset.scaled
  
}

selectQuantitativeFeatures<-function(dataset){
  cols_numeric <- unlist(lapply(dataset, is.numeric))
  dataset_numeric <- dataset[ , cols_numeric]
  dataset_numeric
}

getColumnsWithMissingData<-function(dataset){
  is.na(dataset)
  colSums(is.na(dataset))
  which(colSums(is.na(dataset))>0)
  names <- names(which(colSums(is.na(dataset))>0))
  names
}

fillMissingData<-function(dataset){
  dataset_complete<-dataset
  dataset_quantitative <- selectQuantitativeFeatures(dataset)
  features<-getColumnsWithMissingData(dataset_quantitative)
  
  countries<-unique(dataset$country)
  for(country in countries){
    for(feature in features){
      values<-dataset[dataset$Country == country, feature]
      if(all(is.na(values))){
        dataset_complete[dataset_complete$Country == country, feature] <- mean(dataset_complete[,feature], na.rm = TRUE) 
      }
    }
  }
  
  dataset_complete <- dataset_complete %>% 
    group_by(Country) %>% 
    mutate_if(is.numeric, 
              function(x) ifelse(is.na(x), 
                                 median(x, na.rm = TRUE), 
                                 x))
  
  dataset_complete
}

selectSignificatFeatures<-function(dataset, include_country){
  features <- c(
    'First_wave_density', 'Second_wave_density',
    'Life_expectancy', 'Population_density', 'GVA',
    '%_of_people_studying_or_training', '%_of_NEET', '%_early_leavers_from_education',
    'Hospital_beds', 'Farm_labour_force', 'Utilised_agricoltural_area',
    'Hours_worked', 'Unemployement_rate'
    )
  
  if(include_country){
    features <- append(features, 'Country')
  }
  
  dataset<-dataset[, features]
  dataset
}



