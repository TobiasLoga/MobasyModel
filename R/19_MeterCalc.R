#####################################################################################X
##
##    File name:        "MeterCalc.R"
##
##    Module of:        "EnergyProfile.R"
##
##    Task:             Energy Profile Procedure
##                      Comparison of metered consumption
##                      with appropriate values from calculation model
##
##    Method:           MOBASY real energy balance calculation
##                      (https://www.iwu.de/forschung/energie/mobasy/)
##
##    Project:          MOBASY
##
##    Author:           Tobias Loga (t.loga@iwu.de)
##                      IWU - Institut Wohnen und Umwelt, Darmstadt / Germany
##
##    Created:          24-06-2022
##    Last changes:     17-03-2023
##
#####################################################################################X
##
##    R-Script derived from Excel workbooks / worksheets
##                      "[EnergyProfile.xlsm]Data.out.TABULA"
##                      "[tabula-calculator.xlsx]Tab.Meter.Definition"
##                      "[tabula-calculator.xlsx]Tab.Const.QuantityMetering"
##                      "[tabula-calculator.xlsx]Tab.Meter.Amount"
##                      "[tabula-calculator.xlsx]Calc.Meter.Comparison"
##
#####################################################################################X



#####################################################################################X
#  INTRODUCTION ------
#####################################################################################X

# The script provides functions to be used in the EnergyProfile and MOBASY
# energy performance calculation (reality based physical model)


#####################################################################################X
##  Dependencies ------
#



#####################################################################################X
##  Overview of functions ------

## Functions included in the script below


## PrepareDFMeterValues (myDS)
#
# This function is used to transform the meter data of a single building
# to a dataframe of 120 rows: 40 values by 3 meter devices (M1, M2 and M3)
#
# Call from:
# MeterCalcSingleBuilding ()
#
# Input:
# Dataset of one building myDS
#
# Output:
# myDF_MeterValues (dataframe with 3 x 40 = 120 rows)


## AllocateMeterAmountsToMonths (myMeterAmountData)
#
# This function is used for allocation of the metered amounts of arbitrary periods
# to monthly values.
# The input is consisting of the period start and end date and the metered amount
# for each of the 40 values of the meter devices M1, M2 and M3 (120 rows)
# The metered amount of a period is assigned to 4 x 12 columns,
# representing the months of 4 calendar years.
#
# Call from:
# MeterCalcSingleBuilding ()
#
# Input:
# myMeterAmountData (dataframe with 3 x 40 = 120 rows)
#
# Output:
# myMeterAmountData, supplemeted by result variables,
# especially the 4 x 12 = 36 columns containing the metered amounts by month


## PrepareMeterCalcSlots (myGeneralData, myConsumption)
#
# This function prepares the slots for comparison of metered and calculated data.
# The number of slots is defined by the constant n_Slot_MeterCalcComparison (currently 9).
#
# Call from:
# MeterCalcSingleBuilding ()
#
# Input:
# myGeneralData (Data_Calc dataset of one building)
# myConsumption (dataframe with 3 x 40 = 120 rows)
#
# Output:
# mySlotData



## MeterCalcSlot (mySlotData)
#
# This function performs the actual comparison of metered and calculated data
# for n_Slot_MeterCalcComparison (currently 9) separated slots.
#
# Call from:
# MeterCalcSingleBuilding ()
#
# Input:
# mySlotData (dataframe with 9 rows)
#
# Output:
# mySlotData, supplemeted by result variables




## MeterCalcSingleBuilding (Data_Calc_CMC [i_Dataset])
#
# This function contains the preparation of meter data and
# the comparison with the calculation results.
# The data from
#
# Call from:
# CalcMeeterComparison ()
#
# Input:
# Data_Calc [i_Dataset] --> myDataset
#
# Output:
# Output variables defined in the table "Data.Building" for one dataset


## CalcMeeterComparison (Data_Calc)
#  It includes a loop by building dataset.
#  In the loop the function MeterCalcSingleBuilding () is used (see above).
## Input:
#  Data_Calc --> myData_Calc_CMC
## Output:
#  dataframe "Data_Calc" suppmented by the output variables
#  defined in the table "Data.Building" for all datasets


# . -----

#####################################################################################X
#  FUNCTION SCRIPTS ------
#####################################################################################X

# . -----

#####################################################################################X
## FUNCTION "PrepareDFMeterValues ()" -----
#####################################################################################X


PrepareDFMeterValues <- function (
    myDS,
    myParTab_Meter_EnergyDensity
)

{

  ###################################################################################X
  # A  DESCRIPTIOM  -----
  ###################################################################################X



  ###################################################################################X
  # B  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X
  ## After debugging: Comment this section


  # myDS <-
  #   myDataset     # defined in MeterCalcSingleBuilding ()
  # #  myBuildingDataTables$Data_Calc [1, ]
  #
  # myParTab_Meter_EnergyDensity <-
  #   TabulaTables$ParTab_Meter_EnergyDensity


  ###################################################################################X
  # C  FUNCTION SCRIPT   -----
  ###################################################################################X


  ###################################################################################X
  ## 0  Constants   -----

  Date_Origin_DataTables          <- "1899-12-30"
  ## Excel is said to use 1900-01-01 as day 1 (Windows default) or
  ## 1904-01-01 as day 0 (Mac default), but this is complicated by Excel
  ## incorrectly treating 1900 as a leap year.
  ## So for dates (post-1901) from Windows Excel:
  ##   as.Date(35981, origin = "1899-12-30") # 1998-07-05
  ## and Mac Excel:
  ##   as.Date(34519, origin = "1904-01-01") # 1998-07-05
  ## (these values come from http://support.microsoft.com/kb/214330)
  ## Source: RStudio Help

  n_MeteringDevice <- 3
  ID_MeteringDevice   <- AuxFunctions::Format_Integer_LeadingZeros (1:n_MeteringDevice, 1, "M")
  ID_MeteringDevice_2 <- AuxFunctions::Format_Integer_LeadingZeros (1:n_MeteringDevice, 2, "M")

  n_Sequence_MeterAmount <- 40




  ###################################################################################X
  ## 1  Preparation   -----
  ###################################################################################X

  ###################################################################################X
  ### 1.1  Initialisation   -----

  myIndex_Dataset <- 1 # There is only one dataset in this function (the first)


  ###################################################################################X
  ### 1.2  Preparation of result vectors   -----

  # The creation of result vectors in helps running the whole script
  # even if there are errors in sections (sub functions)

  ColNames_DFMeterValues <- c (
    "ID_MeterAmount"               ,
    "Index_MeterPeriod"            ,
    "ID_MeterDevice"               ,
    "Code_IndexMeterPeriod"        ,
    "Date_Start"                   ,
    "Date_End"                     ,
    "Amount_Input"                 ,
    "Code_PeriodType"              ,
    "Index_Meter_EC_Building"      ,
    "Code_BuildingMeter"           ,
    "A_C_Meter"                    ,
    "Code_Meter"                   ,
    "Unit"                         ,
    "EnergyDensity_EnergyCarrier"  ,
    "Code_Utilisation"             ,
    "Days_Metering"                ,
    "Value_Consumption"            ,
    "Q_meter"                      ,
    "q_const_year"                 ,
    "Q_const_day"                  ,
    "Q_const"                      ,
    "Q_WeatherDependent"           ,
    "Fraction_const"
  )

  myDF_MeterValues <-
    as.data.frame (
      matrix (NA,
              n_Sequence_MeterAmount * n_MeteringDevice,
              length (ColNames_DFMeterValues)
      )
    )

  colnames (myDF_MeterValues) <- ColNames_DFMeterValues

  #myDF_MeterValues$ID_MeterAmount <-


  myDF_MeterValues$ID_MeterDevice <-
    c(
      rep ("M1", n_Sequence_MeterAmount),
      rep ("M2", n_Sequence_MeterAmount),
      rep ("M3", n_Sequence_MeterAmount)
    )

  myDF_MeterValues$Index_MeterPeriod <-
    c(
      1:n_Sequence_MeterAmount,
      1:n_Sequence_MeterAmount,
      1:n_Sequence_MeterAmount
    )

  # Delete, not used
  # myDF_MeterValues$Code_IndexMeterPeriod <-
  #     AuxFunctions::Format_Integer_LeadingZeros (myDF_MeterValues$Index_MeterPeriod, 3)


  myDF_MeterValues$ID_MeterAmount <-
    paste0 (
      myDF_MeterValues$ID_MeterDevice,
      ".",
      AuxFunctions::Format_Integer_LeadingZeros (
        myDF_MeterValues$Index_MeterPeriod, 3)
        )

  rownames (myDF_MeterValues) <- myDF_MeterValues$ID_MeterAmount



  ###################################################################################X
  ##  2  Calculation   -----
  ###################################################################################X


  ###################################################################################X
  ###  2.1  Specification of the  metering devices <M1> <M2> <M3>  -----
  ###################################################################################X

  # Calculation sheet in EnergyProfile.xlsm:
  # "[tabula-calculator.xlsx]Tab.Meter.Definition"

  # Specification of the (maximal) 3 metering devices
  # <M1> <M2> <M3> ("Tab.Meter.Definition")
  # Information is added about the features of the metered quantity
  # by use of the "tabula-values.xlsx" library
  # and about the utilisation from the building data input


  DF_MeterDevice <- NA

  DF_MeterDevice <-
    as.data.frame (
      c (
        "<EnergyProfile.Query.Current>.<M1>",
        "<EnergyProfile.Query.Current>.<M2>",
        "<EnergyProfile.Query.Current>.<M3>"
      ),
      row.names = c ("M1",
                     "M2",
                     "M3")
    )

  colnames (DF_MeterDevice) <-  c("Code_BuildingMeter")

  DF_MeterDevice$A_C_Meter	<- NA
  DF_MeterDevice$Code_EC	<- NA
  DF_MeterDevice$Unit_EC	<- NA
  DF_MeterDevice$Indicator_Utilisation_Metering_Heating	<- NA
  DF_MeterDevice$Indicator_Utilisation_Metering_DHW	<- NA
  DF_MeterDevice$Indicator_Utilisation_Metering_Cooling	<- NA
  DF_MeterDevice$Indicator_Utilisation_Metering_VentilationAux	<- NA
  DF_MeterDevice$Indicator_Utilisation_Metering_HeatingPlantAux	<- NA
  DF_MeterDevice$Indicator_Utilisation_Metering_HouseholdEl	<- NA
  DF_MeterDevice$Indicator_Utilisation_Metering_Cooking	<- NA
  DF_MeterDevice$Indicator_Utilisation_Metering_Other	<- NA


  #Test
  i_Device <- 1

  for (i_Device in c(1,2,3)) {


    DF_MeterDevice$A_C_Meter [i_Device] <-
      myDS [myIndex_Dataset ,paste0 ("A_C_Meter", "_M", i_Device)]

    DF_MeterDevice$Code_EC [i_Device] <-
      myDS [myIndex_Dataset , paste0 ("Code_Quantity_Metering", "_M", i_Device)]

    DF_MeterDevice$Unit_EC [i_Device] <-
      myDS [myIndex_Dataset , paste0 ("Code_Unit_Metering", "_M", i_Device)]


    DF_MeterDevice$Indicator_Utilisation_Metering_Heating [i_Device] <-
      AuxFunctions::Reformat_InputData_Boolean (
        myDS [myIndex_Dataset ,
              paste0 ("Indicator_Utilisation_Metering_Heating", "_M", i_Device)]
      )

    DF_MeterDevice$Indicator_Utilisation_Metering_DHW [i_Device] <-
      AuxFunctions::Reformat_InputData_Boolean (
        myDS [myIndex_Dataset ,
              paste0 ("Indicator_Utilisation_Metering_DHW", "_M", i_Device)]
      )

    DF_MeterDevice$Indicator_Utilisation_Metering_Cooling [i_Device] <-
      AuxFunctions::Reformat_InputData_Boolean (
        myDS [myIndex_Dataset ,
              paste0 ("Indicator_Utilisation_Metering_Cooling", "_M", i_Device)]
      )

    DF_MeterDevice$Indicator_Utilisation_Metering_VentilationAux [i_Device] <-
      AuxFunctions::Reformat_InputData_Boolean (
        myDS [myIndex_Dataset ,
              paste0 ("Indicator_Utilisation_Metering_VentilationAux",
                                                          "_M",
                                                          i_Device)]
      )

    DF_MeterDevice$Indicator_Utilisation_Metering_HeatingPlantAux [i_Device] <-
      AuxFunctions::Reformat_InputData_Boolean (
        myDS [myIndex_Dataset ,
              paste0 ("Indicator_Utilisation_Metering_HeatingPlantAux",
                                                          "_M",
                                                          i_Device)]
      )

    DF_MeterDevice$Indicator_Utilisation_Metering_HouseholdEl [i_Device] <-
      AuxFunctions::Reformat_InputData_Boolean (
        myDS [myIndex_Dataset ,
              paste0 ("Indicator_Utilisation_Metering_HouseholdEl", "_M", i_Device)]
      )

    DF_MeterDevice$Indicator_Utilisation_Metering_Cooking [i_Device] <-
      AuxFunctions::Reformat_InputData_Boolean (
        myDS [myIndex_Dataset ,
              paste0 ("Indicator_Utilisation_Metering_Cooking", "_M", i_Device)]
      )

    DF_MeterDevice$Indicator_Utilisation_Metering_Other [i_Device] <-
      AuxFunctions::Reformat_InputData_Boolean (
        myDS [myIndex_Dataset ,
              paste0 ("Indicator_Utilisation_Metering_Other", "_M", i_Device)]
      )

  } # End of loop by metering device



  DF_MeterDevice$Index_Meter_EC_Building <- c (1,2,3)

  DF_MeterDevice$Code_A_C_Meter <- "_NA_" # constant for application in Germany
  # Later to be moved to calculation parameters


  DF_MeterDevice$EnergyDensity_EC_Lib <-
    Value_ParTab_Vector (
      myParTab_Meter_EnergyDensity,
      DF_MeterDevice$Code_EC,
      paste0 ("kWh_Hs_per_", DF_MeterDevice$Unit_EC)
    )
  # 2022-11-13 - Suffix "_Lib" appended to variable name

  myDS$EnergyDensity_Vol_w <-
    myDS$vol_w_nd / myDS$q_w_nd
  # 2022-11-13 - variable introduced

  DF_MeterDevice$EnergyDensity_EC <-
    ifelse (DF_MeterDevice$Code_EC == "Water_DHW" &
              DF_MeterDevice$Unit_EC == "m3",
            myDS$EnergyDensity_Vol_w,
            DF_MeterDevice$EnergyDensity_EC_Lib)

  DF_MeterDevice$Code_Utilisation <-
    paste0 (
      "-",
      ifelse (
        DF_MeterDevice$Indicator_Utilisation_Metering_Heating == 1,
        "H-",
        ""
      ),
      ifelse (
        DF_MeterDevice$Indicator_Utilisation_Metering_DHW == 1,
        "W-",
        ""
      ),
      ifelse (
        DF_MeterDevice$Indicator_Utilisation_Metering_Cooling == 1,
        "C-",
        ""
      ),
      ifelse (
        DF_MeterDevice$Indicator_Utilisation_Metering_VentilationAux == 1,
        "V-",
        ""
      ),
      ifelse (
        DF_MeterDevice$Indicator_Utilisation_Metering_HeatingPlantAux == 1,
        "P-",
        ""
      ),
      ifelse (
        DF_MeterDevice$Indicator_Utilisation_Metering_HouseholdEl == 1,
        "HH-",
        ""
      ),
      ifelse (
        DF_MeterDevice$Indicator_Utilisation_Metering_Cooking == 1,
        "GC-",
        ""
      ),
      ifelse (
        DF_MeterDevice$Indicator_Utilisation_Metering_Other == 1,
        "O-",
        ""
      )
    )



  # # Check values
  # DF_MeterDevice$Indicator_Utilisation_Metering_Heating
  # DF_MeterDevice$Indicator_Utilisation_Metering_DHW
  # DF_MeterDevice$Indicator_Utilisation_Metering_Cooling
  # DF_MeterDevice$Indicator_Utilisation_Metering_VentilationAux
  # DF_MeterDevice$Indicator_Utilisation_Metering_HeatingPlantAux
  # DF_MeterDevice$Indicator_Utilisation_Metering_HouseholdEl
  # DF_MeterDevice$Indicator_Utilisation_Metering_Cooking
  # DF_MeterDevice$Indicator_Utilisation_Metering_Other
  # DF_MeterDevice$Code_Utilisation



  ###################################################################################X
  ### 2.2  Fill the meter values dataframe  -----
  ###################################################################################X

  # Processing of metering Sequences from the building data table
  # Calculation sheet in EnergyProfile.xlsm:
  # "[tabula-calculator.xlsx]Calc.Meter.Amount"

  myDF_MeterValues$Code_PeriodType <- "Subsequent"
  myDF_MeterValues$Code_PeriodType [c(1,
                                    n_Sequence_MeterAmount + 1,
                                    2 * n_Sequence_MeterAmount + 1)] <- "Start"
  # <G13> | Type of the period, manual input | Possible entries:
  # "Start: Start date and start value of meter reading are entered manually
  # "Subsequent": Automatic selection of start date and start meter
  # reading from the end values of the previous dataset
  # (used for subsequent periods measured with installed meters)


  ## Excel is said to use 1900-01-01 as day 1 (Windows default) or
  ## 1904-01-01 as day 0 (Mac default), but this is complicated by Excel
  ## incorrectly treating 1900 as a leap year.
  ## So for dates (post-1901) from Windows Excel:
  ##   as.Date(35981, origin = "1899-12-30") # 1998-07-05
  ## and Mac Excel:
  ##   as.Date(34519, origin = "1904-01-01") # 1998-07-05
  ## (these values come from http://support.microsoft.com/kb/214330)
  ## Source: RStudio Help


  ## kann gelöscht werden
  #
  # # Initialising in the correct format
  # myDF_MeterValues$Date_Start <- NA
  #   # as.Date (
  #   #   0,
  #   #   origin = Date_Origin_DataTables,
  #   #   optional = TRUE
  #   # )
  #
  # myDF_MeterValues$Date_End <- NA

  i_Section <- 1
  for (i_Section in (1:3)) {

    CurrentIndices <-
      ((i_Section-1) * n_Sequence_MeterAmount + 1) :
      (i_Section * n_Sequence_MeterAmount)

    myDF_MeterValues$Index_Meter_EC_Building [CurrentIndices] <- i_Section

    myDF_MeterValues$Code_BuildingMeter [CurrentIndices] <-
      DF_MeterDevice$Code_BuildingMeter [i_Section]

    myDF_MeterValues$A_C_Meter [CurrentIndices] <-
      DF_MeterDevice$A_C_Meter [i_Section]

    myDF_MeterValues$Code_Meter [CurrentIndices] <-
      DF_MeterDevice$Code_EC [i_Section]

    myDF_MeterValues$Unit [CurrentIndices] <-
      DF_MeterDevice$Unit_EC [i_Section]

    myDF_MeterValues$EnergyDensity_EnergyCarrier [CurrentIndices] <-
      DF_MeterDevice$EnergyDensity_EC [i_Section]

    myDF_MeterValues$Code_Utilisation [CurrentIndices] <-
      DF_MeterDevice$Code_Utilisation [i_Section]

    myDF_MeterValues$Date_End [CurrentIndices] <-
      myDS [myIndex_Dataset,
                 paste0 ("Date_End_Metering_",
                         AuxFunctions::Format_Integer_LeadingZeros(1:n_Sequence_MeterAmount, 3))]
    myDF_MeterValues$Date_Start [CurrentIndices [1]] <-
      myDS$Date_Start_Metering_001 [myIndex_Dataset]

    # myDF_MeterValues$Date_End [CurrentIndices] <-
    #   Data_Calc [myIndex_Dataset,
    #              paste0 ("Date_End_Metering_",
    #                      AuxFunctions::Format_Integer_LeadingZeros(1:n_Sequence_MeterAmount, 3))]
    #
    # myDF_MeterValues$Date_Start [CurrentIndices [1]] <-
    #   Data_Calc$Date_Start_Metering_001 [myIndex_Dataset]

    myDF_MeterValues$Date_Start [ CurrentIndices [2:n_Sequence_MeterAmount] ] <-
      as.integer (
        myDF_MeterValues$Date_End [CurrentIndices [1:(n_Sequence_MeterAmount-1)] ]
      ) + 1

    myDF_MeterValues$Date_Start [CurrentIndices] <-
      ifelse (is.na (myDF_MeterValues$Date_End [CurrentIndices]),
              NA,
              myDF_MeterValues$Date_Start [CurrentIndices])

    myDF_MeterValues$Amount_Input [CurrentIndices] <-
      as.numeric(
        myDS [myIndex_Dataset,
            paste0 ("Amount_Metering_M", i_Section, "_",
                  AuxFunctions::Format_Integer_LeadingZeros (1:n_Sequence_MeterAmount, 3))]
      )


  } # End loop by i_Section


  ## Conversion of integers to date

  myDF_MeterValues$Date_Start  <-
    as.Date (
      as.integer (myDF_MeterValues$Date_Start),
      origin = Date_Origin_DataTables,
      optional = TRUE
    )

  myDF_MeterValues$Date_End  <-
    as.Date (
      as.integer (myDF_MeterValues$Date_End),
      origin = Date_Origin_DataTables,
      optional = TRUE
    )

  myDF_MeterValues$Days_Metering <-
    AuxFunctions::Replace_NA(
      ifelse ((myDF_MeterValues$Date_End - myDF_MeterValues$Date_Start + 1) <=
                (365 + 365 + 365 + 366),
              myDF_MeterValues$Date_End - myDF_MeterValues$Date_Start + 1,
              0
      ),
      0
    )
  # Maximal 4 years can be included in a sequence.
  # <N13> | Integer





  ## kann gelöscht werden
  #
  # myDF_MeterValues$Value_MeterReading_Start <-  # <S13> | meter reading: value at the beginning of the period | used in case of installed meters, no input necessary in case of "subsequent" | mentioned unit | Real
  # myDF_MeterValues$Value_MeterReading_End <-  # <T13> | meter reading: value at the end of the period | used in case of installed meters | mentioned unit | Real


  myDF_MeterValues$Value_Consumption <-
    myDF_MeterValues$Amount_Input # Simplified as compared to Excel formulas
  # <V13> | consumed amount of the energy carrier | value derived from input | mentioned unit | Real

  myDF_MeterValues$Q_meter <-
    myDF_MeterValues$Value_Consumption *
    myDF_MeterValues$EnergyDensity_EnergyCarrier
  # <W13> | metered energy | value derived from input | kWh | Real

  myDF_MeterValues$q_const_year <-
    ifelse (
      AuxFunctions::Replace_NA (
        grepl ("-H-W-", myDF_MeterValues$Code_Utilisation),
        FALSE),
      ifelse (AuxFunctions::xl_LEFT (myDF_MeterValues$Code_Meter, 2) == "El", 11, 33),
      ifelse (AuxFunctions::Replace_NA (
        grepl ("-W-", myDF_MeterValues$Code_Utilisation),
        FALSE
      ), 100,
      0)
    )
  # <X13> | generated heat independent of weather (no difference between summer and winter months) | This input is used to assign fractions of the consumption values to specific 12 month periods in order to make comparisons with the energy balance calculation. | kWh/(m²a)



  myDF_MeterValues$Q_const_day <-
    pmin (
      myDF_MeterValues$q_const_year / 365 * myDF_MeterValues$A_C_Meter,
      myDF_MeterValues$Q_meter / myDF_MeterValues$Days_Metering,
      na.rm = TRUE
    )
  # <AD13> | kWh/d

  myDF_MeterValues$Q_const <-
    pmin (myDF_MeterValues$Q_const_day * myDF_MeterValues$Days_Metering,
          myDF_MeterValues$Q_meter,
          na.rm = TRUE)
  # <AE13> | kWh

  myDF_MeterValues$Q_WeatherDependent <-
    AuxFunctions::Replace_NA (
      pmax (myDF_MeterValues$Q_meter - myDF_MeterValues$Q_const,
            0,
            na.rm = TRUE), 0)
  # <AF13> | kWh

  myDF_MeterValues$Fraction_const <-
    AuxFunctions::Replace_NA (
      pmin (
        myDF_MeterValues$Q_const / myDF_MeterValues$Q_meter,
        1,
        na.rm = TRUE),
      0) # <AG13>

  # clipr::write_clip (
  #   colnames (myDF_MeterValues)
  # )





  return (myDF_MeterValues)


} # End of function PrepareDFMeterValues ()


## End of the function PrepareDFMeterValues () -----
#####################################################################################X


# . -----



#####################################################################################X
## FUNCTION "AllocateMeterAmountsToMonths ()" -----
#####################################################################################X


AllocateMeterAmountsToMonths <- function (
    myDF_MeterAmount
)

{

  ###################################################################################X
  # A  DESCRIPTIOM  -----
  ###################################################################################X



  ###################################################################################X
  # B  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X
  ## After debugging: Comment this section

  # myDF_MeterAmount <-
  #   DF_MonthlyAmountsByDevice
  #
  # # myDF_MeterAmount  <- DF_MonthlyAmounts # defined in MeterCalcSingleBuilding ()
  # # myDF_MeterAmount  <- myDF_MeterValues # defined in PrepareDFMeterValues ()


  ###################################################################################X
  # C  FUNCTION SCRIPT   -----
  ###################################################################################X

  ###################################################################################X
  ## 0  Constants   -----

  n_Row_DFMeterAmount <- nrow (myDF_MeterAmount)

  ID_TemperatureData_Station_Default <-
   "DE.MET.003987" # default station: Potsdam
  # ID of the temperature station used for allocation of consumption periods to evaluation years


  n_Year_MeterAllocation <- 4
  # number of calendary years used for allocation of meter periods to consumption years
  # = Maximum number of calendary years in which all meter sequences must be included
  # more than 2 years sometimes necessary in case of storable fuels
  # (oil, pellets, liquid gas) delivered by lorry


  Days_12MonthsAllocation <-
    c(31, 28.25, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)


  HeatingDegreeDays_12MonthsAllocation <-
    c (
      589,	507,	474,	324,	15,	0,	0,	0,	5,	326,	477,	592
    )
  # Monthly degree day values of a standard year; used for allocation of
  # metered consumption to months; has only an effect if metered consumption
  # is reported differently from a calendar year (pellets, oil, ...)



  ###################################################################################X
  ## 1  Initialisation   -----
  ###################################################################################X



  ###################################################################################X
  ### 1.1  Preparation of result vectors   -----

  # The creation of result vectors in Data_Calc helps running the whole script
  # even if there are errors in sections (sub functions)

  myMonthlyOutputVariableNames <-
    c (
      "Year_1"                               ,
      "Year_2"                               ,
      "Year_3"                               ,
      "Year_4"                               ,
      "Consumption_Assigned_Year1_Month_01"  ,
      "Consumption_Assigned_Year1_Month_02"  ,
      "Consumption_Assigned_Year1_Month_03"  ,
      "Consumption_Assigned_Year1_Month_04"  ,
      "Consumption_Assigned_Year1_Month_05"  ,
      "Consumption_Assigned_Year1_Month_06"  ,
      "Consumption_Assigned_Year1_Month_07"  ,
      "Consumption_Assigned_Year1_Month_08"  ,
      "Consumption_Assigned_Year1_Month_09"  ,
      "Consumption_Assigned_Year1_Month_10"  ,
      "Consumption_Assigned_Year1_Month_11"  ,
      "Consumption_Assigned_Year1_Month_12"  ,
      "Consumption_Assigned_Year2_Month_01"  ,
      "Consumption_Assigned_Year2_Month_02"  ,
      "Consumption_Assigned_Year2_Month_03"  ,
      "Consumption_Assigned_Year2_Month_04"  ,
      "Consumption_Assigned_Year2_Month_05"  ,
      "Consumption_Assigned_Year2_Month_06"  ,
      "Consumption_Assigned_Year2_Month_07"  ,
      "Consumption_Assigned_Year2_Month_08"  ,
      "Consumption_Assigned_Year2_Month_09"  ,
      "Consumption_Assigned_Year2_Month_10"  ,
      "Consumption_Assigned_Year2_Month_11"  ,
      "Consumption_Assigned_Year2_Month_12"  ,
      "Consumption_Assigned_Year3_Month_01"  ,
      "Consumption_Assigned_Year3_Month_02"  ,
      "Consumption_Assigned_Year3_Month_03"  ,
      "Consumption_Assigned_Year3_Month_04"  ,
      "Consumption_Assigned_Year3_Month_05"  ,
      "Consumption_Assigned_Year3_Month_06"  ,
      "Consumption_Assigned_Year3_Month_07"  ,
      "Consumption_Assigned_Year3_Month_08"  ,
      "Consumption_Assigned_Year3_Month_09"  ,
      "Consumption_Assigned_Year3_Month_10"  ,
      "Consumption_Assigned_Year3_Month_11"  ,
      "Consumption_Assigned_Year3_Month_12"  ,
      "Consumption_Assigned_Year4_Month_01"  ,
      "Consumption_Assigned_Year4_Month_02"  ,
      "Consumption_Assigned_Year4_Month_03"  ,
      "Consumption_Assigned_Year4_Month_04"  ,
      "Consumption_Assigned_Year4_Month_05"  ,
      "Consumption_Assigned_Year4_Month_06"  ,
      "Consumption_Assigned_Year4_Month_07"  ,
      "Consumption_Assigned_Year4_Month_08"  ,
      "Consumption_Assigned_Year4_Month_09"  ,
      "Consumption_Assigned_Year4_Month_10"  ,
      "Consumption_Assigned_Year4_Month_11"  ,
      "Consumption_Assigned_Year4_Month_12"  ,
      "Days_Sum_MeteringPeriod"              ,
      "Days_Year1_Month_01"                  ,
      "Days_Year1_Month_02"                  ,
      "Days_Year1_Month_03"                  ,
      "Days_Year1_Month_04"                  ,
      "Days_Year1_Month_05"                  ,
      "Days_Year1_Month_06"                  ,
      "Days_Year1_Month_07"                  ,
      "Days_Year1_Month_08"                  ,
      "Days_Year1_Month_09"                  ,
      "Days_Year1_Month_10"                  ,
      "Days_Year1_Month_11"                  ,
      "Days_Year1_Month_12"                  ,
      "Days_Year2_Month_01"                  ,
      "Days_Year2_Month_02"                  ,
      "Days_Year2_Month_03"                  ,
      "Days_Year2_Month_04"                  ,
      "Days_Year2_Month_05"                  ,
      "Days_Year2_Month_06"                  ,
      "Days_Year2_Month_07"                  ,
      "Days_Year2_Month_08"                  ,
      "Days_Year2_Month_09"                  ,
      "Days_Year2_Month_10"                  ,
      "Days_Year2_Month_11"                  ,
      "Days_Year2_Month_12"                  ,
      "Days_Year3_Month_01"                  ,
      "Days_Year3_Month_02"                  ,
      "Days_Year3_Month_03"                  ,
      "Days_Year3_Month_04"                  ,
      "Days_Year3_Month_05"                  ,
      "Days_Year3_Month_06"                  ,
      "Days_Year3_Month_07"                  ,
      "Days_Year3_Month_08"                  ,
      "Days_Year3_Month_09"                  ,
      "Days_Year3_Month_10"                  ,
      "Days_Year3_Month_11"                  ,
      "Days_Year3_Month_12"                  ,
      "Days_Year4_Month_01"                  ,
      "Days_Year4_Month_02"                  ,
      "Days_Year4_Month_03"                  ,
      "Days_Year4_Month_04"                  ,
      "Days_Year4_Month_05"                  ,
      "Days_Year4_Month_06"                  ,
      "Days_Year4_Month_07"                  ,
      "Days_Year4_Month_08"                  ,
      "Days_Year4_Month_09"                  ,
      "Days_Year4_Month_10"                  ,
      "Days_Year4_Month_11"                  ,
      "Days_Year4_Month_12"                  ,
      "Name_DegreeDays_StandardYear"         ,
      "DegreeDays_Sum_Year"                  ,
      "DegreeDays_Year1_Month_01"            ,
      "DegreeDays_Year1_Month_02"            ,
      "DegreeDays_Year1_Month_03"            ,
      "DegreeDays_Year1_Month_04"            ,
      "DegreeDays_Year1_Month_05"            ,
      "DegreeDays_Year1_Month_06"            ,
      "DegreeDays_Year1_Month_07"            ,
      "DegreeDays_Year1_Month_08"            ,
      "DegreeDays_Year1_Month_09"            ,
      "DegreeDays_Year1_Month_10"            ,
      "DegreeDays_Year1_Month_11"            ,
      "DegreeDays_Year1_Month_12"            ,
      "DegreeDays_Year2_Month_01"            ,
      "DegreeDays_Year2_Month_02"            ,
      "DegreeDays_Year2_Month_03"            ,
      "DegreeDays_Year2_Month_04"            ,
      "DegreeDays_Year2_Month_05"            ,
      "DegreeDays_Year2_Month_06"            ,
      "DegreeDays_Year2_Month_07"            ,
      "DegreeDays_Year2_Month_08"            ,
      "DegreeDays_Year2_Month_09"            ,
      "DegreeDays_Year2_Month_10"            ,
      "DegreeDays_Year2_Month_11"            ,
      "DegreeDays_Year2_Month_12"            ,
      "DegreeDays_Year3_Month_01"            ,
      "DegreeDays_Year3_Month_02"            ,
      "DegreeDays_Year3_Month_03"            ,
      "DegreeDays_Year3_Month_04"            ,
      "DegreeDays_Year3_Month_05"            ,
      "DegreeDays_Year3_Month_06"            ,
      "DegreeDays_Year3_Month_07"            ,
      "DegreeDays_Year3_Month_08"            ,
      "DegreeDays_Year3_Month_09"            ,
      "DegreeDays_Year3_Month_10"            ,
      "DegreeDays_Year3_Month_11"            ,
      "DegreeDays_Year3_Month_12"            ,
      "DegreeDays_Year4_Month_01"            ,
      "DegreeDays_Year4_Month_02"            ,
      "DegreeDays_Year4_Month_03"            ,
      "DegreeDays_Year4_Month_04"            ,
      "DegreeDays_Year4_Month_05"            ,
      "DegreeDays_Year4_Month_06"            ,
      "DegreeDays_Year4_Month_07"            ,
      "DegreeDays_Year4_Month_08"            ,
      "DegreeDays_Year4_Month_09"            ,
      "DegreeDays_Year4_Month_10"            ,
      "DegreeDays_Year4_Month_11"            ,
      "DegreeDays_Year4_Month_12"            ,
      "Code_Year1_Month_01"                  ,
      "Code_Year1_Month_02"                  ,
      "Code_Year1_Month_03"                  ,
      "Code_Year1_Month_04"                  ,
      "Code_Year1_Month_05"                  ,
      "Code_Year1_Month_06"                  ,
      "Code_Year1_Month_07"                  ,
      "Code_Year1_Month_08"                  ,
      "Code_Year1_Month_09"                  ,
      "Code_Year1_Month_10"                  ,
      "Code_Year1_Month_11"                  ,
      "Code_Year1_Month_12"                  ,
      "Code_Year2_Month_01"                  ,
      "Code_Year2_Month_02"                  ,
      "Code_Year2_Month_03"                  ,
      "Code_Year2_Month_04"                  ,
      "Code_Year2_Month_05"                  ,
      "Code_Year2_Month_06"                  ,
      "Code_Year2_Month_07"                  ,
      "Code_Year2_Month_08"                  ,
      "Code_Year2_Month_09"                  ,
      "Code_Year2_Month_10"                  ,
      "Code_Year2_Month_11"                  ,
      "Code_Year2_Month_12"                  ,
      "Code_Year3_Month_01"                  ,
      "Code_Year3_Month_02"                  ,
      "Code_Year3_Month_03"                  ,
      "Code_Year3_Month_04"                  ,
      "Code_Year3_Month_05"                  ,
      "Code_Year3_Month_06"                  ,
      "Code_Year3_Month_07"                  ,
      "Code_Year3_Month_08"                  ,
      "Code_Year3_Month_09"                  ,
      "Code_Year3_Month_10"                  ,
      "Code_Year3_Month_11"                  ,
      "Code_Year3_Month_12"                  ,
      "Code_Year4_Month_01"                  ,
      "Code_Year4_Month_02"                  ,
      "Code_Year4_Month_03"                  ,
      "Code_Year4_Month_04"                  ,
      "Code_Year4_Month_05"                  ,
      "Code_Year4_Month_06"                  ,
      "Code_Year4_Month_07"                  ,
      "Code_Year4_Month_08"                  ,
      "Code_Year4_Month_09"                  ,
      "Code_Year4_Month_10"                  ,
      "Code_Year4_Month_11"                  ,
      "Code_Year4_Month_12"
    )




  myDF_MeterAmount [ , myMonthlyOutputVariableNames] <- NA


  ###################################################################################X
  ##  2  Calculation   -----
  ###################################################################################X


  ###################################################################################X
  ###  2.1  Allocation of consumption periods to allocation years  -----
  ###################################################################################X

  ## Allocation of consumption values from the 40 sequences to 12-month periods
  #
  # Precondition: Each of the 40 consumption periods must not be longer than 4 (calendary) years.
  # The 4 evaluation years consist of 4 x 12 = 48 subsequent months, with a starting month fixed to January
  # Names: Year1_Month_01, Year1_Month_02, ...
  #
  # For each of the 40 consumption periods the following calculation is implemented:
  # (1) Place the starting date of the period in the respective month of the first allocation year
  # (2) For each month of the 4 allocation years count the number of days included in the consumption period.
  # (3) For each month of the 4 allocation years assign the heating degree days (base temperature 12°C)
  #     corresponding to the number of days allocated in (2).
  #     As a simplification a standard set of 12 heating degree day values from the default climate are used.



  myDF_MeterAmount$Year_1 <-
    as.integer(
      substr (myDF_MeterAmount$Date_Start, 1, 4) # <AH13> | Integer
    )

  myDF_MeterAmount$Year_2 <-
    ifelse (AuxFunctions::xl_AND (
      myDF_MeterAmount$Year_1 > 0,
      (myDF_MeterAmount$Year_1 + 1) <= substr (myDF_MeterAmount$Date_End, 1, 4)
    ),
    myDF_MeterAmount$Year_1 + 1,
    0) # <AI13> | Integer

  myDF_MeterAmount$Year_3 <-
    ifelse (AuxFunctions::xl_AND (
      myDF_MeterAmount$Year_2 > 0,
      (myDF_MeterAmount$Year_2 + 1) <= substr (myDF_MeterAmount$Date_End, 1, 4)
    ),
    myDF_MeterAmount$Year_2 + 1,
    0) # <AJ13> | Integer

  myDF_MeterAmount$Year_4 <-
    ifelse (AuxFunctions::xl_AND (
      myDF_MeterAmount$Year_3 > 0,
      (myDF_MeterAmount$Year_3 + 1) <= substr (myDF_MeterAmount$Date_End, 1, 4)
    ),
    myDF_MeterAmount$Year_3 + 1,
    0) # <AK13> | Integer


  #myDF_MeterAmount$ID_Station_12MonthAllocation <-
  ID_TemperatureData_Station_Default
  # Constant ersatzweise Potsdam? ==> ID Station: 3987


  # Data_Calc_Climate$ID_Station_12MonthAllocation <-
  #   AuxFunctions::Replace_NA (
  #     Data_Calc_Climate$ID_TemperatureData_Mapping_Station1,
  #     ID_TemperatureData_Station_Default
  #   )

  # Data_Calc_Climate$ID_TA_Station1
  # Data_Calc_Climate$ID_TemperatureData_Mapping_Station1
  # Data_Calc_Climate$ID_Mapping_Station_01

  # hole Dir Standard-Heizgradtage für die


  n_Year_MeterAllocation # Constant, value = 4
  # number of calendary years used for allocation of meter periods to consumption years
  # = Maximum number of calendary years in which a meter sequence must be completely included
  # Explanation: More than 2 years sometimes necessary in case of storable fuels
  # (oil, pellets, liquid gas) delivered by lorry



  # Days_12MonthsAllocation <-
  #   as.numeric (
  #     Data_ClimateMonth_TA_HD [
  #       paste0 ("DE.STD.000000.D"),
  #       paste0 ("M_LTA_", AuxFunctions::Format_Integer_LeadingZeros (1:12, 2))] / 20
  #   )
  #
  # HeatingDays_12MonthsAllocation <-
  #   as.numeric (
  #     Data_ClimateMonth_TA_HD [
  #       paste0 (ID_TemperatureData_Station_Default, ".HD_12"),
  #       paste0 ("M_LTA_", AuxFunctions::Format_Integer_LeadingZeros (1:12, 2))]
  #   )


  # HeatingDegreeDays_12MonthsAllocation <-
  #   DegreeDays12Months_MeterAllocation


  ## The following assignment would be more adequate. But in order to keep the values
  ## comparable with EnergyProfile.xlsm the list of values from above are used.
  #
  # HeatingDegreeDays_12MonthsAllocation <-
  #   as.numeric (
  #     pmax (
  #       Data_Calc_MeterCalc$theta_e_Base [i_DataSet_Building] -
  #         Data_ClimateMonth_TA_HD [
  #           paste0 (ID_TemperatureData_Station_Default, ".TA_12"),
  #           paste0 ("M_LTA_", AuxFunctions::Format_Integer_LeadingZeros (1:12, 2))],
  #       0
  #     ) *
  #       HeatingDays_12MonthsAllocation
  #   )


  DF_MeterAmount_SumPeriod <- 0
  # used to check if the sum of all months of the consumption period is
  # equal to the orginal cosumption value

  # Test of loop
  i_AllocationYear <- 1
  i_Month <- 1

  for (i_AllocationYear in (1:n_Year_MeterAllocation)) {

    for (i_Month in (1:12)) {

      ## Variables "Days_Year1_Month_01"
      #  Assign to each month the number of days included in consumption period

      myDF_MeterAmount [ ,
             paste0 ("Days_Year",
                     i_AllocationYear,
                     "_Month_",
                     AuxFunctions::Format_Integer_LeadingZeros (i_Month, 2))] <-
        AuxFunctions::Replace_NA (
          as.numeric (
            pmax (
              pmin (
                AuxFunctions::xl_EOMONTH (
                  AuxFunctions::xl_DATE (myDF_MeterAmount [ ,
                     paste0 ("Year_", i_AllocationYear)], i_Month, 1),
                  0),
                myDF_MeterAmount$Date_End) -
                pmax (
                  AuxFunctions::xl_EOMONTH (
                    AuxFunctions::xl_DATE (myDF_MeterAmount [ ,
                       paste0 ("Year_", i_AllocationYear)], i_Month, 1),
                    -1),
                  myDF_MeterAmount$Date_Start - 1),
              0
            )
          ),
          0
        )

      # <CJ13> | 1 | 31


      ## Variables "DegreeDays_Year1_Month_01" etc.
      #  Assign degree days from default climate

      myDF_MeterAmount [ , paste0 ("DegreeDays_Year",
                                 i_AllocationYear,
                                 "_Month_",
                                 AuxFunctions::Format_Integer_LeadingZeros (i_Month, 2))] <-
        HeatingDegreeDays_12MonthsAllocation  [i_Month]



    } # End loop by i_Month
  } # End loop by i_AllocationYear

  # 2023-10-27: Changed from 1 to 2 loops by month and allocation year
  # and supplemented a loop by row to calculate the missing variable
  # myDF_MeterAmount$DegreeDays_Sum_Year


  i_Col_Start_DegreeDays <-
    which (colnames (myDF_MeterAmount) == "DegreeDays_Year1_Month_01")

  i_Col_Start_Days <-
    which (colnames (myDF_MeterAmount) == "Days_Year1_Month_01")

  i_Row <- 1
  for (i_Row in (1 : n_Row_DFMeterAmount)) {
    myDF_MeterAmount$DegreeDays_Sum_Year [i_Row] <-
      sum (
        as.numeric(
          myDF_MeterAmount [
            i_Row,
            i_Col_Start_DegreeDays : (i_Col_Start_DegreeDays + n_Year_MeterAllocation * 12 -1)] *
            myDF_MeterAmount [
              i_Row,
              i_Col_Start_Days : (i_Col_Start_Days + n_Year_MeterAllocation * 12 -1)] /
            cbind (Days_12MonthsAllocation,
                   Days_12MonthsAllocation,
                   Days_12MonthsAllocation,
                   Days_12MonthsAllocation)
        )
      )
  } # End loop by i_Row


  for (i_AllocationYear in (1:n_Year_MeterAllocation)) {

    for (i_Month in (1:12)) {

      ## Variables "Consumption_Assigned_Year1_Month_01" etc.
      #  Assign degree days from default climate

      myDF_MeterAmount [ ,
           paste0 ("Consumption_Assigned",
                   "_Year",  i_AllocationYear,
                   "_Month_", AuxFunctions::Format_Integer_LeadingZeros (i_Month, 2))] <-
        myDF_MeterAmount [ , paste0 ("Days_Year", i_AllocationYear,
                                     "_Month_",
                                     AuxFunctions::Format_Integer_LeadingZeros (i_Month, 2))] *
        myDF_MeterAmount$Q_const_day +
        AuxFunctions::Replace_NA (
          myDF_MeterAmount [ , paste0 ("Days_Year", i_AllocationYear,
                                       "_Month_",
                                       AuxFunctions::Format_Integer_LeadingZeros (i_Month, 2))] /
            Days_12MonthsAllocation [i_Month] *
            myDF_MeterAmount [ , paste0 ("DegreeDays_Year", i_AllocationYear,
                                         "_Month_",
                                         AuxFunctions::Format_Integer_LeadingZeros (i_Month, 2))] /
            myDF_MeterAmount$DegreeDays_Sum_Year * # Sum of actually allocated degree days
            # 2023-10-27 corrected
            # sum (HeatingDegreeDays_12MonthsAllocation) *
            myDF_MeterAmount$Q_WeatherDependent ,
          0
        ) # <AM13> | 1 | kWh


      DF_MeterAmount_SumPeriod <-
        DF_MeterAmount_SumPeriod +
        myDF_MeterAmount [ , paste0 ("Consumption_Assigned",
                                   "_Year",  i_AllocationYear,
                                   "_Month_", AuxFunctions::Format_Integer_LeadingZeros (i_Month, 2))]


      ## Variables "Code_Year1_Month_01" etc.

      myDF_MeterAmount [ , paste0 ("Code",
                                   "_Year",  i_AllocationYear,
                                   "_Month_",
                                   AuxFunctions::Format_Integer_LeadingZeros (i_Month, 2))] <-
        as.character (
          AuxFunctions::xl_DATE (
            myDF_MeterAmount$Year_1 + i_AllocationYear - 1, # 2023-10-20 added two missing terms
            i_Month,
            1) # <GD13> | 1 | 31
        )
      ## 2023-10-20 Correction
      # myDF_MeterAmount [ , paste0 ("Code",
      #                            "_Year",  i_AllocationYear,
      #                            "_Month_",
      #                            AuxFunctions::Format_Integer_LeadingZeros (i_Month, 2))] <-
      #   as.character (
      #     AuxFunctions::xl_DATE(myDF_MeterAmount$Year_1, i_Month, 1) # <GD13> | 1 | 31
      #   )


    } # End loop by i_Month

  } # End Loop by i_AllocationYear



  myDF_MeterAmount$RelativeDeviation_SumMonthlyConsumption <-
    AuxFunctions::Replace_NA (
      round (
        (DF_MeterAmount_SumPeriod - myDF_MeterAmount$Q_meter) /
          myDF_MeterAmount$Q_meter,
        3
      ),
      0
    )
  # <AL13> | should be equal to 0 | kWh


  # myDF_MeterAmount$RelativeDeviation_SumMonthlyConsumption <-
  #   AuxFunctions::Replace_NA (
  #     round (
  #       myDF_MeterAmount$Deviation_SumMonthlyConsumption / myDF_MeterAmount$Q_meter,
  #       3
  #     ),
  #     0
  #   )
  # # <AL13> | should be equal to 0 | kWh
  #
  #



  # clipr::write_clip (
  #   colnames (myDF_MeterAmount)
  # )


  return (myDF_MeterAmount)


} # End of function AllocateMeterAmountsToMonths ()


## End of the function AllocateMeterAmountsToMonths () -----
#####################################################################################X


# . -----




#####################################################################################X
## FUNCTION "PrepareMeterCalcSlots ()" -----
#####################################################################################X


PrepareMeterCalcSlots <- function (

  # Tables from  data package: "clidamonger" "Climate Data Monthly Germany"
  myClimateData_PostCodes,
  myClimateData_StationTA,
  myClimateData_TA_HD,
  myClimateData_Sol,
  myParTab_SolOrientEst,

  myGeneralData, # Dataset from Data_Calc of one building
  myConsumption  # by device: consumption allocated to months

)

{

  ###################################################################################X
  # A  DESCRIPTIOM  -----
  ###################################################################################X

  ## Preparation of comparison slots defined by periods and by scope
  ## R-Script derived from "[tabula-calculator.xlsx]Calc.Meter.Comparison"
  ## and from "[EnergyProfile.xlsm]Data.Out.TABULA"

  # The number 9 reflects the slots in the Excel workbook and the structure
  # of the current building data table.
  # In principle the number of slots could be extended.


  # <Y24> | Indicator for the utilisation of the measured energy |
  # Energy carrier used for H = heating, W = DHW, C = cooling, V = ventilation (electricity),
  # P = electricity for heating plant (pumps, controls, etc.), HH = household electricity,
  # GC = gas cooking, O = other; e.g. code for all utilisations: "-H-W-C-V-P-HH-GC-O-" |
  # Tab.Meter.Definition | VarChar | Code_BuildingMeter_M01 | 16 | Code_Utilisation | 11



  # 2022-10-21 / Remark Tobias regarding further development:
  # A simplified version for extension should be considered
  # leaving the current systematics undisturbed.
  # An idea is to use 4 additional, predefined comparison slots: H+W, H, W, VolW,
  # each of which could deal with for example 20 comparison years
  # The input would be for each of the 4 slot the start date (year, month)
  # and the assignment of meterings of M1, M2 and M3 by "+" "–" and "0" in the proven manner



  ###################################################################################X
  # B  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X
  ## After debugging: Comment this section

  # myClimateData_PostCodes <-
  #   as.data.frame (StationClimateTables$ClimateData_PostCodes)
  # #  as.data.frame (clidamonger::tab.stationmapping)
  # # Name of the original table is misleading --> better to be changed
  # # (also in the Excel workbook)
  #
  # myClimateData_StationTA <-
  #   as.data.frame (StationClimateTables$ClimateData_StationTA)
  #   #as.data.frame (clidamonger::list.station.ta)
  #
  # myClimateData_TA_HD <-
  #   as.data.frame (StationClimateTables$ClimateData_TA_HD)
  #   #as.data.frame (clidamonger::data.ta.hd)
  #
  # myClimateData_Sol <-
  #   as.data.frame (StationClimateTables$ClimateData_Sol)
  #   #as.data.frame (clidamonger::data.sol)
  #
  # myParTab_SolOrientEst <-
  #   as.data.frame (StationClimateTables$ParTab_SolOrientEst)
  #   #as.data.frame (clidamonger::tab.estim.sol.orient)
  #
  #
  # myGeneralData <-
  #   myDataset
  # # Dataset from Data_Calc of one building, defined in MeterCalcSingleBuilding ()
  #
  # myConsumption <-
  #   DF_MonthlyAmountsByDevice
  # # by device: consumption allocated to months, defined in MeterCalcSingleBuilding ()





  ###################################################################################X
  # C  FUNCTION SCRIPT   -----
  ###################################################################################X


  ###################################################################################X
  ## 0  Constants   -----
  ###################################################################################X

  n_Slot_MeterCalcComparison <- 9

  n_MeteringDevice <- 3
  ID_MeteringDevice_M0   <- AuxFunctions::Format_Integer_LeadingZeros (1:n_MeteringDevice, 1, "M")
  ID_MeteringDevice_M00 <- AuxFunctions::Format_Integer_LeadingZeros (1:n_MeteringDevice, 2, "M")

  n_Sequence_MeterAmount <- 40

  n_Year_MonthlyConsumption <- 4



  ###################################################################################X
  ## 1  Initialisation   -----
  ###################################################################################X

  i_DataSet_Building <- 1


  ###################################################################################X
  ### 1.1  Preparation of result vectors   -----

  # The creation of result vectors helps running the whole script
  # even if there are errors in sections (sub functions)

  mySlotInputVariableNames <-
    c ("ID_ComparisonSlot",
       "Index_ComparisonSlot"

# +++ Variablennamen müssen noch weiter eingetragen werden. +++

          )


  mySlotData <-
    as.data.frame (
      matrix (NA,
              n_Slot_MeterCalcComparison,
              length (mySlotInputVariableNames)
      )
    )

  colnames (mySlotData) <- mySlotInputVariableNames

  mySlotData$Index_ComparisonSlot <-
    c (1:n_Slot_MeterCalcComparison)

  mySlotData$ID_ComparisonSlot <-
    AuxFunctions::Format_Integer_LeadingZeros (mySlotData$Index_ComparisonSlot, 2, "CMC.")






  ###################################################################################X
  ## 2  Calculation   -----
  ###################################################################################X

  ###################################################################################X
  ## 2.1  Preparation metering data all devices (M1, M2, M3)   -----

  mySlotData$F_CalcAdapt_M <-
    myGeneralData$F_CalcAdapt_M

  mySlotData$Indicator_CalcAdapt_M <-
    as.integer (
      myGeneralData  [
        i_DataSet_Building,
        AuxFunctions::Format_Integer_LeadingZeros (
          1:n_Slot_MeterCalcComparison,
          2,
          "Indicator_M_CalcAdapt_"
        )
      ]
    )
  # <GU24>


  mySlotData$Year_Balance_Start <-
    as.integer (
      myGeneralData  [
        i_DataSet_Building,
        AuxFunctions::Format_Integer_LeadingZeros (
          1:n_Slot_MeterCalcComparison,
          2,
          "Year_Start_CompareCalcMeter_"
        )
      ]
    )
  # <F24> | Start year of the comparison period | Integer

  mySlotData$Month_Balance_Start <-
    as.integer (
      myGeneralData  [
        i_DataSet_Building,
        AuxFunctions::Format_Integer_LeadingZeros (
          1:n_Slot_MeterCalcComparison,
          2,
          "Month_Start_CompareCalcMeter_"
        )
      ]
    )
  # <G24> | Start month of the comparison period | Integer

  mySlotData$n_Year <-
    as.integer (
      myGeneralData  [
        i_DataSet_Building,
        AuxFunctions::Format_Integer_LeadingZeros (
          1:n_Slot_MeterCalcComparison,
          2,
          "n_Year_CompareCalcMeter_"
        )
      ]
    )
  # <H24> | number of years to be compared | Integer

  mySlotData$Date_BalanceYears_Start  <-
    as.character (
      AuxFunctions::xl_DATE(
        mySlotData$Year_Balance_Start,
        mySlotData$Month_Balance_Start,
        1
      )
    )
  # <I24> | Start date of the balance year | 41986.384615381947 | Date | Year_1 | 34

  mySlotData$Date_BalanceYears_End <-
    as.character (
      AuxFunctions::xl_DATE(
        mySlotData$Year_Balance_Start + mySlotData$n_Year,
        mySlotData$Month_Balance_Start,
        1
      ) - 1
    )
  # <J24> | End date of the balance year | 42477.115384618053 | Date


  ###################################################################################X
  ## 2.2  Preparation device M1   -----

  mySlotData$Code_MeteringSite_M01             <-
    myGeneralData$Code_EC_M1

  mySlotData$Code_EC_M01                       <-
    myGeneralData$Code_EC_M1

  mySlotData$Unit_EC_M01                       <-
    myGeneralData$Code_Unit_Metering_M1_Input

  mySlotData$EnergyDensity_EC_M01              <-
    myConsumption$EnergyDensity_EnergyCarrier [
      myConsumption$ID_MeterAmount == "M1.001"]

  mySlotData$Code_Utilisation_M01              <-
    myConsumption$Code_Utilisation [
      myConsumption$ID_MeterAmount == "M1.001"]


  mySlotData$Code_CompareCalcMeter_Consider_M01 <-
    as.character(
      myGeneralData [
        AuxFunctions::Format_Integer_LeadingZeros (1 : n_Slot_MeterCalcComparison, 2,
                                     "Code_CompareCalcMeter_Consider_M1_")
      ]
    )

  mySlotData$Multiplier_Contribution_M01 <- 0

  mySlotData$Multiplier_Contribution_M01 <-
    ifelse (mySlotData$Code_CompareCalcMeter_Consider_M01 == "+",
            1,
            mySlotData$Multiplier_Contribution_M01)

  mySlotData$Multiplier_Contribution_M01 <-
    ifelse (mySlotData$Code_CompareCalcMeter_Consider_M01 == "–",
            -1,
            mySlotData$Multiplier_Contribution_M01)

  # <BDH24> | +1: add to total value   -1 :reduce from total value
  #  Meter 01 | Real


  mySlotData$Consumption_SumYears_M01_Month01 <- 0
  mySlotData$Consumption_SumYears_M01_Month02 <- 0
  mySlotData$Consumption_SumYears_M01_Month03 <- 0
  mySlotData$Consumption_SumYears_M01_Month04 <- 0
  mySlotData$Consumption_SumYears_M01_Month05 <- 0
  mySlotData$Consumption_SumYears_M01_Month06 <- 0
  mySlotData$Consumption_SumYears_M01_Month07 <- 0
  mySlotData$Consumption_SumYears_M01_Month08 <- 0
  mySlotData$Consumption_SumYears_M01_Month09 <- 0
  mySlotData$Consumption_SumYears_M01_Month10 <- 0
  mySlotData$Consumption_SumYears_M01_Month11 <- 0
  mySlotData$Consumption_SumYears_M01_Month12 <- 0

  mySlotData$Consumption_SumYears_M01 <- 0

  mySlotData$Consumption_Year_M01 <- 0




  ###################################################################################X
  ## 2.3  Preparation device M2   -----

  mySlotData$Code_MeteringSite_M02             <-
    myGeneralData$Code_EC_M2

  mySlotData$Code_EC_M02                       <-
    myGeneralData$Code_EC_M2

  mySlotData$Unit_EC_M02                       <-
    myGeneralData$Code_Unit_Metering_M2_Input

  mySlotData$EnergyDensity_EC_M02              <-
    myConsumption$EnergyDensity_EnergyCarrier [
      myConsumption$ID_MeterAmount == "M2.001"]

  mySlotData$Code_Utilisation_M02              <-
    myConsumption$Code_Utilisation [
      myConsumption$ID_MeterAmount == "M2.001"]


  mySlotData$Code_CompareCalcMeter_Consider_M02 <-
    as.character(
      myGeneralData [
        AuxFunctions::Format_Integer_LeadingZeros (1 : n_Slot_MeterCalcComparison, 2,
                                     "Code_CompareCalcMeter_Consider_M2_")
      ]
    )

  mySlotData$Multiplier_Contribution_M02 <- 0

  mySlotData$Multiplier_Contribution_M02 <-
    ifelse (mySlotData$Code_CompareCalcMeter_Consider_M02 == "+",
            1,
            mySlotData$Multiplier_Contribution_M02)

  mySlotData$Multiplier_Contribution_M02 <-
    ifelse (mySlotData$Code_CompareCalcMeter_Consider_M02 == "–",
            -1,
            mySlotData$Multiplier_Contribution_M02)

  # <BDH24> | +1: add to total value   -1 :reduce from total value
  #  Meter 01 | Real


  mySlotData$Consumption_SumYears_M02_Month01 <- 0
  mySlotData$Consumption_SumYears_M02_Month02 <- 0
  mySlotData$Consumption_SumYears_M02_Month03 <- 0
  mySlotData$Consumption_SumYears_M02_Month04 <- 0
  mySlotData$Consumption_SumYears_M02_Month05 <- 0
  mySlotData$Consumption_SumYears_M02_Month06 <- 0
  mySlotData$Consumption_SumYears_M02_Month07 <- 0
  mySlotData$Consumption_SumYears_M02_Month08 <- 0
  mySlotData$Consumption_SumYears_M02_Month09 <- 0
  mySlotData$Consumption_SumYears_M02_Month10 <- 0
  mySlotData$Consumption_SumYears_M02_Month11 <- 0
  mySlotData$Consumption_SumYears_M02_Month12 <- 0

  mySlotData$Consumption_SumYears_M02 <- 0

  mySlotData$Consumption_Year_M02 <- 0



  ###################################################################################X
  ## 2.4  Preparation device M3   -----

  mySlotData$Code_MeteringSite_M03             <-
    myGeneralData$Code_EC_M3

  mySlotData$Code_EC_M03                       <-
    myGeneralData$Code_EC_M3

  mySlotData$Unit_EC_M03                       <-
    myGeneralData$Code_Unit_Metering_M3_Input

  mySlotData$EnergyDensity_EC_M03              <-
    myConsumption$EnergyDensity_EnergyCarrier [
      myConsumption$ID_MeterAmount == "M3.001"]

  mySlotData$Code_Utilisation_M03              <-
    myConsumption$Code_Utilisation [
      myConsumption$ID_MeterAmount == "M3.001"]


  mySlotData$Code_CompareCalcMeter_Consider_M03 <-
    as.character(
      myGeneralData [
        AuxFunctions::Format_Integer_LeadingZeros (1 : n_Slot_MeterCalcComparison, 2,
                                     "Code_CompareCalcMeter_Consider_M3_")
      ]
    )

  mySlotData$Multiplier_Contribution_M03 <- 0

  mySlotData$Multiplier_Contribution_M03 <-
    ifelse (mySlotData$Code_CompareCalcMeter_Consider_M03 == "+",
            1,
            mySlotData$Multiplier_Contribution_M03)

  mySlotData$Multiplier_Contribution_M03 <-
    ifelse (mySlotData$Code_CompareCalcMeter_Consider_M03 == "–",
            -1,
            mySlotData$Multiplier_Contribution_M03)

  # <BDH24> | +1: add to total value   -1 :reduce from total value
  #  Meter 01 | Real


  mySlotData$Consumption_SumYears_M03_Month01 <- 0
  mySlotData$Consumption_SumYears_M03_Month02 <- 0
  mySlotData$Consumption_SumYears_M03_Month03 <- 0
  mySlotData$Consumption_SumYears_M03_Month04 <- 0
  mySlotData$Consumption_SumYears_M03_Month05 <- 0
  mySlotData$Consumption_SumYears_M03_Month06 <- 0
  mySlotData$Consumption_SumYears_M03_Month07 <- 0
  mySlotData$Consumption_SumYears_M03_Month08 <- 0
  mySlotData$Consumption_SumYears_M03_Month09 <- 0
  mySlotData$Consumption_SumYears_M03_Month10 <- 0
  mySlotData$Consumption_SumYears_M03_Month11 <- 0
  mySlotData$Consumption_SumYears_M03_Month12 <- 0

  mySlotData$Consumption_SumYears_M03 <- 0

  mySlotData$Consumption_Year_M03 <- 0



  ###################################################################################X
  ## 2.5 Calculation of annual consumption values for devices M1, M2 and M3   -----


  StartIndex_Col_CodeMonths <-
    which (colnames (myConsumption) == "Code_Year1_Month_01")

  Indices_Col_CodeMonths <-
    StartIndex_Col_CodeMonths : (StartIndex_Col_CodeMonths +
                                   n_Year_MonthlyConsumption * 12 - 1)

  StartIndex_Col_ConsumptionMonths <-
    which (colnames (myConsumption) == "Consumption_Assigned_Year1_Month_01")

  Indices_Col_ConsumptionMonths <-
    StartIndex_Col_ConsumptionMonths : (StartIndex_Col_ConsumptionMonths +
                                          n_Year_MonthlyConsumption * 12 - 1)

  ## M01
  StartIndex_Col_ConsumptionMonths_M01_SumYears <-
    which (colnames (mySlotData) == "Consumption_SumYears_M01_Month01")
  Indices_Col_ConsumptionMonths_M01_SumYears <-
    StartIndex_Col_ConsumptionMonths_M01_SumYears : (
      StartIndex_Col_ConsumptionMonths_M01_SumYears + 12 - 1)

  ## M02
  StartIndex_Col_ConsumptionMonths_M02_SumYears <-
    which (colnames (mySlotData) == "Consumption_SumYears_M02_Month01")
  Indices_Col_ConsumptionMonths_M02_SumYears <-
    StartIndex_Col_ConsumptionMonths_M02_SumYears : (
      StartIndex_Col_ConsumptionMonths_M02_SumYears + 12 - 1)

  ## M03
  StartIndex_Col_ConsumptionMonths_M03_SumYears <-
    which (colnames (mySlotData) == "Consumption_SumYears_M03_Month01")
  Indices_Col_ConsumptionMonths_M03_SumYears <-
    StartIndex_Col_ConsumptionMonths_M03_SumYears : (
      StartIndex_Col_ConsumptionMonths_M03_SumYears + 12 - 1)

  i_Slot <- 1
  for (i_Slot in (1 : n_Slot_MeterCalcComparison)) {

    mySlotData [i_Slot, Indices_Col_ConsumptionMonths_M01_SumYears] <- 0
    mySlotData$Consumption_SumYears_M01 [i_Slot] <- 0
    mySlotData [i_Slot, Indices_Col_ConsumptionMonths_M02_SumYears] <- 0
    mySlotData$Consumption_SumYears_M02 [i_Slot] <- 0
    mySlotData [i_Slot, Indices_Col_ConsumptionMonths_M03_SumYears] <- 0
    mySlotData$Consumption_SumYears_M03 [i_Slot] <- 0

    i_MeterAmount <- 1
    for (i_MeterAmount in (1 : (n_MeteringDevice * n_Sequence_MeterAmount))) {

      Filter_CurrentRow <-
        as.numeric (
          (mySlotData$Date_BalanceYears_Start [i_Slot] <=
             myConsumption [i_MeterAmount, Indices_Col_CodeMonths]) * 1
        )  * as.numeric (
          (mySlotData$Date_BalanceYears_End [i_Slot] >=
             myConsumption [i_MeterAmount, Indices_Col_CodeMonths]) * 1
        )

      CurrentConsumption <-
        as.numeric (
          myConsumption [
            i_MeterAmount,
            Indices_Col_ConsumptionMonths
          ] * Filter_CurrentRow
        )

      CurrentConsumption <- Replace_NA (CurrentConsumption, 0)

      ## M01
      if (myConsumption$ID_MeterDevice [i_MeterAmount] == "M1") {

        i_Year <- 1
        for (i_Year in (1:n_Year_MonthlyConsumption)) {

          mySlotData [i_Slot, Indices_Col_ConsumptionMonths_M01_SumYears] <-
            mySlotData [i_Slot, Indices_Col_ConsumptionMonths_M01_SumYears] +
            CurrentConsumption [(i_Year - 1) * 12 + (1:12) ]

        } # End Loop by i_Year

        mySlotData$Consumption_SumYears_M01 [i_Slot] <-
          sum (mySlotData [i_Slot, Indices_Col_ConsumptionMonths_M01_SumYears], na.rm = TRUE)

      } # End if M1


      ## M02
      if (myConsumption$ID_MeterDevice [i_MeterAmount] == "M2") {

        i_Year <- 1
        for (i_Year in (1:n_Year_MonthlyConsumption)) {

          mySlotData [i_Slot, Indices_Col_ConsumptionMonths_M02_SumYears] <-
            mySlotData [i_Slot, Indices_Col_ConsumptionMonths_M02_SumYears] +
            CurrentConsumption [(i_Year - 1) * 12 + (1:12) ]

        } # End Loop by i_Year

        mySlotData$Consumption_SumYears_M02 [i_Slot] <-
          sum (mySlotData [i_Slot, Indices_Col_ConsumptionMonths_M02_SumYears], na.rm = TRUE)

      } # End if M2


      ## M03
      if (myConsumption$ID_MeterDevice  [i_MeterAmount] == "M3") {

        i_Year <- 1
        for (i_Year in (1:n_Year_MonthlyConsumption)) {

          mySlotData [i_Slot, Indices_Col_ConsumptionMonths_M03_SumYears] <-
            mySlotData [i_Slot, Indices_Col_ConsumptionMonths_M03_SumYears] +
            CurrentConsumption [(i_Year - 1) * 12 + (1:12) ]

        } # End Loop by i_Year

        mySlotData$Consumption_SumYears_M03 [i_Slot] <-
          sum (mySlotData [i_Slot, Indices_Col_ConsumptionMonths_M03_SumYears], na.rm = TRUE)

      } # End if M3

    } # End loop by i_MeterAmount

  } # End loop by i_Slot










## 2023-10-22 Loop by i_Slot old version

  # i_Slot <- 1
  # for (i_Slot in (1 : n_Slot_MeterCalcComparison)) {

    ## 2023-10-21 - corrected (see above)
    #
    # CurrentFilterList_M1_Year1 <-
    #   (myConsumption$Code_Year1_Month_01 >= mySlotData$Date_BalanceYears_Start [i_Slot]) &
    #   (myConsumption$Code_Year1_Month_01 <= mySlotData$Date_BalanceYears_End [i_Slot]) &
    #   (myConsumption$ID_MeterDevice == "M1")
    #
    # CurrentFilterList_M1_Year2 <-
    #   (myConsumption$Code_Year2_Month_01 >= mySlotData$Date_BalanceYears_Start [i_Slot]) &
    #   (myConsumption$Code_Year2_Month_01 <= mySlotData$Date_BalanceYears_End [i_Slot]) &
    #   (myConsumption$ID_MeterDevice == "M1")
    #
    # CurrentFilterList_M1_Year3 <-
    #   (myConsumption$Code_Year3_Month_01 >= mySlotData$Date_BalanceYears_Start [i_Slot]) &
    #   (myConsumption$Code_Year3_Month_01 <= mySlotData$Date_BalanceYears_End [i_Slot]) &
    #   (myConsumption$ID_MeterDevice == "M1")
    #
    # CurrentFilterList_M1_Year4 <-
    #   (myConsumption$Code_Year4_Month_01 >= mySlotData$Date_BalanceYears_Start [i_Slot]) &
    #   (myConsumption$Code_Year4_Month_01 <= mySlotData$Date_BalanceYears_End [i_Slot]) &
    #   (myConsumption$ID_MeterDevice == "M1")
    #
    #
    # CurrentFilterList_M2_Year1 <-
    #   (myConsumption$Code_Year1_Month_01 >= mySlotData$Date_BalanceYears_Start [i_Slot]) &
    #   (myConsumption$Code_Year1_Month_01 <= mySlotData$Date_BalanceYears_End [i_Slot]) &
    #   (myConsumption$ID_MeterDevice == "M2")
    #
    # CurrentFilterList_M2_Year2 <-
    #   (myConsumption$Code_Year2_Month_01 >= mySlotData$Date_BalanceYears_Start [i_Slot]) &
    #   (myConsumption$Code_Year2_Month_01 <= mySlotData$Date_BalanceYears_End [i_Slot]) &
    #   (myConsumption$ID_MeterDevice == "M2")
    #
    # CurrentFilterList_M2_Year3 <-
    #   (myConsumption$Code_Year3_Month_01 >= mySlotData$Date_BalanceYears_Start [i_Slot]) &
    #   (myConsumption$Code_Year3_Month_01 <= mySlotData$Date_BalanceYears_End [i_Slot]) &
    #   (myConsumption$ID_MeterDevice == "M2")
    #
    # CurrentFilterList_M2_Year4 <-
    #   (myConsumption$Code_Year4_Month_01 >= mySlotData$Date_BalanceYears_Start [i_Slot]) &
    #   (myConsumption$Code_Year4_Month_01 <= mySlotData$Date_BalanceYears_End [i_Slot]) &
    #   (myConsumption$ID_MeterDevice == "M2")
    #
    #
    # CurrentFilterList_M3_Year1 <-
    #   (myConsumption$Code_Year1_Month_01 >= mySlotData$Date_BalanceYears_Start [i_Slot]) &
    #   (myConsumption$Code_Year1_Month_01 <= mySlotData$Date_BalanceYears_End [i_Slot]) &
    #   (myConsumption$ID_MeterDevice == "M3")
    #
    # CurrentFilterList_M3_Year2 <-
    #   (myConsumption$Code_Year2_Month_01 >= mySlotData$Date_BalanceYears_Start [i_Slot]) &
    #   (myConsumption$Code_Year2_Month_01 <= mySlotData$Date_BalanceYears_End [i_Slot]) &
    #   (myConsumption$ID_MeterDevice == "M3")
    #
    # CurrentFilterList_M3_Year3 <-
    #   (myConsumption$Code_Year3_Month_01 >= mySlotData$Date_BalanceYears_Start [i_Slot]) &
    #   (myConsumption$Code_Year3_Month_01 <= mySlotData$Date_BalanceYears_End [i_Slot]) &
    #   (myConsumption$ID_MeterDevice == "M3")
    #
    # CurrentFilterList_M3_Year4 <-
    #   (myConsumption$Code_Year4_Month_01 >= mySlotData$Date_BalanceYears_Start [i_Slot]) &
    #   (myConsumption$Code_Year4_Month_01 <= mySlotData$Date_BalanceYears_End [i_Slot]) &
    #   (myConsumption$ID_MeterDevice == "M3")


    # CurrentFilterList_M1 <-
    #   (myConsumption$Code_Year1_Month_01 >= mySlotData$Date_BalanceYears_Start [i_Slot]) &
    #   (myConsumption$Code_Year1_Month_01 <= mySlotData$Date_BalanceYears_End [i_Slot]) &
    #   (myConsumption$ID_MeterDevice == "M1")
    #
    # CurrentFilterList_M2 <-
    #   (myConsumption$Code_Year1_Month_01 >= mySlotData$Date_BalanceYears_Start [i_Slot]) &
    #   (myConsumption$Code_Year1_Month_01 <= mySlotData$Date_BalanceYears_End [i_Slot]) &
    #   (myConsumption$ID_MeterDevice == "M2")
    #
    # CurrentFilterList_M3 <-
    #   (myConsumption$Code_Year1_Month_01 >= mySlotData$Date_BalanceYears_Start [i_Slot]) &
    #   (myConsumption$Code_Year1_Month_01 <= mySlotData$Date_BalanceYears_End [i_Slot]) &
    #   (myConsumption$ID_MeterDevice == "M3")
#
#     mySlotData$Consumption_SumYears_M01 [i_Slot] <- 0
#     mySlotData$Consumption_SumYears_M02 [i_Slot] <- 0
#     mySlotData$Consumption_SumYears_M03 [i_Slot] <- 0
#
#
#     ID_Month <- "01" # for testing the loop
#
#     for (ID_Month in (AuxFunctions::Format_Integer_LeadingZeros(1:12,2))) {
#
#       # cat ("i_Slot = ", i_Slot, " ID_Month = ", ID_Month, " | " )
#
#       ### M1 -----
#
#       mySlotData [i_Slot, paste0 ("Consumption_SumYears_M01_Month", ID_Month)] <-
#         sum (
#           myConsumption [
#             CurrentFilterList_M1_Year1,
#             paste0 ("Consumption_Assigned_Year1_Month_", ID_Month)
#             ]
#         ) +
#         sum (
#           myConsumption [
#             CurrentFilterList_M1_Year2,
#             paste0 ("Consumption_Assigned_Year2_Month_", ID_Month)
#           ]
#         ) +
#         sum (
#           myConsumption [
#             CurrentFilterList_M1_Year3,
#             paste0 ("Consumption_Assigned_Year3_Month_", ID_Month)
#           ]
#         ) +
#         sum (
#           myConsumption [
#             CurrentFilterList_M1_Year4,
#             paste0 ("Consumption_Assigned_Year4_Month_", ID_Month)
#           ]
#         )
#
#       mySlotData$Consumption_SumYears_M01 [i_Slot] <-
#         mySlotData$Consumption_SumYears_M01 [i_Slot] +
#         mySlotData [i_Slot, paste0 ("Consumption_SumYears_M01_Month", ID_Month)]
#
#
#       ### M2 -----
#
#       mySlotData [i_Slot, paste0 ("Consumption_SumYears_M02_Month", ID_Month)] <-
#         sum (
#           myConsumption [
#             CurrentFilterList_M2_Year1,
#             paste0 ("Consumption_Assigned_Year1_Month_", ID_Month)
#           ]
#         ) +
#         sum (
#           myConsumption [
#             CurrentFilterList_M2_Year2,
#             paste0 ("Consumption_Assigned_Year2_Month_", ID_Month)
#           ]
#         ) +
#         sum (
#           myConsumption [
#             CurrentFilterList_M2_Year3,
#             paste0 ("Consumption_Assigned_Year3_Month_", ID_Month)
#           ]
#         ) +
#         sum (
#           myConsumption [
#             CurrentFilterList_M2_Year4,
#             paste0 ("Consumption_Assigned_Year4_Month_", ID_Month)
#           ]
#         )
#
#       mySlotData$Consumption_SumYears_M02 [i_Slot] <-
#         mySlotData$Consumption_SumYears_M02 [i_Slot] +
#         mySlotData [i_Slot, paste0 ("Consumption_SumYears_M02_Month", ID_Month)]
#
#
#       ### M3 -----
#
#       mySlotData [i_Slot, paste0 ("Consumption_SumYears_M03_Month", ID_Month)] <-
#         sum (
#           myConsumption [
#             CurrentFilterList_M3_Year1,
#             paste0 ("Consumption_Assigned_Year1_Month_", ID_Month)
#           ]
#         ) +
#         sum (
#           myConsumption [
#             CurrentFilterList_M3_Year2,
#             paste0 ("Consumption_Assigned_Year2_Month_", ID_Month)
#           ]
#         ) +
#         sum (
#           myConsumption [
#             CurrentFilterList_M3_Year3,
#             paste0 ("Consumption_Assigned_Year3_Month_", ID_Month)
#           ]
#         ) +
#         sum (
#           myConsumption [
#             CurrentFilterList_M3_Year4,
#             paste0 ("Consumption_Assigned_Year4_Month_", ID_Month)
#           ]
#         )
#
#       mySlotData$Consumption_SumYears_M03 [i_Slot] <-
#         mySlotData$Consumption_SumYears_M03 [i_Slot] +
#         mySlotData [i_Slot, paste0 ("Consumption_SumYears_M03_Month", ID_Month)]
#
#
#
#     } # End of loop by month
#
#
#   } # End of loop by slot
#

  mySlotData$Consumption_Year_M01 <-
    AuxFunctions::Replace_NA (
      mySlotData$Consumption_SumYears_M01	/ mySlotData$n_Year,
      0
    )

  mySlotData$Consumption_Year_M02 <-
    AuxFunctions::Replace_NA (
      mySlotData$Consumption_SumYears_M02	/ mySlotData$n_Year,
      0
    )

  mySlotData$Consumption_Year_M03 <-
    AuxFunctions::Replace_NA (
      mySlotData$Consumption_SumYears_M03	/ mySlotData$n_Year,
      0
    )



  mySlotData$Indicator_Completeness_Consumption <-
    ifelse (
      mySlotData$Multiplier_Contribution_M01 != 0,
      ifelse (mySlotData$Consumption_Year_M01 == 0, 0, 1),
      1
    ) * ifelse (
      mySlotData$Multiplier_Contribution_M02 != 0,
      ifelse (mySlotData$Consumption_Year_M02 == 0, 0, 1),
      1
    ) * ifelse (
      mySlotData$Multiplier_Contribution_M03 != 0,
      ifelse (mySlotData$Consumption_Year_M03 == 0, 0, 1),
      1
    )
  # <CM24> | Check: Are consumption values available where they are expected?  |
  # If a multiplier for M_01, M_02 or M_03 is equal +1 or -1 there should be a value
  # to be considered. Otherwise the data seem to be uncomplete and should be
  # excluded from evaluation

  mySlotData$Consumption_Year <-
    mySlotData$Indicator_Completeness_Consumption * (
      mySlotData$Multiplier_Contribution_M01 * mySlotData$Consumption_Year_M01 +
      mySlotData$Multiplier_Contribution_M02 * mySlotData$Consumption_Year_M02 +
      mySlotData$Multiplier_Contribution_M03 * mySlotData$Consumption_Year_M03
    )
  # <CN24> | kWh/a | Real

  # cat (mySlotData$Indicator_Completeness_Consumption, fill = TRUE)
  # cat (mySlotData$Multiplier_Contribution_M01, fill = TRUE)
  # cat (mySlotData$Consumption_Year_M01, fill = TRUE)
  # cat (mySlotData$Multiplier_Contribution_M02, fill = TRUE)
  # cat (mySlotData$Consumption_Year_M02, fill = TRUE)
  # cat (mySlotData$Multiplier_Contribution_M03, fill = TRUE)
  # cat (mySlotData$Consumption_Year_M03, fill = TRUE)

  mySlotData$Code_TypeCompareMeterCalc <-
    as.character (myGeneralData [1,
                                 AuxFunctions::Format_Integer_LeadingZeros (1:n_Slot_MeterCalcComparison,
                                                              2, "Code_TypeCompareMeterCalc_")] )
  # Data.Out.TABULA <AFG13> | Utilisation "heating" included in comparison with
  # calculated consumption | Form.Building | Integer | Code_TypeCompareMeterCalc_01 | 322



  ###################################################################################X
  ## 2.6  Prepare DHW comparison data <W>  -----

  # cat ("Prepare DHW comparison data <W>", fill = TRUE)

  mySlotData$Indicator_SysW_IncludedInComparison <-
    ifelse (
      (mySlotData$Multiplier_Contribution_M01 *
         AuxFunctions::Reformat_InputData_Boolean (
           myGeneralData$Indicator_Utilisation_Metering_DHW_M1
         ) +
         mySlotData$Multiplier_Contribution_M02 *
         AuxFunctions::Reformat_InputData_Boolean (
           myGeneralData$Indicator_Utilisation_Metering_DHW_M2
         ) +
         mySlotData$Multiplier_Contribution_M03 *
         AuxFunctions::Reformat_InputData_Boolean (
           myGeneralData$Indicator_Utilisation_Metering_DHW_M3
         )
      ) <= 0,
      0,
      1)
  # <BDN24> | Information if the total conumption including DHW is reduced
  # by the DHW metering (comparison of heating only)



  # Test of loop
  i_Device <-1

  for (i_Device in c(1,2,3))  {

    mySlotData [, AuxFunctions::Format_Integer_LeadingZeros (i_Device, 2, "Code_SysW_EC_Temp_M")] <-
      ifelse (
        (mySlotData [,
                     AuxFunctions::Format_Integer_LeadingZeros (
                       i_Device, 2, "Multiplier_Contribution_M")] *
           mySlotData$Indicator_SysW_IncludedInComparison) == 1,
        ifelse (AuxFunctions::Reformat_InputData_Boolean (
          myGeneralData  [1,
                          paste0 (
                            "Indicator_Utilisation_Metering_DHW_M",
                            i_Device)
          ]
        ) == 1,
        myGeneralData  [1,
                        paste0 (
                          "Code_EC_M",
                          i_Device)
        ],
        "-"),
        "-")
    # <BDO24> | Meter 01 | VarChar

    Code_SysW_EC_Temp_M_Current <-
      mySlotData [, AuxFunctions::Format_Integer_LeadingZeros (i_Device, 2, "Code_SysW_EC_Temp_M")]

    mySlotData [ ,
                AuxFunctions::Format_Integer_LeadingZeros (
      i_Device, 2, "Code_Level_MeterComparison_Temp_SysW_M")
      ] <-
      ifelse (Code_SysW_EC_Temp_M_Current == "-",
              "-",
              ifelse (
                Code_SysW_EC_Temp_M_Current == "Water_DHW",
                "U-V",
                ifelse (
                  AuxFunctions::Reformat_InputData_Boolean (
                    myGeneralData [1,
                                   paste0 ("Indicator_Metering_HeatingPlant_M", i_Device) ]
                  ) == 1,
                  "UDSC",
                  ifelse (
                    AuxFunctions::Reformat_InputData_Boolean (
                      myGeneralData [1,
                                     paste0 ("Indicator_MeteringApartment_M", i_Device) ]
                    ) == 1,
                    "US",
                    "UDS"
                  )
                ) %xl_JoinStrings%
                  ifelse (Code_SysW_EC_Temp_M_Current == "Heat",
                          "-H",
                          ifelse (
                            AuxFunctions::xl_OR (
                              Code_SysW_EC_Temp_M_Current == "DH",
                              Code_SysW_EC_Temp_M_Current == "El",
                              Code_SysW_EC_Temp_M_Current == "El_OP"),
                            mySlotData [,
                                        AuxFunctions::Format_Integer_LeadingZeros (
                                          i_Device, 2,
                                          "Indicator_Temp_AuxIncluded_M"
                                        )
                            ] %xl_JoinStrings% "-E",
                            "-F"))))
    # <BDR24> | Change "Heat" to "HeatDemand" or "HeatGeneration" | Meter 01 | VarChar

  } # End of loop by i_Device



  mySlotData$Index_M_Relevant_SysW <-
    if (myGeneralData$Code_Completeness_Metering_DHW [1] == "Yes") {
      ifelse (
        mySlotData$Code_Level_MeterComparison_Temp_SysW_M01 != "-",
        1,
        ifelse (
          mySlotData$Code_Level_MeterComparison_Temp_SysW_M02 != "-",
          2,
          ifelse (
            mySlotData$Code_Level_MeterComparison_Temp_SysW_M03 != "-",
            3,
            "-"
          )
        )
      )
    } else {
      "-"
    }
  # <BDU24> | Index indicating if M1, M2 or M3 is relevant


  mySlotData$Code_SysW_EC_Temp_Relevant <-
    ifelse (mySlotData$Index_M_Relevant_SysW == "1",
            mySlotData$Code_SysW_EC_Temp_M01,
            ifelse (mySlotData$Index_M_Relevant_SysW == "2",
                    mySlotData$Code_SysW_EC_Temp_M02,
                    ifelse (mySlotData$Index_M_Relevant_SysW == "3",
                            mySlotData$Code_SysW_EC_Temp_M03,
                            "-")
            )
    )
  # <BDV24> | relevant metering quantity | VarChar

  mySlotData$Code_Domain_MeterComparison_SysW <-
    ifelse (mySlotData$Index_M_Relevant_SysW == "1",
            mySlotData$Code_Level_MeterComparison_Temp_SysW_M01,
            ifelse (mySlotData$Index_M_Relevant_SysW == "2",
                    mySlotData$Code_Level_MeterComparison_Temp_SysW_M02,
                    ifelse (mySlotData$Index_M_Relevant_SysW == "3",
                            mySlotData$Code_Level_MeterComparison_Temp_SysW_M03,
                            "-")
            )
    )
  # <BDW24> | VarChar

  mySlotData$Code_Level_MeterComparison_SysW <-
    ifelse (
      mySlotData$Code_Domain_MeterComparison_SysW == "-",
      "-",
      ifelse (
        mySlotData$Code_Domain_MeterComparison_SysW == "UDSC-H",
        "HeatDemand",
        ifelse (
          AuxFunctions::xl_OR (
            AuxFunctions::xl_RIGHT (mySlotData$Code_Domain_MeterComparison_SysW, 1) == "H",
            AuxFunctions::xl_RIGHT (mySlotData$Code_Domain_MeterComparison_SysW, 1) == "V"
          ),
          "HeatDemand",
          "EnergyCarrier"
        )
      )
    )
  # <BDX24> | level of metering for DHW | Pre-defined codes:
  # "HeatDemand"
  # "HeatGeneration"
  # "EnergyCarrier"
  # "-" | VarChar | Transfer to Calculator"

  mySlotData$Multiplier_MeterComparison_q_w_nd <-
    ifelse (AuxFunctions::xl_LEFT (mySlotData$Code_Domain_MeterComparison_SysW, 1) == "U",
            1,
            0)
  # <BDY24> | multiplier for making calculation comparable with metered values | standard value: 1; may be changed to 0 or other values if this energy balance contribution is not or not entirely included in the respective meter | considered case: "HeatDemand" | Real | Transfer to Calculator

  mySlotData$Multiplier_MeterComparison_q_d_w <-
    ifelse (AuxFunctions::xl_MID (mySlotData$Code_Domain_MeterComparison_SysW, 2, 1) == "D",
            1,
            0)
  # <BDZ24> | multiplier for making calculation comparable with metered values | standard value: 1; may be changed to 0 or other values if this energy balance contribution is not or not entirely included in the respective meter | considered case: "HeatDemand" | Real | Transfer to Calculator

  mySlotData$Multiplier_MeterComparison_q_s_w <-
    ifelse (AuxFunctions::xl_OR (
      AuxFunctions::xl_MID (mySlotData$Code_Domain_MeterComparison_SysW, 2, 1) == "S",
      AuxFunctions::xl_MID (mySlotData$Code_Domain_MeterComparison_SysW, 3, 1) == "S"
    ), 1, 0)
  # <BEA24> | multiplier for making calculation comparable with metered values | standard value: 1; may be changed to 0 or other values if this energy balance contribution is not or not entirely included in the respective meter | considered case: "HeatDemand" | Real | Transfer to Calculator

  mySlotData$Multiplier_MeterComparison_q_dh_w <-
    ifelse (AuxFunctions::xl_MID (mySlotData$Code_Domain_MeterComparison_SysW, 4, 1) == "C",
            1,
            0)
  # <BEB24> | multiplier for making calculation comparable with metered values | standard value: 1; may be changed to 0 or other values if this energy balance contribution is not or not entirely included in the respective meter | considered cases: "HeatDemand" or "EnergyCarrier" | include heat losses of connection pipes between buidings and heating plant (district heating) | Real | Transfer to Calculator


  mySlotData$Multiplier_MeterComparison_q_del_w_1 <-
    ifelse (mySlotData$Code_SysW_EC_Temp_Relevant == "-",
            0,
            AuxFunctions::Reformat_InputData_Boolean (
              AuxFunctions::Replace_NA (
                AuxFunctions::xl_FIND (
                  mySlotData$Code_SysW_EC_Temp_Relevant,
                  rep.int (myGeneralData$Code_SysW_EC_1 [1], n_Slot_MeterCalcComparison)
                ) > 0,
                0
              )
            )
    )
  # <BEC24> | multiplier for making calculation comparable with metered values |
  # standard value: 1; may be changed to 0 or other values if this energy balance contribution
  # is not or not entirely included in the respective meter |
  # considered cases: "HeatDemand" or "EnergyCarrier" | Real | Transfer to Calculator

  mySlotData$Multiplier_MeterComparison_q_del_w_2 <-
    ifelse (mySlotData$Code_SysW_EC_Temp_Relevant == "-",
            0,
            AuxFunctions::Reformat_InputData_Boolean (
              AuxFunctions::Replace_NA (
                AuxFunctions::xl_FIND (
                  mySlotData$Code_SysW_EC_Temp_Relevant,
                  rep.int (myGeneralData$Code_SysW_EC_2 [1], n_Slot_MeterCalcComparison)
                ) > 0,
                0
              )
            )
    )

  mySlotData$Multiplier_MeterComparison_q_del_w_3 <-
    ifelse (mySlotData$Code_SysW_EC_Temp_Relevant == "-",
            0,
            AuxFunctions::Reformat_InputData_Boolean (
              AuxFunctions::Replace_NA (
                AuxFunctions::xl_FIND (
                  mySlotData$Code_SysW_EC_Temp_Relevant,
                  rep.int (myGeneralData$Code_SysW_EC_3 [1], n_Slot_MeterCalcComparison)
                ) > 0,
                0
              )
            )
    )

  # Check result
  mySlotData$Code_SysW_EC_Temp_Relevant
  # mySlotData$Multiplier_MeterComparison_q_del_w_1
  # mySlotData$Multiplier_MeterComparison_q_del_w_2
  # mySlotData$Multiplier_MeterComparison_q_del_w_3


  mySlotData$Multiplier_MeterComparison_q_del_w_aux <-
    AuxFunctions::Replace_NA ((
      AuxFunctions::xl_FIND ("A-E", mySlotData$Code_Domain_MeterComparison_SysW, 1) > 0
    ) * 1, 0)
  # <BEF24> | multiplier for making calculation comparable with metered values |
  # standard value: 1; may be changed to 0 or other values if this energy balance
  # contribution is not or not entirely included in the respective meter |
  # considered case: "EnergyCarrier" | Real | Transfer to Calculator

  mySlotData$Multiplier_MeterComparison_q_prod_el_w_1 <-
    0
  # <BEG24> | multiplier for making calculation comparable with metered values |
  # standard value: 0; may be changed to -1 or other negative values if the
  # energy production has a reducing effect on the respective metered consumption |
  # considered case: "EnergyCarrier" |
  # still to be considered --> Introduce indicator in Form.Metering | Real | Transfer to Calculator

  mySlotData$Multiplier_MeterComparison_q_prod_el_w_2 <-
    0
  # <BEH24> | multiplier for making calculation comparable with metered values |
  # standard value: 0; may be changed to -1 or other negative values if the
  # energy production has a reducing effect on the respective metered consumption |
  # considered case: "EnergyCarrier" | still to be considered
  # --> Introduce indicator in Form.Metering | Real | Transfer to Calculator

  mySlotData$Multiplier_MeterComparison_q_prod_el_w_3 <-
    0
  # <BEI24> | multiplier for making calculation comparable with metered values |
  # standard value: 0; may be changed to -1 or other negative values if the
  # energy production has a reducing effect on the respective metered consumption |
  # considered case: "EnergyCarrier" | still to be considered
  # --> Introduce indicator in Form.Metering | Real | Transfer to Calculator



  ###################################################################################X
  ## 2.7  Prepare heating comparison data <H>   -----

  # cat ("Prepare heating comparison data <H>", fill = TRUE)

  # Test of loop
  i_Device <-1

  for (i_Device in c(1,2,3))  {

    mySlotData [, AuxFunctions::Format_Integer_LeadingZeros (i_Device, 2, "Code_SysH_EC_Temp_M")] <-
      ifelse (
        mySlotData [, AuxFunctions::Format_Integer_LeadingZeros (i_Device, 2, "Multiplier_Contribution_M")] == 1,
        ifelse (AuxFunctions::Reformat_InputData_Boolean(
          myGeneralData  [1,
                          paste0 (
                            "Indicator_Utilisation_Metering_Heating_M",
                            i_Device)
          ]
        ) == 1,
        myGeneralData  [1,
                        paste0 (
                          "Code_EC_M",
                          i_Device)
        ],
        "-"),
        "-")
    # <BEJ24> | Meter 01 | VarChar

    Code_SysH_EC_Temp_M_Current <-
      mySlotData [, AuxFunctions::Format_Integer_LeadingZeros (i_Device, 2, "Code_SysH_EC_Temp_M")]

    mySlotData [, AuxFunctions::Format_Integer_LeadingZeros (i_Device, 2, "Code_Level_MeterComparison_Temp_SysH_M")] <-
      ifelse (Code_SysH_EC_Temp_M_Current == "-",
              "-",
              ifelse (
                AuxFunctions::Reformat_InputData_Boolean (
                  myGeneralData [1,
                                 paste0 ("Indicator_Metering_HeatingPlant_M", i_Device) ]
                ) == 1,
                "UDSC",
                ifelse (
                  AuxFunctions::Reformat_InputData_Boolean (
                    myGeneralData [1,
                                   paste0 ("Indicator_MeteringApartment_M", i_Device) ]
                  ) == 1,
                  "US",
                  "UDS"
                )
              ) %xl_JoinStrings%
                ifelse (Code_SysH_EC_Temp_M_Current == "Heat",
                        "-H",
                        ifelse (
                          AuxFunctions::xl_OR (
                            Code_SysH_EC_Temp_M_Current == "DH",
                            Code_SysH_EC_Temp_M_Current == "El",
                            Code_SysH_EC_Temp_M_Current == "El_OP"),
                          mySlotData [,
                                      AuxFunctions::Format_Integer_LeadingZeros (
                                        i_Device, 2,
                                        "Indicator_Temp_AuxIncluded_M"
                                      )
                          ] %xl_JoinStrings% "-E",
                          "-F")))
    # <BEM24> | Change "Heat" to "HeatDemand" or "HeatGeneration" | Meter 01 |
    # Hier dürfte das "S" nur auftauchen, wenn es einen Heizungspufferspeicher gibt
    # --> noch verbessern | VarChar

  } # End of loop by i_Device

  # Check results
  # mySlotData$Code_Level_MeterComparison_Temp_SysH_M01
  # mySlotData$Code_SysH_EC_Temp_M01
  # mySlotData$Code_Level_MeterComparison_Temp_SysH_M02
  # mySlotData$Code_SysH_EC_Temp_M02
  # mySlotData$Code_Level_MeterComparison_Temp_SysH_M03
  # mySlotData$Code_SysH_EC_Temp_M03


  mySlotData$Index_M_Relevant_SysH <-
    if (myGeneralData$Code_Completeness_Metering_Heating [1] == "Yes") {
      ifelse (
        mySlotData$Code_Level_MeterComparison_Temp_SysH_M01 != "-",
        1,
        ifelse (
          mySlotData$Code_Level_MeterComparison_Temp_SysH_M02 != "-",
          2,
          ifelse (
            mySlotData$Code_Level_MeterComparison_Temp_SysH_M03 != "-",
            3,
            "-"
          )
        )
      )
    } else {
      "-"
    }
  # <BEP24> | Index indicating if M1, M2 or M3 is relevant

  mySlotData$Code_SysH_EC_Temp_Relevant <-
    ifelse (mySlotData$Index_M_Relevant_SysH == "1",
            mySlotData$Code_SysH_EC_Temp_M01,
            ifelse (mySlotData$Index_M_Relevant_SysH == "2",
                    mySlotData$Code_SysH_EC_Temp_M02,
                    ifelse (mySlotData$Index_M_Relevant_SysH == "3",
                            mySlotData$Code_SysH_EC_Temp_M03,
                            "-")
            )
    )
  # <BEQ24> | relevant metering quantity | VarChar

  mySlotData$Code_Domain_MeterComparison_SysH <-
    ifelse (mySlotData$Index_M_Relevant_SysH == "1",
            mySlotData$Code_Level_MeterComparison_Temp_SysH_M01,
            ifelse (mySlotData$Index_M_Relevant_SysH == "2",
                    mySlotData$Code_Level_MeterComparison_Temp_SysH_M03,
                    ifelse (mySlotData$Index_M_Relevant_SysH == "3",
                            mySlotData$Code_Level_MeterComparison_Temp_SysH_M03,
                            "-")
            )
    )
  # <BER24> | VarChar

  mySlotData$Code_Level_MeterComparison_SysH <-
    ifelse (
      mySlotData$Code_Domain_MeterComparison_SysH == "-",
      "-",
      ifelse (
        mySlotData$Code_Domain_MeterComparison_SysH == "UDSC-H",
        "HeatDemand",
        ifelse (
          AuxFunctions::xl_RIGHT (mySlotData$Code_Domain_MeterComparison_SysH, 1) == "H",
          "HeatDemand",
          "EnergyCarrier"
        )
      )
    )
  # <BES24> | level of metering for space heating | Pre-defined codes | Real | Transfer to Calculator"

  mySlotData$Multiplier_MeterComparison_q_h_nd_eff <-
    ifelse (
      AuxFunctions::xl_LEFT (
        mySlotData$Code_Domain_MeterComparison_SysH, 1) == "U",
      1,
      0)
  # <BET24> | multiplier for making calculation comparable with metered values | standard value: 1; may be changed to 0 or other values if this energy balance contribution is not or not entirely included in the respective meter | considered case: "HeatDemand" | Real | Transfer to Calculator

  mySlotData$Multiplier_MeterComparison_q_d_h <-
    ifelse (AuxFunctions::xl_MID (mySlotData$Code_Domain_MeterComparison_SysH, 2, 1) == "D",
            1,
            0)
  # <BEU24> | multiplier for making calculation comparable with metered values | standard value: 1; may be changed to 0 or other values if this energy balance contribution is not or not entirely included in the respective meter | considered case: "HeatDemand" | 2021-04-01: Error detected; q_s_h and q_d_h were accidentally swapped | Real | Transfer to Calculator

  mySlotData$Multiplier_MeterComparison_q_s_h <-
    ifelse (AuxFunctions::xl_OR (
      AuxFunctions::xl_MID (mySlotData$Code_Domain_MeterComparison_SysH, 2, 1) == "S",
      AuxFunctions::xl_MID (mySlotData$Code_Domain_MeterComparison_SysH, 3, 1) == "S"
    ), 1, 0)
  # <BEV24> | multiplier for making calculation comparable with metered values | standard value: 1; may be changed to 0 or other values if this energy balance contribution is not or not entirely included in the respective meter | considered case: "HeatDemand" | 2021-04-01: Error detected; q_s_h and q_d_h were accidentally swapped | Real | Transfer to Calculator

  mySlotData$Multiplier_MeterComparison_q_dh_h <-
    ifelse (AuxFunctions::xl_MID (mySlotData$Code_Domain_MeterComparison_SysH, 4, 1) == "C",
            1,
            0)
  # <BEW24> | multiplier for making calculation comparable with metered values | standard value: 1; may be changed to 0 or other values if this energy balance contribution is not or not entirely included in the respective meter | considered cases: "HeatDemand" or "EnergyCarrier" | include heat losses of connection pipes between buidings and heating plant (district heating) | Real | Transfer to Calculator

  mySlotData$Multiplier_MeterComparison_q_del_h_1 <-
    ifelse (
      mySlotData$Code_SysH_EC_Temp_Relevant == "-",
      0,
      AuxFunctions::Replace_NA (
        AuxFunctions::xl_FIND (
          mySlotData$Code_SysH_EC_Temp_Relevant,
          rep (myGeneralData$Code_SysH_EC_1 [1], n_Slot_MeterCalcComparison) ,
          1
        ) > 0,
        0
      ) * 1
    )
  # <BEX24> | multiplier for making calculation comparable with metered values | standard value: 1; may be changed to 0 or other values if this energy balance contribution is not or not entirely included in the respective meter | considered cases: "HeatDemand" or "EnergyCarrier" | Real | Transfer to Calculator

  mySlotData$Multiplier_MeterComparison_q_del_h_2 <-
    ifelse (
      mySlotData$Code_SysH_EC_Temp_Relevant == "-",
      0,
      AuxFunctions::Replace_NA (
        AuxFunctions::xl_FIND (
          mySlotData$Code_SysH_EC_Temp_Relevant,
          rep (myGeneralData$Code_SysH_EC_2 [1], n_Slot_MeterCalcComparison) ,
          1
        ) > 0,
        0
      ) * 1
    )
  # <BEY24> | multiplier for making calculation comparable with metered values | standard value: 1; may be changed to 0 or other values if this energy balance contribution is not or not entirely included in the respective meter | considered cases: "HeatDemand" or "EnergyCarrier" | Real | Transfer to Calculator

  mySlotData$Multiplier_MeterComparison_q_del_h_3 <-
    ifelse (
      mySlotData$Code_SysH_EC_Temp_Relevant == "-",
      0,
      AuxFunctions::Replace_NA (
        AuxFunctions::xl_FIND (
          mySlotData$Code_SysH_EC_Temp_Relevant,
          rep (myGeneralData$Code_SysH_EC_3 [1], n_Slot_MeterCalcComparison) ,
          1
        ) > 0,
        0
      ) * 1
    )
  # <BEZ24> | multiplier for making calculation comparable with metered values | standard value: 1; may be changed to 0 or other values if this energy balance contribution is not or not entirely included in the respective meter | considered cases: "HeatDemand" or "EnergyCarrier" | Real | Transfer to Calculator

  mySlotData$Multiplier_MeterComparison_q_del_h_aux <-
    AuxFunctions::Replace_NA ((
      AuxFunctions::xl_FIND (
        "A-E",
        mySlotData$Code_Domain_MeterComparison_SysH,
        1
      ) > 0
    ) == 1,
    0) *
    (myGeneralData$Indicator_Utilisation_Metering_HeatingPlantAux_M1 [1] * 1)
  # <BFA24> | multiplier for making calculation comparable with metered values | standard value: 1; may be changed to 0 or other values if this energy balance contribution is not or not entirely included in the respective meter | considered case: "EnergyCarrier" | Real | Transfer to Calculator

  mySlotData$Multiplier_MeterComparison_q_del_ve_aux <-
    AuxFunctions::Replace_NA ((
      AuxFunctions::xl_FIND (
        "A-E",
        mySlotData$Code_Domain_MeterComparison_SysH,
        1
      ) > 0
    ) == 1, 0) *
    (myGeneralData$Indicator_Utilisation_Metering_VentilationAux_M1 [1] * 1)
  # <BFB24> | multiplier for making calculation comparable with metered values | standard value: 1; may be changed to 0 or other values if this energy balance contribution is not or not entirely included in the respective meter | considered case: "EnergyCarrier" | Real

  mySlotData$Multiplier_MeterComparison_q_prod_el_h_1 <- 0
  # <BFC24> | multiplier for making calculation comparable with metered values |
  # standard value: 0; may be changed to -1 or other negative values if the
  # energy production has a reducing effect on the respective metered consumption |
  # considered case: "EnergyCarrier" | Real
  mySlotData$Multiplier_MeterComparison_q_prod_el_h_2 <- 0
  # <BFD24> | multiplier for making calculation comparable with metered values |
  # standard value: 0; may be changed to -1 or other negative values if the
  # energy production has a reducing effect on the respective metered consumption |
  # considered case: "EnergyCarrier" | Real
  mySlotData$Multiplier_MeterComparison_q_prod_el_h_3 <- 0
  # <BFE24> | multiplier for making calculation comparable with metered values |
  # standard value: 0; may be changed to -1 or other negative values if the
  # energy production has a reducing effect on the respective metered consumption |
  # considered case: "EnergyCarrier" | Real





  ###################################################################################X
  ## 2.8  Prepare station climate data of the peridods   -----
  ###################################################################################X

  # cat ("Prepare station climate data of the peridods", fill = TRUE)

  ## Initialisation
  mySlotData$HeatingDays_MeterPeriod         <- NA
  mySlotData$Theta_e_MeterPeriod             <- NA
  mySlotData$I_Sol_HD_Hor_MeterPeriod        <- NA
  mySlotData$I_Sol_HD_East_MeterPeriod       <- NA
  mySlotData$I_Sol_HD_South_MeterPeriod      <- NA
  mySlotData$I_Sol_HD_West_MeterPeriod       <- NA
  mySlotData$I_Sol_HD_North_MeterPeriod      <- NA

  ## Initialisation
  mySlotData$f_Correction_Int     <- 1
  mySlotData$f_Correction_HDD     <- 1
  mySlotData$f_Correction_RHDD    <- 1
  mySlotData$f_Correction_Sol_HD  <- 1


  i_Slot <- 1
  for (i_Slot in (1 : n_Slot_MeterCalcComparison)) {

    if ((mySlotData$Month_Balance_Start [i_Slot] > 0) &&
        (mySlotData$Year_Balance_Start [i_Slot] > 0) &&
        (mySlotData$n_Year [i_Slot] > 0)) {

        # cat ("i_Slot                         = ", i_Slot, fill = TRUE)
        # cat ("myGeneralData$theta_i_calc     = ", myGeneralData$theta_i_calc, fill = TRUE)
        # cat ("myGeneralData$ID_PostCode_Calc = ", myGeneralData$ID_PostCode_Calc, fill = TRUE)
        # cat ("myGeneralData$theta_e_Base     = ", myGeneralData$theta_e_Base, fill = TRUE)

      # ResultOfFunction <-
        myResultList_ClimateByMonth <-
          CliDaMon::ClimateByMonth (

          # Tables from  data package: "clidamonger" "Climate Data Monthly Germany"
          myClimateData_PostCodes = myClimateData_PostCodes,
          myClimateData_StationTA = myClimateData_StationTA,
          myClimateData_TA_HD     = myClimateData_TA_HD,
          myClimateData_Sol       = myClimateData_Sol,
          myParTab_SolOrientEst   = myParTab_SolOrientEst,

          Indicator_Type_LocationBuilding = 1,
          # 1: by post code, 2: by weather station

          Indicator_Type_AssignStationToPostcode = 2,
          # 1: the closest, 2: the three closest stations (weighted by reciprocal distance)

          PostCode = myGeneralData$ID_PostCode_Calc,

          Code_ClimateStation = NA,

          Indicator_ExcludeSelectedStation = 0,
          # 0: Do not exclude = standard entry

          Month_Start = mySlotData$Month_Balance_Start [i_Slot],
          Year_Start = mySlotData$Year_Balance_Start [i_Slot],
          n_Year = mySlotData$n_Year [i_Slot],

          Temperature_HDD_Base = myGeneralData$theta_e_Base,

          Temperature_HDD_Room = myGeneralData$theta_i_calc,

          Degree_Inclination_Solar = 45 # arc degree

        )

      # str (
      #   ResultOfFunction
      # )



        CurrentDF_ClimMon <-
          myResultList_ClimateByMonth$DF_ClimCalc
        # CurrentDF_ClimMon <-
        #   ResultDataframe_ClimateByMonth (ResultOfFunction, myIndex_DF = 1)

        # cat ("CurrentDF_ClimMon$HD [13] = ", CurrentDF_ClimMon$HD [13], fill=TRUE)

      mySlotData$HeatingDays_MeterPeriod [i_Slot]         <- CurrentDF_ClimMon$HD [13]
      mySlotData$Theta_e_MeterPeriod [i_Slot]             <- CurrentDF_ClimMon$TA_HD [13]
      mySlotData$I_Sol_HD_Hor_MeterPeriod [i_Slot]        <- CurrentDF_ClimMon$G_Hor_HD [13]
      mySlotData$I_Sol_HD_East_MeterPeriod [i_Slot]       <- CurrentDF_ClimMon$G_E_HD [13]
      mySlotData$I_Sol_HD_South_MeterPeriod [i_Slot]      <- CurrentDF_ClimMon$G_S_HD [13]
      mySlotData$I_Sol_HD_West_MeterPeriod [i_Slot]       <- CurrentDF_ClimMon$G_W_HD [13]
      mySlotData$I_Sol_HD_North_MeterPeriod [i_Slot]      <- CurrentDF_ClimMon$G_N_HD [13]




    } # End if




  } # End of loop by slot


  DF_Temp <-
    as.data.frame (
      ClimateCalibration (
        theta_e_Base               = myGeneralData$theta_e_Base,      # single value
        theta_i_HDD                = myGeneralData$theta_i_calc,      # single value
        HeatingDays_PhysMod        = myGeneralData$HeatingDays,       # single value
        theta_e_PhysMod            = myGeneralData$theta_e,           # single value
        HeatingDays_MeterPeriod    = mySlotData$HeatingDays_MeterPeriod,  # slot vector
        theta_e_MeterPeriod        = mySlotData$Theta_e_MeterPeriod,      # slot vector

        I_Sol_HD_Hor_PhysMod       = myGeneralData$I_Sol_HD_Hor,      # single value
        I_Sol_HD_East_PhysMod      = myGeneralData$I_Sol_HD_East,     # single value
        I_Sol_HD_South_PhysMod     = myGeneralData$I_Sol_HD_South,    # single value
        I_Sol_HD_West_PhysMod      = myGeneralData$I_Sol_HD_West,     # single value
        I_Sol_HD_North_PhysMod     = myGeneralData$I_Sol_HD_North,    # single value

        I_Sol_HD_Hor_MeterPeriod   = mySlotData$I_Sol_HD_Hor_MeterPeriod    ,      # slot vector
        I_Sol_HD_East_MeterPeriod  = mySlotData$I_Sol_HD_East_MeterPeriod   ,      # slot vector
        I_Sol_HD_South_MeterPeriod = mySlotData$I_Sol_HD_South_MeterPeriod  ,      # slot vector
        I_Sol_HD_West_MeterPeriod  = mySlotData$I_Sol_HD_West_MeterPeriod   ,      # slot vector
        I_Sol_HD_North_MeterPeriod = mySlotData$I_Sol_HD_North_MeterPeriod         # slot vector
      )
    )

  mySlotData$f_Correction_Int     <- 1 # not used until now

  mySlotData$f_Correction_HDD     <-
    AuxFunctions::Replace_NA (DF_Temp$f_Correction_HDD, 1)

  mySlotData$f_Correction_RHDD     <-
    AuxFunctions::Replace_NA (DF_Temp$f_Correction_RHDD, 1)

  mySlotData$f_Correction_Sol_HD  <-
    AuxFunctions::Replace_NA (DF_Temp$f_Correction_Sol_HD, 1)


  return (mySlotData)


} # End of function PrepareMeterCalcSlots ()


## End of the function PrepareMeterCalcSlots () -----
#####################################################################################X


# . -----





#####################################################################################X
## FUNCTION "CalculateMeterCalcSlots ()" -----
#####################################################################################X


CalculateMeterCalcSlots <- function (
    myGeneralData, # Dataset from Data_Calc of one building
    mySlotCalcData
)

{

  ###################################################################################X
  # A  DESCRIPTIOM  -----
  ###################################################################################X


  ###################################################################################X
  # Climate correction of the energy performance calculation  -----

  ## Method 1 - Correction of total calculation by "heating degree days" HDD ("Heizgradtage")
  #
  # Code_Type_ConsiderActualClimate == "Correction_Temperature"
  # All terms of the calculated energy demand for heating are adapted to the
  # real climate of the year
  # (Annotation: A widely spread method is to correct the metered consumption
  # by the inverse factor and to leave the calculation unaltered.)
  #
  # f_Correction_HDD
  # Correction factor heating degree days HDD (difference to base temperature)
  # Used for correcting the energy demand as a total


  ## Method 2 - Correction of the respective building calculation terms
  ## by "room heating degree days" RHDD ("Gradtagzahl") and by solar radiation
  #
  # Code_Type_ConsiderActualClimate == "Correction_Temperature_Solar"
  # This provides realistic results of an energy performance calculation
  # for each metering year but with only one standard calculation
  # (e.g. long-term average at the location).
  #
  # f_Correction_RHDD
  # Correction factor room heating degree days RHDD (difference to room temperature)
  # Used for correcting the heat loss term of the building energy balance calculation
  #
  # f_Correction_Sol_HD
  # Correction factor passive solar radiation
  # Used for correcting the passive solar gains term of the building energy balance calculation
  #
  # f_Correction_Int | currently not in use
  # Correction factor internal heat sources
  # Used for correcting the internal heat gains term of the building energy balance calculation


  ###################################################################################X
  # B  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X
  ## After debugging: Comment this section

  # myGeneralData     <- myDataset
  # # Dataset from Data_Calc of one building, defined in MeterCalcSingleBuilding ()
  #
  # mySlotCalcData    <- DF_MeterCalcSlots  # defined in PrepareMeterCalcSlots ()


  ###################################################################################X
  # C  FUNCTION SCRIPT   -----
  ###################################################################################X

  ###################################################################################X
  ## 0  Constants   -----
  ###################################################################################X

  n_Slot_MeterCalcComparison <- 9



  ###################################################################################X
  ## 1  Assign the matching balance results to the comparison variables   -----


  i_DataSet_Building <- 1
  # Remark: A formver version of the following calculation included a loop by building.
  # Therefore the dataset index i_DataSet_Building is included in the formulas.
  # However, the function is currently only used for one building dataset.
  # The index was maintained due to simplification reasons
  # (and in case a fall back to the old concept is being considererd:)




  mySlotCalcData$q_compare_w_heat_demand <-
    ifelse (
      mySlotCalcData$Code_Level_MeterComparison_SysW == "HeatDemand",
      myGeneralData$q_w_nd [i_DataSet_Building] *
        mySlotCalcData$Multiplier_MeterComparison_q_w_nd +
        myGeneralData$q_s_w [i_DataSet_Building] *
        mySlotCalcData$Multiplier_MeterComparison_q_s_w +
        myGeneralData$q_d_w [i_DataSet_Building] *
        mySlotCalcData$Multiplier_MeterComparison_q_d_w
      ,
      0
    ) # <DY24> | Comparison value | HeatDemand | kWh/(m²a) | Real

  mySlotCalcData$q_compare_w_heat_generation <-
    ifelse (
      mySlotCalcData$Code_Level_MeterComparison_SysW == "HeatGeneration",
      myGeneralData$q_g_w_out [i_DataSet_Building] * (
        myGeneralData$Fraction_SysW_G_1 [i_DataSet_Building] *
          mySlotCalcData$Multiplier_MeterComparison_q_del_w_1 +
          myGeneralData$Fraction_SysW_G_2 [i_DataSet_Building] *
          mySlotCalcData$Multiplier_MeterComparison_q_del_w_2 +
          myGeneralData$Fraction_SysW_G_3 [i_DataSet_Building] *
          mySlotCalcData$Multiplier_MeterComparison_q_del_w_3
      ),
      0
    ) # <DZ24> | Comparison value | HeatGeneration | kWh/(m²a) | Real

  mySlotCalcData$q_compare_w_energy_carrier <-
    ifelse (
      mySlotCalcData$Code_Level_MeterComparison_SysW == "EnergyCarrier",
      myGeneralData$q_del_w_1 [i_DataSet_Building] *
        mySlotCalcData$Multiplier_MeterComparison_q_del_w_1 +
        myGeneralData$q_del_w_2 [i_DataSet_Building] *
        mySlotCalcData$Multiplier_MeterComparison_q_del_w_2 +
        myGeneralData$q_del_w_3 [i_DataSet_Building] *
        mySlotCalcData$Multiplier_MeterComparison_q_del_w_3 +
        myGeneralData$q_del_w_aux [i_DataSet_Building] *
        mySlotCalcData$Multiplier_MeterComparison_q_del_w_aux +
        myGeneralData$q_prod_el_w_1 [i_DataSet_Building] *
        mySlotCalcData$Multiplier_MeterComparison_q_prod_el_w_1 +
        myGeneralData$q_prod_el_w_2 [i_DataSet_Building] *
        mySlotCalcData$Multiplier_MeterComparison_q_prod_el_w_2 +
        myGeneralData$q_prod_el_w_3 [i_DataSet_Building] *
        mySlotCalcData$Multiplier_MeterComparison_q_prod_el_w_3
      ,
      0
    ) # <EA24> | Comparison value | EnergyCarrier | kWh/(m²a) | Real

  mySlotCalcData$q_compare_w_per_sqm <- NA # Result variable
  mySlotCalcData$q_compare_w_per_sqm <-
    mySlotCalcData$q_compare_w_heat_demand +
    mySlotCalcData$q_compare_w_heat_generation +
    mySlotCalcData$q_compare_w_energy_carrier
  # <EB24> | Comparison value | kWh/(m²a) | Real

  mySlotCalcData$Q_compare_w <-
    mySlotCalcData$q_compare_w_per_sqm *
    myGeneralData$A_C_Ref [i_DataSet_Building]
  # <EC24> | Comparison value | kWh/a | Real


  ###################################################################################X
  ## 2  Apply the climate correction   -----

  ## See explanations in section "A DESCCRIPTION"

  mySlotCalcData$q_h_nd_ClimateCorrection <-
    myGeneralData$q_ht [i_DataSet_Building] *
    mySlotCalcData$f_Correction_RHDD -
    (  myGeneralData$q_sol [i_DataSet_Building] *
         mySlotCalcData$f_Correction_Sol_HD +
         myGeneralData$q_int [i_DataSet_Building] *
         mySlotCalcData$f_Correction_Int [i_DataSet_Building] ) *
    myGeneralData$eta_h_gn [i_DataSet_Building]
  # <EL24>

  mySlotCalcData$Delta_q_ClimateCorrection_HDD_Sol <-
    ifelse (
      rep (
        myGeneralData$Code_Type_ClimateCorrection [i_DataSet_Building],
        n_Slot_MeterCalcComparison
        ) == "Correction_Temperature_Solar",
      mySlotCalcData$q_h_nd_ClimateCorrection -
        myGeneralData$q_h_nd  [i_DataSet_Building],
      0
    )
  # <FX24> | Climate correction of energy balance - version 1: detailed
  # method using ratios of HDD and solar irradiance

  mySlotCalcData$f_ClimateCorrection_HDD_Factor <-
    ifelse (
      myGeneralData$Code_Type_ClimateCorrection [i_DataSet_Building] ==
        "Correction_Temperature",
      mySlotCalcData$f_Correction_HDD,
      1
    )
  # <FY24> | Climate correction of energy balance - version 2: simple method using ratios of HDD


  ###################################################################################X
  ## 3  Determine comparison values at 3 possible levels   -----

  mySlotCalcData$q_compare_h_heat_demand <-
    ifelse (
      mySlotCalcData$Code_Level_MeterComparison_SysH == "HeatDemand",
      (
        myGeneralData$q_h_nd_eff [i_DataSet_Building]	*
          mySlotCalcData$Multiplier_MeterComparison_q_h_nd_eff +
          myGeneralData$q_s_h	[i_DataSet_Building] *
          mySlotCalcData$Multiplier_MeterComparison_q_s_h +
          myGeneralData$q_d_h [i_DataSet_Building] *
          mySlotCalcData$Multiplier_MeterComparison_q_d_h
      ) *
        mySlotCalcData$f_ClimateCorrection_HDD_Factor +
        mySlotCalcData$Delta_q_ClimateCorrection_HDD_Sol,
      0
    )
  # <FZ24> | Comparison value | HeatDemand | kWh/(m²a) | Real

  mySlotCalcData$q_compare_h_heat_generation <-
    ifelse (
      mySlotCalcData$Code_Level_MeterComparison_SysH == "HeatGeneration",
      ( myGeneralData$q_g_h_out [i_DataSet_Building] +
          mySlotCalcData$Delta_q_ClimateCorrection_HDD_Sol ) *
        mySlotCalcData$f_ClimateCorrection_HDD_Factor *
        (myGeneralData$Fraction_SysH_G_1 [i_DataSet_Building]*
            mySlotCalcData$Multiplier_MeterComparison_q_del_h_1 +
            myGeneralData$Fraction_SysH_G_2 [i_DataSet_Building] *
            mySlotCalcData$Multiplier_MeterComparison_q_del_h_2 +
            myGeneralData$Fraction_SysH_G_3 [i_DataSet_Building] *
            mySlotCalcData$Multiplier_MeterComparison_q_del_h_3)
      ,
      0
    )
  # <GA24> | Comparison value | HeatGeneration | kWh/(m²a) | Real

  mySlotCalcData$q_compare_h_energy_carrier <-
    ifelse (
      mySlotCalcData$Code_Level_MeterComparison_SysH == "EnergyCarrier",
      (  myGeneralData$q_del_h_1 [i_DataSet_Building] *
           mySlotCalcData$Multiplier_MeterComparison_q_del_h_1 +
           myGeneralData$q_del_h_2 [i_DataSet_Building] *
           mySlotCalcData$Multiplier_MeterComparison_q_del_h_2 +
           myGeneralData$q_del_h_3 [i_DataSet_Building] *
           mySlotCalcData$Multiplier_MeterComparison_q_del_h_3 +
           myGeneralData$q_del_h_aux	[i_DataSet_Building] *
           mySlotCalcData$Multiplier_MeterComparison_q_del_h_aux	+
           myGeneralData$q_del_ve_aux [i_DataSet_Building] *
           mySlotCalcData$Multiplier_MeterComparison_q_del_ve_aux +
           myGeneralData$q_prod_el_h_1 [i_DataSet_Building] *
           mySlotCalcData$Multiplier_MeterComparison_q_prod_el_h_1 +
           myGeneralData$q_prod_el_h_2 [i_DataSet_Building] *
           mySlotCalcData$Multiplier_MeterComparison_q_prod_el_h_2 +
           myGeneralData$q_prod_el_h_3 [i_DataSet_Building] *
           mySlotCalcData$Multiplier_MeterComparison_q_prod_el_h_3
      ) * (
        ( myGeneralData$q_g_h_out [i_DataSet_Building] +
          mySlotCalcData$Delta_q_ClimateCorrection_HDD_Sol) /
          myGeneralData$q_g_h_out [i_DataSet_Building]
      ) * mySlotCalcData$f_ClimateCorrection_HDD_Factor,
      0
    )
  # <GB24> | Comparison value | EnergyCarrier | kWh/(m²a) | Real

  mySlotCalcData$q_compare_h_per_sqm <- NA # Result variable
  mySlotCalcData$q_compare_h_per_sqm <-
    mySlotCalcData$q_compare_h_heat_demand +
    mySlotCalcData$q_compare_h_heat_generation +
    mySlotCalcData$q_compare_h_energy_carrier
  # <GC24> | Comparison value | kWh/(m²a) | Real

  mySlotCalcData$Q_compare_h <-
    mySlotCalcData$q_compare_h_per_sqm *
    myGeneralData$A_C_Ref [i_DataSet_Building]
  # <GD24> | Comparison value | kWh/a | Real

  mySlotCalcData$Indicator_PlausibilityComparison <-
    (
      AuxFunctions::Replace_NA (
        pmin (pmax (AuxFunctions::xl_FIND ("H", mySlotCalcData$Code_TypeCompareMeterCalc), 0), 1),
        0
      ) == (mySlotCalcData$Code_Domain_MeterComparison_SysH != "-") * 1
    ) * (
      AuxFunctions::Replace_NA (
        pmin (pmax (AuxFunctions::xl_FIND ("W", mySlotCalcData$Code_TypeCompareMeterCalc), 0), 1),
        0
      ) == (mySlotCalcData$Code_Domain_MeterComparison_SysW != "-") * 1
    ) * 1 # <GH24>

  # cat (mySlotCalcData$Indicator_PlausibilityComparison, fill = TRUE)

  mySlotCalcData$Q_calc <-
    ifelse (
      mySlotCalcData$Indicator_PlausibilityComparison == 0,
      NA,
      ifelse (
        mySlotCalcData$Indicator_CalcAdapt_M * 1 == 1,
        mySlotCalcData$F_CalcAdapt_M,
        1
      ) * (
        mySlotCalcData$Q_compare_w + mySlotCalcData$Q_compare_h
      )
    )
  # <GU24> | Calculated energy demand, comparison value | kWh/a | Real


  mySlotCalcData$Q_meter <-
    ifelse (
      mySlotCalcData$Indicator_PlausibilityComparison == 0,
      NA,
      mySlotCalcData$Consumption_Year
    )
  # <GV24> | Metered energy demand, comparison value | kWh/a | Real

  # cat (mySlotCalcData$Q_meter, fill = TRUE)

  ###################################################################################X
  ## 4  Determine the indicator pair for direct comparison  -----

  # Result variables
  # This assures that these needed variables are existing even in case of calculation errors
  mySlotCalcData$q_calc_per_sqm       <- NA
  mySlotCalcData$q_meter_per_sqm      <- NA
  mySlotCalcData$ratio_q_meter_q_calc <- NA

  mySlotCalcData$q_calc_per_sqm <-
    mySlotCalcData$Q_calc / myGeneralData$A_C_Ref [i_DataSet_Building]
  # <GW24> | Calculated energy demand, comparison value |
  # Value related to reference floor area | kWh/(m²a) | Real

  mySlotCalcData$q_meter_per_sqm <-
    mySlotCalcData$Q_meter / myGeneralData$A_C_Ref [i_DataSet_Building]
  # <GX24> | Metered energy demand, comparison value |
  # Value related to reference floor area | kWh/(m²a) | Real

  # cat (mySlotCalcData$q_meter_per_sqm, fill = TRUE)


  mySlotCalcData$ratio_q_meter_q_calc <-
    AuxFunctions::Replace_NA (mySlotCalcData$q_meter_per_sqm / mySlotCalcData$q_calc_per_sqm, 0)
  # <GY24> | Ratio of the comparison values of the metered energy consumption
  # to the calculted energy demand | Real


  ###################################################################################X
  ## 5  Option (not yet implemented): Application of calibration from other building variant -----

  ## This commented section can remain to be later used as template for programming
  #
  ## Section for improving a prognosis if the measured energy consumption is known
  ## (useful for energy advice, for method see study "Berücksichtigung des Nutzerverhaltens
  ## bei individuellen Verbesserungen", on behalf of BBSR, IWU 2018)
  #
  ## implemented in EnergyProfile.xlsm but not yet in R
  #
  #
  # mySlotCalcData$q_calc_compare <-
  #   ifelse (
  #     mySlotCalcData$Indicator_PlausibilityComparison == 0,
  #     ,
  #     (
  #       mySlotCalcData$Q_compare_w + mySlotCalcData$Q_compare_h
  #     ) / mySlotCalcData$A_C_Ref
  #   ) # <GJ24> | Calculated energy demand, comparison value | Section for improving a prognosis if the measured energy consumption is known (useful for energy advice, for method see study "Berücksichtigung des Nutzerverhaltens bei individuellen Verbesserungen", on behalf of BBSR, IWU 2018) | kWh/(m²a)
  # mySlotCalcData$q_calc_compare_adapted <-
  #   ifelse (
  #     mySlotCalcData$Indicator_PlausibilityComparison == 0,
  #     ,
  #     mySlotCalcData$q_calc_compare * mySlotCalcData$F_CalcAdapt_M
  #   ) # <GK24> | Calculated energy demand (comparison value) adapted by empirical calibration factor = estimated energy consumption | Section for improving a prognosis if the measured energy consumption is known (useful for energy advice, for method see study "Berücksichtigung des Nutzerverhaltens bei individuellen Verbesserungen", on behalf of BBSR, IWU 2018) | kWh/(m²a)
  # mySlotCalcData$q_meter_compare <-
  #   ifelse (
  #     mySlotCalcData$Indicator_PlausibilityComparison == 0,
  #     ,
  #     mySlotCalcData$Consumption_Year / mySlotCalcData$A_C_Ref
  #   ) # <GL24> | Metered energy demand, comparison value | Section for improving a prognosis if the measured energy consumption is known (useful for energy advice, for method see study "Berücksichtigung des Nutzerverhaltens bei individuellen Verbesserungen", on behalf of BBSR, IWU 2018) | kWh/(m²a)
  # mySlotCalcData$f_ind_MeasuredToEstimated_Actual <-
  #   mySlotCalcData$q_meter_compare / mySlotCalcData$q_calc_compare_adapted # <GM24> | Individual ratio of actual consumption to estimated consumption for current state of the building | Section for improving a prognosis if the measured energy consumption is known (useful for energy advice, for method see study "Berücksichtigung des Nutzerverhaltens bei individuellen Verbesserungen", on behalf of BBSR, IWU 2018)
  # mySlotCalcData$Code_MeterComparison_StateBefore <-
  #   AuxFunctions::Replace_NA (
  #     OFFSET(
  #       '[EnergyProfile.xlsm]Data.Out.TABULA',
  #       mySlotCalcData$Index_MeterComparison - 1,
  #       MATCH(
  #         'Code_MeterComparison_StateBefore',
  #         '[EnergyProfile.xlsm]Data.Out.TABULA!1:1',
  #         0
  #       ) - 1
  #     ),
  #     -999999
  #   ) # <GN24> | Code of the dataset used as a reference to estimate the expected consumption from the energy consumption of a former state | Section for improving a prognosis if the measured energy consumption is known (useful for energy advice, for method see study "Berücksichtigung des Nutzerverhaltens bei individuellen Verbesserungen", on behalf of BBSR, IWU 2018)
  # mySlotCalcData$f_ind_StateBefore <-
  #   AuxFunctions::Replace_NA (OFFSET(
  #     A1,
  #     MATCH(mySlotCalcData$Code_MeterComparison_StateBefore, A:A, 0) - 1,
  #     f_ind_MeasuredToEstimated_Actual - 1
  #   ), ) # <GO24> | Individual ratio of actual consumption to estimated consumption for a different state of the building (used for extrapolation of expected consumption of the current state) | Section for improving a prognosis if the measured energy consumption is known (useful for energy advice, for method see study "Berücksichtigung des Nutzerverhaltens bei individuellen Verbesserungen", on behalf of BBSR, IWU 2018) | f_ind_MeasuredToEstimated_Actual | 195
  # mySlotCalcData$f_ind_MeasuredToEstimated_LowerLimit <-
  #   '0.7' # <GP24> | Lower boundary of the expectation range | Section for improving a prognosis if the measured energy consumption is known (useful for energy advice, for method see study "Berücksichtigung des Nutzerverhaltens bei individuellen Verbesserungen", on behalf of BBSR, IWU 2018)
  # mySlotCalcData$f_ind_MeasuredToEstimated_UpperLimit <-
  #   '1.5' # <GQ24> | Upper boundary of the expectation range | Section for improving a prognosis if the measured energy consumption is known (useful for energy advice, for method see study "Berücksichtigung des Nutzerverhaltens bei individuellen Verbesserungen", on behalf of BBSR, IWU 2018)
  # mySlotCalcData$f_ind_Estimation <-
  #   pmin (
  #     pmax (
  #       mySlotCalcData$f_ind_StateBefore,
  #       mySlotCalcData$f_ind_MeasuredToEstimated_LowerLimit
  #     ),
  #     mySlotCalcData$f_ind_MeasuredToEstimated_UpperLimit
  #   ) # <GR24> | Estimated value of the individual ratio of actual consumption to estimated consumption state B of the building, extrapolation assuming that reasons for deviation from the typical level of measured concumption are the same for state B as for state A | Section for improving a prognosis if the measured energy consumption is known (useful for energy advice, for method see study "Berücksichtigung des Nutzerverhaltens bei individuellen Verbesserungen", on behalf of BBSR, IWU 2018)
  # mySlotCalcData$q_calc_compare_adapted_ind_Estimation <-
  #   mySlotCalcData$q_calc_compare_adapted * mySlotCalcData$f_ind_Estimation # <GS24> | Calculated energy demand (comparison value) adapted by the empirical calibration factor and by an additional factor extrapolating the ratio of actual consumption to standard estimation from a former state to the actual state (e.g. estimated energy consumption after refurbishment) | Section for improving a prognosis if the measured energy consumption is known (useful for energy advice, for method see study "Berücksichtigung des Nutzerverhaltens bei individuellen Verbesserungen", on behalf of BBSR, IWU 2018) | kWh/(m²a)

  mySlotCalcData$Code_TypePeriod_MeterComparison <-
    ifelse (
      mySlotCalcData$Code_Domain_MeterComparison_SysH != "-",
      ifelse (
        mySlotCalcData$Code_Domain_MeterComparison_SysW != "-",
        "H+W",
        "H"
      ),
      "W"
    ) %xl_JoinStrings%
    ifelse (mySlotCalcData$Indicator_CalcAdapt_M * 1 >= 1,
            "(Cal)",
            "") %xl_JoinStrings% "." %xl_JoinStrings%
    AuxFunctions::xl_TEXT (mySlotCalcData$n_Year, "00") %xl_JoinStrings%
    "." %xl_JoinStrings%
    AuxFunctions::xl_TEXT (mySlotCalcData$Year_Balance_Start, "0000") %xl_JoinStrings%
    "-" %xl_JoinStrings%
    AuxFunctions::xl_TEXT (mySlotCalcData$Month_Balance_Start, "00")
  # <GZ24>




  ###################################################################################X
  ## 6  Function output   -----


  return (mySlotCalcData)


} # End of function CalculateMeterCalcSlots ()


## End of the function CalculateMeterCalcSlots () -----
#####################################################################################X


# . -----






#####################################################################################X
## FUNCTION "MeterCalcSingleBuilding ()" -----
#####################################################################################X


MeterCalcSingleBuilding <-  function (

    myClimateData_PostCodes,
    myClimateData_StationTA,
    myClimateData_TA_HD,
    myClimateData_Sol,
    myParTab_SolOrientEst,

    myParTab_Meter_EnergyDensity,

    myDataset
)

{

  cat ("MeterCalcSingleBuilding (", myDataset [1,1], ")", fill = TRUE, sep = "")

  ###################################################################################X
  # A  DESCRIPTIOM  -----
  ###################################################################################X



  ###################################################################################X
  # B  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X
  ## After debugging: Comment this section
#
#   myClimateData_PostCodes <-
#     as.data.frame (StationClimateTables$ClimateData_PostCodes)
#   #  as.data.frame (clidamonger::tab.stationmapping)
#   # Name of the original table is misleading --> better to be changed
#   # (also in the Excel workbook)
#
#   myClimateData_StationTA <-
#     as.data.frame (StationClimateTables$ClimateData_StationTA)
#   #as.data.frame (clidamonger::list.station.ta)
#
#   myClimateData_TA_HD <-
#     as.data.frame (StationClimateTables$ClimateData_TA_HD)
#   #as.data.frame (clidamonger::data.ta.hd)
#
#   myClimateData_Sol <-
#     as.data.frame (StationClimateTables$ClimateData_Sol)
#   #as.data.frame (clidamonger::data.sol)
#
#   myParTab_SolOrientEst <-
#     as.data.frame (StationClimateTables$ParTab_SolOrientEst)
#   #as.data.frame (clidamonger::tab.estim.sol.orient)
#
#   myParTab_Meter_EnergyDensity <-
#     TabulaTables$ParTab_Meter_EnergyDensity
#
#   myDataset  <-
#     myDataCalc_CMC [8, ]
#   # myDataset  <- myDataCalc_CMC ["DE.MOBASY.WBG.0008.04", ]
#   # myDataset  <- myDataCalc_CMC [185, ]


  ###################################################################################X
  # C  FUNCTION SCRIPT   -----
  ###################################################################################X

  ###################################################################################X
  ## 0  Constants   -----
  ###################################################################################X

  n_Slot_MeterCalcComparison <- 9

  ###################################################################################X
  ## 1  Calculation   -----

  DF_MonthlyAmountsByDevice <- NA

  DF_MonthlyAmountsByDevice <-
    PrepareDFMeterValues (
        myDataset,
        myParTab_Meter_EnergyDensity
      )

  DF_MonthlyAmountsByDevice <-
    AllocateMeterAmountsToMonths (DF_MonthlyAmountsByDevice)

# cat ("PrepareMeterCalcSlots", fill = TRUE, sep = "")


  DF_MeterCalcSlots <- NA

  # Assign consumption data to the slots
  DF_MeterCalcSlots <-
    PrepareMeterCalcSlots (

      myClimateData_PostCodes = myClimateData_PostCodes,
      myClimateData_StationTA = myClimateData_StationTA,
      myClimateData_TA_HD     = myClimateData_TA_HD,
      myClimateData_Sol       = myClimateData_Sol,
      myParTab_SolOrientEst   = myParTab_SolOrientEst,

      myDataset,
      DF_MonthlyAmountsByDevice

      )

# cat ("CalculateMeterCalcSlots", fill = TRUE, sep = "")

  # Comparison of metered and calculated data by slot
  DF_MeterCalcSlots <-
    CalculateMeterCalcSlots (
      myDataset,
      DF_MeterCalcSlots
    )


  ###################################################################################X
  ## 2  Output variable transformation (all slots to one building dataset)   -----

  OutputVariableNames_ComparisonSlots <-
    c (
      "Code_TypePeriod_MeterComparison",
      "Date_BalanceYears_Start",
      "Date_BalanceYears_End",
      "f_Correction_HDD",
      "f_Correction_Sol_HD",
      "f_Correction_Int",
      "q_compare_w_per_sqm",
      "q_compare_h_per_sqm",
      "Code_Domain_MeterComparison_SysH",
      "Code_Domain_MeterComparison_SysW",
      "F_CalcAdapt_M",
      "Indicator_CalcAdapt_M",
      "q_calc_per_sqm",
      "q_meter_per_sqm",
      "ratio_q_meter_q_calc"
    )


  OutputVariableNames_BuildingDataset <-
    c (
      "Code_Model1_TypePeriod_MeterComparison_",
      "Date_Model1_BalanceYears_Start_",
      "Date_Model1_BalanceYears_End_",
      "f_Model1_Correction_HDD_",
      "f_Model1_Correction_Sol_HD_",
      "f_Model1_Correction_Int_",
      "q_Model1_compare_w_per_sqm_",
      "q_Model1_compare_h_per_sqm_",
      "Code_Model1_Domain_MeterComparison_SysH_",
      "Code_Model1_Domain_MeterComparison_SysW_",
      "F_Model1_CalcAdapt_M_",
      "Indicator_Model1_CalcAdapt_M_",
      "q_Model1_calc_per_sqm_",
      "q_Model1_meter_per_sqm_",
      "ratio_Model1_q_meter_q_calc_"
    )

  DF_Output_MeterCalcSingleBuilding <- as.data.frame (matrix (NA))
  DF_Output_MeterCalcSingleBuilding [ ,1] <- myDataset$ID_Dataset


  i_Slot <- 1
  for (i_Slot in (1:n_Slot_MeterCalcComparison)) {

    # cat ("Loop i_Slot = ", i_Slot, fill = TRUE, sep = "")

    CurrentOutputVariableNames <-
    AuxFunctions::Format_Integer_LeadingZeros (
      i_Slot, 2, OutputVariableNames_BuildingDataset
    )

    DF_Output_MeterCalcSingleBuilding [ ,CurrentOutputVariableNames] <- NA

    DF_Output_MeterCalcSingleBuilding [ ,CurrentOutputVariableNames] <-
      DF_MeterCalcSlots [i_Slot, OutputVariableNames_ComparisonSlots]


    # myDataset [ ,CurrentOutputVariableNames] <- NA
    #
    # myDataset [ ,CurrentOutputVariableNames] <-
    #   DF_MeterCalcSlots [i_Slot, OutputVariableNames_ComparisonSlots]


  } # End loop by slot


  ###################################################################################X
  ## 3  Function output   -----

  return (DF_Output_MeterCalcSingleBuilding [1 ,-1])
  # return (myDataset [1, ])


} # End of function MeterCalcSingleBuilding ()


## End of the function MeterCalcSingleBuilding () -----
#####################################################################################X


# . -----






#####################################################################################X
## FUNCTION "CalcMeterComparison ()" -----
#####################################################################################X


CalcMeterComparison <- function (

  # Tables from  data package: "clidamonger" "Climate Data Monthly Germany"
  myClimateData_PostCodes,
  myClimateData_StationTA,
  myClimateData_TA_HD,
  myClimateData_Sol,
  myParTab_SolOrientEst,

  myParTab_Meter_EnergyDensity,

  myDataInput,
  myDataCalc_CMC

  )

{

  cat ("CalcMeterComparison ()", fill = TRUE)

  ###################################################################################X
  # A  DESCRIPTIOM  -----
  ###################################################################################X



  ###################################################################################X
  # B  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X
  ## After debugging: Comment this section

  # myClimateData_PostCodes <-
  #   as.data.frame (StationClimateTables$ClimateData_PostCodes)
  # #  as.data.frame (clidamonger::tab.stationmapping)
  # # Name of the original table is misleading --> better to be changed
  # # (also in the Excel workbook)
  #
  # myClimateData_StationTA <-
  #   as.data.frame (StationClimateTables$ClimateData_StationTA)
  #   #as.data.frame (clidamonger::list.station.ta)
  #
  # myClimateData_TA_HD <-
  #   as.data.frame (StationClimateTables$ClimateData_TA_HD)
  #   #as.data.frame (clidamonger::data.ta.hd)
  #
  # myClimateData_Sol <-
  #   as.data.frame (StationClimateTables$ClimateData_Sol)
  #   #as.data.frame (clidamonger::data.sol)
  #
  # myParTab_SolOrientEst <-
  #   as.data.frame (StationClimateTables$ParTab_SolOrientEst)
  #   #as.data.frame (clidamonger::tab.estim.sol.orient)
  #
  # myParTab_Meter_EnergyDensity <-
  #   TabulaTables$ParTab_Meter_EnergyDensity
  #
  # myDataInput     <-
  #   myBuildingDataTables$Data_Input
  #
  # myDataCalc_CMC  <-
  #   myOutputTables$Data_Calc
  #


  ###################################################################################X
  # C  FUNCTION SCRIPT   -----
  ###################################################################################X

  ###################################################################################X
  ## 0  Constants   -----
  ###################################################################################X

  n_Slot_MeterCalcComparison <- 9


  ###################################################################################X
  ## 1  Preparation   -----
  ###################################################################################X

  myCount_Dataset <-
    nrow (myDataCalc_CMC)




  ###################################################################################X
  ## 2  Transformation of input data   -----
  ###################################################################################X


  ## Transfer of values from input variables to calculation variables
  # This is necessary due to differences of variable names
  # and to clean the variable format (Boolean)



  # The input values A_C_Meter are currently not used,
  # Instead the TABULA reference area ist used (see below)
  myDataCalc_CMC$A_C_Meter_M1_Input                                  <-
    myDataInput$A_C_Floor_Metering_M1
  myDataCalc_CMC$A_C_Meter_M2_Input                                  <-
    myDataInput$A_C_Floor_Metering_M2
  myDataCalc_CMC$A_C_Meter_M3_Input                                  <-
    myDataInput$A_C_Floor_Metering_M3

  myDataCalc_CMC$A_C_Meter_M1                                        <-
    myDataCalc_CMC$A_C_Ref
  myDataCalc_CMC$A_C_Meter_M2                                        <-
    myDataCalc_CMC$A_C_Ref
  myDataCalc_CMC$A_C_Meter_M3                                        <-
    myDataCalc_CMC$A_C_Ref

  myDataCalc_CMC$Code_EC_M1                                          <-
    myDataInput$Code_Quantity_Metering_M1
  myDataCalc_CMC$Code_EC_M2                                          <-
    myDataInput$Code_Quantity_Metering_M2
  myDataCalc_CMC$Code_EC_M3                                          <-
    myDataInput$Code_Quantity_Metering_M3
  myDataCalc_CMC$Code_Unit_Metering_M1_Input                         <-
    myDataInput$Code_Unit_Metering_M1
  myDataCalc_CMC$Code_Unit_Metering_M2_Input                         <-
    myDataInput$Code_Unit_Metering_M2
  myDataCalc_CMC$Code_Unit_Metering_M3_Input                         <-
    myDataInput$Code_Unit_Metering_M3
  myDataCalc_CMC$Indicator_Utilisation_Metering_Heating_M1           <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M1_Heating)
  myDataCalc_CMC$Indicator_Utilisation_Metering_DHW_M1               <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M1_DHW)
  myDataCalc_CMC$Indicator_Utilisation_Metering_Cooling_M1           <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M1_Cooling)
  myDataCalc_CMC$Indicator_Utilisation_Metering_VentilationAux_M1    <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M1_VentilationAux)
  myDataCalc_CMC$Indicator_Utilisation_Metering_HeatingPlantAux_M1   <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M1_HeatingPlantAux)
  myDataCalc_CMC$Indicator_Utilisation_Metering_HouseholdEl_M1       <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M1_HouseholdEl)
  myDataCalc_CMC$Indicator_Utilisation_Metering_Cooking_M1           <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M1_Cooking)
  myDataCalc_CMC$Indicator_Utilisation_Metering_Other_M1             <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M1_Other)
  myDataCalc_CMC$Indicator_Utilisation_Metering_Heating_M2           <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M2_Heating)
  myDataCalc_CMC$Indicator_Utilisation_Metering_DHW_M2               <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M2_DHW)
  myDataCalc_CMC$Indicator_Utilisation_Metering_Cooling_M2           <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M2_Cooling)
  myDataCalc_CMC$Indicator_Utilisation_Metering_VentilationAux_M2    <-
    AuxFunctions::Reformat_InputData_Boolean (
      myDataInput$Indicator_Utilisation_Metering_M2_VentilationAux)
  myDataCalc_CMC$Indicator_Utilisation_Metering_HeatingPlantAux_M2   <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M2_HeatingPlantAux)
  myDataCalc_CMC$Indicator_Utilisation_Metering_HouseholdEl_M2       <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M2_HouseholdEl)
  myDataCalc_CMC$Indicator_Utilisation_Metering_Cooking_M2           <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M2_Cooking)
  myDataCalc_CMC$Indicator_Utilisation_Metering_Other_M2             <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M2_Other)
  myDataCalc_CMC$Indicator_Utilisation_Metering_Heating_M3           <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M3_Heating)
  myDataCalc_CMC$Indicator_Utilisation_Metering_DHW_M3               <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M3_DHW)
  myDataCalc_CMC$Indicator_Utilisation_Metering_Cooling_M3           <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M3_Cooling)
  myDataCalc_CMC$Indicator_Utilisation_Metering_VentilationAux_M3    <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M3_VentilationAux)
  myDataCalc_CMC$Indicator_Utilisation_Metering_HeatingPlantAux_M3   <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M3_HeatingPlantAux)
  myDataCalc_CMC$Indicator_Utilisation_Metering_HouseholdEl_M3       <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M3_HouseholdEl)
  myDataCalc_CMC$Indicator_Utilisation_Metering_Cooking_M3           <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M3_Cooking)
  myDataCalc_CMC$Indicator_Utilisation_Metering_Other_M3             <-
    AuxFunctions::Reformat_InputData_Boolean (myDataInput$Indicator_Utilisation_Metering_M3_Other)






  ###################################################################################X
  ## 3  Calculation   -----
  ###################################################################################X


  ###################################################################################X
  ### Start Loop by building dataset    -----

  i_Dataset <- 1  # 186 # For testing the loop content
  # i_Dataset <- which (rownames (myDataCalc_CMC) == "DE.MOBASY.BV.0014.04")
  # i_Dataset <- which (rownames (myDataCalc_CMC) == "DE.MOBASY.WBG.0008.04")

  for (i_Dataset in (1:myCount_Dataset)) {

    CurrentResult <-
      MeterCalcSingleBuilding (

        myClimateData_PostCodes = myClimateData_PostCodes,
        myClimateData_StationTA = myClimateData_StationTA,
        myClimateData_TA_HD     = myClimateData_TA_HD,
        myClimateData_Sol       = myClimateData_Sol,
        myParTab_SolOrientEst   = myParTab_SolOrientEst,

        myParTab_Meter_EnergyDensity = myParTab_Meter_EnergyDensity,

        myDataCalc_CMC [i_Dataset , ]
        )


    myDataCalc_CMC [i_Dataset, colnames (CurrentResult)] <-
      CurrentResult [1, ]
    # myDataCalc_CMC [i_Dataset, myOutputVariableNames] <-
    #   CurrentResult [1, ]

  } # End of loop by i_Dataset

  ### End Loop by building dataset    -----
  ###################################################################################X



  ###################################################################################X
  ## 4  Function output   -----
  ###################################################################################X


  myDataCalc_CMC$Date_Change <- TimeStampForDataset ()



  return (myDataCalc_CMC)


} # End of function CalcMeterComparison ()


## End of the function CalcMeterComparison () -----
#####################################################################################X


# . -----



###################################################################################X
## Test of functions  -----
###################################################################################X
## After testing: Comment this section





# . -----



