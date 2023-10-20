#####################################################################################X
##
##    File name:        "Climate.R"
##
##    Module of:        "EnergyProfile.R"
##
##    Task:             Energy Profile Procedure
##                      Preparation of climate data,
##                      by use of building localisation (postcode)
##
##    Method:           MOBASY real climate
##                      (https://www.iwu.de/forschung/energie/mobasy/)
##
##    Project:          MOBASY
##
##    Author:           Tobias Loga (t.loga@iwu.de)
##                      IWU - Institut Wohnen und Umwelt, Darmstadt / Germany
##
##    Created:          22-04-2022
##    Last changes:     02-06-2023
##
#####################################################################################X
##
##    R-Script derived from
##    > Excel workbook "EnergyProfile.xlsm" sheet "Data.out.TABULA"
##    > Excel workbook "Gradtagzahlen-Deutschland.xlsx"
##
#####################################################################################X




#####################################################################################X
##  Dependencies ------
#
## R data package clidamonger
# This data package provides up-to-date climate data for Germany (updated twice a year).
#
#
## Script "CliDaMon-Functions.R"
## Functions CliDaMon::ClimateByMonth () and ResultDataframe_ClimateByMonth ()
# The generic function ClimateByMonth () is used to provide climate data for a given
# postcode and a specified period by providing values for 12 months (of a
# specific year or of a period of n years - in the latter case the 12 monthly
# values are averaged over all years)


#####################################################################################X
##  Overview of functions ------

# Functions included in the script below

# ClimateLibValues ()
# This function provides national or regional long-term average
# climate data from the TABULA library.
# Result: 13 additional vectors in "DataCalc" with suffix "_Lib"

# ClimateStationValues ("LTA", Data_Calc)
# This function provides the long-term average climate data
# by requested weather station or by postcode.
# Result: 13 additional vectors in "DataCalc" with suffix "_LTA_Stations"

# ClimateStationValues ("Period", Data_Calc)
# This function provides climate data for a given period
# by requested weather station or by postcode.
# Result: 13 additional vectors in "DataCalc" with suffix "_Stations"

# ClimateForPhysicalModel ()
# This function provides the input data for the physical model.
# The following climate is assigned depending on the first part of
# "Code_Type_ConsiderActualClimate":
# (1) "Standard": Library values (climate variables with suffix "_Lib")
# (2) "LocalLTA":Long-term averages for a given location (suffix "_LTA_Stations")
# (3) "LocalPeriod": Specific period for a given location (suffix "_Stations")
# Result of the function:
# 13 additional vectors in "DataCalc" without suffix (pure variable names)
# used as input for the physical model

# ClimateCalibration ()
# Factors are provided for calibrating the terms in the energy balance equation
# to the climate conditions of the specific years considered in the
# comaparison of calculated and metered consumption.
# The factors are provided by calculating the ratio of the climate data
# of the consumption period to the climate data of the physical model:
# for degree days and for solar radiation separately.
# This function is not applied to the building datasets as a whole but to the
# comparison slots of single buildings (currently 9 slots).






#####################################################################################X
##  Input variables (table "Data.Building") ------
#####################################################################################X

# ID_Zone_LocationBuilding
#
#
# Code_Type_ConsiderActualClimate
# 1	Standard
# 2	LocalLTA
# 3	LocalPeriod
# 4	Standard_LocalLTA
# 5	Standard_LocalPeriod
# 6	LocalLTA_LocalPeriod
# 7	_NA_
#
#
# theta_Base_Input
#
#
# Code_Type_ClimateCorrection
# 1	Correction_Temperature
# 2	Correction_Temperature_Solar
# 3	_NA_
#
#
# Code_SelectionType_ClimateLib
# 1	Functional
# 2	Manual
# 3	_NA_
#
#
# Code_SelectionType_ActualClimate
# 1	Functional
# 2	Manual_LocationID
# 3	Manual_ClimateID
# 4	_NA_
#
#
## The use of the following manual input variables is not yet
## implemented in the R script.
# ID_ActualClimate_Manual_Location
# ID_ActualClimate_Manual_Temperature_1
# ID_ActualClimate_Manual_Temperature_2
# ID_ActualClimate_Manual_Temperature_3
# Factor_Weighting_ActualClimate_Manual_Temperature_1
# Factor_Weighting_ActualClimate_Manual_Temperature_2
# Factor_Weighting_ActualClimate_Manual_Temperature_3
# ID_ActualClimate_Manual_Solar
#
#
# Code_ActualClimate_TypePeriodSelection
# 1	Functional
# 2	Manual
# 3	_NA_
#
#
# Year_Start_ActualClimate_Manual
# Month_Start_ActualClimate_Manual
# n_Year_ActualClimate_Manual



#####################################################################################X
#  FUNCTION SCRIPTS ------
#####################################################################################X

# . -----


#####################################################################################X
## FUNCTION "ClimateLibValues ()" -----
#####################################################################################X


ClimateLibValues <- function (

  myDataCalc_ClimLib,
  myParTab_Climate

) {

  ###################################################################################X
  # 1  DESCRIPTION   -----
  ###################################################################################X

  # This function provides national or regional long-term average
  # climate data from the TABULA library.
  # Result: 13 additional vectors in "DataCalc" with suffix "_Lib"



  ###################################################################################X
  # 2  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X
  ## After debugging: Comment this section

  # myDataCalc_ClimLib <- Data_Calc


  ###################################################################################X
  # 3  FUNCTION SCRIPT   -----
  ###################################################################################X

  ## Initialisation

  myList_Variables <-
    c (
      "theta_e_Base_Lib",
      "HeatingDays_Lib",
      "theta_e_Lib",
      "I_Sol_HD_Hor_Lib",
      "I_Sol_HD_East_Lib",
      "I_Sol_HD_South_Lib",
      "I_Sol_HD_West_Lib",
      "I_Sol_HD_North_Lib",
      "I_Sol_Year_Hor_Lib",
      "I_Sol_Year_East_Lib",
      "I_Sol_Year_South_Lib",
      "I_Sol_Year_West_Lib",
      "I_Sol_Year_North_Lib"
    )

  myDataCalc_ClimLib [ , myList_Variables] <- NA
  # Variables must be existing, even if no values can be assigned


  ## Get values from library table

  myDataCalc_ClimLib$Code_Climate_Lib <- "DE.N"

  myDataCalc_ClimLib$theta_e_Base_Lib <-
    Value_ParTab_Vector (myParTab_Climate,
                         myDataCalc_ClimLib$Code_Climate_Lib,
                         "Theta_e_Base")

  myDataCalc_ClimLib$HeatingDays_Lib <-
    Value_ParTab_Vector (myParTab_Climate,
                         myDataCalc_ClimLib$Code_Climate_Lib,
                         "HeatingDays")

  myDataCalc_ClimLib$theta_e_Lib <-
    Value_ParTab_Vector (myParTab_Climate,
                         myDataCalc_ClimLib$Code_Climate_Lib,
                         "Theta_e")

  myDataCalc_ClimLib$I_Sol_HD_Hor_Lib <-
    Value_ParTab_Vector (myParTab_Climate,
                         myDataCalc_ClimLib$Code_Climate_Lib,
                         "I_Sol_Hor")

  myDataCalc_ClimLib$I_Sol_HD_East_Lib <-
    Value_ParTab_Vector (myParTab_Climate,
                         myDataCalc_ClimLib$Code_Climate_Lib,
                         "I_Sol_East")

  myDataCalc_ClimLib$I_Sol_HD_South_Lib <-
    Value_ParTab_Vector (myParTab_Climate,
                         myDataCalc_ClimLib$Code_Climate_Lib,
                         "I_Sol_South")

  myDataCalc_ClimLib$I_Sol_HD_West_Lib <-
    Value_ParTab_Vector (myParTab_Climate,
                         myDataCalc_ClimLib$Code_Climate_Lib,
                         "I_Sol_West")

  myDataCalc_ClimLib$I_Sol_HD_North_Lib <-
    Value_ParTab_Vector (myParTab_Climate,
                         myDataCalc_ClimLib$Code_Climate_Lib,
                         "I_Sol_North")

  myDataCalc_ClimLib$I_Sol_Year_Hor_Lib <-
    Value_ParTab_Vector (myParTab_Climate,
                         myDataCalc_ClimLib$Code_Climate_Lib,
                         "I_Sol_Year_Hor")

  myDataCalc_ClimLib$I_Sol_Year_East_Lib <-
    Value_ParTab_Vector (myParTab_Climate,
                         myDataCalc_ClimLib$Code_Climate_Lib,
                         "I_Sol_Year_East")

  myDataCalc_ClimLib$I_Sol_Year_South_Lib <-
    Value_ParTab_Vector (myParTab_Climate,
                         myDataCalc_ClimLib$Code_Climate_Lib,
                         "I_Sol_Year_South")

  myDataCalc_ClimLib$I_Sol_Year_West_Lib <-
    Value_ParTab_Vector (myParTab_Climate,
                         myDataCalc_ClimLib$Code_Climate_Lib,
                         "I_Sol_Year_West")

  myDataCalc_ClimLib$I_Sol_Year_North_Lib <-
    Value_ParTab_Vector (myParTab_Climate,
                         myDataCalc_ClimLib$Code_Climate_Lib,
                         "I_Sol_Year_North")

    return (myDataCalc_ClimLib)

} # End of function ClimateLibValues ()


## End of the function ClimateLibValues () -----
#####################################################################################X


# . -----





#####################################################################################X
## FUNCTION "ClimateStationValues ()" -----
#####################################################################################X


ClimateStationValues <- function (

  myCode_TypeClimateYear,    # Possible values: "LTA", "Period"
  myDataCalc_ClimateStation, # Dataframe Data_Calc
  # myMonth_Start = NA,
  # myYear_Start = NA,
  # myNumber_Years = NA

  # Tables from  data package: "clidamonger" "Climate Data Monthly Germany"
  myClimateData_PostCodes = NA,
  myClimateData_StationTA = NA,
  myClimateData_TA_HD     = NA,
  myClimateData_Sol       = NA,
  myParTab_SolOrientEst   = NA

) {

  cat ("ClimateStationValues (", myCode_TypeClimateYear, ")", fill = TRUE)


  ###################################################################################X
  # 1  DESCRIPTION  -----
  ###################################################################################X

  # The result vectors created by this function depend
  # on the input parameter "myCode_TypeClimateYear"

  # ClimateStationValues ("LTA", Data_Calc)
  # This function provides the long-term average climate data
  # by requested weather station or by postcode.
  # Result: 13 additional vectors in "DataCalc" with suffix "_LTA_Stations"

  # ClimateStationValues ("Period", Data_Calc)
  # This function provides climate data for a given period
  # by requested weather station or by postcode.
  # Result: 13 additional vectors in "DataCalc" with suffix "_Stations"


  ###################################################################################X
  # 2  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X


  ## After debugging: Comment this section


  ## Version 1

    # myClimateData_PostCodes <-
    #   MobasyData$Lib_ClimateStation$ClimateData_PostCodes
    #
    # myClimateData_StationTA <-
    #   MobasyData$Lib_ClimateStation$ClimateData_StationTA
    #
    # myClimateData_TA_HD <-
    #   MobasyData$Lib_ClimateStation$ClimateData_TA_HD
    #
    # myClimateData_Sol <-
    #   MobasyData$Lib_ClimateStation$ClimateData_Sol
    #
    # myParTab_SolOrientEst <-
    #   MobasyData$Lib_ClimateStation$ParTab_SolOrientEst
    #
    #
    # myDataCalc_ClimateStation <- MobasyData$Data_Calc
    # #myDataCalc_ClimateStation <- Data_Calc [Data_Calc$ID_Dataset == "DE.MOBASY.BV.0017.05", ]
    # #myDataCalc_ClimateStation <- Data_Calc [Data_Calc$ID_Dataset == "DE.MOBASY.WBG.0008.05", ]
    # #myDataCalc_ClimateStation <- Data_Calc [Data_Calc$ID_Dataset == "DE.MOBASY.NH.0057.05", ]
    # # myCode_TypeClimateYear <- "Period" # "LTA", "Period"
    #  myCode_TypeClimateYear <- "LTA" # "LTA", "Period"
    #
    # # myMonth_Start <- 7
    # # myYear_Start <- 2020
    # # myNumber_Years <- 4


  ## Version 2
#
#   myClimateData_PostCodes <-
#     as.data.frame (clidamonger::tab.stationmapping)
#   # Name of the original table is misleading --> better to be changed
#   # (also in the Excel workbook)
#
#   myClimateData_StationTA <-
#     as.data.frame (clidamonger::list.station.ta)
#
#   myClimateData_TA_HD <-
#     as.data.frame (clidamonger::data.ta.hd)
#
#   myClimateData_Sol <-
#     as.data.frame (clidamonger::data.sol)
#
#   myParTab_SolOrientEst <-
#     as.data.frame (clidamonger::tab.estim.sol.orient)
#
#
#   myDataCalc_ClimateStation <- Data_Calc
#   #myDataCalc_ClimateStation <- Data_Calc [Data_Calc$ID_Dataset == "DE.MOBASY.BV.0017.05", ]
#   #myDataCalc_ClimateStation <- Data_Calc [Data_Calc$ID_Dataset == "DE.MOBASY.WBG.0008.05", ]
#   #myDataCalc_ClimateStation <- Data_Calc [Data_Calc$ID_Dataset == "DE.MOBASY.NH.0057.05", ]
#   myCode_TypeClimateYear <- "Period" # "LTA", "Period"
#   # myCode_TypeClimateYear <- "LTA" # "LTA", "Period"
#
#   # myMonth_Start <- 7
#   # myYear_Start <- 2020
#   # myNumber_Years <- 4



  # # Test
  # myDataCalc_ClimateStation$ID_Zone_LocationBuilding [2] <- 13469
  # myDataCalc_ClimateStation$ID_Zone_LocationBuilding [5] <- 64625
  #
  # myDataCalc_ClimateStation$Year_Start_ActualClimate_Manual [1] <- NA
  # myDataCalc_ClimateStation$Month_Start_ActualClimate_Manual [1] <- NA
  # myDataCalc_ClimateStation$n_Year_ActualClimate_Manual [1] <- NA


  ###################################################################################X
  # 3  FUNCTION SCRIPT   -----
  ###################################################################################X

  myCount_Dataset <-
    nrow (myDataCalc_ClimateStation)

  myDF_Internal <-
    as.data.frame (
      cbind (
        myDataCalc_ClimateStation$ID_Dataset
      )
    )

  myDF_Internal$theta_e_Base <-
    AuxFunctions::Replace_NA (
      myDataCalc_ClimateStation$theta_Base_Input,
      12 # [°C]
    )



  # For test, can be deleted
  #myDataCalc_ClimateStation$Code_SelectionType_ActualClimate [1] <- "Manual_LocationID"


  myDataCalc_ClimateStation$Code_SelectionType_ActualClimate <-
    AuxFunctions::Replace_NA (
      myDataCalc_ClimateStation$Code_SelectionType_ActualClimate,
      "Manual_ClimateID"
    )

  myDataCalc_ClimateStation$ID_PostCode_Calc <-
    AuxFunctions::Format_Integer_LeadingZeros (
      as.numeric (
        ifelse (
          myDataCalc_ClimateStation$Code_SelectionType_ActualClimate ==
            "Manual_LocationID",
          AuxFunctions::xl_RIGHT (
            myDataCalc_ClimateStation$ID_ActualClimate_Manual_Location, 5
          ),
          myDataCalc_ClimateStation$ID_Zone_LocationBuilding
        )
      ),
      5
    )


  if (myCode_TypeClimateYear == "LTA") {

    myDF_Internal$Month_Start <- 1

    myDF_Internal$Year_Start <-  myClimateData_TA_HD$Year_PeriodStart_LTA [1]

    myDF_Internal$Number_Years <-
      myClimateData_TA_HD$Year_PeriodEnd_LTA [1] -
        myClimateData_TA_HD$Year_PeriodStart_LTA [1] + 1

  } else {

# 2023-10-20: Check this section

    # if (myDataCalc_ClimateStation$Code_ActualClimate_TypePeriodSelection ==
    #     "Manual") {

      myDF_Internal$Month_Start <-
        myDataCalc_ClimateStation$Month_Start_ActualClimate_Manual

      myDF_Internal$Year_Start <-
        myDataCalc_ClimateStation$Year_Start_ActualClimate_Manual

      myDF_Internal$Number_Years <-
        myDataCalc_ClimateStation$n_Year_ActualClimate_Manual

    # } else {
    #   # Do nothing
    #   # The three variables are required as input in this case
    # }

  }


  ## Initialisation of result dataframe

  myResult <-
    as.data.frame (
      matrix (NA, myCount_Dataset, 13)
    )

  ResultColNames <-
    c (
      "HD",
      "TA_HD",
      "G_Hor_HD",
      "G_E_HD",
      "G_S_HD",
      "G_W_HD",
      "G_N_HD",
      "G_Hor",
      "G_E",
      "G_S",
      "G_W",
      "G_N"
    )

  StationInfoColNames <-
    c (
    "Code_Station",
    "Name_Station",
    "Factor_Weighting",
    "Factor_Consider"
    )


  colnames (myResult) <- c ("ID_Dataset", ResultColNames)

  myResult$ID_Dataset <- myDF_Internal [ , 1]


  # Initialisation for testing the loop
  i_Dataset <- 1

  for (i_Dataset in (1:myCount_Dataset)) {

    if ( ! (is.na (myDF_Internal$Month_Start  [i_Dataset])  |
            is.na (myDF_Internal$Year_Start   [i_Dataset])  |
            is.na (myDF_Internal$Number_Years [i_Dataset])
            )
         ) { # if period is defined

      myResultList_ClimateByMonth <-
        CliDaMon::ClimateByMonth (

          # Tables from  data package: "clidamonger" "Climate Data Monthly Germany"
          myClimateData_PostCodes = myClimateData_PostCodes,
          myClimateData_StationTA = myClimateData_StationTA,
          myClimateData_TA_HD     = myClimateData_TA_HD,
          myClimateData_Sol       = myClimateData_Sol,
          myParTab_SolOrientEst   = myParTab_SolOrientEst,

          Indicator_Type_LocationBuilding =
            ifelse (
              myDataCalc_ClimateStation$Code_SelectionType_ActualClimate [i_Dataset] ==
                "Manual_ClimateID" ,
              2,
              1
            ),
          # 1: by post code, 2: by weather station

          Indicator_Type_AssignStationToPostcode = 2,
          # 1: the closest, 2: the three closest stations
          # (weighted by reciprocal distance)

          PostCode =
            myDataCalc_ClimateStation$ID_PostCode_Calc [i_Dataset],

          Code_ClimateStation =
            myDataCalc_ClimateStation$ID_ActualClimate_Manual_Temperature_1 [i_Dataset],
          # The manual input of the other two stations is not used
          # The implementation requires an extension of the generic
          # function "ClimeatByMonth ()".

          Indicator_ExcludeSelectedStation = 0,
          # 0: Do not exclude = standard entry

          Month_Start = myDF_Internal$Month_Start [i_Dataset],
          Year_Start  = myDF_Internal$Year_Start [i_Dataset],
          n_Year      = myDF_Internal$Number_Years [i_Dataset],

          Temperature_HDD_Base =
            myDF_Internal$theta_e_Base [i_Dataset],

          Temperature_HDD_Room = 20, # [°C]

          Degree_Inclination_Solar = 45 # arc degree

        )



      ## The function "CliDaMon::ClimateByMonth" returns a list of dataframes
      # myResultList_ClimateByMonth [[5]] # Show the list of dataframes


      myDF_ClimMon <-
        myResultList_ClimateByMonth [[1]]
      #   ResultDataframe_ClimateByMonth (myResultList_ClimateByMonth, myIndex_DF = 1)
      # clipr::write_clip(myDF_ClimMon)


      # myDF_ClimMon_Evaluation <-
      # myResultList_ClimateByMonth [[2]]
      # # ResultDataframe_ClimateByMonth (myResultList_ClimateByMonth, myIndex_DF = 2)

      myDF_StationInfo_TA <-
        myResultList_ClimateByMonth [[3]]
        # ResultDataframe_ClimateByMonth (myResultList_ClimateByMonth, myIndex_DF = 3)
      #
      # myDF_FunctionParameters <-
      #   myResultList_ClimateByMonth [[4]]
      # # ResultDataframe_ClimateByMonth (myResultList_ClimateByMonth, myIndex_DF = 4)


      myResult [i_Dataset, ResultColNames]  <-
        myDF_ClimMon [13, ResultColNames] # row 13 = total of 12 months

      myResult [i_Dataset, paste0 (StationInfoColNames, "_1")] <-
        myDF_StationInfo_TA [1, StationInfoColNames]
      myResult [i_Dataset, paste0 (StationInfoColNames, "_2")] <-
        myDF_StationInfo_TA [2, StationInfoColNames]
      myResult [i_Dataset, paste0 (StationInfoColNames, "_3")] <-
        myDF_StationInfo_TA [3, StationInfoColNames]


    } else {

      myResult [i_Dataset, ResultColNames]  <-
        NA # row 13 = total of 12 months

      myResult [i_Dataset, paste0 (StationInfoColNames, "_1")] <-
        NA
      myResult [i_Dataset, paste0 (StationInfoColNames, "_2")] <-
        NA
      myResult [i_Dataset, paste0 (StationInfoColNames, "_3")] <-
        NA




    } # End if period is defined / not defined

  } # End of loop by i_Dataset




  if (myCode_TypeClimateYear == "LTA") {

    myDataCalc_ClimateStation$Code_LTAStation_1 <-
      myResult$Code_Station_1
    myDataCalc_ClimateStation$Name_LTAStation_1 <-
      myResult$Name_Station_1
    myDataCalc_ClimateStation$Factor_ActualWeight_LTAStation_1 <-
      myResult$Factor_Weighting_1 * myResult$Factor_Consider_1

    myDataCalc_ClimateStation$Code_LTAStation_2 <-
      myResult$Code_Station_2
    myDataCalc_ClimateStation$Name_LTAStation_2 <-
      myResult$Name_Station_2
    myDataCalc_ClimateStation$Factor_ActualWeight_LTAStation_2 <-
      myResult$Factor_Weighting_2 * myResult$Factor_Consider_2

    myDataCalc_ClimateStation$Code_LTAStation_3 <-
      myResult$Code_Station_3
    myDataCalc_ClimateStation$Name_LTAStation_3 <-
      myResult$Name_Station_3
    myDataCalc_ClimateStation$Factor_ActualWeight_LTAStation_3 <-
      myResult$Factor_Weighting_3 * myResult$Factor_Consider_3

    myDataCalc_ClimateStation$theta_e_Base_LTA_Stations   <-
      myDF_Internal$theta_e_Base
    myDataCalc_ClimateStation$HeatingDays_LTA_Stations   <-
      myResult$HD
    myDataCalc_ClimateStation$theta_e_LTA_Stations   <-
      myResult$TA_HD
    myDataCalc_ClimateStation$I_Sol_HD_Hor_LTA_Stations   <-
      myResult$G_Hor_HD
    myDataCalc_ClimateStation$I_Sol_HD_East_LTA_Stations   <-
      myResult$G_E_HD
    myDataCalc_ClimateStation$I_Sol_HD_South_LTA_Stations   <-
      myResult$G_S_HD
    myDataCalc_ClimateStation$I_Sol_HD_West_LTA_Stations   <-
      myResult$G_W_HD
    myDataCalc_ClimateStation$I_Sol_HD_North_LTA_Stations   <-
      myResult$G_N_HD
    myDataCalc_ClimateStation$I_Sol_Year_Hor_LTA_Stations   <-
      myResult$G_Hor
    myDataCalc_ClimateStation$I_Sol_Year_East_LTA_Stations   <-
      myResult$G_E
    myDataCalc_ClimateStation$I_Sol_Year_South_LTA_Stations   <-
      myResult$G_S
    myDataCalc_ClimateStation$I_Sol_Year_West_LTA_Stations   <-
      myResult$G_W
    myDataCalc_ClimateStation$I_Sol_Year_North_LTA_Stations   <-
      myResult$G_N

  } else {

    myDataCalc_ClimateStation$Code_Station_1 <-
      myResult$Code_Station_1
    myDataCalc_ClimateStation$Name_Station_1 <-
      myResult$Name_Station_1
    myDataCalc_ClimateStation$Factor_ActualWeight_Station_1 <-
      myResult$Factor_Weighting_1 * myResult$Factor_Consider_1

    myDataCalc_ClimateStation$Code_Station_2 <-
      myResult$Code_Station_2
    myDataCalc_ClimateStation$Name_Station_2 <-
      myResult$Name_Station_2
    myDataCalc_ClimateStation$Factor_ActualWeight_Station_2 <-
      myResult$Factor_Weighting_2 * myResult$Factor_Consider_2

    myDataCalc_ClimateStation$Code_Station_3 <-
      myResult$Code_Station_3
    myDataCalc_ClimateStation$Name_Station_3 <-
      myResult$Name_Station_3
    myDataCalc_ClimateStation$Factor_ActualWeight_Station_3 <-
      myResult$Factor_Weighting_3 * myResult$Factor_Consider_3

    myDataCalc_ClimateStation$theta_e_Base_Stations   <-
      myDF_Internal$theta_e_Base
    myDataCalc_ClimateStation$HeatingDays_Stations   <-
      myResult$HD
    myDataCalc_ClimateStation$theta_e_Stations   <-
      myResult$TA_HD
    myDataCalc_ClimateStation$I_Sol_HD_Hor_Stations   <-
      myResult$G_Hor_HD
    myDataCalc_ClimateStation$I_Sol_HD_East_Stations   <-
      myResult$G_E_HD
    myDataCalc_ClimateStation$I_Sol_HD_South_Stations   <-
      myResult$G_S_HD
    myDataCalc_ClimateStation$I_Sol_HD_West_Stations   <-
      myResult$G_W_HD
    myDataCalc_ClimateStation$I_Sol_HD_North_Stations   <-
      myResult$G_N_HD
    myDataCalc_ClimateStation$I_Sol_Year_Hor_Stations   <-
      myResult$G_Hor
    myDataCalc_ClimateStation$I_Sol_Year_East_Stations   <-
      myResult$G_E
    myDataCalc_ClimateStation$I_Sol_Year_South_Stations   <-
      myResult$G_S
    myDataCalc_ClimateStation$I_Sol_Year_West_Stations   <-
      myResult$G_W
    myDataCalc_ClimateStation$I_Sol_Year_North_Stations   <-
      myResult$G_N

  }


  return (myDataCalc_ClimateStation)


} # End of function ClimateStationValues ()


## End of the function ClimateStationValues () -----
#####################################################################################X


# . -----




#####################################################################################X
## FUNCTION "ClimateForPhysicalModel ()" -----
#####################################################################################X


ClimateForPhysicalModel <- function (

    myDataCalc_ClimatePhysMod,
    myCode_ForceClimateType = NA

) {

  cat ("ClimateForPhysicalModel ()", fill = TRUE)


  ###################################################################################X
  # 1  DESCRIPTIOM  -----
  ###################################################################################X

  # ClimateForPhysicalModel ()
  # This function provides the input data for the physical model.
  # The variable "Code_Type_ConsiderActualClimateFor" contains for
  # each building dataset the information which climate is to be used
  # for the energy performance calculation (physical model).
  #
  # The variable "Code_Type_ConsiderActualClimate" can have the following values:
  # "Standard"
  # "LocalLTA"
  # "LocalPeriod"
  # "Standard_LocalLTA"
  # "Standard_LocalPeriod"
  # "LocalLTA_LocalPeriod"
  #
  # The code primarily determines the climate for the physical model,
  # Those codes consisting of two strings linked by "_" contain a further information:
  # The second code element determines that a correction of the calculation
  # is applied in the comparison of calculation and metered energy consumption
  # (see specific function section "MeterCalc.R").
  #
  # The following climate is assigned depending on the first part of the code:
  # (1) "Standard": Library values (climate variables with suffix "_Lib")
  # (2) "LocalLTA":Long-term averages for a given location (suffix "_LTA_Stations")
  # (3) "LocalPeriod": Specific period for a given location (suffix "_Stations")
  #
  # Result of the function are:
  # 13 additional vectors in "DataCalc" without ending (pure variable names)
  # used as input for the physical model


  ###################################################################################X
  # 2  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X
  ## After debugging: Comment this section

  # myDataCalc_ClimatePhysMod <- Data_Calc

  # myCode_ForceClimateType <- NA
  # myCode_ForceClimateType <- "Lib"


  # myDataCalc_ClimatePhysMod <- Data_Calc [Data_Calc$ID_Dataset == "DE.MOBASY.BV.0017.05", ]
  # myDataCalc_ClimatePhysMod <- Data_Calc [Data_Calc$ID_Dataset == "DE.MOBASY.NH.0057.05", ]


  # The variable "Code_Type_ConsiderActualClimate" can have the following values:
  # "Standard"
  # "LocalLTA"
  # "LocalPeriod"
  # "Standard_LocalLTA"
  # "Standard_LocalPeriod"
  # "LocalLTA_LocalPeriod"


  ###################################################################################X
  # 3  FUNCTION SCRIPT   -----
  ###################################################################################X

  myCount_Dataset <-
    nrow (myDataCalc_ClimatePhysMod)

  myList_Variables <-
    c (
      "theta_e_Base",
      "HeatingDays",
      "theta_e",
      "I_Sol_HD_Hor",
      "I_Sol_HD_East",
      "I_Sol_HD_South",
      "I_Sol_HD_West",
      "I_Sol_HD_North",
      "I_Sol_Year_Hor",
      "I_Sol_Year_East",
      "I_Sol_Year_South",
      "I_Sol_Year_West",
      "I_Sol_Year_North"
    )

  myDataCalc_ClimatePhysMod [ , myList_Variables] <- NA

  myDataCalc_ClimatePhysMod$Code_Type_ConsiderActualClimate

  myDataCalc_ClimatePhysMod$Code_ClimateType_PhysicalModel_Input <-
    ifelse (
      myDataCalc_ClimatePhysMod$Code_Type_ConsiderActualClimate ==
              "LocalPeriod",
            "Stations",
            ifelse ((myDataCalc_ClimatePhysMod$Code_Type_ConsiderActualClimate ==
                       "LocalLTA") |
                      (myDataCalc_ClimatePhysMod$Code_Type_ConsiderActualClimate ==
                         "LocalLTA_LocalPeriod"),
                    "LTA_Stations",
                    "Lib")
            )

  myDataCalc_ClimatePhysMod$Code_ClimateType_PhysicalModel <-
    ifelse (is.na (myCode_ForceClimateType),
            myDataCalc_ClimatePhysMod$Code_ClimateType_PhysicalModel_Input,
            myCode_ForceClimateType)


  i_Dataset <- 1
  CurrentName <- myList_Variables [1]

  for (CurrentName in myList_Variables) {

    for (i_Dataset in (1:myCount_Dataset)) {

      myDataCalc_ClimatePhysMod [
        i_Dataset, CurrentName
      ] <-
        myDataCalc_ClimatePhysMod [
          i_Dataset,
          paste0 (
            CurrentName,
            "_",
            myDataCalc_ClimatePhysMod$Code_ClimateType_PhysicalModel [i_Dataset]
          )
        ]

    } # End loop by i_Dataset

  } # End loop by variable name


  ## Check result values
  myDataCalc_ClimatePhysMod$ID_PostCode_Calc
  myDataCalc_ClimatePhysMod$theta_e_Base
  myDataCalc_ClimatePhysMod$HeatingDays
  myDataCalc_ClimatePhysMod$theta_e
  myDataCalc_ClimatePhysMod$I_Sol_HD_Hor
  myDataCalc_ClimatePhysMod$I_Sol_HD_East
  myDataCalc_ClimatePhysMod$I_Sol_HD_South
  myDataCalc_ClimatePhysMod$I_Sol_HD_West
  myDataCalc_ClimatePhysMod$I_Sol_HD_North
  myDataCalc_ClimatePhysMod$I_Sol_Year_Hor
  myDataCalc_ClimatePhysMod$I_Sol_Year_East
  myDataCalc_ClimatePhysMod$I_Sol_Year_South
  myDataCalc_ClimatePhysMod$I_Sol_Year_West
  myDataCalc_ClimatePhysMod$I_Sol_Year_North


  return (myDataCalc_ClimatePhysMod)


} # End of function ClimateForPhysicalModel ()


## End of the function ClimateForPhysicalModel () -----
#####################################################################################X


# . -----








#####################################################################################X
## FUNCTION "ClimateCalibration ()" -----
#####################################################################################X


ClimateCalibration <- function (
   theta_e_Base               ,      # single value
   theta_i_HDD                ,      # single value
   HeatingDays_PhysMod        ,      # single value
   theta_e_PhysMod            ,      # single value
   HeatingDays_MeterPeriod    ,      # slot vector
   theta_e_MeterPeriod        ,      # slot vector

   I_Sol_HD_Hor_PhysMod       ,      # single value
   I_Sol_HD_East_PhysMod      ,      # single value
   I_Sol_HD_South_PhysMod     ,      # single value
   I_Sol_HD_West_PhysMod      ,      # single value
   I_Sol_HD_North_PhysMod     ,      # single value

   I_Sol_HD_Hor_MeterPeriod       ,      # slot vector
   I_Sol_HD_East_MeterPeriod      ,      # slot vector
   I_Sol_HD_South_MeterPeriod     ,      # slot vector
   I_Sol_HD_West_MeterPeriod      ,      # slot vector
   I_Sol_HD_North_MeterPeriod            # slot vector
)

 {

  ###################################################################################X
  # 1  DESCRIPTIOM  -----
  ###################################################################################X

  # ClimateCalibration ()
  # Factors are provided for calibrating the terms in the energy balance equation
  # to the climate conditions of the specific years considered in the
  # comaparison of calculated and metered consumption.
  # The factors are provided by calculating the ratio of the climate data
  # of the consumption period to the climate data of the physical model.
  # This function is not applied to the building datasets as a whole but to the
  # comparison slots of single buildings (currently 9 slots).
  #
  # Used DataSlotCalc variables:
  #
  # theta_i_HDD   (one value, input: Data_Calc$theta_i_calc)
  # theta_e_PhysMod            (single value)
  # myHeatingDays_PhysMod      (single value)
  # myTheta_e_MeterPeriod      (slot vector)
  # myHeatingDays_MeterPeriod  (slot vector)
  #
  # I_Sol_HD_Hor_PhysMod       (single value)
  # I_Sol_HD_East_PhysMod      (single value)
  # I_Sol_HD_South_PhysMod     (single value)
  # I_Sol_HD_West_PhysMod      (single value)
  # I_Sol_HD_North_PhysMod     (single value)
  #
  # I_Sol_HD_Hor_MeterPeriod       (slot vector)
  # I_Sol_HD_East_MeterPeriod      (slot vector)
  # I_Sol_HD_South_MeterPeriod     (slot vector)
  # I_Sol_HD_West_MeterPeriod      (slot vector)
  # I_Sol_HD_North_MeterPeriod     (slot vector)
  #
  # Result:
  # f_Correction_HDD 	  (slot vector)
  # f_Correction_Sol_HD (slot vector)
  #
  # Result of the function:
  # Two additional vectors in "DataSlotCalc" representing the ratio of the climate data
  # for comparison with metered data to the climate data of the physical model:
  # one vector representing this ratio for the heating degree days (HDD),
  # one vector representing this ratio for the solar global radiation
  # during the heating season.
  # Two correction factors: f_Correction_HDD and f_Correction_Sol_HD


  ###################################################################################X
  # 2  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X
  ## After debugging: Comment this section


  ## First version for Debugging the function without slot data
  # theta_e_Base                <- Data_Calc$theta_e_Base
  # theta_i_HDD                 <- Data_Calc$theta_i_calc
  # HeatingDays_PhysMod         <- Data_Calc$HeatingDays_LTA_Stations
  # theta_e_PhysMod             <- Data_Calc$theta_e_LTA_Stations
  # HeatingDays_MeterPeriod     <- Data_Calc$HeatingDays_Stations
  # theta_e_MeterPeriod         <- Data_Calc$theta_e_Stations
  # I_Sol_HD_Hor_PhysMod        <- Data_Calc$I_Sol_HD_Hor_LTA_Stations
  # I_Sol_HD_East_PhysMod       <- Data_Calc$I_Sol_HD_East_LTA_Stations
  # I_Sol_HD_South_PhysMod      <- Data_Calc$I_Sol_HD_South_LTA_Stations
  # I_Sol_HD_West_PhysMod       <- Data_Calc$I_Sol_HD_West_LTA_Stations
  # I_Sol_HD_North_PhysMod      <- Data_Calc$I_Sol_HD_North_LTA_Stations
  # I_Sol_HD_Hor_MeterPeriod    <- Data_Calc$I_Sol_HD_Hor_Stations
  # I_Sol_HD_East_MeterPeriod   <- Data_Calc$I_Sol_HD_East_Stations
  # I_Sol_HD_South_MeterPeriod  <- Data_Calc$I_Sol_HD_South_Stations
  # I_Sol_HD_West_MeterPeriod   <- Data_Calc$I_Sol_HD_West_Stations
  # I_Sol_HD_North_MeterPeriod  <- Data_Calc$I_Sol_HD_North_Stations


  ###################################################################################X
  # 3  FUNCTION SCRIPT   -----
  ###################################################################################X

  myCount_Slot <-
    length (HeatingDays_MeterPeriod)


  # Heating degree days with difference to base temperature
  # used for correction of consumption values
  # in German: "Heizgradtage"
  HDD_MeterPeriod <-
    (theta_e_Base - theta_e_MeterPeriod) * HeatingDays_MeterPeriod

  HDD_PhysMod <-
    (theta_e_Base - theta_e_PhysMod) * HeatingDays_PhysMod


  # Room heating degree days with difference to room temperature
  # used for correction of the heat loss term of the energy performance calculation
  RHDD_MeterPeriod <-
    (theta_i_HDD - theta_e_MeterPeriod) * HeatingDays_MeterPeriod

  RHDD_PhysMod <-
    (theta_i_HDD - theta_e_PhysMod) * HeatingDays_PhysMod



  f_Correction_HDD <-
    HDD_MeterPeriod / HDD_PhysMod

  f_Correction_RHDD <-
    RHDD_MeterPeriod / RHDD_PhysMod

  I_Sol_HD_Average_MeterPeriod <-
    AuxFunctions::xl_AVERAGE (
      I_Sol_HD_Hor_MeterPeriod,
      I_Sol_HD_East_MeterPeriod,
      I_Sol_HD_South_MeterPeriod,
      I_Sol_HD_West_MeterPeriod,
      I_Sol_HD_North_MeterPeriod
    )

  I_Sol_HD_Average_PhysMod <-
    AuxFunctions::xl_AVERAGE (
      I_Sol_HD_Hor_PhysMod,
      I_Sol_HD_East_PhysMod,
      I_Sol_HD_South_PhysMod,
      I_Sol_HD_West_PhysMod,
      I_Sol_HD_North_PhysMod
    )

  f_Correction_Sol_HD <-
    I_Sol_HD_Average_MeterPeriod / I_Sol_HD_Average_PhysMod


  return (
    cbind (
      f_Correction_HDD,
      f_Correction_RHDD,
      f_Correction_Sol_HD
    )
  )


} # End of function ClimateCalibration ()


## End of the function ClimateCalibration () -----
#####################################################################################X


# . -----




















###################################################################################X
## Test of functions  -----
###################################################################################X
## After testing: Comment this section


# Data_Calc <- ClimateLibValues (Data_Calc)
#
# Data_Calc$theta_e_Lib
# Data_Calc$I_Sol_South_Lib



#















