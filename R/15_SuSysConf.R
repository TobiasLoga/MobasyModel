#####################################################################################X
##    File name:        "SuSysConf"
##
##    Module of:        "EnergyProfile.R"
##
##    Task:             Configuration of Heat Supply System
##
##    Method:           { Documentation not yet available }
##
##    Project:          MOBASY
##
##    Authors:          Tobias Loga (t.loga@iwu.de)
##                      Jens Calisti
##                      IWU - Institut Wohnen und Umwelt, Darmstadt / Germany
##
##    Created:          14-05-2021
##    Last changes:     15-10-2021
##
#####################################################################################X
##
##    Content:          Function SuSysConf ()
##
##    Source:           R-Script derived from Excel workbook / worksheet
##                      "[EnergyProfile.xlsm]Data.out.TABULA"
##
#####################################################################################X

# Log changes
# 2023-01-30 in "Ventilation system and air exchange rate" Data_Calc$Code_SysVent


#####################################################################################X
##  Dependencies / requirements ------
#
#   Script "AuxFunctions.R"
#   Script "AuxConstants.R"



#####################################################################################X
## FUNCTION "SuSysConf ()" -----
#####################################################################################X



SuSysConf <- function (

    myInputData,
    myCalcData,

    ParTab_BoundaryCond,
    ParTab_System_HG,
    ParTab_System_HS,
    ParTab_System_HD,
    ParTab_System_HA,
    ParTab_System_WG,
    ParTab_System_WS,
    ParTab_System_WD,
    ParTab_System_WA,
    ParTab_System_H,
    ParTab_System_W,
    ParTab_System_Vent,
    ParTab_System_PVPanel,
    ParTab_System_PV,
    ParTab_System_Coverage,
    ParTab_System_ElProd,
    ParTab_System_SetECAssess,
    ParTab_System_EC,
    ParTab_CalcAdapt

) {

  cat ("SuSysConf ()", fill = TRUE)


  ###################################################################################X
  # 1  DESCRIPTION   -----
  ###################################################################################X

  # This function is used to configure the heat supply system
  # on the basis of the Energy Profile Indicators


  ###################################################################################X
  # 2  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X


  ## After debugging: Comment this section
  #
  # myInputData <- myBuildingDataTables$Data_Input
  # myCalcData  <- myBuildingDataTables$Data_Calc
  #
  # ParTab_BoundaryCond  <- TabulaTables$ParTab_BoundaryCond
  # ParTab_System_HG<- TabulaTables$ParTab_System_HS
  # ParTab_System_HS <- TabulaTables$ParTab_System_HS
  # ParTab_System_HD <- TabulaTables$ParTab_System_HD
  # ParTab_System_HA <- TabulaTables$ParTab_System_HA
  # ParTab_System_WG <- TabulaTables$ParTab_System_WG
  # ParTab_System_WS <- TabulaTables$ParTab_System_WS
  # ParTab_System_WD <- TabulaTables$ParTab_System_WD
  # ParTab_System_WA <- TabulaTables$ParTab_System_WA
  # ParTab_System_H <- TabulaTables$ParTab_System_H
  # ParTab_System_W <- TabulaTables$ParTab_System_W
  # ParTab_System_Vent <- TabulaTables$ParTab_System_Vent
  # ParTab_System_PVPanel <- TabulaTables$ParTab_System_PVPanel
  # ParTab_System_PV <- TabulaTables$ParTab_System_PV
  # # ParTab_System_Coverage <- TabulaTables$ParTab_System_Coverage # not used
  # # ParTab_System_ElProd <- TabulaTables$ParTab_System_ElProd # not used
  # ParTab_System_SetECAssess <- TabulaTables$ParTab_System_SetECAssess
  # ParTab_System_EC <- TabulaTables$ParTab_System_EC
  # ParTab_CalcAdapt <- TabulaTables$ParTab_CalcAdapt



  ###################################################################################X
  # 3  FUNCTION SCRIPT   -----
  ###################################################################################X

  ###################################################################################X
  ##  Constants  -----
  ###################################################################################X

  Value_Numeric_Error             <- -99999
  Value_String_Error              <- "_ERROR_"



  Year_Installation_System_NA                  <- 2000
  # Default value for the year of system installation, used if there is no input
  # and the construction year of the building is before Year_Installation_System_NA


  Code_Type_EC_Boiler_OilGas_NA <- "Gas" # Default energy carrier for OilGas boilers
  # OPEN TASK: Currently "Gas" is used here since this is most common in Germany,
  # but in principle it would be better to define an energy carrier code "Fuel_Boiler_NA"

  Code_BoilerType_OilGas_NA       <- "B_NC_LT"

  Code_Type_EC_Boiler_Solid_NA    <- "Bio_FW"
  Code_BoilerType_Solid_NA        <- "B_NC_CT"

  Code_Type_EC_Heatpump_NA        <- "El"
  Code_HeatpumpType_NA            <- "HP_Air"

  Code_Type_EC_CHP_NA             <- "Gas"

  Code_Type_EC_Stove_NA           <- "Gas"
  # OPEN TASK: Currently "Gas" is used here since this is most common in Germany,
  # but in principle it would be better to define an energy carrier code "Fuel_Stove_NA"



  ## Default values of heat supply fractions (percentages of produced heat)
  ## used if several heat generators are selected
  ## OPEN TASK: The other default fractions are still placed directly in the code
  ## --> First step: Introduce as constants | Further step: Define a table in the library
  Fraction_Default_ThermalSolar_SysH_SUH <- 0.10
  Fraction_Default_ThermalSolar_SysH_MUH <- 0.05
  Fraction_Default_ThermalSolar_SysW_SUH <- 0.60
  Fraction_Default_ThermalSolar_SysW_MUH <- 0.40

  Code_Type_SysPVPanel_NA                <- "Gen"
  Code_SubType_SysPVPanel_NA             <- "01"
  f_PV_A_SolarPotential_1_NA             <- 1
  f_PV_A_SolarPotential_2_NA             <- 0

  Code_Orientation_SolarPotential_1_NA   <- "South"
  Code_Orientation_SolarPotential_2_NA   <- "North"
  Inclination_SolarPotential_1_NA        <- 45
  Inclination_SolarPotential_2_NA        <- 45



  ###################################################################################X
  ##  Preparation  -----
  ###################################################################################X




  #####################################################################################X
  ## Reformat and clean all input data  ---------------------------


  #myCalcData$Index_Sys_Class_National <- myInputData$Index_Sys_Class_National # <AFF11>
  #myCalcData$Code_TypeCompareMeterCalc <- myInputData$Code_TypeCompareMeterCalc_01 # <AFG11>

  #View (myInputData$Code_CompareCalcMeter_Consider_M1_01)

  # myCalcData$Code_CompareCalcMeter_Consider_M1 <- cbind.data.frame (myInputData$Code_CompareCalcMeter_Consider_M1_01,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M1_02,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M1_03,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M1_04,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M1_05,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M1_06,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M1_07,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M1_08,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M1_09)
  #
  # myCalcData$Code_CompareCalcMeter_Consider_M2 <- cbind.data.frame (myInputData$Code_CompareCalcMeter_Consider_M2_01,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M2_02,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M2_03,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M2_04,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M2_05,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M2_06,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M2_07,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M2_08,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M2_09)
  #
  # myCalcData$Code_CompareCalcMeter_Consider_M3 <- cbind.data.frame (myInputData$Code_CompareCalcMeter_Consider_M3_01,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M3_02,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M3_03,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M3_04,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M3_05,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M3_06,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M3_07,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M3_08,
  #                                                                  myInputData$Code_CompareCalcMeter_Consider_M3_09)

  # M E R K P U N K T : k?nnte sein, dass das so nicht geht!

  #which (myCalcData [,"Code_CompareCalcMeter_Consider_M1"])
  #View (myCalcData$Code_CompareCalcMeter_Consider_M1[2])




  myCalcData$Code_EC_Specification_Version <-
    paste (myCalcData$Code_Country, ".", "002", sep = "") # Open task: should be variable input

  # Default value for the year of system installation is used if there is no input and the construction year of the building is before Year_Installation_System_NA
  myCalcData$Year_Installation_System_Calc <-
    AuxFunctions::Replace_NA (
      myInputData$Year_Installation_System,
      pmax (Year_Installation_System_NA, myCalcData$Year1_Building)
    )


  myCalcData$Code_CentralisationType_SysHG_Input <-
    myInputData$Code_CentralisationType_SysHG

  myCalcData$Indicator_Storage_SysH <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Storage_SysH)
  myCalcData$Year_Installation_Storage_SysH_Calc <-
    AuxFunctions::Replace_NA (
      myInputData$Year_Installation_Storage_SysH,
      myCalcData$Year_Installation_System_Calc
    )

  myCalcData$Indicator_Storage_SysH_Immersion <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Storage_SysH_Immersion)
  myCalcData$Indicator_Storage_SysH_InsideEnvelope <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Storage_SysH_InsideEnvelope)
  myCalcData$Indicator_Distribution_SysH <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Distribution_SysH)

  myCalcData$Year_Installation_Distribution_SysH_Calc <-
      AuxFunctions::Replace_NA (
          myInputData$Year_Installation_Distribution_SysH,
          myCalcData$Year_Installation_System_Calc
      )

  myCalcData$Indicator_Distribution_SysH_OutsideEnvelope <-
      AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Distribution_SysH_OutsideEnvelope)
  myCalcData$Indicator_Distribution_SysH_PoorlyInsulated <-
      AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Distribution_SysH_PoorlyInsulated)
  myCalcData$Indicator_Distribution_SysH_LowTemperature <-
      AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Distribution_SysH_LowTemperature)

  myCalcData$Indicator_Storage_SysW <-
      AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Storage_SysW)
  myCalcData$Year_Installation_Storage_SysW_Calc <-
      AuxFunctions::Replace_NA (myInputData$Year_Installation_Storage_SysW,
                  myCalcData$Year_Installation_System_Calc)
  myCalcData$Indicator_Storage_SysW_Immersion <-
      AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Storage_SysW_Immersion)
  myCalcData$Indicator_Storage_SysW_InsideEnvelope <-
      AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Storage_SysW_InsideEnvelope)
  myCalcData$Indicator_Distribution_SysW <-
      AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Distribution_SysW)
  myCalcData$Year_Installation_Distribution_SysW_Calc <-
      AuxFunctions::Replace_NA (
          myInputData$Year_Installation_Distribution_SysW,
          myCalcData$Year_Installation_System_Calc
      )
  myCalcData$Indicator_Distribution_SysW_CirculationLoop <-
      AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Distribution_SysW_CirculationLoop)
  myCalcData$Indicator_Distribution_SysW_OutsideEnvelope <-
      AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Distribution_SysW_OutsideEnvelope)
  myCalcData$Indicator_Distribution_SysW_PoorlyInsulated <-
      AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Distribution_SysW_PoorlyInsulated)

  #. --------------------------------------------------------------------------------------------------

  #####################################################################################X
  ## SysG - Heat generators -----



  # Rule for handling of NA in case of heat generators:
  #
  # Example for "Boiler_OilGas"
  #
  # myCalcData$Indicator_Boiler_OilGas: If NA then set to 0 # if there is an uncertainty it is assumed that no such heat generator is available
  # myCalcData$Indicator_Boiler_OilGas_SysH: If the heat generator is available and the use for space heating is unclear it is set to 1, assuming that this is a typical case
  # myCalcData$Indicator_Boiler_OilGas_SysW: If the heat generator is available and the use for DHW is unclear it is set to 1, assuming that this is a typical case
  #
  # Only Exception for the rule "SysH": thermal solar systems, here the value is set to 0, assuming that the typical case is that heat is not supplied for heating


  myCalcData$Indicator_UserInput_FractionSysG <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_UserInput_FractionSysG)

  #####################################################################################X
  ## . Boiler_OilGas -----

  myCalcData$Indicator_Boiler_OilGas <-
    AuxFunctions::Reformat_InputData_Boolean (AuxFunctions::Replace_NA (myInputData$Indicator_Boiler_OilGas, 0))
  myCalcData$Indicator_Boiler_OilGas_SysH <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Boiler_OilGas_SysH)
  myCalcData$Indicator_Boiler_OilGas_SysW <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Boiler_OilGas_SysW)

  # The following input fractions (percentages of heat delivered by this heat generator)
  # do not form part of the monitoring indicators. They are included to enable parameter studies.
  myCalcData$Fraction_Input_Boiler_OilGas_SysH <-
    as.numeric (myInputData$Fraction_Input_Boiler_OilGas_SysH)
  myCalcData$Fraction_Input_Boiler_OilGas_SysW <-
    as.numeric (myInputData$Fraction_Input_Boiler_OilGas_SysW)

  myCalcData$Year_Installation_Boiler_OilGas <-
    as.integer (myInputData$Year_Installation_Boiler_OilGas)
  myCalcData$Code_Type_EC_Boiler_OilGas <-
    myInputData$Code_Type_EC_Boiler_OilGas
  myCalcData$Code_BoilerType_OilGas <-
    myInputData$Code_BoilerType_OilGas

  myCalcData$Indicator_Completeness_SysHG_Boiler_OilGas <-
    AuxFunctions::Replace_NA (myCalcData$Indicator_Boiler_OilGas * myCalcData$Indicator_Boiler_OilGas_SysH,
                0) *
    (
      0.5 + 0.25 * (myCalcData$Code_Type_EC_Boiler_OilGas != "_NA_") + 0.25 * (myCalcData$Code_BoilerType_OilGas != "_NA_")
    )

  myCalcData$Indicator_Completeness_SysWG_Boiler_OilGas <-
    AuxFunctions::Replace_NA (myCalcData$Indicator_Boiler_OilGas * myCalcData$Indicator_Boiler_OilGas_SysW,
                0) *
    (
      0.5 + 0.25 * (myCalcData$Code_Type_EC_Boiler_OilGas != "_NA_") + 0.25 * (myCalcData$Code_BoilerType_OilGas != "_NA_")
    )

  myCalcData$Code_EC_Boiler_OilGas <-
    ifelse (
      myCalcData$Indicator_Boiler_OilGas * 1 == 1,
      ifelse (
        myCalcData$Code_Type_EC_Boiler_OilGas == "_NA_",
        Code_Type_EC_Boiler_OilGas_NA,
        # Default energy carrier for OilGas boilers
        myCalcData$Code_Type_EC_Boiler_OilGas
      ),
      "-"
    )

  myCalcData$Code_SysH_G_Boiler_OilGas <-
    ifelse (
      myCalcData$Indicator_Boiler_OilGas * AuxFunctions::Replace_NA (myCalcData$Indicator_Boiler_OilGas_SysH * 1, 1) == 1,
      paste (
        myCalcData$Code_Country,
        ".",
        ifelse (
          myCalcData$Code_BoilerType_OilGas == "_NA_",
          Code_BoilerType_OilGas_NA,
          myCalcData$Code_BoilerType_OilGas
        ),
        ".",
        myCalcData$Code_BuildingSizeClass_System,
        ifelse (
          (
            myCalcData$Code_BoilerType_OilGas == "B_C" &
              AuxFunctions::Replace_NA (myCalcData$Indicator_Distribution_SysH_LowTemperature * 1, 0) == 1
          ),
          ".12",
          ".11"
        ),
        sep = ""
      ),
      "-"
    )

  myCalcData$Code_SysW_G_Boiler_OilGas <-
    ifelse (
      myCalcData$Indicator_Boiler_OilGas * AuxFunctions::Replace_NA (myCalcData$Indicator_Boiler_OilGas_SysW * 1, 1) == 1,
      paste (
        myCalcData$Code_Country,
        "." ,
        ifelse (
          myCalcData$Code_BoilerType_OilGas == "_NA_",
          Code_BoilerType_OilGas_NA,
          myCalcData$Code_BoilerType_OilGas
        ) ,
        "." ,
        myCalcData$Code_BuildingSizeClass_System,
        ".11",
        sep = ""
      ),
      "-"
    )

  myCalcData$Fraction_Standard_Boiler_OilGas_SysH <-
    0.2 # Default value used if several heat generators are selected
  myCalcData$Fraction_Standard_Boiler_OilGas_SysW <-
    0.2 # Default value used if several heat generators are selected

  myCalcData$Fraction_Boiler_OilGas_SysH <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_Boiler_OilGas_SysH * 1, 0) > 0,
      myCalcData$Fraction_Input_Boiler_OilGas_SysH,
      myCalcData$Fraction_Standard_Boiler_OilGas_SysH
    )

  myCalcData$Fraction_Boiler_OilGas_SysW <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_Boiler_OilGas_SysW * 1, 0) > 0,
      myCalcData$Fraction_Input_Boiler_OilGas_SysW,
      myCalcData$Fraction_Standard_Boiler_OilGas_SysW
    )


  #####################################################################################X
  ## . Boiler_Solid -----

  myCalcData$Indicator_Boiler_Solid <-
    AuxFunctions::Reformat_InputData_Boolean (AuxFunctions::Replace_NA (myInputData$Indicator_Boiler_Solid, 0))
  myCalcData$Indicator_Boiler_Solid_SysH <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Boiler_Solid_SysH)
  myCalcData$Indicator_Boiler_Solid_SysW <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Boiler_Solid_SysW)

  # The following input fractions (percentages of heat delivered by this heat generator) do not form part of the monitoring indicators.
  # They are included to enable parameter studies.
  myCalcData$Fraction_Input_Boiler_Solid_SysH <-
    as.numeric (myInputData$Fraction_Input_Boiler_Solid_SysH)
  myCalcData$Fraction_Input_Boiler_Solid_SysW <-
    as.numeric (myInputData$Fraction_Input_Boiler_Solid_SysW)

  myCalcData$Year_Installation_Boiler_Solid <-
    as.integer (myInputData$Year_Installation_Boiler_Solid)
  myCalcData$Code_Type_EC_Boiler_Solid <-
    myInputData$Code_Type_EC_Boiler_Solid # <AHI11 >

  myCalcData$Indicator_Completeness_SysHG_Boiler_Solid <-
    AuxFunctions::Replace_NA (myCalcData$Indicator_Boiler_Solid * myCalcData$Indicator_Boiler_Solid_SysH,
                0) *
    (0.5 + 0.5 * (myCalcData$Code_Type_EC_Boiler_Solid !=  "_NA_"))

  myCalcData$Indicator_Completeness_SysWG_Boiler_Solid <-
    AuxFunctions::Replace_NA (myCalcData$Indicator_Boiler_Solid * myCalcData$Indicator_Boiler_Solid_SysW,
                0) *
    (0.5 + 0.5 * (myCalcData$Code_Type_EC_Boiler_Solid !=  "_NA_"))

  myCalcData$Code_EC_Boiler_Solid <-
    ifelse (
      myCalcData$Indicator_Boiler_Solid * 1 == 1,
      ifelse (
        myCalcData$Code_Type_EC_Boiler_Solid == "_NA_",
        Code_Type_EC_Boiler_Solid_NA,
        myCalcData$Code_Type_EC_Boiler_Solid
      ),
      "-"
    )

  myCalcData$Code_SysH_G_Boiler_Solid <-
    ifelse (
      myCalcData$Indicator_Boiler_Solid * AuxFunctions::Replace_NA (myCalcData$Indicator_Boiler_Solid_SysH * 1, 1) == 1,
      paste (
        myCalcData$Code_Country,
        ".",
        Code_BoilerType_Solid_NA,
        ".",
        myCalcData$Code_BuildingSizeClass_System,
        ".11",
        sep = ""
      ),
      "-"
    )

  myCalcData$Code_SysW_G_Boiler_Solid <-
    ifelse (
      myCalcData$Indicator_Boiler_Solid * AuxFunctions::Replace_NA (myCalcData$Indicator_Boiler_Solid_SysW * 1, 1) == 1,
      paste (
        myCalcData$Code_Country,
        ".",
        Code_BoilerType_Solid_NA,
        ".",
        myCalcData$Code_BuildingSizeClass_System,
        ".11",
        sep = ""
      ),
      "-"
    )

  myCalcData$Fraction_Standard_Boiler_Solid_SysH <-
    0.2 # Default value used if several heat generators are selected
  myCalcData$Fraction_Standard_Boiler_Solid_SysW <-
    0.2 # Default value used if several heat generators are selected

  myCalcData$Fraction_Boiler_Solid_SysH <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_Boiler_Solid_SysH * 1, 0) > 0,
      myCalcData$Fraction_Input_Boiler_Solid_SysH,
      myCalcData$Fraction_Standard_Boiler_Solid_SysH
    )

  myCalcData$Fraction_Boiler_Solid_SysW <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_Boiler_Solid_SysW * 1, 0) > 0,
      myCalcData$Fraction_Input_Boiler_Solid_SysW,
      myCalcData$Fraction_Standard_Boiler_Solid_SysW
    )

  #####################################################################################X
  ## . Heatpump -----

  myCalcData$Indicator_Heatpump <-
    AuxFunctions::Reformat_InputData_Boolean (AuxFunctions::Replace_NA (myInputData$Indicator_Heatpump, 0))
  myCalcData$Indicator_Heatpump_SysH <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Heatpump_SysH)
  myCalcData$Indicator_Heatpump_SysW <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Heatpump_SysW)

  # The following input fractions (percentages of heat delivered by this heat generator) do not form part of the monitoring indicators.
  # They are included to enable parameter studies.
  myCalcData$Fraction_Input_Heatpump_SysH <-
    as.numeric (myInputData$Fraction_Input_Heatpump_SysH)
  myCalcData$Fraction_Input_Heatpump_SysW <-
    as.numeric (myInputData$Fraction_Input_Heatpump_SysW)

  myCalcData$Year_Installation_Heatpump <-
    as.integer (myInputData$Year_Installation_Heatpump)
  myCalcData$Code_HeatpumpType <-
    myInputData$Code_HeatpumpType # <AHY11>
  myCalcData$Indicator_Heatpump_PlusDirectElectricHeater <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Heatpump_PlusDirectElectricHeater) # <AHZ11>

  myCalcData$Indicator_Completeness_SysHG_Heatpump <-
    AuxFunctions::Replace_NA (myCalcData$Indicator_Heatpump  *  myCalcData$Indicator_Heatpump_SysH,
                0) *
    (0.5  +  0.25 * (myCalcData$Code_HeatpumpType != "_NA_") +
       0.25 * ifelse (
         is.na (myCalcData$Indicator_Heatpump_PlusDirectElectricHeater),
         0,
         1
       ))

  myCalcData$Indicator_Completeness_SysWG_Heatpump <-
    AuxFunctions::Replace_NA (myCalcData$Indicator_Heatpump * myCalcData$Indicator_Heatpump_SysW,
                0) *
    (0.5 + 0.25 * (myCalcData$Code_HeatpumpType != "_NA_") +
       0.25 * ifelse (
         is.na (myCalcData$Indicator_Heatpump_PlusDirectElectricHeater),
         0,
         1
       ))

  myCalcData$Code_EC_Heatpump <-
    ifelse (myCalcData$Indicator_Heatpump  == 1,
            Code_Type_EC_Heatpump_NA,
            "-")

  myCalcData$Code_SysH_G_Heatpump <-
    ifelse (
      myCalcData$Indicator_Heatpump * AuxFunctions::Replace_NA (myCalcData$Indicator_Heatpump_SysH, 1) == 1,
      paste (
        myCalcData$Code_Country,
        ".",
        ifelse (
          myCalcData$Code_HeatpumpType == "_NA_",
          Code_HeatpumpType_NA,
          myCalcData$Code_HeatpumpType
        ),
        ".Gen.",
        ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_Heatpump_PlusDirectElectricHeater, 0) == 0,
          12,
          11
        ) +
          ifelse (
            (
              AuxFunctions::Replace_NA (myCalcData$Indicator_Distribution_SysH_LowTemperature, 0) == 1
            ) &
              (myCalcData$Code_HeatpumpType != "HP_ExhAir"),
            2,
            0
          ),
        sep = ""
      ),
      "-"
    )

  myCalcData$Code_SysW_G_Heatpump <-
    ifelse (
      myCalcData$Indicator_Heatpump * AuxFunctions::Replace_NA (myCalcData$Indicator_Heatpump_SysW * 1, 1) == 1,
      paste (
        myCalcData$Code_Country,
        ".",
        ifelse (
          myCalcData$Code_HeatpumpType == "_NA_",
          Code_HeatpumpType_NA,
          myCalcData$Code_HeatpumpType
        ),
        ".Gen",
        ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_Heatpump_PlusDirectElectricHeater, 0) == 0,
          ".12",
          ".11"
        ),
        sep = ""
      ),
      "-"
    )

  myCalcData$Fraction_Standard_Heatpump_SysH <-
    0.2 # Default value used if several heat generators are selected
  myCalcData$Fraction_Standard_Heatpump_SysW <-
    0.2 # Default value used if several heat generators are selected

  myCalcData$Fraction_Heatpump_SysH <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_Heatpump_SysH, 0) > 0,
      myCalcData$Fraction_Input_Heatpump_SysH,
      myCalcData$Fraction_Standard_Heatpump_SysH
    )

  myCalcData$Fraction_Heatpump_SysW <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_Heatpump_SysW, 0) > 0,
      myCalcData$Fraction_Input_Heatpump_SysW,
      myCalcData$Fraction_Standard_Heatpump_SysW
    )


  #####################################################################################X
  ## . ElectricCentral -----

  myCalcData$Indicator_ElectricCentral <-
    AuxFunctions::Reformat_InputData_Boolean (AuxFunctions::Replace_NA (myInputData$Indicator_ElectricCentral, 0))
  myCalcData$Indicator_ElectricCentral_SysH <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_ElectricCentral_SysH)
  myCalcData$Indicator_ElectricCentral_SysW <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_ElectricCentral_SysW)

  # The following input fractions (percentages of heat delivered by this heat generator) do not form part of the monitoring indicators.
  # They are included to enable parameter studies.
  myCalcData$Fraction_Input_ElectricCentral_SysH <-
    as.numeric (myInputData$Fraction_Input_ElectricCentral_SysH)
  myCalcData$Fraction_Input_ElectricCentral_SysW <-
    as.numeric (myInputData$Fraction_Input_ElectricCentral_SysW)

  myCalcData$Year_Installation_ElectricCentral <-
    as.integer (myInputData$Year_Installation_ElectricCentral)

  myCalcData$Indicator_Completeness_SysHG_ElectricCentral <-
    AuxFunctions::Replace_NA (myCalcData$Indicator_ElectricCentral * myCalcData$Indicator_ElectricCentral_SysH,
                0)
  myCalcData$Indicator_Completeness_SysWG_ElectricCentral <-
    AuxFunctions::Replace_NA (myCalcData$Indicator_ElectricCentral * myCalcData$Indicator_ElectricCentral_SysW,
                0)

  myCalcData$Code_EC_ElectricCentral <-
    ifelse ((AuxFunctions::Replace_NA (myCalcData$Indicator_ElectricCentral, 0) == 1) |
              (
                AuxFunctions::Replace_NA (
                  myCalcData$Indicator_Storage_SysH * myCalcData$Indicator_Storage_SysH_Immersion,
                  0
                ) == 1
              ) |
              (
                AuxFunctions::Replace_NA (
                  myCalcData$Indicator_Storage_SysW * myCalcData$Indicator_Storage_SysW_Immersion,
                  0
                ) == 1
              ),
            "El",
            "-")

  myCalcData$Code_SysH_G_ElectricCentral <-
    ifelse ((
      myCalcData$Indicator_ElectricCentral * AuxFunctions::Replace_NA (myCalcData$Indicator_ElectricCentral_SysH, 1) == 1
    ) |
      (
        AuxFunctions::Replace_NA (
          myCalcData$Indicator_Storage_SysH * myCalcData$Indicator_Storage_SysH_Immersion,
          0
        ) == 1
      ),
    paste (myCalcData$Code_Country, ".E_Immersion.Gen.11", sep = ""),
    "-"
    )

  myCalcData$Code_SysW_G_ElectricCentral <-
    ifelse ((
      myCalcData$Indicator_ElectricCentral * AuxFunctions::Replace_NA (myCalcData$Indicator_ElectricCentral_SysW, 1) == 1
    ) |
      (
        AuxFunctions::Replace_NA (
          myCalcData$Indicator_Storage_SysW * myCalcData$Indicator_Storage_SysW_Immersion,
          0
        ) == 1
      ),
    paste (myCalcData$Code_Country, ".E_Immersion.Gen.11", sep =
             ""),
    "-"
    )

  myCalcData$Fraction_Standard_ElectricCentral_SysH <-
    0.2 # Default values used if several heat generators are selected
  myCalcData$Fraction_Standard_ElectricCentral_SysW <-
    0.2 # Default values used if several heat generators are selected

  myCalcData$Fraction_ElectricCentral_SysH <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_ElectricCentral_SysH, 0) > 0,
      myCalcData$Fraction_Input_ElectricCentral_SysH,
      myCalcData$Fraction_Standard_ElectricCentral_SysH
    )

  myCalcData$Fraction_ElectricCentral_SysW <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_ElectricCentral_SysW, 0) > 0,
      myCalcData$Fraction_Input_ElectricCentral_SysW,
      myCalcData$Fraction_Standard_ElectricCentral_SysW
    )



  #####################################################################################X
  ## . ThermalSolar -----

  myCalcData$Indicator_ThermalSolar <-
    AuxFunctions::Reformat_InputData_Boolean (AuxFunctions::Replace_NA (myInputData$Indicator_ThermalSolar, 0))
  myCalcData$Indicator_ThermalSolar_SysH <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_ThermalSolar_SysH)
  myCalcData$Indicator_ThermalSolar_SysW <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_ThermalSolar_SysW)

  # The following input fractions (percentages of heat delivered by this heat generator) do not form part of the monitoring indicators.
  # They are included to enable parameter studies.
  myCalcData$Fraction_Input_ThermalSolar_SysH <-
    as.numeric (myInputData$Fraction_Input_ThermalSolar_SysH)
  myCalcData$Fraction_Input_ThermalSolar_SysW <-
    as.numeric (myInputData$Fraction_Input_ThermalSolar_SysW)

  myCalcData$Year_Installation_ThermalSolar <-
    as.integer (myInputData$Year_Installation_ThermalSolar)
  myCalcData$Code_EC_ThermalSolar <-
    ifelse (myCalcData$Indicator_ThermalSolar == 1, "Solar", "-")

  myCalcData$Code_SysH_G_ThermalSolar <-
    ifelse (
      myCalcData$Indicator_ThermalSolar * AuxFunctions::Replace_NA (myCalcData$Indicator_ThermalSolar_SysH, 0) == 1,
      paste (myCalcData$Code_Country, ".Solar.Gen.11", sep = ""),
      "-"
    )

  myCalcData$Code_SysW_G_ThermalSolar <-
    ifelse (
      myCalcData$Indicator_ThermalSolar * AuxFunctions::Replace_NA (myCalcData$Indicator_ThermalSolar_SysW, 1) == 1,
      paste (myCalcData$Code_Country, ".Solar.Gen.11", sep = "")
      ,
      "-"
    )

  myCalcData$Fraction_Standard_ThermalSolar_SysH <-
    ifelse (
      myCalcData$Code_BuildingSizeClass_System == "SUH",
      Fraction_Default_ThermalSolar_SysH_SUH,
      Fraction_Default_ThermalSolar_SysH_MUH
    )

  myCalcData$Fraction_Standard_ThermalSolar_SysW <-
    ifelse (
      myCalcData$Code_BuildingSizeClass_System == "SUH",
      Fraction_Default_ThermalSolar_SysW_SUH,
      Fraction_Default_ThermalSolar_SysW_MUH
    )

  myCalcData$Fraction_ThermalSolar_SysH <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_ThermalSolar_SysH, 0) > 0,
      myCalcData$Fraction_Input_ThermalSolar_SysH,
      myCalcData$Fraction_Standard_ThermalSolar_SysH
    )

  myCalcData$Fraction_ThermalSolar_SysW <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_ThermalSolar_SysW, 0) > 0,
      myCalcData$Fraction_Input_ThermalSolar_SysW,
      myCalcData$Fraction_Standard_ThermalSolar_SysW
    )


  #####################################################################################X
  ## . CHP -----

  myCalcData$Indicator_CHP <-
    AuxFunctions::Reformat_InputData_Boolean (AuxFunctions::Replace_NA (myInputData$Indicator_CHP, 0))
  myCalcData$Indicator_CHP_SysH <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_CHP_SysH)
  myCalcData$Indicator_CHP_SysW <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_CHP_SysW)

  # The following input fractions (percentages of heat delivered by this heat generator) do not form part of the monitoring indicators.
  # They are included to enable parameter studies.
  myCalcData$Fraction_Input_CHP_SysH <-
    as.numeric (myInputData$Fraction_Input_CHP_SysH)
  myCalcData$Fraction_Input_CHP_SysW <-
    as.numeric (myInputData$Fraction_Input_CHP_SysW)

  myCalcData$Year_Installation_CHP <-
    as.integer (myInputData$Year_Installation_CHP)
  myCalcData$Code_Type_EC_CHP <-
    AuxFunctions::Replace_NA (myInputData$Code_Type_EC_CHP, "_NA_")

  myCalcData$Indicator_Completeness_SysHG_CHP <-
    AuxFunctions::Replace_NA (myCalcData$Indicator_CHP * myCalcData$Indicator_CHP_SysH, 0) *
    (0.5 + 0.5 * (myCalcData$Code_Type_EC_CHP !=  "_NA_"))

  myCalcData$Indicator_Completeness_SysWG_CHP <-
    AuxFunctions::Replace_NA (myCalcData$Indicator_CHP * myCalcData$Indicator_CHP_SysW, 0) *
    (0.5 + 0.5 * (myCalcData$Code_Type_EC_CHP !=  "_NA_"))

  myCalcData$Code_EC_CHP <- ifelse (
    myCalcData$Indicator_CHP == 1,
    ifelse (
      myCalcData$Code_Type_EC_CHP == "_NA_",
      Code_Type_EC_CHP_NA,
      myCalcData$Code_Type_EC_CHP
    ),
    "-"
  )

  myCalcData$Code_SysH_G_CHP <-
    ifelse (
      myCalcData$Indicator_CHP * AuxFunctions::Replace_NA (myCalcData$Indicator_CHP_SysH, 0) == 1,
      paste (
        myCalcData$Code_Country,
        ifelse (myCalcData$n_Dwelling >= 12,
                ".CHP.Gen.12",
                ".CHP.Gen.11"),
        sep = ""
      ),
      "-"
    )

  myCalcData$Code_SysW_G_CHP <-
    ifelse (
      myCalcData$Indicator_CHP * AuxFunctions::Replace_NA (myCalcData$Indicator_CHP_SysW, 1) == 1,
      paste (
        myCalcData$Code_Country,
        ifelse (myCalcData$n_Dwelling >= 12,
                ".CHP.Gen.12",
                ".CHP.Gen.11"),
        sep = ""
      ),
      "-"
    )

  myCalcData$Fraction_Standard_CHP_SysH <-
    0.4 # Default value used if several heat generators are selected
  myCalcData$Fraction_Standard_CHP_SysW <-
    0.8 # Default value used if several heat generators are selected

  myCalcData$Fraction_CHP_SysH <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_CHP_SysH, 0) > 0,
      myCalcData$Fraction_Input_CHP_SysH,
      myCalcData$Fraction_Standard_CHP_SysH
    )

  myCalcData$Fraction_CHP_SysW <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_CHP_SysW, 0) > 0,
      myCalcData$Fraction_Input_CHP_SysW,
      myCalcData$Fraction_Standard_CHP_SysW
    )


  #####################################################################################X
  ## . DistrictHeating -----


  myCalcData$Indicator_DistrictHeating <-
    AuxFunctions::Reformat_InputData_Boolean (AuxFunctions::Replace_NA (myInputData$Indicator_DistrictHeating, 0))
  myCalcData$Indicator_DistrictHeating_SysH <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_DistrictHeating_SysH)
  myCalcData$Indicator_DistrictHeating_SysW <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_DistrictHeating_SysW)

  # The following input fractions (percentages of heat delivered by this heat generator) do not form part of the monitoring indicators.
  # They are included to enable parameter studies.
  myCalcData$Fraction_Input_DistrictHeating_SysH <-
    as.numeric (myInputData$Fraction_Input_DistrictHeating_SysH)
  myCalcData$Fraction_Input_DistrictHeating_SysW <-
    as.numeric (myInputData$Fraction_Input_DistrictHeating_SysW)

  myCalcData$Year_Installation_DistrictHeating <-
    as.integer (myInputData$Year_Installation_DistrictHeating)
  myCalcData$Indicator_EC_DHStation_Fossil <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_EC_DHStation_Fossil)
  myCalcData$Indicator_EC_DHStation_Bio <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_EC_DHStation_Bio)
  myCalcData$Indicator_DHStation_Boiler <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_DHStation_Boiler)
  myCalcData$Indicator_DHStation_CHP <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_DHStation_CHP)

  myCalcData$Indicator_Completeness_SysHG_DistrictHeating <-
    AuxFunctions::Replace_NA (myCalcData$Indicator_DistrictHeating * myCalcData$Indicator_DistrictHeating_SysH,
                0) *
    (0.5 + 0.25 * pmax (
      AuxFunctions::Replace_NA (myCalcData$Indicator_EC_DHStation_Fossil, 0),
      AuxFunctions::Replace_NA (myCalcData$Indicator_EC_DHStation_Bio, 0)
    ) +
      0.25 * pmax (
        AuxFunctions::Replace_NA (myCalcData$Indicator_DHStation_Boiler, 0),
        AuxFunctions::Replace_NA (myCalcData$Indicator_DHStation_CHP, 0)
      ))

  myCalcData$Indicator_Completeness_SysWG_DistrictHeating <-
    AuxFunctions::Replace_NA (myCalcData$Indicator_DistrictHeating * myCalcData$Indicator_DistrictHeating_SysW,
                0) *
    (0.5 + 0.25 * pmax (
      AuxFunctions::Replace_NA (myCalcData$Indicator_EC_DHStation_Fossil, 0),
      AuxFunctions::Replace_NA (myCalcData$Indicator_EC_DHStation_Bio, 0)
    ) +
      0.25 * pmax (
        AuxFunctions::Replace_NA (myCalcData$Indicator_DHStation_Boiler, 0),
        AuxFunctions::Replace_NA (myCalcData$Indicator_DHStation_CHP, 0)
      ))

  myCalcData$Code_EC_DistrictHeating <-
    ifelse (myCalcData$Indicator_DistrictHeating == 1,
            paste (
              "DH",
              ifelse (
                AuxFunctions::Replace_NA (myCalcData$Indicator_EC_DHStation_Bio, 0) == 1,
                "_Bio",
                ""
              ),
              ifelse (
                AuxFunctions::Replace_NA (myCalcData$Indicator_DHStation_CHP, 0) == 1,
                ifelse (
                  AuxFunctions::Replace_NA (myCalcData$Indicator_DHStation_Boiler, 1) == 1,
                  "_CHP33",
                  "_CHP67"
                ),
                "_NoCHP"
              ),
              sep = ""
            ),
            "-")

  myCalcData$Code_SysH_G_DistrictHeating <-
    ifelse (
      myCalcData$Indicator_DistrictHeating * AuxFunctions::Replace_NA (myCalcData$Indicator_DistrictHeating_SysH, 1) == 1,
      paste (myCalcData$Code_Country, ".TS.Gen.11", sep = ""),
      "-"
    )

  myCalcData$Code_SysW_G_DistrictHeating <-
    ifelse (
      myCalcData$Indicator_DistrictHeating * AuxFunctions::Replace_NA (myCalcData$Indicator_DistrictHeating_SysW, 1) == 1,
      paste (myCalcData$Code_Country, ".TS.Gen.11", sep =
               "") ,
      "-"
    )

  myCalcData$Fraction_Standard_DistrictHeating_SysH <-
    0.4  # Default value used if several heat generators are selected
  myCalcData$Fraction_Standard_DistrictHeating_SysW <-
    0.2  # Default value used if several heat generators are selected
  # OPEN TASK: Why is default value SysW so low? --> Check. If there is no good reason set to 0.8 .

  myCalcData$Fraction_DistrictHeating_SysH <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_DistrictHeating_SysH, 0) > 0,
      myCalcData$Fraction_Input_DistrictHeating_SysH,
      myCalcData$Fraction_Standard_DistrictHeating_SysH
    )

  myCalcData$Fraction_DistrictHeating_SysW <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_DistrictHeating_SysW, 0) > 0,
      myCalcData$Fraction_Input_DistrictHeating_SysW,
      myCalcData$Fraction_Standard_DistrictHeating_SysW
    )


  #####################################################################################X
  ## . Completeness_Sys_G_Central -----

  myCalcData$Indicator_Completeness_SysHG_Central <-
    pmax (
      myCalcData$Indicator_Completeness_SysHG_Boiler_OilGas,
      myCalcData$Indicator_Completeness_SysHG_Boiler_Solid,
      myCalcData$Indicator_Completeness_SysHG_Heatpump,
      myCalcData$Indicator_Completeness_SysHG_ElectricCentral,
      myCalcData$Indicator_Completeness_SysHG_CHP,
      myCalcData$Indicator_Completeness_SysHG_DistrictHeating
    )

  myCalcData$Indicator_Completeness_SysWG_Central <-
    pmax (
      myCalcData$Indicator_Completeness_SysWG_Boiler_OilGas,
      myCalcData$Indicator_Completeness_SysWG_Boiler_Solid,
      myCalcData$Indicator_Completeness_SysWG_Heatpump,
      myCalcData$Indicator_Completeness_SysWG_ElectricCentral,
      myCalcData$Indicator_Completeness_SysWG_CHP,
      myCalcData$Indicator_Completeness_SysWG_DistrictHeating
    )



  #####################################################################################X
  ## . SysH_G_Decentral -----

  myCalcData$Indicator_SysH_G_Decentral <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_SysH_G_Decentral) # <AKW11>


  #####################################################################################X
  ## . SysH_G_Stove -----

  myCalcData$Indicator_SysH_G_Stove <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_SysH_G_Stove) # <AKX11>

  # The following input fractions (percentages of heat delivered by this heat generator) do not form part of the monitoring indicators.
  # They are included to enable parameter studies.
  myCalcData$Fraction_Input_SysH_G_Stove <-
    as.numeric (myInputData$Fraction_Input_SysH_G_Stove)

  myCalcData$Year_Installation_SysH_G_Stove <-
    as.integer (myInputData$Year_Installation_SysH_G_Stove)
  myCalcData$Code_Type_EC_Stove <-
    myInputData$Code_Type_EC_Stove # <ALA11>

  myCalcData$Code_SysH_EC_Stove <-
    ifelse (
      myCalcData$Indicator_SysH_G_Stove == 1,
      ifelse (
        myCalcData$Code_Type_EC_Stove == "_NA_",
        Code_Type_EC_Stove_NA,
        myCalcData$Code_Type_EC_Stove
      ),
      "-"
    )

  myCalcData$Code_SysH_G_Stove <-
    ifelse (
      myCalcData$Indicator_SysH_G_Stove == 1,
      paste (
        myCalcData$Code_Country,
        ifelse (
          myCalcData$Code_Type_EC_Stove == "Oil",
          ".Stove_L.Gen.11",
          ifelse (
            myCalcData$Code_Type_EC_Stove == "Gas",
            ".G_SH.Gen.11",
            ".Stove_S.Gen.11"
          )
        ),
        sep = ""
      ),
      "-"
    )

  myCalcData$Fraction_Standard_Stove_SysH <-
    0.3 # Default value used if several heat generators are selected
  myCalcData$Fraction_Stove_SysH <-      # 2023-11-10 corrected by supplementing Replace_NA ()
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_SysH_G_Stove, 0) > 0,
      myCalcData$Fraction_Input_SysH_G_Stove,
      myCalcData$Fraction_Standard_Stove_SysH
    )


  #####################################################################################X
  ## . SysH_G_DirectElectric -----

  myCalcData$Indicator_SysH_G_Dec_DirectElectric <-
    AuxFunctions::Reformat_InputData_Boolean (
      AuxFunctions::Replace_NA (myInputData$Indicator_SysH_G_Dec_DirectElectric, 0)
      )

  # The following input fraction (percentages of heat delivered by this heat generator) does not form part of the monitoring indicators.
  # It is included to enable parameter studies.
  myCalcData$Fraction_Input_SysH_G_Dec_DirectElectric <-
    as.numeric (myInputData$Fraction_Input_SysH_G_Dec_DirectElectric)

  myCalcData$Year_SysH_G_Dec_DirectElectric <-
    as.integer (myInputData$Year_SysH_G_Dec_DirectElectric)

  myCalcData$Code_SysH_EC_Dec_DirectElectric <-
    ifelse (myCalcData$Indicator_SysH_G_Dec_DirectElectric == 1,
            "El",
            "-")

  myCalcData$Code_SysH_G_Dec_DirectElectric <-
    ifelse (
      myCalcData$Indicator_SysH_G_Dec_DirectElectric == 1,
      paste (myCalcData$Code_Country, ".E_SH.Gen.11", sep =
               ""),
      "-"
    )

  myCalcData$Fraction_Standard_Dec_DirectElectric_SysH <-
    0.2  # Default value used if several heat generators are selected
  myCalcData$Fraction_Dec_DirectElectric_SysH <-    # 2023-11-10 corrected by supplementing Replace_NA ()
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_SysH_G_Dec_DirectElectric, 0) > 0,
      myCalcData$Fraction_Input_SysH_G_Dec_DirectElectric,
      myCalcData$Fraction_Standard_Dec_DirectElectric_SysH
    )


  #####################################################################################X
  ## . SysH_G_ElectricNightStorage -----

  myCalcData$Indicator_SysH_G_Dec_ElectricNightStorage <-
    AuxFunctions::Reformat_InputData_Boolean (AuxFunctions::Replace_NA (myInputData$Indicator_SysH_G_Dec_ElectricNightStorage, 0))

  # The following input fraction (percentages of heat delivered by this heat generator) does not form part of the monitoring indicators.
  # It is included to enable parameter studies.
  myCalcData$Fraction_Input_SysH_G_Dec_ElectricNightStorage <-
    as.numeric (myInputData$Fraction_Input_SysH_G_Dec_ElectricNightStorage)

  myCalcData$Year_SysH_G_Dec_ElectricNightStorage <-
    as.integer (myInputData$Year_SysH_G_Dec_ElectricNightStorage)

  myCalcData$Code_SysH_EC_Dec_ElectricNightStorage <-
    ifelse (myCalcData$Indicator_SysH_G_Dec_ElectricNightStorage == 1,
            "El_OP",
            "-")

  myCalcData$Code_SysH_G_Dec_ElectricNightStorage <-
    ifelse (
      myCalcData$Indicator_SysH_G_Dec_ElectricNightStorage == 1,
      paste (myCalcData$Code_Country, ".E_Storage.Gen.11", sep =
               ""),
      "-"
    )

  myCalcData$Fraction_Standard_Dec_ElectricNightStorage_SysH <-
    0.4  # Default value used if several heat generators are selected

  myCalcData$Fraction_Dec_ElectricNightStorage_SysH <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_SysH_G_Dec_ElectricNightStorage, 0) > 0,
      myCalcData$Fraction_Input_SysH_G_Dec_ElectricNightStorage,
      myCalcData$Fraction_Standard_Dec_ElectricNightStorage_SysH
    )


  #####################################################################################X
  ## . SysH_G_Dec_Heatpump -----

  myCalcData$Indicator_SysH_G_Dec_Heatpump <-
    AuxFunctions::Reformat_InputData_Boolean (AuxFunctions::Replace_NA (myInputData$Indicator_SysH_G_Dec_Heatpump, 0))

  # The following input fraction (percentages of heat delivered by this heat generator) does not form part of the monitoring indicators.
  # It is included to enable parameter studies.
  myCalcData$Fraction_Input_SysH_G_Dec_Heatpump <-
    as.numeric (myInputData$Fraction_Input_SysH_G_Dec_Heatpump)
  myCalcData$Year_SysH_G_Dec_Heatpump <-
    as.integer (myInputData$Year_SysH_G_Dec_Heatpump)

  myCalcData$Code_SysH_EC_Dec_Heatpump <-
    ifelse (myCalcData$Indicator_SysH_G_Dec_Heatpump == 1,
            "El",
            "-")

  myCalcData$Code_SysH_G_Dec_Heatpump <-
    ifelse (
      myCalcData$Indicator_SysH_G_Dec_Heatpump == 1,
      paste (myCalcData$Code_Country, ".HP_Air.Gen.14", sep =
               ""),
      "-"
    )

  myCalcData$Fraction_Standard_Dec_Heatpump_SysH <-
    0.4 # Default value used if several heat generators are selected

  myCalcData$Fraction_Dec_Heatpump_SysH <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_SysH_G_Dec_Heatpump, 0) > 0,
      myCalcData$Fraction_Input_SysH_G_Dec_Heatpump,
      myCalcData$Fraction_Standard_Dec_Heatpump_SysH
    )


  #####################################################################################X
  ## . Completeness_Sys_HG_Decentral -----

  myCalcData$Indicator_Completeness_SysHG_Decentral <-
    AuxFunctions::Replace_NA (myCalcData$Indicator_SysH_G_Decentral, 0) *
    (
      0.5 + pmax (
        0.25 * AuxFunctions::Replace_NA (myCalcData$Indicator_SysH_G_Stove, 0) + 0.25 * (myCalcData$Code_Type_EC_Stove != "_NA_"),
        0.5 * AuxFunctions::Replace_NA (myCalcData$Indicator_SysH_G_Dec_DirectElectric, 0),
        0.5 * AuxFunctions::Replace_NA (myCalcData$Indicator_SysH_G_Dec_ElectricNightStorage, 0),
        0.5 * AuxFunctions::Replace_NA (myCalcData$Indicator_SysH_G_Dec_Heatpump, 0)
      )
    )

  myCalcData$Indicator_Completeness_SysHG <-
    pmax (
      myCalcData$Indicator_Completeness_SysHG_Central,
      myCalcData$Indicator_Completeness_SysHG_Decentral
    )


  #.------------------------------------------------------------------------------------

  #####################################################################################X
  ## SysW_G_Dec -----

  myCalcData$Indicator_SysW_G_Decentral <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_SysW_G_Decentral)


  #####################################################################################X
  ## . SysW_G_Dec_ElectricStorage

  myCalcData$Indicator_SysW_G_Dec_ElectricStorage <-
    AuxFunctions::Reformat_InputData_Boolean (AuxFunctions::Replace_NA (myInputData$Indicator_SysW_G_Dec_ElectricStorage, 0))

  # The following input fraction (percentages of heat delivered by this heat generator) does not form part of the monitoring indicators.
  # It is included to enable parameter studies.
  myCalcData$Fraction_Input_SysW_G_Dec_ElectricStorage <-
    as.numeric (myInputData$Fraction_Input_SysW_G_Dec_ElectricStorage)

  myCalcData$Year_Installation_SysW_G_Dec_ElectricStorage <-
    as.integer (myInputData$Year_Installation_SysW_G_Dec_ElectricStorage)

  myCalcData$Code_SysW_EC_Dec_ElectricStorage <-
    ifelse (myCalcData$Indicator_SysW_G_Dec_ElectricStorage == 1,
            "El",
            "-")

  myCalcData$Code_SysW_G_Dec_ElectricStorage <-
    ifelse (
      myCalcData$Indicator_SysW_G_Dec_ElectricStorage == 1,
      paste (myCalcData$Code_Country, ".E_Immersion.Gen.11", sep =
               ""),
      "-"
    )

  myCalcData$Fraction_Standard_Dec_ElectricStorage_SysW <-
    0.3 # Default value used if several heat generators are selected

  myCalcData$Fraction_Dec_ElectricStorage_SysW <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_SysW_G_Dec_ElectricStorage, 0) > 0,
      myCalcData$Fraction_Input_SysW_G_Dec_ElectricStorage,
      myCalcData$Fraction_Standard_Dec_ElectricStorage_SysW
    )


  #####################################################################################X
  ## . SysW_G_Dec_ElectricTankless ------

  myCalcData$Indicator_SysW_G_Dec_ElectricTankless <-
    AuxFunctions::Reformat_InputData_Boolean (AuxFunctions::Replace_NA (myInputData$Indicator_SysW_G_Dec_ElectricTankless, 0)) # <AMK11>

  # The following input fraction (percentages of heat delivered by this heat generator) does not form part of the monitoring indicators.
  # It is included to enable parameter studies.
  myCalcData$Fraction_Input_SysW_G_Dec_ElectricTankless <-
    as.numeric (myInputData$Fraction_Input_SysW_G_Dec_ElectricTankless)

  myCalcData$Year_Installation_SysW_G_Dec_ElectricTankless <-
    as.integer (myInputData$Year_Installation_SysW_G_Dec_ElectricTankless)

  myCalcData$Code_SysW_EC_Dec_ElectricTankless <-
    ifelse (myCalcData$Indicator_SysW_G_Dec_ElectricTankless == 1,
            "El",
            "-")

  myCalcData$Code_SysW_G_Dec_ElectricTankless <-
    ifelse (
      myCalcData$Indicator_SysW_G_Dec_ElectricTankless == 1,
      paste (myCalcData$Code_Country, ".E_IWH.Gen.11", sep =
               ""),
      "-"
    )

  myCalcData$Fraction_Standard_Dec_ElectricTankless_SysW <-
    0.3 # Default value used if several heat generators are selected


  myCalcData$Fraction_Dec_ElectricTankless_SysW <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_SysW_G_Dec_ElectricTankless, 0) > 0,
      myCalcData$Fraction_Input_SysW_G_Dec_ElectricTankless,
      myCalcData$Fraction_Standard_Dec_ElectricTankless_SysW
    )


  #####################################################################################X
  ## . SysW_G_Dec_GasTankless -----

  myCalcData$Indicator_SysW_G_Dec_GasTankless <-
    AuxFunctions::Reformat_InputData_Boolean (AuxFunctions::Replace_NA (myInputData$Indicator_SysW_G_Dec_GasTankless, 0))

  # The following input fraction (percentages of heat delivered by this heat generator) does not form part of the monitoring indicators.
  # It is included to enable parameter studies.
  myCalcData$Fraction_Input_SysW_G_Dec_GasTankless <-
    as.numeric (myInputData$Fraction_Input_SysW_G_Dec_GasTankless)

  myCalcData$Year_Installation_SysW_G_Dec_GasTankless <-
    as.integer (myInputData$Year_Installation_SysW_G_Dec_GasTankless)

  myCalcData$Code_SysW_EC_Dec_GasTankless <-
    ifelse (myCalcData$Indicator_SysW_G_Dec_GasTankless == 1,
            "Gas",
            "-")

  myCalcData$Code_SysW_G_Dec_GasTankless <-
    ifelse (
      myCalcData$Indicator_SysW_G_Dec_GasTankless == 1,
      paste (myCalcData$Code_Country, ".G_IWH_NC.Gen.11", sep = ""),
      "-"
    )

  myCalcData$Fraction_Standard_Dec_GasTankless_SysW <-
    0.3 # Default value used if several heat generators are selected

  myCalcData$Fraction_Dec_GasTankless_SysW <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Fraction_Input_SysW_G_Dec_GasTankless, 0) > 0,
      myCalcData$Fraction_Input_SysW_G_Dec_GasTankless,
      myCalcData$Fraction_Standard_Dec_GasTankless_SysW
    )


  #####################################################################################X
  ## . Completeness_Sys_WG_Decentral -----

  myCalcData$Indicator_Completeness_SysWG_Decentral <-
    AuxFunctions::Replace_NA(myCalcData$Indicator_SysW_G_Decentral, 0) *
    (0.5  +  0.5 * pmax (
      AuxFunctions::Replace_NA (myCalcData$Indicator_SysW_G_Dec_ElectricStorage, 0),
      AuxFunctions::Replace_NA (myCalcData$Indicator_SysW_G_Dec_ElectricTankless, 0),
      AuxFunctions::Replace_NA (myCalcData$Indicator_SysW_G_Dec_GasTankless, 0)
    ))

  myCalcData$Indicator_Completeness_SysWG <-
    pmax (
      myCalcData$Indicator_Completeness_SysWG_Central,
      myCalcData$Indicator_Completeness_SysWG_Decentral
    ) # <AMZ11>


  #.------------------------------------------------------------------------------------


  #####################################################################################X
  ## Ventilation system and air exchange rate -----

  myCalcData$Indicator_SysVent_Mechanical <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_SysVent_Mechanical)
  myCalcData$Year_Installation_SysVent_Mechanical <-
    as.integer (myInputData$Year_Installation_SysVent_Mechanical)
  myCalcData$Indicator_SysVent_HeatRec <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_SysVent_HeatRec)
  myCalcData$eta_ve_rec_Input <-
    as.numeric (myInputData$eta_SysVent_HeatRec)


  myCalcData$Code_SysVent <-
    paste (
      myCalcData$Code_Country,
      ifelse (
        AuxFunctions::Replace_NA (myCalcData$Indicator_SysVent_Mechanical, 0) == 1,
        paste (
          ifelse (
            AuxFunctions::Replace_NA (myCalcData$Indicator_SysVent_HeatRec, 0) == 1,
            ".Bal_Rec.",
            ".Exh."
          ),
          myCalcData$Code_BuildingSizeClass_System,
          sep = ""
        ),
        ".-.Gen"
      ),
      ifelse (
        AuxFunctions::Replace_NA (myCalcData$Indicator_SysVent_HeatRec, 0) == 1,
        ifelse (
          is.na (myCalcData$eta_ve_rec_Input),
          ".15",
          ifelse (
            myCalcData$eta_ve_rec_Input >= 0.7,
            ".12",
            ".11")
        ),
        ".11"),
    sep = ""
   )

  # 2023-01-30 Changed
  # former version:
  #
  # myCalcData$Code_SysVent <- paste (
  #   myCalcData$Code_Country,
  #   ifelse (
  #     AuxFunctions::Replace_NA (myCalcData$Indicator_SysVent_Mechanical, 0) == 1,
  #     paste (
  #       ifelse (
  #         AuxFunctions::Replace_NA (myCalcData$Indicator_SysVent_HeatRec, 0) == 1,
  #         ".Bal_Rec.",
  #         ".Exh."
  #       ),
  #       myCalcData$Code_BuildingSizeClass_System,
  #       sep = ""
  #     ),
  #     ".-.Gen"
  #   ),
  #   ifelse ((
  #     AuxFunctions::Replace_NA (myCalcData$Indicator_SysVent_HeatRec, 0) == 1
  #   ) & (
  #     AuxFunctions::Replace_NA (myCalcData$eta_ve_rec_Input, 0) >= 0.8
  #   ),
  #   ".12",
  #   ".11"),
  #   sep = ""
  # )

  myCalcData$n_air_mech_Lib <-
    AuxFunctions::Replace_NA (ifelse (myCalcData$Code_SysVent == "-",
                        0,
                        ParTab_System_Vent [myCalcData$Code_SysVent, "n_air_mech"]),
                Value_Numeric_Error) # this is an error indicator for numeric values
  # --> Created code is not available in the parameter table.
  # --> Correction needed in the code creation formulas or in the parameter table


  myCalcData$n_Air_Window_VentSys_Exhaust_Lib <-
    AuxFunctions::Replace_NA (
      ifelse (myCalcData$Code_BoundaryCond == "-",
              0,
              ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "n_Air_Window_VentSys_Exhaust"]),
      Value_Numeric_Error
    )


  myCalcData$n_Air_Window_VentSys_Balanced_Lib <-
    AuxFunctions::Replace_NA (
      ifelse (myCalcData$Code_BoundaryCond == "-",
              0,
              ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "n_Air_Window_VentSys_Balanced"]),
      Value_Numeric_Error
    )

  myCalcData$eta_ve_rec_Lib <-
    AuxFunctions::Replace_NA (ifelse (myCalcData$Code_SysVent == "-",
                        0,
                        ParTab_System_Vent [myCalcData$Code_SysVent, "eta_ve_rec"]),
                Value_Numeric_Error) # Error --> Correction needed in the code creation formulas or in the parameter table

  myCalcData$q_del_ve_aux <-
    AuxFunctions::Replace_NA (ifelse (myCalcData$Code_SysVent == "-",
                        0,
                        ParTab_System_Vent [myCalcData$Code_SysVent, "q_del_ve_aux"]),
                Value_Numeric_Error) # Error --> Correction needed in the code creation formulas or in the parameter table

  myCalcData$eta_ve_rec <-
    ifelse (
      AuxFunctions::Replace_NA (
        myCalcData$Indicator_SysVent_Mechanical * myCalcData$Indicator_SysVent_HeatRec,
        0
      ) == 1,
      ifelse (
        AuxFunctions::Replace_NA (myCalcData$eta_ve_rec_Input, 0) > 0,
        myCalcData$eta_ve_rec_Input,
        myCalcData$eta_ve_rec_Lib
      ),
      0
    )

  myCalcData$n_air_mech <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Indicator_SysVent_Mechanical, 0) == 1,
      ifelse (
        myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
        AuxFunctions::Replace_NA (
          ifelse (
            myCalcData$eta_ve_rec > 0,
            myCalcData$n_Air_Mech_Balanced_Input,
            myCalcData$n_Air_Mech_Exhaust_Input
          ),
          myCalcData$n_air_mech_Lib
        ),
        ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
          ifelse (
            myCalcData$eta_ve_rec > 0,
            myCalcData$n_Air_Mech_Balanced_Input,
            myCalcData$n_Air_Mech_Exhaust_Input
          ),
          myCalcData$n_air_mech_Lib
        )
      ),
      0
    )

  myCalcData$n_Air_Window <- ifelse (
    myCalcData$n_air_mech > 0,
    ifelse (
      myCalcData$eta_ve_rec > 0,
      myCalcData$n_Air_Window_VentSys_Balanced_Lib,
      myCalcData$n_Air_Window_VentSys_Exhaust_Lib
    ),
    myCalcData$n_Air_Window_NoVentSys
  )

  myCalcData$n_air_use <- myCalcData$n_air_mech + myCalcData$n_Air_Window

  #####################################################################################X
  ## Extra thick insulation of system components / passive house components -----

  myCalcData$Indicator_SysHW_D_S_ExtraThickInsulation <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_SysHW_D_S_ExtraThickInsulation)

  #####################################################################################X
  ## PV system -----

  myCalcData$Code_TypeInput_AreaPotentialActiveSolar <-
    myInputData$Code_TypeInput_AreaPotentialActiveSolar
  myCalcData$Code_SysPVPanel <-
    paste (myCalcData$Code_Country,
           Code_Type_SysPVPanel_NA,
           Code_SubType_SysPVPanel_NA,
           sep = ".")
  myCalcData$Indicator_SysPV <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_SysPV)
  myCalcData$Indicator_SysPV_ElectricStorage <-
    AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_SysPV_ElectricStorage)
  myCalcData$Year_Installation_SysPV <-
    as.integer(myInputData$Year_Installation_SysPV)
  myCalcData$f_PV_A_SolarPotential_1 <-
    ifelse (
      AuxFunctions::Replace_NA (myCalcData$Indicator_SysPV, 0) == 1,
      ifelse ((AuxFunctions::Replace_NA (
        myCalcData$Indicator_ThermalSolar_SysH, 0
      ) == 1) |
        (AuxFunctions::Replace_NA (
          myCalcData$Indicator_ThermalSolar_SysW, 0
        ) == 1),
      0.5 * f_PV_A_SolarPotential_1_NA,
      f_PV_A_SolarPotential_1_NA
      ),
      0
    )
  # Default value f_PV_A_SolarPotential_1_NA = 1.0; if a solar thermal system is used for DHW (or for heating) the default value is reduced to 0.5
  myCalcData$f_PV_A_SolarPotential_2 <-
    ifelse (
      myCalcData$Code_TypeInput_AreaPotentialActiveSolar  ==  "Manual",
      ifelse (AuxFunctions::Replace_NA (myCalcData$Indicator_SysPV, 0),
              1,
              0),
      f_PV_A_SolarPotential_2_NA
    )
  # Default value f_PV_A_SolarPotential_2_NA = 1.0; only set to 1.0 if manual input is given

  myCalcData$K_peak_pv <-
    AuxFunctions::Replace_NA (
      ifelse (myCalcData$Code_SysPVPanel == "-",
              0,
              ParTab_System_PVPanel [myCalcData$Code_SysPVPanel, "K_peak_pv"]),
      Value_Numeric_Error
    ) # Error --> Correction needed in the code creation formulas or in the parameter table

  myCalcData$f_perf <-
    AuxFunctions::Replace_NA (
      ifelse (myCalcData$Code_SysPVPanel == "-",
              0,
              ParTab_System_PVPanel [myCalcData$Code_SysPVPanel, "f_perf"]),
      Value_Numeric_Error
    ) # Error --> Correction needed in the code creation formulas or in the parameter table

  myCalcData$f_PV_frame <-
    AuxFunctions::Replace_NA (
      ifelse (myCalcData$Code_SysPVPanel == "-",
              0,
              ParTab_System_PVPanel [myCalcData$Code_SysPVPanel, "f_PV_frame"]),
      Value_Numeric_Error
    ) # Error --> Correction needed in the code creation formulas or in the parameter table






  myCalcData$A_SolarPotential_1 <-
    AuxFunctions::Replace_NA (
      ifelse (
        myCalcData$Code_TypeInput_AreaPotentialActiveSolar == "Manual",
        myCalcData$A_ActiveSolarPotential_1,
        round(sqrt(2) / 2, 2) * myCalcData$A_GIA_Env / myCalcData$n_Storey_Eff_Env
      ),
      round(sqrt(2) / 2, 2) * myCalcData$A_GIA_Env / myCalcData$n_Storey_Eff_Env
    )
  # Default value: One half of the external footprint area of the building projected on a 45? plane

  myCalcData$Code_Orientation_SolarPotential_1 <-
    AuxFunctions::Replace_NA (
      ifelse (
        myCalcData$Code_TypeInput_AreaPotentialActiveSolar == "Manual",
        myInputData$Code_Orientation_ActiveSolarPotential_1,
        Code_Orientation_SolarPotential_1_NA
      ),
      Code_Orientation_SolarPotential_1_NA
    )

  myCalcData$Inclination_SolarPotential_1 <-
    AuxFunctions::Replace_NA (
      ifelse (
        myCalcData$Code_TypeInput_AreaPotentialActiveSolar == "Manual",
        myInputData$Inclination_ActiveSolarPotential_1,
        Inclination_SolarPotential_1_NA
      ),
      Inclination_SolarPotential_1_NA
    )


  myCalcData$A_SolarPotential_2 <-
    AuxFunctions::Replace_NA (
      ifelse (
        myCalcData$Code_TypeInput_AreaPotentialActiveSolar == "Manual",
        myCalcData$A_ActiveSolarPotential_2,
        round(sqrt(2) / 2, 2) * myCalcData$A_GIA_Env / myCalcData$n_Storey_Eff_Env
      ),
      round(sqrt(2) / 2, 2) * myCalcData$A_GIA_Env / myCalcData$n_Storey_Eff_Env
    )
  # Default value: One half of the external footprint area of the building projected on a 45? plane

  myCalcData$Code_Orientation_SolarPotential_2 <-
    AuxFunctions::Replace_NA (
      ifelse (
        myCalcData$Code_TypeInput_AreaPotentialActiveSolar == "Manual",
        myInputData$Code_Orientation_ActiveSolarPotential_2,
        Code_Orientation_SolarPotential_2_NA
      ),
      Code_Orientation_SolarPotential_2_NA
    )

  myCalcData$Inclination_SolarPotential_2 <-
    AuxFunctions::Replace_NA (
      ifelse (
        myCalcData$Code_TypeInput_AreaPotentialActiveSolar == "Manual",
        myInputData$Inclination_ActiveSolarPotential_2,
        Inclination_SolarPotential_2_NA
      ),
      Inclination_SolarPotential_2_NA
    )




  myCalcData$P_el_pv_peak_1 <-
    myCalcData$A_SolarPotential_1 * myCalcData$f_PV_A_SolarPotential_1 * myCalcData$K_peak_pv * myCalcData$f_PV_frame # <AOD11>


  # 2021-06-18: Preparation of climate data not yet implemented
  myCalcData$I_Sol_Year_Vertical_1 <-
    ifelse (
      myCalcData$Code_Orientation_SolarPotential_1 == "-",
      myCalcData$I_Sol_Year_Hor,
      (
        AuxFunctions::Replace_NA (
          regexpr ("East", myCalcData$Code_Orientation_SolarPotential_1) > 0,
          0
        ) *
          myCalcData$I_Sol_Year_East
        + AuxFunctions::Replace_NA (
          regexpr ("South", myCalcData$Code_Orientation_SolarPotential_1) > 0,
          0
        ) *
          myCalcData$I_Sol_Year_South
        + AuxFunctions::Replace_NA (
          regexpr ("West", myCalcData$Code_Orientation_SolarPotential_1) > 0,
          0
        ) *
          myCalcData$I_Sol_Year_West
        + AuxFunctions::Replace_NA (
          regexpr ("North", myCalcData$Code_Orientation_SolarPotential_1) > 0,
          0
        ) *
          myCalcData$I_Sol_Year_North
      ) / ifelse (nchar (
        myCalcData$Code_Orientation_SolarPotential_1
      ) > 5, 2, 1)
    ) # <AOE11>

  myCalcData$I_Sol_Year_1 <-
    (90 - myCalcData$Inclination_SolarPotential_1) / 90 * myCalcData$I_Sol_Year_Hor + myCalcData$Inclination_SolarPotential_1 / 90 * myCalcData$I_Sol_Year_Vertical_1 # <AOF11>

  myCalcData$E_el_pv_out_1 <-
    myCalcData$P_el_pv_peak_1 * myCalcData$I_Sol_Year_1 * myCalcData$f_perf * myCalcData$f_PV_frame # <AOG11>
  myCalcData$q_el_pv_kWpeak_1 <-
    AuxFunctions::Replace_NA (myCalcData$E_el_pv_out_1 / myCalcData$P_el_pv_peak_1, 0) # <AOH11>

  myCalcData$P_el_pv_peak_2 <-
    myCalcData$A_SolarPotential_2 * myCalcData$f_PV_A_SolarPotential_2 * myCalcData$K_peak_pv * myCalcData$f_PV_frame # <AOI11>
  myCalcData$I_Sol_Year_Vertical_2 <-
    ifelse (
      myCalcData$Code_Orientation_SolarPotential_2 == "-",
      myCalcData$I_Sol_Year_Hor,
      (
        AuxFunctions::Replace_NA (
          regexpr ("East", myCalcData$Code_Orientation_SolarPotential_2) > 0,
          0
        ) * myCalcData$I_Sol_Year_East + AuxFunctions::Replace_NA (
          regexpr ("South", myCalcData$Code_Orientation_SolarPotential_2) > 0,
          0
        ) * myCalcData$I_Sol_Year_South + AuxFunctions::Replace_NA (
          regexpr ("West", myCalcData$Code_Orientation_SolarPotential_2) > 0,
          0
        ) * myCalcData$I_Sol_Year_West + AuxFunctions::Replace_NA (
          regexpr ("North", myCalcData$Code_Orientation_SolarPotential_2) > 0,
          0
        ) * myCalcData$I_Sol_Year_North
      ) / ifelse (nchar (
        myCalcData$Code_Orientation_SolarPotential_2
      ) > 5, 2, 1)
    ) # <AOJ11>
  myCalcData$I_Sol_Year_2 <-
    (90 - myCalcData$Inclination_SolarPotential_2) / 90 * myCalcData$I_Sol_Year_Hor +
    myCalcData$Inclination_SolarPotential_2 / 90 * myCalcData$I_Sol_Year_Vertical_2 # <AOK11>
  myCalcData$E_el_pv_out_2 <-
    myCalcData$P_el_pv_peak_2 * myCalcData$I_Sol_Year_2 * myCalcData$f_perf * myCalcData$f_PV_frame # <AOL11>
  myCalcData$q_el_pv_kWpeak_2 <-
    AuxFunctions::Replace_NA (myCalcData$E_el_pv_out_2 / myCalcData$P_el_pv_peak_2, 0) # <AOM11>





  #####################################################################################X
  ## Assignment of available heat generators to 3 calculation slots ------------
  #####################################################################################X


  #####################################################################################X
  ## . SysH - Sequence of heat generators  ------------

  # In a specific sequence (first heat generators for base load, then others)
  # the potential heat generators are checked if they are available.
  # For a given heat generator the index is set to 1 if no other heat generator is yet available.
  # It is set to 2 if already 1 heat generator is available and so on.
  # Indicator_SysPV_ElectricStorageIndex_SysH_G_Combined is only an auxiliary matrix.

  myCalcData$Index_SysH_G_DistrictHeating <-
      ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_DistrictHeating * 1, 0) * AuxFunctions::Replace_NA (myCalcData$Indicator_DistrictHeating_SysH * 1, 1) == 1,
          1,
          0
      ) # <AOO11>
  Index_SysH_G_Combined <-  myCalcData$Index_SysH_G_DistrictHeating

  myCalcData$Index_SysH_G_CHP <-
      ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_CHP * 1, 0) * AuxFunctions::Replace_NA (myCalcData$Indicator_CHP_SysH * 1, 0) == 1,
          Index_SysH_G_Combined + 1,
          0
      ) # <AOP11>
  Index_SysH_G_Combined <-  cbind (Index_SysH_G_Combined, myCalcData$Index_SysH_G_CHP)

  myCalcData$Index_SysH_G_Heatpump <-
      ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_Heatpump * 1, 0) * AuxFunctions::Replace_NA (myCalcData$Indicator_Heatpump_SysH * 1, 1) == 1,
          apply (Index_SysH_G_Combined, 1, max) + 1,
          0
      ) # <AOQ11>
  Index_SysH_G_Combined <-  cbind (Index_SysH_G_Combined, myCalcData$Index_SysH_G_Heatpump)

  myCalcData$Index_SysH_G_Boiler_OilGas <-
      ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_Boiler_OilGas * 1, 0) * AuxFunctions::Replace_NA (myCalcData$Indicator_Boiler_OilGas_SysH * 1, 1) == 1,
          apply (Index_SysH_G_Combined, 1, max) + 1,
          0
      ) # <AOR11>
  Index_SysH_G_Combined <-  cbind (Index_SysH_G_Combined, myCalcData$Index_SysH_G_Boiler_OilGas)

  myCalcData$Index_SysH_G_Boiler_Solid <-
      ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_Boiler_Solid * 1, 0) * AuxFunctions::Replace_NA (myCalcData$Indicator_Boiler_Solid_SysH * 1, 1) == 1,
          apply (Index_SysH_G_Combined, 1, max) + 1,
          0
      ) # <AOS11>
  Index_SysH_G_Combined <-  cbind (Index_SysH_G_Combined, myCalcData$Index_SysH_G_Boiler_Solid)

  myCalcData$Index_SysH_G_ElectricCentral <-
      ifelse ((AuxFunctions::Replace_NA (myCalcData$Indicator_ElectricCentral * 1, 0) *
                   AuxFunctions::Replace_NA (myCalcData$Indicator_ElectricCentral_SysH * 1, 1) == 1) |
                  (AuxFunctions::Replace_NA (myCalcData$Indicator_Storage_SysH * 1, 0) *
                       AuxFunctions::Replace_NA (myCalcData$Indicator_Storage_SysH_Immersion * 1, 0) == 1),
          apply (Index_SysH_G_Combined, 1, max) + 1,
          0
      ) # <AOT11>
  Index_SysH_G_Combined <-  cbind (Index_SysH_G_Combined, myCalcData$Index_SysH_G_ElectricCentral)

  myCalcData$Index_SysH_G_ThermalSolar <-
      ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_ThermalSolar * 1, 0) * AuxFunctions::Replace_NA (myCalcData$Indicator_ThermalSolar_SysH * 1, 0) == 1,
          apply (Index_SysH_G_Combined, 1, max) + 1,
          0
      ) # <AOU11>
  Index_SysH_G_Combined <-  cbind (Index_SysH_G_Combined, myCalcData$Index_SysH_G_ThermalSolar)

  myCalcData$Index_SysH_G_Stove <-
      ifelse (
         (AuxFunctions::Replace_NA (myCalcData$Indicator_SysH_G_Decentral * 1, 0) *
          AuxFunctions::Replace_NA (myCalcData$Indicator_SysH_G_Stove * 1, 0)) == 1,
          apply (Index_SysH_G_Combined, 1, max) + 1,
          0
      ) # <AOV11>
  Index_SysH_G_Combined <-  cbind (Index_SysH_G_Combined, myCalcData$Index_SysH_G_Stove)

  myCalcData$Index_SysH_G_Dec_DirectElectric <-
      ifelse (
         (AuxFunctions::Replace_NA (myCalcData$Indicator_SysH_G_Decentral * 1, 0) *
          AuxFunctions::Replace_NA (myCalcData$Indicator_SysH_G_Dec_DirectElectric * 1, 0)) == 1,
          apply (Index_SysH_G_Combined, 1, max) + 1,
          0
      ) # <AOW11>
  Index_SysH_G_Combined <-  cbind (Index_SysH_G_Combined, myCalcData$Index_SysH_G_Dec_DirectElectric)

  myCalcData$Index_SysH_G_Dec_ElectricNightStorage <-
      ifelse (
         (AuxFunctions::Replace_NA (myCalcData$Indicator_SysH_G_Decentral * 1, 0) *
          AuxFunctions::Replace_NA (myCalcData$Indicator_SysH_G_Dec_ElectricNightStorage * 1, 0)) == 1,
          apply (Index_SysH_G_Combined, 1, max) + 1,
          0
      ) # <AOX11>
  Index_SysH_G_Combined <-  cbind (Index_SysH_G_Combined, myCalcData$Index_SysH_G_Dec_ElectricNightStorage)

  myCalcData$Index_SysH_G_Dec_Heatpump <-
      ifelse (
         (AuxFunctions::Replace_NA (myCalcData$Indicator_SysH_G_Decentral * 1, 0) *
          AuxFunctions::Replace_NA (myCalcData$Indicator_SysH_G_Dec_Heatpump * 1, 0)) == 1,
          apply (Index_SysH_G_Combined, 1, max) + 1,
          0
      ) # <AOY11>
  Index_SysH_G_Combined <-  cbind (Index_SysH_G_Combined, myCalcData$Index_SysH_G_Dec_Heatpump)

  #Index_SysH_G_Combined [157,]

  #apply (Index_SysH_G_Combined, 1, max) # Check result



  #####################################################################################X
  ## . SysH - Assign heat generators, energy carriers, and fractions to the three calculation slots  ------------


  myCalcData$Code_SysH_G_1 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysH_G_DistrictHeating == 1,
              myCalcData$Code_SysH_G_DistrictHeating,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_CHP == 1,
              myCalcData$Code_SysH_G_CHP,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Heatpump == 1,
              myCalcData$Code_SysH_G_Heatpump,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_OilGas == 1,
              myCalcData$Code_SysH_G_Boiler_OilGas,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_Solid == 1,
              myCalcData$Code_SysH_G_Boiler_Solid,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ElectricCentral == 1,
              myCalcData$Code_SysH_G_ElectricCentral,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ThermalSolar == 1,
              myCalcData$Code_SysH_G_ThermalSolar,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Stove == 1,
              myCalcData$Code_SysH_G_Stove,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_DirectElectric == 1,
              myCalcData$Code_SysH_G_Dec_DirectElectric,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_ElectricNightStorage == 1,
              myCalcData$Code_SysH_G_Dec_ElectricNightStorage,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_Heatpump == 1,
              myCalcData$Code_SysH_G_Dec_Heatpump,
              ""
          ),
          sep = ""
      )
      ,
      "-")


  myCalcData$Code_SysH_G_2 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysH_G_DistrictHeating == 2,
              myCalcData$Code_SysH_G_DistrictHeating,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_CHP == 2,
              myCalcData$Code_SysH_G_CHP,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Heatpump == 2,
              myCalcData$Code_SysH_G_Heatpump,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_OilGas == 2,
              myCalcData$Code_SysH_G_Boiler_OilGas,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_Solid == 2,
              myCalcData$Code_SysH_G_Boiler_Solid,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ElectricCentral == 2,
              myCalcData$Code_SysH_G_ElectricCentral,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ThermalSolar == 2,
              myCalcData$Code_SysH_G_ThermalSolar,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Stove == 2,
              myCalcData$Code_SysH_G_Stove,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_DirectElectric == 2,
              myCalcData$Code_SysH_G_Dec_DirectElectric,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_ElectricNightStorage == 2,
              myCalcData$Code_SysH_G_Dec_ElectricNightStorage,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_Heatpump == 2,
              myCalcData$Code_SysH_G_Dec_Heatpump,
              ""
          ),
          sep = ""
      )
      ,
      "-")




  myCalcData$Code_SysH_G_3 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysH_G_DistrictHeating == 3,
              myCalcData$Code_SysH_G_DistrictHeating,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_CHP == 3,
              myCalcData$Code_SysH_G_CHP,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Heatpump == 3,
              myCalcData$Code_SysH_G_Heatpump,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_OilGas == 3,
              myCalcData$Code_SysH_G_Boiler_OilGas,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_Solid == 3,
              myCalcData$Code_SysH_G_Boiler_Solid,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ElectricCentral == 3,
              myCalcData$Code_SysH_G_ElectricCentral,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ThermalSolar == 3,
              myCalcData$Code_SysH_G_ThermalSolar,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Stove == 3,
              myCalcData$Code_SysH_G_Stove,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_DirectElectric == 3,
              myCalcData$Code_SysH_G_Dec_DirectElectric,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_ElectricNightStorage == 3,
              myCalcData$Code_SysH_G_Dec_ElectricNightStorage,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_Heatpump == 3,
              myCalcData$Code_SysH_G_Dec_Heatpump,
              ""
          ),
          sep = ""
      )
      ,
      "-")

  myCalcData$Code_SysH_EC_1 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysH_G_DistrictHeating == 1,
              myCalcData$Code_EC_DistrictHeating,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_CHP == 1,
              myCalcData$Code_EC_CHP,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Heatpump == 1,
              myCalcData$Code_EC_Heatpump,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_OilGas == 1,
              myCalcData$Code_EC_Boiler_OilGas,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_Solid == 1,
              myCalcData$Code_EC_Boiler_Solid,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ElectricCentral == 1,
              myCalcData$Code_EC_ElectricCentral,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ThermalSolar == 1,
              myCalcData$Code_EC_ThermalSolar,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Stove == 1,
              myCalcData$Code_SysH_EC_Stove,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_DirectElectric == 1,
              myCalcData$Code_SysH_EC_Dec_DirectElectric,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_ElectricNightStorage == 1,
              myCalcData$Code_SysH_EC_Dec_ElectricNightStorage,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_Heatpump == 1,
              myCalcData$Code_SysH_EC_Dec_Heatpump,
              ""
          ),
          sep = ""
      )
      ,
      "-")

  myCalcData$Code_SysH_EC_2 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysH_G_DistrictHeating == 2,
              myCalcData$Code_EC_DistrictHeating,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_CHP == 2,
              myCalcData$Code_EC_CHP,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Heatpump == 2,
              myCalcData$Code_EC_Heatpump,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_OilGas == 2,
              myCalcData$Code_EC_Boiler_OilGas,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_Solid == 2,
              myCalcData$Code_EC_Boiler_Solid,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ElectricCentral == 2,
              myCalcData$Code_EC_ElectricCentral,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ThermalSolar == 2,
              myCalcData$Code_EC_ThermalSolar,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Stove == 2,
              myCalcData$Code_SysH_EC_Stove,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_DirectElectric == 2,
              myCalcData$Code_SysH_EC_Dec_DirectElectric,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_ElectricNightStorage == 2,
              myCalcData$Code_SysH_EC_Dec_ElectricNightStorage,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_Heatpump == 2,
              myCalcData$Code_SysH_EC_Dec_Heatpump,
              ""
          ),
          sep = ""
      )
      ,
      "-")

  myCalcData$Code_SysH_EC_3 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysH_G_DistrictHeating == 3,
              myCalcData$Code_EC_DistrictHeating,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_CHP == 3,
              myCalcData$Code_EC_CHP,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Heatpump == 3,
              myCalcData$Code_EC_Heatpump,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_OilGas == 3,
              myCalcData$Code_EC_Boiler_OilGas,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_Solid == 3,
              myCalcData$Code_EC_Boiler_Solid,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ElectricCentral == 3,
              myCalcData$Code_EC_ElectricCentral,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ThermalSolar == 3,
              myCalcData$Code_EC_ThermalSolar,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Stove == 3,
              myCalcData$Code_SysH_EC_Stove,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_DirectElectric == 3,
              myCalcData$Code_SysH_EC_Dec_DirectElectric,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_ElectricNightStorage == 3,
              myCalcData$Code_SysH_EC_Dec_ElectricNightStorage,
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_Heatpump == 3,
              myCalcData$Code_SysH_EC_Dec_Heatpump,
              ""
          ),
          sep = ""
      )
      ,
      "-")

  # Above the strings are pasted using "" if the code is not assigned (to simplify the script).
  # Later "-" is used when no heat generator is assigned.
  myCalcData$Code_SysH_G_1 [myCalcData$Code_SysH_G_1 ==""] <- "-"
  myCalcData$Code_SysH_G_2 [myCalcData$Code_SysH_G_2 ==""] <- "-"
  myCalcData$Code_SysH_G_3 [myCalcData$Code_SysH_G_3 ==""] <- "-"
  myCalcData$Code_SysH_EC_1 [myCalcData$Code_SysH_EC_1 ==""] <- "-"
  myCalcData$Code_SysH_EC_2 [myCalcData$Code_SysH_EC_2 ==""] <- "-"
  myCalcData$Code_SysH_EC_3 [myCalcData$Code_SysH_EC_3 ==""] <- "-"

  myCalcData$Fraction_Interim_SysH_G_1 <-
      AuxFunctions::Replace_NA (as.numeric(
          pmax (
              ifelse (
                  myCalcData$Index_SysH_G_DistrictHeating == 1,
                  myCalcData$Fraction_DistrictHeating_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_CHP == 1,
                  myCalcData$Fraction_CHP_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Heatpump == 1,
                  myCalcData$Fraction_Heatpump_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Boiler_OilGas == 1,
                  myCalcData$Fraction_Boiler_OilGas_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Boiler_Solid == 1,
                  myCalcData$Fraction_Boiler_Solid_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_ElectricCentral == 1,
                  myCalcData$Fraction_ElectricCentral_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_ThermalSolar == 1,
                  myCalcData$Fraction_ThermalSolar_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Stove == 1,
                  myCalcData$Fraction_Stove_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Dec_DirectElectric == 1,
                  myCalcData$Fraction_Dec_DirectElectric_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Dec_ElectricNightStorage == 1,
                  myCalcData$Fraction_Dec_ElectricNightStorage_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Dec_Heatpump == 1,
                  myCalcData$Fraction_Dec_Heatpump_SysH,
                  0
              )
          )
      )
      ,
      0)


  myCalcData$Fraction_Interim_SysH_G_2 <-
      AuxFunctions::Replace_NA (as.numeric (
          pmax (
              ifelse (
                  myCalcData$Index_SysH_G_DistrictHeating == 2,
                  myCalcData$Fraction_DistrictHeating_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_CHP == 2,
                  myCalcData$Fraction_CHP_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Heatpump == 2,
                  myCalcData$Fraction_Heatpump_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Boiler_OilGas == 2,
                  myCalcData$Fraction_Boiler_OilGas_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Boiler_Solid == 2,
                  myCalcData$Fraction_Boiler_Solid_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_ElectricCentral == 2,
                  myCalcData$Fraction_ElectricCentral_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_ThermalSolar == 2,
                  myCalcData$Fraction_ThermalSolar_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Stove == 2,
                  myCalcData$Fraction_Stove_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Dec_DirectElectric == 2,
                  myCalcData$Fraction_Dec_DirectElectric_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Dec_ElectricNightStorage == 2,
                  myCalcData$Fraction_Dec_ElectricNightStorage_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Dec_Heatpump == 2,
                  myCalcData$Fraction_Dec_Heatpump_SysH,
                  0
              )
          )
      )
      ,
      0)

  myCalcData$Fraction_Interim_SysH_G_3 <-
      AuxFunctions::Replace_NA (as.numeric (
          pmax (
              ifelse (
                  myCalcData$Index_SysH_G_DistrictHeating == 3,
                  myCalcData$Fraction_DistrictHeating_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_CHP == 3,
                  myCalcData$Fraction_CHP_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Heatpump == 3,
                  myCalcData$Fraction_Heatpump_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Boiler_OilGas == 3,
                  myCalcData$Fraction_Boiler_OilGas_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Boiler_Solid == 3,
                  myCalcData$Fraction_Boiler_Solid_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_ElectricCentral == 3,
                  myCalcData$Fraction_ElectricCentral_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_ThermalSolar == 3,
                  myCalcData$Fraction_ThermalSolar_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Stove == 3,
                  myCalcData$Fraction_Stove_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Dec_DirectElectric == 3,
                  myCalcData$Fraction_Dec_DirectElectric_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Dec_ElectricNightStorage == 3,
                  myCalcData$Fraction_Dec_ElectricNightStorage_SysH,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysH_G_Dec_Heatpump == 3,
                  myCalcData$Fraction_Dec_Heatpump_SysH,
                  0
              )
          )
      )
      ,
      0)





  myCalcData$Fraction_SysH_G_1 <-
      ifelse (
          ((
              AuxFunctions::Replace_NA (myCalcData$Fraction_Interim_SysH_G_2 * 1 > 0, FALSE) &
                  AuxFunctions::Replace_NA (myCalcData$Fraction_Interim_SysH_G_3 * 1 > 0, FALSE)
          )
          &
              ((myCalcData$Index_SysH_G_DistrictHeating == 1) |
                   (myCalcData$Index_SysH_G_CHP == 1) |
                   (myCalcData$Index_SysH_G_Heatpump == 1)
              )),
          myCalcData$Fraction_Interim_SysH_G_1,
          1 - AuxFunctions::Replace_NA (myCalcData$Fraction_Interim_SysH_G_2 * 1, 0) - AuxFunctions::Replace_NA (myCalcData$Fraction_Interim_SysH_G_3 * 1, 0)
      ) # <API11>

  myCalcData$Fraction_SysH_G_2 <-
      AuxFunctions::Replace_NA (
          AuxFunctions::Replace_NA (myCalcData$Fraction_Interim_SysH_G_2 * 1, 0) / (
              AuxFunctions::Replace_NA (myCalcData$Fraction_Interim_SysH_G_2 * 1, 0) +
                  AuxFunctions::Replace_NA (myCalcData$Fraction_Interim_SysH_G_3 * 1, 0)
          ) * (1 - myCalcData$Fraction_SysH_G_1),
          0
      ) # <APJ11>

  myCalcData$Fraction_SysH_G_3 <-
      AuxFunctions::Replace_NA (1 - myCalcData$Fraction_SysH_G_1 - myCalcData$Fraction_SysH_G_2,
                  0) # <APK11>

  myCalcData$Count_SysH_G <-
      apply (Index_SysH_G_Combined, 1, max) # <APL11>


  myCalcData$Message_Count_SysH_G <-
      ifelse (
          myCalcData$Count_SysH_G > 3,
          paste (
              "Notice: " ,
              myCalcData$Count_SysH_G,
              " heat generators for heating selected. Only 3 are beeing considered.",
              sep=""
          ),
          "-"
      ) # <APM11>







  myCalcData$Code_CentralDecentral_SysH_G_1 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysH_G_DistrictHeating == 1,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_CHP == 1,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Heatpump == 1,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_OilGas == 1,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_Solid == 1,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ElectricCentral == 1,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ThermalSolar == 1,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Stove == 1,
              "D",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_DirectElectric == 1,
              "D",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_ElectricNightStorage == 1,
              "D",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_Heatpump == 1,
              "D",
              ""
          ),
          sep = ""
      )
      ,
      "-")






  myCalcData$Code_CentralDecentral_SysH_G_2 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysH_G_DistrictHeating == 2,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_CHP == 2,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Heatpump == 2,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_OilGas == 2,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_Solid == 2,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ElectricCentral == 2,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ThermalSolar == 2,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Stove == 2,
              "D",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_DirectElectric == 2,
              "D",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_ElectricNightStorage == 2,
              "D",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_Heatpump == 2,
              "D",
              ""
          ),
          sep = ""
      )
      ,
      "-")



  myCalcData$Code_CentralDecentral_SysH_G_3 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysH_G_DistrictHeating == 3,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_CHP == 3,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Heatpump == 3,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_OilGas == 3,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Boiler_Solid == 3,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ElectricCentral == 3,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_ThermalSolar == 3,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Stove == 3,
              "D",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_DirectElectric == 3,
              "D",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_ElectricNightStorage == 3,
              "D",
              ""
          ),
          ifelse (
              myCalcData$Index_SysH_G_Dec_Heatpump == 3,
              "D",
              ""
          ),
          sep = ""
      )
      ,
      "-")

  myCalcData$Code_CentralDecentral_SysH_G_1 [myCalcData$Code_CentralDecentral_SysH_G_1 ==""] <- "-"
  myCalcData$Code_CentralDecentral_SysH_G_2 [myCalcData$Code_CentralDecentral_SysH_G_2 ==""] <- "-"
  myCalcData$Code_CentralDecentral_SysH_G_3 [myCalcData$Code_CentralDecentral_SysH_G_3 ==""] <- "-"


  myCalcData$Fraction_SysH_G_Central <-
      (myCalcData$Code_CentralDecentral_SysH_G_1 == "C") * myCalcData$Fraction_SysH_G_1 +
      (myCalcData$Code_CentralDecentral_SysH_G_2 == "C") * myCalcData$Fraction_SysH_G_2 +
      (myCalcData$Code_CentralDecentral_SysH_G_3 == "C") * myCalcData$Fraction_SysH_G_3 # <APQ11>


  myCalcData$e_g_h_Heat_1 <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Code_SysH_G_1 == "-",
          0,
          round (as.numeric (ParTab_System_HG [myCalcData$Code_SysH_G_1, "e_g_h_Heat"]), digits = 3)
          )
      , -999999) #

  myCalcData$e_g_h_Heat_2 <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Code_SysH_G_2 == "-",
          0,
          round (as.numeric (ParTab_System_HG [myCalcData$Code_SysH_G_2, "e_g_h_Heat"]), digits = 3)
      )
      , -999999) #

  myCalcData$e_g_h_Heat_3 <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Code_SysH_G_3 == "-",
          0,
          round (as.numeric (ParTab_System_HG [myCalcData$Code_SysH_G_3, "e_g_h_Heat"]), digits = 3)
      )
      , -999999) #



  myCalcData$e_g_h_Electricity_1 <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Code_SysH_G_1 == "-",
          0,
          round (as.numeric (ParTab_System_HG [myCalcData$Code_SysH_G_1, "e_g_h_Electricity"]), digits = 3)
      )
      , -999999) #

  myCalcData$e_g_h_Electricity_2 <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Code_SysH_G_2 == "-",
          0,
          round (as.numeric (ParTab_System_HG [myCalcData$Code_SysH_G_2, "e_g_h_Electricity"]), digits = 3)
      )
      , -999999) #

  myCalcData$e_g_h_Electricity_3 <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Code_SysH_G_3 == "-",
          0,
          round (as.numeric (ParTab_System_HG [myCalcData$Code_SysH_G_3, "e_g_h_Electricity"]), digits = 3)
      )
      , -999999) #


  myCalcData$Code_CentralisationType_SysHG <-
      ifelse (
          myCalcData$Code_CentralisationType_SysHG_Input == "_NA_",
          ifelse (
              AuxFunctions::xl_AND (
                  myCalcData$Indicator_Completeness_SysHG_Central == 0,
                  myCalcData$Indicator_Completeness_SysHG_Decentral > 0,
                  AuxFunctions::Replace_NA (myCalcData$Indicator_Distribution_SysH * 1, 0) == 1
              ),
              "Room",
              "Building"
          ),
          myCalcData$Code_CentralisationType_SysHG_Input
      ) # <APX11>

  #####################################################################################X
  ## . SysH_S and SysH_D - Codes of storage and distribution for heating system  ------------


  myCalcData$Code_SysH_S <-
      ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_Storage_SysH * 1, 0) == 1,
          ifelse (
              AuxFunctions::Replace_NA (
                  myCalcData$Indicator_Storage_SysH_InsideEnvelope * 1,
                  ifelse (myCalcData$Code_CellarCond == "N", 0, 1)
              ) == 1,
              paste (myCalcData$Code_Country, ".BS.Gen.11", sep=""),
              paste (myCalcData$Code_Country, ".",
                     ifelse (
                      myCalcData$Code_BuildingSizeClass_System == "SUH",
                      "BS_E.SUH",
                      "BS.MUH"
                  ),
                  ifelse (
                      myCalcData$Year_Installation_Storage_SysH_Calc >= 1995,
                      ".12",
                      ".11"
                  ), sep ="")
          ),
          "-"
      ) # <APY11>

  myCalcData$Code_SysH_D <-
      ifelse (
          (myCalcData$Code_CentralisationType_SysHG != "Room") &
              (myCalcData$Code_CentralisationType_SysHG != "Apartment") &
              (AuxFunctions::Replace_NA (myCalcData$Indicator_Distribution_SysH, 1) * 1 != 0),
          paste (myCalcData$Code_Country, "." ,
              ifelse (
                  AuxFunctions::Replace_NA (
                      myCalcData$Indicator_Distribution_SysH_OutsideEnvelope * 1,
                      ifelse (myCalcData$Code_CellarCond == "N", 1, 0)
                  ) == 1,
                  "C_Ext.",
                  "C_Int."
              ) ,
              ifelse (myCalcData$Code_BuildingSizeClass_System == "SUH", "SUH", "MUH"),
              ifelse (
                  myCalcData$Year_Installation_Distribution_SysH_Calc >= 1995,
                  ifelse (
                      AuxFunctions::Replace_NA (myCalcData$Indicator_Distribution_SysH_PoorlyInsulated * 1, 0) == 1,
                      ".13",
                      ifelse (AuxFunctions::xl_AND (
                          AuxFunctions::Replace_NA (myCalcData$Indicator_Distribution_SysH_LowTemperature * 1, 0) == 1,
                          AuxFunctions::Replace_NA (
                              myCalcData$Indicator_Distribution_SysH_OutsideEnvelope * 1,
                              ifelse (myCalcData$Code_CellarCond == "N", 1, 0)
                          ) == 1),
                          ".15",
                          ".14")
                  ),
                  ifelse (
                      AuxFunctions::Replace_NA (myCalcData$Indicator_Distribution_SysH_PoorlyInsulated * 1, 0) == 1,
                      ".11",
                      ".13"
                  )
              ), sep=""),
          "-"
      ) # <APZ11>

  # 2021-10-13 additional condition for Indicator_Distribution_SysH included --> enables explicitely switching off heating system distribution (f?r Zweileitersystem)
  # myCalcData$Code_SysH_D <-
  #     ifelse (
  #         (myCalcData$Code_CentralisationType_SysHG != "Room") &
  #             (myCalcData$Code_CentralisationType_SysHG != "Apartment"),
  #         paste (myCalcData$Code_Country, "." ,
  #                ifelse (
  #                    AuxFunctions::Replace_NA (
  #                        myCalcData$Indicator_Distribution_SysH_OutsideEnvelope * 1,
  #                        ifelse (myCalcData$Code_CellarCond == "N", 1, 0)
  #                    ) == 1,
  #                    "C_Ext.",
  #                    "C_Int."
  #                ) ,
  #                ifelse (myCalcData$Code_BuildingSizeClass_System == "SUH", "SUH", "MUH"),
  #                ifelse (
  #                    myCalcData$Year_Installation_Distribution_SysH_Calc >= 1995,
  #                    ifelse (
  #                        AuxFunctions::Replace_NA (myCalcData$Indicator_Distribution_SysH_PoorlyInsulated * 1, 0) == 1,
  #                        ".13",
  #                        ifelse (AuxFunctions::xl_AND (
  #                            AuxFunctions::Replace_NA (myCalcData$Indicator_Distribution_SysH_LowTemperature * 1, 0) == 1,
  #                            AuxFunctions::Replace_NA (
  #                                myCalcData$Indicator_Distribution_SysH_OutsideEnvelope * 1,
  #                                ifelse (myCalcData$Code_CellarCond == "N", 1, 0)
  #                            ) == 1),
  #                            ".15",
  #                            ".14")
  #                    ),
  #                    ifelse (
  #                        AuxFunctions::Replace_NA (myCalcData$Indicator_Distribution_SysH_PoorlyInsulated * 1, 0) == 1,
  #                        ".11",
  #                        ".13"
  #                    )
  #                ), sep=""),
  #         "-"
  #     ) # <APZ11>

  myCalcData$Code_SysH_Aux <-
      ifelse (
          myCalcData$Code_Country != 0,
          paste (myCalcData$Code_Country,
              ifelse (
                  myCalcData$Fraction_SysH_G_Central >= 0.5,
                  paste (".C.",
                      ifelse (myCalcData$Code_BuildingSizeClass_System == "SUH", "SUH", "MUH"), sep =""),
                  ".D.Gen"
              ), ".11", sep=""),
          "-"
      ) # <AQA11>

  myCalcData$Indicator_Completeness_SysHD <-
      0.25 * AuxFunctions::xl_NOT (is.na (myCalcData$Indicator_Distribution_SysH)) +
      0.25 * AuxFunctions::xl_NOT (is.na (myCalcData$Indicator_Distribution_SysH_OutsideEnvelope)) +
      0.25 * AuxFunctions::xl_NOT (is.na (myCalcData$Indicator_Distribution_SysH_PoorlyInsulated)) +
      0.25 * AuxFunctions::xl_NOT (is.na (myCalcData$Indicator_Distribution_SysH_LowTemperature)) # <AQB11>

  myCalcData$Indicator_Completeness_SysHS <-
      0.5 * AuxFunctions::xl_NOT (is.na (myCalcData$Indicator_Storage_SysH)) +
      0.25 * AuxFunctions::xl_NOT (is.na (myCalcData$Indicator_Storage_SysH_Immersion)) +
      0.25 * AuxFunctions::xl_NOT (is.na (myCalcData$Indicator_Storage_SysH_InsideEnvelope)) # <AQC11>

  myCalcData$q_s_h_Database <- Value_ParTab (ParTab_System_HS, myCalcData$Code_SysH_S, "q_s_h", 3, "-", 0, Value_Numeric_Error)

  myCalcData$q_d_h_Database <- Value_ParTab (ParTab_System_HD, myCalcData$Code_SysH_D, "q_d_h", 3, "-", 0, Value_Numeric_Error)

  myCalcData$q_del_h_aux_Database <- Value_ParTab (ParTab_System_HA, myCalcData$Code_SysH_Aux, "q_del_h_aux", 3, "-", 0, Value_Numeric_Error)

  myCalcData$q_s_h <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Indicator_SysHW_D_S_ExtraThickInsulation * 1 == 1,
          0.8,
          1
      ),
      1) * myCalcData$q_s_h_Database # <AQG11>

  myCalcData$q_d_h <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Indicator_SysHW_D_S_ExtraThickInsulation * 1 == 1,
          0.8,
          1
      ),
      1) * myCalcData$q_d_h_Database # <AQH11>

  myCalcData$q_del_h_aux <- myCalcData$q_del_h_aux_Database # <AQI11>




  myCalcData$Index_SysW_G_DistrictHeating <-
      ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_DistrictHeating * 1, 0) * AuxFunctions::Replace_NA (myCalcData$Indicator_DistrictHeating_SysW * 1, 1) == 1,
          1,
          0
      ) # <AQJ11>
  Index_SysW_G_Combined <- myCalcData$Index_SysW_G_DistrictHeating

  myCalcData$Index_SysW_G_CHP <-
      ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_CHP * 1, 0) * AuxFunctions::Replace_NA (myCalcData$Indicator_CHP_SysW * 1, 1) == 1,
          Index_SysW_G_Combined + 1,
          0
      ) # <AQK11>
  Index_SysW_G_Combined <-  cbind (Index_SysW_G_Combined, myCalcData$Index_SysW_G_CHP)

  myCalcData$Index_SysW_G_Heatpump <-
      ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_Heatpump * 1, 0) * AuxFunctions::Replace_NA (myCalcData$Indicator_Heatpump_SysW * 1, 1) == 1,
          apply (Index_SysW_G_Combined, 1, max) + 1,
          0
      ) # <AQL11>
  Index_SysW_G_Combined <-  cbind (Index_SysW_G_Combined, myCalcData$Index_SysW_G_Heatpump)

  myCalcData$Index_SysW_G_Boiler_OilGas <-
      ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_Boiler_OilGas * 1, 0) * AuxFunctions::Replace_NA (myCalcData$Indicator_Boiler_OilGas_SysW * 1, 1) == 1,
          apply (Index_SysW_G_Combined, 1, max) + 1,
          0
      ) # <AQM11>
  Index_SysW_G_Combined <-  cbind (Index_SysW_G_Combined, myCalcData$Index_SysW_G_Boiler_OilGas)

  myCalcData$Index_SysW_G_Boiler_Solid <-
      ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_Boiler_Solid * 1, 0) * AuxFunctions::Replace_NA (myCalcData$Indicator_Boiler_Solid_SysW * 1, 1) == 1,
          apply (Index_SysW_G_Combined, 1, max) + 1,
          0
      ) # <AQN11>
  Index_SysW_G_Combined <-  cbind (Index_SysW_G_Combined, myCalcData$Index_SysW_G_Boiler_Solid)

  myCalcData$Index_SysW_G_ElectricCentral <-
      ifelse (
          AuxFunctions::xl_OR (
              AuxFunctions::Replace_NA (myCalcData$Indicator_ElectricCentral * 1, 0) * AuxFunctions::Replace_NA (myCalcData$Indicator_ElectricCentral_SysW * 1, 1) == 1,
              AuxFunctions::Replace_NA (myCalcData$Indicator_Storage_SysW * 1, 0) * AuxFunctions::Replace_NA (myCalcData$Indicator_Storage_SysW_Immersion * 1, 0) == 1
          ),
          apply (Index_SysW_G_Combined, 1, max) + 1,
          0
      ) # <AQO11>
  Index_SysW_G_Combined <-  cbind (Index_SysW_G_Combined, myCalcData$Index_SysW_G_ElectricCentral)

  myCalcData$Index_SysW_G_ThermalSolar <-
      ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_ThermalSolar * 1, 0) * AuxFunctions::Replace_NA (myCalcData$Indicator_ThermalSolar_SysW * 1, 1) == 1,
          apply (Index_SysW_G_Combined, 1, max) + 1,
          0
      ) # <AQP11>
  Index_SysW_G_Combined <-  cbind (Index_SysW_G_Combined, myCalcData$Index_SysW_G_ThermalSolar)

  myCalcData$Index_SysW_G_Dec_ElectricStorage <-
      ifelse (
         (AuxFunctions::Replace_NA (myCalcData$Indicator_SysW_G_Decentral * 1, 0) *
          AuxFunctions::Replace_NA (myCalcData$Indicator_SysW_G_Dec_ElectricStorage * 1, 0)) == 1,
          apply (Index_SysW_G_Combined, 1, max) + 1,
          0
      ) # <AQQ11>
  Index_SysW_G_Combined <-  cbind (Index_SysW_G_Combined, myCalcData$Index_SysW_G_Dec_ElectricStorage)

  myCalcData$Index_SysW_G_Dec_ElectricTankless <-
      ifelse (
          (AuxFunctions::Replace_NA (myCalcData$Indicator_SysW_G_Decentral * 1, 0) *
           AuxFunctions::Replace_NA (myCalcData$Indicator_SysW_G_Dec_ElectricTankless * 1, 0)) == 1,
          apply (Index_SysW_G_Combined, 1, max) + 1,
          0
      ) # <AQR11>
  Index_SysW_G_Combined <-  cbind (Index_SysW_G_Combined, myCalcData$Index_SysW_G_Dec_ElectricTankless)

  myCalcData$Index_SysW_G_Dec_GasTankless <-
      ifelse (
          (AuxFunctions::Replace_NA (myCalcData$Indicator_SysW_G_Decentral * 1, 0) *
           AuxFunctions::Replace_NA (myCalcData$Indicator_SysW_G_Dec_GasTankless * 1, 0)) == 1,
          apply (Index_SysW_G_Combined, 1, max) + 1,
          0
      ) # <AQS11>
  Index_SysW_G_Combined <-  cbind (Index_SysW_G_Combined, myCalcData$Index_SysW_G_Dec_GasTankless)

  #Index_SysW_G_Combined[157,]








  #####################################################################################X
  ## . SysW - Assign heat generators, energy carriers, and fractions to the three calculation slots  -----


  myCalcData$Code_SysW_G_1 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysW_G_DistrictHeating == 1,
              myCalcData$Code_SysW_G_DistrictHeating,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_CHP == 1,
              myCalcData$Code_SysW_G_CHP,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Heatpump == 1,
              myCalcData$Code_SysW_G_Heatpump,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_OilGas == 1,
              myCalcData$Code_SysW_G_Boiler_OilGas,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_Solid == 1,
              myCalcData$Code_SysW_G_Boiler_Solid,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ElectricCentral == 1,
              myCalcData$Code_SysW_G_ElectricCentral,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ThermalSolar == 1,
              myCalcData$Code_SysW_G_ThermalSolar,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricStorage == 1,
              myCalcData$Code_SysW_G_Dec_ElectricStorage,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricTankless == 1,
              myCalcData$Code_SysW_G_Dec_ElectricTankless,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_GasTankless == 1,
              myCalcData$Code_SysW_G_Dec_GasTankless,
              ""
          ),
          sep = ""
      )
      ,
      "")

  myCalcData$Code_SysW_G_2 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysW_G_DistrictHeating == 2,
              myCalcData$Code_SysW_G_DistrictHeating,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_CHP == 2,
              myCalcData$Code_SysW_G_CHP,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Heatpump == 2,
              myCalcData$Code_SysW_G_Heatpump,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_OilGas == 2,
              myCalcData$Code_SysW_G_Boiler_OilGas,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_Solid == 2,
              myCalcData$Code_SysW_G_Boiler_Solid,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ElectricCentral == 2,
              myCalcData$Code_SysW_G_ElectricCentral,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ThermalSolar == 2,
              myCalcData$Code_SysW_G_ThermalSolar,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricStorage == 2,
              myCalcData$Code_SysW_G_Dec_ElectricStorage,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricTankless == 2,
              myCalcData$Code_SysW_G_Dec_ElectricTankless,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_GasTankless == 2,
              myCalcData$Code_SysW_G_Dec_GasTankless,
              ""
          ),
          sep = ""
      )
      ,
      "")

  myCalcData$Code_SysW_G_3 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysW_G_DistrictHeating == 3,
              myCalcData$Code_SysW_G_DistrictHeating,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_CHP == 3,
              myCalcData$Code_SysW_G_CHP,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Heatpump == 3,
              myCalcData$Code_SysW_G_Heatpump,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_OilGas == 3,
              myCalcData$Code_SysW_G_Boiler_OilGas,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_Solid == 3,
              myCalcData$Code_SysW_G_Boiler_Solid,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ElectricCentral == 3,
              myCalcData$Code_SysW_G_ElectricCentral,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ThermalSolar == 3,
              myCalcData$Code_SysW_G_ThermalSolar,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricStorage == 3,
              myCalcData$Code_SysW_G_Dec_ElectricStorage,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricTankless == 3,
              myCalcData$Code_SysW_G_Dec_ElectricTankless,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_GasTankless == 3,
              myCalcData$Code_SysW_G_Dec_GasTankless,
              ""
          ),
          sep = ""
      ),
      "")

  myCalcData$Code_SysW_EC_1 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysW_G_DistrictHeating == 1,
              myCalcData$Code_EC_DistrictHeating,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_CHP == 1,
              myCalcData$Code_EC_CHP,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Heatpump == 1,
              myCalcData$Code_EC_Heatpump,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_OilGas == 1,
              myCalcData$Code_EC_Boiler_OilGas,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_Solid == 1,
              myCalcData$Code_EC_Boiler_Solid,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ElectricCentral == 1,
              myCalcData$Code_EC_ElectricCentral,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ThermalSolar == 1,
              myCalcData$Code_EC_ThermalSolar,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricStorage == 1,
              myCalcData$Code_SysW_EC_Dec_ElectricStorage,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricTankless == 1,
              myCalcData$Code_SysW_EC_Dec_ElectricTankless,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_GasTankless == 1,
              myCalcData$Code_SysW_EC_Dec_GasTankless,
              ""
          ),
          sep = ""
      )
      ,
      "")

  myCalcData$Code_SysW_EC_2 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysW_G_DistrictHeating == 2,
              myCalcData$Code_EC_DistrictHeating,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_CHP == 2,
              myCalcData$Code_EC_CHP,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Heatpump == 2,
              myCalcData$Code_EC_Heatpump,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_OilGas == 2,
              myCalcData$Code_EC_Boiler_OilGas,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_Solid == 2,
              myCalcData$Code_EC_Boiler_Solid,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ElectricCentral == 2,
              myCalcData$Code_EC_ElectricCentral,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ThermalSolar == 2,
              myCalcData$Code_EC_ThermalSolar,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricStorage == 2,
              myCalcData$Code_SysW_EC_Dec_ElectricStorage,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricTankless == 2,
              myCalcData$Code_SysW_EC_Dec_ElectricTankless,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_GasTankless == 2,
              myCalcData$Code_SysW_EC_Dec_GasTankless,
              ""
          ),
          sep = ""
      )
      ,
      "")

  myCalcData$Code_SysW_EC_3 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysW_G_DistrictHeating == 3,
              myCalcData$Code_EC_DistrictHeating,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_CHP == 3,
              myCalcData$Code_EC_CHP,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Heatpump == 3,
              myCalcData$Code_EC_Heatpump,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_OilGas == 3,
              myCalcData$Code_EC_Boiler_OilGas,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_Solid == 3,
              myCalcData$Code_EC_Boiler_Solid,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ElectricCentral == 3,
              myCalcData$Code_EC_ElectricCentral,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ThermalSolar == 3,
              myCalcData$Code_EC_ThermalSolar,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricStorage == 3,
              myCalcData$Code_SysW_EC_Dec_ElectricStorage,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricTankless == 3,
              myCalcData$Code_SysW_EC_Dec_ElectricTankless,
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_GasTankless == 3,
              myCalcData$Code_SysW_EC_Dec_GasTankless,
              ""
          ),
          sep = ""
      )
      ,
      "")

  # Above the strings are pasted using "" if the code is not assigned (to simplify the script).
  # Later "-" is used when no heat generator is assigned.
  myCalcData$Code_SysW_G_1 [myCalcData$Code_SysW_G_1 ==""] <- "-"
  myCalcData$Code_SysW_G_2 [myCalcData$Code_SysW_G_2 ==""] <- "-"
  myCalcData$Code_SysW_G_3 [myCalcData$Code_SysW_G_3 ==""] <- "-"
  myCalcData$Code_SysW_EC_1 [myCalcData$Code_SysW_EC_1 ==""] <- "-"
  myCalcData$Code_SysW_EC_2 [myCalcData$Code_SysW_EC_2 ==""] <- "-"
  myCalcData$Code_SysW_EC_3 [myCalcData$Code_SysW_EC_3 ==""] <- "-"



  myCalcData$Fraction_Interim_SysW_G_1 <-
      AuxFunctions::Replace_NA (as.numeric(
          pmax (
              ifelse (
                  myCalcData$Index_SysW_G_DistrictHeating == 1,
                  myCalcData$Fraction_DistrictHeating_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_CHP == 1,
                  myCalcData$Fraction_CHP_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Heatpump == 1,
                  myCalcData$Fraction_Heatpump_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Boiler_OilGas == 1,
                  myCalcData$Fraction_Boiler_OilGas_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Boiler_Solid == 1,
                  myCalcData$Fraction_Boiler_Solid_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_ElectricCentral == 1,
                  myCalcData$Fraction_ElectricCentral_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_ThermalSolar == 1,
                  myCalcData$Fraction_ThermalSolar_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Dec_ElectricStorage == 1,
                  myCalcData$Fraction_Dec_ElectricStorage_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Dec_ElectricTankless == 1,
                  myCalcData$Fraction_Dec_ElectricTankless_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Dec_GasTankless == 1,
                  myCalcData$Fraction_Dec_GasTankless_SysW,
                  0
              )
          )
      )
      ,
      0)

  myCalcData$Fraction_Interim_SysW_G_2 <-
      AuxFunctions::Replace_NA (as.numeric(
          pmax (
              ifelse (
                  myCalcData$Index_SysW_G_DistrictHeating == 2,
                  myCalcData$Fraction_DistrictHeating_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_CHP == 2,
                  myCalcData$Fraction_CHP_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Heatpump == 2,
                  myCalcData$Fraction_Heatpump_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Boiler_OilGas == 2,
                  myCalcData$Fraction_Boiler_OilGas_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Boiler_Solid == 2,
                  myCalcData$Fraction_Boiler_Solid_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_ElectricCentral == 2,
                  myCalcData$Fraction_ElectricCentral_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_ThermalSolar == 2,
                  myCalcData$Fraction_ThermalSolar_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Dec_ElectricStorage == 2,
                  myCalcData$Fraction_Dec_ElectricStorage_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Dec_ElectricTankless == 2,
                  myCalcData$Fraction_Dec_ElectricTankless_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Dec_GasTankless == 2,
                  myCalcData$Fraction_Dec_GasTankless_SysW,
                  0
              )
          )
      )
      ,
      0)



  myCalcData$Fraction_Interim_SysW_G_3 <-
      AuxFunctions::Replace_NA (as.numeric(
          pmax (
              ifelse (
                  myCalcData$Index_SysW_G_DistrictHeating == 3,
                  myCalcData$Fraction_DistrictHeating_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_CHP == 3,
                  myCalcData$Fraction_CHP_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Heatpump == 3,
                  myCalcData$Fraction_Heatpump_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Boiler_OilGas == 3,
                  myCalcData$Fraction_Boiler_OilGas_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Boiler_Solid == 3,
                  myCalcData$Fraction_Boiler_Solid_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_ElectricCentral == 3,
                  myCalcData$Fraction_ElectricCentral_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_ThermalSolar == 3,
                  myCalcData$Fraction_ThermalSolar_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Dec_ElectricStorage == 3,
                  myCalcData$Fraction_Dec_ElectricStorage_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Dec_ElectricTankless == 3,
                  myCalcData$Fraction_Dec_ElectricTankless_SysW,
                  0
              ),
              ifelse (
                  myCalcData$Index_SysW_G_Dec_GasTankless == 3,
                  myCalcData$Fraction_Dec_GasTankless_SysW,
                  0
              )
          )
      )
      ,
      0)






















  myCalcData$Fraction_SysW_G_1 <-
      ifelse (
          AuxFunctions::xl_AND (
              AuxFunctions::xl_AND (
                  AuxFunctions::Replace_NA (myCalcData$Fraction_Interim_SysW_G_2 > 0, FALSE),
                  AuxFunctions::Replace_NA (myCalcData$Fraction_Interim_SysW_G_3 > 0, FALSE)
              ),
              AuxFunctions::xl_OR (
                  myCalcData$Index_SysW_G_DistrictHeating == 1,
                  myCalcData$Index_SysW_G_CHP == 1,
                  myCalcData$Index_SysW_G_Heatpump == 1
              )
          ),
          myCalcData$Fraction_Interim_SysW_G_1,
          1 - AuxFunctions::Replace_NA (myCalcData$Fraction_Interim_SysW_G_2, 0) - AuxFunctions::Replace_NA (myCalcData$Fraction_Interim_SysW_G_3, 0)
      ) # <ARC11>

  myCalcData$Fraction_SysW_G_2 <-
      AuxFunctions::Replace_NA (
          AuxFunctions::Replace_NA (myCalcData$Fraction_Interim_SysW_G_2, 0) /
              (AuxFunctions::Replace_NA (myCalcData$Fraction_Interim_SysW_G_2, 0) + AuxFunctions::Replace_NA (myCalcData$Fraction_Interim_SysW_G_3, 0)) *
              (1 - myCalcData$Fraction_SysW_G_1),
          0
      ) # <ARD11>

  myCalcData$Fraction_SysW_G_3 <-
      AuxFunctions::Replace_NA (1 - myCalcData$Fraction_SysW_G_1 - myCalcData$Fraction_SysW_G_2,
                  0) # <ARE11>

  myCalcData$Count_SysW_G <-
      apply (Index_SysW_G_Combined, 1, max) # <ARF11>

  myCalcData$Message_Count_SysW_G <-
      ifelse (
          myCalcData$Count_SysW_G > 3,
          paste (
              "Notice: " ,
              myCalcData$Count_SysW_G,
              " heat generators for heating selected. Only 3 are beeing considered.",
              sep=""
          ),
          "-"
      ) # <ARG11>

  myCalcData$Code_CentralDecentral_SysW_G_1 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysW_G_DistrictHeating == 1,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_CHP == 1,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Heatpump == 1,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_OilGas == 1,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_Solid == 1,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ElectricCentral == 1,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ThermalSolar == 1,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricStorage == 1,
              "D",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricTankless == 1,
              "D",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_GasTankless == 1,
              "D",
              ""
          ),
          sep = ""
      )
      ,
      "-")

  myCalcData$Code_CentralDecentral_SysW_G_2 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysW_G_DistrictHeating == 2,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_CHP == 2,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Heatpump == 2,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_OilGas == 2,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_Solid == 2,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ElectricCentral == 2,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ThermalSolar == 2,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricStorage == 2,
              "D",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricTankless == 2,
              "D",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_GasTankless == 2,
              "D",
              ""
          ),
          sep = ""
      )
      ,
      "-")

  myCalcData$Code_CentralDecentral_SysW_G_3 <-
      AuxFunctions::Replace_NA (paste (
          ifelse (
              myCalcData$Index_SysW_G_DistrictHeating == 3,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_CHP == 3,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Heatpump == 3,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_OilGas == 3,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Boiler_Solid == 3,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ElectricCentral == 3,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_ThermalSolar == 3,
              "C",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricStorage == 3,
              "D",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_ElectricTankless == 3,
              "D",
              ""
          ),
          ifelse (
              myCalcData$Index_SysW_G_Dec_GasTankless == 3,
              "D",
              ""
          ),
          sep = ""
      )
      ,
      "-")

  myCalcData$Fraction_SysW_G_Central <-
      (myCalcData$Code_CentralDecentral_SysW_G_1 == "C") * myCalcData$Fraction_SysW_G_1 +
      (myCalcData$Code_CentralDecentral_SysW_G_2 == "C") * myCalcData$Fraction_SysW_G_2 +
      (myCalcData$Code_CentralDecentral_SysW_G_3 == "C") * myCalcData$Fraction_SysW_G_3 # <ARK11>

  myCalcData$e_g_w_Heat_1 <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Code_SysW_G_1 == "-",
          0,
          round (as.numeric (ParTab_System_WG [myCalcData$Code_SysW_G_1, "e_g_w_Heat"]), digits = 3)
      )
      , -999999) #

  myCalcData$e_g_w_Heat_2 <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Code_SysW_G_2 == "-",
          0,
          round (as.numeric (ParTab_System_WG [myCalcData$Code_SysW_G_2, "e_g_w_Heat"]), digits = 3)
      )
      , -999999) #

  myCalcData$e_g_w_Heat_3 <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Code_SysW_G_3 == "-",
          0,
          round (as.numeric (ParTab_System_WG [myCalcData$Code_SysW_G_3, "e_g_w_Heat"]), digits = 3)
      )
      , -999999) #

  myCalcData$e_g_w_Electricity_1 <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Code_SysW_G_1 == "-",
          0,
          round (as.numeric (ParTab_System_WG [myCalcData$Code_SysW_G_1, "e_g_w_Electricity"]), digits = 3)
      )
      , -999999) #

  myCalcData$e_g_w_Electricity_2 <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Code_SysW_G_2 == "-",
          0,
          round (as.numeric (ParTab_System_WG [myCalcData$Code_SysW_G_2, "e_g_w_Electricity"]), digits = 3)
      )
      , -999999) #

  myCalcData$e_g_w_Electricity_3 <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Code_SysW_G_3 == "-",
          0,
          round (as.numeric (ParTab_System_WG [myCalcData$Code_SysW_G_3, "e_g_w_Electricity"]), digits = 3)
      )
      , -999999) #


  #####################################################################################X
  ## . SysW_S and SysW_D - Codes of storage and distribution for DHW system  ------------

  myCalcData$Code_SysW_S_Central <-
      ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_Storage_SysW * 1, 1) == 1,
          paste (
              myCalcData$Code_Country,
              ".S_C_",
              ifelse (
                  AuxFunctions::Replace_NA (
                      myCalcData$Indicator_Storage_SysW_InsideEnvelope * 1,
                      ifelse (myCalcData$Code_CellarCond == "N", 0, 1)
                  ) == 1,
                  "Int.",
                  "Ext."
              ),
              ifelse (myCalcData$Code_BuildingSizeClass_System == "SUH", "SUH", "MUH"),
              ifelse (
                  myCalcData$Year_Installation_Storage_SysW_Calc >= 1995,
                  ".12",
                  ".11"
              ),
              sep = ""
          ),
          "-"
      ) # <ARR11>

  myCalcData$Code_SysW_S_Decentral <-
      ifelse (
          AuxFunctions::Replace_NA (myCalcData$Indicator_SysW_G_Dec_ElectricStorage * 1, 0) == 1,
          paste (
              myCalcData$Code_Country,
              ".S_D.",
              "Gen",
              ifelse (
                  myCalcData$Year_Installation_Storage_SysW_Calc >= 1995,
                  ".12",
                  ".11"
              ),
              sep = ""
          ),
          "-"
      ) # <ARS11>

  myCalcData$Code_SysW_S <-
      ifelse (
          AuxFunctions::xl_AND (
              myCalcData$Code_SysW_S_Central != "-",
              AuxFunctions::xl_OR (
                  myCalcData$Index_SysW_G_ElectricCentral > 0,
                  myCalcData$Fraction_SysW_G_Central >= 0.5
              )
          ),
          myCalcData$Code_SysW_S_Central,
          myCalcData$Code_SysW_S_Decentral
      ) # <ART11>

  myCalcData$Code_SysW_D_NoCirc <-
      ifelse (
          AuxFunctions::xl_AND (
              myCalcData$Code_Country != 0,
              AuxFunctions::Replace_NA (
                  myCalcData$Indicator_Distribution_SysW_CirculationLoop * 1,
                  ifelse (myCalcData$Code_BuildingSize == "MUH", 1, 0)
              ) == 0
          ),
          paste (
              myCalcData$Code_Country,
              ifelse (
                  AuxFunctions::Replace_NA (myCalcData$Indicator_Distribution_SysW * 1, 1) == 1,
                  paste(
                      ".C_",
                      "NoCirc_",
                      ifelse (
                          AuxFunctions::Replace_NA (
                              myCalcData$Indicator_Distribution_SysW_OutsideEnvelope * 1,
                              ifelse (myCalcData$Code_CellarCond == "N", 1, 0)
                          ) == 1,
                          "Int.",
                          "Ext."
                      ),
                      "Gen.",
                      ifelse (
                          myCalcData$Year_Installation_Distribution_SysW_Calc >= 1995,
                          14,
                          ifelse (
                              myCalcData$Year_Installation_Distribution_SysW_Calc >= 1979,
                              13,
                              11
                          )
                      ),
                      sep = ""
                  ),
                  ".D.Gen.12"
              ),
              sep = ""
          ),
          "-"
      ) # <ARU11>

  myCalcData$Code_SysW_D_Circ <-
      ifelse (
          AuxFunctions::xl_AND (
              myCalcData$Code_Country != 0,
              AuxFunctions::Replace_NA (
                  myCalcData$Indicator_Distribution_SysW_CirculationLoop * 1,
                  ifelse (myCalcData$Code_BuildingSize == "MUH", 1, 0)
              ) == 1
          ),
          paste (
              myCalcData$Code_Country,
              ".C_",
              "Circ_",
              ifelse (
                  AuxFunctions::Replace_NA (myCalcData$Indicator_Distribution_SysW_OutsideEnvelope * 1, 1) == 1,
                  "Ext.",
                  "Int."
              ),
              ifelse (
                  myCalcData$Code_BuildingSizeClass_System == "SUH",
                  "SUH.",
                  "MUH."
              ),
              ifelse (
                  AuxFunctions::Replace_NA (myCalcData$Indicator_Distribution_SysW_PoorlyInsulated * 1, 0) == 1,
                  17,
                  ifelse (
                      myCalcData$Year_Installation_Distribution_SysW_Calc >= 1995,
                      14,
                      ifelse (
                          myCalcData$Year_Installation_Distribution_SysW_Calc >= 1979,
                          13,
                          11
                      )
                  )
              ),
              sep = ""
          ),
          "-"
      ) # <ARV11>

  myCalcData$Code_SysW_D <-
      ifelse (
          AuxFunctions::Replace_NA (
              myCalcData$Indicator_Distribution_SysW_CirculationLoop * 1,
              ifelse (myCalcData$Code_BuildingSize == "MUH", 1, 0)
          ) == 1,
          myCalcData$Code_SysW_D_Circ,
          myCalcData$Code_SysW_D_NoCirc
      ) # <ARW11>

  myCalcData$Code_SysW_Aux <-
      ifelse (myCalcData$Code_Country != 0,
              paste (
                  myCalcData$Code_Country,
                  ifelse (
                      myCalcData$Fraction_SysW_G_Central  <= 0.5,
                      ".D.Gen.11",
                      paste (
                          ifelse (
                              AuxFunctions::Replace_NA (myCalcData$Indicator_Distribution_SysW_CirculationLoop * 1, 1) == 1,
                              ".C_Circ",
                              ".C_NoCirc"
                          ),
                          ifelse (
                              AuxFunctions::xl_AND (
                                  myCalcData$Index_SysW_G_ThermalSolar > 0,
                                  myCalcData$Index_SysW_G_ThermalSolar <= 3
                              ),
                              "_Sol",
                              ""
                          ),
                          ifelse (
                              myCalcData$Code_BuildingSizeClass_System == "SUH",
                              ".SUH.",
                              ".MUH."
                          ),
                          "11",
                          sep = ""
                      )
                  ),
                  sep = ""
              ),
              "-") # <ARX11>

  myCalcData$Indicator_Completeness_SysWD <-
      0.25 * AuxFunctions::xl_NOT (is.na (myCalcData$Indicator_Distribution_SysW)) +
      0.25 * AuxFunctions::xl_NOT (is.na (myCalcData$Indicator_Distribution_SysW_CirculationLoop)) +
      0.25 * AuxFunctions::xl_NOT (is.na (myCalcData$Indicator_Distribution_SysW_OutsideEnvelope)) +
      0.25 * AuxFunctions::xl_NOT (is.na (myCalcData$Indicator_Distribution_SysW_PoorlyInsulated)) # <ARY11>

  myCalcData$Indicator_Completeness_SysWS <-
      0.50 * AuxFunctions::xl_NOT (is.na (myCalcData$Indicator_Storage_SysW)) +
      0.25 * AuxFunctions::xl_NOT (is.na (myCalcData$Indicator_Storage_SysW_Immersion)) +
      0.25 * AuxFunctions::xl_NOT (is.na (myCalcData$Indicator_Storage_SysW_InsideEnvelope)) # <ARZ11>

  #View (ParTab_System_WS)
  myCalcData$q_s_w_Database <-
      Value_ParTab (ParTab_System_WS,
                    myCalcData$Code_SysW_S,
                    "q_s_w",
                    3,
                    "-",
                    0,
                    Value_Numeric_Error)

  myCalcData$q_s_w_h_Database <-
      Value_ParTab (ParTab_System_WS,
                    myCalcData$Code_SysW_S,
                    "q_s_w_h",
                    3,
                    "-",
                    0,
                    Value_Numeric_Error)

  myCalcData$q_d_w_Database <-
      Value_ParTab (ParTab_System_WD,
                    myCalcData$Code_SysW_D,
                    "q_d_w",
                    3,
                    "-",
                    0,
                    Value_Numeric_Error)

  myCalcData$q_d_w_h_Database <-
      Value_ParTab (ParTab_System_WD,
                    myCalcData$Code_SysW_D,
                    "q_d_w_h",
                    3,
                    "-",
                    0,
                    Value_Numeric_Error)

  myCalcData$q_del_w_aux_Database <-
      Value_ParTab (
          ParTab_System_WA,
          myCalcData$Code_SysW_Aux,
          "q_del_w_aux",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$q_s_w <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Indicator_SysHW_D_S_ExtraThickInsulation * 1 == 1,
          0.8,
          1
      ),
      1) * myCalcData$q_s_w_Database # <ASF11>

  myCalcData$q_s_w_h <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Indicator_SysHW_D_S_ExtraThickInsulation * 1 == 1,
          0.8,
          1
      ),
      1) * myCalcData$q_s_w_h_Database # <ASG11>

  myCalcData$q_d_w <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Indicator_SysHW_D_S_ExtraThickInsulation * 1 == 1,
          0.8,
          1
      ),
      1) * myCalcData$q_d_w_Database # <ASH11>

  myCalcData$q_d_w_h <-
      AuxFunctions::Replace_NA (ifelse (
          myCalcData$Indicator_SysHW_D_S_ExtraThickInsulation * 1 == 1,
          0.8,
          1
      ),
      1) * myCalcData$q_d_w_h_Database # <ASI11>

  myCalcData$q_del_w_aux <- myCalcData$q_del_w_aux_Database # <ASJ11>



  #####################################################################################X
  ## Manual input of supply system data (PENDING) -----







  # ++++++++ WORK IN PROGRESS | new script to be supplemented++++++++++
  # 2022-12-09






  #.------------------------------------------------------------------------------------


  #####################################################################################X
  ## Calc.Adapt - Adaptation of the calculation results -----

  myCalcData$Indicator_CalcAdapt_M_Active <- 1 #0 # <ASK11> # Open Task: This input should later be included in the building datasets
  myCalcData$Code_CalcAdapt_M_Manual <- "" # <ASL11> # Open Task: This input should later be included in the building datasets

  myCalcData$Code_CalcAdapt_M_Auto <-
      AuxFunctions::xl_CONCATENATE (
          myCalcData$Code_Country,
          ".M",
          ifelse (
              myCalcData$Fraction_SysH_G_Central >= 0.5,
              ifelse (myCalcData$Index_SysH_G_Heatpump * 1 == 1, ".02", ".01"),
              ifelse (myCalcData$Index_SysH_G_Dec_DirectElectric * 1 == 1, ".04", ".03")
          )
      ) # <ASM11>

  myCalcData$Code_CalcAdapt_M <-
      ifelse (
          myCalcData$Indicator_CalcAdapt_M_Active == 0,
          "NotApplied",
          ifelse (
              AuxFunctions::Replace_NA (nchar (myCalcData$Code_CalcAdapt_M_Manual) >= 4, FALSE),
              myCalcData$Code_CalcAdapt_M_Manual,
              myCalcData$Code_CalcAdapt_M_Auto
          )
      ) # <ASN11>

  myCalcData$Name_CalcAdapt_M <-
      String_ParTab (
          ParTab_CalcAdapt,
          myCalcData$Code_CalcAdapt_M,
          "Name_CalcAdapt",
          "-",
          "",
          Value_String_Error
      )

  myCalcData$Name_National_CalcAdapt_M <-
      String_ParTab (
          ParTab_CalcAdapt,
          myCalcData$Code_CalcAdapt_M,
          "Name_National_CalcAdapt",
          "-",
          "",
          Value_String_Error
      )

  myCalcData$Description_CalcAdapt_M <-
      String_ParTab (
          ParTab_CalcAdapt,
          myCalcData$Code_CalcAdapt_M,
          "Description_CalcAdapt",
          "-",
          "",
          Value_String_Error
      )

  myCalcData$Description_National_CalcAdapt_M <-
      String_ParTab (
          ParTab_CalcAdapt,
          myCalcData$Code_CalcAdapt_M,
          "Description_National_CalcAdapt",
          "-",
          "",
          Value_String_Error
      )

  myCalcData$Remark_CalcAdapt_M <-
      String_ParTab (
          ParTab_CalcAdapt,
          myCalcData$Code_CalcAdapt_M,
          "Remark_CalcAdapt",
          "-",
          "",
          Value_String_Error
      )

  myCalcData$Name_National_CalcAdapt_M <-
      String_ParTab (
          ParTab_CalcAdapt,
          myCalcData$Code_CalcAdapt_M,
          "Name_National_CalcAdapt",
          "-",
          "",
          Value_String_Error
      )

  myCalcData$Indicator_CalcAdapt_M_Accuracy <-
      String_ParTab (
          ParTab_CalcAdapt,
          myCalcData$Code_CalcAdapt_M,
          "Indicator_CalcAdapt_Accuracy",
          "-",
          0,
          Value_Numeric_Error
      )


  myCalcData$F_CalcAdapt_M_000 <-
      Value_ParTab (
          ParTab_CalcAdapt,
          myCalcData$Code_CalcAdapt_M,
          "F_CalcAdapt_000",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$F_CalcAdapt_M_100 <-
      Value_ParTab (
          ParTab_CalcAdapt,
          myCalcData$Code_CalcAdapt_M,
          "F_CalcAdapt_100",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$F_CalcAdapt_M_200 <-
      Value_ParTab (
          ParTab_CalcAdapt,
          myCalcData$Code_CalcAdapt_M,
          "F_CalcAdapt_200",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$F_CalcAdapt_M_300 <-
      Value_ParTab (
          ParTab_CalcAdapt,
          myCalcData$Code_CalcAdapt_M,
          "F_CalcAdapt_300",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$F_CalcAdapt_M_400 <-
      Value_ParTab (
          ParTab_CalcAdapt,
          myCalcData$Code_CalcAdapt_M,
          "F_CalcAdapt_400",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$F_CalcAdapt_M_500 <-
      Value_ParTab (
          ParTab_CalcAdapt,
          myCalcData$Code_CalcAdapt_M,
          "F_CalcAdapt_500",
          3,
          "-",
          0,
          Value_Numeric_Error
      )


  #.------------------------------------------------------------------------------------

  #####################################################################################X
  ## EC - Energy carriers -----


  ## EC SysH - Energy carriers heating

  myCalcData$Code_Specification_SysH_EC_1 <-
      ifelse (
          myCalcData$Code_SysH_EC_1 != "-",
          AuxFunctions::xl_CONCATENATE(
              myCalcData$Code_EC_Specification_Version,
              ".",
              myCalcData$Code_SysH_EC_1
          ),
          "-"
      ) # <ATA11>

  myCalcData$Code_Specification_SysH_EC_2 <-
      ifelse (
          myCalcData$Code_SysH_EC_2 != "-",
          AuxFunctions::xl_CONCATENATE(
              myCalcData$Code_EC_Specification_Version,
              ".",
              myCalcData$Code_SysH_EC_2
          ),
          "-"
      )

  myCalcData$Code_Specification_SysH_EC_3 <-
      ifelse (
          myCalcData$Code_SysH_EC_3 != "-",
          AuxFunctions::xl_CONCATENATE(
              myCalcData$Code_EC_Specification_Version,
              ".",
              myCalcData$Code_SysH_EC_3
          ),
          "-"
      )

  myCalcData$Code_Specification_SysH_EC_ElAux <-
      AuxFunctions::xl_CONCATENATE(myCalcData$Code_EC_Specification_Version, ".El") # <ATD11>

  myCalcData$f_p_Total_SysH_EC_1 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysH_EC_1,
          "EC_f_p_Total",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_p_Total_SysH_EC_2 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysH_EC_2,
          "EC_f_p_Total",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_p_Total_SysH_EC_3 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysH_EC_3,
          "EC_f_p_Total",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_p_Total_SysH_ElAux <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysH_EC_ElAux,
          "EC_f_p_Total",
          3,
          "-",
          0,
          Value_Numeric_Error
      )


  myCalcData$f_p_NonRen_SysH_EC_1 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysH_EC_1,
          "EC_f_p_NonRen",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_p_NonRen_SysH_EC_2 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysH_EC_2,
          "EC_f_p_NonRen",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_p_NonRen_SysH_EC_3 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysH_EC_3,
          "EC_f_p_NonRen",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_p_NonRen_SysH_ElAux <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysH_EC_ElAux,
          "EC_f_p_NonRen",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_CO2_SysH_EC_1 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysH_EC_1,
          "EC_f_CO2",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_CO2_SysH_EC_2 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysH_EC_2,
          "EC_f_CO2",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_CO2_SysH_EC_3 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysH_EC_3,
          "EC_f_CO2",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_CO2_SysH_ElAux <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysH_EC_ElAux,
          "EC_f_CO2",
          3,
          "-",
          0,
          Value_Numeric_Error
      )


  myCalcData$price_SysH_EC_1 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysH_EC_1,
          "EC_price",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$price_SysH_EC_2 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysH_EC_2,
          "EC_price",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$price_SysH_EC_3 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysH_EC_3,
          "EC_price",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$price_SysH_ElAux <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysH_EC_ElAux,
          "EC_price",
          3,
          "-",
          0,
          Value_Numeric_Error
      )


  ## EC SysW - Energy carriers DHW

  myCalcData$Code_Specification_SysW_EC_1 <-
      ifelse (
          myCalcData$Code_SysW_EC_1 != "-",
          AuxFunctions::xl_CONCATENATE(
              myCalcData$Code_EC_Specification_Version,
              ".",
              myCalcData$Code_SysW_EC_1
          ),
          "-"
      ) # <ATA11>

  myCalcData$Code_Specification_SysW_EC_2 <-
      ifelse (
          myCalcData$Code_SysW_EC_2 != "-",
          AuxFunctions::xl_CONCATENATE(
              myCalcData$Code_EC_Specification_Version,
              ".",
              myCalcData$Code_SysW_EC_2
          ),
          "-"
      )

  myCalcData$Code_Specification_SysW_EC_3 <-
      ifelse (
          myCalcData$Code_SysW_EC_3 != "-",
          AuxFunctions::xl_CONCATENATE(
              myCalcData$Code_EC_Specification_Version,
              ".",
              myCalcData$Code_SysW_EC_3
          ),
          "-"
      )

  myCalcData$Code_Specification_SysW_EC_ElAux <-
      AuxFunctions::xl_CONCATENATE(myCalcData$Code_EC_Specification_Version, ".El") # <ATD11>

  myCalcData$f_p_Total_SysW_EC_1 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysW_EC_1,
          "EC_f_p_Total",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_p_Total_SysW_EC_2 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysW_EC_2,
          "EC_f_p_Total",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_p_Total_SysW_EC_3 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysW_EC_3,
          "EC_f_p_Total",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_p_Total_SysW_ElAux <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysW_EC_ElAux,
          "EC_f_p_Total",
          3,
          "-",
          0,
          Value_Numeric_Error
      )


  myCalcData$f_p_NonRen_SysW_EC_1 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysW_EC_1,
          "EC_f_p_NonRen",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_p_NonRen_SysW_EC_2 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysW_EC_2,
          "EC_f_p_NonRen",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_p_NonRen_SysW_EC_3 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysW_EC_3,
          "EC_f_p_NonRen",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_p_NonRen_SysW_ElAux <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysW_EC_ElAux,
          "EC_f_p_NonRen",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_CO2_SysW_EC_1 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysW_EC_1,
          "EC_f_CO2",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_CO2_SysW_EC_2 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysW_EC_2,
          "EC_f_CO2",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_CO2_SysW_EC_3 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysW_EC_3,
          "EC_f_CO2",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$f_CO2_SysW_ElAux <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysW_EC_ElAux,
          "EC_f_CO2",
          3,
          "-",
          0,
          Value_Numeric_Error
      )


  myCalcData$price_SysW_EC_1 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysW_EC_1,
          "EC_price",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$price_SysW_EC_2 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysW_EC_2,
          "EC_price",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$price_SysW_EC_3 <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysW_EC_3,
          "EC_price",
          3,
          "-",
          0,
          Value_Numeric_Error
      )

  myCalcData$price_SysW_ElAux <-
      Value_ParTab (
          ParTab_System_EC,
          myCalcData$Code_Specification_SysW_EC_ElAux,
          "EC_price",
          3,
          "-",
          0,
          Value_Numeric_Error
      )



  #.------------------------------------------------------------------------------------


  ###################################################################################X
  #  4 OUTPUT  -----
  ###################################################################################X


  ###################################################################################X
  ##  . Return dataframe "myCalcData" including new calculation variables   ------


return (myCalcData)



} # End of function


## End of the function SuSysConf () -----
#####################################################################################X


#.------------------------------------------------------------------------------------

