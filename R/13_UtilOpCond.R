#####################################################################################X
##
##    File name:        "UtilOpCond.R"
##
##    Module of:        "EnergyProfile.R"
##
##    Task:             Definition of uilisation and operation conditions
##
##    Method:           Typical values derived in project for BBSR
##                      "Berücksichtigung des Nutzerverhaltens
##                      bei energetischen Verbesserungen"
##                      https://www.iwu.de/forschung/energie/
##                      nutzerverhalten-bei-energetischen-verbesserungen/
##
##    Project:          MOBASY
##
##    Authors:          Tobias Loga (t.loga@iwu.de)
##                      Jens Calisti
##                      IWU - Institut Wohnen und Umwelt, Darmstadt / Germany
##
##    Created:          14-05-2021
##    Last changes:     26-05-2023
##
#####################################################################################X
##
##    Content:          Function UtilOpCond ()
##
##    Source:           R-Script derived from Excel workbooks / worksheets
##                      "[EnergyProfile.xlsm]Data.out.TABULA"
##
#####################################################################################X



#####################################################################################X
##  Dependencies / requirements ------
#
#   Script "AuxFunctions.R"
#   Script "AuxConstants.R"



#####################################################################################X
## FUNCTION "UtilOpCond ()" -----
#####################################################################################X



UtilOpCond <- function (
    myInputData,
    myCalcData,
    ParTab_BoundaryCond
) {

  cat ("UtilOpCond ()", fill = TRUE)


  ###################################################################################X
  # 1  DESCRIPTION   -----
  ###################################################################################X

  # This function sets the internal boundary conditions for the energy performance
  # calculation, modelling the utilisation and operation of the building.


  ###################################################################################X
  # 2  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X
  ## After debugging: Comment this section

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


  ###################################################################################X
  ##  Constants  -----
  ###################################################################################X

  Value_Numeric_Error             <- -99999
  Value_String_Error              <- "_ERROR_"

  Code_BoundaryCond_Name_NA       <- "EU"
  # Boundary conditions used when there is no dataset selected


  ###################################################################################X
  ##  Preparation  -----
  ###################################################################################X


  #myCalcData$Code_U_Class_National <- myInputData$Code_U_Class_National # <AE11>
  #myCalcData$A_C_Floor_Intake <- myInputData$A_C_Floor_Intake # <AF11>
  #myCalcData$Code_TypeFloorArea_A_C_Floor_Intake <- myInputData$Code_TypeFloorArea_A_C_Floor_Intake # <AG11>
  #myCalcData$Code_BuildingPart_A_C_Floor_Intake <- myInputData$Code_BuildingPart_A_C_Floor_Intake # <AH11>
  #myCalcData$Code_TypeInput_Envelope_SurfaceArea <- myInputData$Code_TypeInput_Envelope_SurfaceArea # <AI11>
  #myCalcData$Code_TypeInput_Envelope_ThermalTransmittance <- myInputData$Code_TypeInput_Envelope_ThermalTransmittance # <AJ11>

  #myCalcData$Year1_Building <- AuxFunctions::Replace_NA (myInputData$Year_Building, Year_Building_NA)

  #myCalcData$Index_Class_Year_Building_Calc <- MATCH(myCalcData$Year1_Building,myCalcData$Year_Start_ConstrPeriod_01:myCalcData$Year_Start_ConstrPeriod_20,1) # <AM11>
  myCalcData$n_Block_Input <- myInputData$n_Block # <AN11>
  myCalcData$n_House_Input <- myInputData$n_House # <AO11>
  myCalcData$n_Storey_Input <- myInputData$n_Storey # <AP11>

  myCalcData$n_Dwelling_Input <- myInputData$n_Dwelling # <AQ11>
  #myCalcData$n_Dwelling <- myInputData$n_Dwelling # <AQ11>

  myCalcData$n_Block <-
    ifelse (
      is.na (myCalcData$n_Block_Input),
      1.0,
      ifelse (myCalcData$n_Block_Input == 0, 1.0, myCalcData$n_Block_Input)
    ) # <AR11>

  myCalcData$n_House <-
    ifelse (
      is.na(myCalcData$n_House_Input),
      1.0,
      ifelse(myCalcData$n_House_Input == 0, 1.0, myCalcData$n_House_Input)
    ) # <AS11>

  myCalcData$n_Dwelling <-
    AuxFunctions::Replace_NA (
      myCalcData$n_Dwelling_Input * 1,
      ifelse (
        myCalcData$Code_BuildingPart_A_C_Floor_Intake == "Building",
        round (myCalcData$A_C_Floor_Intake / 80, 0),
        round(myCalcData$A_C_Floor_Intake * myCalcData$n_Storey_Input / 80, 0)
      )
    ) # <AT11>

  myCalcData$Code_BuildingSize <-
    ifelse (myCalcData$n_Dwelling <= 2, "SUH", "MUH") # <AU11>

  myCalcData$Code_BuildingSizeClass_System <-
    myCalcData$Code_BuildingSize


  #.---------------------------------------------------------------------------------------------------

  ###################################################################################X
  ## Utilisation boundary conditions    ------------
  ###################################################################################X

  myCalcData$Code_BuildingSizeClass_System <-
    myCalcData$Code_BuildingSize

  myCalcData$Code_BoundaryCond_NA <-
    paste (Code_BoundaryCond_Name_NA,
           ".",
           myCalcData$Code_BuildingSizeClass_System,
           sep = "")

  myCalcData$Code_BoundaryCond_Input <-
    myInputData$Code_BoundaryCond

  myCalcData$Code_BoundaryCond <-
    AuxFunctions::Replace_NA (
      ifelse ((myCalcData$Code_BoundaryCond_Input == 0) |
                (myCalcData$Code_BoundaryCond_Input == "_NA_") |
                (myCalcData$Code_BoundaryCond_Input == ""),
              myCalcData$Code_BoundaryCond_NA,
              ifelse (
                AuxFunctions::xl_RIGHT (myCalcData$Code_BoundaryCond_Input, 1) == "*",
                paste (
                  substr (
                    myCalcData$Code_BoundaryCond_Input,
                    1,
                    nchar (myCalcData$Code_BoundaryCond_Input) - 1
                  ),
                  myCalcData$Code_BuildingSizeClass_System,
                  sep = ""
                ),
                myCalcData$Code_BoundaryCond_Input
              )
      ),
      myCalcData$Code_BoundaryCond_NA
    ) # <MJ11>

  #str (ParTab_BoundaryCond)


  ###################################################################################X
  ## . Library values (tabula-value.xlsx) -----

  myCalcData$Remark_BoundaryCond_1_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "Remarks"], NA) # possible that value is not available
  myCalcData$theta_i_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "theta_i"], NA) # possible that value is not available
  myCalcData$h_tr_A_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "h_tr_A"], NA) # possible that value is not available
  myCalcData$h_tr_B_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "h_tr_B"], NA) # possible that value is not available
  myCalcData$theta_i_htrA_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "theta_i_htrA"], NA) # possible that value is not available
  myCalcData$theta_i_htrB_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "theta_i_htrB"], NA) # possible that value is not available
  myCalcData$F_red_htrA_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "F_red_htrA"], NA) # possible that value is not available  <MQ11>
  myCalcData$F_red_htrB_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "F_red_htrB"], NA) # possible that value is not available

  myCalcData$F_red_htr1_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "F_red_htr1"], Value_Numeric_Error) # Value must be available
  myCalcData$F_red_htr4_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "F_red_htr4"], Value_Numeric_Error) # and so on
  myCalcData$phi_int_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "phi_int"], Value_Numeric_Error)
  myCalcData$F_sh_hor_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "F_sh_hor"], Value_Numeric_Error)
  myCalcData$F_sh_vert_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "F_sh_vert"], Value_Numeric_Error)
  myCalcData$F_f_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "F_f"], Value_Numeric_Error)
  myCalcData$F_w_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "F_w"], Value_Numeric_Error)
  myCalcData$c_m_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "c_m"], Value_Numeric_Error)
  myCalcData$q_w_nd_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "q_w_nd"], Value_Numeric_Error)

  myCalcData$DeltaT_w_nd_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "DeltaT_w_nd"], Value_Numeric_Error)
  myCalcData$vol_w_nd_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "vol_w_nd"], Value_Numeric_Error)

  myCalcData$A_C_Ref_PerPerson_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "A_C_Ref_PerPerson"], Value_Numeric_Error)
  myCalcData$Vol_DHW_PerPersonPerDay_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "Vol_DHW_PerPersonPerDay"], Value_Numeric_Error)

  myCalcData$h_room_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "h_room"], Value_Numeric_Error)
  myCalcData$n_air_use_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "n_air_use"], Value_Numeric_Error)
  myCalcData$n_Air_Window_NoVentSys_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "n_Air_Window_NoVentSys"], Value_Numeric_Error)
  myCalcData$n_Air_Window_VentSys_Exhaust_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "n_Air_Window_VentSys_Exhaust"], Value_Numeric_Error)
  myCalcData$n_Air_Window_VentSys_Balanced_Lib <-
    AuxFunctions::Replace_NA (ParTab_BoundaryCond [myCalcData$Code_BoundaryCond, "n_Air_Window_VentSys_Balanced"], Value_Numeric_Error)


  ###################################################################################X
  ## . Alternative individual input -----

  myCalcData$Remark_BoundaryCond_Input <-
    myInputData$Remark_BoundaryCond_Input # <NI11>
  myCalcData$theta_i_Input <- myInputData$theta_i_Input # <NJ11>
  myCalcData$h_tr_A_Input <- myInputData$h_tr_A_Input # <NK11>
  myCalcData$h_tr_B_Input <- myInputData$h_tr_B_Input # <NL11>
  myCalcData$theta_i_htrA_Input <-
    myInputData$theta_i_htrA_Input # <NM11>
  myCalcData$theta_i_htrB_Input <-
    myInputData$theta_i_htrB_Input # <NN11>
  myCalcData$F_red_htrA_Input <-
    myInputData$F_red_htrA_Input # <NO11>
  myCalcData$F_red_htrB_Input <-
    myInputData$F_red_htrB_Input # <NP11>
  myCalcData$phi_int_Input <-
    myInputData$phi_int_Input # <NQ11>
  myCalcData$F_sh_hor_Input <-
    myInputData$F_sh_hor_Input # <NR11>
  myCalcData$F_sh_vert_Input <-
    myInputData$F_sh_vert_Input # <NS11>
  myCalcData$F_f_Input <-
    myInputData$F_f_Input # <NT11>
  myCalcData$F_w_Input <-
    myInputData$F_w_Input # <NU11>
  myCalcData$c_m_Input <-
    myInputData$c_m_Input # <NV11>
  myCalcData$q_w_nd_Input <-
    myInputData$q_w_nd_Input # <NW11>
  myCalcData$DeltaT_w_nd_Input <-
    myInputData$DeltaT_w_nd_Input # <NX11>
  myCalcData$vol_w_nd_Input <-
    myInputData$vol_w_nd_Input # <NY11>
  myCalcData$h_Ref_AirExchangeRate_Input <-
    myInputData$h_Ref_AirExchangeRate_Input # <NZ11>
  myCalcData$n_Air_Window_NoVentSys_Input <-
    myInputData$n_Air_Window_NoVentSys_Input # <OA11>
  myCalcData$n_Air_Mech_Exhaust_Input <-
    myInputData$n_Air_Mech_Exhaust_Input # <OB11>
  myCalcData$n_Air_Window_VentSys_Exhaust_Input <-
    myInputData$n_Air_Window_VentSys_Exhaust_Input # <OC11>
  myCalcData$n_Air_Mech_Balanced_Input <-
    myInputData$n_Air_Mech_Balanced_Input # <OD11>
  myCalcData$n_Air_Window_VentSys_Balanced_Input <-
    myInputData$n_Air_Window_VentSys_Balanced_Input # <OE11>

  myCalcData$Code_Type_Input_BoundaryConditions <-
      myInputData$Code_Type_Input_BoundaryConditions # <OF11>

  myCalcData$Remark_BoundaryCond_1 <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$Remark_BoundaryCond_Input, 0) != 0,
              myCalcData$Remark_BoundaryCond_Input,
              myCalcData$Remark_BoundaryCond_1_Lib
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$Remark_BoundaryCond_Input,
              myCalcData$Remark_BoundaryCond_1_Lib
          )
      ) # <OG11>


  ###################################################################################X
  ## . Calculation values: Select library values or individual input   -----

  myCalcData$theta_i <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$theta_i_Input, 0) != 0,
              myCalcData$theta_i_Input,
              myCalcData$theta_i_Lib
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$theta_i_Input,
              myCalcData$theta_i_Lib
          )
      ) # <OH11>

  myCalcData$h_tr_A <-
      AuxFunctions::Replace_NA (
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
              ifelse (
                  AuxFunctions::Replace_NA (myCalcData$h_tr_A_Input, 0) != 0,
                  myCalcData$h_tr_A_Input,
                  myCalcData$h_tr_A_Lib
              ),
              ifelse (
                  myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
                  myCalcData$h_tr_A_Input,
                  myCalcData$h_tr_A_Lib
              )
          ),
          1
      ) # <OI11>

  myCalcData$h_tr_B <-
      AuxFunctions::Replace_NA (
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
              ifelse (
                  AuxFunctions::Replace_NA (myCalcData$h_tr_B_Input, 0) != 0,
                  myCalcData$h_tr_B_Input,
                  myCalcData$h_tr_B_Lib
              ),
              ifelse (
                  myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
                  myCalcData$h_tr_B_Input,
                  myCalcData$h_tr_B_Lib
              )
          ),
          4
      ) # <OJ11>

  myCalcData$theta_i_htrA <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$theta_i_htrA_Input, 0) != 0,
              myCalcData$theta_i_htrA_Input,
              myCalcData$theta_i_htrA_Lib
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$theta_i_htrA_Input,
              myCalcData$theta_i_htrA_Lib
          )
      ) # <OK11>

  myCalcData$theta_i_htrB <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$theta_i_htrB_Input, 0) != 0,
              myCalcData$theta_i_htrB_Input,
              myCalcData$theta_i_htrB_Lib
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$theta_i_htrB_Input,
              myCalcData$theta_i_htrB_Lib
          )
      ) # <OL11>

  myCalcData$F_red_htrA <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$F_red_htrA_Input, 0) != 0,
              myCalcData$F_red_htrA_Input,
              myCalcData$F_red_htrA_Lib
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$F_red_htrA_Input,
              myCalcData$F_red_htrA_Lib
          )
      ) # <OM11>
  myCalcData$F_red_htrB <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$F_red_htrB_Input, 0) != 0,
              myCalcData$F_red_htrB_Input,
              myCalcData$F_red_htrB_Lib
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$F_red_htrB_Input,
              myCalcData$F_red_htrB_Lib
          )
      ) # <ON11>
  myCalcData$phi_int <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$phi_int_Input, 0) != 0,
              myCalcData$phi_int_Input,
              myCalcData$phi_int_Lib
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$phi_int_Input,
              myCalcData$phi_int_Lib
          )
      ) # <OO11>
  myCalcData$F_sh_hor <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$F_sh_hor_Input, 0) != 0,
              myCalcData$F_sh_hor_Input,
              myCalcData$F_sh_hor_Lib
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$F_sh_hor_Input,
              myCalcData$F_sh_hor_Lib
          )
      ) # <OP11>
  myCalcData$F_sh_vert <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$F_sh_vert_Input, 0) != 0,
              myCalcData$F_sh_vert_Input,
              myCalcData$F_sh_vert_Lib
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$F_sh_vert_Input,
              myCalcData$F_sh_vert_Lib
          )
      ) # <OQ11>
  myCalcData$F_f <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$F_f_Input, 0) != 0,
              myCalcData$F_f_Input,
              myCalcData$F_f_Lib
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$F_f_Input,
              myCalcData$F_f_Lib
          )
      ) # <OR11>
  myCalcData$F_w <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$F_w_Input, 0) != 0,
              myCalcData$F_w_Input,
              myCalcData$F_w_Lib
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$F_w_Input,
              myCalcData$F_w_Lib
          )
      ) # <OS11>

  myCalcData$c_m <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$c_m_Input, 0) != 0,
              myCalcData$c_m_Input,
              myCalcData$c_m_Lib
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$c_m_Input,
              myCalcData$c_m_Lib
          )
      ) # <OT11>

  myCalcData$q_w_nd_tmp <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$q_w_nd_Input, 0) != 0,
              myCalcData$q_w_nd_Input,
              myCalcData$q_w_nd_Lib
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$q_w_nd_Input,
              myCalcData$q_w_nd_Lib
          )
      ) # <OU11>
  myCalcData$DeltaT_w_nd <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$DeltaT_w_nd_Input, 0) != 0,
              myCalcData$DeltaT_w_nd_Input,
              myCalcData$DeltaT_w_nd_Lib
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$DeltaT_w_nd_Input,
              myCalcData$DeltaT_w_nd_Lib
          )
      ) # <OV11>
  myCalcData$vol_w_nd <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$vol_w_nd_Input, 0) != 0,
              myCalcData$vol_w_nd_Input,
              myCalcData$vol_w_nd_Lib
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$vol_w_nd_Input,
              myCalcData$vol_w_nd_Lib
          )
      ) # <OW11>
  myCalcData$h_Ref_AirExchangeRate <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$h_Ref_AirExchangeRate_Input, 0) != 0,
              myCalcData$h_Ref_AirExchangeRate_Input,
              myCalcData$h_room_Lib
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$h_Ref_AirExchangeRate_Input,
              myCalcData$h_room_Lib
          )
      ) # <OX11>
  myCalcData$n_Air_Window_NoVentSys <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              AuxFunctions::Replace_NA (myCalcData$n_Air_Window_NoVentSys_Input, 0) != 0,
              myCalcData$n_Air_Window_NoVentSys_Input,
              AuxFunctions::Replace_NA (
                  myCalcData$n_Air_Window_NoVentSys_Lib,
                  myCalcData$n_air_use_Lib
              )
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$n_Air_Window_NoVentSys_Input,
              AuxFunctions::Replace_NA (
                  myCalcData$n_Air_Window_NoVentSys_Lib,
                  myCalcData$n_air_use_Lib
              )
          )
      ) # <OY11>
  myCalcData$n_Air_Window_VentSys_Exhaust <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              is.na (myCalcData$n_Air_Window_VentSys_Exhaust_Input),
              AuxFunctions::Replace_NA (
                  myCalcData$n_Air_Window_VentSys_Exhaust_Lib,
                  myCalcData$n_air_use_Lib
              ),
              myCalcData$n_Air_Window_VentSys_Exhaust_Input
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$n_Air_Window_VentSys_Exhaust_Input,
              AuxFunctions::Replace_NA (
                  myCalcData$n_Air_Window_VentSys_Exhaust_Lib,
                  myCalcData$n_air_use_Lib
              )
          )
      ) # <OZ11>
  myCalcData$n_Air_Window_VentSys_Balanced <-
      ifelse (
          myCalcData$Code_Type_Input_BoundaryConditions == "AccordingToAvailability",
          ifelse (
              is.na (myCalcData$n_Air_Window_VentSys_Balanced_Input),
              AuxFunctions::Replace_NA (
                  myCalcData$n_Air_Window_VentSys_Balanced_Lib,
                  myCalcData$n_air_use_Lib
              ),
              myCalcData$n_Air_Window_VentSys_Balanced_Input
          ),
          ifelse (
              myCalcData$Code_Type_Input_BoundaryConditions == "CalcInputIndividual",
              myCalcData$n_Air_Window_VentSys_Balanced_Input,
              AuxFunctions::Replace_NA (
                  myCalcData$n_Air_Window_VentSys_Balanced_Lib,
                  myCalcData$n_air_use_Lib
              )
          )
      ) # <PA11>
  myCalcData$q_w_nd <-
      ifelse (
        is.na (myCalcData$q_w_nd_tmp),
        #AuxFunctions::xl_OR (myCalcData$q_w_nd_tmp == 0, myCalcData$q_w_nd_tmp == ""),
          myCalcData$DeltaT_w_nd * myCalcData$vol_w_nd * 1.16 / 1000,
          myCalcData$q_w_nd_tmp
      ) # <PB11>


  myCalcData$q_w_nd_UtilOpCond <- myCalcData$q_w_nd # for checking



  #.---------------------------------------------------------------------------------------------------

  ###################################################################################X
  ## Operation conditions    ------------
  ###################################################################################X

  #++++++ not yet implemented in EnergyProfile.xlsm / input not yet available ++++++



  ###################################################################################X
  #  4 OUTPUT  -----
  ###################################################################################X


  ###################################################################################X
  ##  . Return dataframe "myCalcData" including new calculation variables   ------


return (myCalcData)



} # End of function


## End of the function UtilOpCond () -----
#####################################################################################X


#.------------------------------------------------------------------------------------





