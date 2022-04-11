
#six categories of interest: education, population, healthcare, mobility, primary sector, economy
#the order follows the order presented in the report

#------------------------Renaming the features----------------------------------
colnames(dataset) <- c('NUTS','air_passengers','avalaible_hospital_beds','death_rate_scaled_on_100k',
                       'total_compensation_of_employees_x10^6','deaths','%_of_early_leavers_from_education',
                       'sum_of_hours_worked_x1000','farm_labour_force','health_personnel','discharges_after_respiratory_disease',
                       'life_expectancy','longterm_beds_scaled_on_100k','gdp_x10^6','%_of_people_studying_or_training',
                       'pop_density_scaled_on_1km^2','population','students','GVA_in_%','vehicles','students_in_tertiary_education',
                       'unemployement_rate_in_%','utilised_agricoltural_area','NEET_%','cases_by_population_first_wave',
                       'cases_by_population_second_wave','country','longitude','latitude')


#----------information about how the database is ordered-----------------------
indexes = list(
  #names = colnames(dataset),
  education        = c(7,21,24,15,18),
  population       = c(12,16,4,6),
  healthcare       = c(11,13,10,3),
  mobility         = c(2,20),
  primary_sector   = c(9,23),
  economy_category = c(22,8,19,5,14), #TO CHECK IF 14(=nama_10r_2gdp) IS THE GDP
  coordinates = c(28,29),
  coutry = c(27),
  cases = c(25, 26)
  
  #if want to add something else just put its position on the dataset
  #eg:>> coordinates = c(28,29);
)
#TO TAKE DATAFRAME RELATED TO A CERTAIN CATEGORY 
# EXAMPLE: >> dataset[indexes$education]

#---------informatio about how our dataset is scaled--------------------------
scale.info = list(
  #0      if it is in absolute number 
  #1      if it is already scaled
  #1e3    if it is in percentage
  #1e4    if it is scaled x1'000 inhabitants
  #1e5    if it is scaled x100'000 inhabitants
  #-1     if it is wrong to scale with population or better to do not scale
  #       (to scale manually if really needed)
  education        = c(-1,0,-1,-1,0),
  #obs: early level is in percentage but 
  #over the total number of people who joined schools
  population       = c(-1,-1,1e5,0),
  healthcare       = c(0,1e5,0,1e5),
  mobility         = c(1e3,0),
  primary_sector   = c(1,-1),
  economy_category = c(100,-1,-1,-1,-1),
  coordinates = c(-1, -1),
  coutry = c(-1),
  cases = c(1, 1)
  #   some economics data can be scaled but i don't think it is needed
)




