#####################################################################################X
##
##    File name:        "CalcBuilding.R"
##
##    Module of:        "EnergyProfile.R"
##
##    Task:             Energy performance calculation for the building
##                      (physical model / energy need for heating)
##
##    Method:           TABULA energy performance calculation
##                      https://www.episcope.eu/fileadmin/tabula/public/docs/
##                      report/TABULA_CommonCalculationMethod.pdf
##
##    Projects:         TABULA / EPISCOPE / MOBASY
##
##    Authors:          Tobias Loga (t.loga@iwu.de)
##                      Jens Calisti
##                      IWU - Institut Wohnen und Umwelt, Darmstadt / Germany
##
##    Created:          14-07-2021
##    Last changes:     02-06-2023
##
#####################################################################################X
##
##    Content:          Function CalcBuilding ()
##
##    Source:           R-Script derived from Excel workbook / worksheet
##                      "[tabula-calculator.xlsx]Calc.Set.Building"
##
#####################################################################################X

## Temporary change log
#
# 2023-03-10 Variable name changed (to make in consistent):
# I_Sol_Hor etc. replaced by I_Sol_HD_Hor



#####################################################################################X
##  Dependencies / requirements ------
#
#   Script "AuxFunctions.R"
#   Script "AuxConstants.R"



#####################################################################################X
## FUNCTION "CalcBuilding ()" -----
#####################################################################################X



CalcBuilding <- function (

  myInputData,
  myCalcData,

  ParTab_EnvArEst = NA

) {

  cat ("CalcBuilding ()", fill = TRUE)


  ###################################################################################X
  # 1  DESCRIPTION   -----
  ###################################################################################X

  # This function is used to calculate the energy need for heating.



  ###################################################################################X
  # 2  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X


  ## After debugging: Comment this section
  #
  # myInputData <- Data_Input
  # myCalcData  <- Data_Calc


  ## Test specific datasets
  # myInputData    <- Data_Input ["DE.MOBASY.NH.0020.05", ]
  # myCalcData     <- Data_Calc  ["DE.MOBASY.NH.0020.05", ]
  # myInputData    <- Data_Input ["DE.MOBASY.WBG.0007.05", ]
  # myCalcData     <- Data_Calc  ["DE.MOBASY.WBG.0007.05", ]


  ###################################################################################X
  # 3  FUNCTION SCRIPT   -----
  ###################################################################################X


  #.------------------------------------------------------------------------------------


  #####################################################################################X
  ## Envelope surface area -----
  #####################################################################################X


  #####################################################################################X
  ## . Calculate and check deviation between manually entered envelope area and estimation -----


  myCalcData$A_Input_Roof_01    <- AuxFunctions::Replace_NA (myInputData$A_Input_Roof_01, 1)
  myCalcData$A_Input_Roof_02    <- AuxFunctions::Replace_NA (myInputData$A_Input_Roof_02, 1)
  myCalcData$A_Input_Wall_01    <- AuxFunctions::Replace_NA (myInputData$A_Input_Wall_01, 1)
  myCalcData$A_Input_Wall_02    <- AuxFunctions::Replace_NA (myInputData$A_Input_Wall_02, 1)
  myCalcData$A_Input_Wall_03    <- AuxFunctions::Replace_NA (myInputData$A_Input_Wall_03, 1)
  myCalcData$A_Input_Floor_01   <- AuxFunctions::Replace_NA (myInputData$A_Input_Floor_01, 1)
  myCalcData$A_Input_Floor_02   <- AuxFunctions::Replace_NA (myInputData$A_Input_Floor_02, 1)
  myCalcData$A_Input_Window_01  <- AuxFunctions::Replace_NA (myInputData$A_Input_Window_01, 1)
  myCalcData$A_Input_Window_02  <- AuxFunctions::Replace_NA (myInputData$A_Input_Window_02, 1)
  myCalcData$A_Input_Door_01    <- AuxFunctions::Replace_NA (myInputData$A_Input_Door_01, 1)




  myCalcData$A_Estim_Env_Sum <-
      apply(
          cbind(
              myCalcData$A_Estim_Roof_01,
              myCalcData$A_Estim_Roof_02,
              myCalcData$A_Estim_Wall_01,
              myCalcData$A_Estim_Wall_02,
              myCalcData$A_Estim_Wall_03,
              myCalcData$A_Estim_Floor_01,
              myCalcData$A_Estim_Floor_02,
              myCalcData$A_Estim_Window_01,
              myCalcData$A_Estim_Window_02,
              myCalcData$A_Estim_Door_01
          ),
          1,
          sum
      ) # <CF13> | m? | Real

  myCalcData$A_Exact_Env_Sum <-
      apply(
          cbind(
              myCalcData$A_Input_Roof_01,
              myCalcData$A_Input_Roof_02,
              myCalcData$A_Input_Wall_01,
              myCalcData$A_Input_Wall_02,
              myCalcData$A_Input_Wall_03,
              myCalcData$A_Input_Floor_01,
              myCalcData$A_Input_Floor_02,
              myCalcData$A_Input_Window_01,
              myCalcData$A_Input_Window_02,
              myCalcData$A_Input_Door_01
          ),
          1,
          sum
      ) # <CG13> | m? | Real

  myCalcData$r_EnvTotal_ExactToEstim <-
      AuxFunctions::Replace_NA (myCalcData$A_Exact_Env_Sum / myCalcData$A_Estim_Env_Sum, 0)
  # <CH13> | ratio of total envelope area: exact to estimated | Real

  # myCalcData$f_PlausiCrit_EnvSum_LowerLimit <- 0.8 # <CI13> | Tab.Par.EnvAreaEstim | Real
  # myCalcData$f_PlausiCrit_EnvSum_UpperLimit <- 1.25 # <CJ13> | Tab.Par.EnvAreaEstim | Real



  myCalcData$f_PlausiCrit_EnvSum_LowerLimit <-
    ParTab_EnvArEst$f_PlausiCrit_EnvSum_LowerLimit
  # <CI13> | Tab.Par.EnvAreaEstim | Real
  myCalcData$f_PlausiCrit_EnvSum_UpperLimit <-
    ParTab_EnvArEst$f_PlausiCrit_EnvSum_UpperLimit
  # <CJ13> | Tab.Par.EnvAreaEstim | Real

  myCalcData$Check_EnvSum_ExactToEstim <-
      ifelse (
          AuxFunctions::xl_AND (
              myCalcData$r_EnvTotal_ExactToEstim >= myCalcData$f_PlausiCrit_EnvSum_LowerLimit,
              myCalcData$r_EnvTotal_ExactToEstim <= myCalcData$f_PlausiCrit_EnvSum_UpperLimit
          ),
          1,
          0
      ) # <CK13> | global check of exact envelope areas compared to estimated values; criterium: total envelope | 0 = false, 1 = true, -1 = not defined | Integer"

  myCalcData$r_EnvFloor_ExactToEstim <-
      AuxFunctions::Replace_NA ((myCalcData$A_Input_Floor_01 + myCalcData$A_Input_Floor_02) / (myCalcData$A_Estim_Floor_01 + myCalcData$A_Estim_Floor_02),
                  0) # <CL13> | ratio of bottom part of envelope area: exact to estimated | Real

  # myCalcData$f_PlausiCrit_FloorArea_LowerLimit <-
  #     0.9 # <CM13> | Tab.Par.EnvAreaEstim | Real
  # myCalcData$f_PlausiCrit_FloorArea_UpperLimit <-
  #     1.3 # <CN13> | Tab.Par.EnvAreaEstim | Real

  myCalcData$f_PlausiCrit_FloorArea_LowerLimit <- ParTab_EnvArEst$f_PlausiCrit_FloorArea_LowerLimit #
  myCalcData$f_PlausiCrit_FloorArea_UpperLimit <- ParTab_EnvArEst$f_PlausiCrit_FloorArea_UpperLimit #

  myCalcData$Check_FloorArea_ExactToEstim <-
      ifelse (
          AuxFunctions::xl_AND (
              myCalcData$r_EnvFloor_ExactToEstim >= myCalcData$f_PlausiCrit_FloorArea_LowerLimit,
              myCalcData$r_EnvFloor_ExactToEstim <= myCalcData$f_PlausiCrit_FloorArea_UpperLimit
          ),
          1,
          0
      ) # <CO13> | global check of exact envelope areas compared to estimated values; criterium: floor area (only in case of simple building geometries) | 0 = false, 1 = true, -1 = not defined | Integer"

  myCalcData$Check_ToBeApplied_FloorArea_ExactToEstim <-
      ifelse (myCalcData$f_AtticCond + myCalcData$f_CellarCond == 0, 1, 0) # <CP13> | This check of basement/floor area cannot be applied in case of partly or completely heated attics (the indicator is 0 in this case).  | Integer

  myCalcData$r_EnvWindow_ExactToEstim <-
      AuxFunctions::Replace_NA ((
          myCalcData$A_Input_Window_01 + myCalcData$A_Input_Window_02 + myCalcData$A_Input_Door_01
      ) / (myCalcData$A_Estim_Window_01 + myCalcData$A_Estim_Window_02 + myCalcData$A_Estim_Door_01),
      0
      ) # <CQ13> | ratio of window area: exact to estimated | Real

  # myCalcData$f_PlausiCrit_WindowArea_LowerLimit <-
  #     0.67 # <CR13> | Tab.Par.EnvAreaEstim | Real
  # myCalcData$f_PlausiCrit_WindowArea_UpperLimit <-
  #     1.5 # <CS13> | Tab.Par.EnvAreaEstim | Real

  myCalcData$f_PlausiCrit_WindowArea_LowerLimit <- ParTab_EnvArEst$f_PlausiCrit_WindowArea_LowerLimit #
  myCalcData$f_PlausiCrit_WindowArea_UpperLimit <- ParTab_EnvArEst$f_PlausiCrit_WindowArea_UpperLimit #


  myCalcData$Check_WindowArea_ExactToEstim <-
      ifelse (
          AuxFunctions::xl_AND (
              myCalcData$r_EnvWindow_ExactToEstim >= myCalcData$f_PlausiCrit_WindowArea_LowerLimit,
              myCalcData$r_EnvWindow_ExactToEstim <= myCalcData$f_PlausiCrit_WindowArea_UpperLimit
          ),
          1,
          0
      ) # <CT13> | global check of exact envelope areas compared to estimated values; criterium: window area | 0 = false, 1 = true, -1 = not defined | Integer

  myCalcData$Check_EnvArea_ExactToEstim <-
      myCalcData$Check_EnvSum_ExactToEstim * ifelse (
          myCalcData$Check_ToBeApplied_FloorArea_ExactToEstim == 1,
          myCalcData$Check_FloorArea_ExactToEstim,
          1
      ) * myCalcData$Check_WindowArea_ExactToEstim # <CU13> | global check of exact envelope areas compared to estimated values; criteria: total envelope, floor area (only in case of simple building geometries), window area | 0 = false, 1 = true, -1 = not defined | Integer"



  #####################################################################################X
  ## . Assign manual input or estimation to calculation variables for envelope area -----


  myCalcData$Code_TypeIntake_EnvelopeArea <-
      ifelse (
          myCalcData$Code_TypeInput_Envelope_SurfaceArea == "Manual",
          "Manual",
          ifelse (
              myCalcData$Code_TypeInput_WindowAreaPassiveSolar == "Manual",
              "Estimation_ManualWindowOrientation",
              "Estimation"
          )
      ) # <KF13> | Code for tabula-calculator.xlsx | "Manual" (or empty) = use area input values; "Estimation" = use estimated values
  # Source: "[EnergyProfile.xlsm]Data.Out.TABULA


  myCalcData$A_Calc_Roof_01 <-
      ifelse (
          AuxFunctions::xl_LEFT (myCalcData$Code_TypeIntake_EnvelopeArea, 10) == "Estimation",
          myCalcData$A_Estim_Roof_01,
          myCalcData$A_Input_Roof_01
      ) # <CV13> | envelope area actually used for further calculations | element type roof 1 | m? | Tab.Building | Real
  myCalcData$A_Calc_Roof_02 <-
      ifelse (
          AuxFunctions::xl_LEFT (myCalcData$Code_TypeIntake_EnvelopeArea, 10) == "Estimation",
          myCalcData$A_Estim_Roof_02,
          myCalcData$A_Input_Roof_02
      ) # <CW13> | envelope area actually used for further calculations | element type roof 2 | m? | Tab.Building | Real
  myCalcData$A_Calc_Wall_01 <-
      ifelse (
          AuxFunctions::xl_LEFT (myCalcData$Code_TypeIntake_EnvelopeArea, 10) == "Estimation",
          myCalcData$A_Estim_Wall_01,
          myCalcData$A_Input_Wall_01
      ) # <CX13> | envelope area actually used for further calculations | element type wall 1 | m? | Tab.Building | Real
  myCalcData$A_Calc_Wall_02 <-
      ifelse (
          AuxFunctions::xl_LEFT (myCalcData$Code_TypeIntake_EnvelopeArea, 10) == "Estimation",
          myCalcData$A_Estim_Wall_02,
          myCalcData$A_Input_Wall_02
      )
  myCalcData$A_Calc_Wall_03 <-
      ifelse (
          AuxFunctions::xl_LEFT (myCalcData$Code_TypeIntake_EnvelopeArea, 10) == "Estimation",
          myCalcData$A_Estim_Wall_03,
          myCalcData$A_Input_Wall_03
      )
  myCalcData$A_Calc_Floor_01 <-
      ifelse (
          AuxFunctions::xl_LEFT (myCalcData$Code_TypeIntake_EnvelopeArea, 10) == "Estimation",
          myCalcData$A_Estim_Floor_01,
          myCalcData$A_Input_Floor_01
      )
  myCalcData$A_Calc_Floor_02 <-
      ifelse (
          AuxFunctions::xl_LEFT (myCalcData$Code_TypeIntake_EnvelopeArea, 10) == "Estimation",
          myCalcData$A_Estim_Floor_02,
          myCalcData$A_Input_Floor_02
      )

  myCalcData$A_Calc_Window_01 <-
      ifelse (
          AuxFunctions::xl_LEFT (myCalcData$Code_TypeIntake_EnvelopeArea, 10) == "Estimation",
          myCalcData$A_Estim_Window_01,
          myCalcData$A_Input_Window_01
      ) # <DC13> | envelope area actually used for further calculations | element type window 1 | m? | Tab.Building | Real
  myCalcData$A_Calc_Window_02 <-
      ifelse (
          AuxFunctions::xl_LEFT (myCalcData$Code_TypeIntake_EnvelopeArea, 10) == "Estimation",
          myCalcData$A_Estim_Window_02,
          myCalcData$A_Input_Window_02
      ) # <DD13> | envelope area actually used for further calculations | element type window 2 | m? | Tab.Building | Real
  myCalcData$A_Calc_Door_01 <-
      ifelse (
          AuxFunctions::xl_LEFT (myCalcData$Code_TypeIntake_EnvelopeArea, 10) == "Estimation",
          myCalcData$A_Estim_Door_01,
          myCalcData$A_Input_Door_01
      ) # <DE13> | envelope area actually used for further calculations | element type door 1 | m? | Tab.Building | Real

  myCalcData$A_Calc_Window_Horizontal <-
      AuxFunctions::Replace_NA (
          ifelse (
              myCalcData$Code_TypeIntake_EnvelopeArea == "Estimation",
              0,
              AuxFunctions::Replace_NA (
                  myCalcData$A_Window_Horizontal / apply (cbind (myCalcData$A_Window_Horizontal,
                                                                myCalcData$A_Window_East,
                                                                myCalcData$A_Window_South,
                                                                myCalcData$A_Window_West,
                                                                myCalcData$A_Window_North),
                                                         1, sum),
                  1 / 5
              )
          ) * (myCalcData$A_Calc_Window_01 + myCalcData$A_Calc_Window_02),
          0
      ) # <DF13> | area of horizontal windows | tilted below 30?, otherwise classified as vertical (see below) | m? | Tab.Building | Real | 2020-06-05 iwu/tl: Formula changed (allocation of window to orientation possible / parameter "Estimation_ManualWindowOrientation"). Also implemented for manual input: Manual m? input for the windows by orientation is calibrated to the sum of A_Calc_Window_1 and A_Calc_Window_2 to avoid incorrect passive solar gains.  | 0

  myCalcData$A_Calc_Window_East <-
      AuxFunctions::Replace_NA (
          ifelse (
              myCalcData$Code_TypeIntake_EnvelopeArea == "Estimation",
              0.5,
              AuxFunctions::Replace_NA (
                  myCalcData$A_Window_East / apply (cbind (myCalcData$A_Window_Horizontal,
                                                                myCalcData$A_Window_East,
                                                                myCalcData$A_Window_South,
                                                                myCalcData$A_Window_West,
                                                                myCalcData$A_Window_North),
                                                         1, sum),
                  1 / 5
              )
          ) * (myCalcData$A_Calc_Window_01 + myCalcData$A_Calc_Window_02),
          0
      ) # <DG13> | window area oriented east | deviation from orientation: +/- 45? | m? | Tab.Building | Real | 2020-06-05 iwu/tl: Formula changed (allocation of window to orientation possible / parameter "Estimation_ManualWindowOrientation"). Also implemented for manual input: Manual m? input for the windows by orientation is calibrated to the sum of A_Calc_Window_1 and A_Calc_Window_2 to avoid incorrect passive solar gains.  | 0.5

  myCalcData$A_Calc_Window_South <-
      AuxFunctions::Replace_NA (
          ifelse (
              myCalcData$Code_TypeIntake_EnvelopeArea == "Estimation",
              0,
              AuxFunctions::Replace_NA (
                  myCalcData$A_Window_South / apply (cbind (myCalcData$A_Window_Horizontal,
                                                                myCalcData$A_Window_East,
                                                                myCalcData$A_Window_South,
                                                                myCalcData$A_Window_West,
                                                                myCalcData$A_Window_North),
                                                         1, sum),
                  1 / 5
              )
          ) * (myCalcData$A_Calc_Window_01 + myCalcData$A_Calc_Window_02),
          0
      ) # <DH13> | window area oriented south | deviation from orientation: +/- 45? | m? | Tab.Building | Real | 2020-06-05 iwu/tl: Formula changed (allocation of window to orientation possible / parameter "Estimation_ManualWindowOrientation"). Also implemented for manual input: Manual m? input for the windows by orientation is calibrated to the sum of A_Calc_Window_1 and A_Calc_Window_2 to avoid incorrect passive solar gains.  | 0

  myCalcData$A_Calc_Window_West <-
      AuxFunctions::Replace_NA (
          ifelse (
              myCalcData$Code_TypeIntake_EnvelopeArea == "Estimation",
              0.5,
              AuxFunctions::Replace_NA (
                  myCalcData$A_Window_West / apply (cbind (myCalcData$A_Window_Horizontal,
                                                                myCalcData$A_Window_East,
                                                                myCalcData$A_Window_South,
                                                                myCalcData$A_Window_West,
                                                                myCalcData$A_Window_North),
                                                         1, sum),
                  1 / 5
              )
          ) * (myCalcData$A_Calc_Window_01 + myCalcData$A_Calc_Window_02),
          0
      ) # <DI13> | window area oriented west | deviation from orientation: +/- 45? | m? | Tab.Building | Real | 2020-06-05 iwu/tl: Formula changed (allocation of window to orientation possible / parameter "Estimation_ManualWindowOrientation"). Also implemented for manual input: Manual m? input for the windows by orientation is calibrated to the sum of A_Calc_Window_1 and A_Calc_Window_2 to avoid incorrect passive solar gains.  | 0.5

  myCalcData$A_Calc_Window_North <-
      AuxFunctions::Replace_NA (
          ifelse (
              myCalcData$Code_TypeIntake_EnvelopeArea == "Estimation",
              0,
              AuxFunctions::Replace_NA (
                  myCalcData$A_Window_North / apply (cbind (myCalcData$A_Window_Horizontal,
                                                                myCalcData$A_Window_East,
                                                                myCalcData$A_Window_South,
                                                                myCalcData$A_Window_West,
                                                                myCalcData$A_Window_North),
                                                         1, sum),
                  1 / 5
              )
          ) * (myCalcData$A_Calc_Window_01 + myCalcData$A_Calc_Window_02),
          0
      ) # <DJ13> | window area oriented north | deviation from orientation: +/- 45? | m? | Tab.Building | Real | 2020-06-05 iwu/tl: Formula changed (allocation of window to orientation possible / parameter "Estimation_ManualWindowOrientation"). Also implemented for manual input: Manual m? input for the windows by orientation is calibrated to the sum of A_Calc_Window_1 and A_Calc_Window_2 to avoid incorrect passive solar gains.  | 0







  #.------------------------------------------------------------------------------------


  #####################################################################################X
  ## . Estimation of thermal bridging from values for "Original" and "Refurbished"  -----

  # Weighted by the share of refurbished envelope area




  myCalcData$A_Calc_Env_Sum <-
      apply(
          cbind(
              myCalcData$A_Calc_Roof_01,
              myCalcData$A_Calc_Roof_02,
              myCalcData$A_Calc_Wall_01,
              myCalcData$A_Calc_Wall_02,
              myCalcData$A_Calc_Wall_03,
              myCalcData$A_Calc_Floor_01,
              myCalcData$A_Calc_Floor_02,
              myCalcData$A_Calc_Window_01,
              myCalcData$A_Calc_Window_02,
              myCalcData$A_Calc_Door_01
          ),
          1,
          sum
      )

  myCalcData$Fraction_EnvelopeRefurbished <-
      AuxFunctions::Replace_NA ((
          ifelse (
              myCalcData$R_Measure_Roof_01 > 0,
              myCalcData$f_Measure_Roof_01 * myCalcData$A_Calc_Roof_01,
              0
          ) + ifelse (
              myCalcData$R_Measure_Roof_02 > 0,
              myCalcData$f_Measure_Roof_02 * myCalcData$A_Calc_Roof_02,
              0
          ) + ifelse (
              myCalcData$R_Measure_Wall_01 > 0,
              myCalcData$f_Measure_Wall_01 * myCalcData$A_Calc_Wall_01,
              0
          ) + ifelse (
              myCalcData$R_Measure_Wall_02 > 0,
              myCalcData$f_Measure_Wall_02 * myCalcData$A_Calc_Wall_02,
              0
          ) + ifelse (
              myCalcData$R_Measure_Wall_03 > 0,
              myCalcData$f_Measure_Wall_03 * myCalcData$A_Calc_Wall_03,
              0
          ) + ifelse (
              myCalcData$R_Measure_Floor_01 > 0,
              myCalcData$f_Measure_Floor_01 * myCalcData$A_Calc_Floor_01,
              0
          ) + ifelse (
              myCalcData$R_Measure_Floor_02 > 0,
              myCalcData$f_Measure_Floor_02 * myCalcData$A_Calc_Floor_02,
              0
          ) + ifelse (
              myCalcData$R_Measure_Window_01 > 0,
              myCalcData$f_Measure_Window_01 * myCalcData$A_Calc_Window_01,
              0
          ) + ifelse (
              myCalcData$R_Measure_Window_02 > 0,
              myCalcData$f_Measure_Window_02 * myCalcData$A_Calc_Window_02,
              0
          ) + ifelse (
              myCalcData$R_Measure_Door_01 > 0,
              myCalcData$f_Measure_Door_01 * myCalcData$A_Calc_Door_01,
              0
          )
      ) / myCalcData$A_Calc_Env_Sum,
      0
      ) # <KQ13> | fraction of the thermal envelope to which measures are applied | Real



  myCalcData$Type_ThermalBridging_Actual <-
      ifelse (
          AuxFunctions::xl_OR (
              myCalcData$Code_ThermalBridging_Refurbished == "",
              myCalcData$Code_ThermalBridging_Original == myCalcData$Code_ThermalBridging_Refurbished
          ),
          myCalcData$Code_ThermalBridging_Original,
          ifelse (
              myCalcData$Code_TypeVariant == "Variation",
              myCalcData$Code_ThermalBridging_Refurbished,
              ifelse (
                  myCalcData$Fraction_EnvelopeRefurbished == 0,
                  myCalcData$Code_ThermalBridging_Original,
                  ifelse (
                      myCalcData$Fraction_EnvelopeRefurbished == 1,
                      myCalcData$Code_ThermalBridging_Refurbished,
                      myCalcData$Code_ThermalBridging_Original %xl_JoinStrings%
                          "(" %xl_JoinStrings%
                          AuxFunctions::xl_TEXT (1 - myCalcData$Fraction_EnvelopeRefurbished, "##0%")
                      %xl_JoinStrings% ")." %xl_JoinStrings%
                          myCalcData$Code_ThermalBridging_Refurbished %xl_JoinStrings%
                          "(" %xl_JoinStrings%
                          AuxFunctions::xl_TEXT (myCalcData$Fraction_EnvelopeRefurbished, "##0%")
                      %xl_JoinStrings% ")"
                  )
              )
          )
      ) # <KR13> | code of the thermal bridging type (dummy code) | merged codes from original and refurbished state, including applied fractions | VarChar


  myCalcData$Code_TypeVariant <- "" # <I13> currently not active, defined for automatic adaptation for refurbishment variants

  myCalcData$delta_U_ThermalBridging <-
      AuxFunctions::Replace_NA (
          ifelse (
              myCalcData$Code_ThermalBridging_Refurbished != "",
              ifelse (
                  myCalcData$Code_TypeVariant == "Variation",
                  myCalcData$delta_U_ThermalBridging_Refurbished,
                  (1 - myCalcData$Fraction_EnvelopeRefurbished) * myCalcData$delta_U_ThermalBridging_Original +
                      myCalcData$Fraction_EnvelopeRefurbished * myCalcData$delta_U_ThermalBridging_Refurbished
              ),
              myCalcData$delta_U_ThermalBridging_Original
          ),
          0
      )
  # <KS13> | additional losses of the thermal envelope caused by thermal bridging (supplement to all U-values), actual value (weighted average of values of unrefurbished and refurbished envelope parts) | standard values in W/(m?K):
  # 0      minimal
  # 0,02   very low
  # 0,05   low
  # 0,1    medium
  # 0,15   high
  # (valid for thermal envelope based on external dimensions) | W/(m?K) | Real"



  #.------------------------------------------------------------------------------------


  #####################################################################################X
  ## Calculation of energy need for heating  -----------------



  myCalcData$H_Transmission_Roof_01 <-
      ifelse (
          is.na (
              myCalcData$U_Actual_Roof_01 * myCalcData$A_Calc_Roof_01 * myCalcData$b_Transmission_Roof_01
          ),
          0,
          myCalcData$U_Actual_Roof_01 * myCalcData$A_Calc_Roof_01 * myCalcData$b_Transmission_Roof_01
      ) # <KT13> | heat transfer coefficient by transmission | element type roof 1 | W/K | Real
  myCalcData$H_Transmission_Roof_02 <-
      ifelse (
          is.na (
              myCalcData$U_Actual_Roof_02 * myCalcData$A_Calc_Roof_02 * myCalcData$b_Transmission_Roof_02
          ),
          0,
          myCalcData$U_Actual_Roof_02 * myCalcData$A_Calc_Roof_02 * myCalcData$b_Transmission_Roof_02
      ) # <KU13> | heat transfer coefficient by transmission | element type roof 2 | W/K | Real
  myCalcData$H_Transmission_Wall_01 <-
      ifelse (
          is.na (
              myCalcData$U_Actual_Wall_01 * myCalcData$A_Calc_Wall_01 * myCalcData$b_Transmission_Wall_01
          ),
          0,
          myCalcData$U_Actual_Wall_01 * myCalcData$A_Calc_Wall_01 * myCalcData$b_Transmission_Wall_01
      ) # <KV13> | heat transfer coefficient by transmission | element type wall 1 | W/K | Real
  myCalcData$H_Transmission_Wall_02 <-
      ifelse (
          is.na (
              myCalcData$U_Actual_Wall_02 * myCalcData$A_Calc_Wall_02 * myCalcData$b_Transmission_Wall_02
          ),
          0,
          myCalcData$U_Actual_Wall_02 * myCalcData$A_Calc_Wall_02 * myCalcData$b_Transmission_Wall_02
      ) # <KW13> | heat transfer coefficient by transmission | element type wall 2 | W/K | Real
  myCalcData$H_Transmission_Wall_03 <-
      ifelse (
          is.na (
              myCalcData$U_Actual_Wall_03 * myCalcData$A_Calc_Wall_03 * myCalcData$b_Transmission_Wall_03
          ),
          0,
          myCalcData$U_Actual_Wall_03 * myCalcData$A_Calc_Wall_03 * myCalcData$b_Transmission_Wall_03
      ) # <KX13> | heat transfer coefficient by transmission | element type wall 3 | W/K | Real
  myCalcData$H_Transmission_Floor_01 <-
      ifelse (
          is.na (
              myCalcData$U_Actual_Floor_01 * myCalcData$A_Calc_Floor_01 * myCalcData$b_Transmission_Floor_01
          ),
          0,
          myCalcData$U_Actual_Floor_01 * myCalcData$A_Calc_Floor_01 * myCalcData$b_Transmission_Floor_01
      ) # <KY13> | heat transfer coefficient by transmission | element type floor 1 | W/K | Real
  myCalcData$H_Transmission_Floor_02 <-
      ifelse (
          is.na (
              myCalcData$U_Actual_Floor_02 * myCalcData$A_Calc_Floor_02 * myCalcData$b_Transmission_Floor_02
          ),
          0,
          myCalcData$U_Actual_Floor_02 * myCalcData$A_Calc_Floor_02 * myCalcData$b_Transmission_Floor_02
      ) # <KZ13> | heat transfer coefficient by transmission | element type floor 2 | W/K | Real
  myCalcData$H_Transmission_Window_01 <-
      ifelse (
          is.na (myCalcData$U_Actual_Window_01 * myCalcData$A_Calc_Window_01 * 1),
          0,
          myCalcData$U_Actual_Window_01 * myCalcData$A_Calc_Window_01 * 1
      ) # <LA13> | heat transfer coefficient by transmission | element type window 1 | W/K | Real
  myCalcData$H_Transmission_Window_02 <-
      ifelse (
          is.na (myCalcData$U_Actual_Window_02 * myCalcData$A_Calc_Window_02 * 1),
          0,
          myCalcData$U_Actual_Window_02 * myCalcData$A_Calc_Window_02 * 1
      ) # <LB13> | heat transfer coefficient by transmission | element type window 2 | W/K | Real
  myCalcData$H_Transmission_Door_01 <-
      ifelse (
          is.na (myCalcData$U_Actual_Door_01 * myCalcData$A_Calc_Door_01 * 1),
          0,
          myCalcData$U_Actual_Door_01 * myCalcData$A_Calc_Door_01 * 1
      ) # <LC13> | heat transfer coefficient by transmission | element type door 1 | W/K | Real

  myCalcData$H_Transmission_ThermalBridging <-
      myCalcData$A_Calc_Env_Sum * myCalcData$delta_U_ThermalBridging # <LD13> | heat transfer coefficient by transmission | supplemental heat loss due to thermal bridging  | W/K | Real

  myCalcData$h_Transmission <-
      AuxFunctions::Replace_NA (apply (
          cbind(
              myCalcData$H_Transmission_Roof_01,
              myCalcData$H_Transmission_Roof_02,
              myCalcData$H_Transmission_Wall_01,
              myCalcData$H_Transmission_Wall_02,
              myCalcData$H_Transmission_Wall_03,
              myCalcData$H_Transmission_Floor_01,
              myCalcData$H_Transmission_Floor_02,
              myCalcData$H_Transmission_Window_01,
              myCalcData$H_Transmission_Window_02,
              myCalcData$H_Transmission_Door_01,
              myCalcData$H_Transmission_ThermalBridging
          ),
          1,
          sum
      ) / myCalcData$A_C_Ref,
      0)
  # <LE13> | floor area related heat transfer coefficient by transmission | indicator for energy quality of building envelope (compactness + insulation) | W/(m?K) | Real


  myCalcData$h_Ventilation <-
      0.34 * (myCalcData$n_air_use + myCalcData$n_air_infiltration) * ifelse (
          AuxFunctions::xl_AND (
              myCalcData$h_Ref_AirExchangeRate > 0,
              myCalcData$h_Ref_AirExchangeRate != ""
          ),
          myCalcData$h_Ref_AirExchangeRate,
          2.5
      ) # <LF13> | floor area related heat transfer coefficient by ventilation | W/(m?K) | Real | 2020-04-28 / iwu / tl: Formula changed

  myCalcData$theta_i_calc <-
      ifelse (
          AuxFunctions::xl_AND (AuxFunctions::Replace_NA (myCalcData$theta_i,0) > 0, AuxFunctions::Replace_NA (myCalcData$theta_i, "") != ""),
          myCalcData$theta_i,
          myCalcData$theta_i_htrA +
              (myCalcData$h_Transmission - myCalcData$h_tr_A) / (myCalcData$h_tr_B - myCalcData$h_tr_A) *
              (myCalcData$theta_i_htrB - myCalcData$theta_i_htrA)
      ) # <LG13> | Internal temperature used for calculation (Internal temperature during heating season in directly heated spaces, average during heating hours (time without night setback)) | interpolation between theta_i_htrA and theta_i_htrB if theta_i is not available | ?C | Real | 2020-04-28 / iwu / tl: Formula changed
  myCalcData$Sum_DeltaT_for_HeatingDays <-
      (myCalcData$theta_i_calc - myCalcData$theta_e) * myCalcData$HeatingDays # <LH13> | accumulated difference between internal and external temperature | Kd/a | Real

  myCalcData$F_red_temp <-
      ifelse (
          myCalcData$h_Transmission <= myCalcData$h_tr_A,
          myCalcData$F_red_htrA,
          ifelse (
              myCalcData$h_Transmission >= myCalcData$h_tr_B,
              myCalcData$F_red_htrB,
              myCalcData$F_red_htrA +
                (myCalcData$h_Transmission - myCalcData$h_tr_A) *
                (myCalcData$F_red_htrB - myCalcData$F_red_htrA) /
                (myCalcData$h_tr_B - myCalcData$h_tr_A)
              )
      ) # <LI13> | temperature reduction factor, considering the effect of night setback and unheated space  | values of F_red_temp are given for h_tr = 1 und h_tr = 4, interpolation of values between / 2016-11-02: interpolation for h_tr < 1 changed: function min() introduced to limit the reduction factor to a maximum of 1.0 | Real | 2020-11-11 / iwu / tl: Formula changed from:



  myCalcData$theta_i_effective <-
      myCalcData$theta_e + (myCalcData$theta_i_calc - myCalcData$theta_e) * myCalcData$F_red_temp # <LJ13> | Effective internal temperature during heating season | ?C | Real | 2020-11-11 / iwu / tl: new column

  myCalcData$q_ht_tr <-
      myCalcData$h_Transmission * 0.024 * myCalcData$Sum_DeltaT_for_HeatingDays * myCalcData$F_red_temp # <LK13> | floor area related annual transmission losses | kWh/(m?a) | Real

  myCalcData$q_ht_ve <-
      myCalcData$h_Ventilation * 0.024 * myCalcData$Sum_DeltaT_for_HeatingDays * myCalcData$F_red_temp # <LL13> | floor area related annual ventilation losses | kWh/(m?a) | Real

  myCalcData$q_ht <-
      myCalcData$q_ht_tr + myCalcData$q_ht_ve # <LM13> | floor area related annual losses | kWh/(m?a) | Real

  myCalcData$g_gl_n <-
      AuxFunctions::Replace_NA (((
          AuxFunctions::Replace_NA (myCalcData$f_Measure_Window_01, 0) * AuxFunctions::Replace_NA (myCalcData$g_gl_n_Measure_Window_01, 0) +
          AuxFunctions::Replace_NA (1 - myCalcData$f_Measure_Window_01, 1) * AuxFunctions::Replace_NA (myCalcData$g_gl_n_Window_01, 0)
      ) * myCalcData$A_Calc_Window_01 + (
          AuxFunctions::Replace_NA (myCalcData$f_Measure_Window_02, 0) * AuxFunctions::Replace_NA (myCalcData$g_gl_n_Measure_Window_02, 0) +
              AuxFunctions::Replace_NA (1 - myCalcData$f_Measure_Window_02, 1) * AuxFunctions::Replace_NA (myCalcData$g_gl_n_Window_02, 0)
      ) * myCalcData$A_Calc_Window_02
      ) / (myCalcData$A_Calc_Window_01 + myCalcData$A_Calc_Window_02),
      0
      ) # <LN13> | total solar energy transmittance for radiation perpendicular to the glazing | average for both window types, considering refurbished state | Real | 2020-04-28 / iwu / tl: Formula changed (before f_Measure_Window was not considered, only the code for the measure was used as indicator)


  myCalcData$Q_Sol_Hor <-
      myCalcData$A_Calc_Window_Horizontal *
      myCalcData$I_Sol_HD_Hor *
      myCalcData$F_sh_hor *
      (1 - myCalcData$F_f) *
      myCalcData$F_w *
      myCalcData$g_gl_n # <LO13> | solar heat load during heating season | Horizontal | kWh/a | Real
  myCalcData$Q_Sol_East <-
      myCalcData$A_Calc_Window_East *
      myCalcData$I_Sol_HD_East *
      myCalcData$F_sh_vert *
      (1 - myCalcData$F_f) *
      myCalcData$F_w *
      myCalcData$g_gl_n # <LP13> | solar heat load during heating season | East | kWh/a | Real
  myCalcData$Q_Sol_South <-
      myCalcData$A_Calc_Window_South *
      myCalcData$I_Sol_HD_South *
      myCalcData$F_sh_vert *
      (1 - myCalcData$F_f) *
      myCalcData$F_w *
      myCalcData$g_gl_n # <LQ13> | solar heat load during heating season | South | kWh/a | Real
  myCalcData$Q_Sol_West <-
      myCalcData$A_Calc_Window_West *
      myCalcData$I_Sol_HD_West *
      myCalcData$F_sh_vert *
      (1 - myCalcData$F_f) *
      myCalcData$F_w *
      myCalcData$g_gl_n # <LR13> | solar heat load during heating season | West | kWh/a | Real
  myCalcData$Q_Sol_North <-
      myCalcData$A_Calc_Window_North *
      myCalcData$I_Sol_HD_North *
      myCalcData$F_sh_vert *
      (1 - myCalcData$F_f) *
      myCalcData$F_w *
      myCalcData$g_gl_n # <LS13> | solar heat load during heating season | North | kWh/a | Real
  myCalcData$q_sol <-
      AuxFunctions::Replace_NA (apply (cbind (myCalcData$Q_Sol_Hor,
                                myCalcData$Q_Sol_East,
                                myCalcData$Q_Sol_South,
                                myCalcData$Q_Sol_West,
                                myCalcData$Q_Sol_North), 1, sum) / myCalcData$A_C_Ref,
                  0)
  # <LT13> | floar area related solar heat load during heating season | kWh/(m?a) | Real

  myCalcData$q_int <-
      myCalcData$phi_int * 0.024 * myCalcData$HeatingDays
  # <LU13> | floar area related internal heat sources during heating season | kWh/(m?a) | Real

  myCalcData$tau <-
      AuxFunctions::Replace_NA (myCalcData$c_m / (myCalcData$h_Transmission + myCalcData$h_Ventilation),
                  0)
  # <LV13> | time constant of the building | relevant for seasonal method | h | Real
  myCalcData$a_H <-
      0.8 + myCalcData$tau / 30
  # <LW13> | parameter for determination of the gain utilisation factor for heating | Real
  myCalcData$gamma_h_gn <-
      AuxFunctions::Replace_NA ((myCalcData$q_sol + myCalcData$q_int) / myCalcData$q_ht, 0)
  # <LX13> | heat balance ratio for the heating mode | Real
  myCalcData$eta_h_gn <-
      (1 - myCalcData$gamma_h_gn ^ myCalcData$a_H) / (1 - myCalcData$gamma_h_gn ^
                                                        (myCalcData$a_H + 1))
  # <LY13> | gain utilisation factor for heating | Real
  myCalcData$q_h_nd <-
      ifelse ((
          myCalcData$q_ht - myCalcData$eta_h_gn * (myCalcData$q_sol + myCalcData$q_int)
      ) > 0,
      myCalcData$q_ht - myCalcData$eta_h_gn * (myCalcData$q_sol + myCalcData$q_int),

      )
  # <LZ13> | energy need for heating | kWh/(m?a) | Real


  #.------------------------------------------------------------------------------------



  ###################################################################################X
  #  4 OUTPUT  -----
  ###################################################################################X


  ###################################################################################X
  ##  . Return dataframe "myCalcData" including new calculation variables   ------

  myCalcData$Date_Change <- TimeStampForDataset ()

  return (myCalcData)



} # End of function


## End of the function CalcBuilding () -----
#####################################################################################X


#.------------------------------------------------------------------------------------

