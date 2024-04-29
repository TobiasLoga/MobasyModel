#####################################################################################X
##
##    File name:        "AssignOutput.R"
##
##    Module of:        "EnergyProfile.R"
##
##    Task:             Transformation of variables
##
##    Project:          MOBASY
##
##    Author:           Tobias Loga (t.loga@iwu.de)
##                      IWU - Institut Wohnen und Umwelt, Darmstadt / Germany
##
##    Created:          28-04-2023
##    Last changes:     28-04-2023
##
#####################################################################################X



#####################################################################################X
#  INTRODUCTION ------
#####################################################################################X

# The script provides functions to be used for transformation of variables

#####################################################################################X
##  Dependencies ------

# AuxFunctions.R
# AuxConstants.R


#####################################################################################X
##  Overview of functions ------

## Functions included in the script below


## AssignOutput (myDataOut, myDataCalc)
#
# This function is used to provide the output variables of the monitoring table "Data.Building"
# from the datafram Data_Calc
#
# Call from:
# Main script "EnergyProfile.R"
#
# Input:
# Data_Calc --> myDataCalc
#
# Output:
# myDataOut --> Data_Output





#####################################################################################X
#  FUNCTION SCRIPTS ------
#####################################################################################X

# . ----------------------------------------------------------------------------------


#####################################################################################X
## FUNCTION "AssignOutput ()" -----
#####################################################################################X


AssignOutput <- function (
    myDataOut,
    myDataCalc
)

{

  cat ("AssignOutput ()", fill = TRUE)

  ###################################################################################X
  # A  DESCRIPTIOM  -----
  ###################################################################################X

  # see INTRODUCTION above

  ###################################################################################X
  # B  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X
  ## After debugging: Comment this section


  # myDataOut  <- Data_Output
  # myDataCalc    <- Data_Calc


  ###################################################################################X
  # C  FUNCTION SCRIPT   -----
  ###################################################################################X


  ###################################################################################X
  ## 1  Initialisation   -----

  # myRowNumber <- nrow (myDataCalc)
  #
  # myDataOut <- as.data.frame (
  #   matrix (NA,
  #           nrow = myRowNumber,
  #           ncol = length (ColNames_DataOut))
  # )
  #
  # colnames (myDataOut) <- ColNames_DataOut


  ###################################################################################X
  ## 2  Transformation   -----

  # The following script text has been prepared by use of
  # the workbook "AuxTables_TransformationScript.xlsx" sheet "Data_Output"
  # Any changes of the script should be prepared in that table.

  myDataOut$ID_Dataset                                                             <-
          AuxFunctions::Replace_NULL (myDataCalc$ID_Dataset, NA)
  myDataOut$Code_Model1_Type_Procedure                                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Type_Procedure, NA)
  myDataOut$Remark_Model1_01                                                       <-
          AuxFunctions::Replace_NULL (myDataCalc$Remark_Model1_01, NA)
  myDataOut$Remark_Model1_02                                                       <-
          AuxFunctions::Replace_NULL (myDataCalc$Remark_Model1_02, NA)
  myDataOut$Date_Model1_Change                                                     <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_Change, NA)
  myDataOut$A_Model1_C_Ref                                                         <-
    round (AuxFunctions::Replace_NULL (myDataCalc$A_C_Ref, NA), digits = 1)
  ## 2024-04-26 - incorrect variable, corrected see above
  # myDataOut$A_Model1_C_Ref                                                         <-
  #         round (AuxFunctions::Replace_NULL (myDataCalc$A_Calc_C_Ref, NA), digits = 1)
  myDataOut$A_Model1_C_Living                                                      <-
          round (AuxFunctions::Replace_NULL (myDataCalc$A_Calc_C_Living, NA), digits = 1)
  myDataOut$A_Model1_C_National                                                    <-
          round (AuxFunctions::Replace_NULL (myDataCalc$A_Calc_C_National, NA), digits = 1)
  myDataOut$Code_Model1_Type_EnvelopeArea                                          <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Calc_Type_EnvelopeArea, NA)
  myDataOut$A_Model1_Roof_01                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$A_Calc_Roof_01, NA), digits = 1)
  myDataOut$A_Model1_Roof_02                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$A_Calc_Roof_02, NA), digits = 1)
  myDataOut$A_Model1_Wall_01                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$A_Calc_Wall_01, NA), digits = 1)
  myDataOut$A_Model1_Wall_02                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$A_Calc_Wall_02, NA), digits = 1)
  myDataOut$A_Model1_Wall_03                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$A_Calc_Wall_03, NA), digits = 1)
  myDataOut$A_Model1_Floor_01                                                      <-
          round (AuxFunctions::Replace_NULL (myDataCalc$A_Calc_Floor_01, NA), digits = 1)
  myDataOut$A_Model1_Floor_02                                                      <-
          round (AuxFunctions::Replace_NULL (myDataCalc$A_Calc_Floor_02, NA), digits = 1)
  myDataOut$A_Model1_Window_01                                                     <-
          round (AuxFunctions::Replace_NULL (myDataCalc$A_Calc_Window_01, NA), digits = 1)
  myDataOut$A_Model1_Window_02                                                     <-
          round (AuxFunctions::Replace_NULL (myDataCalc$A_Calc_Window_02, NA), digits = 1)
  myDataOut$A_Model1_Door_01                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$A_Calc_Door_01, NA), digits = 1)
  myDataOut$U_Model1_Roof_01                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$U_Actual_Roof_01, NA), digits = 3)
  myDataOut$U_Model1_Roof_02                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$U_Actual_Roof_02, NA), digits = 3)
  myDataOut$U_Model1_Wall_01                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$U_Actual_Wall_01, NA), digits = 3)
  myDataOut$U_Model1_Wall_02                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$U_Actual_Wall_02, NA), digits = 3)
  myDataOut$U_Model1_Wall_03                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$U_Actual_Wall_03, NA), digits = 3)
  myDataOut$U_Model1_Floor_01                                                      <-
          round (AuxFunctions::Replace_NULL (myDataCalc$U_Actual_Floor_01, NA), digits = 3)
  myDataOut$U_Model1_Floor_02                                                      <-
          round (AuxFunctions::Replace_NULL (myDataCalc$U_Actual_Floor_02, NA), digits = 3)
  myDataOut$U_Model1_Window_01                                                     <-
          round (AuxFunctions::Replace_NULL (myDataCalc$U_Actual_Window_01, NA), digits = 3)
  myDataOut$U_Model1_Window_02                                                     <-
          round (AuxFunctions::Replace_NULL (myDataCalc$U_Actual_Window_02, NA), digits = 3)
  myDataOut$U_Model1_Door_01                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$U_Actual_Door_01, NA), digits = 3)
  myDataOut$delta_U_Model1_ThermalBridging                                         <-
          round (AuxFunctions::Replace_NULL (myDataCalc$delta_U_ThermalBridging, NA), digits = 3)
  myDataOut$n_Model1_air_infiltration                                              <-
          round (AuxFunctions::Replace_NULL (myDataCalc$n_air_infiltration, NA), digits = 3)
  myDataOut$n_Model1_air_use                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$n_air_use, NA), digits = 3)
  myDataOut$n_Model1_air_mech                                                      <-
          round (AuxFunctions::Replace_NULL (myDataCalc$n_Calc_air_mech, NA), digits = 3)
  myDataOut$n_Model1_air_total                                                     <-
          round (AuxFunctions::Replace_NULL (myDataCalc$n_air_use + myDataCalc$n_air_infiltration, NA), digits = 3)
  myDataOut$eta_Model1_ve_rec                                                      <-
          round (AuxFunctions::Replace_NULL (myDataCalc$eta_ve_rec, NA), digits = 3)
  myDataOut$h_Model1_ht_tr                                                         <-
          round (AuxFunctions::Replace_NULL (myDataCalc$h_Transmission, NA), digits = 3)
  myDataOut$h_Model1_ht_ve                                                         <-
          round (AuxFunctions::Replace_NULL (myDataCalc$h_Ventilation, NA), digits = 3)
  myDataOut$Sum_DeltaT_for_HeatingDays_Model1                                      <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Sum_DeltaT_for_HeatingDays, NA), digits = 0)
  myDataOut$q_Model1_ht_tr                                                         <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_ht_tr, NA), digits = 1)
  myDataOut$q_Model1_ht_ve                                                         <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_ht_ve, NA), digits = 1)
  myDataOut$q_Model1_sol                                                           <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_sol, NA), digits = 1)
  myDataOut$q_Model1_int                                                           <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_int, NA), digits = 1)
  myDataOut$a_Model1_H                                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$a_H, NA), digits = 3)
  myDataOut$eta_Model1_h_gn                                                        <-
          round (AuxFunctions::Replace_NULL (myDataCalc$eta_h_gn, NA), digits = 3)
  myDataOut$q_Model1_h_nd                                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_h_nd, NA), digits = 1)
  myDataOut$q_Model1_h_nd_net                                                      <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_h_nd_net, NA), digits = 1)
  myDataOut$Code_Model1_SysH_G_1                                                   <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_SysH_G_1, NA)
  myDataOut$Code_Model1_SysH_EC_1                                                  <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_SysH_EC_1, NA)
  myDataOut$q_Model1_g_out_h_1                                                     <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_g_out_h_1, NA), digits = 1)
  myDataOut$q_Model1_del_h_1                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_h_1, NA), digits = 1)
  myDataOut$q_Model1_prod_el_h_1                                                   <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_prod_el_h_1, NA), digits = 1)
  myDataOut$Code_Model1_SysH_G_2                                                   <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_SysH_G_2, NA)
  myDataOut$Code_Model1_SysH_EC_2                                                  <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_SysH_EC_2, NA)
  myDataOut$q_Model1_g_out_h_2                                                     <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_g_out_h_2, NA), digits = 1)
  myDataOut$q_Model1_del_h_2                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_h_2, NA), digits = 1)
  myDataOut$q_Model1_prod_el_h_2                                                   <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_prod_el_h_2, NA), digits = 1)
  myDataOut$Code_Model1_SysH_G_3                                                   <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_SysH_G_3, NA)
  myDataOut$Code_Model1_SysH_EC_3                                                  <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_SysH_EC_3, NA)
  myDataOut$q_Model1_g_out_h_3                                                     <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_g_out_h_3, NA), digits = 1)
  myDataOut$q_Model1_del_h_3                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_h_3, NA), digits = 1)
  myDataOut$q_Model1_prod_el_h_3                                                   <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_prod_el_h_3, NA), digits = 1)
  myDataOut$q_Model1_del_h_aux                                                     <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_h_aux, NA), digits = 1)
  myDataOut$q_Model1_del_ve_aux                                                    <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_ve_aux, NA), digits = 1)
  myDataOut$q_Model1_p_Total_SysH                                                  <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_p_Total_SysH, NA), digits = 1)
  myDataOut$q_Model1_p_NonRen_SysH                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_p_NonRen_SysH, NA), digits = 1)
  myDataOut$q_Model1_w_nd                                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_w_nd, NA), digits = 1)
  myDataOut$Code_Model1_SysW_G_1                                                   <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_SysW_G_1, NA)
  myDataOut$Code_Model1_SysW_EC_1                                                  <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_SysW_EC_1, NA)
  myDataOut$q_Model1_g_out_w_1                                                     <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_g_out_w_1, NA), digits = 1)
  myDataOut$q_Model1_del_w_1                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_w_1, NA), digits = 1)
  myDataOut$q_Model1_prod_el_w_1                                                   <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_prod_el_w_1, NA), digits = 1)
  myDataOut$Code_Model1_SysW_G_2                                                   <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_SysW_G_2, NA)
  myDataOut$Code_Model1_SysW_EC_2                                                  <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_SysW_EC_2, NA)
  myDataOut$q_Model1_g_out_w_2                                                     <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_g_out_w_2, NA), digits = 1)
  myDataOut$q_Model1_del_w_2                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_w_2, NA), digits = 1)
  myDataOut$q_Model1_prod_el_w_2                                                   <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_prod_el_w_2, NA), digits = 1)
  myDataOut$Code_Model1_SysW_G_3                                                   <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_SysW_G_3, NA)
  myDataOut$Code_Model1_SysW_EC_3                                                  <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_SysW_EC_3, NA)
  myDataOut$q_Model1_g_out_w_3                                                     <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_g_out_w_3, NA), digits = 1)
  myDataOut$q_Model1_del_w_3                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_w_3, NA), digits = 1)
  myDataOut$q_Model1_prod_el_w_3                                                   <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_prod_el_w_3, NA), digits = 1)
  myDataOut$q_Model1_del_w_aux                                                     <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_w_aux, NA), digits = 1)
  myDataOut$q_Model1_p_Total_SysW                                                  <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_p_Total_SysW, NA), digits = 1)
  myDataOut$q_Model1_p_NonRen_SysW                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_p_NonRen_SysW, NA), digits = 1)
  myDataOut$q_Model1_del_h_sum_gas                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_h_sum_gas, NA), digits = 1)
  myDataOut$q_Model1_del_h_sum_oil                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_h_sum_oil, NA), digits = 1)
  myDataOut$q_Model1_del_h_sum_coal                                                <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_h_sum_coal, NA), digits = 1)
  myDataOut$q_Model1_del_h_sum_bio                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_h_sum_bio, NA), digits = 1)
  myDataOut$q_Model1_del_h_sum_el                                                  <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_h_sum_el, NA), digits = 1)
  myDataOut$q_Model1_del_h_sum_dh                                                  <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_h_sum_dh, NA), digits = 1)
  myDataOut$q_Model1_del_h_sum_other                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_h_sum_other, NA), digits = 1)
  myDataOut$q_Model1_prod_h_sum_el                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_prod_h_sum_el, NA), digits = 1)
  myDataOut$q_Model1_del_w_sum_gas                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_w_sum_gas, NA), digits = 1)
  myDataOut$q_Model1_del_w_sum_oil                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_w_sum_oil, NA), digits = 1)
  myDataOut$q_Model1_del_w_sum_coal                                                <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_w_sum_coal, NA), digits = 1)
  myDataOut$q_Model1_del_w_sum_bio                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_w_sum_bio, NA), digits = 1)
  myDataOut$q_Model1_del_w_sum_el                                                  <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_w_sum_el, NA), digits = 1)
  myDataOut$q_Model1_del_w_sum_dh                                                  <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_w_sum_dh, NA), digits = 1)
  myDataOut$q_Model1_del_w_sum_other                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_w_sum_other, NA), digits = 1)
  myDataOut$q_Model1_prod_w_sum_el                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_prod_w_sum_el, NA), digits = 1)
  myDataOut$q_Model1_del_sum_gas                                                   <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_sum_gas, NA), digits = 1)
  myDataOut$q_Model1_del_sum_oil                                                   <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_sum_oil, NA), digits = 1)
  myDataOut$q_Model1_del_sum_coal                                                  <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_sum_coal, NA), digits = 1)
  myDataOut$q_Model1_del_sum_bio                                                   <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_sum_bio, NA), digits = 1)
  myDataOut$q_Model1_del_sum_el                                                    <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_sum_el, NA), digits = 1)
  myDataOut$q_Model1_del_sum_dh                                                    <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_sum_dh, NA), digits = 1)
  myDataOut$q_Model1_del_sum_other                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_del_sum_other, NA), digits = 1)
  myDataOut$q_Model1_prod_sum_el                                                   <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_prod_sum_el, NA), digits = 1)
  myDataOut$q_Model1_p_Total                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_p_Total, NA), digits = 1)
  myDataOut$q_Model1_p_NonRen                                                      <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_p_NonRen, NA), digits = 1)
  myDataOut$theta_i_Model1                                                         <-
          round (AuxFunctions::Replace_NULL (myDataCalc$theta_i, NA), digits = 1)
  myDataOut$h_tr_A_Model1                                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$h_tr_A, NA), digits = 3)
  myDataOut$h_tr_B_Model1                                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$h_tr_B, NA), digits = 3)
  myDataOut$theta_i_htrA_Model1                                                    <-
          round (AuxFunctions::Replace_NULL (myDataCalc$theta_i_htrA, NA), digits = 1)
  myDataOut$theta_i_htrB_Model1                                                    <-
          round (AuxFunctions::Replace_NULL (myDataCalc$theta_i_htrB, NA), digits = 1)
  myDataOut$F_red_htrA_Model1                                                      <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_red_htrA, NA), digits = 3)
  myDataOut$F_red_htrB_Model1                                                      <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_red_htrB, NA), digits = 3)
  myDataOut$theta_i_calc_Model1                                                    <-
          round (AuxFunctions::Replace_NULL (myDataCalc$theta_i_calc, NA), digits = 1)
  myDataOut$F_red_temp_Model1                                                      <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_red_temp, NA), digits = 3)
  myDataOut$h_Ref_AirExchangeRate_Model1                                           <-
          round (AuxFunctions::Replace_NULL (myDataCalc$h_Ref_AirExchangeRate, NA), digits = 3)
  myDataOut$phi_int_Model1                                                         <-
          round (AuxFunctions::Replace_NULL (myDataCalc$phi_int, NA), digits = 1)
  myDataOut$F_sh_hor_Model1                                                        <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_sh_hor, NA), digits = 3)
  myDataOut$F_sh_vert_Model1                                                       <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_sh_vert, NA), digits = 3)
  myDataOut$F_f_Model1                                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_f, NA), digits = 3)
  myDataOut$F_w_Model1                                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_w, NA), digits = 3)
  myDataOut$c_m_Model1                                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$c_m, NA), digits = 1)
  myDataOut$Code_ClimateRegion_Model1                                              <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_ClimateRegion, NA)
  myDataOut$Name_ClimateRegion_Model1                                              <-
          AuxFunctions::Replace_NULL (myDataCalc$Name_ClimateRegion, NA)
  myDataOut$theta_e_Base_Model1                                                    <-
          round (AuxFunctions::Replace_NULL (myDataCalc$theta_e_Base, NA), digits = 1)
  myDataOut$HeatingDays_Model1                                                     <-
          round (AuxFunctions::Replace_NULL (myDataCalc$HeatingDays, NA), digits = 0)
  myDataOut$theta_e_HD_Model1                                                      <-
          round (AuxFunctions::Replace_NULL (myDataCalc$theta_e, NA), digits = 1)
  myDataOut$I_Sol_HD_Hor_Model1                                                    <-
          round (AuxFunctions::Replace_NULL (myDataCalc$I_Sol_HD_Hor, NA), digits = 0)
  myDataOut$I_Sol_HD_East_Model1                                                   <-
          round (AuxFunctions::Replace_NULL (myDataCalc$I_Sol_HD_East, NA), digits = 0)
  myDataOut$I_Sol_HD_South_Model1                                                  <-
          round (AuxFunctions::Replace_NULL (myDataCalc$I_Sol_HD_South, NA), digits = 0)
  myDataOut$I_Sol_HD_West_Model1                                                   <-
          round (AuxFunctions::Replace_NULL (myDataCalc$I_Sol_HD_West, NA), digits = 0)
  myDataOut$I_Sol_HD_North_Model1                                                  <-
          round (AuxFunctions::Replace_NULL (myDataCalc$I_Sol_HD_North, NA), digits = 0)
  myDataOut$I_Sol_Year_Hor_Model1                                                  <-
          round (AuxFunctions::Replace_NULL (myDataCalc$I_Sol_Year_Hor, NA), digits = 0)
  myDataOut$I_Sol_Year_East_Model1                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$I_Sol_Year_East, NA), digits = 0)
  myDataOut$I_Sol_Year_South_Model1                                                <-
          round (AuxFunctions::Replace_NULL (myDataCalc$I_Sol_Year_South, NA), digits = 0)
  myDataOut$I_Sol_Year_West_Model1                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$I_Sol_Year_West, NA), digits = 0)
  myDataOut$I_Sol_Year_North_Model1                                                <-
          round (AuxFunctions::Replace_NULL (myDataCalc$I_Sol_Year_North, NA), digits = 0)
  myDataOut$theta_i_effective_Model1                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$theta_i_effective, NA), digits = 1)
  myDataOut$Code_CalcAdapt_M_Model1                                                <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_CalcAdapt_M, NA)
  myDataOut$F_CalcAdapt_M_Model1                                                   <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_CalcAdapt_M, NA), digits = 3)
  myDataOut$Code_Model1_TypePeriod_MeterComparison_01                              <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_TypePeriod_MeterComparison_01, NA)
  myDataOut$Date_Model1_BalanceYears_Start_01                                      <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_Start_01, NA)
  myDataOut$Date_Model1_BalanceYears_End_01                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_End_01, NA)
  myDataOut$f_Model1_Correction_HDD_01                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_HDD_01, NA), digits = 3)
  myDataOut$f_Model1_Correction_Sol_HD_01                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Sol_HD_01, NA), digits = 3)
  myDataOut$f_Model1_Correction_Int_01                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Int_01, NA), digits = 3)
  myDataOut$q_Model1_compare_w_per_sqm_01                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_w_per_sqm_01, NA), digits = 1)
  myDataOut$q_Model1_compare_h_per_sqm_01                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_h_per_sqm_01, NA), digits = 1)
  myDataOut$Code_Model1_Domain_MeterComparison_SysH_01                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysH_01, NA)
  myDataOut$Code_Model1_Domain_MeterComparison_SysW_01                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysW_01, NA)
  myDataOut$F_Model1_CalcAdapt_M_01                                                <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_Model1_CalcAdapt_M_01, NA), digits = 3)
  myDataOut$Indicator_Model1_CalcAdapt_M_01                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Indicator_Model1_CalcAdapt_M_01, NA)
  myDataOut$q_Model1_calc_per_sqm_01                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_calc_per_sqm_01, NA), digits = 1)
  myDataOut$q_Model1_meter_per_sqm_01                                              <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_meter_per_sqm_01, NA), digits = 1)
  myDataOut$ratio_Model1_q_meter_q_calc_01                                         <-
          round (AuxFunctions::Replace_NULL (myDataCalc$ratio_Model1_q_meter_q_calc_01, NA), digits = 3)
  myDataOut$Code_Model1_TypePeriod_MeterComparison_02                              <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_TypePeriod_MeterComparison_02, NA)
  myDataOut$Date_Model1_BalanceYears_Start_02                                      <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_Start_02, NA)
  myDataOut$Date_Model1_BalanceYears_End_02                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_End_02, NA)
  myDataOut$f_Model1_Correction_HDD_02                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_HDD_02, NA), digits = 3)
  myDataOut$f_Model1_Correction_Sol_HD_02                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Sol_HD_02, NA), digits = 3)
  myDataOut$f_Model1_Correction_Int_02                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Int_02, NA), digits = 3)
  myDataOut$q_Model1_compare_w_per_sqm_02                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_w_per_sqm_02, NA), digits = 1)
  myDataOut$q_Model1_compare_h_per_sqm_02                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_h_per_sqm_02, NA), digits = 1)
  myDataOut$Code_Model1_Domain_MeterComparison_SysH_02                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysH_02, NA)
  myDataOut$Code_Model1_Domain_MeterComparison_SysW_02                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysW_02, NA)
  myDataOut$F_Model1_CalcAdapt_M_02                                                <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_Model1_CalcAdapt_M_02, NA), digits = 3)
  myDataOut$Indicator_Model1_CalcAdapt_M_02                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Indicator_Model1_CalcAdapt_M_02, NA)
  myDataOut$q_Model1_calc_per_sqm_02                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_calc_per_sqm_02, NA), digits = 1)
  myDataOut$q_Model1_meter_per_sqm_02                                              <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_meter_per_sqm_02, NA), digits = 1)
  myDataOut$ratio_Model1_q_meter_q_calc_02                                         <-
          round (AuxFunctions::Replace_NULL (myDataCalc$ratio_Model1_q_meter_q_calc_02, NA), digits = 3)
  myDataOut$Code_Model1_TypePeriod_MeterComparison_03                              <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_TypePeriod_MeterComparison_03, NA)
  myDataOut$Date_Model1_BalanceYears_Start_03                                      <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_Start_03, NA)
  myDataOut$Date_Model1_BalanceYears_End_03                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_End_03, NA)
  myDataOut$f_Model1_Correction_HDD_03                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_HDD_03, NA), digits = 3)
  myDataOut$f_Model1_Correction_Sol_HD_03                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Sol_HD_03, NA), digits = 3)
  myDataOut$f_Model1_Correction_Int_03                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Int_03, NA), digits = 3)
  myDataOut$q_Model1_compare_w_per_sqm_03                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_w_per_sqm_03, NA), digits = 1)
  myDataOut$q_Model1_compare_h_per_sqm_03                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_h_per_sqm_03, NA), digits = 1)
  myDataOut$Code_Model1_Domain_MeterComparison_SysH_03                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysH_03, NA)
  myDataOut$Code_Model1_Domain_MeterComparison_SysW_03                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysW_03, NA)
  myDataOut$F_Model1_CalcAdapt_M_03                                                <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_Model1_CalcAdapt_M_03, NA), digits = 3)
  myDataOut$Indicator_Model1_CalcAdapt_M_03                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Indicator_Model1_CalcAdapt_M_03, NA)
  myDataOut$q_Model1_calc_per_sqm_03                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_calc_per_sqm_03, NA), digits = 1)
  myDataOut$q_Model1_meter_per_sqm_03                                              <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_meter_per_sqm_03, NA), digits = 1)
  myDataOut$ratio_Model1_q_meter_q_calc_03                                         <-
          round (AuxFunctions::Replace_NULL (myDataCalc$ratio_Model1_q_meter_q_calc_03, NA), digits = 3)
  myDataOut$Code_Model1_TypePeriod_MeterComparison_04                              <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_TypePeriod_MeterComparison_04, NA)
  myDataOut$Date_Model1_BalanceYears_Start_04                                      <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_Start_04, NA)
  myDataOut$Date_Model1_BalanceYears_End_04                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_End_04, NA)
  myDataOut$f_Model1_Correction_HDD_04                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_HDD_04, NA), digits = 3)
  myDataOut$f_Model1_Correction_Sol_HD_04                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Sol_HD_04, NA), digits = 3)
  myDataOut$f_Model1_Correction_Int_04                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Int_04, NA), digits = 3)
  myDataOut$q_Model1_compare_w_per_sqm_04                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_w_per_sqm_04, NA), digits = 1)
  myDataOut$q_Model1_compare_h_per_sqm_04                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_h_per_sqm_04, NA), digits = 1)
  myDataOut$Code_Model1_Domain_MeterComparison_SysH_04                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysH_04, NA)
  myDataOut$Code_Model1_Domain_MeterComparison_SysW_04                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysW_04, NA)
  myDataOut$F_Model1_CalcAdapt_M_04                                                <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_Model1_CalcAdapt_M_04, NA), digits = 3)
  myDataOut$Indicator_Model1_CalcAdapt_M_04                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Indicator_Model1_CalcAdapt_M_04, NA)
  myDataOut$q_Model1_calc_per_sqm_04                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_calc_per_sqm_04, NA), digits = 1)
  myDataOut$q_Model1_meter_per_sqm_04                                              <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_meter_per_sqm_04, NA), digits = 1)
  myDataOut$ratio_Model1_q_meter_q_calc_04                                         <-
          round (AuxFunctions::Replace_NULL (myDataCalc$ratio_Model1_q_meter_q_calc_04, NA), digits = 3)
  myDataOut$Code_Model1_TypePeriod_MeterComparison_05                              <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_TypePeriod_MeterComparison_05, NA)
  myDataOut$Date_Model1_BalanceYears_Start_05                                      <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_Start_05, NA)
  myDataOut$Date_Model1_BalanceYears_End_05                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_End_05, NA)
  myDataOut$f_Model1_Correction_HDD_05                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_HDD_05, NA), digits = 3)
  myDataOut$f_Model1_Correction_Sol_HD_05                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Sol_HD_05, NA), digits = 3)
  myDataOut$f_Model1_Correction_Int_05                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Int_05, NA), digits = 3)
  myDataOut$q_Model1_compare_w_per_sqm_05                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_w_per_sqm_05, NA), digits = 1)
  myDataOut$q_Model1_compare_h_per_sqm_05                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_h_per_sqm_05, NA), digits = 1)
  myDataOut$Code_Model1_Domain_MeterComparison_SysH_05                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysH_05, NA)
  myDataOut$Code_Model1_Domain_MeterComparison_SysW_05                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysW_05, NA)
  myDataOut$F_Model1_CalcAdapt_M_05                                                <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_Model1_CalcAdapt_M_05, NA), digits = 3)
  myDataOut$Indicator_Model1_CalcAdapt_M_05                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Indicator_Model1_CalcAdapt_M_05, NA)
  myDataOut$q_Model1_calc_per_sqm_05                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_calc_per_sqm_05, NA), digits = 1)
  myDataOut$q_Model1_meter_per_sqm_05                                              <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_meter_per_sqm_05, NA), digits = 1)
  myDataOut$ratio_Model1_q_meter_q_calc_05                                         <-
          round (AuxFunctions::Replace_NULL (myDataCalc$ratio_Model1_q_meter_q_calc_05, NA), digits = 3)
  myDataOut$Code_Model1_TypePeriod_MeterComparison_06                              <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_TypePeriod_MeterComparison_06, NA)
  myDataOut$Date_Model1_BalanceYears_Start_06                                      <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_Start_06, NA)
  myDataOut$Date_Model1_BalanceYears_End_06                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_End_06, NA)
  myDataOut$f_Model1_Correction_HDD_06                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_HDD_06, NA), digits = 3)
  myDataOut$f_Model1_Correction_Sol_HD_06                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Sol_HD_06, NA), digits = 3)
  myDataOut$f_Model1_Correction_Int_06                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Int_06, NA), digits = 3)
  myDataOut$q_Model1_compare_w_per_sqm_06                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_w_per_sqm_06, NA), digits = 1)
  myDataOut$q_Model1_compare_h_per_sqm_06                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_h_per_sqm_06, NA), digits = 1)
  myDataOut$Code_Model1_Domain_MeterComparison_SysH_06                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysH_06, NA)
  myDataOut$Code_Model1_Domain_MeterComparison_SysW_06                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysW_06, NA)
  myDataOut$F_Model1_CalcAdapt_M_06                                                <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_Model1_CalcAdapt_M_06, NA), digits = 3)
  myDataOut$Indicator_Model1_CalcAdapt_M_06                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Indicator_Model1_CalcAdapt_M_06, NA)
  myDataOut$q_Model1_calc_per_sqm_06                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_calc_per_sqm_06, NA), digits = 1)
  myDataOut$q_Model1_meter_per_sqm_06                                              <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_meter_per_sqm_06, NA), digits = 1)
  myDataOut$ratio_Model1_q_meter_q_calc_06                                         <-
          round (AuxFunctions::Replace_NULL (myDataCalc$ratio_Model1_q_meter_q_calc_06, NA), digits = 3)
  myDataOut$Code_Model1_TypePeriod_MeterComparison_07                              <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_TypePeriod_MeterComparison_07, NA)
  myDataOut$Date_Model1_BalanceYears_Start_07                                      <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_Start_07, NA)
  myDataOut$Date_Model1_BalanceYears_End_07                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_End_07, NA)
  myDataOut$f_Model1_Correction_HDD_07                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_HDD_07, NA), digits = 3)
  myDataOut$f_Model1_Correction_Sol_HD_07                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Sol_HD_07, NA), digits = 3)
  myDataOut$f_Model1_Correction_Int_07                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Int_07, NA), digits = 3)
  myDataOut$q_Model1_compare_w_per_sqm_07                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_w_per_sqm_07, NA), digits = 1)
  myDataOut$q_Model1_compare_h_per_sqm_07                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_h_per_sqm_07, NA), digits = 1)
  myDataOut$Code_Model1_Domain_MeterComparison_SysH_07                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysH_07, NA)
  myDataOut$Code_Model1_Domain_MeterComparison_SysW_07                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysW_07, NA)
  myDataOut$F_Model1_CalcAdapt_M_07                                                <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_Model1_CalcAdapt_M_07, NA), digits = 3)
  myDataOut$Indicator_Model1_CalcAdapt_M_07                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Indicator_Model1_CalcAdapt_M_07, NA)
  myDataOut$q_Model1_calc_per_sqm_07                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_calc_per_sqm_07, NA), digits = 1)
  myDataOut$q_Model1_meter_per_sqm_07                                              <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_meter_per_sqm_07, NA), digits = 1)
  myDataOut$ratio_Model1_q_meter_q_calc_07                                         <-
          round (AuxFunctions::Replace_NULL (myDataCalc$ratio_Model1_q_meter_q_calc_07, NA), digits = 3)
  myDataOut$Code_Model1_TypePeriod_MeterComparison_08                              <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_TypePeriod_MeterComparison_08, NA)
  myDataOut$Date_Model1_BalanceYears_Start_08                                      <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_Start_08, NA)
  myDataOut$Date_Model1_BalanceYears_End_08                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_End_08, NA)
  myDataOut$f_Model1_Correction_HDD_08                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_HDD_08, NA), digits = 3)
  myDataOut$f_Model1_Correction_Sol_HD_08                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Sol_HD_08, NA), digits = 3)
  myDataOut$f_Model1_Correction_Int_08                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Int_08, NA), digits = 3)
  myDataOut$q_Model1_compare_w_per_sqm_08                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_w_per_sqm_08, NA), digits = 1)
  myDataOut$q_Model1_compare_h_per_sqm_08                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_h_per_sqm_08, NA), digits = 1)
  myDataOut$Code_Model1_Domain_MeterComparison_SysH_08                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysH_08, NA)
  myDataOut$Code_Model1_Domain_MeterComparison_SysW_08                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysW_08, NA)
  myDataOut$F_Model1_CalcAdapt_M_08                                                <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_Model1_CalcAdapt_M_08, NA), digits = 3)
  myDataOut$Indicator_Model1_CalcAdapt_M_08                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Indicator_Model1_CalcAdapt_M_08, NA)
  myDataOut$q_Model1_calc_per_sqm_08                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_calc_per_sqm_08, NA), digits = 1)
  myDataOut$q_Model1_meter_per_sqm_08                                              <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_meter_per_sqm_08, NA), digits = 1)
  myDataOut$ratio_Model1_q_meter_q_calc_08                                         <-
          round (AuxFunctions::Replace_NULL (myDataCalc$ratio_Model1_q_meter_q_calc_08, NA), digits = 3)
  myDataOut$Code_Model1_TypePeriod_MeterComparison_09                              <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_TypePeriod_MeterComparison_09, NA)
  myDataOut$Date_Model1_BalanceYears_Start_09                                      <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_Start_09, NA)
  myDataOut$Date_Model1_BalanceYears_End_09                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Date_Model1_BalanceYears_End_09, NA)
  myDataOut$f_Model1_Correction_HDD_09                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_HDD_09, NA), digits = 3)
  myDataOut$f_Model1_Correction_Sol_HD_09                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Sol_HD_09, NA), digits = 3)
  myDataOut$f_Model1_Correction_Int_09                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$f_Model1_Correction_Int_09, NA), digits = 3)
  myDataOut$q_Model1_compare_w_per_sqm_09                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_w_per_sqm_09, NA), digits = 1)
  myDataOut$q_Model1_compare_h_per_sqm_09                                          <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_compare_h_per_sqm_09, NA), digits = 1)
  myDataOut$Code_Model1_Domain_MeterComparison_SysH_09                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysH_09, NA)
  myDataOut$Code_Model1_Domain_MeterComparison_SysW_09                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Model1_Domain_MeterComparison_SysW_09, NA)
  myDataOut$F_Model1_CalcAdapt_M_09                                                <-
          round (AuxFunctions::Replace_NULL (myDataCalc$F_Model1_CalcAdapt_M_09, NA), digits = 3)
  myDataOut$Indicator_Model1_CalcAdapt_M_09                                        <-
          AuxFunctions::Replace_NULL (myDataCalc$Indicator_Model1_CalcAdapt_M_09, NA)
  myDataOut$q_Model1_calc_per_sqm_09                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_calc_per_sqm_09, NA), digits = 1)
  myDataOut$q_Model1_meter_per_sqm_09                                              <-
          round (AuxFunctions::Replace_NULL (myDataCalc$q_Model1_meter_per_sqm_09, NA), digits = 1)
  myDataOut$ratio_Model1_q_meter_q_calc_09                                         <-
          round (AuxFunctions::Replace_NULL (myDataCalc$ratio_Model1_q_meter_q_calc_09, NA), digits = 3)
  myDataOut$Code_Uncertainty_A_Envelope                                            <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_A_Envelope, NA)
  myDataOut$Code_Uncertainty_InputManual_U_Top                                     <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_InputManual_U_Top, NA)
  myDataOut$Code_Uncertainty_InputManual_U_Wall                                    <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_InputManual_U_Wall, NA)
  myDataOut$Code_Uncertainty_InputManual_U_Window                                  <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_InputManual_U_Window, NA)
  myDataOut$Code_Uncertainty_InputManual_U_Bottom                                  <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_InputManual_U_Bottom, NA)
  myDataOut$Code_Uncertainty_U_Original                                            <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_U_Original, NA)
  myDataOut$Code_Uncertainty_f_Insulation_Roof                                     <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_f_Insulation_Roof, NA)
  myDataOut$Code_Uncertainty_f_Insulation_Ceiling                                  <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_f_Insulation_Ceiling, NA)
  myDataOut$Code_Uncertainty_f_Insulation_Wall                                     <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_f_Insulation_Wall, NA)
  myDataOut$Code_Uncertainty_f_Insulation_Floor                                    <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_f_Insulation_Floor, NA)
  myDataOut$Code_Uncertainty_d_Insulation_Roof                                     <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_d_Insulation_Roof, NA)
  myDataOut$Code_Uncertainty_d_Insulation_Ceiling                                  <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_d_Insulation_Ceiling, NA)
  myDataOut$Code_Uncertainty_d_Insulation_Wall                                     <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_d_Insulation_Wall, NA)
  myDataOut$Code_Uncertainty_d_Insulation_Floor                                    <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_d_Insulation_Floor, NA)
  myDataOut$Code_Uncertainty_Lambda_Insulation_Roof                                <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_Lambda_Insulation_Roof, NA)
  myDataOut$Code_Uncertainty_Lambda_Insulation_Ceiling                             <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_Lambda_Insulation_Ceiling, NA)
  myDataOut$Code_Uncertainty_Lambda_Insulation_Wall                                <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_Lambda_Insulation_Wall, NA)
  myDataOut$Code_Uncertainty_Lambda_Insulation_Floor                               <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_Lambda_Insulation_Floor, NA)
  myDataOut$Code_Uncertainty_U_WindowType1                                         <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_U_WindowType1, NA)
  myDataOut$Code_Uncertainty_U_WindowType2                                         <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_U_WindowType2, NA)
  myDataOut$Code_Uncertainty_ThermalBridging                                       <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_ThermalBridging, NA)
  myDataOut$Code_Uncertainty_n_Air_HeatLosses                                      <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_n_Air_HeatLosses, NA)
  myDataOut$Code_Uncertainty_theta_i_User                                          <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_theta_i_User, NA)
  myDataOut$Code_Uncertainty_HDD_Climate                                           <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_HDD_Climate, NA)
  myDataOut$Code_Uncertainty_A_Aperture_PassiveSolar_EquivalentSouth               <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_A_Aperture_PassiveSolar_EquivalentSouth, NA)
  myDataOut$Code_Uncertainty_I_Sol                                                 <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_I_Sol, NA)
  myDataOut$Code_Uncertainty_phi_int                                               <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_phi_int, NA)
  myDataOut$Code_Uncertainty_eta_ve_rec                                            <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_eta_ve_rec, NA)
  myDataOut$Code_Uncertainty_q_w_nd                                                <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_q_w_nd, NA)
  myDataOut$Code_Uncertainty_e_SysH                                                <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_e_SysH, NA)
  myDataOut$Code_Uncertainty_e_SysW                                                <-
          AuxFunctions::Replace_NULL (myDataCalc$Code_Uncertainty_e_SysW, NA)
  myDataOut$Delta_q_h_nd_Unc_A_Envelope                                            <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_A_Envelope, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_Roof_01                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_Roof_01, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_Roof_02                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_Roof_02, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_Wall_01                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_Wall_01, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_Wall_02                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_Wall_02, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_Wall_03                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_Wall_03, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_Floor_01                                              <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_Floor_01, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_Floor_02                                              <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_Floor_02, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_Window_01                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_Window_01, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_Window_02                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_Window_02, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_Door_01                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_Door_01, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_DeltaU_ThermalBridging                                <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_DeltaU_ThermalBridging, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_n_air                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_n_air, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_theta_i                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_theta_i, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_F_HDD                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_F_HDD, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_A_Aperture_PassiveSolar_EquivalentSouth               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_A_Aperture_PassiveSolar_EquivalentSouth, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_I_Sol                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_I_Sol, NA), digits = 2)
  myDataOut$Delta_q_h_nd_Unc_phi_int                                               <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_h_nd_Unc_phi_int, NA), digits = 2)
  myDataOut$Uncertainty_q_h_nd                                                     <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Uncertainty_q_h_nd, NA), digits = 2)
  myDataOut$Uncertainty_q_w_nd                                                     <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Uncertainty_q_w_nd, NA), digits = 2)
  myDataOut$e_g_h                                                                  <-
          round (AuxFunctions::Replace_NULL (myDataCalc$e_g_h, NA), digits = 3)
  myDataOut$e_g_w                                                                  <-
          round (AuxFunctions::Replace_NULL (myDataCalc$e_g_w, NA), digits = 3)
  myDataOut$e_SysH                                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$e_SysH, NA), digits = 3)
  myDataOut$e_SysW                                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$e_SysW, NA), digits = 3)
  myDataOut$Delta_q_del_Unc_q_h_nd                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_del_Unc_q_h_nd, NA), digits = 2)
  myDataOut$Delta_q_del_Unc_q_w_nd                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_del_Unc_q_w_nd, NA), digits = 2)
  myDataOut$Delta_q_del_Unc_eta_ve_rec                                             <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_del_Unc_eta_ve_rec, NA), digits = 2)
  myDataOut$Delta_q_del_Unc_e_SysH                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_del_Unc_e_SysH, NA), digits = 2)
  myDataOut$Delta_q_del_Unc_e_SysW                                                 <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Delta_q_del_Unc_e_SysW, NA), digits = 2)
  myDataOut$Uncertainty_q_del_h                                                    <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Uncertainty_q_del_h, NA), digits = 2)
  myDataOut$Uncertainty_q_del_w                                                    <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Uncertainty_q_del_w, NA), digits = 2)
  myDataOut$Uncertainty_q_del                                                      <-
          round (AuxFunctions::Replace_NULL (myDataCalc$Uncertainty_q_del, NA), digits = 2)



  ###################################################################################X
  ## 3  Output   -----


  return (myDataOut)


} # End of function AssignOutput ()


## End of the function AssignOutput () -----
#####################################################################################X


# . ----------------------------------------------------------------------------------



# . ----------------------------------------------------------------------------------


#####################################################################################X
## FUNCTION "ProvideChartData ()" -----
#####################################################################################X


ProvideChartData <- function (
    myDataOut,
    myDataCalc
)

{

  cat ("ProvideChartData ()", fill = TRUE)

  ###################################################################################X
  # A  DESCRIPTIOM  -----
  ###################################################################################X


  ###################################################################################X
  # B  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X
  ## After debugging: Comment this section


  # myDataOut   <- myOutputTables$Data_Output
  # myDataCalc  <- myOutputTables$Data_Calc
  #



  ###################################################################################X
  # C  FUNCTION SCRIPT   -----
  ###################################################################################X


  ###################################################################################X
  ## 1  Initialisation   -----

  DF_HeatNeed_Data        <- NA
  DF_HeatNeed_Labels      <- NA
  DF_HeatNeed_Settings    <- NA

  DF_FinalEnergy_Data     <- NA
  DF_FinalEnergy_Labels   <- NA
  DF_FinalEnergy_Settings <- NA


  ###################################################################################X
  ## 2  Prepare data for heat need chart / energy balance of building envelope   -----

  ## Transmission losses

  # DF_A_Elements  <-
  #   data.frame (
  #     myDataOut [ ,
  #       c(
  #         "A_Model1_Roof_01",
  #         "A_Model1_Roof_02",
  #         "A_Model1_Wall_01",
  #         "A_Model1_Wall_02",
  #         "A_Model1_Wall_03",
  #         "A_Model1_Floor_01",
  #         "A_Model1_Floor_02",
  #         "A_Model1_Window_01",
  #         "A_Model1_Window_02",
  #         "A_Model1_Door_01"
  #       )
  #     ]
  # )
  #
  # DF_U_Elements <-
  #   myDataOut [ ,
  #       c(
  #         "U_Model1_Roof_01",
  #         "U_Model1_Roof_02",
  #         "U_Model1_Wall_01",
  #         "U_Model1_Wall_02",
  #         "U_Model1_Wall_03",
  #         "U_Model1_Floor_01",
  #         "U_Model1_Floor_02",
  #         "U_Model1_Window_01",
  #         "U_Model1_Window_02",
  #         "U_Model1_Door_01"
  #       )
  #     ]
  #
  # H_Transmission_Sum_Elements <-
  #    apply (DF_A_Elements * DF_U_Elements * c(1,1,1,0.5,0.5,0.5,0.5,1,1,1), 1, sum)
  #
  # A_Envelope <-
  #   apply (DF_A_Elements, 1, sum)
  #
  #
  # h_tr <-
  #   (H_Transmission_Sum_Elements +
  #   A_Envelope * myDataOut$delta_U_Model1_ThermalBridging) /
  #   myDataOut$A_Model1_C_Ref
  #
  # H_Transmission_Sum_Elements / myDataOut$A_Model1_C_Ref
  #
  # myDataOut$h_Model1_ht_tr







  ## Multiplier

  f_HeatNeed_Total <- 1.0


  ## Energy balance

  DF_HeatNeed_Data <- data.frame (rownames (myDataOut))
  colnames (DF_HeatNeed_Data) <- "ID_Dataset"
  rownames (DF_HeatNeed_Data) <- DF_HeatNeed_Data$ID_Dataset

  DF_HeatNeed_Data$q_h_nd_net      <- f_HeatNeed_Total * myDataOut$q_Model1_h_nd_net

  DF_HeatNeed_Data$q_ve_recovered  <-
    f_HeatNeed_Total *
    (myDataOut$q_Model1_h_nd - myDataOut$q_Model1_h_nd_net)

  DF_HeatNeed_Data$q_sol           <- f_HeatNeed_Total * myDataOut$q_Model1_sol
  DF_HeatNeed_Data$q_int           <- f_HeatNeed_Total * myDataOut$q_Model1_int

  DF_HeatNeed_Data$q_tr_roof       <-
    f_HeatNeed_Total *
    myDataCalc$H_Transmission_Roof_01 /
    (myDataCalc$h_Transmission * myDataOut$A_Model1_C_Ref) *
    myDataOut$q_Model1_ht_tr

  DF_HeatNeed_Data$q_tr_ceiling    <-
    f_HeatNeed_Total *
    myDataCalc$H_Transmission_Roof_02 /
    (myDataCalc$h_Transmission * myDataOut$A_Model1_C_Ref) *
    myDataOut$q_Model1_ht_tr

  DF_HeatNeed_Data$q_tr_walls       <-
    f_HeatNeed_Total * (
      myDataCalc$H_Transmission_Wall_01 +
      myDataCalc$H_Transmission_Wall_02 +
      myDataCalc$H_Transmission_Wall_03
    ) /
    (myDataCalc$h_Transmission * myDataOut$A_Model1_C_Ref) *
    myDataOut$q_Model1_ht_tr


  DF_HeatNeed_Data$q_tr_windows     <-
    f_HeatNeed_Total * (
      myDataCalc$H_Transmission_Window_01 +
      myDataCalc$H_Transmission_Window_02 +
      myDataCalc$H_Transmission_Door_01
    ) /
    (myDataCalc$h_Transmission * myDataOut$A_Model1_C_Ref) *
    myDataOut$q_Model1_ht_tr

  DF_HeatNeed_Data$q_tr_floor       <-
    f_HeatNeed_Total * (
      myDataCalc$H_Transmission_Floor_01 +
        myDataCalc$H_Transmission_Floor_02
    ) /
    (myDataCalc$h_Transmission * myDataOut$A_Model1_C_Ref) *
    myDataOut$q_Model1_ht_tr


  DF_HeatNeed_Data$q_tr_thermalbridging <-
    f_HeatNeed_Total *
    myDataCalc$H_Transmission_ThermalBridging /
    (myDataCalc$h_Transmission * myDataOut$A_Model1_C_Ref) *
    myDataOut$q_Model1_ht_tr


  DF_HeatNeed_Data$q_ve <-
    f_HeatNeed_Total * myDataOut$q_Model1_ht_ve

  # # Check gains and losses, should be equal
  # apply (DF_HeatNeed_Data [ ,2:5], 1, sum)
  # apply (DF_HeatNeed_Data [ ,6:12], 1, sum)


  DF_HeatNeed_Labels   <- "Test"
  DF_HeatNeed_Settings <- "Test"



  List_Chart_HeatNeed <-
    list (
      DF_HeatNeed_Data     = DF_HeatNeed_Data,
      DF_HeatNeed_Labels   = DF_HeatNeed_Labels,
      DF_HeatNeed_Settings = DF_HeatNeed_Settings
    )


  DF_FinalEnergy_Data  <- "Test"
  DF_HeatNeed_Labels   <- "Test"
  DF_HeatNeed_Settings <- "Test"



  List_Chart_FinalEnergy <-
    list (
      DF_FinalEnergy_Data     = DF_FinalEnergy_Data,
      DF_FinalEnergy_Labels   = DF_FinalEnergy_Labels,
      DF_FinalEnergy_Settings = DF_FinalEnergy_Settings
    )



  ###################################################################################X
  ## 3  Output   -----


  myChartData <-
    list (
      List_Chart_HeatNeed = List_Chart_HeatNeed,
      List_Chart_FinalEnergy = List_Chart_FinalEnergy
    )

  return (myChartData)


} # End of function ProvideChartData ()


## End of the function ProvideChartData () -----
#####################################################################################X


# . ----------------------------------------------------------------------------------












###################################################################################X
## Test of functions  -----
###################################################################################X
## After testing: Comment this section






