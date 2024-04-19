#####################################################################################X
##
##    File name:        "UValEst.R"
##
##    Module of:        "EnergyProfile.R"
##
##    Task:             Estimation of U-values
##
##    Methods:          Energy Profile / envelope surface area estimation procedure
##                      (https://www.iwu.de/forschung/energie/kurzverfahren-energieprofil/)
##                      MOBASY handling of missing input
##                      (https://www.iwu.de/forschung/energie/mobasy/)
##
##    Projects:         TABULA / EPISCOPE / MOBASY
##
##    Authors:          Tobias Loga (t.loga@iwu.de)
##                      Jens Calisti
##                      IWU - Institut Wohnen und Umwelt, Darmstadt / Germany
##
##    Created:          08-07-2021
##    Last changes:     26-05-2023
##
#####################################################################################X
##
##    Content:          Function "UValEst ()"
##
##    Source:           R-Script derived from Excel workbooks / worksheets
##                      "[EnergyProfile.xlsm]Data.out.TABULA"
##                      "[tabula-calculator.xlsx]Calc.Set.Building"
##
#####################################################################################X

## Temporary change log
#  2023-04-12: Formula for Data_Calc_UValEst$R_PredefinedMeasure_Window_1 corrected


#####################################################################################X
##  Dependencies / requirements ------
#
#   Script "AuxFunctions.R"
#   Script "AuxConstants.R"



#####################################################################################X
## FUNCTION "UValEst ()" -----
#####################################################################################X



UValEst <- function (
    myInputData,
    myCalcData,
    ParTab_ConstrYearClass    ,
    ParTab_Infiltration       ,
    ParTab_UClassConstr       ,
    ParTab_InsulationDefault  ,
    ParTab_MeasurefDefault    ,
    ParTab_WindowTypePeriods  ,
    ParTab_ThermalBridging
) {

  cat ("UValEst ()", fill = TRUE)

  ###################################################################################X
  # 1  DESCRIPTION   -----
  ###################################################################################X

  # This function estimates the U-values of buildings
  # using information about construction year and later applied insulation measures
  # (part of the "energy profile indicators").
  # The method provides input data for the energy performance calculation.


  ###################################################################################X
  # 2  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X
  ## After debugging: Comment this section

  # myInputData <- myBuildingDataTables$Data_Input
  # myCalcData  <- myBuildingDataTables$Data_Calc
  #
  # ParTab_ConstrYearClass  <- TabulaTables$ParTab_ConstrYearClass
  # ParTab_Infiltration      <- TabulaTables$ParTab_Infiltration
  # ParTab_UClassConstr      <- TabulaTables$ParTab_UClassConstr
  # ParTab_InsulationDefault <- TabulaTables$ParTab_InsulationDefault
  # ParTab_MeasurefDefault   <- TabulaTables$ParTab_MeasurefDefault
  # ParTab_WindowTypePeriods <- TabulaTables$ParTab_WindowTypePeriods
  # ParTab_ThermalBridging   <- TabulaTables$ParTab_ThermalBridging


  ###################################################################################X
  # 3  FUNCTION SCRIPT   -----
  ###################################################################################X


  ###################################################################################X
  ##  Constants  -----
  ###################################################################################X

  Value_Numeric_Error             <- -99999
  Value_String_Error              <- "_ERROR_"

  Year_Building_NA                             <- 1963
  # Default value used if year of construction is unknown

  Year_Min_NA_Insulation_Original              <- 1995
  # Applies to cases where information about insulation is given,
  # but no information if this is original or applied during refurbishment;
  # lower boundary of the period


  ###################################################################################X
  ##  Preparation  -----
  ###################################################################################X





  ###################################################################################X
  ## Preparation of dataframe ----

  ## Assign values to the data frame used for all variables
  ## and auxiliary quantities "Data_Calc_UValEst"

  Data_Calc_UValEst <- as.data.frame (myInputData$ID_Dataset)
  colnames (Data_Calc_UValEst) <- "ID_Dataset"

  myCount_Dataset <-
    nrow (Data_Calc_UValEst)

  Data_Calc_UValEst$Code_U_Class_National <- myInputData$Code_U_Class_National # <AE11>
  Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance <- myInputData$Code_TypeInput_Envelope_ThermalTransmittance # <AJ11>

  Data_Calc_UValEst$Year1_Building <- AuxFunctions::Replace_NA (myInputData$Year_Building, Year_Building_NA)

  #Data_Calc_UValEst$Index_Class_Year_Building_Calc <- MATCH(Data_Calc_UValEst$Year1_Building, Data_Calc_UValEst$Year_Start_ConstrPeriod_01:Data_Calc_UValEst$Year_Start_ConstrPeriod_20,1) # <AM11>


  # iwu/tl: I did not manage to programme the following without loop, help is appreciated :)
  #i_Row <- 1
  for (i_Row in (1:myCount_Dataset)) {

      Data_Calc_UValEst$Index_Class_Year_Building_Calc [i_Row] <-
          max (
              which (
                  Data_Calc_UValEst$Year1_Building [i_Row] >=
                      ParTab_ConstrYearClass$ConstructionYearClass_FirstYear
              ),
              na.rm = TRUE
          )

      Data_Calc_UValEst$ConstructionYearClass_FirstYear [i_Row] <-
          ParTab_ConstrYearClass$ConstructionYearClass_FirstYear [
              Data_Calc_UValEst$Index_Class_Year_Building_Calc [i_Row]
              ]

      Data_Calc_UValEst$ConstructionYearClass_LastYear [i_Row] <-
          ParTab_ConstrYearClass$ConstructionYearClass_LastYear [
              Data_Calc_UValEst$Index_Class_Year_Building_Calc [i_Row]
          ]

  } # End loop

  #Data_Calc_UValEst$Index_Class_Year_Building_Calc
  #Data_Calc_UValEst$ConstructionYearClass_FirstYear
  #Data_Calc_UValEst$ConstructionYearClass_LastYear

  # Note: The following formulas are only needed to calculate Code_BuildingSize ("SUH" or "MUH")
  # only used for default value of insulation fraction if nothing about later insulation is known

  Data_Calc_UValEst$n_Block_Input <- myInputData$n_Block # <AN11>
  Data_Calc_UValEst$n_House_Input <- myInputData$n_House # <AO11>
  Data_Calc_UValEst$n_Storey_Input <- myInputData$n_Storey # <AP11>
  Data_Calc_UValEst$n_Dwelling <- myInputData$n_Dwelling # <AQ11>
  Data_Calc_UValEst$n_Block <- ifelse (is.na (Data_Calc_UValEst$n_Block_Input), 1.0, ifelse (Data_Calc_UValEst$n_Block_Input==0, 1.0, Data_Calc_UValEst$n_Block_Input)) # <AR11>
  Data_Calc_UValEst$n_House <- ifelse (is.na(Data_Calc_UValEst$n_House_Input), 1.0, ifelse(Data_Calc_UValEst$n_House_Input==0, 1.0, Data_Calc_UValEst$n_House_Input)) # <AS11>
  Data_Calc_UValEst$n_Apartment <- AuxFunctions::Replace_NA (Data_Calc_UValEst$n_Dwelling*1, ifelse (Data_Calc_UValEst$Code_BuildingPart_A_C_Floor_Intake == "Building", round (Data_Calc_UValEst$A_C_Floor_Intake/80,0),round(Data_Calc_UValEst$A_C_Floor_Intake*Data_Calc_UValEst$n_Storey_Input/80,0))) # <AT11>
  Data_Calc_UValEst$Code_BuildingSize <-  ifelse (Data_Calc_UValEst$n_Apartment <= 2, "SUH", "MUH") # <AU11>
  #. --------------------------------------------------------------------------------------------------


  ###################################################################################X
  ## Transform input to calculation variables (handling of missing input)  -----
  ###################################################################################X

  # Calculation / Code from "[EnergyProfile.xlsm]Data.Out.TABULA"


  ###################################################################################X
  ## . Opaque elements: Assign and convert input quantities for calculation  -----

  Data_Calc_UValEst$Indicator_Roof_Constr_Massive <-
      AuxFunctions::Replace_NA (AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Roof_Constr_Massive) * 1, 0) # <BE11>
  Data_Calc_UValEst$Indicator_Roof_Constr_Wood <-
      AuxFunctions::Replace_NA (AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Roof_Constr_Wood) * 1, 0) # <BF11>
  Data_Calc_UValEst$Indicator_UpperCeiling_Constr_Massive <-
      AuxFunctions::Replace_NA (AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Ceiling_Constr_Massive) * 1, 0) # <BG11>
  Data_Calc_UValEst$Indicator_UpperCeiling_Constr_Wood <-
      AuxFunctions::Replace_NA (AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Ceiling_Constr_Wood) * 1, 0) # <BH11>
  Data_Calc_UValEst$Indicator_Wall_Constr_Massive <-
      AuxFunctions::Replace_NA (AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Wall_Constr_Massive) * 1, 0) # <BI11>
  Data_Calc_UValEst$Indicator_Wall_Constr_Wood <-
      AuxFunctions::Replace_NA (AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Wall_Constr_Wood) * 1, 0) # <BJ11>
  Data_Calc_UValEst$Indicator_Floor_Constr_Massive <-
      AuxFunctions::Replace_NA (AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Floor_Constr_Massive) * 1, 0) # <BK11>
  Data_Calc_UValEst$Indicator_Floor_Constr_Wood <-
      AuxFunctions::Replace_NA (AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_Floor_Constr_Wood) * 1, 0) # <BL11>

  Data_Calc_UValEst$Code_InsulationType_Roof_Input <-
      myInputData$Code_InsulationType_Roof # <BM11>
  Data_Calc_UValEst$Code_InsulationType_Ceiling_Input <-
      myInputData$Code_InsulationType_Ceiling # <BN11>
  Data_Calc_UValEst$Code_InsulationType_Wall_Input <-
      myInputData$Code_InsulationType_Wall # <BO11>
  Data_Calc_UValEst$Code_InsulationType_Floor_Input <-
      myInputData$Code_InsulationType_Floor # <BP11>

  Data_Calc_UValEst$Code_InsulationType_Roof_1 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Code_InsulationType_Roof_Input, "_NA_") != "_NA_",
          Data_Calc_UValEst$Code_InsulationType_Roof_Input,
          ifelse (Data_Calc_UValEst$Year1_Building < Year_Min_NA_Insulation_Original, "Refurbish", "Original")
      ) # <BQ11>
  Data_Calc_UValEst$Code_InsulationType_Roof_2 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Code_InsulationType_Ceiling_Input, "_NA_") != "_NA_",
          Data_Calc_UValEst$Code_InsulationType_Ceiling_Input,
          ifelse (Data_Calc_UValEst$Year1_Building < Year_Min_NA_Insulation_Original, "Refurbish", "Original")
      ) # <BR11>
  Data_Calc_UValEst$Code_InsulationType_Wall_1 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Code_InsulationType_Wall_Input, "_NA_") != "_NA_",
          Data_Calc_UValEst$Code_InsulationType_Wall_Input,
          ifelse (Data_Calc_UValEst$Year1_Building < Year_Min_NA_Insulation_Original, "Refurbish", "Original")
      ) # <BS11>
  Data_Calc_UValEst$Code_InsulationType_Floor_1 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Code_InsulationType_Floor_Input, "_NA_") != "_NA_",
          Data_Calc_UValEst$Code_InsulationType_Floor_Input,
          ifelse (Data_Calc_UValEst$Year1_Building < Year_Min_NA_Insulation_Original, "Refurbish", "Original")
      ) # <BT11>
  Data_Calc_UValEst$Year_Refurbishment_Roof_Input <-
      myInputData$Year_Refurbishment_Roof # <BU11>
  Data_Calc_UValEst$Year_Refurbishment_Ceiling_Input <-
      myInputData$Year_Refurbishment_Ceiling # <BV11>
  Data_Calc_UValEst$Year_Refurbishment_Wall_Input <-
      myInputData$Year_Refurbishment_Wall # <BW11>
  Data_Calc_UValEst$Year_Refurbishment_Floor_Input <-
      myInputData$Year_Refurbishment_Floor # <BX11>


  Data_Calc_UValEst$Year_Insulation_Roof <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Year_Refurbishment_Roof_Input, 0) > 0,
          Data_Calc_UValEst$Year_Refurbishment_Roof_Input,
          ifelse (
              AuxFunctions::xl_OR (
                  Data_Calc_UValEst$Code_InsulationType_Roof_Input == "Original",
                  Data_Calc_UValEst$Year1_Building >= Year_Min_NA_Insulation_Original
              ),
              Data_Calc_UValEst$Year1_Building,
              Year_Min_NA_Insulation_Original
          )
      ) # <BY11>
  Data_Calc_UValEst$Year_Insulation_Ceiling <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Year_Refurbishment_Ceiling_Input, 0) > 0,
          Data_Calc_UValEst$Year_Refurbishment_Ceiling_Input,
          ifelse (
              AuxFunctions::xl_OR (
                  Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "Original",
                  Data_Calc_UValEst$Year1_Building >= Year_Min_NA_Insulation_Original
              ),
              Data_Calc_UValEst$Year1_Building,
              Year_Min_NA_Insulation_Original
          )
      ) # <BZ11>
  Data_Calc_UValEst$Year_Insulation_Wall <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Year_Refurbishment_Wall_Input, 0) > 0,
          Data_Calc_UValEst$Year_Refurbishment_Wall_Input,
          ifelse (
              AuxFunctions::xl_OR (
                  Data_Calc_UValEst$Code_InsulationType_Wall_Input == "Original",
                  Data_Calc_UValEst$Year1_Building >= Year_Min_NA_Insulation_Original
              ),
              Data_Calc_UValEst$Year1_Building,
              Year_Min_NA_Insulation_Original
          )
      ) # <CA11>
  Data_Calc_UValEst$Year_Insulation_Floor <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Year_Refurbishment_Floor_Input, 0) > 0,
          Data_Calc_UValEst$Year_Refurbishment_Floor_Input,
          ifelse (
              AuxFunctions::xl_OR (
                  Data_Calc_UValEst$Code_InsulationType_Floor_Input == "Original",
                  Data_Calc_UValEst$Year1_Building >= Year_Min_NA_Insulation_Original
              ),
              Data_Calc_UValEst$Year1_Building,
              Year_Min_NA_Insulation_Original
          )
      ) # <CB11>


  # iwu/tl: I did not manage to programme the following without loop, help is appreciated :)

  #i_Row <- 1
  for (i_Row in (1:myCount_Dataset)) {
      Data_Calc_UValEst$Index_Class_Year_Insulation_Roof [i_Row] <-
          max (
              which (
                  Data_Calc_UValEst$Year_Insulation_Roof [i_Row] >= ParTab_ConstrYearClass$ConstructionYearClass_FirstYear
              )
          )
  } # End loop
  #Data_Calc_UValEst$Index_Class_Year_Insulation_Roof

  for (i_Row in (1:myCount_Dataset)) {
      Data_Calc_UValEst$Index_Class_Year_Insulation_Ceiling [i_Row] <-
          max (
              which (
                  Data_Calc_UValEst$Year_Insulation_Ceiling [i_Row] >= ParTab_ConstrYearClass$ConstructionYearClass_FirstYear
              )
          )
  } # End loop
  #Data_Calc_UValEst$Index_Class_Year_Insulation_Ceiling

  for (i_Row in (1:myCount_Dataset)) {
      Data_Calc_UValEst$Index_Class_Year_Insulation_Wall [i_Row] <-
          max (
              which (
                  Data_Calc_UValEst$Year_Insulation_Wall [i_Row] >= ParTab_ConstrYearClass$ConstructionYearClass_FirstYear
              )
          )
  } # End loop
  #Data_Calc_UValEst$Index_Class_Year_Insulation_Wall

  for (i_Row in (1:myCount_Dataset)) {
      Data_Calc_UValEst$Index_Class_Year_Insulation_Floor [i_Row] <-
          max (
              which (
                  Data_Calc_UValEst$Year_Insulation_Floor [i_Row] >= ParTab_ConstrYearClass$ConstructionYearClass_FirstYear
              )
          )
  } # End loop
  #Data_Calc_UValEst$Index_Class_Year_Insulation_Floor


  Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1_Input <-
      myInputData$d_Insulation_Roof # <CG11>
  Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2_Input <-
      myInputData$d_Insulation_Ceiling # <CH11>
  Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1_Input <-
      myInputData$d_Insulation_Wall # <CI11>
  Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_2_Input <-
      Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1_Input # <CJ11>
  Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_3_Input <-
      Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_2_Input # <CK11>
  Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1_Input <-
      myInputData$d_Insulation_Floor # <CL11>
  Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_2_Input <-
      Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1_Input # <CM11>

  Data_Calc_UValEst$f_Measure_Roof_1_Input <-
      myInputData$f_Insulation_Roof # <CN11>
  Data_Calc_UValEst$f_Measure_Roof_2_Input <-
      myInputData$f_Insulation_Ceiling # <CO11>
  Data_Calc_UValEst$f_Measure_Wall_1_Input <-
      myInputData$f_Insulation_Wall # <CP11>
  Data_Calc_UValEst$f_Measure_Wall_2_Input <-
      Data_Calc_UValEst$f_Measure_Wall_1_Input # <CQ11>
  Data_Calc_UValEst$f_Measure_Wall_3_Input <-
      Data_Calc_UValEst$f_Measure_Wall_2_Input # <CR11>
  Data_Calc_UValEst$f_Measure_Floor_1_Input <-
      myInputData$f_Insulation_Floor # <CS11>
  Data_Calc_UValEst$f_Measure_Floor_2_Input <-
      Data_Calc_UValEst$f_Measure_Floor_1_Input # <CT11>


  Data_Calc_UValEst$f_Measure_Window_1_Input <-
      myInputData$f_Area_WindowType2 # <DM11>
  Data_Calc_UValEst$f_Measure_Window_2_Input <- 0 # <DN11>
  Data_Calc_UValEst$f_Measure_Door_1_Input <-
      Data_Calc_UValEst$f_Measure_Window_1_Input # <DO11>

  Data_Calc_UValEst$Code_MeasureType_Roof_1_Input <-
      myInputData$Code_MeasureType_Roof # <DP11>
  Data_Calc_UValEst$Code_MeasureType_Roof_2_Input <-
      myInputData$Code_MeasureType_Ceiling # <DQ11>
  Data_Calc_UValEst$Code_MeasureType_Wall_1_Input <-
      myInputData$Code_MeasureType_Wall # <DR11>
  Data_Calc_UValEst$Code_MeasureType_Floor_1_Input <-
      myInputData$Code_MeasureType_Floor # <DS11>

  Data_Calc_UValEst$Code_MeasureType_Roof_1 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Code_MeasureType_Roof_1_Input, "_NA_") != "_NA_",
          Data_Calc_UValEst$Code_MeasureType_Roof_1_Input,
          ifelse (
              Data_Calc_UValEst$Code_InsulationType_Roof_1 == "Original",
              "ReplaceInsulation",
              "Add"
          )
      ) # <DT11>
  Data_Calc_UValEst$Code_MeasureType_Roof_2 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Code_MeasureType_Roof_2_Input, "_NA_") != "_NA_",
          Data_Calc_UValEst$Code_MeasureType_Roof_2_Input,
          ifelse (
              Data_Calc_UValEst$Code_InsulationType_Roof_2 == "Original",
              "ReplaceInsulation",
              "Add"
          )
      ) # <DU11>
  Data_Calc_UValEst$Code_MeasureType_Wall_1 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Code_MeasureType_Wall_1_Input, "_NA_") != "_NA_",
          Data_Calc_UValEst$Code_MeasureType_Wall_1_Input,
          ifelse (
              Data_Calc_UValEst$Code_InsulationType_Wall_1 == "Original",
              "ReplaceInsulation",
              "Add"
          )
      ) # <DV11>
  Data_Calc_UValEst$Code_MeasureType_Floor_1 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Code_MeasureType_Floor_1_Input, "_NA_") != "_NA_",
          Data_Calc_UValEst$Code_MeasureType_Floor_1_Input,
          ifelse (
              Data_Calc_UValEst$Code_InsulationType_Floor_1 == "Original",
              "ReplaceInsulation",
              "Add"
          )
      ) # <DW11>

  Data_Calc_UValEst$Lambda_Insulation_Input_Roof <-
      myInputData$Lambda_Insulation_Roof # <DX11>
  Data_Calc_UValEst$Lambda_Insulation_Input_Ceiling <-
      myInputData$Lambda_Insulation_Ceiling # <DY11>
  Data_Calc_UValEst$Lambda_Insulation_Input_Wall <-
      myInputData$Lambda_Insulation_Wall # <DZ11>
  Data_Calc_UValEst$Lambda_Insulation_Input_Floor <-
      myInputData$Lambda_Insulation_Floor # <EA11>
  Data_Calc_UValEst$Indicator_InternalWallInsulation <-
      AuxFunctions::Reformat_InputData_Boolean(myInputData$Indicator_InternalWallInsulation) # <EB11>
  Data_Calc_UValEst$Code_Potential_ExternalWallInsulation <-
      myInputData$Code_Potential_ExternalWallInsulation # <EC11>




  ###################################################################################X
  ## . Windows: Assign and convert input quantities for calculation -----

  # 2023-10-27
  # Data_Calc_UValEst$f_Area_WindowType2 <-
  #     myInputData$f_Area_WindowType2 # <ED11>
  Data_Calc_UValEst$Code_NumberPanes_WindowType1 <-
      myInputData$Code_NumberPanes_WindowType1 # <EE11>
  Data_Calc_UValEst$Code_NumberPanes_WindowType2 <-
      myInputData$Code_NumberPanes_WindowType2 # <EF11>
  Data_Calc_UValEst$Indicator_LowE_WindowType1 <-
      AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_LowE_WindowType1) # <EG11>
  Data_Calc_UValEst$Indicator_LowE_WindowType2 <-
      AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_LowE_WindowType2) # <EH11>
  Data_Calc_UValEst$Code_Frame_WindowType1 <-
      myInputData$Code_Frame_WindowType1 # <EI11>
  Data_Calc_UValEst$Code_Frame_WindowType2 <-
      myInputData$Code_Frame_WindowType2 # <EJ11>
  Data_Calc_UValEst$Indicator_PassiveHouseWindow_WindowType1 <-
      AuxFunctions::Replace_NA (
          AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_PassiveHouseWindow_WindowType1),
          0
      ) # <EK11>
  Data_Calc_UValEst$Indicator_PassiveHouseWindow_WindowType2 <-
      AuxFunctions::Replace_NA (
          AuxFunctions::Reformat_InputData_Boolean (myInputData$Indicator_PassiveHouseWindow_WindowType2),
          0
      ) # <EL11>

  Data_Calc_UValEst$Year_Installation_WindowType1 <-
      myInputData$Year_Installation_WindowType1 # <EM11>
  Data_Calc_UValEst$Year_Installation_WindowType2 <-
      myInputData$Year_Installation_WindowType2 # <EN11>
  Data_Calc_UValEst$Year_Installation_WindowType1_Calc <-
      AuxFunctions::Replace_NA (Data_Calc_UValEst$Year_Installation_WindowType1,
                  Data_Calc_UValEst$Year1_Building) # <EO11>
  Data_Calc_UValEst$Year_Installation_WindowType2_Calc <-
      AuxFunctions::Replace_NA (Data_Calc_UValEst$Year_Installation_WindowType2,
                  Data_Calc_UValEst$Year1_Building) # <EP11>

  Data_Calc_UValEst$Code_U_Class_WindowType1_nPane <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Indicator_PassiveHouseWindow_WindowType1, 0)  == 1,
          "3",
          AuxFunctions::Replace_NA (pmin (3, as.numeric (
            gsub ("_", NA,   AuxFunctions::xl_LEFT (Data_Calc_UValEst$Code_NumberPanes_WindowType1, 1))
          )), "-")
      ) # <EQ11>
  Data_Calc_UValEst$Code_U_Class_WindowType2_nPane <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Indicator_PassiveHouseWindow_WindowType2, 0) * 1 == 1,
          3,
          AuxFunctions::Replace_NA (pmin (3, as.numeric (
            gsub ("_", NA,   AuxFunctions::xl_LEFT (Data_Calc_UValEst$Code_NumberPanes_WindowType2, 1))
          )), "-")
      ) # <ER11>



  Data_Calc_UValEst$Code_U_Class_WindowType1_LowE <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Indicator_PassiveHouseWindow_WindowType1, 0) * 1 == 1,
          "LowE",
          ifelse (
              AuxFunctions::xl_OR (
                  Data_Calc_UValEst$Code_NumberPanes_WindowType1 == "1p",
                  Data_Calc_UValEst$Code_NumberPanes_WindowType1 == "_NA_",
                  is.na (Data_Calc_UValEst$Indicator_LowE_WindowType1)
              ),
              "-",
              ifelse (
                  AuxFunctions::Replace_NA (Data_Calc_UValEst$Indicator_LowE_WindowType1, 0) == 1,
                  "LowE",
                  "NoCoating"
              )
          )
      ) # <ES11>
  Data_Calc_UValEst$Code_U_Class_WindowType2_LowE <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Indicator_PassiveHouseWindow_WindowType2, 0) * 1 == 1,
          "LowE",
          ifelse (
              AuxFunctions::xl_OR (
                  Data_Calc_UValEst$Code_NumberPanes_WindowType2 == "1p",
                  Data_Calc_UValEst$Code_NumberPanes_WindowType2 == "_NA_",
                  is.na (Data_Calc_UValEst$Indicator_LowE_WindowType2)
              ),
              "-",
              ifelse (
                  AuxFunctions::Replace_NA (Data_Calc_UValEst$Indicator_LowE_WindowType2, 0) == 1,
                  "LowE",
                  "NoCoating"
              )
          )
      ) # <ET11>



  ## 2024-04-19 query Code_NumberPanes_WindowTypeX == "_NA_" added at the beginning
  #
  # Data_Calc_UValEst$Code_U_Class_WindowType1_LowE <-
  #     ifelse (
  #         AuxFunctions::Replace_NA (Data_Calc_UValEst$Indicator_PassiveHouseWindow_WindowType1, 0) * 1 == 1,
  #         "LowE",
  #         ifelse (
  #             AuxFunctions::xl_OR (
  #                 Data_Calc_UValEst$Code_NumberPanes_WindowType1 == "1p",
  #                 is.na (Data_Calc_UValEst$Indicator_LowE_WindowType1)
  #             ),
  #             "-",
  #             ifelse (
  #                 AuxFunctions::Replace_NA (Data_Calc_UValEst$Indicator_LowE_WindowType1, 0) == 1,
  #                 "LowE",
  #                 "NoCoating"
  #             )
  #         )
  #     ) # <ES11>
  # Data_Calc_UValEst$Code_U_Class_WindowType2_LowE <-
  #     ifelse (
  #         AuxFunctions::Replace_NA (Data_Calc_UValEst$Indicator_PassiveHouseWindow_WindowType2, 0) * 1 == 1,
  #         "LowE",
  #         ifelse (
  #             AuxFunctions::xl_OR (
  #                 Data_Calc_UValEst$Code_NumberPanes_WindowType2 == "1p",
  #                 is.na (Data_Calc_UValEst$Indicator_LowE_WindowType2)
  #             ),
  #             "-",
  #             ifelse (
  #                 AuxFunctions::Replace_NA (Data_Calc_UValEst$Indicator_LowE_WindowType2, 0) == 1,
  #                 "LowE",
  #                 "NoCoating"
  #             )
  #         )
  #     ) # <ET11>

  Data_Calc_UValEst$Code_U_Class_WindowType1_GasFilling <- "-" # <EU11>
  Data_Calc_UValEst$Code_U_Class_WindowType2_GasFilling <- "-" # <EV11>
  Data_Calc_UValEst$Code_U_Class_WindowType1_FrameMaterial <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Indicator_PassiveHouseWindow_WindowType1, 0) * 1 == 1,
          "-",
          ifelse (
              Data_Calc_UValEst$Code_Frame_WindowType1 == "_NA_",
              "-",
              Data_Calc_UValEst$Code_Frame_WindowType1
          )
      ) # <EW11>
  Data_Calc_UValEst$Code_U_Class_WindowType2_FrameMaterial <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Indicator_PassiveHouseWindow_WindowType2, 0) * 1 == 1,
          "-",
          ifelse (
              Data_Calc_UValEst$Code_Frame_WindowType2 == "_NA_",
              "-",
              Data_Calc_UValEst$Code_Frame_WindowType2
          )
      ) # <EX11>

  Data_Calc_UValEst$Code_U_Class_WindowType1_Further <-
      ifelse (
          Data_Calc_UValEst$Indicator_PassiveHouseWindow_WindowType1 * 1 == 1,
          "Insulation",
          ifelse (
              AuxFunctions::xl_AND (
                  Data_Calc_UValEst$Code_U_Class_WindowType1_LowE == "LowEPlus",
                  Data_Calc_UValEst$Code_U_Class_WindowType1_FrameMaterial == "Metal"
              ),
              "ThermalBreak",
              "-"
          )
      ) # <EY11>
  Data_Calc_UValEst$Code_U_Class_WindowType2_Further <-
      ifelse (
          Data_Calc_UValEst$Indicator_PassiveHouseWindow_WindowType2 * 1 == 1,
          "Insulation",
          ifelse (
              AuxFunctions::xl_AND (
                  Data_Calc_UValEst$Code_U_Class_WindowType2_LowE == "LowEPlus",
                  Data_Calc_UValEst$Code_U_Class_WindowType2_FrameMaterial == "Metal"
              ),
              "ThermalBreak",
              "-"
          )
      ) # <EZ11>

  Data_Calc_UValEst$U_Window_Input_Type1 <-
      myInputData$U_w_Certified_WindowType1 # <FA11>
  Data_Calc_UValEst$U_Window_Input_Type2 <-
      myInputData$U_w_Certified_WindowType2 # <FB11>
  Data_Calc_UValEst$U_Door_Input_1 <- Data_Calc_UValEst$U_Window_Input_Type1 # <FC11>
  Data_Calc_UValEst$g_gl_n_Window_Input_1 <- 0.6 # <FD11>
  Data_Calc_UValEst$g_gl_n_Window_Input_2 <- 0.6 # <FE11>


  ###################################################################################X
  ## . Codes for thermal bridging and infiltration  -----

  Data_Calc_UValEst$Code_ThermalBridging_Refurbished_Input <-
      myInputData$Code_ThermalBridging # <FF11>

  Data_Calc_UValEst$Code_Infiltration_Actual_Input <-
      myInputData$Code_Infiltration # <FJ11>
  Data_Calc_UValEst$Code_Infiltration_Actual <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          "Manual input",
          ifelse (
              Data_Calc_UValEst$Code_Infiltration_Actual_Input == "_NA_",
              ifelse (
                  AuxFunctions::xl_AND (
                      Data_Calc_UValEst$n_Storey >= 3,
                      AuxFunctions::Replace_NA (Data_Calc_UValEst$Indicator_Wall_Constr_Wood, 0) == 0
                  ),
                  "Low",
                  "Medium"
              ),
              Data_Calc_UValEst$Code_Infiltration_Actual_Input
          )
      ) # <FK11>

  Data_Calc_UValEst$n_air_infiltration_Class <-
      Value_ParTab (ParTab_Infiltration, Data_Calc_UValEst$Code_Infiltration_Actual, "n_air_infiltration", 3, "Manual input", NA, Value_Numeric_Error)


  ###################################################################################X
  ## . Age classes of the building and of constructions  -----

  Data_Calc_UValEst$Code_ConstructionYearClass <-
      paste0 (
          myInputData$Code_Country,
          ".",
          Data_Calc_UValEst$Code_U_Class_National,
          ".",
          AuxFunctions::xl_TEXT(Data_Calc_UValEst$Index_Class_Year_Building_Calc, "00")
      ) # <FM11>

  Data_Calc_UValEst$U_Class_Roof_NA <-
      ParTab_UClassConstr [Data_Calc_UValEst$Code_ConstructionYearClass, "U_Class_Roof_Default"]
  Data_Calc_UValEst$U_Class_Roof_Massive <-
      ParTab_UClassConstr [Data_Calc_UValEst$Code_ConstructionYearClass, "U_Class_Roof_Massive"]
  Data_Calc_UValEst$U_Class_Roof_Wooden <-
      ParTab_UClassConstr [Data_Calc_UValEst$Code_ConstructionYearClass, "U_Class_Roof_Wooden"]

  Data_Calc_UValEst$U_Class_UpperCeiling_NA <-
      ParTab_UClassConstr [Data_Calc_UValEst$Code_ConstructionYearClass, "U_Class_UpperCeiling_Default"]
  Data_Calc_UValEst$U_Class_UpperCeiling_Massive <-
      ParTab_UClassConstr [Data_Calc_UValEst$Code_ConstructionYearClass, "U_Class_UpperCeiling_Massive"]
  Data_Calc_UValEst$U_Class_UpperCeiling_Wooden <-
      ParTab_UClassConstr [Data_Calc_UValEst$Code_ConstructionYearClass, "U_Class_UpperCeiling_Wooden"]

  Data_Calc_UValEst$U_Class_Wall_NA <-
      ParTab_UClassConstr [Data_Calc_UValEst$Code_ConstructionYearClass, "U_Class_Wall_Default"]
  Data_Calc_UValEst$U_Class_Wall_Massive <-
      ParTab_UClassConstr [Data_Calc_UValEst$Code_ConstructionYearClass, "U_Class_Wall_Massive"]
  Data_Calc_UValEst$U_Class_Wall_Wooden <-
      ParTab_UClassConstr [Data_Calc_UValEst$Code_ConstructionYearClass, "U_Class_Wall_Wooden"]

  Data_Calc_UValEst$U_Class_Floor_NA <-
      ParTab_UClassConstr [Data_Calc_UValEst$Code_ConstructionYearClass, "U_Class_Floor_Default"]
  Data_Calc_UValEst$U_Class_Floor_Massive <-
      ParTab_UClassConstr [Data_Calc_UValEst$Code_ConstructionYearClass, "U_Class_Floor_Massive"]
  Data_Calc_UValEst$U_Class_Floor_Wooden <-
      ParTab_UClassConstr [Data_Calc_UValEst$Code_ConstructionYearClass, "U_Class_Floor_Wooden"]


  ###################################################################################X
  ## . Insulation type (used for simplified assessment of non-honogenious constructions -----

  Data_Calc_UValEst$Code_Insulation_Default <- paste0 (myInputData$Code_Country, ".", Data_Calc_UValEst$Code_U_Class_National) # <GC11>

  Data_Calc_UValEst$Code_InstallationType_Insulation_Roof_Default <-
      AuxFunctions::Replace_NA (
          ifelse (
              AuxFunctions::xl_AND (
                  myInputData$Code_AtticCond == "-",
                  AuxFunctions::xl_NOT (Data_Calc_UValEst$Indicator_Roof_Constr_Wood == 1)
              ),
              "FlatRoofMassive",
              "AppliedBetweenRafters"
          ),
          "AppliedBetweenRafters"
      ) # <GD11>

  Data_Calc_UValEst$Code_InstallationType_Insulation_Ceiling_Default <-
      'TopCeiling' # <GE11>

  Data_Calc_UValEst$Code_InstallationType_Insulation_Wall_Default <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Indicator_InternalWallInsulation, 0) == 1,
          "Wall_Internal",
          "Wall_External"
      ) # <GF11>

  Data_Calc_UValEst$Code_InstallationType_Insulation_Floor_Default <-
      'BorderingCellar' # <GG11>



  ###################################################################################X
  ## . Period of applied measures (estimated when no input available) -----

  Data_Calc_UValEst$ID_Class_Year_Insulation_Roof  <-
      paste0 (
          Data_Calc_UValEst$Code_Insulation_Default,
          ".",
          formatC (
              Data_Calc_UValEst$Index_Class_Year_Insulation_Roof,
              width = 2,
              format = "d",
              flag = "0"
          )
      )

  Data_Calc_UValEst$ID_Class_Year_Insulation_Ceiling  <-
      paste0 (
          Data_Calc_UValEst$Code_Insulation_Default,
          ".",
          formatC (
              Data_Calc_UValEst$Index_Class_Year_Insulation_Ceiling,
              width = 2,
              format = "d",
              flag = "0"
          )
      )

  Data_Calc_UValEst$ID_Class_Year_Insulation_Wall  <-
      paste0 (
          Data_Calc_UValEst$Code_Insulation_Default,
          ".",
          formatC (
              Data_Calc_UValEst$Index_Class_Year_Insulation_Wall,
              width = 2,
              format = "d",
              flag = "0"
          )
      )

  Data_Calc_UValEst$ID_Class_Year_Insulation_Floor  <-
      paste0 (
          Data_Calc_UValEst$Code_Insulation_Default,
          ".",
          formatC (
              Data_Calc_UValEst$Index_Class_Year_Insulation_Floor,
              width = 2,
              format = "d",
              flag = "0"
          )
      )


  ###################################################################################X
  ## . Thermal conductivity of insulation measures when no input is available -----

  Data_Calc_UValEst$Lambda_Insulation_Roof_Default <- NA

  Data_Calc_UValEst$Lambda_Insulation_Roof_Default <-
             ifelse (
                 Data_Calc_UValEst$Code_InstallationType_Insulation_Roof_Default == "AppliedBetweenRafters",
                 Value_ParTab (
                     ParTab_InsulationDefault,
                     Data_Calc_UValEst$ID_Class_Year_Insulation_Roof,
                     "Lambda_Insulation_Default_AppliedBetweenRafters",
                     3,
                     "-",
                     0,
                     Value_Numeric_Error
                 ),
                 Data_Calc_UValEst$Lambda_Insulation_Roof_Default
             ) # <GT11>

  Data_Calc_UValEst$Lambda_Insulation_Roof_Default <-
      ifelse (
          Data_Calc_UValEst$Code_InstallationType_Insulation_Roof_Default == "FlatRoofMassive",
          Value_ParTab (
              ParTab_InsulationDefault,
              Data_Calc_UValEst$ID_Class_Year_Insulation_Roof,
              "Lambda_Insulation_Default_FlatRoofMassive",
              3,
              "-",
              0,
              Value_Numeric_Error
          ),
          Data_Calc_UValEst$Lambda_Insulation_Roof_Default
      ) # <GT11>


  Data_Calc_UValEst$Lambda_Insulation_Ceiling_Default <- NA

  Data_Calc_UValEst$Lambda_Insulation_Ceiling_Default <-
      ifelse (
          Data_Calc_UValEst$Code_InstallationType_Insulation_Ceiling_Default == "TopCeiling",
          Value_ParTab (
              ParTab_InsulationDefault,
              Data_Calc_UValEst$ID_Class_Year_Insulation_Ceiling,
              "Lambda_Insulation_Default_TopCeiling",
              3,
              "-",
              0,
              Value_Numeric_Error
          ),
          Data_Calc_UValEst$Lambda_Insulation_Ceiling_Default
      ) # <GU11>


  Data_Calc_UValEst$Lambda_Insulation_Wall_Default <- NA

  Data_Calc_UValEst$Lambda_Insulation_Wall_Default <-
      ifelse (
          Data_Calc_UValEst$Code_InstallationType_Insulation_Wall_Default == "Wall_External",
          Value_ParTab (
              ParTab_InsulationDefault,
              Data_Calc_UValEst$ID_Class_Year_Insulation_Wall,
              "Lambda_Insulation_Default_Wall_External",
              3,
              "-",
              0,
              Value_Numeric_Error
          ),
          Data_Calc_UValEst$Lambda_Insulation_Wall_Default
      ) # <GV11>

  Data_Calc_UValEst$Lambda_Insulation_Wall_Default <-
      ifelse (
          Data_Calc_UValEst$Code_InstallationType_Insulation_Wall_Default == "Wall_Internal",
          Value_ParTab (
              ParTab_InsulationDefault,
              Data_Calc_UValEst$ID_Class_Year_Insulation_Wall,
              "Lambda_Insulation_Default_Wall_Internal",
              3,
              "-",
              0,
              Value_Numeric_Error
          ),
          Data_Calc_UValEst$Lambda_Insulation_Wall_Default
      ) # <GV11>


  Data_Calc_UValEst$Lambda_Insulation_Floor_Default <- NA

  Data_Calc_UValEst$Lambda_Insulation_Floor_Default <-
      ifelse (
          Data_Calc_UValEst$Code_InstallationType_Insulation_Floor_Default == "BorderingCellar",
          Value_ParTab (
              ParTab_InsulationDefault,
              Data_Calc_UValEst$ID_Class_Year_Insulation_Floor,
              "Lambda_Insulation_Default_BorderingCellar",
              3,
              "-",
              0,
              Value_Numeric_Error
          ),
          Data_Calc_UValEst$Lambda_Insulation_Floor_Default
      ) # <GW11>

  Data_Calc_UValEst$Lambda_Insulation_Floor_Default <-
      ifelse (
          Data_Calc_UValEst$Code_InstallationType_Insulation_Floor_Default == "BorderingSoil",
          Value_ParTab (
              ParTab_InsulationDefault,
              Data_Calc_UValEst$ID_Class_Year_Insulation_Floor,
              "Lambda_Insulation_Default_BorderingSoil",
              3,
              "-",
              0,
              Value_Numeric_Error
          ),
          Data_Calc_UValEst$Lambda_Insulation_Floor_Default
      ) # <GW11>


  ###################################################################################X
  ## . Insulation thickness of measures when no input is available -----

  Data_Calc_UValEst$d_Insulation_Roof_Default <- NA

  Data_Calc_UValEst$d_Insulation_Roof_Default <-
      ifelse (
          Data_Calc_UValEst$Code_InstallationType_Insulation_Roof_Default == "AppliedBetweenRafters",
          Value_ParTab (
              ParTab_InsulationDefault,
              Data_Calc_UValEst$ID_Class_Year_Insulation_Roof,
              "d_Insulation_Default_AppliedBetweenRafters",
              3,
              "-",
              0,
              Value_Numeric_Error
          ),
          Data_Calc_UValEst$d_Insulation_Roof_Default
      ) # <GX11>

  Data_Calc_UValEst$d_Insulation_Roof_Default <-
      ifelse (
          Data_Calc_UValEst$Code_InstallationType_Insulation_Roof_Default == "FlatRoofMassive",
          Value_ParTab (
              ParTab_InsulationDefault,
              Data_Calc_UValEst$ID_Class_Year_Insulation_Roof,
              "d_Insulation_Default_FlatRoofMassive",
              3,
              "-",
              0,
              Value_Numeric_Error
          ),
          Data_Calc_UValEst$d_Insulation_Roof_Default
      ) # <GX11>

  Data_Calc_UValEst$d_Insulation_Roof_Default <- 1/100 * Data_Calc_UValEst$d_Insulation_Roof_Default


  Data_Calc_UValEst$d_Insulation_Ceiling_Default <- NA

  Data_Calc_UValEst$d_Insulation_Ceiling_Default <-
      ifelse (
          Data_Calc_UValEst$Code_InstallationType_Insulation_Ceiling_Default == "TopCeiling",
          Value_ParTab (
              ParTab_InsulationDefault,
              Data_Calc_UValEst$ID_Class_Year_Insulation_Ceiling,
              "d_Insulation_Default_TopCeiling",
              3,
              "-",
              0,
              Value_Numeric_Error
          ),
          Data_Calc_UValEst$d_Insulation_Ceiling_Default
      ) # <GY11>

  Data_Calc_UValEst$d_Insulation_Ceiling_Default <- 1/100 * Data_Calc_UValEst$d_Insulation_Ceiling_Default


  Data_Calc_UValEst$d_Insulation_Wall_Default <- NA

  Data_Calc_UValEst$d_Insulation_Wall_Default <-
      ifelse (
          Data_Calc_UValEst$Code_InstallationType_Insulation_Wall_Default == "Wall_External",
          Value_ParTab (
              ParTab_InsulationDefault,
              Data_Calc_UValEst$ID_Class_Year_Insulation_Wall,
              "d_Insulation_Default_Wall_External",
              3,
              "-",
              0,
              Value_Numeric_Error
          ),
          Data_Calc_UValEst$d_Insulation_Wall_Default
      ) # <GZ11>

  Data_Calc_UValEst$d_Insulation_Wall_Default <-
      ifelse (
          Data_Calc_UValEst$Code_InstallationType_Insulation_Wall_Default == "Wall_Internal",
          Value_ParTab (
              ParTab_InsulationDefault,
              Data_Calc_UValEst$ID_Class_Year_Insulation_Wall,
              "d_Insulation_Default_Wall_Internal",
              3,
              "-",
              0,
              Value_Numeric_Error
          ),
          Data_Calc_UValEst$d_Insulation_Wall_Default
      ) # <GZ11>

  Data_Calc_UValEst$d_Insulation_Wall_Default <- 1/100 * Data_Calc_UValEst$d_Insulation_Wall_Default


  Data_Calc_UValEst$d_Insulation_Floor_Default <- NA

  Data_Calc_UValEst$d_Insulation_Floor_Default <-
      ifelse (
          Data_Calc_UValEst$Code_InstallationType_Insulation_Floor_Default == "BorderingCellar",
          Value_ParTab (
              ParTab_InsulationDefault,
              Data_Calc_UValEst$ID_Class_Year_Insulation_Floor,
              "d_Insulation_Default_BorderingCellar",
              3,
              "-",
              0,
              Value_Numeric_Error
          ),
          Data_Calc_UValEst$d_Insulation_Floor_Default
      ) # <HA11>

  Data_Calc_UValEst$d_Insulation_Floor_Default <-
      ifelse (
          Data_Calc_UValEst$Code_InstallationType_Insulation_Floor_Default == "BorderingSoil",
          Value_ParTab (
              ParTab_InsulationDefault,
              Data_Calc_UValEst$ID_Class_Year_Insulation_Floor,
              "d_Insulation_Default_BorderingSoil",
              3,
              "-",
              0,
              Value_Numeric_Error
          ),
          Data_Calc_UValEst$d_Insulation_Floor_Default
      ) # <HA11>

  Data_Calc_UValEst$d_Insulation_Floor_Default <- 1/100 * Data_Calc_UValEst$d_Insulation_Floor_Default


  ###################################################################################X
  ## . Area fractions of measures when no input is available / case: refurbishment was carried out -----

  Data_Calc_UValEst$f_Insulation_Roof_Default_Refurbish <-
      Value_ParTab(
          ParTab_MeasurefDefault,
          paste0 (
              Data_Calc_UValEst$Code_Insulation_Default,
              ".",
              "Gen.Refurbished",
              ".",
              AuxFunctions::xl_TEXT (Data_Calc_UValEst$Index_Class_Year_Insulation_Roof, "00")
          ),
          "f_Measure_Default_Roof",
          3
      )

  Data_Calc_UValEst$f_Insulation_Ceiling_Default_Refurbish <-
      Value_ParTab(
          ParTab_MeasurefDefault,
          paste0 (
              Data_Calc_UValEst$Code_Insulation_Default,
              ".",
              "Gen.Refurbished",
              ".",
              AuxFunctions::xl_TEXT (Data_Calc_UValEst$Index_Class_Year_Insulation_Ceiling, "00")
          ),
          "f_Measure_Default_TopCeiling",
          3
      )

  Data_Calc_UValEst$f_Insulation_Wall_Default_Refurbish <-
      Value_ParTab(
          ParTab_MeasurefDefault,
          paste0 (
              Data_Calc_UValEst$Code_Insulation_Default,
              ".",
              "Gen.Refurbished",
              ".",
              AuxFunctions::xl_TEXT (Data_Calc_UValEst$Index_Class_Year_Insulation_Wall, "00")
          ),
          "f_Measure_Default_Wall",
          3
      )

  Data_Calc_UValEst$f_Insulation_Floor_Default_Refurbish <-
      Value_ParTab(
          ParTab_MeasurefDefault,
          paste0 (
              Data_Calc_UValEst$Code_Insulation_Default,
              ".",
              "Gen.Refurbished",
              ".",
              AuxFunctions::xl_TEXT (Data_Calc_UValEst$Index_Class_Year_Insulation_Floor, "00")
          ),
          "f_Measure_Default_Floor",
          3
      )


  ###################################################################################X
  ## . Area fractions of measures when no input is available / case: no information about refurbishment -----

  # An average state of the building stock is considered

  Data_Calc_UValEst$f_Insulation_Roof_Default_NA <-
      Value_ParTab (
          ParTab_MeasurefDefault,
          paste0 (
              Data_Calc_UValEst$Code_Insulation_Default,
              ".",
              Data_Calc_UValEst$Code_BuildingSize,
              ".NA.",
              AuxFunctions::xl_TEXT (Data_Calc_UValEst$Index_Class_Year_Building_Calc, "00")
          ),
          "f_Measure_Default_Roof",
          3
      )

  Data_Calc_UValEst$f_Insulation_Ceiling_Default_NA <-
      Value_ParTab (
          ParTab_MeasurefDefault,
          paste0 (
              Data_Calc_UValEst$Code_Insulation_Default,
              ".",
              Data_Calc_UValEst$Code_BuildingSize,
              ".NA.",
              AuxFunctions::xl_TEXT (Data_Calc_UValEst$Index_Class_Year_Building_Calc, "00")
          ),
          "f_Measure_Default_TopCeiling",
          3
      )

  Data_Calc_UValEst$f_Insulation_Wall_Default_NA <-
      Value_ParTab (
          ParTab_MeasurefDefault,
          paste0 (
              Data_Calc_UValEst$Code_Insulation_Default,
              ".",
              Data_Calc_UValEst$Code_BuildingSize,
              ".NA.",
              AuxFunctions::xl_TEXT (Data_Calc_UValEst$Index_Class_Year_Building_Calc, "00")
          ),
          "f_Measure_Default_Wall",
          3
      )

  Data_Calc_UValEst$f_Insulation_Floor_Default_NA <-
      Value_ParTab (
          ParTab_MeasurefDefault,
          paste0 (
              Data_Calc_UValEst$Code_Insulation_Default,
              ".",
              Data_Calc_UValEst$Code_BuildingSize,
              ".NA.",
              AuxFunctions::xl_TEXT (Data_Calc_UValEst$Index_Class_Year_Building_Calc, "00")
          ),
          "f_Measure_Default_Floor",
          3
      ) # <HL11>


  Data_Calc_UValEst$Lambda_Insulation_Roof_Calc <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Lambda_Insulation_Input_Roof, 0) > 0,
          Data_Calc_UValEst$Lambda_Insulation_Input_Roof,
          Data_Calc_UValEst$Lambda_Insulation_Roof_Default
      ) # <HM11>
  Data_Calc_UValEst$Lambda_Insulation_Ceiling_Calc <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Lambda_Insulation_Input_Ceiling, 0) > 0,
          Data_Calc_UValEst$Lambda_Insulation_Input_Ceiling,
          Data_Calc_UValEst$Lambda_Insulation_Ceiling_Default
      ) # <HN11>
  Data_Calc_UValEst$Lambda_Insulation_Wall_Calc <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Lambda_Insulation_Input_Wall, 0) > 0,
          Data_Calc_UValEst$Lambda_Insulation_Input_Wall,
          Data_Calc_UValEst$Lambda_Insulation_Wall_Default
      ) # <HO11>
  Data_Calc_UValEst$Lambda_Insulation_Floor_Calc <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$Lambda_Insulation_Input_Floor, 0) > 0,
          Data_Calc_UValEst$Lambda_Insulation_Input_Floor,
          Data_Calc_UValEst$Lambda_Insulation_Floor_Default
      ) # <HP11>


  ###################################################################################X
  ## . Insulation thickness of measures -----

  Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1 <-
    ifelse (Data_Calc_UValEst$Code_InsulationType_Roof_Input == "None",
            0,
            ifelse (
              AuxFunctions::Replace_NA (
                Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1_Input,
                0
              ) !=0,
              Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1_Input / 100,
              ifelse (
                AuxFunctions::xl_OR (
                  Data_Calc_UValEst$Code_InsulationType_Roof_Input == "Refurbish",
                  Data_Calc_UValEst$Code_InsulationType_Roof_Input == "_NA_"
                ),
                Data_Calc_UValEst$d_Insulation_Roof_Default,
                0
              )
            )
          ) # <HQ11>

  Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2 <-
    ifelse (Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "None",
            0,
            ifelse (
              AuxFunctions::Replace_NA (
                Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2_Input,
                0
              ) !=0,
              Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2_Input / 100,
              ifelse (
                AuxFunctions::xl_OR (
                  Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "Refurbish",
                  Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "_NA_"
                ),
                Data_Calc_UValEst$d_Insulation_Ceiling_Default,
                0
              )
            )
          )# <HR11>

  Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1 <-
    ifelse (Data_Calc_UValEst$Code_InsulationType_Wall_Input == "None",
            0,
            ifelse (
              AuxFunctions::Replace_NA (
                Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1_Input,
                0
              ) != 0,
              Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1_Input / 100,
              ifelse (
                AuxFunctions::xl_OR (
                  Data_Calc_UValEst$Code_InsulationType_Wall_Input == "Refurbish",
                  Data_Calc_UValEst$Code_InsulationType_Wall_Input == "_NA_"
                ),
                Data_Calc_UValEst$d_Insulation_Wall_Default,
                0
              )
            )
          ) # <HS11>

  Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_2 <-
    Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1 # <HT11>

  Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_3 <-
    Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_2 # <HU11>

  Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1 <-
    ifelse (Data_Calc_UValEst$Code_InsulationType_Floor_Input == "None",
            0,
            ifelse (
              AuxFunctions::Replace_NA (
                Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1_Input,
                0
              ) != 0,
              Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1_Input / 100,
              ifelse (
                AuxFunctions::xl_OR (
                  Data_Calc_UValEst$Code_InsulationType_Floor_Input == "Refurbish",
                  Data_Calc_UValEst$Code_InsulationType_Floor_Input == "_NA_"
                ),
                Data_Calc_UValEst$d_Insulation_Floor_Default,
                0
              )
            )
          ) # <HV11>

  Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_2 <-
    Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1 # <HW11>



  # 2024-04-19 Above script changed to set d_insulation always to 0 if insulation type == "None"
  # Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1 <-
  #   ifelse (
  #     AuxFunctions::Replace_NA (
  #       Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1_Input,
  #       0
  #     ) !=0,
  #     Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1_Input / 100,
  #     ifelse (
  #       AuxFunctions::xl_OR (
  #         Data_Calc_UValEst$Code_InsulationType_Roof_Input == "Refurbish",
  #         Data_Calc_UValEst$Code_InsulationType_Roof_Input == "_NA_"
  #       ),
  #       Data_Calc_UValEst$d_Insulation_Roof_Default,
  #       0
  #     )
  #   ) # <HQ11>
  # Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2 <-
  #   ifelse (
  #     AuxFunctions::Replace_NA (
  #       Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2_Input,
  #       0
  #     ) !=0,
  #     Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2_Input / 100,
  #     ifelse (
  #       AuxFunctions::xl_OR (
  #         Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "Refurbish",
  #         Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "_NA_"
  #       ),
  #       Data_Calc_UValEst$d_Insulation_Ceiling_Default,
  #       0
  #     )
  #   ) # <HR11>
  # Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1 <-
  #   ifelse (
  #     AuxFunctions::Replace_NA (
  #       Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1_Input,
  #       0
  #     ) != 0,
  #     Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1_Input / 100,
  #     ifelse (
  #       AuxFunctions::xl_OR (
  #         Data_Calc_UValEst$Code_InsulationType_Wall_Input == "Refurbish",
  #         Data_Calc_UValEst$Code_InsulationType_Wall_Input == "_NA_"
  #       ),
  #       Data_Calc_UValEst$d_Insulation_Wall_Default,
  #       0
  #     )
  #   ) # <HS11>
  # Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_2 <-
  #   Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1 # <HT11>
  # Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_3 <-
  #   Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_2 # <HU11>
  # Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1 <-
  #   ifelse (
  #     AuxFunctions::Replace_NA (
  #       Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1_Input,
  #       0
  #     ) != 0,
  #     Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1_Input / 100,
  #     ifelse (
  #       AuxFunctions::xl_OR (
  #         Data_Calc_UValEst$Code_InsulationType_Floor_Input == "Refurbish",
  #         Data_Calc_UValEst$Code_InsulationType_Floor_Input == "_NA_"
  #       ),
  #       Data_Calc_UValEst$d_Insulation_Floor_Default,
  #       0
  #     )
  #   ) # <HV11>
  # Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_2 <-
  #   Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1 # <HW11>
  #



  # 2023-09-29 Above Script changed to interprete 0 as NA in specific cases
  # because NA input is not yet possible in the webtool.
  #
  # Script before changes:
  #
  # Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1 <-
  #     AuxFunctions::Replace_NA (
  #         Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1_Input / 100,
  #         ifelse (
  #             AuxFunctions::xl_OR (
  #                 Data_Calc_UValEst$Code_InsulationType_Roof_Input == "Refurbish",
  #                 Data_Calc_UValEst$Code_InsulationType_Roof_Input == "_NA_"
  #             ),
  #             Data_Calc_UValEst$d_Insulation_Roof_Default,
  #             0
  #         )
  #     ) # <HQ11>
  # Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2 <-
  #     AuxFunctions::Replace_NA (
  #         Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2_Input / 100,
  #         ifelse (
  #             AuxFunctions::xl_OR (
  #                 Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "Refurbish",
  #                 Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "_NA_"
  #             ),
  #             Data_Calc_UValEst$d_Insulation_Ceiling_Default,
  #             0
  #         )
  #     ) # <HR11>
  # Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1 <-
  #     AuxFunctions::Replace_NA (
  #         Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1_Input / 100,
  #         ifelse (
  #             AuxFunctions::xl_OR (
  #                 Data_Calc_UValEst$Code_InsulationType_Wall_Input == "Refurbish",
  #                 Data_Calc_UValEst$Code_InsulationType_Wall_Input == "_NA_"
  #             ),
  #             Data_Calc_UValEst$d_Insulation_Wall_Default,
  #             0
  #         )
  #     ) # <HS11>
  # Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_2 <-
  #     Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1 # <HT11>
  # Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_3 <-
  #     Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_2 # <HU11>
  # Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1 <-
  #     AuxFunctions::Replace_NA (
  #         Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1_Input / 100,
  #         ifelse (
  #             AuxFunctions::xl_OR (
  #                 Data_Calc_UValEst$Code_InsulationType_Floor_Input == "Refurbish",
  #                 Data_Calc_UValEst$Code_InsulationType_Floor_Input == "_NA_"
  #             ),
  #             Data_Calc_UValEst$d_Insulation_Floor_Default,
  #             0
  #         )
  #     ) # <HV11>
  # Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_2 <-
  #     Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1 # <HW11>


  ###################################################################################X
  ## . Area fraction of applied measures -----

  Data_Calc_UValEst$f_Measure_Roof_1 <-
    ifelse (
      AuxFunctions::Replace_NA (
        Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance,
        "_NA_"
      ) == "Manual",
      0,
      ifelse (
        Data_Calc_UValEst$Code_InsulationType_Roof_Input == "None",
        0,
        ifelse (
        AuxFunctions::Replace_NA (
          Data_Calc_UValEst$f_Measure_Roof_1_Input,
          0
        ) != 0,
        Data_Calc_UValEst$f_Measure_Roof_1_Input * 1,
          ifelse (
            Data_Calc_UValEst$Code_InsulationType_Roof_Input == "Refurbish",
            Data_Calc_UValEst$f_Insulation_Roof_Default_Refurbish,
            ifelse (
              Data_Calc_UValEst$Code_InsulationType_Roof_Input == "Original",
              ifelse (
                AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1_Input, 0) / 100 >
                  0.01,
                1,
                0
              ),
              ifelse (
                AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1_Input, 0) / 100 >
                  0.01,
                Data_Calc_UValEst$f_Insulation_Roof_Default_Refurbish,
                Data_Calc_UValEst$f_Insulation_Roof_Default_NA
              )
            )
          )
        )
      )
    ) # <HX13>

  Data_Calc_UValEst$f_Measure_Roof_2 <-
    ifelse (
      AuxFunctions::Replace_NA (
        Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance,
        "_NA_"
      ) == "Manual",
      0,
      ifelse (
        Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "None",
        0,
        ifelse (
        AuxFunctions::Replace_NA (
          Data_Calc_UValEst$f_Measure_Roof_2_Input,
          0
        ) != 0,
        Data_Calc_UValEst$f_Measure_Roof_2_Input * 1,
          ifelse (
            Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "Refurbish",
            Data_Calc_UValEst$f_Insulation_Ceiling_Default_Refurbish,
            ifelse (
              Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "Original",
              ifelse (
                AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2_Input, 0) / 100 >
                  0.01,
                1,
                0
              ),
              ifelse (
                AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2_Input, 0) / 100 >
                  0.01,
                Data_Calc_UValEst$f_Insulation_Ceiling_Default_Refurbish,
                Data_Calc_UValEst$f_Insulation_Ceiling_Default_NA
              )
            )
          )
        )
      )
    ) # <HY13>

  Data_Calc_UValEst$f_Measure_Wall_1 <-
    ifelse (
      AuxFunctions::Replace_NA (
        Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance,
        "_NA_"
      ) == "Manual",
      0,
      ifelse (
        Data_Calc_UValEst$Code_InsulationType_Wall_Input == "None",
        0,
        ifelse (
        AuxFunctions::Replace_NA (
          Data_Calc_UValEst$f_Measure_Wall_1_Input,
          0
        ) != 0,
        Data_Calc_UValEst$f_Measure_Wall_1_Input * 1,
          ifelse (
            Data_Calc_UValEst$Code_InsulationType_Wall_Input == "Refurbish",
            Data_Calc_UValEst$f_Insulation_Wall_Default_Refurbish,
            ifelse (
              Data_Calc_UValEst$Code_InsulationType_Wall_Input == "Original",
              ifelse (
                AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1_Input, 0) / 100 >
                  0.01,
                1,
                0
              ),
              ifelse (
                AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1_Input, 0) / 100 >
                  0.01,
                Data_Calc_UValEst$f_Insulation_Wall_Default_Refurbish,
                Data_Calc_UValEst$f_Insulation_Wall_Default_NA
              )
            )
          )
        )
      )
    ) # <HZ13>

  Data_Calc_UValEst$f_Measure_Wall_2 <- Data_Calc_UValEst$f_Measure_Wall_1 # <IA13>

  Data_Calc_UValEst$f_Measure_Wall_3 <- Data_Calc_UValEst$f_Measure_Wall_2 # <IB13>

  Data_Calc_UValEst$f_Measure_Floor_1 <-
    ifelse (
      AuxFunctions::Replace_NA (
        Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance,
        "_NA_"
      ) == "Manual",
      0,
      ifelse (
        Data_Calc_UValEst$Code_InsulationType_Floor_Input == "None",
        0,
        ifelse (
        AuxFunctions::Replace_NA (
          Data_Calc_UValEst$f_Measure_Floor_1_Input,
          0
        ) != 0,
        Data_Calc_UValEst$f_Measure_Floor_1_Input * 1,
          ifelse (
            Data_Calc_UValEst$Code_InsulationType_Floor_Input == "Refurbish",
            Data_Calc_UValEst$f_Insulation_Floor_Default_Refurbish,
            ifelse (
              Data_Calc_UValEst$Code_InsulationType_Floor_Input == "Original",
              ifelse (
                AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1_Input, 0) / 100 >
                  0.01,
                1,
                0
              ),
              ifelse (
                AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1_Input, 0) / 100 >
                  0.01,
                Data_Calc_UValEst$f_Insulation_Floor_Default_Refurbish,
                Data_Calc_UValEst$f_Insulation_Floor_Default_NA
              )
            )
          )
        )
      )
    ) # <IC13>

  Data_Calc_UValEst$f_Measure_Floor_2 <- Data_Calc_UValEst$f_Measure_Floor_1 # <ID13>


  # 2024-04-19 Above script changed to set f_insulation always to 0 if insulation type == "None"
  # Data_Calc_UValEst$f_Measure_Roof_1 <-
  #   ifelse (
  #     AuxFunctions::Replace_NA (
  #       Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance,
  #       "_NA_"
  #     ) == "Manual",
  #     0,
  #     ifelse (
  #       AuxFunctions::Replace_NA (
  #         Data_Calc_UValEst$f_Measure_Roof_1_Input,
  #         0
  #       ) != 0,
  #       Data_Calc_UValEst$f_Measure_Roof_1_Input * 1,
  #       ifelse (
  #         Data_Calc_UValEst$Code_InsulationType_Roof_Input == "None",
  #         0,
  #         ifelse (
  #           Data_Calc_UValEst$Code_InsulationType_Roof_Input == "Refurbish",
  #           Data_Calc_UValEst$f_Insulation_Roof_Default_Refurbish,
  #           ifelse (
  #             Data_Calc_UValEst$Code_InsulationType_Roof_Input == "Original",
  #             ifelse (
  #               AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1_Input, 0) / 100 >
  #                 0.01,
  #               1,
  #               0
  #             ),
  #             ifelse (
  #               AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1_Input, 0) / 100 >
  #                 0.01,
  #               Data_Calc_UValEst$f_Insulation_Roof_Default_Refurbish,
  #               Data_Calc_UValEst$f_Insulation_Roof_Default_NA
  #             )
  #           )
  #         )
  #       )
  #     )
  #   ) # <HX13>
  #
  # Data_Calc_UValEst$f_Measure_Roof_2 <-
  #   ifelse (
  #     AuxFunctions::Replace_NA (
  #       Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance,
  #       "_NA_"
  #     ) == "Manual",
  #     0,
  #     ifelse (
  #       AuxFunctions::Replace_NA (
  #         Data_Calc_UValEst$f_Measure_Roof_2_Input,
  #         0
  #       ) != 0,
  #       Data_Calc_UValEst$f_Measure_Roof_2_Input * 1,
  #       ifelse (
  #         Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "None",
  #         0,
  #         ifelse (
  #           Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "Refurbish",
  #           Data_Calc_UValEst$f_Insulation_Ceiling_Default_Refurbish,
  #           ifelse (
  #             Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "Original",
  #             ifelse (
  #               AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2_Input, 0) / 100 >
  #                 0.01,
  #               1,
  #               0
  #             ),
  #             ifelse (
  #               AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2_Input, 0) / 100 >
  #                 0.01,
  #               Data_Calc_UValEst$f_Insulation_Ceiling_Default_Refurbish,
  #               Data_Calc_UValEst$f_Insulation_Ceiling_Default_NA
  #             )
  #           )
  #         )
  #       )
  #     )
  #   ) # <HY13>
  #
  # Data_Calc_UValEst$f_Measure_Wall_1 <-
  #   ifelse (
  #     AuxFunctions::Replace_NA (
  #       Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance,
  #       "_NA_"
  #     ) == "Manual",
  #     0,
  #     ifelse (
  #       AuxFunctions::Replace_NA (
  #         Data_Calc_UValEst$f_Measure_Wall_1_Input,
  #         0
  #       ) != 0,
  #       Data_Calc_UValEst$f_Measure_Wall_1_Input * 1,
  #       ifelse (
  #         Data_Calc_UValEst$Code_InsulationType_Wall_Input == "None",
  #         0,
  #         ifelse (
  #           Data_Calc_UValEst$Code_InsulationType_Wall_Input == "Refurbish",
  #           Data_Calc_UValEst$f_Insulation_Wall_Default_Refurbish,
  #           ifelse (
  #             Data_Calc_UValEst$Code_InsulationType_Wall_Input == "Original",
  #             ifelse (
  #               AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1_Input, 0) / 100 >
  #                 0.01,
  #               1,
  #               0
  #             ),
  #             ifelse (
  #               AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1_Input, 0) / 100 >
  #                 0.01,
  #               Data_Calc_UValEst$f_Insulation_Wall_Default_Refurbish,
  #               Data_Calc_UValEst$f_Insulation_Wall_Default_NA
  #             )
  #           )
  #         )
  #       )
  #     )
  #   ) # <HZ13>
  #
  # Data_Calc_UValEst$f_Measure_Wall_2 <- Data_Calc_UValEst$f_Measure_Wall_1 # <IA13>
  #
  # Data_Calc_UValEst$f_Measure_Wall_3 <- Data_Calc_UValEst$f_Measure_Wall_2 # <IB13>
  #
  # Data_Calc_UValEst$f_Measure_Floor_1 <-
  #   ifelse (
  #     AuxFunctions::Replace_NA (
  #       Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance,
  #       "_NA_"
  #     ) == "Manual",
  #     0,
  #     ifelse (
  #       AuxFunctions::Replace_NA (
  #         Data_Calc_UValEst$f_Measure_Floor_1_Input,
  #         0
  #       ) != 0,
  #       Data_Calc_UValEst$f_Measure_Floor_1_Input * 1,
  #       ifelse (
  #         Data_Calc_UValEst$Code_InsulationType_Floor_Input == "None",
  #         0,
  #         ifelse (
  #           Data_Calc_UValEst$Code_InsulationType_Floor_Input == "Refurbish",
  #           Data_Calc_UValEst$f_Insulation_Floor_Default_Refurbish,
  #           ifelse (
  #             Data_Calc_UValEst$Code_InsulationType_Floor_Input == "Original",
  #             ifelse (
  #               AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1_Input, 0) / 100 >
  #                 0.01,
  #               1,
  #               0
  #             ),
  #             ifelse (
  #               AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1_Input, 0) / 100 >
  #                 0.01,
  #               Data_Calc_UValEst$f_Insulation_Floor_Default_Refurbish,
  #               Data_Calc_UValEst$f_Insulation_Floor_Default_NA
  #             )
  #           )
  #         )
  #       )
  #     )
  #   ) # <IC13>
  #
  # Data_Calc_UValEst$f_Measure_Floor_2 <- Data_Calc_UValEst$f_Measure_Floor_1 # <ID13>









  # 2023-09-29 Above Script changed to interprete 0 as NA in specific cases
  # because NA input is not yet possible in the webtool.
  #
  # Script before changes:
  #
  # Data_Calc_UValEst$f_Measure_Roof_1 <-
  #     ifelse (
  #         AuxFunctions::Replace_NA (
  #             Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance,
  #             "_NA_"
  #         ) == "Manual",
  #         0,
  #         AuxFunctions::Replace_NA (
  #             Data_Calc_UValEst$f_Measure_Roof_1_Input * 1,
  #             ifelse (
  #                 Data_Calc_UValEst$Code_InsulationType_Roof_Input == "None",
  #                 0,
  #                 ifelse (
  #                     Data_Calc_UValEst$Code_InsulationType_Roof_Input == "Refurbish",
  #                     Data_Calc_UValEst$f_Insulation_Roof_Default_Refurbish,
  #                     ifelse (
  #                         Data_Calc_UValEst$Code_InsulationType_Roof_Input == "Original",
  #                         ifelse (
  #                             AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1_Input, 0) / 100 >
  #                                 0.01,
  #                             1,
  #                             0
  #                         ),
  #                         ifelse (
  #                             AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1_Input, 0) / 100 >
  #                                 0.01,
  #                             Data_Calc_UValEst$f_Insulation_Roof_Default_Refurbish,
  #                             Data_Calc_UValEst$f_Insulation_Roof_Default_NA
  #                         )
  #                     )
  #                 )
  #             )
  #         )
  #     ) # <HX13>
  #
  # Data_Calc_UValEst$f_Measure_Roof_2 <-
  #     ifelse (
  #         AuxFunctions::Replace_NA (
  #             Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance,
  #             "_NA_"
  #         ) == "Manual",
  #         0,
  #         AuxFunctions::Replace_NA (
  #             Data_Calc_UValEst$f_Measure_Roof_2_Input * 1,
  #             ifelse (
  #                 Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "None",
  #                 0,
  #                 ifelse (
  #                     Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "Refurbish",
  #                     Data_Calc_UValEst$f_Insulation_Ceiling_Default_Refurbish,
  #                     ifelse (
  #                         Data_Calc_UValEst$Code_InsulationType_Ceiling_Input == "Original",
  #                         ifelse (
  #                             AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2_Input, 0) / 100 >
  #                                 0.01,
  #                             1,
  #                             0
  #                         ),
  #                         ifelse (
  #                             AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2_Input, 0) / 100 >
  #                                 0.01,
  #                             Data_Calc_UValEst$f_Insulation_Ceiling_Default_Refurbish,
  #                             Data_Calc_UValEst$f_Insulation_Ceiling_Default_NA
  #                         )
  #                     )
  #                 )
  #             )
  #         )
  #     ) # <HY13>
  #
  # Data_Calc_UValEst$f_Measure_Wall_1 <-
  #     ifelse (
  #         AuxFunctions::Replace_NA (
  #             Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance,
  #             "_NA_"
  #         ) == "Manual",
  #         0,
  #         AuxFunctions::Replace_NA (
  #             Data_Calc_UValEst$f_Measure_Wall_1_Input * 1,
  #             ifelse (
  #                 Data_Calc_UValEst$Code_InsulationType_Wall_Input == "None",
  #                 0,
  #                 ifelse (
  #                     Data_Calc_UValEst$Code_InsulationType_Wall_Input == "Refurbish",
  #                     Data_Calc_UValEst$f_Insulation_Wall_Default_Refurbish,
  #                     ifelse (
  #                         Data_Calc_UValEst$Code_InsulationType_Wall_Input == "Original",
  #                         ifelse (
  #                             AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1_Input, 0) / 100 >
  #                                 0.01,
  #                             1,
  #                             0
  #                         ),
  #                         ifelse (
  #                             AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1_Input, 0) / 100 >
  #                                 0.01,
  #                             Data_Calc_UValEst$f_Insulation_Wall_Default_Refurbish,
  #                             Data_Calc_UValEst$f_Insulation_Wall_Default_NA
  #                         )
  #                     )
  #                 )
  #             )
  #         )
  #     ) # <HZ13>
  #
  # Data_Calc_UValEst$f_Measure_Wall_2 <- Data_Calc_UValEst$f_Measure_Wall_1 # <IA13>
  #
  # Data_Calc_UValEst$f_Measure_Wall_3 <- Data_Calc_UValEst$f_Measure_Wall_2 # <IB13>
  #
  # Data_Calc_UValEst$f_Measure_Floor_1 <-
  #     ifelse (
  #         AuxFunctions::Replace_NA (
  #             Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance,
  #             "_NA_"
  #         ) == "Manual",
  #         0,
  #         AuxFunctions::Replace_NA (
  #             Data_Calc_UValEst$f_Measure_Floor_1_Input * 1,
  #             ifelse (
  #                 Data_Calc_UValEst$Code_InsulationType_Floor_Input == "None",
  #                 0,
  #                 ifelse (
  #                     Data_Calc_UValEst$Code_InsulationType_Floor_Input == "Refurbish",
  #                     Data_Calc_UValEst$f_Insulation_Floor_Default_Refurbish,
  #                     ifelse (
  #                         Data_Calc_UValEst$Code_InsulationType_Floor_Input == "Original",
  #                         ifelse (
  #                             AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1_Input, 0) / 100 >
  #                                 0.01,
  #                             1,
  #                             0
  #                         ),
  #                         ifelse (
  #                             AuxFunctions::Replace_NA (Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1_Input, 0) / 100 >
  #                                 0.01,
  #                             Data_Calc_UValEst$f_Insulation_Floor_Default_Refurbish,
  #                             Data_Calc_UValEst$f_Insulation_Floor_Default_NA
  #                         )
  #                     )
  #                 )
  #             )
  #         )
  #     ) # <IC13>
  #
  # Data_Calc_UValEst$f_Measure_Floor_2 <- Data_Calc_UValEst$f_Measure_Floor_1 # <ID13>


  Data_Calc_UValEst$f_Measure_Window_1 <-
      ifelse (
          AuxFunctions::Replace_NA (
              Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance,
              "_NA_"
          ) == "Manual",
          0,
          ifelse (
              is.na (Data_Calc_UValEst$f_Measure_Window_1_Input),
              ifelse (AuxFunctions::xl_AND (
                  AuxFunctions::Replace_NA (Data_Calc_UValEst$Code_NumberPanes_WindowType2, "_NA_") == "_NA_",
                  is.na (Data_Calc_UValEst$U_Window_Input_Type2)
              ), 0, 0.3),
              Data_Calc_UValEst$f_Measure_Window_1_Input * 1
          )
      ) # <IE13> | 0 | Real | 0.3

  Data_Calc_UValEst$f_Measure_Window_2 <- 0 # <IF13> | 0

  Data_Calc_UValEst$f_Measure_Door_1 <-
      Data_Calc_UValEst$f_Measure_Window_1 # <IG13> | 0


  ###################################################################################X
  ## . U-values of original construction -----

  Data_Calc_UValEst$U_Class_Original_Roof_1 <-
      ifelse (
          Data_Calc_UValEst$Indicator_Roof_Constr_Massive * 1 == 1,
          ifelse (
              Data_Calc_UValEst$Indicator_Roof_Constr_Wood * 1 == 1,
              AuxFunctions::xl_AVERAGE (
                  Data_Calc_UValEst$U_Class_Roof_Massive,
                  Data_Calc_UValEst$U_Class_Roof_Wooden
              ),
              Data_Calc_UValEst$U_Class_Roof_Massive
          ),
          ifelse (
              Data_Calc_UValEst$Indicator_Roof_Constr_Wood * 1 == 1,
              Data_Calc_UValEst$U_Class_Roof_Wooden,
              Data_Calc_UValEst$U_Class_Roof_NA
          )
      ) # <IH13> | 04-05-2020: Variable name changed from: | U_Roof_1

  Data_Calc_UValEst$U_Class_Original_Roof_2 <-
      ifelse (
          Data_Calc_UValEst$Indicator_UpperCeiling_Constr_Massive * 1 == 1,
          ifelse (
              Data_Calc_UValEst$Indicator_UpperCeiling_Constr_Wood * 1 == 1,
              AuxFunctions::xl_AVERAGE (
                  Data_Calc_UValEst$U_Class_UpperCeiling_Massive,
                  Data_Calc_UValEst$U_Class_UpperCeiling_Wooden
              ),
              Data_Calc_UValEst$U_Class_UpperCeiling_Massive
          ),
          ifelse (
              Data_Calc_UValEst$Indicator_UpperCeiling_Constr_Wood * 1 == 1,
              Data_Calc_UValEst$U_Class_UpperCeiling_Wooden,
              Data_Calc_UValEst$U_Class_UpperCeiling_NA
          )
      ) # <II13> | 04-05-2020: Variable name changed from: | U_Roof_2

  Data_Calc_UValEst$U_Class_Original_Wall_1 <-
      ifelse (
          Data_Calc_UValEst$Indicator_Wall_Constr_Massive * 1 == 1,
          ifelse (
              Data_Calc_UValEst$Indicator_Wall_Constr_Wood * 1 == 1,
              AuxFunctions::xl_AVERAGE (
                  Data_Calc_UValEst$U_Class_Wall_Massive,
                  Data_Calc_UValEst$U_Class_Wall_Wooden
              ),
              Data_Calc_UValEst$U_Class_Wall_Massive
          ),
          ifelse (
              Data_Calc_UValEst$Indicator_Wall_Constr_Wood * 1 == 1,
              Data_Calc_UValEst$U_Class_Wall_Wooden,
              Data_Calc_UValEst$U_Class_Wall_NA
          )
      ) # <IJ13> | 04-05-2020: Variable name changed from: | U_Wall_1

  Data_Calc_UValEst$U_Class_Original_Wall_2 <-
      Data_Calc_UValEst$U_Class_Original_Wall_1 # <IK13> | 04-05-2020: Variable name changed from: | U_Wall_2

  Data_Calc_UValEst$U_Class_Original_Wall_3 <-
      Data_Calc_UValEst$U_Class_Wall_Massive # <IL13> | 04-05-2020: Variable name changed from: | U_Wall_3

  Data_Calc_UValEst$U_Class_Original_Floor_1 <-
      ifelse (
          Data_Calc_UValEst$Indicator_Floor_Constr_Massive * 1 == 1,
          ifelse (
              Data_Calc_UValEst$Indicator_Floor_Constr_Wood * 1 == 1,
              AuxFunctions::xl_AVERAGE (
                  Data_Calc_UValEst$U_Class_Floor_Massive,
                  Data_Calc_UValEst$U_Class_Floor_Wooden
              ),
              Data_Calc_UValEst$U_Class_Floor_Massive
          ),
          ifelse (
              Data_Calc_UValEst$Indicator_Floor_Constr_Wood * 1 == 1,
              Data_Calc_UValEst$U_Class_Floor_Wooden,
              Data_Calc_UValEst$U_Class_Floor_NA
          )
      ) # <IM13> | 04-05-2020: Variable name changed from: | U_Floor_1

  Data_Calc_UValEst$U_Class_Original_Floor_2 <-
      Data_Calc_UValEst$U_Class_Floor_Massive # <IN13> | 04-05-2020: Variable name changed from: | U_Floor_2


  Data_Calc_UValEst$Code_U_Class_Window_Type_1 <-
      myInputData$Code_Country %xl_JoinStrings%
      "." %xl_JoinStrings%
      Data_Calc_UValEst$Code_U_Class_National %xl_JoinStrings%
      "." %xl_JoinStrings%
      "Gen" %xl_JoinStrings%
      "." %xl_JoinStrings%
      Data_Calc_UValEst$Code_U_Class_WindowType1_nPane %xl_JoinStrings%
      "." %xl_JoinStrings%
      Data_Calc_UValEst$Code_U_Class_WindowType1_LowE %xl_JoinStrings%
      "." %xl_JoinStrings%
      Data_Calc_UValEst$Code_U_Class_WindowType1_GasFilling %xl_JoinStrings%
      "." %xl_JoinStrings%
      Data_Calc_UValEst$Code_U_Class_WindowType1_FrameMaterial %xl_JoinStrings%
      "." %xl_JoinStrings%
      Data_Calc_UValEst$Code_U_Class_WindowType1_Further # <IO13> | code of window typification | Code_U_Class_Window_Type_1 | Gen

  Data_Calc_UValEst$Code_U_Class_Window_Type_2 <-
      myInputData$Code_Country %xl_JoinStrings%
      "." %xl_JoinStrings%
      Data_Calc_UValEst$Code_U_Class_National %xl_JoinStrings%
      "." %xl_JoinStrings%
      "Gen" %xl_JoinStrings%
      "." %xl_JoinStrings%
      Data_Calc_UValEst$Code_U_Class_WindowType2_nPane %xl_JoinStrings%
      "." %xl_JoinStrings%
      Data_Calc_UValEst$Code_U_Class_WindowType2_LowE %xl_JoinStrings%
      "." %xl_JoinStrings%
      Data_Calc_UValEst$Code_U_Class_WindowType2_GasFilling %xl_JoinStrings%
      "." %xl_JoinStrings%
      Data_Calc_UValEst$Code_U_Class_WindowType2_FrameMaterial %xl_JoinStrings%
      "." %xl_JoinStrings%
      Data_Calc_UValEst$Code_U_Class_WindowType2_Further # <IP13> | code of window typification | Code_U_Class_Window_Type_2 | Gen

  #i_Row <- 1
  for (i_Row in (1:myCount_Dataset)) {
      Data_Calc_UValEst$Index_Col_Tab_U_WindowType1_Period [i_Row] <-
          max (
              which (
                  Data_Calc_UValEst$Year_Installation_WindowType1_Calc [i_Row] >= ParTab_ConstrYearClass$ConstructionYearClass_FirstYear
              )
          )
  } # End loop
  #Data_Calc_UValEst$Index_Col_Tab_U_WindowType1_Period

  for (i_Row in (1:myCount_Dataset)) {
      Data_Calc_UValEst$Index_Col_Tab_U_WindowType2_Period [i_Row] <-
          max (
              which (
                  Data_Calc_UValEst$Year_Installation_WindowType2_Calc [i_Row] >= ParTab_ConstrYearClass$ConstructionYearClass_FirstYear
              )
          )
  } # End loop
  #Data_Calc_UValEst$Index_Col_Tab_U_WindowType2_Period

  Data_Calc_UValEst$U_Class_Window_Type_1 <-
      Value_ParTab_Vector (
          ParTab_WindowTypePeriods,
          Data_Calc_UValEst$Code_U_Class_Window_Type_1,
          paste0 (
              "U_Window_Period_",
              AuxFunctions::xl_TEXT (Data_Calc_UValEst$Index_Col_Tab_U_WindowType1_Period, "00")
          ),
      )

  Data_Calc_UValEst$U_Class_Window_Type_2 <-
      Value_ParTab_Vector (
          ParTab_WindowTypePeriods,
          Data_Calc_UValEst$Code_U_Class_Window_Type_2,
          paste0 (
              "U_Window_Period_",
              AuxFunctions::xl_TEXT (Data_Calc_UValEst$Index_Col_Tab_U_WindowType2_Period, "00")
          ),
      )


  Data_Calc_UValEst$g_gl_n_Window_Type_1 <-
  Value_ParTab_Vector (
      ParTab_WindowTypePeriods,
      Data_Calc_UValEst$Code_U_Class_Window_Type_1,
      paste0 (
          "g_gl_n_Window_Period_",
          AuxFunctions::xl_TEXT (Data_Calc_UValEst$Index_Col_Tab_U_WindowType1_Period, "00")
      ),
  )

  Data_Calc_UValEst$g_gl_n_Window_Type_2 <-
      Value_ParTab_Vector (
          ParTab_WindowTypePeriods,
          Data_Calc_UValEst$Code_U_Class_Window_Type_2,
          paste0 (
              "g_gl_n_Window_Period_",
              AuxFunctions::xl_TEXT (Data_Calc_UValEst$Index_Col_Tab_U_WindowType2_Period, "00")
          ),
      )



  Data_Calc_UValEst$U_Class_Original_Window_1 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_UValEst$U_Window_Input_Type1 * 1, 0) > 0,
          Data_Calc_UValEst$U_Window_Input_Type1,
          Data_Calc_UValEst$U_Class_Window_Type_1
      ) # <IW13> | 04-05-2020: Variable name changed from: | U_Window_1

  # Attention: Window_Type_2 and Window_2 are something very different

  Data_Calc_UValEst$U_Class_Original_Window_2 <- Data_Calc_UValEst$U_Class_Original_Window_1
  # in Excel: 0 (changed, since below values are necessary)
  # <IX13> | Remark: U_Window_2 is not used! The second window type is applied as a measure to Window_1. The reason is that tabula-calculator.xlsx and TABULA.xlsm was supposed to be not structurally changed (estimated window area = window 1) | U_Window_2

  Data_Calc_UValEst$U_Class_Original_Door_1 <-
      Data_Calc_UValEst$U_Class_Original_Window_1 # <IY13> | 04-05-2020: Variable name changed from: | U_Door_1


  ###################################################################################X
  ## . Codes of the existing constructions (only used for information) -----

  Data_Calc_UValEst$Code_Roof_1 <-
      Data_Calc_UValEst$Code_ConstructionYearClass %xl_JoinStrings% "." %xl_JoinStrings%
      Data_Calc_UValEst$ConstructionYearClass_FirstYear %xl_JoinStrings% "-" %xl_JoinStrings%
      Data_Calc_UValEst$ConstructionYearClass_LastYear %xl_JoinStrings% "." %xl_JoinStrings%
      Data_Calc_UValEst$Indicator_Roof_Constr_Massive %xl_JoinStrings%
      Data_Calc_UValEst$Indicator_Roof_Constr_Wood # <JB13> | Code for identification of the U-value | element type roof 1 | Only used for indication

  Data_Calc_UValEst$Code_Roof_2 <-
      Data_Calc_UValEst$Code_ConstructionYearClass %xl_JoinStrings% "." %xl_JoinStrings%
      Data_Calc_UValEst$ConstructionYearClass_FirstYear %xl_JoinStrings% "-" %xl_JoinStrings%
      Data_Calc_UValEst$ConstructionYearClass_LastYear %xl_JoinStrings% "." %xl_JoinStrings%
      Data_Calc_UValEst$Indicator_UpperCeiling_Constr_Massive %xl_JoinStrings%
      Data_Calc_UValEst$Indicator_UpperCeiling_Constr_Wood # <JC13> | Code for identification of the U-value | element type roof 2 | Only used for indication

  Data_Calc_UValEst$Code_Wall_1 <-
      Data_Calc_UValEst$Code_ConstructionYearClass %xl_JoinStrings% "." %xl_JoinStrings%
      Data_Calc_UValEst$ConstructionYearClass_FirstYear %xl_JoinStrings% "-" %xl_JoinStrings%
      Data_Calc_UValEst$ConstructionYearClass_LastYear %xl_JoinStrings% "." %xl_JoinStrings%
      Data_Calc_UValEst$Indicator_Wall_Constr_Massive %xl_JoinStrings%
      Data_Calc_UValEst$Indicator_Wall_Constr_Wood # <JD13> | Code for identification of the U-value | element type wall 1 | Only used for indication

  Data_Calc_UValEst$Code_Wall_2 <-
      Data_Calc_UValEst$Code_ConstructionYearClass %xl_JoinStrings% "." %xl_JoinStrings%
      Data_Calc_UValEst$ConstructionYearClass_FirstYear %xl_JoinStrings% "-" %xl_JoinStrings%
      Data_Calc_UValEst$ConstructionYearClass_LastYear %xl_JoinStrings% "." %xl_JoinStrings%
      Data_Calc_UValEst$Indicator_Wall_Constr_Massive %xl_JoinStrings%
      Data_Calc_UValEst$Indicator_Wall_Constr_Wood # <JE13> | Code for identification of the U-value | element type wall 2 | Only used for indication

  Data_Calc_UValEst$Code_Wall_3 <-
      Data_Calc_UValEst$Code_ConstructionYearClass %xl_JoinStrings% "." %xl_JoinStrings%
      Data_Calc_UValEst$ConstructionYearClass_FirstYear %xl_JoinStrings% "-" %xl_JoinStrings%
      Data_Calc_UValEst$ConstructionYearClass_LastYear %xl_JoinStrings% "." %xl_JoinStrings%
      Data_Calc_UValEst$Indicator_Roof_Constr_Massive %xl_JoinStrings%
      Data_Calc_UValEst$Indicator_Roof_Constr_Wood # <JF13> | Code for identification of the U-value | element type wall 3 | Only used for indication

  Data_Calc_UValEst$Code_Floor_1 <-
      Data_Calc_UValEst$Code_ConstructionYearClass %xl_JoinStrings% "." %xl_JoinStrings%
      Data_Calc_UValEst$ConstructionYearClass_FirstYear %xl_JoinStrings% "-" %xl_JoinStrings%
      Data_Calc_UValEst$ConstructionYearClass_LastYear %xl_JoinStrings% "." %xl_JoinStrings%
      Data_Calc_UValEst$Indicator_Floor_Constr_Massive %xl_JoinStrings%
      Data_Calc_UValEst$Indicator_Floor_Constr_Wood # <JG13> | Code for identification of the U-value | element type floor 1 | Only used for indication

  Data_Calc_UValEst$Code_Floor_2 <-
      Data_Calc_UValEst$Code_ConstructionYearClass %xl_JoinStrings% "." %xl_JoinStrings%
      Data_Calc_UValEst$ConstructionYearClass_FirstYear %xl_JoinStrings% "-" %xl_JoinStrings%
      Data_Calc_UValEst$ConstructionYearClass_LastYear %xl_JoinStrings% "." %xl_JoinStrings%
      Data_Calc_UValEst$Indicator_Floor_Constr_Massive %xl_JoinStrings%
      Data_Calc_UValEst$Indicator_Floor_Constr_Wood # <JH13> | Code for identification of the U-value | element type floor 2 | Only used for indication

  Data_Calc_UValEst$Code_Window_1 <-
      Data_Calc_UValEst$Code_U_Class_Window_Type_1 # <JI13> | Code for identification of the U-value | element type window 1

  Data_Calc_UValEst$Code_Window_2 <- '-' # <JJ13> | Code for identification of the U-value | element type window 2

  Data_Calc_UValEst$Code_Door_1 <-
      Data_Calc_UValEst$Code_Window_1 # <JK13> | Code for identification of the U-value | element type door 1

  Data_Calc_UValEst$Code_Measure_Window_1 <-
      Data_Calc_UValEst$Code_U_Class_Window_Type_2 # <JL13>


  ###################################################################################X
  ## . Thermal resistance of 1 cm insulation measure (concept of "predefined measure") -----

  # This approach enables scaling of the thickness of predefined measures
  # in TABULA.xlsm and in the TABULA webtool
  # This is not (yet) implemented in the MOBASY concept, therefore the predefined measure
  # is set to a standard thickness of 1 cm; the actual insulation thickniss is later
  # applied by just multiplying,

  Data_Calc_UValEst$R_PredefinedMeasure_Roof_1 <-
      ifelse (Data_Calc_UValEst$f_Measure_Roof_1 > 0,
              0.01 / Data_Calc_UValEst$Lambda_Insulation_Roof_Calc,
              0) # <JM13>

  Data_Calc_UValEst$R_PredefinedMeasure_Roof_2 <-
      ifelse (Data_Calc_UValEst$f_Measure_Roof_2 > 0,
              0.01 / Data_Calc_UValEst$Lambda_Insulation_Ceiling_Calc,
              0) # <JN13>

  Data_Calc_UValEst$R_PredefinedMeasure_Wall_1 <-
      ifelse (Data_Calc_UValEst$f_Measure_Wall_1 > 0,
              0.01 / Data_Calc_UValEst$Lambda_Insulation_Wall_Calc,
              0) # <JO13>

  Data_Calc_UValEst$R_PredefinedMeasure_Wall_2 <-
      Data_Calc_UValEst$R_PredefinedMeasure_Wall_1 # <JP13>

  Data_Calc_UValEst$R_PredefinedMeasure_Wall_3 <-
      Data_Calc_UValEst$R_PredefinedMeasure_Wall_1 # <JQ13>

  Data_Calc_UValEst$R_PredefinedMeasure_Floor_1 <-
      ifelse (Data_Calc_UValEst$f_Measure_Floor_1 > 0,
              0.01 / Data_Calc_UValEst$Lambda_Insulation_Floor_Calc,
              0) # <JR13>

  Data_Calc_UValEst$R_PredefinedMeasure_Floor_2 <-
      Data_Calc_UValEst$R_PredefinedMeasure_Floor_1 # <JS13>

  # 2023-04-12: Corrected (U_Window_Input_Type2 can be NA)
  Data_Calc_UValEst$R_PredefinedMeasure_Window_1 <-
    ifelse (
      AuxFunctions::Replace_NA (Data_Calc_UValEst$U_Window_Input_Type2, 0) > 0,
      1 / Data_Calc_UValEst$U_Window_Input_Type2,
      1 / Data_Calc_UValEst$U_Class_Window_Type_2
    ) # <JT13>

  # Data_Calc_UValEst$R_PredefinedMeasure_Window_1 <-
  #     ifelse (
  #         Data_Calc_UValEst$U_Window_Input_Type2 > 0,
  #         1 / Data_Calc_UValEst$U_Window_Input_Type2,
  #         1 / Data_Calc_UValEst$U_Class_Window_Type_2
  #     ) # <JT13>

  Data_Calc_UValEst$R_PredefinedMeasure_Window_2 <- 0 # <JU13>

  Data_Calc_UValEst$R_PredefinedMeasure_Door_1 <-
      Data_Calc_UValEst$R_PredefinedMeasure_Window_1 # <JV13>

  Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Roof_1 <-
      ifelse (Data_Calc_UValEst$R_PredefinedMeasure_Roof_1 > 0, 0.01, 0) # <JW13>

  Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Roof_2 <-
      ifelse (Data_Calc_UValEst$R_PredefinedMeasure_Roof_2 > 0, 0.01, 0) # <JX13>

  Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Wall_1 <-
      ifelse (Data_Calc_UValEst$R_PredefinedMeasure_Wall_1 > 0, 0.01, 0) # <JY13>

  Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Wall_2 <-
      ifelse (Data_Calc_UValEst$R_PredefinedMeasure_Wall_2 > 0, 0.01, 0) # <JZ13>

  Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Wall_3 <-
      ifelse (Data_Calc_UValEst$R_PredefinedMeasure_Wall_3 > 0, 0.01, 0) # <KA13>

  Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Floor_1 <-
      ifelse (Data_Calc_UValEst$R_PredefinedMeasure_Floor_1 > 0, 0.01, 0) # <KB13>

  Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Floor_2 <-
      ifelse (Data_Calc_UValEst$R_PredefinedMeasure_Floor_2 > 0, 0.01, 0) # <KC13>



  # Data_Calc_UValEst$Code_TypeInput_WindowAreaPassiveSolar <- myInputData$Code_TypeInput_WindowAreaPassiveSolar # <KE13> | Form.Building | Code_TypeInput_WindowAreaPassiveSolar | 141
  # Data_Calc_UValEst$Code_TypeIntake_EnvelopeArea <- ifelse (Data_Calc_UValEst$Code_TypeInput_Envelope_SurfaceArea == "Manual", "Manual", ifelse (Data_Calc_UValEst$Code_TypeInput_WindowAreaPassiveSolar == "Manual", "Estimation_ManualWindowOrientation", "Estimation")) # <KF13> | Code for tabula-calculator.xlsx | "Manual" (or empty) = use area input values; "Estimation" = use estimated values
  # Data_Calc_UValEst$A_Roof_1 <- myInputData$A_Input_Roof_01 # <KG13> | surface area (external dimensions) | element type roof 1 | m? | Form.Building | Alternative direct data input | A_Input_Roof_01 | 92
  # Data_Calc_UValEst$A_Roof_2 <- myInputData$A_Input_Roof_02 # <KH13> | surface area (external dimensions) | element type roof 2 | m? | Form.Building | A_Input_Roof_02 | 93
  # Data_Calc_UValEst$A_Wall_1 <- myInputData$A_Input_Wall_01 # <KI13> | surface area (external dimensions) | element type wall 1 | m? | Form.Building | A_Input_Wall_01 | 94
  # Data_Calc_UValEst$A_Wall_2 <- myInputData$A_Input_Wall_02 # <KJ13> | surface area (external dimensions) | element type wall 2 | m? | Form.Building | A_Input_Wall_02 | 95
  # Data_Calc_UValEst$A_Wall_3 <- myInputData$A_Input_Wall_03 # <KK13> | surface area (external dimensions) | element type wall 3 | m? | Form.Building | A_Input_Wall_03 | 96
  # Data_Calc_UValEst$A_Floor_1 <- myInputData$A_Input_Floor_01 # <KL13> | surface area (external dimensions) | element type floor 1 | m? | Form.Building | A_Input_Floor_01 | 97
  # Data_Calc_UValEst$A_Floor_2 <- myInputData$A_Input_Floor_02 # <KM13> | surface area (external dimensions) | element type floor 2 | m? | Form.Building | A_Input_Floor_02 | 98
  # Data_Calc_UValEst$A_Window_1 <- myInputData$A_Input_Window_01 # <KN13> | surface area | element type window 1 | m? | Form.Building | A_Input_Window_01 | 99
  # Data_Calc_UValEst$A_Window_2 <- myInputData$A_Input_Window_02 # <KO13> | surface area | element type window 2 | m? | Form.Building | A_Input_Window_02 | 100
  # Data_Calc_UValEst$A_Door_1 <- myInputData$A_Input_Door_01 # <KP13> | surface area | element type door 1 | m? | Form.Building | A_Input_Door_01 | 101
  # Data_Calc_UValEst$A_Window_Horizontal <- myInputData$A_Window_Horizontal # <KQ13> | area of horizontal windows | tilted below 30?, otherwise classified as vertical (see below) | m? | Form.Building | A_Window_Horizontal | 143
  # Data_Calc_UValEst$A_Window_East <- myInputData$A_Window_East # <KR13> | window area oriented east | deviation from orientation: +/- 45? | m? | Form.Building | A_Window_East | 144
  # Data_Calc_UValEst$A_Window_South <- myInputData$A_Window_South # <KS13> | window area oriented south | deviation from orientation: +/- 45? | m? | Form.Building | A_Window_South | 145
  # Data_Calc_UValEst$A_Window_West <- myInputData$A_Window_West # <KT13> | window area oriented west | deviation from orientation: +/- 45? | m? | Form.Building | A_Window_West | 146
  # Data_Calc_UValEst$A_Window_North <- myInputData$A_Window_North # <KU13> | window area oriented north | deviation from orientation: +/- 45? | m? | Form.Building | A_Window_North | 147


  ###################################################################################X
  ## . Considering of manual input of U-values if available (handled as "original construction") -----

  Data_Calc_UValEst$U_Original_Roof_1 <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          myInputData$U_Input_Roof_01,
          Data_Calc_UValEst$U_Class_Original_Roof_1
      ) # <KV13> | 04-05-2020: Variable name changed from: | U_Roof_1 | Form.Building | Functional input or alternative direct data input | U_Input_Roof_01 | 103

  Data_Calc_UValEst$U_Original_Roof_2 <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          myInputData$U_Input_Roof_02,
          Data_Calc_UValEst$U_Class_Original_Roof_2
      ) # <KW13> | 04-05-2020: Variable name changed from: | U_Roof_2 | Form.Building | U_Input_Roof_02 | 104

  Data_Calc_UValEst$U_Original_Wall_1 <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          myInputData$U_Input_Wall_01,
          Data_Calc_UValEst$U_Class_Original_Wall_1
      ) # <KX13> | 04-05-2020: Variable name changed from: | U_Wall_1 | Form.Building | U_Input_Wall_01 | 105

  Data_Calc_UValEst$U_Original_Wall_2 <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          myInputData$U_Input_Wall_02,
          Data_Calc_UValEst$U_Class_Original_Wall_2
      ) # <KY13> | 04-05-2020: Variable name changed from: | U_Wall_2 | Form.Building | U_Input_Wall_02 | 106

  Data_Calc_UValEst$U_Original_Wall_3 <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          myInputData$U_Input_Wall_03,
          Data_Calc_UValEst$U_Class_Original_Wall_3
      ) # <KZ13> | 04-05-2020: Variable name changed from: | U_Wall_3 | Form.Building | U_Input_Wall_03 | 107

  Data_Calc_UValEst$U_Original_Floor_1 <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          myInputData$U_Input_Floor_01,
          Data_Calc_UValEst$U_Class_Original_Floor_1
      ) # <LA13> | 04-05-2020: Variable name changed from: | U_Floor_1 | Form.Building | U_Input_Floor_01 | 108

  Data_Calc_UValEst$U_Original_Floor_2 <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          myInputData$U_Input_Floor_02,
          Data_Calc_UValEst$U_Class_Original_Floor_2
      ) # <LB13> | 04-05-2020: Variable name changed from: | U_Floor_2 | Form.Building | U_Input_Floor_02 | 109

  Data_Calc_UValEst$U_Original_Window_1 <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          myInputData$U_Input_Window_01,
          Data_Calc_UValEst$U_Class_Original_Window_1
      ) # <LC13> | Form.Building | U_Input_Window_01 | 110

  Data_Calc_UValEst$U_Original_Window_2 <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          myInputData$U_Input_Window_02,
          Data_Calc_UValEst$U_Class_Original_Window_2
      ) # <LD13> | Form.Building | U_Input_Window_02 | 111

  Data_Calc_UValEst$U_Original_Door_1 <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          myInputData$U_Input_Door_01,
          Data_Calc_UValEst$U_Class_Original_Door_1
      ) # <LE13> | Form.Building | U_Input_Door_01 | 112


  ###################################################################################X
  ## . Thermal resistance of unheated spaces -----

  Data_Calc_UValEst$R_Add_UnheatedSpace_Roof_1 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
              myInputData$R_Add_UnheatedSpace_Roof_1,
              0
          ),
          0
      ) # <LF13> | Form.Building | R_Add_UnheatedSpace_Roof_1 | 123 | 0

  Data_Calc_UValEst$R_Add_UnheatedSpace_Roof_2 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
              myInputData$R_Add_UnheatedSpace_Roof_2,
              0.3
          ),
          0.3
      ) # <LG13> | Form.Building | R_Add_UnheatedSpace_Roof_2 | 124 | 0.3

  Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_1 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
              myInputData$R_Add_UnheatedSpace_Wall_1,
              0
          ),
          0
      ) # <LH13> | Form.Building | R_Add_UnheatedSpace_Wall_1 | 125 | 0

  Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_2 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
              myInputData$R_Add_UnheatedSpace_Wall_2,
              0
          ),
          0
      ) # <LI13> | Form.Building | R_Add_UnheatedSpace_Wall_2 | 126 | 0

  Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_3 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
              myInputData$R_Add_UnheatedSpace_Wall_3,
              0
          ),
          0
      ) # <LJ13> | Form.Building | R_Add_UnheatedSpace_Wall_3 | 127 | 0

  Data_Calc_UValEst$R_Add_UnheatedSpace_Floor_1 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
              myInputData$R_Add_UnheatedSpace_Floor_1,
              0.3
          ),
          0.3
      ) # <LK13> | Form.Building | R_Add_UnheatedSpace_Floor_1 | 128 | 0.3

  Data_Calc_UValEst$R_Add_UnheatedSpace_Floor_2 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
              myInputData$R_Add_UnheatedSpace_Floor_2,
              0
          ),
          0
      ) # <LL13> | Form.Building | R_Add_UnheatedSpace_Floor_2 | 129 | 0


  ###################################################################################X
  ## . Reduction factor for heat transmission for considering losses to ground  -----

  Data_Calc_UValEst$b_Transmission_Roof_1 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
              myInputData$b_Transmission_Roof_1,
              1
          ),
          1
      ) # <LM13> | Form.Building | b_Transmission_Roof_1 | 130 | 1

  Data_Calc_UValEst$b_Transmission_Roof_2 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
              myInputData$b_Transmission_Roof_2,
              1
          ),
          1
      ) # <LN13> | Form.Building | b_Transmission_Roof_2 | 131 | 1

  Data_Calc_UValEst$b_Transmission_Wall_1 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
              myInputData$b_Transmission_Wall_1,
              1
          ),
          1
      ) # <LO13> | Form.Building | b_Transmission_Wall_1 | 132 | 1

  Data_Calc_UValEst$b_Transmission_Wall_2 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
              myInputData$b_Transmission_Wall_2,
              1
          ),
          1
      ) # <LP13> | Form.Building | b_Transmission_Wall_2 | 133 | 1

  Data_Calc_UValEst$b_Transmission_Wall_3 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
              myInputData$b_Transmission_Wall_3,
              0.5
          ),
          0.5
      ) # <LQ13> | Form.Building | b_Transmission_Wall_3 | 134 | 0.5

  Data_Calc_UValEst$b_Transmission_Floor_1 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
              myInputData$b_Transmission_Floor_1,
              0.5
          ),
          0.5
      ) # <LR13> | Form.Building | b_Transmission_Floor_1 | 135 | 0.5

  Data_Calc_UValEst$b_Transmission_Floor_2 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
              myInputData$b_Transmission_Floor_2,
              0.5
          ),
          0.5
      ) # <LS13> | Form.Building | b_Transmission_Floor_2 | 136 | 0.5

  Data_Calc_UValEst$g_gl_n_Input_Window_1 <-
      myInputData$g_gl_n_Input_Window_1 # <LT13> | Form.Building | g_gl_n_Input_Window_1 | 137
  Data_Calc_UValEst$g_gl_n_Input_Window_2 <-
      myInputData$g_gl_n_Input_Window_2 # <LU13> | Form.Building | g_gl_n_Input_Window_2 | 138

  Data_Calc_UValEst$delta_U_Input_ThermalBridging <-
      myInputData$delta_U_Input_ThermalBridging # <LV13> | Form.Building | delta_U_Input_ThermalBridging | 139

  Data_Calc_UValEst$n_air_infiltration <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          myInputData$n_Input_air_infiltration,
          Data_Calc_UValEst$n_air_infiltration_Class
      ) # <LW13> | Form.Building | n_Input_air_infiltration | 140

  Data_Calc_UValEst$g_gl_n_Window_1 <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          Data_Calc_UValEst$g_gl_n_Input_Window_1,
          Data_Calc_UValEst$g_gl_n_Window_Type_1
      ) # <LX13>

  Data_Calc_UValEst$g_gl_n_Window_2 <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          Data_Calc_UValEst$g_gl_n_Input_Window_2,
          Data_Calc_UValEst$g_gl_n_Window_Type_1
      ) # <LY13> | not used in case of Energy Profile surface area estimation

  Data_Calc_UValEst$g_gl_n_PredefinedMeasure_Window_1 <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          Data_Calc_UValEst$g_gl_n_Input_Window_1,
          Data_Calc_UValEst$g_gl_n_Window_Type_2
      ) # <LZ13> | used for the definition of the second window type in case of Energy Profile surface area estimation | not used for direct input modus

  Data_Calc_UValEst$g_gl_n_PredefinedMeasure_Window_2 <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          Data_Calc_UValEst$g_gl_n_Input_Window_1,
          Data_Calc_UValEst$g_gl_n_Window_Type_2
      ) # <MA13> | not used in case of Energy Profile surface area estimation | not used for direct input modus


  ###################################################################################X
  ## . Thermal bridging -----

  Data_Calc_UValEst$Code_ThermalBridging_Refurbished <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          "Manual input",
          ifelse (
              Data_Calc_UValEst$Code_ThermalBridging_Refurbished_Input == "_NA_",
              ifelse (
                  AuxFunctions::xl_AND (
                      AuxFunctions::xl_OR (
                          AuxFunctions::Replace_NA (Data_Calc_UValEst$Indicator_InternalWallInsulation * 1, 0) == 1,
                          Data_Calc_UValEst$Code_Potential_ExternalWallInsulation == "NotPossible"
                      ),
                      Data_Calc_UValEst$f_Measure_Wall_1 > 0.5,
                      Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1 > 0.01
                  ),
                  "High",
                  ifelse (
                      AuxFunctions::xl_AND (
                          Data_Calc_UValEst$Code_InsulationType_Wall_1 == "Original",
                          Data_Calc_UValEst$f_Measure_Wall_1 == 1,
                          Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1 > 0.1
                      ),
                      "Minimal",
                      ifelse (
                          AuxFunctions::xl_AND (
                              Data_Calc_UValEst$Code_InsulationType_Wall_1 == "Refurbish",
                              Data_Calc_UValEst$f_Measure_Wall_1 > 0,
                              Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1 > 0.1
                          ),
                          "Medium",
                          "Low"
                      )
                  )
              ),
              Data_Calc_UValEst$Code_ThermalBridging_Refurbished_Input
          )
      )  # <FG11>


  Data_Calc_UValEst$delta_U_Class_ThermalBridging_Refurbished <-
    Value_ParTab (
      ParTab_ThermalBridging,
      Data_Calc_UValEst$Code_ThermalBridging_Refurbished,
      "delta_U_ThermalBridging",
      3,
      "Manual input",
      NA,
      Value_Numeric_Error
    )

  Data_Calc_UValEst$Code_ThermalBridging_Original <-
      Data_Calc_UValEst$Code_ThermalBridging_Refurbished

  Data_Calc_UValEst$delta_U_Class_ThermalBridging_Original <-
      Data_Calc_UValEst$delta_U_Class_ThermalBridging_Refurbished # <FI11>

  #2021-07-16: The position of the last 4 formulas had to be changed, some variables were not yet defined at the former position, also done in Excel

  Data_Calc_UValEst$delta_U_ThermalBridging_Original <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          Data_Calc_UValEst$delta_U_Input_ThermalBridging,
          Data_Calc_UValEst$delta_U_Class_ThermalBridging_Original
      ) # <MB13>

  Data_Calc_UValEst$delta_U_ThermalBridging_Refurbished <-
      ifelse (
          Data_Calc_UValEst$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          Data_Calc_UValEst$delta_U_Input_ThermalBridging,
          Data_Calc_UValEst$delta_U_Class_ThermalBridging_Refurbished
      ) # <MC13>






  #. ---------------------------------------------------------------------------------


  ###################################################################################X
  ## Calculation of U-values -----
  ###################################################################################X

  # Calculation / Code from "[tabula-calculator.xlsx]Calc.Set.Building"


  ###################################################################################X
  ## . Estimation of insulation already included in the construction (before measure is applied) -----

  Data_Calc_UValEst$d_Insulation_OriginalIncluded_Roof_1 <-
      ifelse (Data_Calc_UValEst$U_Original_Roof_1 < 1,
              ifelse ((1 / Data_Calc_UValEst$U_Original_Roof_1 - 1) * 0.04 > 0.01,
                      (1 / Data_Calc_UValEst$U_Original_Roof_1 - 1) * 0.04,
                      0
              ),
              0) # <ET13> | thickness of existing insulation | relevant in case of replacement by new measure | m | Tab.Building | Real | 05-05-2020: Variable name changed from: | d_Insulation_Roof_1
  Data_Calc_UValEst$d_Insulation_OriginalIncluded_Roof_2 <-
      ifelse (Data_Calc_UValEst$U_Original_Roof_2 < 1,
              ifelse ((1 / Data_Calc_UValEst$U_Original_Roof_2 - 1) * 0.04 > 0.01,
                      (1 / Data_Calc_UValEst$U_Original_Roof_2 - 1) * 0.04,
                      0
              ),
              0) # <EU13> | thickness of existing insulation | relevant in case of replacement by new measure | m | Tab.Building | Real | 05-05-2020: Variable name changed from: | d_Insulation_Roof_2
  Data_Calc_UValEst$d_Insulation_OriginalIncluded_Wall_1 <-
      ifelse (Data_Calc_UValEst$U_Original_Wall_1 < 1,
              ifelse ((1 / Data_Calc_UValEst$U_Original_Wall_1 - 1) * 0.04 > 0.01,
                      (1 / Data_Calc_UValEst$U_Original_Wall_1 - 1) * 0.04,
                      0
              ),
              0) # <EV13> | thickness of existing insulation | relevant in case of replacement by new measure | m | Tab.Building | Real | 05-05-2020: Variable name changed from: | d_Insulation_Wall_1
  Data_Calc_UValEst$d_Insulation_OriginalIncluded_Wall_2 <-
      ifelse (Data_Calc_UValEst$U_Original_Wall_2 < 1,
              ifelse ((1 / Data_Calc_UValEst$U_Original_Wall_2 - 1) * 0.04 > 0.01,
                      (1 / Data_Calc_UValEst$U_Original_Wall_2 - 1) * 0.04,
                      0
              ),
              0) # <EW13> | thickness of existing insulation | relevant in case of replacement by new measure | m | Tab.Building | Real | 05-05-2020: Variable name changed from: | d_Insulation_Wall_2
  Data_Calc_UValEst$d_Insulation_OriginalIncluded_Wall_3 <-
      ifelse (Data_Calc_UValEst$U_Original_Wall_3 < 1,
              ifelse ((1 / Data_Calc_UValEst$U_Original_Wall_3 - 1) * 0.04 > 0.01,
                      (1 / Data_Calc_UValEst$U_Original_Wall_3 - 1) * 0.04,
                      0
              ),
              0) # <EX13> | thickness of existing insulation | relevant in case of replacement by new measure | m | Tab.Building | Real | 05-05-2020: Variable name changed from: | d_Insulation_Wall_3
  Data_Calc_UValEst$d_Insulation_OriginalIncluded_Floor_1 <-
      ifelse (Data_Calc_UValEst$U_Original_Floor_1 < 1,
              ifelse ((1 / Data_Calc_UValEst$U_Original_Floor_1 - 1) * 0.04 > 0.01,
                      (1 / Data_Calc_UValEst$U_Original_Floor_1 - 1) * 0.04,
                      0
              ),
              0) # <EY13> | thickness of existing insulation | relevant in case of replacement by new measure | m | Tab.Building | Real | 05-05-2020: Variable name changed from: | d_Insulation_Floor_1
  Data_Calc_UValEst$d_Insulation_OriginalIncluded_Floor_2 <-
      ifelse (Data_Calc_UValEst$U_Original_Floor_2 < 1,
              ifelse ((1 / Data_Calc_UValEst$U_Original_Floor_2 - 1) * 0.04 > 0.01,
                      (1 / Data_Calc_UValEst$U_Original_Floor_2 - 1) * 0.04,
                      0
              ),
              0) # <EZ13> | thickness of existing insulation | relevant in case of replacement by new measure | m | Tab.Building | Real | 05-05-2020: Variable name changed from: | d_Insulation_Floor_2


  ###################################################################################X
  ## . Insulation thickness of an applied measure -----

  Data_Calc_UValEst$d_Insulation_Measure_Roof_1 <-
      ifelse (
          Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1 > 0,
          Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1,
          Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Roof_1
      ) # <GY13> | actual insulation thickness of  refurbishment measure | element type roof 1 | m | Real
  Data_Calc_UValEst$d_Insulation_Measure_Roof_2 <-
      ifelse (
          Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2 > 0,
          Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2,
          Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Roof_2
      ) # <GZ13> | actual insulation thickness of  refurbishment measure | element type roof 2 | m | Real
  Data_Calc_UValEst$d_Insulation_Measure_Wall_1 <-
      ifelse (
          Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1 > 0,
          Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1,
          Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Wall_1
      ) # <HA13> | actual insulation thickness of  refurbishment measure | element type wall 1 | m | Real
  Data_Calc_UValEst$d_Insulation_Measure_Wall_2 <-
      ifelse (
          Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_2 > 0,
          Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_2,
          Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Wall_2
      ) # <HB13> | actual insulation thickness of  refurbishment measure | element type wall 2 | m | Real
  Data_Calc_UValEst$d_Insulation_Measure_Wall_3 <-
      ifelse (
          Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_3 > 0,
          Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_3,
          Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Wall_3
      ) # <HC13> | actual insulation thickness of  refurbishment measure | element type wall 3 | m | Real
  Data_Calc_UValEst$d_Insulation_Measure_Floor_1 <-
      ifelse (
          Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1 > 0,
          Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1,
          Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Floor_1
      ) # <HD13> | actual insulation thickness of  refurbishment measure | element type floor 1 | m | Real
  Data_Calc_UValEst$d_Insulation_Measure_Floor_2 <-
      ifelse (
          Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_2 > 0,
          Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_2,
          Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Floor_2
      ) # <HE13> | actual insulation thickness of  refurbishment measure | element type floor 2 | m | Real


  ###################################################################################X
  ## . Thermal resistance of an applied measure -----

  Data_Calc_UValEst$R_Measure_Roof_1 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Roof_1 != 0,
              Data_Calc_UValEst$d_Insulation_Measure_Roof_1 / Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Roof_1,
              1
          ) * Data_Calc_UValEst$R_PredefinedMeasure_Roof_1,
          0
      ) # <HF13> | thermal resistance of refurbishment measure | element type roof 1 | m?K/W | Tab.Building.Measure | Real
  Data_Calc_UValEst$R_Measure_Roof_2 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Roof_2 != 0,
              Data_Calc_UValEst$d_Insulation_Measure_Roof_2 / Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Roof_2,
              1
          ) * Data_Calc_UValEst$R_PredefinedMeasure_Roof_2,
          0
      ) # <HG13> | thermal resistance of refurbishment measure | element type roof 2 | m?K/W | Tab.Building.Measure | Real
  Data_Calc_UValEst$R_Measure_Wall_1 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Wall_1 != 0,
              Data_Calc_UValEst$d_Insulation_Measure_Wall_1 / Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Wall_1,
              1
          ) * Data_Calc_UValEst$R_PredefinedMeasure_Wall_1,
          0
      ) # <HH13> | thermal resistance of refurbishment measure | element type wall 1 | m?K/W | Tab.Building.Measure | Real
  Data_Calc_UValEst$R_Measure_Wall_2 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Wall_2 != 0,
              Data_Calc_UValEst$d_Insulation_Measure_Wall_2 / Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Wall_2,
              1
          ) * Data_Calc_UValEst$R_PredefinedMeasure_Wall_2,
          0
      ) # <HI13> | thermal resistance of refurbishment measure | element type wall 2 | m?K/W | Tab.Building.Measure | Real
  Data_Calc_UValEst$R_Measure_Wall_3 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Wall_3 != 0,
              Data_Calc_UValEst$d_Insulation_Measure_Wall_3 / Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Wall_3,
              1
          ) * Data_Calc_UValEst$R_PredefinedMeasure_Wall_3,
          0
      ) # <HJ13> | thermal resistance of refurbishment measure | element type wall 3 | m?K/W | Tab.Building.Measure | Real
  Data_Calc_UValEst$R_Measure_Floor_1 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Floor_1 != 0,
              Data_Calc_UValEst$d_Insulation_Measure_Floor_1 / Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Floor_1,
              1
          ) * Data_Calc_UValEst$R_PredefinedMeasure_Floor_1,
          0
      ) # <HK13> | thermal resistance of refurbishment measure | element type floor 1 | m?K/W | Tab.Building.Measure | Real
  Data_Calc_UValEst$R_Measure_Floor_2 <-
      AuxFunctions::Replace_NA (
          ifelse (
              Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Floor_2 != 0,
              Data_Calc_UValEst$d_Insulation_Measure_Floor_2 / Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Floor_2, 1) * Data_Calc_UValEst$R_PredefinedMeasure_Floor_2, 0) # <HL13> | thermal resistance of refurbishment measure | element type floor 2 | m?K/W | Tab.Building.Measure | Real

  Data_Calc_UValEst$R_Measure_Window_1 <-
      Data_Calc_UValEst$R_PredefinedMeasure_Window_1 # <HM13> | thermal resistance of refurbishment measure | element type window 1 | m?K/W | Tab.Building.Measure | Real
  Data_Calc_UValEst$R_Measure_Window_2 <-
      Data_Calc_UValEst$R_PredefinedMeasure_Window_2 # <HN13> | thermal resistance of refurbishment measure | element type window 2 | m?K/W | Tab.Building.Measure | Real
  Data_Calc_UValEst$R_Measure_Door_1 <-
      Data_Calc_UValEst$R_PredefinedMeasure_Door_1 # <HO13> | thermal resistance of refurbishment measure | element type door 1 | m?K/W | Tab.Building.Measure | Real
  Data_Calc_UValEst$g_gl_n_Measure_Window_1 <-
      Data_Calc_UValEst$g_gl_n_PredefinedMeasure_Window_1 # <HP13> | total solar energy transmittance for radiation perpendicular to the glazing, refurbished window | element type window 1 | m?K/W | Tab.Building.Measure | Real
  Data_Calc_UValEst$g_gl_n_Measure_Window_2 <-
      Data_Calc_UValEst$g_gl_n_PredefinedMeasure_Window_2 # <HQ13> | total solar energy transmittance for radiation perpendicular to the glazing, refurbished window | element type window 2 | m?K/W | Tab.Building.Measure | Real


  ###################################################################################X
  ## . Measure types  -----

  Data_Calc_UValEst$Code_MeasureType_Wall_2 <-
      Data_Calc_UValEst$Code_MeasureType_Wall_1 # <HU13> | code of the measure type | element type wall 2 | Tab.Const.MeasureType | VarChar
  Data_Calc_UValEst$Code_MeasureType_Wall_3 <-
      Data_Calc_UValEst$Code_MeasureType_Wall_2 # <HV13> | code of the measure type | element type wall 3 | Tab.Const.MeasureType | VarChar

  Data_Calc_UValEst$Code_MeasureType_Floor_2 <-
      Data_Calc_UValEst$Code_MeasureType_Floor_1 # <HX13> | code of the measure type | element type floor 2 | Tab.Const.MeasureType | VarChar

  Data_Calc_UValEst$Code_MeasureType_Window_1 <-
      'Replace' # <HY13> | code of the measure type | element type window 1 | Tab.Const.MeasureType | VarChar
  Data_Calc_UValEst$Code_MeasureType_Window_2 <-
      'Replace' # <HZ13> | code of the measure type | element type window 2 | Tab.Const.MeasureType | VarChar
  Data_Calc_UValEst$Code_MeasureType_Door_1 <-
      'Replace' # <IA13> | code of the measure type | element type door 1 | Tab.Const.MeasureType | VarChar


  ###################################################################################X
  ## . Thermal resistance of the construction before measure (replacing or adding insulation) -----


  Data_Calc_UValEst$R_Before_Roof_1 <-
      AuxFunctions::Replace_NA (
          ifelse (
              !is.na (Data_Calc_UValEst$R_Add_UnheatedSpace_Roof_1),
              Data_Calc_UValEst$R_Add_UnheatedSpace_Roof_1,
              0
          ) + ifelse (
              !is.na (Data_Calc_UValEst$U_Original_Roof_1),
              1 / Data_Calc_UValEst$U_Original_Roof_1 - ifelse (
                  AuxFunctions::xl_AND (
                      Data_Calc_UValEst$Code_MeasureType_Roof_1 == "ReplaceInsulation",
                      AuxFunctions::xl_NOT (is.na (Data_Calc_UValEst$R_Measure_Roof_1))
                  ),
                  Data_Calc_UValEst$d_Insulation_OriginalIncluded_Roof_1 / 0.04,
                  0
              ),
              0
          ),
          0
      ) # <JM13> | thermal resistance of element without insulation, considering the possibility to remove existing insulation during refurbishment | element type roof 1 | m?K/W | Real
  Data_Calc_UValEst$R_Before_Roof_2 <-
      AuxFunctions::Replace_NA (
          ifelse (
              !is.na (Data_Calc_UValEst$R_Add_UnheatedSpace_Roof_2),
              Data_Calc_UValEst$R_Add_UnheatedSpace_Roof_2,
              0
          ) + ifelse (
              !is.na (Data_Calc_UValEst$U_Original_Roof_2),
              1 / Data_Calc_UValEst$U_Original_Roof_2 - ifelse (
                  AuxFunctions::xl_AND (
                      Data_Calc_UValEst$Code_MeasureType_Roof_2 == "ReplaceInsulation",
                      AuxFunctions::xl_NOT (is.na (Data_Calc_UValEst$R_Measure_Roof_2))
                  ),
                  Data_Calc_UValEst$d_Insulation_OriginalIncluded_Roof_2 / 0.04,
                  0
              ),
              0
          ),
          0
      ) # <JN13> | thermal resistance of element without insulation, considering the possibility to remove existing insulation during refurbishment | element type roof 2 | m?K/W | Real
  Data_Calc_UValEst$R_Before_Wall_1 <-
      AuxFunctions::Replace_NA (
          ifelse (
              !is.na (Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_1),
              Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_1,
              0
          ) + ifelse (
              !is.na (Data_Calc_UValEst$U_Original_Wall_1),
              1 / Data_Calc_UValEst$U_Original_Wall_1 - ifelse (
                  AuxFunctions::xl_AND (
                      Data_Calc_UValEst$Code_MeasureType_Wall_1 == "ReplaceInsulation",
                      AuxFunctions::xl_NOT (is.na (Data_Calc_UValEst$R_Measure_Wall_1))
                  ),
                  Data_Calc_UValEst$d_Insulation_OriginalIncluded_Wall_1 / 0.04,
                  0
              ),
              0
          ),
          0
      ) # <JO13> | thermal resistance of element without insulation, considering the possibility to remove existing insulation during refurbishment | element type wall 1 | m?K/W | Real
  Data_Calc_UValEst$R_Before_Wall_2 <-
      AuxFunctions::Replace_NA (
          ifelse (
              !is.na (Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_2),
              Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_2,
              0
          ) + ifelse (
              !is.na (Data_Calc_UValEst$U_Original_Wall_2),
              1 / Data_Calc_UValEst$U_Original_Wall_2 - ifelse (
                  AuxFunctions::xl_AND (
                      Data_Calc_UValEst$Code_MeasureType_Wall_2 == "ReplaceInsulation",
                      AuxFunctions::xl_NOT (is.na (Data_Calc_UValEst$R_Measure_Wall_2))
                  ),
                  Data_Calc_UValEst$d_Insulation_OriginalIncluded_Wall_2 / 0.04,
                  0
              ),
              0
          ),
          0
      ) # <JP13> | thermal resistance of element without insulation, considering the possibility to remove existing insulation during refurbishment | element type wall 2 | m?K/W | Real
  Data_Calc_UValEst$R_Before_Wall_3 <-
      AuxFunctions::Replace_NA (
          ifelse (
              !is.na (Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_3),
              Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_3,
              0
          ) + ifelse (
              !is.na (Data_Calc_UValEst$U_Original_Wall_3),
              1 / Data_Calc_UValEst$U_Original_Wall_3 - ifelse (
                  AuxFunctions::xl_AND (
                      Data_Calc_UValEst$Code_MeasureType_Wall_3 == "ReplaceInsulation",
                      AuxFunctions::xl_NOT (is.na (Data_Calc_UValEst$R_Measure_Wall_3))
                  ),
                  Data_Calc_UValEst$d_Insulation_OriginalIncluded_Wall_3 / 0.04,
                  0
              ),
              0
          ),
          0
      ) # <JQ13> | thermal resistance of element without insulation, considering the possibility to remove existing insulation during refurbishment | element type wall 3 | m?K/W | Real
  Data_Calc_UValEst$R_Before_Floor_1 <-
      AuxFunctions::Replace_NA (
          ifelse (
              !is.na (Data_Calc_UValEst$R_Add_UnheatedSpace_Floor_1),
              Data_Calc_UValEst$R_Add_UnheatedSpace_Floor_1,
              0
          ) + ifelse (
              !is.na (Data_Calc_UValEst$U_Original_Floor_1),
              1 / Data_Calc_UValEst$U_Original_Floor_1 - ifelse (
                  AuxFunctions::xl_AND (
                      Data_Calc_UValEst$Code_MeasureType_Floor_1 == "ReplaceInsulation",
                      AuxFunctions::xl_NOT (is.na (Data_Calc_UValEst$R_Measure_Floor_1))
                  ),
                  Data_Calc_UValEst$d_Insulation_OriginalIncluded_Floor_1 / 0.04,
                  0
              ),
              0
          ),
          0
      ) # <JR13> | thermal resistance of element without insulation, considering the possibility to remove existing insulation during refurbishment | element type floor 1 | m?K/W | Real
  Data_Calc_UValEst$R_Before_Floor_2 <-
      AuxFunctions::Replace_NA (
          ifelse (
              !is.na (Data_Calc_UValEst$R_Add_UnheatedSpace_Floor_2),
              Data_Calc_UValEst$R_Add_UnheatedSpace_Floor_2,
              0
          ) + ifelse (
              !is.na (Data_Calc_UValEst$U_Original_Floor_2),
              1 / Data_Calc_UValEst$U_Original_Floor_2 - ifelse (
                  AuxFunctions::xl_AND (
                      Data_Calc_UValEst$Code_MeasureType_Floor_2 == "ReplaceInsulation",
                      AuxFunctions::xl_NOT (is.na (Data_Calc_UValEst$R_Measure_Floor_2))
                  ),
                  Data_Calc_UValEst$d_Insulation_OriginalIncluded_Floor_2 / 0.04,
                  0
              ),
              0
          ),
          0
      ) # <JS13> | thermal resistance of element without insulation, considering the possibility to remove existing insulation during refurbishment | element type floor 2 | m?K/W | Real

  Data_Calc_UValEst$R_Before_Window_1 <-
      AuxFunctions::Replace_NA (ifelse (
          !is.na (Data_Calc_UValEst$U_Original_Window_1),
          1 / Data_Calc_UValEst$U_Original_Window_1,
          0
      ), 0) # <JT13> | thermal resistance of element before refurbishment | element type window 1 | m?K/W | Real
  Data_Calc_UValEst$R_Before_Window_2 <-
      AuxFunctions::Replace_NA (ifelse (
          !is.na (Data_Calc_UValEst$U_Original_Window_2),
          1 / Data_Calc_UValEst$U_Original_Window_2,
          0
      ), 0) # <JU13> | thermal resistance of element without insulation, in case that existing insulation is removed during refurbishment | element type window 2 | m?K/W | Real
  Data_Calc_UValEst$R_Before_Door_1 <-
      AuxFunctions::Replace_NA (ifelse (
          !is.na (Data_Calc_UValEst$U_Original_Door_1),
          1 / Data_Calc_UValEst$U_Original_Door_1,
          0
      ), 0) # <JV13> | thermal resistance of element without insulation, in case that existing insulation is removed during refurbishment | element type door 1 | m?K/W | Real


  ###################################################################################X
  ## . U-value of the area where an insulation measure is applied -----

  Data_Calc_UValEst$U_Measure_Roof_1 <-
      AuxFunctions::Replace_NA (1 / (
          ifelse (
              Data_Calc_UValEst$Code_MeasureType_Roof_1 == "Replace",
              ifelse (
                  !is.na (Data_Calc_UValEst$R_Add_UnheatedSpace_Roof_1),
                  Data_Calc_UValEst$R_Add_UnheatedSpace_Roof_1,
                  0
              ),
              Data_Calc_UValEst$R_Before_Roof_1
          ) + ifelse (
              !is.na (Data_Calc_UValEst$R_Measure_Roof_1),
              Data_Calc_UValEst$R_Measure_Roof_1,
              0
          )
      ), 0) # <JW13> | effective U-value of the refurbished area fraction of the construction element, considering also thermal resistance of unheated spaces (if existent) | element type roof 1 | W/(m?K) | Real | 2020-01-21 iwu/tl: formula changed --> now case "_NA_" included | 2020-01-24 iwu/tl: r?ckg?ngig gemacht
  Data_Calc_UValEst$U_Measure_Roof_2 <-
      AuxFunctions::Replace_NA (1 / (
          ifelse (
              Data_Calc_UValEst$Code_MeasureType_Roof_2 == "Replace",
              ifelse (
                  !is.na (Data_Calc_UValEst$R_Add_UnheatedSpace_Roof_2),
                  Data_Calc_UValEst$R_Add_UnheatedSpace_Roof_2,
                  0
              ),
              Data_Calc_UValEst$R_Before_Roof_2
          ) + ifelse (
              !is.na (Data_Calc_UValEst$R_Measure_Roof_2),
              Data_Calc_UValEst$R_Measure_Roof_2,
              0
          )
      ), 0) # <JX13> | effective U-value of the refurbished area fraction of the construction element, considering also thermal resistance of unheated spaces (if existent) | element type roof 2 | W/(m?K) | Real | 2020-01-21 iwu/tl: formula changed --> now case "_NA_" included | 2020-01-24 iwu/tl: r?ckg?ngig gemacht
  Data_Calc_UValEst$U_Measure_Wall_1 <-
      AuxFunctions::Replace_NA (1 / (
          ifelse (
              Data_Calc_UValEst$Code_MeasureType_Wall_1 == "Replace",
              ifelse (
                  !is.na (Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_1),
                  Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_1,
                  0
              ),
              Data_Calc_UValEst$R_Before_Wall_1
          ) + ifelse (
              !is.na (Data_Calc_UValEst$R_Measure_Wall_1),
              Data_Calc_UValEst$R_Measure_Wall_1,
              0
          )
      ), 0) # <JY13> | effective U-value of the refurbished area fraction of the construction element, considering also thermal resistance of unheated spaces (if existent) | element type wall 1 | W/(m?K) | Real | 2020-01-21 iwu/tl: formula changed --> now case "_NA_" included | 2020-01-24 iwu/tl: r?ckg?ngig gemacht
  Data_Calc_UValEst$U_Measure_Wall_2 <-
      AuxFunctions::Replace_NA (1 / (
          ifelse (
              Data_Calc_UValEst$Code_MeasureType_Wall_2 == "Replace",
              ifelse (
                  !is.na (Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_2),
                  Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_2,
                  0
              ),
              Data_Calc_UValEst$R_Before_Wall_2
          ) + ifelse (
              !is.na (Data_Calc_UValEst$R_Measure_Wall_2),
              Data_Calc_UValEst$R_Measure_Wall_2,
              0
          )
      ), 0) # <JZ13> | effective U-value of the refurbished area fraction of the construction element, considering also thermal resistance of unheated spaces (if existent) | element type wall 2 | W/(m?K) | Real | 2020-01-21 iwu/tl: formula changed --> now case "_NA_" included | 2020-01-24 iwu/tl: r?ckg?ngig gemacht
  Data_Calc_UValEst$U_Measure_Wall_3 <-
      AuxFunctions::Replace_NA (1 / (
          ifelse (
              Data_Calc_UValEst$Code_MeasureType_Wall_3 == "Replace",
              ifelse (
                  !is.na (Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_3),
                  Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_3,
                  0
              ),
              Data_Calc_UValEst$R_Before_Wall_3
          ) + ifelse (
              !is.na (Data_Calc_UValEst$R_Measure_Wall_3),
              Data_Calc_UValEst$R_Measure_Wall_3,
              0
          )
      ), 0) # <KA13> | effective U-value of the refurbished area fraction of the construction element, considering also thermal resistance of unheated spaces (if existent) | element type wall 3 | W/(m?K) | Real | 2020-01-21 iwu/tl: formula changed --> now case "_NA_" included | 2020-01-24 iwu/tl: r?ckg?ngig gemacht
  Data_Calc_UValEst$U_Measure_Floor_1 <-
      AuxFunctions::Replace_NA (1 / (
          ifelse (
              Data_Calc_UValEst$Code_MeasureType_Floor_1 == "Replace",
              ifelse (
                  !is.na (Data_Calc_UValEst$R_Add_UnheatedSpace_Floor_1),
                  Data_Calc_UValEst$R_Add_UnheatedSpace_Floor_1,
                  0
              ),
              Data_Calc_UValEst$R_Before_Floor_1
          ) + ifelse (
              !is.na (Data_Calc_UValEst$R_Measure_Floor_1),
              Data_Calc_UValEst$R_Measure_Floor_1,
              0
          )
      ), 0) # <KB13> | effective U-value of the refurbished area fraction of the construction element, considering also thermal resistance of unheated spaces (if existent) | element type floor 1 | W/(m?K) | Real | 2020-01-21 iwu/tl: formula changed --> now case "_NA_" included | 2020-01-24 iwu/tl: r?ckg?ngig gemacht
  Data_Calc_UValEst$U_Measure_Floor_2 <-
      AuxFunctions::Replace_NA (1 / (
          ifelse (
              Data_Calc_UValEst$Code_MeasureType_Floor_2 == "Replace",
              ifelse (
                  !is.na (Data_Calc_UValEst$R_Add_UnheatedSpace_Floor_2),
                  Data_Calc_UValEst$R_Add_UnheatedSpace_Floor_2,
                  0
              ),
              Data_Calc_UValEst$R_Before_Floor_2
          ) + ifelse (
              !is.na (Data_Calc_UValEst$R_Measure_Floor_2),
              Data_Calc_UValEst$R_Measure_Floor_2,
              0
          )
      ), 0) # <KC13> | effective U-value of the refurbished area fraction of the construction element, considering also thermal resistance of unheated spaces (if existent) | element type floor 2 | W/(m?K) | Real | 2020-01-21 iwu/tl: formula changed --> now case "_NA_" included | 2020-01-24 iwu/tl: r?ckg?ngig gemacht
  Data_Calc_UValEst$U_Measure_Window_1 <-
      AuxFunctions::Replace_NA (1 / (
          ifelse (
              Data_Calc_UValEst$Code_MeasureType_Window_1 == "Replace",
              0,
              Data_Calc_UValEst$R_Before_Window_1
          ) + ifelse (
              !is.na (Data_Calc_UValEst$R_Measure_Window_1),
              Data_Calc_UValEst$R_Measure_Window_1,
              0
          )
      ), 0) # <KD13> | U-value of the refurbished area fraction of the construction element | element type window 1 | W/(m?K) | Real
  Data_Calc_UValEst$U_Measure_Window_2 <-
      AuxFunctions::Replace_NA (1 / (
          ifelse (
              Data_Calc_UValEst$Code_MeasureType_Window_2 == "Replace",
              0,
              Data_Calc_UValEst$R_Before_Window_2
          ) + ifelse (
              !is.na (Data_Calc_UValEst$R_Measure_Window_2),
              Data_Calc_UValEst$R_Measure_Window_2,
              0
          )
      ), 0) # <KE13> | U-value of the refurbished area fraction of the construction element | element type window 2 | W/(m?K) | Real
  Data_Calc_UValEst$U_Measure_Door_1 <-
      AuxFunctions::Replace_NA (1 / (
          ifelse (
              Data_Calc_UValEst$Code_MeasureType_Door_1 == "Replace",
              0,
              Data_Calc_UValEst$R_Before_Door_1
          ) + ifelse (
              !is.na (Data_Calc_UValEst$R_Measure_Door_1),
              Data_Calc_UValEst$R_Measure_Door_1,
              0
          )
      ), 0) # <KF13> | U-value of the refurbished area fraction of the construction element | element type door 1 | W/(m?K) | Real


  ###################################################################################X
  ## . Resulting U-value considering areas with and without applied measures -----

  Data_Calc_UValEst$U_Actual_Roof_1 <-
      ifelse (
          Data_Calc_UValEst$U_Original_Roof_1 > 0,
          (1 - Data_Calc_UValEst$f_Measure_Roof_1) * 1 / (
              1 / Data_Calc_UValEst$U_Original_Roof_1 + Data_Calc_UValEst$R_Add_UnheatedSpace_Roof_1
          ),
          0
      ) + Data_Calc_UValEst$f_Measure_Roof_1 * Data_Calc_UValEst$U_Measure_Roof_1 # <KG13> | actual U-value of the construction element after refurbishment, considering also the additional thermal resistance due to unheated space bordering at the construction element | element type roof 1 | W/(m?K) | Real
  Data_Calc_UValEst$U_Actual_Roof_2 <-
      ifelse (
          Data_Calc_UValEst$U_Original_Roof_2 > 0,
          (1 - Data_Calc_UValEst$f_Measure_Roof_2) * 1 / (
              1 / Data_Calc_UValEst$U_Original_Roof_2 + Data_Calc_UValEst$R_Add_UnheatedSpace_Roof_2
          ),
          0
      ) + Data_Calc_UValEst$f_Measure_Roof_2 * Data_Calc_UValEst$U_Measure_Roof_2 # <KH13> | actual U-value of the construction element after refurbishment, considering also the additional thermal resistance due to unheated space bordering at the construction element | element type roof 2 | W/(m?K) | Real
  Data_Calc_UValEst$U_Actual_Wall_1 <-
      ifelse (
          Data_Calc_UValEst$U_Original_Wall_1 > 0,
          (1 - Data_Calc_UValEst$f_Measure_Wall_1) * 1 / (
              1 / Data_Calc_UValEst$U_Original_Wall_1 + Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_1
          ),
          0
      ) + Data_Calc_UValEst$f_Measure_Wall_1 * Data_Calc_UValEst$U_Measure_Wall_1 # <KI13> | actual U-value of the construction element after refurbishment, considering also the additional thermal resistance due to unheated space bordering at the construction element | element type wall 1 | W/(m?K) | Real
  Data_Calc_UValEst$U_Actual_Wall_2 <-
      ifelse (
          Data_Calc_UValEst$U_Original_Wall_2 > 0,
          (1 - Data_Calc_UValEst$f_Measure_Wall_2) * 1 / (
              1 / Data_Calc_UValEst$U_Original_Wall_2 + Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_2
          ),
          0
      ) + Data_Calc_UValEst$f_Measure_Wall_2 * Data_Calc_UValEst$U_Measure_Wall_2 # <KJ13> | actual U-value of the construction element after refurbishment, considering also the additional thermal resistance due to unheated space bordering at the construction element | element type wall 2 | W/(m?K) | Real
  Data_Calc_UValEst$U_Actual_Wall_3 <-
      ifelse (
          Data_Calc_UValEst$U_Original_Wall_3 > 0,
          (1 - Data_Calc_UValEst$f_Measure_Wall_3) * 1 / (
              1 / Data_Calc_UValEst$U_Original_Wall_3 + Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_3
          ),
          0
      ) + Data_Calc_UValEst$f_Measure_Wall_3 * Data_Calc_UValEst$U_Measure_Wall_3 # <KK13> | actual U-value of the construction element after refurbishment, considering also the additional thermal resistance due to unheated space bordering at the construction element | element type wall 3 | W/(m?K) | Real
  Data_Calc_UValEst$U_Actual_Floor_1 <-
      ifelse (
          Data_Calc_UValEst$U_Original_Floor_1 > 0,
          (1 - Data_Calc_UValEst$f_Measure_Floor_1) * 1 / (
              1 / Data_Calc_UValEst$U_Original_Floor_1 + Data_Calc_UValEst$R_Add_UnheatedSpace_Floor_1
          ),
          0
      ) + Data_Calc_UValEst$f_Measure_Floor_1 * Data_Calc_UValEst$U_Measure_Floor_1 # <KL13> | actual U-value of the construction element after refurbishment, considering also the additional thermal resistance due to unheated space bordering at the construction element | element type floor 1 | W/(m?K) | Real
  Data_Calc_UValEst$U_Actual_Floor_2 <-
      ifelse (
          Data_Calc_UValEst$U_Original_Floor_2 > 0,
          (1 - Data_Calc_UValEst$f_Measure_Floor_2) * 1 / (
              1 / Data_Calc_UValEst$U_Original_Floor_2 + Data_Calc_UValEst$R_Add_UnheatedSpace_Floor_2
          ),
          0
      ) + Data_Calc_UValEst$f_Measure_Floor_2 * Data_Calc_UValEst$U_Measure_Floor_2 # <KM13> | actual U-value of the construction element after refurbishment, considering also the additional thermal resistance due to unheated space bordering at the construction element | element type floor 2 | W/(m?K) | Real

  Data_Calc_UValEst$U_Actual_Window_1 <-
      (1 - Data_Calc_UValEst$f_Measure_Window_1) * Data_Calc_UValEst$U_Original_Window_1 + Data_Calc_UValEst$f_Measure_Window_1 * Data_Calc_UValEst$U_Measure_Window_1 # <KN13> | actual U-value of the construction element after refurbishment | element type window 1 | W/(m?K) | Real
  Data_Calc_UValEst$U_Actual_Window_2 <-
      (1 - Data_Calc_UValEst$f_Measure_Window_2) * Data_Calc_UValEst$U_Original_Window_2 + Data_Calc_UValEst$f_Measure_Window_2 * Data_Calc_UValEst$U_Measure_Window_2 # <KO13> | actual U-value of the construction element after refurbishment | element type window 2 | W/(m?K) | Real
  Data_Calc_UValEst$U_Actual_Door_1 <-
      (1 - Data_Calc_UValEst$f_Measure_Door_1) * Data_Calc_UValEst$U_Original_Door_1 + Data_Calc_UValEst$f_Measure_Door_1 * Data_Calc_UValEst$U_Measure_Door_1 # <KP13> | actual U-value of the construction element after refurbishment | element type door 1 | W/(m?K) | Real

  #. --------------------------------------------------------------------------------------------------


  ###################################################################################X
  #  4 OUTPUT  -----
  ###################################################################################X


  ###################################################################################X
  ##  . Return dataframe "myCalcData" including new calculation variables   ------


  # Data_Output <- NA
  # Data_Output            <- as.data.frame (myCalcData [, "ID_Dataset"])
  # colnames (Data_Output) <- "ID_Dataset"

  myCalcData$Date_Change                              <- TimeStampForDataset ()

  # myCalcData$Code_Country                             <- Data_Calc_UValEst$Code_Country
  # myCalcData$Code_Building                            <- Data_Calc_UValEst$Code_Building
  myCalcData$Year1_Building                           <- Data_Calc_UValEst$Year1_Building

  myCalcData$Code_BuildingSize                        <- Data_Calc_UValEst$Code_BuildingSize

  myCalcData$Code_ThermalBridging_Original            <- Data_Calc_UValEst$Code_ThermalBridging_Original
  myCalcData$Code_ThermalBridging_Refurbished         <- Data_Calc_UValEst$Code_ThermalBridging_Refurbished
  myCalcData$Code_Infiltration_Actual                 <- Data_Calc_UValEst$Code_Infiltration_Actual

  myCalcData$Code_Roof_01                             <- Data_Calc_UValEst$Code_Roof_1
  myCalcData$Code_Roof_02                             <- Data_Calc_UValEst$Code_Roof_2
  myCalcData$Code_Wall_01                             <- Data_Calc_UValEst$Code_Wall_1
  myCalcData$Code_Wall_02                             <- Data_Calc_UValEst$Code_Wall_2
  myCalcData$Code_Wall_03                             <- Data_Calc_UValEst$Code_Wall_3
  myCalcData$Code_Floor_01                            <- Data_Calc_UValEst$Code_Floor_1
  myCalcData$Code_Floor_02                            <- Data_Calc_UValEst$Code_Floor_2
  myCalcData$Code_Window_01                           <- Data_Calc_UValEst$Code_Window_1
  myCalcData$Code_Window_02                           <- Data_Calc_UValEst$Code_Window_2
  myCalcData$Code_Door_01                             <- Data_Calc_UValEst$Code_Door_1

  myCalcData$Code_ConstructionBorder_Roof_01          <- Data_Calc_UValEst$Code_ConstructionBorder_Roof_1
  myCalcData$Code_ConstructionBorder_Roof_02          <- Data_Calc_UValEst$Code_ConstructionBorder_Roof_2
  myCalcData$Code_ConstructionBorder_Wall_01          <- Data_Calc_UValEst$Code_ConstructionBorder_Wall_1
  myCalcData$Code_ConstructionBorder_Wall_02          <- Data_Calc_UValEst$Code_ConstructionBorder_Wall_2
  myCalcData$Code_ConstructionBorder_Wall_03          <- Data_Calc_UValEst$Code_ConstructionBorder_Wall_3
  myCalcData$Code_ConstructionBorder_Floor_01         <- Data_Calc_UValEst$Code_ConstructionBorder_Floor_1
  myCalcData$Code_ConstructionBorder_Floor_02         <- Data_Calc_UValEst$Code_ConstructionBorder_Floor_2

  myCalcData$delta_U_ThermalBridging_Original         <- round (Data_Calc_UValEst$delta_U_ThermalBridging_Original, digits = 3)
  myCalcData$delta_U_ThermalBridging_Refurbished      <- round (Data_Calc_UValEst$delta_U_ThermalBridging_Refurbished, digits = 3)
  myCalcData$n_air_infiltration                       <- round (Data_Calc_UValEst$n_air_infiltration, digits = 3)

  myCalcData$U_Original_Roof_01                       <- round (Data_Calc_UValEst$U_Original_Roof_1, digits = 3)
  myCalcData$U_Original_Roof_02                       <- round (Data_Calc_UValEst$U_Original_Roof_2, digits = 3)
  myCalcData$U_Original_Wall_01                       <- round (Data_Calc_UValEst$U_Original_Wall_1, digits = 3)
  myCalcData$U_Original_Wall_02                       <- round (Data_Calc_UValEst$U_Original_Wall_2, digits = 3)
  myCalcData$U_Original_Wall_03                       <- round (Data_Calc_UValEst$U_Original_Wall_3, digits = 3)
  myCalcData$U_Original_Floor_01                      <- round (Data_Calc_UValEst$U_Original_Floor_1, digits = 3)
  myCalcData$U_Original_Floor_02                      <- round (Data_Calc_UValEst$U_Original_Floor_2, digits = 3)
  myCalcData$U_Original_Window_01                     <- round (Data_Calc_UValEst$U_Original_Window_1, digits = 3)
  myCalcData$U_Original_Window_02                     <- round (Data_Calc_UValEst$U_Original_Window_2, digits = 3)
  myCalcData$U_Original_Door_01                       <- round (Data_Calc_UValEst$U_Original_Door_1, digits = 3)
  myCalcData$g_gl_n_Window_01                         <- round (Data_Calc_UValEst$g_gl_n_Window_1, digits = 3)
  myCalcData$g_gl_n_Window_02                         <- round (Data_Calc_UValEst$g_gl_n_Window_2, digits = 3)

  myCalcData$d_Insulation_OriginalIncluded_Roof_01    <- round (Data_Calc_UValEst$d_Insulation_OriginalIncluded_Roof_1, digits = 1)
  myCalcData$d_Insulation_OriginalIncluded_Roof_02    <- round (Data_Calc_UValEst$d_Insulation_OriginalIncluded_Roof_2, digits = 1)
  myCalcData$d_Insulation_OriginalIncluded_Wall_01    <- round (Data_Calc_UValEst$d_Insulation_OriginalIncluded_Wall_1, digits = 1)
  myCalcData$d_Insulation_OriginalIncluded_Wall_02    <- round (Data_Calc_UValEst$d_Insulation_OriginalIncluded_Wall_2, digits = 1)
  myCalcData$d_Insulation_OriginalIncluded_Wall_03    <- round (Data_Calc_UValEst$d_Insulation_OriginalIncluded_Wall_3, digits = 1)
  myCalcData$d_Insulation_OriginalIncluded_Floor_01   <- round (Data_Calc_UValEst$d_Insulation_OriginalIncluded_Floor_1, digits = 1)
  myCalcData$d_Insulation_OriginalIncluded_Floor_02   <- round (Data_Calc_UValEst$d_Insulation_OriginalIncluded_Floor_2, digits = 1)

  myCalcData$R_Add_UnheatedSpace_Roof_01              <- round (Data_Calc_UValEst$R_Add_UnheatedSpace_Roof_1, digits = 3)
  myCalcData$R_Add_UnheatedSpace_Roof_02              <- round (Data_Calc_UValEst$R_Add_UnheatedSpace_Roof_2, digits = 3)
  myCalcData$R_Add_UnheatedSpace_Wall_01              <- round (Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_1, digits = 3)
  myCalcData$R_Add_UnheatedSpace_Wall_02              <- round (Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_2, digits = 3)
  myCalcData$R_Add_UnheatedSpace_Wall_03              <- round (Data_Calc_UValEst$R_Add_UnheatedSpace_Wall_3, digits = 3)
  myCalcData$R_Add_UnheatedSpace_Floor_01             <- round (Data_Calc_UValEst$R_Add_UnheatedSpace_Floor_1, digits = 3)
  myCalcData$R_Add_UnheatedSpace_Floor_02             <- round (Data_Calc_UValEst$R_Add_UnheatedSpace_Floor_2, digits = 3)

  myCalcData$b_Transmission_Roof_01                   <- round (Data_Calc_UValEst$b_Transmission_Roof_1, digits = 3)
  myCalcData$b_Transmission_Roof_02                   <- round (Data_Calc_UValEst$b_Transmission_Roof_2, digits = 3)
  myCalcData$b_Transmission_Wall_01                   <- round (Data_Calc_UValEst$b_Transmission_Wall_1, digits = 3)
  myCalcData$b_Transmission_Wall_02                   <- round (Data_Calc_UValEst$b_Transmission_Wall_2, digits = 3)
  myCalcData$b_Transmission_Wall_03                   <- round (Data_Calc_UValEst$b_Transmission_Wall_3, digits = 3)
  myCalcData$b_Transmission_Floor_01                  <- round (Data_Calc_UValEst$b_Transmission_Floor_1, digits = 3)
  myCalcData$b_Transmission_Floor_02                  <- round (Data_Calc_UValEst$b_Transmission_Floor_2, digits = 3)

  myCalcData$Code_Measure_Window_01                   <- Data_Calc_UValEst$Code_Measure_Window_1
  myCalcData$Code_Measure_Window_02                   <- Data_Calc_UValEst$Code_Measure_Window_2
  myCalcData$Code_Measure_Door_01                     <- Data_Calc_UValEst$Code_Measure_Door_1

  myCalcData$R_PredefinedMeasure_Roof_01              <- round (Data_Calc_UValEst$R_PredefinedMeasure_Roof_1, digits = 3)
  myCalcData$R_PredefinedMeasure_Roof_02              <- round (Data_Calc_UValEst$R_PredefinedMeasure_Roof_2, digits = 3)
  myCalcData$R_PredefinedMeasure_Wall_01              <- round (Data_Calc_UValEst$R_PredefinedMeasure_Wall_1, digits = 3)
  myCalcData$R_PredefinedMeasure_Wall_02              <- round (Data_Calc_UValEst$R_PredefinedMeasure_Wall_2, digits = 3)
  myCalcData$R_PredefinedMeasure_Wall_03              <- round (Data_Calc_UValEst$R_PredefinedMeasure_Wall_3, digits = 3)
  myCalcData$R_PredefinedMeasure_Floor_01             <- round (Data_Calc_UValEst$R_PredefinedMeasure_Floor_1, digits = 3)
  myCalcData$R_PredefinedMeasure_Floor_02             <- round (Data_Calc_UValEst$R_PredefinedMeasure_Floor_2, digits = 3)
  myCalcData$R_PredefinedMeasure_Window_01            <- round (Data_Calc_UValEst$R_PredefinedMeasure_Window_1, digits = 3)
  myCalcData$R_PredefinedMeasure_Window_02            <- round (Data_Calc_UValEst$R_PredefinedMeasure_Window_2, digits = 3)
  myCalcData$R_PredefinedMeasure_Door_01              <- round (Data_Calc_UValEst$R_PredefinedMeasure_Door_1, digits = 3)
  myCalcData$g_gl_n_PredefinedMeasure_Window_01       <- round (Data_Calc_UValEst$g_gl_n_PredefinedMeasure_Window_1, digits = 3)
  myCalcData$g_gl_n_PredefinedMeasure_Window_02       <- round (Data_Calc_UValEst$g_gl_n_PredefinedMeasure_Window_2, digits = 3)

  myCalcData$d_Insulation_PredefinedMeasure_Roof_01   <- round (Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Roof_1, digits = 3)
  myCalcData$d_Insulation_PredefinedMeasure_Roof_02   <- round (Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Roof_2, digits = 3)
  myCalcData$d_Insulation_PredefinedMeasure_Wall_01   <- round (Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Wall_1, digits = 3)
  myCalcData$d_Insulation_PredefinedMeasure_Wall_02   <- round (Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Wall_2, digits = 3)
  myCalcData$d_Insulation_PredefinedMeasure_Wall_03   <- round (Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Wall_3, digits = 3)
  myCalcData$d_Insulation_PredefinedMeasure_Floor_01  <- round (Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Floor_1, digits = 3)
  myCalcData$d_Insulation_PredefinedMeasure_Floor_02  <- round (Data_Calc_UValEst$d_Insulation_PredefinedMeasure_Floor_2, digits = 3)

  myCalcData$d_Insulation_Input_Measure_Roof_01       <- round (Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_1, digits = 3)
  myCalcData$d_Insulation_Input_Measure_Roof_02       <- round (Data_Calc_UValEst$d_Insulation_Input_Measure_Roof_2, digits = 3)
  myCalcData$d_Insulation_Input_Measure_Wall_01       <- round (Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_1, digits = 3)
  myCalcData$d_Insulation_Input_Measure_Wall_02       <- round (Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_2, digits = 3)
  myCalcData$d_Insulation_Input_Measure_Wall_03       <- round (Data_Calc_UValEst$d_Insulation_Input_Measure_Wall_3, digits = 3)
  myCalcData$d_Insulation_Input_Measure_Floor_01      <- round (Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_1, digits = 3)
  myCalcData$d_Insulation_Input_Measure_Floor_02      <- round (Data_Calc_UValEst$d_Insulation_Input_Measure_Floor_2, digits = 3)
  myCalcData$d_Insulation_Measure_Roof_01             <- round (Data_Calc_UValEst$d_Insulation_Measure_Roof_1, digits = 3)
  myCalcData$d_Insulation_Measure_Roof_02             <- round (Data_Calc_UValEst$d_Insulation_Measure_Roof_2, digits = 3)
  myCalcData$d_Insulation_Measure_Wall_01             <- round (Data_Calc_UValEst$d_Insulation_Measure_Wall_1, digits = 3)
  myCalcData$d_Insulation_Measure_Wall_02             <- round (Data_Calc_UValEst$d_Insulation_Measure_Wall_2, digits = 3)
  myCalcData$d_Insulation_Measure_Wall_03             <- round (Data_Calc_UValEst$d_Insulation_Measure_Wall_3, digits = 3)
  myCalcData$d_Insulation_Measure_Floor_01            <- round (Data_Calc_UValEst$d_Insulation_Measure_Floor_1, digits = 3)
  myCalcData$d_Insulation_Measure_Floor_02            <- round (Data_Calc_UValEst$d_Insulation_Measure_Floor_2, digits = 3)

  myCalcData$R_Measure_Roof_01                        <- round (Data_Calc_UValEst$R_Measure_Roof_1, digits = 3)
  myCalcData$R_Measure_Roof_02                        <- round (Data_Calc_UValEst$R_Measure_Roof_2, digits = 3)
  myCalcData$R_Measure_Wall_01                        <- round (Data_Calc_UValEst$R_Measure_Wall_1, digits = 3)
  myCalcData$R_Measure_Wall_02                        <- round (Data_Calc_UValEst$R_Measure_Wall_2, digits = 3)
  myCalcData$R_Measure_Wall_03                        <- round (Data_Calc_UValEst$R_Measure_Wall_3, digits = 3)
  myCalcData$R_Measure_Floor_01                       <- round (Data_Calc_UValEst$R_Measure_Floor_1, digits = 3)
  myCalcData$R_Measure_Floor_02                       <- round (Data_Calc_UValEst$R_Measure_Floor_2, digits = 3)
  myCalcData$R_Measure_Window_01                      <- round (Data_Calc_UValEst$R_Measure_Window_1, digits = 3)
  myCalcData$R_Measure_Window_02                      <- round (Data_Calc_UValEst$R_Measure_Window_2, digits = 3)
  myCalcData$R_Measure_Door_01                        <- round (Data_Calc_UValEst$R_Measure_Door_1, digits = 3)
  myCalcData$g_gl_n_Measure_Window_01                 <- round (Data_Calc_UValEst$g_gl_n_Measure_Window_1, digits = 3)
  myCalcData$g_gl_n_Measure_Window_02                 <- round (Data_Calc_UValEst$g_gl_n_Measure_Window_2, digits = 3)

  myCalcData$Code_MeasureType_Roof_01                 <- Data_Calc_UValEst$Code_MeasureType_Roof_1
  myCalcData$Code_MeasureType_Roof_02                 <- Data_Calc_UValEst$Code_MeasureType_Roof_2
  myCalcData$Code_MeasureType_Wall_01                 <- Data_Calc_UValEst$Code_MeasureType_Wall_1
  myCalcData$Code_MeasureType_Wall_02                 <- Data_Calc_UValEst$Code_MeasureType_Wall_2
  myCalcData$Code_MeasureType_Wall_03                 <- Data_Calc_UValEst$Code_MeasureType_Wall_3
  myCalcData$Code_MeasureType_Floor_01                <- Data_Calc_UValEst$Code_MeasureType_Floor_1
  myCalcData$Code_MeasureType_Floor_02                <- Data_Calc_UValEst$Code_MeasureType_Floor_2
  myCalcData$Code_MeasureType_Window_01               <- Data_Calc_UValEst$Code_MeasureType_Window_1
  myCalcData$Code_MeasureType_Window_02               <- Data_Calc_UValEst$Code_MeasureType_Window_2
  myCalcData$Code_MeasureType_Door_01                 <- Data_Calc_UValEst$Code_MeasureType_Door_1

  myCalcData$Code_U_Class_WindowType1_nPane           <- Data_Calc_UValEst$Code_U_Class_WindowType1_nPane
  myCalcData$Code_U_Class_WindowType2_nPane           <- Data_Calc_UValEst$Code_U_Class_WindowType2_nPane

  myCalcData$Year_Installation_WindowType1_Calc       <- Data_Calc_UValEst$Year_Installation_WindowType1_Calc
  myCalcData$Year_Installation_WindowType2_Calc       <- Data_Calc_UValEst$Year_Installation_WindowType2_Calc
  myCalcData$Code_U_Class_WindowType1_FrameMaterial   <- Data_Calc_UValEst$Code_U_Class_WindowType1_FrameMaterial
  myCalcData$Code_U_Class_WindowType2_FrameMaterial   <- Data_Calc_UValEst$Code_U_Class_WindowType2_FrameMaterial
  myCalcData$Code_U_Class_WindowType1_LowE            <- Data_Calc_UValEst$Code_U_Class_WindowType1_LowE
  myCalcData$Code_U_Class_WindowType2_LowE            <- Data_Calc_UValEst$Code_U_Class_WindowType2_LowE

  myCalcData$f_Measure_Roof_01                        <- round (Data_Calc_UValEst$f_Measure_Roof_1, digits = 3)
  myCalcData$f_Measure_Roof_02                        <- round (Data_Calc_UValEst$f_Measure_Roof_2, digits = 3)
  myCalcData$f_Measure_Wall_01                        <- round (Data_Calc_UValEst$f_Measure_Wall_1, digits = 3)
  myCalcData$f_Measure_Wall_02                        <- round (Data_Calc_UValEst$f_Measure_Wall_2, digits = 3)
  myCalcData$f_Measure_Wall_03                        <- round (Data_Calc_UValEst$f_Measure_Wall_3, digits = 3)
  myCalcData$f_Measure_Floor_01                       <- round (Data_Calc_UValEst$f_Measure_Floor_1, digits = 3)
  myCalcData$f_Measure_Floor_02                       <- round (Data_Calc_UValEst$f_Measure_Floor_2, digits = 3)
  myCalcData$f_Measure_Window_01                      <- round (Data_Calc_UValEst$f_Measure_Window_1, digits = 3)
  myCalcData$f_Measure_Window_02                      <- round (Data_Calc_UValEst$f_Measure_Window_2, digits = 3)
  myCalcData$f_Measure_Door_01                        <- round (Data_Calc_UValEst$f_Measure_Door_1, digits = 3)

  myCalcData$R_Before_Roof_01                         <- round (Data_Calc_UValEst$R_Before_Roof_1, digits = 3)
  myCalcData$R_Before_Roof_02                         <- round (Data_Calc_UValEst$R_Before_Roof_2, digits = 3)
  myCalcData$R_Before_Wall_01                         <- round (Data_Calc_UValEst$R_Before_Wall_1, digits = 3)
  myCalcData$R_Before_Wall_02                         <- round (Data_Calc_UValEst$R_Before_Wall_2, digits = 3)
  myCalcData$R_Before_Wall_03                         <- round (Data_Calc_UValEst$R_Before_Wall_3, digits = 3)
  myCalcData$R_Before_Floor_01                        <- round (Data_Calc_UValEst$R_Before_Floor_1, digits = 3)
  myCalcData$R_Before_Floor_02                        <- round (Data_Calc_UValEst$R_Before_Floor_2, digits = 3)
  myCalcData$R_Before_Window_01                       <- round (Data_Calc_UValEst$R_Before_Window_1, digits = 3)
  myCalcData$R_Before_Window_02                       <- round (Data_Calc_UValEst$R_Before_Window_2, digits = 3)
  myCalcData$R_Before_Door_01                         <- round (Data_Calc_UValEst$R_Before_Door_1, digits = 3)

  myCalcData$U_Measure_Roof_01                        <- round (Data_Calc_UValEst$U_Measure_Roof_1, digits = 3)
  myCalcData$U_Measure_Roof_02                        <- round (Data_Calc_UValEst$U_Measure_Roof_2, digits = 3)
  myCalcData$U_Measure_Wall_01                        <- round (Data_Calc_UValEst$U_Measure_Wall_1, digits = 3)
  myCalcData$U_Measure_Wall_02                        <- round (Data_Calc_UValEst$U_Measure_Wall_2, digits = 3)
  myCalcData$U_Measure_Wall_03                        <- round (Data_Calc_UValEst$U_Measure_Wall_3, digits = 3)
  myCalcData$U_Measure_Floor_01                       <- round (Data_Calc_UValEst$U_Measure_Floor_1, digits = 3)
  myCalcData$U_Measure_Floor_02                       <- round (Data_Calc_UValEst$U_Measure_Floor_2, digits = 3)
  myCalcData$U_Measure_Window_01                      <- round (Data_Calc_UValEst$U_Measure_Window_1, digits = 3)
  myCalcData$U_Measure_Window_02                      <- round (Data_Calc_UValEst$U_Measure_Window_2, digits = 3)
  myCalcData$U_Measure_Door_01                        <- round (Data_Calc_UValEst$U_Measure_Door_1, digits = 3)

  myCalcData$U_Actual_Roof_01                         <- AuxFunctions::Replace_NA (round (Data_Calc_UValEst$U_Actual_Roof_1, digits = 3), 0)
  myCalcData$U_Actual_Roof_02                         <- AuxFunctions::Replace_NA (round (Data_Calc_UValEst$U_Actual_Roof_2, digits = 3), 0)
  myCalcData$U_Actual_Wall_01                         <- AuxFunctions::Replace_NA (round (Data_Calc_UValEst$U_Actual_Wall_1, digits = 3), 0)
  myCalcData$U_Actual_Wall_02                         <- AuxFunctions::Replace_NA (round (Data_Calc_UValEst$U_Actual_Wall_2, digits = 3), 0)
  myCalcData$U_Actual_Wall_03                         <- AuxFunctions::Replace_NA (round (Data_Calc_UValEst$U_Actual_Wall_3, digits = 3), 0)
  myCalcData$U_Actual_Floor_01                        <- AuxFunctions::Replace_NA (round (Data_Calc_UValEst$U_Actual_Floor_1, digits = 3), 0)
  myCalcData$U_Actual_Floor_02                        <- AuxFunctions::Replace_NA (round (Data_Calc_UValEst$U_Actual_Floor_2, digits = 3), 0)
  myCalcData$U_Actual_Window_01                       <- AuxFunctions::Replace_NA (round (Data_Calc_UValEst$U_Actual_Window_1, digits = 3), 0)
  myCalcData$U_Actual_Window_02                       <- AuxFunctions::Replace_NA (round (Data_Calc_UValEst$U_Actual_Window_2, digits = 3), 0)
  myCalcData$U_Actual_Door_01                         <- AuxFunctions::Replace_NA (round (Data_Calc_UValEst$U_Actual_Door_1, digits = 3), 0)



  myCalcData$h_Transmission_EnvArEst <-
    round (
      (myCalcData$b_Transmission_Roof_01   * myCalcData$A_Estim_Roof_01    * myCalcData$U_Actual_Roof_01  +
         myCalcData$b_Transmission_Roof_02   * myCalcData$A_Estim_Roof_02    * myCalcData$U_Actual_Roof_02  +
         myCalcData$b_Transmission_Wall_01   * myCalcData$A_Estim_Wall_01    * myCalcData$U_Actual_Wall_01+
         myCalcData$b_Transmission_Wall_02   * myCalcData$A_Estim_Wall_02    * myCalcData$U_Actual_Wall_02 +
         myCalcData$b_Transmission_Wall_03   * myCalcData$A_Estim_Wall_03    * myCalcData$U_Actual_Wall_03 +
         myCalcData$b_Transmission_Floor_01  * myCalcData$A_Estim_Floor_01   * myCalcData$U_Actual_Floor_01 +
         myCalcData$b_Transmission_Floor_02  * myCalcData$A_Estim_Floor_02   * myCalcData$U_Actual_Floor_02 +
         myCalcData$A_Estim_Window_01  * myCalcData$U_Actual_Window_01 +
         myCalcData$A_Estim_Window_02  * myCalcData$U_Actual_Window_02 +
         myCalcData$A_Estim_Door_01    * myCalcData$U_Actual_Door_01) /
        myCalcData$A_C_Ref

      , 3
    )
  # [W/K/m²]
  # Thermal heat transfer coefficient by transmission per sqm reference area
  # based on estimated envelope area, undisturbed elements without thermal bridging


  #memory.size()
  #Data_Calc_UValEst <- NA # Save memory
  #memory.size()


  #i_Col_Double <- which (colnames (Data_Output) %in% colnames (Data_Calc_FunctionInput))
  #colnames (Data_Output [ ,i_Col_Double])
  #Data_Calc_FunctionOutput <- cbind (Data_Calc_FunctionInput, Data_Output [ ,-i_Col_Double])
  #colnames (Data_Calc_FunctionOutput)

  # return (cbind (Data_Calc_FunctionInput, Data_Output [ ,-i_Col_Double]))
  # }



  return (myCalcData)

} # End of function


## End of the function UValEst () -----
#####################################################################################X


#.------------------------------------------------------------------------------------




