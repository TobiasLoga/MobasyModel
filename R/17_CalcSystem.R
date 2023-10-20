###################################################################################X
##
##    File name:        "CalcSystem.R"
##
##    Module of:        "EnergyProfile.R"
##
##    Task:             Energy performance calculation for the heat supply system
##                      (physical model / energy use)
##
##    Method:          TABULA energy performance calculation
##                      https://www.episcope.eu/fileadmin/tabula/public/docs/
##                      report/TABULA_CommonCalculationMethod.pdf
##
##    Projects:         TABULA / EPISCOPE / MOBASY
##
##    Authors:          Tobias Loga (t.loga@iwu.de)
##                      Jens Calisti
##                      IWU - Institut Wohnen und Umwelt, Darmstadt / Germany
##
##    Created:          30-08-2021
##    Last changes:     29-10-2021
##
#####################################################################################X
##
##    Content:          Function CalcSystem ()
##
##    Source:           R-Script derived from Excel workbook / worksheet
##                      "[tabula-calculator.xlsx]Calc.Set.System"
##
#####################################################################################X

  # Temporary change log
  # 2023-03-10 Error corrected: "Data_Calc_Unc" was used in one line instead of "Data_Calc_System"






#####################################################################################X
##  Dependencies / requirements ------
#
#   Script "AuxFunctions.R"
#   Script "AuxConstants.R"



#####################################################################################X
## FUNCTION "CalcSystem ()" -----
#####################################################################################X



CalcSystem <- function (

  myCalcData

) {

  cat ("CalcSystem ()", fill = TRUE)


  ###################################################################################X
  # 1  DESCRIPTION   -----
  ###################################################################################X

  # This function is used to calculate the delivered energy by energy carrier
  # using as input the energy need for heating and the configuration of the supply system.



  ###################################################################################X
  # 2  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X


  ## After debugging: Comment this section
  #
  # myCalcData  <- Data_Calc


  ## Test specific datasets
  # myCalcData     <- Data_Calc  ["DE.MOBASY.NH.0020.05", ]
  # myCalcData     <- Data_Calc  ["DE.MOBASY.WBG.0007.05", ]


  ###################################################################################X
  # 3  FUNCTION SCRIPT   -----
  ###################################################################################X



  #.----------------------------------------------------------------------------------


  ###################################################################################X
  ## Calculation of system performance -----
  ###################################################################################X

  n_Dataset <-
    nrow (myCalcData)

  ###################################################################################X
  ## . DHW System  -----

  myCalcData$q_g_w_out <-
      myCalcData$q_w_nd +
      ifelse (is.na (myCalcData$q_s_w),
              0,
              myCalcData$q_s_w) +
      ifelse (is.na (myCalcData$q_d_w),
              0,
              myCalcData$q_d_w)
  # <AU13> | generated heat dhw (net energy need + storage losses + distribution losses) | annual values in kWh per m? reference area  | kWh/(m?a) | Real

  myCalcData$q_g_out_w_1 <-
      (1 - myCalcData$Fraction_SysW_G_2 - myCalcData$Fraction_SysW_G_3) * myCalcData$q_g_w_out
  myCalcData$q_g_out_w_2 <-
      myCalcData$Fraction_SysW_G_2 * myCalcData$q_g_w_out
  myCalcData$q_g_out_w_3 <-
      myCalcData$Fraction_SysW_G_3 * myCalcData$q_g_w_out
  # These three quantities are not included in "tabula-calculator.xlsx" but needed for the result table

  myCalcData$q_del_w_1 <-
      myCalcData$q_g_out_w_1 * ifelse (is.na (myCalcData$e_g_w_Heat_1),
                                             0,
                                             myCalcData$e_g_w_Heat_1) # <AV13> | delivered energy heat generator 1 | annual values in kWh per m? reference area  | kWh/(m?a) | Real
  myCalcData$q_del_w_2 <-
      myCalcData$q_g_out_w_2 * ifelse (is.na (myCalcData$e_g_w_Heat_2),
                                             0,
                                             myCalcData$e_g_w_Heat_2) # <AW13> | delivered energy heat generator 2 | annual values in kWh per m? reference area  | kWh/(m?a) | Real
  myCalcData$q_del_w_3 <-
      myCalcData$q_g_out_w_3 * ifelse (is.na (myCalcData$e_g_w_Heat_3),
                                             0,
                                             myCalcData$e_g_w_Heat_3) # <AX13> | delivered energy heat generator 3 | annual values in kWh per m? reference area  | kWh/(m?a) | Real

  myCalcData$q_prod_el_w_1 <-
      ifelse (
          is.na (myCalcData$e_g_w_Electricity_1),
          0,
          ifelse (
              myCalcData$e_g_w_Electricity_1 > 0,
              1 / myCalcData$e_g_w_Electricity_1,
              0
          )
      ) * myCalcData$q_del_w_1 # <AY13> | produced electricity heat generator 1 | only in case of chp engines / annual values in kWh per m? reference area | kWh/(m?a) | Real
  myCalcData$q_prod_el_w_2 <-
      ifelse (
          is.na (myCalcData$e_g_w_Electricity_2),
          0,
          ifelse (
              myCalcData$e_g_w_Electricity_2 > 0,
              1 / myCalcData$e_g_w_Electricity_2,
              0
          )
      ) * myCalcData$q_del_w_2 # <AZ13> | produced electricity heat generator 2 | only in case of chp engines / annual values in kWh per m? reference area | kWh/(m?a) | Real
  myCalcData$q_prod_el_w_3 <-
      ifelse (
          is.na (myCalcData$e_g_w_Electricity_3),
          0,
          ifelse (
              myCalcData$e_g_w_Electricity_3 > 0,
              1 / myCalcData$e_g_w_Electricity_3,
              0
          )
      ) * myCalcData$q_del_w_3 # <BA13> | produced electricity heat generator 3 | only in case of chp engines / annual values in kWh per m? reference area | kWh/(m?a) | Real



  ###################################################################################X
  ## . Ventilation system  -----------------

  # myCalcData$n_ <- Data_PreCalc_CalcBuilding$a_Model1_H
  # myCalcData$a_H <- Data_PreCalc_CalcBuilding$a_Model1_H
  #
  # myCalcData$a_H <- Data_PreCalc_CalcBuilding$a_Model1_H
  # myCalcData$eta_Model1_h_gn <- Data_PreCalc_CalcBuilding$eta_Model1_h_gn
  #

  myCalcData$n_air_mech_eff <-
      pmin (myCalcData$n_air_use, myCalcData$n_air_mech)
      # <CD13> | effective air change rate during heating season, effected by the mechanical ventilation system | n_air_mech is restricted by the air change rate defined by the usage n_air_usage: If n_air_n_air_usage  is lower than n_air_mech n_air_usage is determining this quantity. This considers a possible operation with lower air exchange rate by the users. | 1/h | Real

  myCalcData$f_air_mech <-
      AuxFunctions::Replace_NA (myCalcData$n_air_mech_eff / (myCalcData$n_air_infiltration + myCalcData$n_air_use),
                  0)
                  # <CE13> | fraction of total air change rate used in the calculation of the energy need for heating which is ensured by a mechanical ventilation system | Only this part of the annual heat losses by ventilation is recoverable.  | Real

  myCalcData$q_ve_rec_h <-
      ifelse (
          is.na (
              myCalcData$f_air_mech * myCalcData$eta_ve_rec * myCalcData$q_ht_ve
          ),
          0,
          myCalcData$f_air_mech * myCalcData$eta_ve_rec * myCalcData$q_ht_ve
      ) # <CH13> | contribution of ventilation heat recovery | annual values in kWh per m? reference area  | kWh/(m?a) | Real



  ###################################################################################X
  ## . Usability of heat losses for heating   -----------------

  myCalcData$gamma_h_gn_sys <-
      AuxFunctions::Replace_NA ((AuxFunctions::Replace_NA (myCalcData$q_s_w_h, 0) +
              AuxFunctions::Replace_NA (myCalcData$q_d_w_h, 0) +
              myCalcData$q_ve_rec_h) / myCalcData$q_h_nd,
      0) # <CI13> | gain/loss ratio for heating contributions from dhw and ventilation system | Real

  myCalcData$eta_h_gn_sys <-
      AuxFunctions::Replace_NA ((1 - myCalcData$gamma_h_gn_sys ^ myCalcData$a_H) / (1 - myCalcData$gamma_h_gn_sys ^
                                                                        (myCalcData$a_H + 1)),
                  0) # <CJ13> | gain utilisation factor for heating contributions from dhw and ventilation system | Real

  myCalcData$q_s_w_h_usable <-
      ifelse (is.na (myCalcData$q_s_w_h),
              0,
              myCalcData$q_s_w_h * myCalcData$eta_h_gn_sys)
  # <CK13> | usable part of recoverable heat loss dhw storage | annual values in kWh per m? reference area  | kWh/(m?a) | Real

  myCalcData$q_d_w_h_usable <-
      ifelse (is.na (myCalcData$q_d_w_h),
              0,
              myCalcData$q_d_w_h * myCalcData$eta_h_gn_sys)
  # <CL13> | usable part of recoverable heat loss dhw distribution | annual values in kWh per m? reference area  | kWh/(m?a) | Real

  myCalcData$q_ve_rec_h_usable <-
      myCalcData$eta_h_gn_sys * myCalcData$q_ve_rec_h
  # <CM13> | usable contribution of ventilation heat recovery | annual values in kWh per m? reference area  | kWh/(m?a) | Real

  myCalcData$q_h_nd_net <-
      AuxFunctions::Replace_NA (myCalcData$q_h_nd - myCalcData$q_ve_rec_h_usable, 0)
  # <CN13> | net energy need for heating | annual heat demand, to be covered by the space heating system | kWh/(m?a) | Real


  ###################################################################################X
  ## . Determine effective energy need for heating (including effect of ventilation heat recovery)  -----

  # 2022-12-02: Moved here from UncEPCalc.R

  myCalcData$q_h_nd_eff <-
    AuxFunctions::Replace_NA (
      myCalcData$q_h_nd -
        myCalcData$q_ve_rec_h_usable -
        myCalcData$q_s_w_h_usable -
        myCalcData$q_d_w_h_usable,
      0)
  # <CQ13> | effective energy need for heating | to be covered by the space heating system: annual heat demand minus contribution by DHW heat loss and ventilation heat recovery | kWh/(m²a) | Real | q_h_nd_net_eff


  ###################################################################################X
  ## . Heating system  -----

  myCalcData$q_g_h_out <-
      myCalcData$q_h_nd +
      ifelse (is.na (myCalcData$q_s_h),
              0,
              myCalcData$q_s_h) +
      ifelse (is.na (myCalcData$q_d_h),
              0,
              myCalcData$q_d_h) -
      myCalcData$q_s_w_h_usable -
      myCalcData$q_d_w_h_usable -
      myCalcData$q_ve_rec_h_usable # <CO13> | generated heat heating system (net energy need + storage losses + distribution losses) | annual values in kWh per m? reference area  | kWh/(m?a) | Real

  myCalcData$q_g_out_h_1 <- (1 - myCalcData$Fraction_SysH_G_2 - myCalcData$Fraction_SysH_G_3) * myCalcData$q_g_h_out
  myCalcData$q_g_out_h_2 <- myCalcData$Fraction_SysH_G_2 * myCalcData$q_g_h_out
  myCalcData$q_g_out_h_3 <- myCalcData$Fraction_SysH_G_3 * myCalcData$q_g_h_out
  # These three quantities are not included in "tabula-calculator.xlsx" but needed for the result table

  myCalcData$q_del_h_1 <-
      myCalcData$q_g_out_h_1 * ifelse (is.na (myCalcData$e_g_h_Heat_1), 0, myCalcData$e_g_h_Heat_1) # <CP13> | delivered energy heat generator 1 | annual values in kWh per m? reference area  | kWh/(m?a) | Real
  myCalcData$q_del_h_2 <-
      myCalcData$q_g_out_h_2 * ifelse (is.na (myCalcData$e_g_h_Heat_2), 0, myCalcData$e_g_h_Heat_2) # <CQ13> | delivered energy heat generator 2 | annual values in kWh per m? reference area  | kWh/(m?a) | Real
  myCalcData$q_del_h_3 <-
      myCalcData$q_g_out_h_3 * ifelse (is.na (myCalcData$e_g_h_Heat_3), 0, myCalcData$e_g_h_Heat_3) # <CR13> | delivered energy heat generator 3 | annual values in kWh per m? reference area  | kWh/(m?a) | Real

  myCalcData$q_prod_el_h_1 <-
      ifelse (
          is.na (myCalcData$e_g_h_Electricity_1),
          0,
          ifelse (
              myCalcData$e_g_h_Electricity_1 > 0,
              1 / myCalcData$e_g_h_Electricity_1,
              0
          )
      ) * myCalcData$q_del_h_1 # <CS13> | produced electricity heat generator 1 | only in case of chp engines / annual values in kWh per m? reference area | kWh/(m?a) | Real
  myCalcData$q_prod_el_h_2 <-
      ifelse (
          is.na (myCalcData$e_g_h_Electricity_2),
          0,
          ifelse (
              myCalcData$e_g_h_Electricity_2 > 0,
              1 / myCalcData$e_g_h_Electricity_2,
              0
          )
      ) * myCalcData$q_del_h_2 # <CT13> | produced electricity heat generator 2 | only in case of chp engines / annual values in kWh per m? reference area | kWh/(m?a) | Real
  myCalcData$q_prod_el_h_3 <-
      ifelse (
          is.na (myCalcData$e_g_h_Electricity_3),
          0,
          ifelse (
              myCalcData$e_g_h_Electricity_3 > 0,
              1 / myCalcData$e_g_h_Electricity_3,
              0
          )
      ) * myCalcData$q_del_h_3 # <CU13> | produced electricity heat generator 3 | only in case of chp engines / annual values in kWh per m? reference area | kWh/(m?a) | Real




  ###################################################################################X
  ## . PV system  -----

  myCalcData$P_el_pv_peak_1 <-
      myCalcData$A_SolarPotential_1 * myCalcData$f_PV_A_SolarPotential_1 * myCalcData$K_peak_pv * myCalcData$f_PV_frame # <DG13> | rated PV capacity ("peak  power"); electrical power of a photovoltaic system with a given surface and for a solar irradiance of 1 kW/m? on this surface (at 25 ?C) | partial area 1 | kW | Real
  myCalcData$P_el_pv_peak_2 <-
      myCalcData$A_SolarPotential_2 * myCalcData$f_PV_A_SolarPotential_2 * myCalcData$K_peak_pv * myCalcData$f_PV_frame # <DH13> | rated PV capacity ("peak  power"); electrical power of a photovoltaic system with a given surface and for a solar irradiance of 1 kW/m? on this surface (at 25 ?C) | partial area 2 | kW | Real

  myCalcData$Code_SysPV_1 <-
      ifelse (
          AuxFunctions::xl_AND (
              myCalcData$A_SolarPotential_1 > 0,
              myCalcData$Code_SysPVPanel != 0,
              myCalcData$f_PV_A_SolarPotential_1 > 0
          ),
          myCalcData$Code_ClimateRegion %xl_JoinStrings% ".<" %xl_JoinStrings% myCalcData$Code_SysPVPanel %xl_JoinStrings% ">." %xl_JoinStrings% myCalcData$Code_Orientation_SolarPotential_1 %xl_JoinStrings% "." %xl_JoinStrings% AuxFunctions::xl_TEXT (myCalcData$Inclination_SolarPotential_1, "00") %xl_JoinStrings% substr (myCalcData$Code_SysPVPanel, 3, 30),
          0
      ) # <DI13> | code of the pv system type  | partial area 1 | VarChar
  myCalcData$Code_SysPV_2 <-
      ifelse (
          AuxFunctions::xl_AND (
              myCalcData$A_SolarPotential_2 > 0,
              myCalcData$Code_SysPVPanel != 0,
              myCalcData$f_PV_A_SolarPotential_2 > 0
          ),
          myCalcData$Code_ClimateRegion %xl_JoinStrings% ".<" %xl_JoinStrings% myCalcData$Code_SysPVPanel %xl_JoinStrings% ">." %xl_JoinStrings% myCalcData$Code_Orientation_SolarPotential_2 %xl_JoinStrings% "." %xl_JoinStrings% AuxFunctions::xl_TEXT (myCalcData$Inclination_SolarPotential_2, "00") %xl_JoinStrings% substr (myCalcData$Code_SysPVPanel, 3, 30),
          0
      ) # <DJ13> | code of the pv system type  | partial area 2 | VarChar

  myCalcData$Q_el_pv_1 <-
      myCalcData$P_el_pv_peak_1 * myCalcData$q_el_pv_kWpeak_1 # <DM13> | annual electricity produced by PV panels | partial area 1 | Real
  myCalcData$Q_el_pv_2 <-
      myCalcData$P_el_pv_peak_2 * myCalcData$q_el_pv_kWpeak_2 # <DN13> | annual electricity produced by PV panels | partial area 2 | Real
  myCalcData$q_prod_el_pv <-
      AuxFunctions::Replace_NA ((myCalcData$Q_el_pv_1 + myCalcData$Q_el_pv_2) / myCalcData$A_C_Ref,
                  0) # <DO13> | annual electricity produced by the PV system per m? reference area | kWh/(m?a) | Real



  #.----------------------------------------------------------------------------------


  ###################################################################################X
  ## Total energy use by energy carrier  -----------------

  Code_Temp <- "Gas"
  n_Char_Code_Temp <- nchar (Code_Temp)
  myCalcData$q_del_w_sum_gas <-
      ifelse (substr (myCalcData$Code_SysW_EC_1, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_1,
              0) +
      ifelse (substr (myCalcData$Code_SysW_EC_2, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_2,
              0) +
      ifelse (substr (myCalcData$Code_SysW_EC_3, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_3,
              0) +
      (Code_Temp == "El") * myCalcData$q_del_w_aux
  # <DP13> | DHW: delivered energy, energy carrier gas | Gas | kWh/(m?a) | Real
  # Improved version of Excel formula (match only at the beginning of code)

  Code_Temp <- "Oil"
  n_Char_Code_Temp <- nchar (Code_Temp)
  myCalcData$q_del_w_sum_oil <-
      ifelse (substr (myCalcData$Code_SysW_EC_1, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_1,
              0) +
      ifelse (substr (myCalcData$Code_SysW_EC_2, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_2,
              0) +
      ifelse (substr (myCalcData$Code_SysW_EC_3, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_3,
              0) +
      (Code_Temp == "El") * myCalcData$q_del_w_aux
  # <DQ13> | DHW: delivered energy, energy carrier oil | Oil | kWh/(m?a) | Real

  Code_Temp <- "Coal"
  n_Char_Code_Temp <- nchar (Code_Temp)
  myCalcData$q_del_w_sum_coal <-
      ifelse (substr (myCalcData$Code_SysW_EC_1, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_1,
              0) +
      ifelse (substr (myCalcData$Code_SysW_EC_2, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_2,
              0) +
      ifelse (substr (myCalcData$Code_SysW_EC_3, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_3,
              0) +
      (Code_Temp == "El") * myCalcData$q_del_w_aux
  # <DR13> | DHW: delivered energy, energy carrier coal | Coal | kWh/(m?a) | Real

  Code_Temp <- "Bio"
  n_Char_Code_Temp <- nchar (Code_Temp)
  myCalcData$q_del_w_sum_bio <-
      ifelse (substr (myCalcData$Code_SysW_EC_1, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_1,
              0) +
      ifelse (substr (myCalcData$Code_SysW_EC_2, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_2,
              0) +
      ifelse (substr (myCalcData$Code_SysW_EC_3, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_3,
              0) +
      (Code_Temp == "El") * myCalcData$q_del_w_aux
  # <DS13> | DHW: delivered energy, energy carrier bio | Bio | kWh/(m?a) | Real

  Code_Temp <- "El"
  n_Char_Code_Temp <- nchar (Code_Temp)
  myCalcData$q_del_w_sum_el <-
      ifelse (substr (myCalcData$Code_SysW_EC_1, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_1,
              0) +
      ifelse (substr (myCalcData$Code_SysW_EC_2, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_2,
              0) +
      ifelse (substr (myCalcData$Code_SysW_EC_3, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_3,
              0) +
      (Code_Temp == "El") * myCalcData$q_del_w_aux
  # <DT13> | DHW: delivered energy, energy carrier el | El | kWh/(m?a) | Real

  Code_Temp <- "DH"
  n_Char_Code_Temp <- nchar (Code_Temp)
  myCalcData$q_del_w_sum_dh <-
      ifelse (substr (myCalcData$Code_SysW_EC_1, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_1,
              0) +
      ifelse (substr (myCalcData$Code_SysW_EC_2, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_2,
              0) +
      ifelse (substr (myCalcData$Code_SysW_EC_3, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_3,
              0) +
      (Code_Temp == "El") * myCalcData$q_del_w_aux
  # <DU13> | DHW: delivered energy, energy carrier dh | DH | kWh/(m?a) | Real

  Code_Temp <- "Other"
  n_Char_Code_Temp <- nchar (Code_Temp)
  myCalcData$q_del_w_sum_other <-
      ifelse (substr (myCalcData$Code_SysW_EC_1, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_1,
              0) +
      ifelse (substr (myCalcData$Code_SysW_EC_2, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_2,
              0) +
      ifelse (substr (myCalcData$Code_SysW_EC_3, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_w_3,
              0) +
      (Code_Temp == "El") * myCalcData$q_del_w_aux
  # <DV13> | DHW: delivered energy, energy carrier other | Other | kWh/(m?a) | Real

  myCalcData$q_prod_w_sum_el <-
      -(myCalcData$q_prod_el_w_1 + myCalcData$q_prod_el_w_2 + myCalcData$q_prod_el_w_3) # <DW13> | DHW: produced electricity (negative value) | 2020-09-25 / iwu /tl: renamed from q_prod_el_w_sum | kWh/(m?a) | Real


  Code_Temp <- "Gas"
  n_Char_Code_Temp <- nchar (Code_Temp)
  myCalcData$q_del_h_sum_gas <-
      ifelse (substr (myCalcData$Code_SysH_EC_1, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_1,
              0) +
      ifelse (substr (myCalcData$Code_SysH_EC_2, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_2,
              0) +
      ifelse (substr (myCalcData$Code_SysH_EC_3, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_3,
              0) +
      (Code_Temp == "El") * (myCalcData$q_del_h_aux + myCalcData$q_del_ve_aux)
  # <DX13> | heating: delivered energy, energy carrier gas | Gas | kWh/(m?a) | Real | 2016-11-03 / Tobias: formula corrected (accidentally included DHW)
  # Improved version of Excel formula (match only at the beginning of code)

  Code_Temp <- "Oil"
  n_Char_Code_Temp <- nchar (Code_Temp)
  myCalcData$q_del_h_sum_oil <-
      ifelse (substr (myCalcData$Code_SysH_EC_1, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_1,
              0) +
      ifelse (substr (myCalcData$Code_SysH_EC_2, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_2,
              0) +
      ifelse (substr (myCalcData$Code_SysH_EC_3, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_3,
              0) +
      (Code_Temp == "El") * (myCalcData$q_del_h_aux + myCalcData$q_del_ve_aux)
  # <DY13> | heating: delivered energy, energy carrier oil | Oil | kWh/(m?a) | Real | 2016-11-03 / Tobias: formula corrected (accidentally included DHW)

  Code_Temp <- "Coal"
  n_Char_Code_Temp <- nchar (Code_Temp)
  myCalcData$q_del_h_sum_coal <-
      ifelse (substr (myCalcData$Code_SysH_EC_1, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_1,
              0) +
      ifelse (substr (myCalcData$Code_SysH_EC_2, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_2,
              0) +
      ifelse (substr (myCalcData$Code_SysH_EC_3, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_3,
              0) +
      (Code_Temp == "El") * (myCalcData$q_del_h_aux + myCalcData$q_del_ve_aux)
  # <DZ13> | heating: delivered energy, energy carrier coal | Coal | kWh/(m?a) | Real | 2016-11-03 / Tobias: formula corrected (accidentally included DHW)

  Code_Temp <- "Bio"
  n_Char_Code_Temp <- nchar (Code_Temp)
  myCalcData$q_del_h_sum_bio <-
      ifelse (substr (myCalcData$Code_SysH_EC_1, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_1,
              0) +
      ifelse (substr (myCalcData$Code_SysH_EC_2, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_2,
              0) +
      ifelse (substr (myCalcData$Code_SysH_EC_3, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_3,
              0) +
      (Code_Temp == "El") * (myCalcData$q_del_h_aux + myCalcData$q_del_ve_aux)
  # <EA13> | heating: delivered energy, energy carrier bio | Bio | kWh/(m?a) | Real | 2016-11-03 / Tobias: formula corrected (accidentally included DHW)

  Code_Temp <- "El"
  n_Char_Code_Temp <- nchar (Code_Temp)
  myCalcData$q_del_h_sum_el <-
      ifelse (substr (myCalcData$Code_SysH_EC_1, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_1,
              0) +
      ifelse (substr (myCalcData$Code_SysH_EC_2, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_2,
              0) +
      ifelse (substr (myCalcData$Code_SysH_EC_3, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_3,
              0) +
      (Code_Temp == "El") * (myCalcData$q_del_h_aux + myCalcData$q_del_ve_aux)
  # <EB13> | heating: delivered energy, energy carrier el | El | kWh/(m?a) | Real | 2016-11-03 / Tobias: formula corrected (accidentally included DHW)

  Code_Temp <- "El"
  n_Char_Code_Temp <- nchar (Code_Temp)
  myCalcData$q_del_h_sum_el <-
      ifelse (substr (myCalcData$Code_SysH_EC_1, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_1,
              0) +
      ifelse (substr (myCalcData$Code_SysH_EC_2, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_2,
              0) +
      ifelse (substr (myCalcData$Code_SysH_EC_3, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_3,
              0) +
      (Code_Temp == "El") * (myCalcData$q_del_h_aux + myCalcData$q_del_ve_aux)
  # <EB13> | heating: delivered energy, energy carrier el | El | kWh/(m?a) | Real | 2016-11-03 / Tobias: formula corrected (accidentally included DHW)

  Code_Temp <- "DH"
  n_Char_Code_Temp <- nchar (Code_Temp)
  myCalcData$q_del_h_sum_dh <-
      ifelse (substr (myCalcData$Code_SysH_EC_1, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_1,
              0) +
      ifelse (substr (myCalcData$Code_SysH_EC_2, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_2,
              0) +
      ifelse (substr (myCalcData$Code_SysH_EC_3, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_3,
              0) +
      (Code_Temp == "El") * (myCalcData$q_del_h_aux + myCalcData$q_del_ve_aux)
  # <EC13> | heating: delivered energy, energy carrier dh | DH | kWh/(m?a) | Real | 2016-11-03 / Tobias: formula corrected (accidentally included DHW)

  Code_Temp <- "Other"
  n_Char_Code_Temp <- nchar (Code_Temp)
  myCalcData$q_del_h_sum_other <-
      ifelse (substr (myCalcData$Code_SysH_EC_1, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_1,
              0) +
      ifelse (substr (myCalcData$Code_SysH_EC_2, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_2,
              0) +
      ifelse (substr (myCalcData$Code_SysH_EC_3, 1, n_Char_Code_Temp) == Code_Temp,
              myCalcData$q_del_h_3,
              0) +
      (Code_Temp == "El") * (myCalcData$q_del_h_aux + myCalcData$q_del_ve_aux)
  # <ED13> | heating: delivered energy, energy carrier other | Other | kWh/(m?a) | Real


  myCalcData$q_prod_h_sum_el <-
      - (myCalcData$q_prod_el_h_1 + myCalcData$q_prod_el_h_2 + myCalcData$q_prod_el_h_3)
  # <EE13> | heating: produced electricity (negative value) | 2020-09-25 / iwu /tl: renamed from q_prod_el_h_sum | kWh/(m?a) | Real

  myCalcData$q_del_sum_gas <-
      myCalcData$q_del_w_sum_gas + myCalcData$q_del_h_sum_gas
  myCalcData$q_del_sum_oil <-
      myCalcData$q_del_w_sum_oil + myCalcData$q_del_h_sum_oil
  myCalcData$q_del_sum_coal <-
      myCalcData$q_del_w_sum_coal + myCalcData$q_del_h_sum_coal
  myCalcData$q_del_sum_bio <-
      myCalcData$q_del_w_sum_bio + myCalcData$q_del_h_sum_bio
  myCalcData$q_del_sum_el <-
      myCalcData$q_del_w_sum_el + myCalcData$q_del_h_sum_el
  myCalcData$q_del_sum_dh <-
      myCalcData$q_del_w_sum_dh + myCalcData$q_del_h_sum_dh
  myCalcData$q_del_sum_other <-
      myCalcData$q_del_w_sum_other + myCalcData$q_del_h_sum_other

  myCalcData$q_prod_sum_el <-
     myCalcData$q_prod_w_sum_el + myCalcData$q_prod_h_sum_el - myCalcData$q_prod_el_pv
  # <EM13> | sum produced electricity (negative value) | 2020-09-25 / iwu /tl: q_exp_sum_el renamed to q_prod_sum_el  | kWh/(m?a) | Real |



  ###################################################################################X
  ## . Assessment of energy carriers (primary energy, CO2, cost) -----

  myCalcData$q_p_Total_SysW <-
      ifelse (
          is.na (myCalcData$f_p_Total_SysW_EC_1),
          0,
          myCalcData$q_del_w_1 * myCalcData$f_p_Total_SysW_EC_1
      ) + ifelse (
          is.na (myCalcData$f_p_Total_SysW_EC_2),
          0,
          myCalcData$q_del_w_2 * myCalcData$f_p_Total_SysW_EC_2
      ) + ifelse (
          is.na (myCalcData$f_p_Total_SysW_EC_3),
          0,
          myCalcData$q_del_w_3 * myCalcData$f_p_Total_SysW_EC_3
      ) + ifelse (
          is.na (myCalcData$f_p_Total_SysW_ElAux),
          0,
          myCalcData$q_del_w_aux * myCalcData$f_p_Total_SysW_ElAux
      ) # <FH13> | (total) primary energy demand | kWh/(m?a) | Real

  myCalcData$q_p_NonRen_SysW <-
      ifelse (
          is.na (myCalcData$f_p_NonRen_SysW_EC_1),
          0,
          myCalcData$q_del_w_1 * myCalcData$f_p_NonRen_SysW_EC_1
      ) + ifelse (
          is.na (myCalcData$f_p_NonRen_SysW_EC_2),
          0,
          myCalcData$q_del_w_2 * myCalcData$f_p_NonRen_SysW_EC_2
      ) + ifelse (
          is.na (myCalcData$f_p_NonRen_SysW_EC_3),
          0,
          myCalcData$q_del_w_3 * myCalcData$f_p_NonRen_SysW_EC_3
      ) + ifelse (
          is.na (myCalcData$f_p_NonRen_SysW_ElAux),
          0,
          myCalcData$q_del_w_aux * myCalcData$f_p_NonRen_SysW_ElAux
      ) # <FI13> | non-renewable primary energy demand | kWh/(m?a) | Real

  myCalcData$Emission_CO2_SysW <-
      (
          ifelse (
              is.na (myCalcData$f_CO2_SysW_EC_1),
              0,
              myCalcData$q_del_w_1 * myCalcData$f_CO2_SysW_EC_1
          ) + ifelse (
              is.na (myCalcData$f_CO2_SysW_EC_2),
              0,
              myCalcData$q_del_w_2 * myCalcData$f_CO2_SysW_EC_2
          ) + ifelse (
              is.na (myCalcData$f_CO2_SysW_EC_3),
              0,
              myCalcData$q_del_w_3 * myCalcData$f_CO2_SysW_EC_3
          ) + ifelse (
              is.na (myCalcData$f_CO2_SysW_ElAux),
              0,
              myCalcData$q_del_w_aux * myCalcData$f_CO2_SysW_ElAux
          )
      ) / 1000 # <FJ13> | CO2 emissions | kg/(m?a) | Real

  myCalcData$Costs_SysW <-
      ifelse (
          is.na (myCalcData$price_SysW_EC_1),
          0,
          myCalcData$q_del_w_1 * myCalcData$price_SysW_EC_1
      ) + ifelse (
          is.na (myCalcData$price_SysW_EC_2),
          0,
          myCalcData$q_del_w_2 * myCalcData$price_SysW_EC_2
      ) + ifelse (
          is.na (myCalcData$price_SysW_EC_3),
          0,
          myCalcData$q_del_w_3 * myCalcData$price_SysW_EC_3
      ) + ifelse (
          is.na (myCalcData$price_SysW_ElAux),
          0,
          myCalcData$q_del_w_aux * myCalcData$price_SysW_ElAux
      ) # <FK13> | annual costs | Euro/(m?a) | Real


  myCalcData$Code_Specification_SysH_EC_1 <-
      ifelse (
          myCalcData$Code_SysH_EC_1 != "",
          myCalcData$Code_EC_Specification_Version %xl_JoinStrings% "." %xl_JoinStrings% myCalcData$Code_SysH_EC_1,
          ""
      ) # <FL13> | code of specification for energy carrier 1 | heating system / energy carrier 1 | Tab.System.EC | VarChar

  myCalcData$Code_Specification_SysH_EC_2 <-
      ifelse (
          myCalcData$Code_SysH_EC_2 != "",
          myCalcData$Code_EC_Specification_Version %xl_JoinStrings% "." %xl_JoinStrings% myCalcData$Code_SysH_EC_2,
          ""
      ) # <FM13> | code of specification for energy carrier 2 | heating system / energy carrier 2 | Tab.System.EC | VarChar

  myCalcData$Code_Specification_SysH_EC_3 <-
      ifelse (
          myCalcData$Code_SysH_EC_3 != "",
          myCalcData$Code_EC_Specification_Version %xl_JoinStrings% "." %xl_JoinStrings% myCalcData$Code_SysH_EC_3,
          ""
      ) # <FN13> | code of specification for energy carrier 3 | dhe / energy carrier 3 | Tab.System.EC | VarChar

  myCalcData$Code_Specification_SysH_EC_ElAux <-
      myCalcData$Code_EC_Specification_Version %xl_JoinStrings% ".El" # <FO13> | code of specification for auxiliary electricity | heating system / auxiliary electricity | Tab.System.EC | VarChar


  myCalcData$q_p_Total_SysH <-
      ifelse (
          is.na (myCalcData$f_p_Total_SysH_EC_1),
          0,
          myCalcData$q_del_h_1 * myCalcData$f_p_Total_SysH_EC_1
      ) + ifelse (
          is.na (myCalcData$f_p_Total_SysH_EC_2),
          0,
          myCalcData$q_del_h_2 * myCalcData$f_p_Total_SysH_EC_2
      ) + ifelse (
          is.na (myCalcData$f_p_Total_SysH_EC_3),
          0,
          myCalcData$q_del_h_3 * myCalcData$f_p_Total_SysH_EC_3
      ) + ifelse (
          is.na (myCalcData$f_p_Total_SysH_ElAux),
          0,
          (myCalcData$q_del_h_aux + myCalcData$q_del_ve_aux) * myCalcData$f_p_Total_SysH_ElAux
      )
  # <GF13> | (total) primary energy demand | kWh/(m?a) | Real

  myCalcData$q_p_NonRen_SysH <-
      ifelse (
          is.na (myCalcData$f_p_NonRen_SysH_EC_1),
          0,
          myCalcData$q_del_h_1 * myCalcData$f_p_NonRen_SysH_EC_1
      ) + ifelse (
          is.na (myCalcData$f_p_NonRen_SysH_EC_2),
          0,
          myCalcData$q_del_h_2 * myCalcData$f_p_NonRen_SysH_EC_2
      ) + ifelse (
          is.na (myCalcData$f_p_NonRen_SysH_EC_3),
          0,
          myCalcData$q_del_h_3 * myCalcData$f_p_NonRen_SysH_EC_3
      ) + ifelse (
          is.na (myCalcData$f_p_NonRen_SysH_ElAux),
          0,
          (myCalcData$q_del_h_aux + myCalcData$q_del_ve_aux) * myCalcData$f_p_NonRen_SysH_ElAux
      )
  # <GG13> | non-renewable primary energy demand | kWh/(m?a) | Real

  myCalcData$Emission_CO2_SysH <-
      (
          ifelse (
              is.na (myCalcData$f_CO2_SysH_EC_1),
              0,
              myCalcData$q_del_h_1 * myCalcData$f_CO2_SysH_EC_1
          ) + ifelse (
              is.na (myCalcData$f_CO2_SysH_EC_2),
              0,
              myCalcData$q_del_h_2 * myCalcData$f_CO2_SysH_EC_2
          ) + ifelse (
              is.na (myCalcData$f_CO2_SysH_EC_3),
              0,
              myCalcData$q_del_h_3 * myCalcData$f_CO2_SysH_EC_3
          ) + ifelse (
              is.na (myCalcData$f_CO2_SysH_ElAux),
              0,
              (myCalcData$q_del_h_aux + myCalcData$q_del_ve_aux) * myCalcData$f_CO2_SysH_ElAux
          )
      ) / 1000 # <GH13> | CO2 emissions | kg/(m?a) | Real

  myCalcData$Costs_SysH <-
      ifelse (
          is.na (myCalcData$price_SysH_EC_1),
          0,
          myCalcData$q_del_h_1 * myCalcData$price_SysH_EC_1
      ) + ifelse (
          is.na (myCalcData$price_SysH_EC_2),
          0,
          myCalcData$q_del_h_2 * myCalcData$price_SysH_EC_2
      ) + ifelse (
          is.na (myCalcData$price_SysH_EC_3),
          0,
          myCalcData$q_del_h_3 * myCalcData$price_SysH_EC_3
      ) + ifelse (
          is.na (myCalcData$price_SysH_ElAux),
          0,
          (myCalcData$q_del_h_aux + myCalcData$q_del_ve_aux) * myCalcData$price_SysH_ElAux
      )
  # <GI13> | annual costs | Euro/(m?a) | Real


  ###################################################################################X
  ## . Supplemental assessment of electricity produced on-site  -----

  myCalcData$Code_ElProd_Coverage <- ""
      # only used in TABULA.xlsm
      # <GJ13> | code of the PV coverage version | VarChar

  myCalcData$q_del_el_allowable <-
      myCalcData$q_del_sum_el # <GK13> | delivered electricity, allowable for coverage by on-site electricity production | Note: It is intended to later introduce an option for consideration of household appliances, if required | kWh/(m?a) | Real

  myCalcData$Indicator_Sys_ElProd_Coverage_PV <- 1 # Open task / formula needs to be implemented in EnergyProfile.xlsm
  # <GL13> | indicator assigning the coverage factors to electricity production by PV (combination of PV and CHP possible) | 1 = assigned to PV
  # 0 = not assigned to PV | Integer"

  myCalcData$Indicator_Sys_ElProd_Coverage_CHP <- 1 # Open task / formula needs to be implemented in EnergyProfile.xlsm
  # <GM13> | indicator assigning the coverage factors to electricity production by CHP (combination of PV and CHP possible) | 1 = assigned to CHP
  # 0 = not assigned to CHP | Integer"

  myCalcData$q_prod_el <-
      myCalcData$q_prod_el_w_1 + myCalcData$q_prod_el_w_2 + myCalcData$q_prod_el_w_3 +
      myCalcData$q_prod_el_h_1 + myCalcData$q_prod_el_h_2 + myCalcData$q_prod_el_h_3 +
      myCalcData$q_prod_el_pv # <GN13> | annual electricity production by PV and CHP systems  | kWh/(m?a) | Real

  myCalcData$q_prod_el_alowable <-
      myCalcData$Indicator_Sys_ElProd_Coverage_CHP * (
          myCalcData$q_prod_el_w_1 + myCalcData$q_prod_el_w_2 + myCalcData$q_prod_el_w_3 +
      myCalcData$q_prod_el_h_1 + myCalcData$q_prod_el_h_1 + myCalcData$q_prod_el_h_3) +
      myCalcData$Indicator_Sys_ElProd_Coverage_PV * myCalcData$q_prod_el_pv
  # <GO13> | annual electricity on-site electricity production, allowable for coverage of building's electricity demand | kWh/(m?a) | Real

  myCalcData$Ratio_Sys_Supply_Demand <-
      AuxFunctions::Replace_NA (myCalcData$q_prod_el_alowable / myCalcData$q_del_el_allowable,
                  0) # <GP13> | ratio of annual electricity production by PV and CHP systems to annual delivered electricity for heating, DHW and auxiliary energy | Real

  # <OpenTask>
  # The following assigment of fixed values is only a temporary solution (the same in tabula-calculator.xlsx)
  # This needs to be determined in [EnergyProfile.xlsm]Data.Out.TABULA on the basis of [tabula-values.xlsx]Tab.System.Coverage
  myCalcData$Ratio_Supply_Demand_Node_01 <-
      0 # <GQ13> | supply demand ratio | value node 01 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Ratio_Supply_Demand_Node_01 | 12
  myCalcData$Ratio_Supply_Demand_Node_02 <-
      0.25 # <GR13> | supply demand ratio | value node 02 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Ratio_Supply_Demand_Node_02 | 13
  myCalcData$Ratio_Supply_Demand_Node_03 <-
      0.5 # <GS13> | supply demand ratio | value node 03 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Ratio_Supply_Demand_Node_03 | 14
  myCalcData$Ratio_Supply_Demand_Node_04 <-
      0.75 # <GT13> | supply demand ratio | value node 04 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Ratio_Supply_Demand_Node_04 | 15
  myCalcData$Ratio_Supply_Demand_Node_05 <-
      1 # <GU13> | supply demand ratio | value node 05 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Ratio_Supply_Demand_Node_05 | 16
  myCalcData$Ratio_Supply_Demand_Node_06 <-
      1.5 # <GV13> | supply demand ratio | value node 06 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Ratio_Supply_Demand_Node_06 | 17
  myCalcData$Ratio_Supply_Demand_Node_07 <-
      2 # <GW13> | supply demand ratio | value node 07 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Ratio_Supply_Demand_Node_07 | 18
  myCalcData$Ratio_Supply_Demand_Node_08 <-
      3 # <GX13> | supply demand ratio | value node 08 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Ratio_Supply_Demand_Node_08 | 19
  myCalcData$Ratio_Supply_Demand_Node_09 <-
      5 # <GY13> | supply demand ratio | value node 09 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Ratio_Supply_Demand_Node_09 | 20
  myCalcData$Ratio_Supply_Demand_Node_10 <-
      10 # <GZ13> | supply demand ratio | value node 10 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Ratio_Supply_Demand_Node_10 | 21
  myCalcData$Fraction_SysCoverage_Node_01 <-
      0 # <HA13> | fraction of delivered energy covered by respective system; results of more detailed calculation  | value node 01 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Fraction_SysCoverage_Node_01 | 22
  myCalcData$Fraction_SysCoverage_Node_02 <-
      0.04 # <HB13> | fraction of delivered energy covered by respective system; results of more detailed calculation  | value node 02 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Fraction_SysCoverage_Node_02 | 23
  myCalcData$Fraction_SysCoverage_Node_03 <-
      0.08 # <HC13> | fraction of delivered energy covered by respective system; results of more detailed calculation  | value node 03 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Fraction_SysCoverage_Node_03 | 24
  myCalcData$Fraction_SysCoverage_Node_04 <-
      0.12 # <HD13> | fraction of delivered energy covered by respective system; results of more detailed calculation  | value node 04 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Fraction_SysCoverage_Node_04 | 25
  myCalcData$Fraction_SysCoverage_Node_05 <-
      0.2 # <HE13> | fraction of delivered energy covered by respective system; results of more detailed calculation  | value node 05 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Fraction_SysCoverage_Node_05 | 26
  myCalcData$Fraction_SysCoverage_Node_06 <-
      0.26 # <HF13> | fraction of delivered energy covered by respective system; results of more detailed calculation  | value node 06 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Fraction_SysCoverage_Node_06 | 27
  myCalcData$Fraction_SysCoverage_Node_07 <-
      0.32 # <HG13> | fraction of delivered energy covered by respective system; results of more detailed calculation  | value node 07 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Fraction_SysCoverage_Node_07 | 28
  myCalcData$Fraction_SysCoverage_Node_08 <-
      0.4 # <HH13> | fraction of delivered energy covered by respective system; results of more detailed calculation  | value node 08 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Fraction_SysCoverage_Node_08 | 29
  myCalcData$Fraction_SysCoverage_Node_09 <-
      0.5 # <HI13> | fraction of delivered energy covered by respective system; results of more detailed calculation  | value node 09 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Fraction_SysCoverage_Node_09 | 30
  myCalcData$Fraction_SysCoverage_Node_10 <-
      0.6 # <HJ13> | fraction of delivered energy covered by respective system; results of more detailed calculation  | value node 10 | Tab.System.Coverage | Real | Code_ElProd_Coverage | 192 | Fraction_SysCoverage_Node_10 | 31


  Array_Ratio_Supply_Demand <-
      cbind (
          myCalcData$Ratio_Supply_Demand_Node_01,
          myCalcData$Ratio_Supply_Demand_Node_02,
          myCalcData$Ratio_Supply_Demand_Node_03,
          myCalcData$Ratio_Supply_Demand_Node_04,
          myCalcData$Ratio_Supply_Demand_Node_05,
          myCalcData$Ratio_Supply_Demand_Node_06,
          myCalcData$Ratio_Supply_Demand_Node_07,
          myCalcData$Ratio_Supply_Demand_Node_08,
          myCalcData$Ratio_Supply_Demand_Node_09,
          myCalcData$Ratio_Supply_Demand_Node_10)

  Array_Fraction_SysCoverage <-
      cbind (
          myCalcData$Fraction_SysCoverage_Node_01,
          myCalcData$Fraction_SysCoverage_Node_02,
          myCalcData$Fraction_SysCoverage_Node_03,
          myCalcData$Fraction_SysCoverage_Node_04,
          myCalcData$Fraction_SysCoverage_Node_05,
          myCalcData$Fraction_SysCoverage_Node_06,
          myCalcData$Fraction_SysCoverage_Node_07,
          myCalcData$Fraction_SysCoverage_Node_08,
          myCalcData$Fraction_SysCoverage_Node_09,
          myCalcData$Fraction_SysCoverage_Node_10)



  ## Determine the first of the two columns of the array to be applied
  ## = Borders of the value range in which the actual value of "Ratio_Sys_Supply_Demand" can be found
  #i_Row <- 1 #  166 # Used for testing the loop

  n_Col_Array_SysCoverage = 10

  for (i_Row in 1:n_Dataset) {

      Col_Table_SysCoverage <-
          max (c (which (Array_Ratio_Supply_Demand [i_Row,] < myCalcData$Ratio_Sys_Supply_Demand [i_Row]),0))
      if (Col_Table_SysCoverage == n_Col_Array_SysCoverage) {
          myCalcData$Fraction_SysCoverage [i_Row] <-
              Array_Fraction_SysCoverage [i_Row, n_Col_Array_SysCoverage]
      } else {
          if (Col_Table_SysCoverage > 0) {
          myCalcData$Fraction_SysCoverage [i_Row] <-
              Array_Fraction_SysCoverage [i_Row, Col_Table_SysCoverage] +
              ((Array_Fraction_SysCoverage [i_Row, Col_Table_SysCoverage + 1] -
                  Array_Fraction_SysCoverage [i_Row, Col_Table_SysCoverage]) /
              (Array_Ratio_Supply_Demand [i_Row, Col_Table_SysCoverage + 1] -
                 Array_Ratio_Supply_Demand [i_Row, Col_Table_SysCoverage])) *
              (myCalcData$Ratio_Sys_Supply_Demand [i_Row] -
                 Array_Ratio_Supply_Demand [i_Row, Col_Table_SysCoverage])
          } else {
              myCalcData$Fraction_SysCoverage [i_Row] <- NA
          }
      }
  }
  #myCalcData$Fraction_SysCoverage
  # <HL13> | fraction of delivered energy covered by PV system | derived from tabled values on the basis of more detailed calculation  | Real

  myCalcData$q_del_el_prod_used <-
                  -pmin (
                      myCalcData$Fraction_SysCoverage *
                        myCalcData$q_del_el_allowable,
                      myCalcData$q_prod_el_alowable
                  ) # <HM13> | produced electricity directly used in the building | kWh/(m?a) | Real

  myCalcData$q_del_el_prod_exportgrid <-
                  ifelse (
                      (myCalcData$Indicator_Sys_ElProd_Coverage_PV +
                        myCalcData$Indicator_Sys_ElProd_Coverage_CHP) == 0,
                      -myCalcData$q_prod_el_pv,
                      -myCalcData$q_prod_el_alowable -
                        myCalcData$q_del_el_prod_used
                  ) # <HN13> | electricity exported to the grid (not directly used)  | produced by PV only (if a value for q_del_el_prod_exportgrid_CHP is given) or by both CHP + PV  | kWh/(m?a) | Real

  myCalcData$q_del_el_prod_exportgrid_CHP <-
                  ifelse (
                      myCalcData$Indicator_Sys_ElProd_Coverage_CHP == 1,
                      0,
                      -(myCalcData$q_prod_el_w_1 +
                        myCalcData$q_prod_el_w_2 +
                        myCalcData$q_prod_el_w_3) +
                       (myCalcData$q_prod_el_h_1 +
                        myCalcData$q_prod_el_h_2 +
                        myCalcData$q_prod_el_h_3)
                  )
  # <HO13> | electricity exported to the grid (not directly used)  | produced by CHP; value is only given here in case that the concept for self-use of on-site produced electricity is specifying the self-use for ONE of the two generation types: CHP or PV | kWh/(m?a) | Real

  ## 2022-11-30 / This makes no sense after correction of variable names "exp" to "prod"
  # Additional quantities not included in tabula-calculator.xlsx
  # Cannot be included because an assigment of exported electricity to H and W is not included in the systematics
  # Therefore the values are set to NA
  # myCalcData$q_exp_h_sum_el <- NA
  # myCalcData$q_exp_w_sum_el <- NA



  # <OpenTask>
  # Data entry in the following section not yet implemented

  myCalcData$Code_EC_El_Prod_Used <-
                  "-"
  # <HP13> | code of specification for electricity production | directly used in the building | VarChar

  myCalcData$Code_Specification_EC_El_Prod_Used <-
                  "-"
  # <HQ13> | code of specification for electricity production | directly used in the building | VarChar

  myCalcData$f_p_total_el_prod_used <-
                  0
  # <HR13> | total primary energy factor (non-renewable + renewable energy) | produced electricity directly used in the building | kWh / kWh | Tab.System.EC | Real | Code_Specification_EC_El_Prod_Used | 225 | EC_f_p_Total | 16

  myCalcData$f_p_NonRen_el_prod_used <-
                  0
  # <HS13> | primary energy factor, only non-renewable energy | produced electricity directly used in the building | kWh / kWh | Tab.System.EC | Real | Code_Specification_EC_El_Prod_Used | 225 | EC_f_p_NonRen | 17

  myCalcData$f_CO2_el_prod_used <-
                  0
  # <HT13> | CO2 emission factor | produced electricity directly used in the building | g / kWh | Tab.System.EC | Real | Code_Specification_EC_El_Prod_Used | 225 | EC_f_CO2 | 18

  myCalcData$price_el_prod_used <-
                  0 # <HU13> | price of the energy carrier  | produced electricity directly used in the building | Euro / kWh | Tab.System.EC | Real | Code_Specification_EC_El_Prod_Used | 225 | EC_price | 19


  myCalcData$q_p_total_el_prod_used <-
      AuxFunctions::Replace_NA (myCalcData$q_del_el_prod_used * myCalcData$f_p_total_el_prod_used,
                  0) # <HV13> | (total) primary energy demand | negative value = bonus | kWh/(m?a) | Real
  myCalcData$q_p_NonRen_el_prod_used <-
      AuxFunctions::Replace_NA (myCalcData$q_del_el_prod_used * myCalcData$f_p_NonRen_el_prod_used,
                  0) # <HW13> | non-renewable primary energy demand | negative value = bonus | kWh/(m?a) | Real
  myCalcData$Emission_CO2_el_prod_used <-
      AuxFunctions::Replace_NA (myCalcData$q_del_el_prod_used * myCalcData$f_CO2_el_prod_used / 1000,
                  0) # <HX13> | CO2 emissions | negative value = bonus | kg/(m?a) | Real
  myCalcData$Costs_el_prod_used <-
      AuxFunctions::Replace_NA (myCalcData$q_del_el_prod_used * myCalcData$price_el_prod_used,
                  0) # <HY13> | annual costs | negative value = bonus | Euro/(m?a) | Real


  myCalcData$Code_EC_El_Prod_ExportGrid <-
      'El_Prod' # <HZ13> | code of specification for electricity production | export to grid | Tab.Type.System | VarChar

  myCalcData$Code_Specification_EC_El_Prod_ExportGrid <-
      ifelse (
          myCalcData$Code_EC_El_Prod_ExportGrid != 0,
          myCalcData$Code_EC_Specification_Version %xl_JoinStrings% "." %xl_JoinStrings% myCalcData$Code_EC_El_Prod_ExportGrid,
          ""
      ) # <IA13> | code of specification for electricity production | export to grid | Tab.System.EC | VarChar


  # <OpenTask>
  # Data entry in the following section not yet implemented

  myCalcData$f_p_total_el_prod_ExportGrid <-
      0 # <IB13> | total primary energy factor (non-renewable + renewable energy) | export to grid | kWh / kWh | Tab.System.EC | Real | Code_Specification_EC_El_Prod_ExportGrid | 235 | EC_f_p_Total | 16

  myCalcData$f_p_NonRen_el_prod_ExportGrid <-
      0 # <IC13> | primary energy factor, only non-renewable energy | export to grid | kWh / kWh | Tab.System.EC | Real | Code_Specification_EC_El_Prod_ExportGrid | 235 | EC_f_p_NonRen | 17

  myCalcData$f_CO2_el_prod_ExportGrid <-
      0 # <ID13> | CO2 emission factor | export to grid | g / kWh | Tab.System.EC | Real | Code_Specification_EC_El_Prod_ExportGrid | 235 | EC_f_CO2 | 18

  myCalcData$price_el_prod_ExportGrid <-
      0 # <IE13> | price of the energy carrier  | export to grid | Euro / kWh | Tab.System.EC | Real | Code_Specification_EC_El_Prod_ExportGrid | 235 | EC_price | 19


  myCalcData$q_p_total_el_prod_ExportGrid <-
      AuxFunctions::Replace_NA (myCalcData$q_del_el_prod_exportgrid * myCalcData$f_p_total_el_prod_ExportGrid,
                  0) # <IF13> | (total) primary energy demand | negative value = bonus | kWh/(m?a) | Real

  myCalcData$q_p_NonRen_el_prod_ExportGrid <-
      AuxFunctions::Replace_NA (myCalcData$q_del_el_prod_exportgrid * myCalcData$f_p_NonRen_el_prod_ExportGrid,
                  0) # <IG13> | non-renewable primary energy demand | negative value = bonus | kWh/(m?a) | Real

  myCalcData$Emission_CO2_el_prod_ExportGrid <-
      AuxFunctions::Replace_NA (myCalcData$q_del_el_prod_exportgrid * myCalcData$f_CO2_el_prod_ExportGrid / 1000,
                  0) # <IH13> | CO2 emissions | negative value = bonus | kg/(m?a) | Real

  myCalcData$Costs_el_prod_ExportGrid <-
      AuxFunctions::Replace_NA (myCalcData$q_del_el_prod_exportgrid * myCalcData$price_el_prod_ExportGrid,
                  0) # <II13> | annual costs | negative value = bonus | Euro/(m?a) | Real

  myCalcData$Code_EC_El_Prod_ExportGrid_CHP <-
      'El_Prod_CHP' # <IJ13> | code of specification for electricity production | CHP: export to grid | Tab.Type.System | VarChar

  myCalcData$Code_Specification_EC_El_Prod_ExportGrid_CHP <-
      ifelse (
          myCalcData$Code_EC_El_Prod_ExportGrid_CHP != 0,
          myCalcData$Code_EC_Specification_Version %xl_JoinStrings% "." %xl_JoinStrings% myCalcData$Code_EC_El_Prod_ExportGrid_CHP,
          ""
      ) # <IK13> | code of specification for electricity production | CHP: export to grid | Tab.System.EC | VarChar


  # <OpenTask>
  # Data entry in the following section not yet implemented

  myCalcData$f_p_total_el_prod_ExportGrid_CHP <-
      0 # <IL13> | total primary energy factor (non-renewable + renewable energy) | CHP: export to grid | kWh / kWh | Tab.System.EC | Real | Code_Specification_EC_El_Prod_ExportGrid_CHP | 245 | EC_f_p_Total | 16

  myCalcData$f_p_NonRen_el_prod_ExportGrid_CHP <-
      0 # <IM13> | primary energy factor, only non-renewable energy | CHP: export to grid | kWh / kWh | Tab.System.EC | Real | Code_Specification_EC_El_Prod_ExportGrid_CHP | 245 | EC_f_p_NonRen | 17

  myCalcData$f_CO2_el_prod_ExportGrid_CHP <-
      0 # <IN13> | CO2 emission factor | CHP: export to grid | g / kWh | Tab.System.EC | Real | Code_Specification_EC_El_Prod_ExportGrid_CHP | 245 | EC_f_CO2 | 18

  myCalcData$price_el_prod_ExportGrid_CHP <-
      0 # <IO13> | price of the energy carrier  | CHP: export to grid | Euro / kWh | Tab.System.EC | Real | Code_Specification_EC_El_Prod_ExportGrid_CHP | 245 | EC_price | 19


  myCalcData$q_p_total_el_prod_ExportGrid_CHP <-
      AuxFunctions::Replace_NA (
          myCalcData$q_del_el_prod_exportgrid_CHP * myCalcData$f_p_total_el_prod_ExportGrid_CHP,
          0
      ) # <IP13> | (total) primary energy demand | CHP: negative value = bonus | kWh/(m?a) | Real

  myCalcData$q_p_NonRen_el_prod_ExportGrid_CHP <-
      AuxFunctions::Replace_NA (
          myCalcData$q_del_el_prod_exportgrid_CHP * myCalcData$f_p_NonRen_el_prod_ExportGrid_CHP,
          0
      ) # <IQ13> | non-renewable primary energy demand | CHP: negative value = bonus | kWh/(m?a) | Real

  myCalcData$Emission_CO2_el_prod_ExportGrid_CHP <-
      AuxFunctions::Replace_NA (
          myCalcData$q_del_el_prod_exportgrid_CHP * myCalcData$f_CO2_el_prod_ExportGrid_CHP / 1000,
          0
      ) # <IR13> | CO2 emissions | CHP: negative value = bonus | kg/(m?a) | Real

  myCalcData$Costs_el_prod_ExportGrid_CHP <-
      AuxFunctions::Replace_NA (
          myCalcData$q_del_el_prod_exportgrid_CHP * myCalcData$price_el_prod_ExportGrid_CHP,
          0
      ) # <IS13> | annual costs | CHP: negative value = bonus | Euro/(m?a) | Real

  myCalcData$q_p_total_el_prod <-
      myCalcData$q_p_total_el_prod_used + myCalcData$q_p_total_el_prod_ExportGrid + myCalcData$q_p_total_el_prod_ExportGrid_CHP # <IT13> | total primary energy demand | produced electricity | kWh/(m?a) | Real

  myCalcData$q_p_NonRen_el_prod <-
      myCalcData$q_p_NonRen_el_prod_used + myCalcData$q_p_NonRen_el_prod_ExportGrid + myCalcData$q_p_NonRen_el_prod_ExportGrid_CHP # <IU13> | non-renewable primary energy demand | produced electricity | kWh/(m?a) | Real

  myCalcData$Emission_CO2_el_prod <-
      myCalcData$Emission_CO2_el_prod_used + myCalcData$Emission_CO2_el_prod_ExportGrid + myCalcData$Emission_CO2_el_prod_ExportGrid_CHP # <IV13> | CO2 emissions | produced electricity | kg/(m?a) | Real

  myCalcData$Costs_el_prod <-
      myCalcData$Costs_el_prod_used + myCalcData$Costs_el_prod_ExportGrid + myCalcData$Costs_el_prod_ExportGrid_CHP # <IW13> | annual costs | produced electricity | Euro/(m?a) | Real

  myCalcData$f_p_total_el_prod <-
      AuxFunctions::Replace_NA (
          myCalcData$q_p_total_el_prod / (
              myCalcData$q_del_el_prod_used + myCalcData$q_del_el_prod_exportgrid + myCalcData$q_del_el_prod_exportgrid_CHP
          ),
          0
      ) # <IX13> | total primary energy factor (non-renewable + renewable energy) | kWh / kWh | Tab.System.EC | Real

  myCalcData$f_p_NonRen_el_prod <-
      AuxFunctions::Replace_NA (
          myCalcData$q_p_NonRen_el_prod / (
              myCalcData$q_del_el_prod_used + myCalcData$q_del_el_prod_exportgrid + myCalcData$q_del_el_prod_exportgrid_CHP
          ),
          0
      ) # <IY13> | primary energy factor, only non-renewable energy | kWh / kWh | Tab.System.EC | Real

  myCalcData$f_CO2_el_prod <-
      AuxFunctions::Replace_NA (
          myCalcData$Emission_CO2_el_prod / (
              myCalcData$q_del_el_prod_used + myCalcData$q_del_el_prod_exportgrid + myCalcData$q_del_el_prod_exportgrid_CHP
          ) * 1000,
          0
      ) # <IZ13> | CO2 emission factor | g / kWh | Tab.System.EC | Real

  myCalcData$price_el_prod <-
      AuxFunctions::Replace_NA (
          myCalcData$Costs_el_prod / (
              myCalcData$q_del_el_prod_used + myCalcData$q_del_el_prod_exportgrid + myCalcData$q_del_el_prod_exportgrid_CHP
          ),
          0
      ) # <JA13> | price of the energy carrier  | Euro / kWh | Tab.System.EC | Real

  myCalcData$q_p_Total <-
      (myCalcData$q_p_Total_SysH + myCalcData$q_p_Total_SysW + myCalcData$q_p_total_el_prod) # <JB13> | total primary energy demand | kWh/(m?a) | Real

  myCalcData$q_p_NonRen <-
      (
          myCalcData$q_p_NonRen_SysH + myCalcData$q_p_NonRen_SysW + myCalcData$q_p_NonRen_el_prod
      ) # <JC13> | non-renewable primary energy demand | kWh/(m?a) | Real

  myCalcData$Emission_CO2 <-
      (
          myCalcData$Emission_CO2_SysH + myCalcData$Emission_CO2_SysW + myCalcData$Emission_CO2_el_prod
      ) # <JD13> | CO2 emissions | kg/(m?a) | Real

  myCalcData$Costs <-
      (myCalcData$Costs_SysH + myCalcData$Costs_SysW + myCalcData$Costs_el_prod) # <JE13> | annual costs | Euro/(m?a) | Real




  ###################################################################################X
  ## . Adaption of calculation to typical level of measured consumption  -----------------


  myCalcData$q_del_Calc_Reference_CalcAdapt_M_Node_01 <- 0
  myCalcData$q_del_Calc_Reference_CalcAdapt_M_Node_02 <- 100
  myCalcData$q_del_Calc_Reference_CalcAdapt_M_Node_03 <- 200
  myCalcData$q_del_Calc_Reference_CalcAdapt_M_Node_04 <- 300
  myCalcData$q_del_Calc_Reference_CalcAdapt_M_Node_05 <- 400
  myCalcData$q_del_Calc_Reference_CalcAdapt_M_Node_06 <- 500

  myCalcData$F_CalcAdapt_M_Node_01 <- myCalcData$F_CalcAdapt_M_000
  myCalcData$F_CalcAdapt_M_Node_02 <- myCalcData$F_CalcAdapt_M_100
  myCalcData$F_CalcAdapt_M_Node_03 <- myCalcData$F_CalcAdapt_M_200
  myCalcData$F_CalcAdapt_M_Node_04 <- myCalcData$F_CalcAdapt_M_300
  myCalcData$F_CalcAdapt_M_Node_05 <- myCalcData$F_CalcAdapt_M_400
  myCalcData$F_CalcAdapt_M_Node_06 <- myCalcData$F_CalcAdapt_M_500


  Array_q_del_Calc_Reference_CalcAdapt_M <-
      cbind (
          myCalcData$q_del_Calc_Reference_CalcAdapt_M_Node_01,
          myCalcData$q_del_Calc_Reference_CalcAdapt_M_Node_02,
          myCalcData$q_del_Calc_Reference_CalcAdapt_M_Node_03,
          myCalcData$q_del_Calc_Reference_CalcAdapt_M_Node_04,
          myCalcData$q_del_Calc_Reference_CalcAdapt_M_Node_05,
          myCalcData$q_del_Calc_Reference_CalcAdapt_M_Node_06)

  Array_F_CalcAdapt_M <-
      cbind (
          myCalcData$F_CalcAdapt_M_Node_01,
          myCalcData$F_CalcAdapt_M_Node_02,
          myCalcData$F_CalcAdapt_M_Node_03,
          myCalcData$F_CalcAdapt_M_Node_04,
          myCalcData$F_CalcAdapt_M_Node_05,
          myCalcData$F_CalcAdapt_M_Node_06)



  myCalcData$q_del_Calc_Reference_CalcAdapt_M <- myCalcData$q_del_w_1 + myCalcData$q_del_w_2 + myCalcData$q_del_w_3 +
      myCalcData$q_del_h_1 + myCalcData$q_del_h_2 + myCalcData$q_del_h_3

  n_Col_Array_CalcAdapt_M = 6

  ## Determine the first of the two columns of the array to be applied
  ## = Borders of the value range in which the actual value of "q_del_Calc_Reference_CalcAdapt_M" can be found
  #i_Row <- 166 # 1 #  166 # Used for testing the loop

  for (i_Row in 1:n_Dataset) {

      Col_Table_CalcAdapt_M <-
          max (c (which (Array_q_del_Calc_Reference_CalcAdapt_M [i_Row,] < myCalcData$q_del_Calc_Reference_CalcAdapt_M [i_Row]),0))
      if (Col_Table_CalcAdapt_M == n_Col_Array_CalcAdapt_M) {
          myCalcData$F_CalcAdapt_M [i_Row] <-
              Array_F_CalcAdapt_M [i_Row, n_Col_Array_CalcAdapt_M]
      } else {
          if (Col_Table_CalcAdapt_M > 0) {
              myCalcData$F_CalcAdapt_M [i_Row] <-
                  Array_F_CalcAdapt_M [i_Row, Col_Table_CalcAdapt_M] +
                  ((Array_F_CalcAdapt_M [i_Row, Col_Table_CalcAdapt_M + 1] - Array_F_CalcAdapt_M [i_Row, Col_Table_CalcAdapt_M]) /
                       (Array_q_del_Calc_Reference_CalcAdapt_M [i_Row, Col_Table_CalcAdapt_M + 1] -
                            Array_q_del_Calc_Reference_CalcAdapt_M [i_Row, Col_Table_CalcAdapt_M])) *
                  (myCalcData$q_del_Calc_Reference_CalcAdapt_M [i_Row] - Array_q_del_Calc_Reference_CalcAdapt_M [i_Row, Col_Table_CalcAdapt_M])
          } else {
              myCalcData$F_CalcAdapt_M [i_Row] <- NA
          }
      }
  }
  #myCalcData$F_CalcAdapt_M
  # <JT13> | factor for adaptation to the typical level of measured consumption for the current value of delivered energy | describes a typical ratio of the measured energy consumption and the energy uses determined by the TABULA method | Real



  myCalcData$q_del_sum_gas_CalcAdapt_M <-
      myCalcData$q_del_sum_gas * myCalcData$F_CalcAdapt_M # <JU13> | sum delivered energy, adapted to typical level of measured consumption, energy carrier gas | Gas | kWh/(m?a) | Real

  myCalcData$q_del_sum_oil_CalcAdapt_M <-
      myCalcData$q_del_sum_oil * myCalcData$F_CalcAdapt_M # <JV13> | sum delivered energy, adapted to typical level of measured consumption, energy carrier oil | Oil | kWh/(m?a) | Real

  myCalcData$q_del_sum_coal_CalcAdapt_M <-
      myCalcData$q_del_sum_coal * myCalcData$F_CalcAdapt_M # <JW13> | sum delivered energy, adapted to typical level of measured consumption, energy carrier coal | Coal | kWh/(m?a) | Real

  myCalcData$q_del_sum_bio_CalcAdapt_M <-
      myCalcData$q_del_sum_bio * myCalcData$F_CalcAdapt_M # <JX13> | sum delivered energy, adapted to typical level of measured consumption, energy carrier bio | Bio | kWh/(m?a) | Real

  myCalcData$q_del_sum_el_CalcAdapt_M <-
      myCalcData$q_del_sum_el * myCalcData$F_CalcAdapt_M # <JY13> | sum delivered energy, adapted to typical level of measured consumption, energy carrier el | El | kWh/(m?a) | Real

  myCalcData$q_del_sum_dh_CalcAdapt_M <-
      myCalcData$q_del_sum_dh * myCalcData$F_CalcAdapt_M # <JZ13> | sum delivered energy, adapted to typical level of measured consumption, energy carrier dh | DH | kWh/(m?a) | Real

  myCalcData$q_del_sum_other_CalcAdapt_M <-
      myCalcData$q_del_sum_other * myCalcData$F_CalcAdapt_M # <KA13> | sum delivered energy, adapted to typical level of measured consumption, energy carrier other | Other | kWh/(m?a) | Real

  myCalcData$q_prod_sum_el_CalcAdapt_M <-
    myCalcData$q_prod_sum_el * myCalcData$F_CalcAdapt_M # <KB13> | sum produced energy, adapted to typical level of measured consumption, energy carrier electricity | kWh/(m?a) | Real

  ## 2022-11-30 / variable name changed --> improvement of consistency
  # myCalcData$q_exp_sum_el_CalcAdapt_M <-
  #     myCalcData$q_prod_sum_el * myCalcData$F_CalcAdapt_M # <KB13> | sum produced energy, adapted to typical level of measured consumption, energy carrier electricity | remark: q_exp_sum_el_CalcAdapt_M should be renamed to q_prod_sum_el_CalcAdapt_M  | kWh/(m?a) | Real

  myCalcData$q_p_Total_CalcAdapt_M <-
      myCalcData$F_CalcAdapt_M * myCalcData$q_p_Total # <KC13> | (total) primary energy demand, adapted to typical level of measured consumption | kWh/(m?a) | Real

  myCalcData$q_p_NonRen_CalcAdapt_M <-
      myCalcData$F_CalcAdapt_M * myCalcData$q_p_NonRen # <KD13> | non-renewable primary energy demand, adapted to typical level of measured consumption | kWh/(m?a) | Real

  myCalcData$Emission_CO2_CalcAdapt_M <-
      myCalcData$F_CalcAdapt_M * myCalcData$Emission_CO2 # <KE13> | CO2 emissions, adapted to typical level of measured consumption | kg/(m?a) | Real

  myCalcData$Costs_CalcAdapt_M <-
      myCalcData$F_CalcAdapt_M * myCalcData$Costs # <KF13> | annual costs, adapted to typical level of measured consumption | Euro/(m?a) | Real




  #.------------------------------------------------------------------------------------



###################################################################################X
#  4 OUTPUT  -----
###################################################################################X


###################################################################################X
##  . Return dataframe "myCalcData" including new calculation variables   ------

  myCalcData$Date_Change <- TimeStampForDataset ()

  return (myCalcData)



} # End of function


## End of the function CalcSystem () -----
#####################################################################################X


#.------------------------------------------------------------------------------------

