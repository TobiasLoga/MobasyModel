#####################################################################################X
##
##    File name:        "UncEPCalc.R"
##
##    Module of:        "EnergyProfile.R"
##
##    Task:             Energy Profile Procedure / Estimation of calculation uncertainty
##
##    Method:           MOBASY uncertainty assessment
##                      (https://www.iwu.de/forschung/energie/mobasy/)
##                      Overview article in English:
##                      Loga, Tobias; Behem, Guillaume:
##                      Target/actual comparison and benchmarking used
##                      to safeguard low energy consumption in refurbished housing stocks;
##                      Proceedings of the eceee Summer Study Conference;
##                      Digital event 7–11 June 2021
##                      (https://www.researchgate.net/publication
##                      /355124720_Targetactual_comparison_and_benchmarking_
##                      used_to_safeguard_low_energy_consumption_in_
##                      refurbished_housing_stocks)
##
##    Project:          MOBASY
##
##    Author:           Tobias Loga (t.loga@iwu.de)
##                      IWU - Institut Wohnen und Umwelt, Darmstadt / Germany
##
##    Created:          29-10-2021
##    Last changes:     09-06-2023
##
#####################################################################################X
##
##    Content:          Function "UncEPCalc ()"
##
##    Source:           R-Script derived from Excel workbooks / worksheets
##                      "[EnergyProfile.xlsm]Data.out.TABULA"
##                      "[tabula-calculator.xlsx]Calc.Set.Building"
##
#####################################################################################X

## Temporary change log
# 2023-03-10 Variable name changed (to make it consistent): I_Sol_Hor etc. replaced by I_Sol_HD_Hor





#####################################################################################X
##  Dependencies / requirements ------
#
#   Script "AuxFunctions.R"
#   Script "AuxConstants.R"



#####################################################################################X
## FUNCTION "UncEPCalc ()" -----
#####################################################################################X


UncEPCalc <- function (

  myInputData,
  Data_Calc_Unc,

  ParTab_Uncertainty = NA

) {

  cat ("UncEPCalc ()", fill = TRUE)

  ###################################################################################X
  # 1  DESCRIPTION   -----
  ###################################################################################X

  # This function estimates the uncertainty of the calculated energy demand
  # by evaluating information about the data sources and about missing input data.



  ###################################################################################X
  # 2  DEBUGGUNG - Assign input for debugging of function  -----
  ###################################################################################X
  ## After debugging: Comment this section

  # Data_Calc_Unc <- Data_Calc

  # For testing
  # Data_Calc_Unc <- Data_Calc
  # myInputData <- Data_Input

  # Data_Calc_Unc <- Data_Calc ["DE.MOBASY.NH.0020.05", ]
  # myInputData    <- Data_Input ["DE.MOBASY.NH.0020.05", ]

  # Data_Calc_Unc <- Data_Calc  ["DE.MOBASY.WBG.0007.05", ]
  # myInputData   <- Data_Input ["DE.MOBASY.WBG.0007.05", ]


  ###################################################################################X
  # 3  FUNCTION SCRIPT   -----
  ###################################################################################X

  ## Initialisation



  #.---------------------------------------------------------------------------------------------------

  ###################################################################################X
  ## Type of data sources -----
  ###################################################################################X

  ## R-Script derived from "[EnergyProfile.xlsm]Data.Out.TABULA"

  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel <-
      myInputData$Code_TypeDataSources_EnvelopeLevel # <BFO13> | Code_TypeDataSources_EnvelopeLevel | 634
  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal <-
      myInputData$Code_TypeDataSources_EnvelopeGlobal # <BFP13> | Code_TypeDataSources_EnvelopeGlobal | 635
  Data_Calc_Unc$Code_TypeDataSources_SurfaceEnvelope <-
      myInputData$Code_TypeDataSources_SurfaceEnvelope # <BFQ13> | Code_TypeDataSources_SurfaceEnvelope | 636
  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof <-
      myInputData$Code_TypeDataSources_ThermalTransmittance_Roof # <BFR13> | Code_TypeDataSources_ThermalTransmittance_Roof | 637
  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls <-
      myInputData$Code_TypeDataSources_ThermalTransmittance_Walls # <BFS13> | Code_TypeDataSources_ThermalTransmittance_Walls | 638
  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Windows <-
      myInputData$Code_TypeDataSources_ThermalTransmittance_Windows # <BFT13> | Code_TypeDataSources_ThermalTransmittance_Windows | 639
  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Floor <-
      myInputData$Code_TypeDataSources_ThermalTransmittance_Floor # <BFU13> | Code_TypeDataSources_ThermalTransmittance_Floor | 640
  Data_Calc_Unc$Code_TypeDataSources_ThermalBridging <-
      myInputData$Code_TypeDataSources_ThermalBridging # <BFV13> | Code_TypeDataSources_ThermalBridging | 641
  Data_Calc_Unc$Code_TypeDataSources_SysH <-
      myInputData$Code_TypeDataSources_SysH # <BFW13> | Code_TypeDataSources_SysH | 642
  Data_Calc_Unc$Code_TypeDataSources_SysW <-
      myInputData$Code_TypeDataSources_SysW # <BFX13> | Code_TypeDataSources_SysW | 643
  Data_Calc_Unc$Code_TypeDataSources_Utilisation <-
      myInputData$Code_TypeDataSources_Utilisation # <BFY13> | Code_TypeDataSources_Utilisation | 644
  Data_Calc_Unc$Code_TypeDataSources_InternalTemperature <-
      ifelse (
          AuxFunctions::Replace_NA (
              Data_Calc_Unc$Code_TypeDataSources_Utilisation == "_NA_",
              TRUE
          ),
          myInputData$Code_TypeDataSources_InternalTemperature,
          Data_Calc_Unc$Code_TypeDataSources_Utilisation
      ) # <BFZ13> | Code_TypeDataSources_InternalTemperature | 645
  Data_Calc_Unc$Code_TypeDataSources_AirExchange <-
      ifelse (
          AuxFunctions::Replace_NA (
              Data_Calc_Unc$Code_TypeDataSources_Utilisation == "_NA_",
              TRUE
          ),
          myInputData$Code_TypeDataSources_AirExchange,
          Data_Calc_Unc$Code_TypeDataSources_Utilisation
      ) # <BGA13> | Code_TypeDataSources_AirExchange | 646
  Data_Calc_Unc$Code_TypeDataSources_PassiveSolarAperture <-
      ifelse (
          AuxFunctions::Replace_NA (
              Data_Calc_Unc$Code_TypeDataSources_Utilisation == "_NA_",
              TRUE
          ),
          myInputData$Code_TypeDataSources_PassiveSolarAperture,
          Data_Calc_Unc$Code_TypeDataSources_Utilisation
      ) # <BGB13> | Code_TypeDataSources_PassiveSolarAperture | 647
  Data_Calc_Unc$Code_TypeDataSources_InternalHeatSources <-
      ifelse (
          AuxFunctions::Replace_NA (
              Data_Calc_Unc$Code_TypeDataSources_Utilisation == "_NA_",
              TRUE
          ),
          myInputData$Code_TypeDataSources_InternalHeatSources,
          Data_Calc_Unc$Code_TypeDataSources_Utilisation
      ) # <BGC13> | Code_TypeDataSources_InternalHeatSources | 648
  Data_Calc_Unc$Code_TypeDataSources_SysW_HeatNeed <-
      ifelse (
          AuxFunctions::Replace_NA (
              Data_Calc_Unc$Code_TypeDataSources_Utilisation == "_NA_",
              TRUE
          ),
          myInputData$Code_TypeDataSources_SysW_HeatNeed,
          Data_Calc_Unc$Code_TypeDataSources_Utilisation
      ) # <BGD13> | Code_TypeDataSources_SysW_HeatNeed | 649
  Data_Calc_Unc$Code_TypeDataSources_Operation <-
      myInputData$Code_TypeDataSources_Operation # <BGE13> | Code_TypeDataSources_Operation | 650
  Data_Calc_Unc$Code_TypeDataSources_Climate <-
      myInputData$Code_TypeDataSources_Climate # <BGF13> | Code_TypeDataSources_Climate | 651
  Data_Calc_Unc$Code_TypeDataSources_Metering <-
      myInputData$Code_TypeDataSources_Metering # <BGG13> | Code_TypeDataSources_Metering | 652
  Data_Calc_Unc$Code_TypeDataSources_MeterHeating <-
      myInputData$Code_TypeDataSources_MeterHeating # <BGH13> | Code_TypeDataSources_MeterHeating | 653

  #.---------------------------------------------------------------------------------------------------

  ###################################################################################X
  ## Completeness of information -----
  ###################################################################################X

  ## R-Script derived from "[EnergyProfile.xlsm]Data.Out.TABULA"


  # Data_Calc_Unc$Indicator_Completeness_SurfaceEnvelope.1 <-
  #     Data_Calc_Unc$Indicator_Completeness_SurfaceEnvelope # <BGI13>

  Data_Calc_Unc$Indicator_Completeness_DHW_HeatNeed <- 0 # <BGJ13>
  Data_Calc_Unc$Indicator_Completeness_SysH <-
      ifelse (
          Data_Calc_Unc$Fraction_SysH_G_Central > 0.5,
          0.5 * Data_Calc_Unc$Indicator_Completeness_SysHG + 0.5 * Data_Calc_Unc$Indicator_Completeness_SysHD,
          1 * Data_Calc_Unc$Indicator_Completeness_SysHG
      ) # <BGK13>
  Data_Calc_Unc$Indicator_Completeness_SysW <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_Unc$Fraction_SysW_G_Central, 0) > 0.5,
          0.5 * AuxFunctions::Replace_NA (Data_Calc_Unc$Indicator_Completeness_SysWG, 0) + 0.5 * AuxFunctions::Replace_NA (Data_Calc_Unc$Indicator_Completeness_SysWD, 0),
          1 * AuxFunctions::Replace_NA (Data_Calc_Unc$Indicator_Completeness_SysWG, 0)
      ) # <BGL13>
  Data_Calc_Unc$Indicator_Completeness_PassiveSolar_Aperture <-
      0 # <BGM13>
  Data_Calc_Unc$Indicator_Completeness_PassiveSolar_Shading <-
      0 # <BGN13>
  Data_Calc_Unc$Indicator_Completeness_InternalHeat_ElectricalAppliances <-
      0 # <BGO13>
  Data_Calc_Unc$Indicator_Completeness_InternalHeat_DHWSystem <-
      Data_Calc_Unc$Indicator_Completeness_SysW # <BGP13>
  Data_Calc_Unc$Indicator_Completeness_InternalHeat_PersonsOther <-
      0 # <BGQ13>

  #.---------------------------------------------------------------------------------------------------

  ###################################################################################X
  ## Classify uncertainty (categories A, B, C, D, E) and assign values   -----
  ###################################################################################X

  ## R-Script derived from "[EnergyProfile.xlsm]Data.Out.TABULA"


  ###################################################################################X
  ## . Envelope area: classification and quantification of uncertainties  -----

  Data_Calc_Unc$Code_Uncertainty_A_Envelope <-
      ifelse (
          AuxFunctions::xl_OR (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_SurfaceEnvelope
              ) == "InspectionOnSite",
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_SurfaceEnvelope
              ) == "RecordsStatementOwner"
          ),
          ifelse (
              myInputData$Code_AttachedNeighbours == "_NA_",
              ifelse (is.na (Data_Calc_Unc$n_Storey_Input),
                      "E",
                      "D"),
              ifelse (AuxFunctions::Replace_NA (Data_Calc_Unc$n_Storey_Input, 0) >= 3,
                      "C",
                      "D")
          ),
          ifelse (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_SurfaceEnvelope
              ) == "DesignDataPlusQA",
              "A",
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_SurfaceEnvelope
                  ) == "DesignData",
                  "B",
                  "E"
              )
          )
      )



  # 2021-10-29: manually corrected
  #
  # $BFO11 Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel
  # $BFP11 Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal
  # $BFQ11 Data_Calc_Unc$Code_TypeDataSources_SurfaceEnvelope
  # $AP11 Data_Calc_Unc$n_Storey_Input
  # $AX11 Data_Calc_Unc$Code_AttachedNeighbours_Input
  #
  # Old version:
  # Data_Calc_Unc$Code_Uncertainty_A_Envelope <-
  #     ifelse (
  #         AuxFunctions::xl_OR (
  #             Data_Calc_Unc$Indicator_Completeness_SurfaceEnvelope.1 < 0.5,
  #             ifelse (
  #                 Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
  #                 Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
  #                 Data_Calc_Unc$Code_TypeDataSources_SurfaceEnvelope
  #             ) == "NoDataSource"
  #         ),
  #         "E",
  #         ifelse (
  #             Data_Calc_Unc$Indicator_Completeness_SurfaceEnvelope.1 >= 0.9,
  #             ifelse (Data_Calc_Unc$n_Storey <= 2, "C", "B"),
  #             ifelse (Data_Calc_Unc$n_Storey <= 2, "D", "C")
  #         )
  #     ) # <BGS13> | direkte Eingaben noch ber?cksichtigen


  Data_Calc_Unc$RelativeUncertainty_A_Envelope <-
      Value_ParTab_Vector(
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.A_Envelope.01"),
          paste0(
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_A_Envelope
          )
      )


  ###################################################################################X
  ## . Manual input of U-values: classification and quantification of uncertainties -----

  Data_Calc_Unc$Code_Uncertainty_InputManual_U_Top <-
      ifelse (
          Data_Calc_Unc$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          ifelse (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
              ) == "NoDataSource",
              "E",
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
                  ) == "DesignDataPlusQA",
                  "A",
                  ifelse (
                      ifelse (
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                          Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
                      ) == "DesignData",
                      "B",
                      ifelse (
                          ifelse (
                              Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                              Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                              Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
                          ) == "InspectionOnSite",
                          "C",
                          "D"
                      )
                  )
              )
          ),
          "E"
      ) # <BGU13> | "D" (manual input of typology data) is not implemented | -
  Data_Calc_Unc$Code_Uncertainty_InputManual_U_Wall <-
      ifelse (
          Data_Calc_Unc$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          ifelse (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls
              ) == "NoDataSource",
              "E",
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls
                  ) == "DesignDataPlusQA",
                  "A",
                  ifelse (
                      ifelse (
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                          Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls
                      ) == "DesignData",
                      "B",
                      ifelse (
                          ifelse (
                              Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                              Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                              Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls
                          ) == "InspectionOnSite",
                          "C",
                          "D"
                      )
                  )
              )
          ),
          "E"
      ) # <BGV13> | "D" (manual input of typology data) is not implemented | -
  Data_Calc_Unc$Code_Uncertainty_InputManual_U_Window <-
      ifelse (
          Data_Calc_Unc$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          ifelse (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Windows
              ) == "NoDataSource",
              "E",
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Windows
                  ) == "DesignDataPlusQA",
                  "A",
                  ifelse (
                      ifelse (
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                          Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Windows
                      ) == "DesignData",
                      "B",
                      ifelse (
                          ifelse (
                              Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                              Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                              Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Windows
                          ) == "InspectionOnSite",
                          "C",
                          "D"
                      )
                  )
              )
          ),
          "E"
      ) # <BGW13> | "D" (manual input of typology data) is not implemented | -
  Data_Calc_Unc$Code_Uncertainty_InputManual_U_Bottom <-
      ifelse (
          Data_Calc_Unc$Code_TypeInput_Envelope_ThermalTransmittance == "Manual",
          ifelse (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Floor
              ) == "NoDataSource",
              "E",
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Floor
                  ) == "DesignDataPlusQA",
                  "A",
                  ifelse (
                      ifelse (
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                          Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Floor
                      ) == "DesignData",
                      "B",
                      ifelse (
                          ifelse (
                              Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                              Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                              Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Floor
                          ) == "InspectionOnSite",
                          "C",
                          "D"
                      )
                  )
              )
          ),
          "E"
      ) # <BGX13> | "D" (manual input of typology data) is not implemented | -


  Data_Calc_Unc$RelativeUncertainty_U_Input_Top <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.U_PreCalc.01"),
          paste0(
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_InputManual_U_Top
          )
      )
  # <BGY13> | U_Input | Tab.Uncertainty.Levels | RelativeUncertainty | U_Precalc | Gen | 1


  Data_Calc_Unc$RelativeUncertainty_U_Input_Wall <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.U_PreCalc.01"),
          paste0(
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_InputManual_U_Wall
          )
      )
  # <BGZ13> | U_Input | Tab.Uncertainty.Levels | RelativeUncertainty | U_Precalc | Gen | 1

  Data_Calc_Unc$RelativeUncertainty_U_Input_Window <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.U_PreCalc.01"),
          paste0(
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_InputManual_U_Window
          )
      )
  # <BHA13> | U_Input | Tab.Uncertainty.Levels | RelativeUncertainty | U_Precalc | Gen | 1


  Data_Calc_Unc$RelativeUncertainty_U_Input_Bottom <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.U_PreCalc.01"),
          paste0(
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_InputManual_U_Bottom
          )
      )
  # <BHB13> | U_Input | Tab.Uncertainty.Levels | RelativeUncertainty | U_Precalc | Gen | 1


  ###################################################################################X
  ## . Classify uncertainty of original U-values -----

  Data_Calc_Unc$Code_Uncertainty_U_Original <-
      ifelse (
          AuxFunctions::Replace_NA (myInputData$Year_Building, 0) == 0,
          "E",
          ifelse (
              myInputData$Year_Building >= 1995,
              "B",
              ifelse (myInputData$Year_Building >= 1983, "C", "D")
          )
      ) # <BHC13> | Here only one datafield needed for all construction types


  ###################################################################################X
  ## . Classify uncertainties of insulated area fraction, insulation thickness, thermal conductivity  -----

  Data_Calc_Unc$Code_Uncertainty_f_Insulation_Roof <-
      ifelse (
          ifelse (
              Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
              Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
              Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
          ) == "NoDataSource",
          "D",
          ifelse (
              is.na (myInputData$f_Insulation_Roof ),
              ifelse (
                  AuxFunctions::xl_OR (
                      AuxFunctions::Replace_NA (myInputData$d_Insulation_Roof, 0) >
                          0,
                      myInputData$Code_InsulationType_Roof == "Refurbish"
                  ),
                  "D",
                  "E"
              ),
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
                  ) == "DesignDataPlusQA",
                  "A",
                  ifelse (
                      ifelse (
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                          Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
                      ) == "DesignData",
                      "B",
                      "C"
                  )
              )
          )
      ) # <BHD13>

  Data_Calc_Unc$Code_Uncertainty_f_Insulation_Ceiling <-
      ifelse (
          ifelse (
              Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
              Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
              Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
          ) == "NoDataSource",
          "D",
          ifelse (
              is.na (myInputData$f_Insulation_Ceiling),
              ifelse (
                  AuxFunctions::xl_OR (
                      AuxFunctions::Replace_NA (myInputData$d_Insulation_Ceiling, 0) >
                          0,
                      myInputData$Code_InsulationType_Ceiling == "Refurbish"
                  ),
                  "D",
                  "E"
              ),
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
                  ) == "DesignDataPlusQA",
                  "A",
                  ifelse (
                      ifelse (
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                          Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
                      ) == "DesignData",
                      "B",
                      "C"
                  )
              )
          )
      ) # <BHE13>

  Data_Calc_Unc$Code_Uncertainty_f_Insulation_Wall <-
      ifelse (
          ifelse (
              Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
              Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
              Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls
          ) == "NoDataSource",
          "D",
          ifelse (
              is.na (myInputData$f_Insulation_Wall),
              ifelse (
                  AuxFunctions::xl_OR (
                      AuxFunctions::Replace_NA (myInputData$d_Insulation_Wall, 0) >
                          0,
                      myInputData$Code_InsulationType_Wall == "Refurbish"
                  ),
                  "D",
                  "E"
              ),
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls
                  ) == "DesignDataPlusQA",
                  "A",
                  ifelse (
                      ifelse (
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                          Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls
                      ) == "DesignData",
                      "B",
                      "C"
                  )
              )
          )
      ) # <BHF13>

  Data_Calc_Unc$Code_Uncertainty_f_Insulation_Floor <-
      ifelse (
          ifelse (
              Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
              Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
              Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Floor
          ) == "NoDataSource",
          "D",
          ifelse (
              is.na (myInputData$f_Insulation_Floor),
              ifelse (
                  AuxFunctions::xl_OR (
                      AuxFunctions::Replace_NA (myInputData$d_Insulation_Floor, 0) >
                          0,
                      myInputData$Code_InsulationType_Floor == "Refurbish"
                  ),
                  "D",
                  "E"
              ),
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Floor
                  ) == "DesignDataPlusQA",
                  "A",
                  ifelse (
                      ifelse (
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                          Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Floor
                      ) == "DesignData",
                      "B",
                      "C"
                  )
              )
          )
      ) # <BHG13>

  Data_Calc_Unc$Code_Uncertainty_d_Insulation_Roof <-
      ifelse (
          AuxFunctions::xl_OR (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
              ) == "NoDataSource",
              is.na (myInputData$d_Insulation_Roof)
          ),
          ifelse (is.na (
              myInputData$Year_Refurbishment_Roof
          ), "E", "D"),
          ifelse (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
              ) == "DesignDataPlusQA",
              "A",
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
                  ) == "DesignData",
                  "B",
                  "C"
              )
          )
      ) # <BHH13>

  Data_Calc_Unc$Code_Uncertainty_d_Insulation_Ceiling <-
      ifelse (
          AuxFunctions::xl_OR (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
              ) == "NoDataSource",
              is.na (myInputData$d_Insulation_Ceiling)
          ),
          ifelse (
              is.na (myInputData$Year_Refurbishment_Ceiling),
              "E",
              "D"
          ),
          ifelse (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
              ) == "DesignDataPlusQA",
              "A",
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
                  ) == "DesignData",
                  "B",
                  "C"
              )
          )
      ) # <BHI13>

  Data_Calc_Unc$Code_Uncertainty_d_Insulation_Wall <-
      ifelse (
          AuxFunctions::xl_OR (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls
              ) == "NoDataSource",
              is.na (myInputData$d_Insulation_Wall)
          ),
          ifelse (is.na (
              myInputData$Year_Refurbishment_Wall
          ), "E", "D"),
          ifelse (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls
              ) == "DesignDataPlusQA",
              "A",
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls
                  ) == "DesignData",
                  "B",
                  "C"
              )
          )
      ) # <BHJ13>

  Data_Calc_Unc$Code_Uncertainty_d_Insulation_Floor <-
      ifelse (
          AuxFunctions::xl_OR (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Floor
              ) == "NoDataSource",
              is.na (myInputData$d_Insulation_Floor)
          ),
          ifelse (
              is.na (myInputData$Year_Refurbishment_Floor),
              "E",
              "D"
          ),
          ifelse (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Floor
              ) == "DesignDataPlusQA",
              "A",
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Floor
                  ) == "DesignData",
                  "B",
                  "C"
              )
          )
      ) # <BHK13>

  Data_Calc_Unc$Code_Uncertainty_Lambda_Insulation_Roof <-
      ifelse (
          AuxFunctions::xl_OR (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
              ) == "NoDataSource",
              is.na (myInputData$Lambda_Insulation_Roof)
          ),
          ifelse (is.na (
              myInputData$Year_Refurbishment_Roof
          ), "E", "D"),
          ifelse (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
              ) == "DesignDataPlusQA",
              "A",
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
                  ) == "DesignData",
                  "B",
                  "C"
              )
          )
      ) # <BHL13>

  Data_Calc_Unc$Code_Uncertainty_Lambda_Insulation_Ceiling <-
      ifelse (
          AuxFunctions::xl_OR (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
              ) == "NoDataSource",
              is.na (myInputData$Lambda_Insulation_Ceiling)
          ),
          ifelse (
              is.na (myInputData$Year_Refurbishment_Ceiling),
              "E",
              "D"
          ),
          ifelse (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
              ) == "DesignDataPlusQA",
              "A",
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Roof
                  ) == "DesignData",
                  "B",
                  "C"
              )
          )
      ) # <BHM13>

  Data_Calc_Unc$Code_Uncertainty_Lambda_Insulation_Wall <-
      ifelse (
          AuxFunctions::xl_OR (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls
              ) == "NoDataSource",
              is.na (myInputData$Lambda_Insulation_Wall)
          ),
          ifelse (is.na (
              myInputData$Year_Refurbishment_Wall
          ), "E", "D"),
          ifelse (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls
              ) == "DesignDataPlusQA",
              "A",
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls
                  ) == "DesignData",
                  "B",
                  "C"
              )
          )
      ) # <BHN13>

  Data_Calc_Unc$Code_Uncertainty_Lambda_Insulation_Floor <-
      ifelse (
          AuxFunctions::xl_OR (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls
              ) == "NoDataSource",
              is.na (myInputData$Lambda_Insulation_Floor)
          ),
          ifelse (
              is.na (myInputData$Year_Refurbishment_Floor),
              "E",
              "D"
          ),
          ifelse (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls
              ) == "DesignDataPlusQA",
              "A",
              ifelse (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Walls
                  ) == "DesignData",
                  "B",
                  "C"
              )
          )
      ) # <BHO13>


  ###################################################################################X
  ## . Classify uncertainties of U-values of windows  -----

  Data_Calc_Unc$Code_Uncertainty_U_WindowType1 <-
      ifelse (
          ifelse (
              Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
              Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
              Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Windows
          ) == "DesignDataPlusQA",
          "A",
          ifelse (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Windows
              ) == "DesignData",
              "B",
              ifelse (
                  AuxFunctions::xl_OR (
                      ifelse (
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                          Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Windows
                      ) == "NoDataSource",
                      AuxFunctions::xl_AND (
                          is.na (myInputData$Year_Installation_WindowType1),
                          Data_Calc_Unc$Code_U_Class_WindowType1_nPane == "-"
                      )
                  ),
                  "E",
                  ifelse (AuxFunctions::xl_OR (
                      AuxFunctions::xl_OR (
                          is.na (myInputData$Year_Installation_WindowType1),
                          Data_Calc_Unc$Code_U_Class_WindowType1_nPane == "-"
                      ),
                      AuxFunctions::xl_AND (
                          Data_Calc_Unc$Year_Installation_WindowType1_Calc >= 1969,
                          Data_Calc_Unc$Year_Installation_WindowType1_Calc <= 1978,
                          Data_Calc_Unc$Code_U_Class_WindowType1_nPane == 2,
                          Data_Calc_Unc$Code_U_Class_WindowType1_FrameMaterial == "-"
                      ),
                      AuxFunctions::xl_AND (
                          Data_Calc_Unc$Year_Installation_WindowType1_Calc >= 1995,
                          Data_Calc_Unc$Year_Installation_WindowType1_Calc <= 2001,
                          Data_Calc_Unc$Code_U_Class_WindowType1_LowE == "-"
                      )
                  ), "D", "C")
              )
          )
      ) # <BHP13>

  Data_Calc_Unc$Code_Uncertainty_U_WindowType2 <-
      ifelse (
          ifelse (
              Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
              Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
              Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Windows
          ) == "DesignDataPlusQA",
          "A",
          ifelse (
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                  Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                  Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Windows
              ) == "DesignData",
              "B",
              ifelse (
                  AuxFunctions::xl_OR (
                      ifelse (
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                          Data_Calc_Unc$Code_TypeDataSources_ThermalTransmittance_Windows
                      ) == "NoDataSource",
                      AuxFunctions::xl_AND (
                          is.na (myInputData$Year_Installation_WindowType2),
                          Data_Calc_Unc$Code_U_Class_WindowType2_nPane == "-"
                      )
                  ),
                  "E",
                  ifelse (AuxFunctions::xl_OR (
                      AuxFunctions::xl_OR (
                          is.na (myInputData$Year_Installation_WindowType2),
                          Data_Calc_Unc$Code_U_Class_WindowType2_nPane == "-"
                      ),
                      AuxFunctions::xl_AND (
                          Data_Calc_Unc$Year_Installation_WindowType2_Calc >= 1969,
                          Data_Calc_Unc$Year_Installation_WindowType2_Calc <= 1978,
                          Data_Calc_Unc$Code_U_Class_WindowType2_nPane == 2,
                          Data_Calc_Unc$Code_U_Class_WindowType2_FrameMaterial == "-"
                      ),
                      AuxFunctions::xl_AND (
                          Data_Calc_Unc$Year_Installation_WindowType2_Calc >= 1995,
                          Data_Calc_Unc$Year_Installation_WindowType2_Calc <= 2001,
                          Data_Calc_Unc$Code_U_Class_WindowType2_LowE == "-"
                      )
                  ), "D", "C")
              )
          )
      ) # <BHQ13>


  ###################################################################################X
  ## . Quantify uncertainty of original U-values  -----

  Data_Calc_Unc$RelativeUncertainty_U_Original <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.U_Original.01"),
          paste0(
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_U_Original
          )
      ) # <BHR13> | U_Original | Tab.Uncertainty.Levels | RelativeUncertainty | U_Original | Gen | 1


  ###################################################################################X
  ## . Quantify uncertainties of insulated area fraction, insulation thickness, thermal conductivity  -----

  Data_Calc_Unc$AbsoluteUncertainty_f_Insulation_Roof <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.f_Insulation.01"),
          paste0(
              "AbsoluteUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_f_Insulation_Roof
          )
      )
  # <BHS13> | f_Insulation_Roof | Tab.Uncertainty.Levels | AbsoluteUncertainty | f_Insulation | Gen | 1

  Data_Calc_Unc$AbsoluteUncertainty_f_Insulation_Ceiling <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.f_Insulation.01"),
          paste0(
              "AbsoluteUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_f_Insulation_Ceiling
          )
      )
  # <BHT13> | f_Insulation_Ceiling | Tab.Uncertainty.Levels | AbsoluteUncertainty | f_Insulation | Gen | 1

  Data_Calc_Unc$AbsoluteUncertainty_f_Insulation_Wall <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.f_Insulation.01"),
          paste0(
              "AbsoluteUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_f_Insulation_Wall
          )
      )
  # <BHU13> | f_Insulation_Wall | Tab.Uncertainty.Levels | AbsoluteUncertainty | f_Insulation | Gen | 1


  Data_Calc_Unc$AbsoluteUncertainty_f_Insulation_Floor <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.f_Insulation.01"),
          paste0(
              "AbsoluteUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_f_Insulation_Floor
          )
      )
  # <BHV13> | f_Insulation_Floor | Tab.Uncertainty.Levels | AbsoluteUncertainty | f_Insulation | Gen | 1

  Data_Calc_Unc$RelativeUncertainty_d_Insulation_Roof <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.d_Insulation.01"),
          paste0(
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_d_Insulation_Roof
          )
      )
  # <BHW13> | d_Insulation_Roof | Tab.Uncertainty.Levels | RelativeUncertainty | d_Insulation | Gen | 1

  Data_Calc_Unc$RelativeUncertainty_d_Insulation_Ceiling <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.d_Insulation.01"),
          paste0(
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_d_Insulation_Ceiling
          )
      )
  # <BHX13> | d_Insulation_Ceiling | Tab.Uncertainty.Levels | RelativeUncertainty | d_Insulation | Gen | 1

  Data_Calc_Unc$RelativeUncertainty_d_Insulation_Wall <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.d_Insulation.01"),
          paste0(
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_d_Insulation_Wall
          )
      )
  # <BHY13> | d_Insulation_Wall | Tab.Uncertainty.Levels | RelativeUncertainty | d_Insulation | Gen | 1

  Data_Calc_Unc$RelativeUncertainty_d_Insulation_Floor <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.d_Insulation.01"),
          paste0(
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_d_Insulation_Floor
          )
      )
  # <BHZ13> | d_Insulation_Floor | Tab.Uncertainty.Levels | RelativeUncertainty | d_Insulation | Gen | 1

  Data_Calc_Unc$AbsoluteUncertainty_d_Insulation_Roof <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.d_Insulation.01"),
          paste0(
              "AbsoluteUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_d_Insulation_Roof
          )
      )
  # <BIA13> | d_Insulation_Roof | Tab.Uncertainty.Levels | AbsoluteUncertainty | d_Insulation | Gen | 1

  Data_Calc_Unc$AbsoluteUncertainty_d_Insulation_Ceiling <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.d_Insulation.01"),
          paste0(
              "AbsoluteUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_d_Insulation_Ceiling
          )
      )
  # <BIB13> | d_Insulation_Ceiling | Tab.Uncertainty.Levels | AbsoluteUncertainty | d_Insulation | Gen | 1

  Data_Calc_Unc$AbsoluteUncertainty_d_Insulation_Wall <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.d_Insulation.01"),
          paste0(
              "AbsoluteUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_d_Insulation_Wall
          )
      )
  # <BIC13> | d_Insulation_Wall | Tab.Uncertainty.Levels | AbsoluteUncertainty | d_Insulation | Gen | 1

  Data_Calc_Unc$AbsoluteUncertainty_d_Insulation_Floor <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.d_Insulation.01"),
          paste0(
              "AbsoluteUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_d_Insulation_Floor
          )
      )
  # <BID13> | d_Insulation_Floor | Tab.Uncertainty.Levels | AbsoluteUncertainty | d_Insulation | Gen | 1

  Data_Calc_Unc$RelativeUncertainty_Lambda_Insulation_Roof <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.Lambda_Insulation.01"),
          paste0(
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_Lambda_Insulation_Roof
          )
      )
  # <BIE13> | Lambda_Insulation_Roof | Tab.Uncertainty.Levels | RelativeUncertainty | Lambda_Insulation | Gen | 1

  Data_Calc_Unc$RelativeUncertainty_Lambda_Insulation_Ceiling <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.Lambda_Insulation.01"),
          paste0(
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_Lambda_Insulation_Ceiling
          )
      )
  # <BIF13> | Lambda_Insulation_Ceiling | Tab.Uncertainty.Levels | RelativeUncertainty | Lambda_Insulation | Gen | 1

  Data_Calc_Unc$RelativeUncertainty_Lambda_Insulation_Wall <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.Lambda_Insulation.01"),
          paste0(
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_Lambda_Insulation_Wall
          )
      )
  # <BIG13> | Lambda_Insulation_Wall | Tab.Uncertainty.Levels | RelativeUncertainty | Lambda_Insulation | Gen | 1

  Data_Calc_Unc$RelativeUncertainty_Lambda_Insulation_Floor <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.Lambda_Insulation.01"),
          paste0(
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_Lambda_Insulation_Floor
          )
      )
  # <BIH13> | Lambda_Insulation_Floor | Tab.Uncertainty.Levels | RelativeUncertainty | Lambda_Insulation | Gen | 1


  ###################################################################################X
  ## . Quantify uncertainties of U-values of windows  -----

  Data_Calc_Unc$RelativeUncertainty_U_WindowType1 <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.U_Window.01"),
          paste0 (
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_U_WindowType1
          )
      )
  # <BII13> | U_WindowType1 | Tab.Uncertainty.Levels | RelativeUncertainty | U_Window | Gen | 1

  Data_Calc_Unc$RelativeUncertainty_U_WindowType2 <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.U_Window.01"),
          paste0 (
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_U_WindowType2
          )
      )
  # <BIJ13> | U_WindowType2 | Tab.Uncertainty.Levels | RelativeUncertainty | U_Window | Gen | 1


  ###################################################################################X
  ## . Classify and quantify uncertainties of thermal bridging  -----

  Data_Calc_Unc$Code_Uncertainty_ThermalBridging <-
      ifelse (
          ifelse (
              Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
              Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
              Data_Calc_Unc$Code_TypeDataSources_ThermalBridging
          ) == "DesignDataPlusQA",
          "A",
          ifelse (
              AuxFunctions::xl_OR (
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                      Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                      Data_Calc_Unc$Code_TypeDataSources_ThermalBridging
                  ) == "DesignData",
                  AuxFunctions::xl_AND (
                      myInputData$Code_ThermalBridging != "_NA_",
                      Data_Calc_Unc$Year1_Building >= 2002
                  )
              ),
              "B",
              ifelse (
                  AuxFunctions::Replace_NA (
                      myInputData$Code_ThermalBridging,
                      "_NA_"
                  ) == "_NA_",
                  ifelse (Data_Calc_Unc$Year1_Building >= 2002, "C", "E"),
                  ifelse (
                      ifelse (
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeLevel == "Global",
                          Data_Calc_Unc$Code_TypeDataSources_EnvelopeGlobal,
                          Data_Calc_Unc$Code_TypeDataSources_ThermalBridging
                      ) == "InspectionOnSite",
                      "C",
                      "D"
                  )
              )
          )
      ) # <BIK13>

  Data_Calc_Unc$AbsoluteUncertainty_DeltaU_ThermalBridging <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.DeltaU_ThermalBridging.01"),
          paste0 (
              "AbsoluteUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_ThermalBridging
          )
      )
  # <BIL13> | DeltaU_ThermalBridging | Tab.Uncertainty.Levels | AbsoluteUncertainty | DeltaU_ThermalBridging | Gen | 1


  ###################################################################################X
  ## . Classify and quantify uncertainties of heat losses by air exchange  -----

  Data_Calc_Unc$Code_Uncertainty_n_Air_HeatLosses <-
      ifelse (
          Data_Calc_Unc$Code_TypeDataSources_AirExchange == "MeasurementOnSiteQA",
          "A",
          ifelse (
              Data_Calc_Unc$Code_TypeDataSources_AirExchange == "MeasurementOnSite",
              "B",
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_AirExchange == "ElevationClassification",
                  "C",
                  ifelse (
                      AuxFunctions::Replace_NA (Data_Calc_Unc$Indicator_SysVent_Mechanical, "_NA_") != "_NA_",
                      ifelse (Data_Calc_Unc$Code_BuildingSize =="MUH", # 2023-01-26: new
                              "C",
                              "D"),
                      "E"
                  )
              )
          )
      ) # <BIM13>

  Data_Calc_Unc$AbsoluteUncertainty_n_Air_HeatLosses <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.n_Air_HeatLosses.01"),
          paste0 (
              "AbsoluteUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_n_Air_HeatLosses
          )
      )
  # <BIN13> | n_Air_HeatLosses | Tab.Uncertainty.Levels | AbsoluteUncertainty | n_Air_HeatLosses | Gen | 1


  ###################################################################################X
  ## . Classify and quantify uncertainties of the internal temperature  -----

  Data_Calc_Unc$Code_Uncertainty_theta_i <-
      ifelse (
          Data_Calc_Unc$Code_TypeDataSources_InternalTemperature == "MeasurementOnSiteQA",
          "A",
          ifelse (
              Data_Calc_Unc$Code_TypeDataSources_InternalTemperature == "MeasurementOnSite",
              "B",
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_InternalTemperature == "ElevationClassification",
                  "C",
                  ifelse (Data_Calc_Unc$Code_BuildingSize =="MUH", # 2023-01-26: new
                          "C",
                          "D")
              )
          )
      ) # <BIO13> | Note: A Precondition for uncertainty class "E" is that the energy quality of the envelope is unclear. However, this cannot bei determined in this workbook but only in tabula-calculator.xlsx. Therefore "E" is not used here (can only be used in manual assessments). | Case "E" to be implemented (defined by energy quality of envelope, calculated later in tabula-calculator.xlsx)

  Data_Calc_Unc$AbsoluteUncertainty_theta_i <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.theta_i.01"),
          paste0 (
              "AbsoluteUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_theta_i
          )
      )
  # <BIP13> | theta_i | Tab.Uncertainty.Levels | AbsoluteUncertainty | theta_i | Gen | 1


  ###################################################################################X
  ## . Classify uncertainties of climate data and passive solar aperture  -----

  Data_Calc_Unc$Code_Uncertainty_HDD_Climate <-
      ifelse (
          Data_Calc_Unc$Code_TypeDataSources_Climate == "MeasurementOnSiteQA",
          "A",
          ifelse (
              Data_Calc_Unc$Code_TypeDataSources_Climate == "MeasurementOnSite",
              "B",
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_Climate == "ElevationClassification",
                  "C",
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_Climate == "NoDataSource",
                      "D",
                      ifelse (
                          AuxFunctions::xl_OR (
                              Data_Calc_Unc$Code_Type_ConsiderActualClimate == "LocalPeriod",
                              Data_Calc_Unc$Code_Type_ConsiderActualClimate == "LocalLTA_LocalPeriod",
                              Data_Calc_Unc$Code_Type_ConsiderActualClimate == "Standard_LocalPeriod"
                          ),
                          "B",
                          ifelse (
                              AuxFunctions::xl_OR (
                                  Data_Calc_Unc$Code_Type_ConsiderActualClimate == "LocalLTA",
                                  Data_Calc_Unc$Code_Type_ConsiderActualClimate == "Standard_LocalLTA"
                              ),
                              "C",
                              "D"
                          )
                      )
                  )
              )
          )
      ) # <BIS13>

  Data_Calc_Unc$Code_Uncertainty_I_Sol <-
      ifelse (
          Data_Calc_Unc$Code_TypeDataSources_Climate == "MeasurementOnSiteQA",
          "A",
          ifelse (
              Data_Calc_Unc$Code_TypeDataSources_Climate == "MeasurementOnSite",
              "B",
              ifelse (
                  Data_Calc_Unc$Code_TypeDataSources_Climate == "ElevationClassification",
                  "C",
                  ifelse (
                      Data_Calc_Unc$Code_TypeDataSources_Climate == "NoDataSource",
                      "D",
                      ifelse (
                          Data_Calc_Unc$Code_Type_ConsiderActualClimate == "LocalPeriod",
                          "B",
                          ifelse (
                              AuxFunctions::xl_OR (
                                  Data_Calc_Unc$Code_Type_ConsiderActualClimate == "LocalLTA_LocalPeriod",
                                  Data_Calc_Unc$Code_Type_ConsiderActualClimate == "Standard_LocalPeriod"
                              ),
                              ifelse (
                                  Data_Calc_Unc$Code_Type_ClimateCorrection == "Correction_Temperature_Solar",
                                  "B",
                                  "C"
                              ),
                              ifelse (
                                  AuxFunctions::xl_OR (
                                      Data_Calc_Unc$Code_Type_ConsiderActualClimate == "LocalLTA",
                                      Data_Calc_Unc$Code_Type_ConsiderActualClimate == "Standard_LocalLTA"
                                  ),
                                  "C",
                                  "D"
                              )
                          )
                      )
                  )
              )
          )
      ) # <BIT13> | I_Sol

  Data_Calc_Unc$Code_Uncertainty_A_Aperture_PassiveSolar_EquivalentSouth <-
    ifelse (
      AuxFunctions::xl_AND (
        AuxFunctions::xl_OR (
          Data_Calc_Unc$Code_TypeInput_Envelope_SurfaceArea == "Manual",
          # in this case also the windows area by orientation must be entered manually.
          Data_Calc_Unc$Code_TypeInput_WindowAreaPassiveSolar == "Manual"
        ) ,
        AuxFunctions::xl_OR (
          Data_Calc_Unc$Code_TypeDataSources_SurfaceEnvelope == "DesignDataPlusQA",
          Data_Calc_Unc$Code_TypeDataSources_SurfaceEnvelope == "DesignData"
        )
      ),
      ifelse (
        AuxFunctions::xl_OR (
          Data_Calc_Unc$Code_TypeDataSources_PassiveSolarAperture == "MeasurementOnSiteQA",
          Data_Calc_Unc$Code_TypeDataSources_PassiveSolarAperture == "MeasurementOnSite"
        ),
        "A",
        ifelse (Data_Calc_Unc$Code_TypeDataSources_PassiveSolarAperture == "ElevationClassification",
                "B",
                "C")
      ),
      ifelse (
        AuxFunctions::xl_OR (
          Data_Calc_Unc$Code_TypeDataSources_PassiveSolarAperture == "NoDataSource",
          Data_Calc_Unc$Code_TypeDataSources_PassiveSolarAperture == "_NA_"
        ),
        "E",
        "D"
      )
    )

  #Data_Calc_Unc$Code_Uncertainty_A_Aperture_PassiveSolar_EquivalentSouth <- "D"
  # <BIU13> | A_Aperture_PassiveSolar_EquivalentSouth | h?ngt ab von dem Vorhandensein Fensterdaten nach Orientierung


  ## corrected 2022-10-10
  #
  # Data_Calc_Unc$Code_Uncertainty_A_Aperture_PassiveSolar_EquivalentSouth <-
  #   ifelse (
  #     AuxFunctions::xl_AND (
  #       Data_Calc_Unc$Code_TypeInput_WindowAreaPassiveSolar == "Functional",
  #       Data_Calc_Unc$Code_TypeInput_Envelope_SurfaceArea == "Manual",
  #       AuxFunctions::xl_OR (
  #         Data_Calc_Unc$Code_TypeDataSources_SurfaceEnvelope == "DesignDataPlusQA",
  #         Data_Calc_Unc$Code_TypeDataSources_SurfaceEnvelope == "DesignData"
  #       )
  #     ),
  #     ifelse (
  #       AuxFunctions::xl_OR (
  #         Data_Calc_Unc$Code_TypeDataSources_PassiveSolarAperture == "MeasurementOnSiteQA",
  #         Data_Calc_Unc$Code_TypeDataSources_PassiveSolarAperture == "MeasurementOnSite"
  #       ),
  #       "A",
  #       ifelse (Data_Calc_Unc$Code_TypeDataSources_PassiveSolarAperture == "ElevationClassification",
  #              "B",
  #              "C")
  #     ),
  #     ifelse (
  #       AuxFunctions::xl_OR (
  #         Data_Calc_Unc$Code_TypeDataSources_PassiveSolarAperture == "NoDataSource",
  #         Data_Calc_Unc$Code_TypeDataSources_PassiveSolarAperture == "_NA_"
  #       ),
  #       "E",
  #       "D"
  #     )
  #   )
  #
  # #Data_Calc_Unc$Code_Uncertainty_A_Aperture_PassiveSolar_EquivalentSouth <- "D"
  # # <BIU13> | A_Aperture_PassiveSolar_EquivalentSouth | h?ngt ab von dem Vorhandensein Fensterdaten nach Orientierung


  ###################################################################################X
  ## . Classify uncertainties of internal heat sources  -----

  Data_Calc_Unc$Code_Uncertainty_phi_int <-
    ifelse (Data_Calc_Unc$Code_TypeDataSources_InternalHeatSources == "MeasurementOnSiteQA",
            "A",
            ifelse (Data_Calc_Unc$Code_TypeDataSources_InternalHeatSources == "MeasurementOnSite",
                         "B",
                    ifelse (Data_Calc_Unc$Code_TypeDataSources_InternalHeatSources == "ElevationClassification",
                            "C",
                            ifelse (Data_Calc_Unc$Code_BuildingSize == "MUH",
                            "D",
                            "E")
                    )
            )
    )


  Data_Calc_Unc$Code_Uncertainty_phi_int <- "D" # <BIV13> | phi_int



  ###################################################################################X
  ## . Classify uncertainties of system efficiencies and DHW heat need   -----


  Data_Calc_Unc$Code_Uncertainty_q_w_nd <-
    ifelse (Data_Calc_Unc$Code_TypeDataSources_Utilisation == "MeasurementOnSiteQA",
            "A",
            ifelse (Data_Calc_Unc$Code_TypeDataSources_Utilisation == "MeasurementOnSite",
                    "B",
                    ifelse (Data_Calc_Unc$Code_TypeDataSources_Utilisation == "ElevationClassification",
                           "C",
                           ifelse (Data_Calc_Unc$Code_TypeDataSources_Utilisation == "NoDataSource",
                                        ifelse (Data_Calc_Unc$Code_BuildingSize == "MUH",
                                                "C",
                                                "D"),
                                   "E"
                                   )
                           )
                    )
            )

  # 2022-04-22: Changed
  # Data_Calc_Unc$Code_Uncertainty_q_w_nd <-
  #     ifelse (
  #         Data_Calc_Unc$Code_TypeDataSources_Utilisation == "MeasurementOnSite",
  #         "A",
  #         ifelse (
  #             Data_Calc_Unc$Code_TypeDataSources_Utilisation == "ElevationClassification",
  #             "C",
  #             "D"
  #         )
  #    )

  # <BIX13> | q_w_nd


  Data_Calc_Unc$Code_Uncertainty_e_SysH <-
    ifelse (
      Data_Calc_Unc$Code_TypeDataSources_SysH == "NoDataSource",
      "E",
      ifelse (
        Data_Calc_Unc$Indicator_Completeness_SysH < 0.5,
        "D",
        ifelse (
          Data_Calc_Unc$Code_TypeDataSources_SysH == "DesignDataPlusQA",
          "A",
          ifelse (
            Data_Calc_Unc$Code_TypeDataSources_SysH == "DesignData",
            "B",
            ifelse (
              Data_Calc_Unc$Code_TypeDataSources_SysH == "InspectionOnSite",
              "C",
              "D"
            )
          )
        )
      )
    )

  Data_Calc_Unc$Code_Uncertainty_e_SysW <-
    ifelse (
      Data_Calc_Unc$Code_TypeDataSources_SysW == "NoDataSource",
      "E",
      ifelse (
        Data_Calc_Unc$Indicator_Completeness_SysW < 0.5,
        "D",
        ifelse (
          Data_Calc_Unc$Code_TypeDataSources_SysW == "DesignDataPlusQA",
          "A",
          ifelse (
            Data_Calc_Unc$Code_TypeDataSources_SysW == "DesignData",
            "B",
            ifelse (
              Data_Calc_Unc$Code_TypeDataSources_SysW == "InspectionOnSite",
              "C",
              "D"
            )
          )
        )
      )
    )



  ## 2023-03-17 Old versions
  #
  # Data_Calc_Unc$Code_Uncertainty_e_SysH <-
  #     ifelse (
  #         AuxFunctions::xl_OR (
  #             Data_Calc_Unc$Indicator_Completeness_SysH < 0.5,
  #             Data_Calc_Unc$Code_TypeDataSources_SysH == "NoDataSource"
  #         ),
  #         "D",
  #         ifelse (
  #             AuxFunctions::xl_AND (
  #                 Data_Calc_Unc$Indicator_Completeness_SysH == 1,
  #                 Data_Calc_Unc$Code_TypeDataSources_SysH == "DesignDataPlusQA"
  #             ),
  #             "A",
  #             ifelse (
  #                 AuxFunctions::xl_AND (
  #                     Data_Calc_Unc$Indicator_Completeness_SysH == 1,
  #                     AuxFunctions::xl_OR (
  #                         Data_Calc_Unc$Code_TypeDataSources_SysH == "DesignData",
  #                         Data_Calc_Unc$Code_TypeDataSources_SysH == "InspectionOnSite"
  #                     )
  #                 ),
  #                 "B",
  #                 "C"
  #             )
  #         )
  #     ) # <BIY13> | e_SysH
  #
  # Data_Calc_Unc$Code_Uncertainty_e_SysW <-
  #     ifelse (
  #         AuxFunctions::xl_OR (
  #             Data_Calc_Unc$Indicator_Completeness_SysW < 0.5,
  #             Data_Calc_Unc$Code_TypeDataSources_SysW == "NoDataSource"
  #         ),
  #         "D",
  #         ifelse (
  #             AuxFunctions::xl_AND (
  #                 Data_Calc_Unc$Indicator_Completeness_SysW == 1,
  #                 Data_Calc_Unc$Code_TypeDataSources_SysW == "DesignDataPlusQA"
  #             ),
  #             "A",
  #             ifelse (
  #                 AuxFunctions::xl_AND (
  #                     Data_Calc_Unc$Indicator_Completeness_SysW == 1,
  #                     AuxFunctions::xl_OR (
  #                         Data_Calc_Unc$Code_TypeDataSources_SysW == "DesignData",
  #                         Data_Calc_Unc$Code_TypeDataSources_SysW == "InspectionOnSite"
  #                     )
  #                 ),
  #                 "B",
  #                 "C"
  #             )
  #         )
  #     ) # <BIZ13> | e_SysW

  ## Simplified approach:
  Data_Calc_Unc$Code_Uncertainty_eta_ve_rec <- Data_Calc_Unc$Code_Uncertainty_e_SysH
  # <BIW13> | eta_ve_rec

  ###################################################################################X
  ## . Quantify uncertainties of climate data and passive solar aperture  -----

  Data_Calc_Unc$RelativeUncertainty_HDD_Climate <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.HDD_Climate.01"),
          paste0 (
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_HDD_Climate
          )
      )
  # <BJA13> | HDD_Climate | Tab.Uncertainty.Levels | RelativeUncertainty | HDD_Climate | Gen | 1

  Data_Calc_Unc$RelativeUncertainty_Aperture_PassiveSolar <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.A_Aperture_PassiveSolar_EquivalentSouth.01"),
          paste0 (
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_A_Aperture_PassiveSolar_EquivalentSouth
          )
      )
  # <BJB13> | A_Aperture_PassiveSolar_EquivalentSouth | Tab.Uncertainty.Levels | RelativeUncertainty | A_Aperture_PassiveSolar_EquivalentSouth | Gen | 1

  Data_Calc_Unc$RelativeUncertainty_SolarRadiation <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.I_Sol.01"),
          paste0 (
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_I_Sol
          )
      )
  # <BJC13> | I_Sol | Tab.Uncertainty.Levels | RelativeUncertainty | I_Sol | Gen | 1


  ###################################################################################X
  ## . Quantify uncertainties of internal heat sources  -----

  Data_Calc_Unc$RelativeUncertainty_phi_int <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.phi_int.01"),
          paste0 (
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_phi_int
          )
      )
  # <BJD13> | phi_int | Tab.Uncertainty.Levels | RelativeUncertainty | phi_int | Gen | 1


  ###################################################################################X
  ## . Quantify uncertainties of system efficiencies and DHW heat need  -----

  Data_Calc_Unc$RelativeUncertainty_eta_ve_rec <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.eta_ve_rec.01"),
          paste0 (
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_eta_ve_rec
          )
      )
  # <BJE13> | eta_ve_rec | Tab.Uncertainty.Levels | RelativeUncertainty | eta_ve_rec | Gen | 1

  Data_Calc_Unc$RelativeUncertainty_q_w_nd <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.q_w_nd.01"),
          paste0 (
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_q_w_nd
          )
      )
  # <BJF13> | q_w_nd | Tab.Uncertainty.Levels | RelativeUncertainty | q_w_nd | Gen | 1

  Data_Calc_Unc$RelativeUncertainty_e_SysH <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.e_SysH.01"),
          paste0 (
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_e_SysH
          )
      )
  # <BJG13> | e_SysH | Tab.Uncertainty.Levels | RelativeUncertainty | e_SysH | Gen | 1

  Data_Calc_Unc$RelativeUncertainty_e_SysW <-
      Value_ParTab_Vector (
          ParTab_Uncertainty,
          paste0 (Data_Calc_Unc$Code_Country, ".Gen.e_SysW.01"),
          paste0 (
              "RelativeUncertainty",
              "_Level_",
              Data_Calc_Unc$Code_Uncertainty_e_SysW
          )
      )
  # <BJH13> | e_SysW | Tab.Uncertainty.Levels | RelativeUncertainty | e_SysW | Gen | 1


  #.---------------------------------------------------------------------------------------------------


  ###################################################################################X
  ##   Determine effective quantities as reference for uncertainties  -----
  ###################################################################################X

  ##    R-Script derived from "[tabula-calculator.xlsx]Calc.Set.Uncertainty"



  # Data_Calc_Unc$Code_UncertaintyAssessment <-
  #     Data_Calc_Unc$Code_BuiSysCombi # <A13> | Identification of the metering dataset | VarChar | reference: | quantity:
  # Data_Calc_Unc$Code_BuiSysCombi <-
  #     EnergyProfile.Query.Current # <B13> | identification of the dataset representing a building-system combination  | > | > | Calc.Set.System | VarChar | > | > | > | >
  # Data_Calc_Unc$Index_Row_SheetCalcSystem <-
  #     AuxFunctions::Replace_NA (MATCH(Data_Calc_Unc$Code_BuiSysCombi, 'Calc.Set.System'!A:A, 0),
  #                 0) # <C13> | Integer
  # Data_Calc_Unc$Code_BuildingVariant <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'Code_BuildingVariant') # <D13> | identification of the building variant dataset | Calc.Set.System | VarChar | Code_BuildingVariant | 2
  # Data_Calc_Unc$Index_Row_SheetCalcBuilding <-
  #     AuxFunctions::Replace_NA (MATCH(Data_Calc_Unc$Code_BuildingVariant, 'Calc.Set.Building'!A:A, 0),
  #                 0) # <E13> | Integer
  # Data_Calc_Unc$Code_Building <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'Code_Building') # <F13> | code of the building dataset | Calc.Set.Building | VarChar | Code_Building | 10
  # Data_Calc_Unc$A_C_Ref <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'A_C_Ref') # <G13> | reference floor area (conditioned floor area, internal dimensions) | actually measured by applying the TABULA definiton, if available; otherwise estimated by applying standard conversion factors | m² | Calc.Set.Building | Real | A_C_Ref | 28
  # Data_Calc_Unc$n_Dwelling <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'n_Dwelling') # <H13> | Calc.Set.Building | Real | n_Dwelling | 30
  # Data_Calc_Unc$U_Original_Roof_1 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'U_Original_Roof_1') # <I13> | W/(m²K) | Calc.Set.Building | Real | U_Original_Roof_1 | 138
  # Data_Calc_Unc$U_Original_Roof_2 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'U_Original_Roof_2') # <J13> | W/(m²K) | Calc.Set.Building | Real | U_Original_Roof_2 | 139
  # Data_Calc_Unc$U_Original_Wall_1 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'U_Original_Wall_1') # <K13> | W/(m²K) | Calc.Set.Building | Real | U_Original_Wall_1 | 140
  # Data_Calc_Unc$U_Original_Wall_2 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'U_Original_Wall_2') # <L13> | W/(m²K) | Calc.Set.Building | Real | U_Original_Wall_2 | 141
  # Data_Calc_Unc$U_Original_Wall_3 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'U_Original_Wall_3') # <M13> | W/(m²K) | Calc.Set.Building | Real | U_Original_Wall_3 | 142
  # Data_Calc_Unc$U_Original_Floor_1 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'U_Original_Floor_1') # <N13> | W/(m²K) | Calc.Set.Building | Real | U_Original_Floor_1 | 143
  # Data_Calc_Unc$U_Original_Floor_2 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'U_Original_Floor_2') # <O13> | W/(m²K) | Calc.Set.Building | Real | U_Original_Floor_2 | 144
  # Data_Calc_Unc$U_Original_Window_1 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'U_Original_Window_1'
  #     ) # <P13> | W/(m²K) | Calc.Set.Building | Real | U_Original_Window_1 | 145
  # Data_Calc_Unc$U_Original_Window_2 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'U_Original_Window_2'
  #     ) # <Q13> | W/(m²K) | Calc.Set.Building | Real | U_Original_Window_2 | 146
  # Data_Calc_Unc$U_Original_Door_1 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'U_Original_Door_1') # <R13> | W/(m²K) | Calc.Set.Building | Real | U_Original_Door_1 | 147
  # Data_Calc_Unc$R_Add_UnheatedSpace_Roof_1 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'R_Add_UnheatedSpace_Roof_1'
  #     ) # <S13> | m²K/W | Calc.Set.Building | Real | R_Add_UnheatedSpace_Roof_1 | 157
  # Data_Calc_Unc$R_Add_UnheatedSpace_Roof_2 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'R_Add_UnheatedSpace_Roof_2'
  #     ) # <T13> | m²K/W | Calc.Set.Building | Real | R_Add_UnheatedSpace_Roof_2 | 158
  # Data_Calc_Unc$R_Add_UnheatedSpace_Wall_1 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'R_Add_UnheatedSpace_Wall_1'
  #     ) # <U13> | m²K/W | Calc.Set.Building | Real | R_Add_UnheatedSpace_Wall_1 | 159
  # Data_Calc_Unc$R_Add_UnheatedSpace_Wall_2 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'R_Add_UnheatedSpace_Wall_2'
  #     ) # <V13> | m²K/W | Calc.Set.Building | Real | R_Add_UnheatedSpace_Wall_2 | 160
  # Data_Calc_Unc$R_Add_UnheatedSpace_Wall_3 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'R_Add_UnheatedSpace_Wall_3'
  #     ) # <W13> | m²K/W | Calc.Set.Building | Real | R_Add_UnheatedSpace_Wall_3 | 161
  # Data_Calc_Unc$R_Add_UnheatedSpace_Floor_1 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'R_Add_UnheatedSpace_Floor_1'
  #     ) # <X13> | m²K/W | Calc.Set.Building | Real | R_Add_UnheatedSpace_Floor_1 | 162
  # Data_Calc_Unc$R_Add_UnheatedSpace_Floor_2 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'R_Add_UnheatedSpace_Floor_2'
  #     ) # <Y13> | m²K/W | Calc.Set.Building | Real | R_Add_UnheatedSpace_Floor_2 | 163


  ###################################################################################X
  ## . Determine effective original U-values (including effect of adjacent unheated spaces)  -----

  # used as reference for respective uncertainty

  Data_Calc_Unc$U_Roof_Original_effective_1 <-
      ifelse (
          AuxFunctions::xl_AND (
              Data_Calc_Unc$U_Original_Roof_01 > 0,
              Data_Calc_Unc$U_Original_Roof_01 < 10
          ),
          1 / (
              1 / Data_Calc_Unc$U_Original_Roof_01 + Data_Calc_Unc$R_Add_UnheatedSpace_Roof_01
          ),

      ) # <Z13> | W/(m²K) | Real
  Data_Calc_Unc$U_Roof_Original_effective_2 <-
      ifelse (
          AuxFunctions::xl_AND (
              Data_Calc_Unc$U_Original_Roof_02 > 0,
              Data_Calc_Unc$U_Original_Roof_02 < 10
          ),
          1 / (
              1 / Data_Calc_Unc$U_Original_Roof_02 + Data_Calc_Unc$R_Add_UnheatedSpace_Roof_02
          ),

      ) # <AA13> | W/(m²K) | Real
  Data_Calc_Unc$U_Wall_Original_effective_1 <-
      ifelse (
          AuxFunctions::xl_AND (
              Data_Calc_Unc$U_Original_Wall_01 > 0,
              Data_Calc_Unc$U_Original_Wall_01 < 10
          ),
          1 / (
              1 / Data_Calc_Unc$U_Original_Wall_01 + Data_Calc_Unc$R_Add_UnheatedSpace_Wall_01
          ),

      ) # <AB13> | W/(m²K) | Real
  Data_Calc_Unc$U_Wall_Original_effective_2 <-
      ifelse (
          AuxFunctions::xl_AND (
              Data_Calc_Unc$U_Original_Wall_02 > 0,
              Data_Calc_Unc$U_Original_Wall_02 < 10
          ),
          1 / (
              1 / Data_Calc_Unc$U_Original_Wall_02 + Data_Calc_Unc$R_Add_UnheatedSpace_Wall_02
          ),

      ) # <AC13> | W/(m²K) | Real
  Data_Calc_Unc$U_Wall_Original_effective_3 <-
      ifelse (
          AuxFunctions::xl_AND (
              Data_Calc_Unc$U_Original_Wall_03 > 0,
              Data_Calc_Unc$U_Original_Wall_03 < 10
          ),
          1 / (
              1 / Data_Calc_Unc$U_Original_Wall_03 + Data_Calc_Unc$R_Add_UnheatedSpace_Wall_03
          ),

      ) # <AD13> | W/(m²K) | Real
  Data_Calc_Unc$U_Floor_Original_effective_1 <-
      ifelse (
          AuxFunctions::xl_AND (
              Data_Calc_Unc$U_Original_Floor_01 > 0,
              Data_Calc_Unc$U_Original_Floor_01 < 10
          ),
          1 / (
              1 / Data_Calc_Unc$U_Original_Floor_01 + Data_Calc_Unc$R_Add_UnheatedSpace_Floor_01
          ),

      ) # <AE13> | W/(m²K) | Real
  Data_Calc_Unc$U_Floor_Original_effective_2 <-
      ifelse (
          AuxFunctions::xl_AND (
              Data_Calc_Unc$U_Original_Floor_02 > 0,
              Data_Calc_Unc$U_Original_Floor_02 < 10
          ),
          1 / (
              1 / Data_Calc_Unc$U_Original_Floor_02 + Data_Calc_Unc$R_Add_UnheatedSpace_Floor_02
          ),

      ) # <AF13> | W/(m²K) | Real
  # Data_Calc_Unc$f_Measure_Roof_01 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'f_Measure_Roof_01') # <AG13> | Roof_01 | Calc.Set.Building | Real | f_Measure_Roof_01 | 236
  # Data_Calc_Unc$f_Measure_Roof_02 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'f_Measure_Roof_02') # <AH13> | Roof_02 | Calc.Set.Building | Real | f_Measure_Roof_02 | 237
  # Data_Calc_Unc$f_Measure_Wall_01 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'f_Measure_Wall_01') # <AI13> | Wall_01 | Calc.Set.Building | Real | f_Measure_Wall_01 | 238
  # Data_Calc_Unc$f_Measure_Wall_02 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'f_Measure_Wall_02') # <AJ13> | Wall_02 | Calc.Set.Building | Real | f_Measure_Wall_02 | 239
  # Data_Calc_Unc$f_Measure_Wall_03 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'f_Measure_Wall_03') # <AK13> | Wall_03 | Calc.Set.Building | Real | f_Measure_Wall_03 | 240
  # Data_Calc_Unc$f_Measure_Floor_01 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'f_Measure_Floor_01') # <AL13> | Floor_01 | Calc.Set.Building | Real | f_Measure_Floor_01 | 241
  # Data_Calc_Unc$f_Measure_Floor_02 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'f_Measure_Floor_02') # <AM13> | Floor_02 | Calc.Set.Building | Real | f_Measure_Floor_02 | 242
  # Data_Calc_Unc$f_Measure_Window_01 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'f_Measure_Window_01') # <AN13> | Window_01 | Calc.Set.Building | Real | f_Measure_Window_01 | 243
  # Data_Calc_Unc$f_Measure_Window_02 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'f_Measure_Window_02') # <AO13> | Window_02 | Calc.Set.Building | Real | f_Measure_Window_02 | 244
  # Data_Calc_Unc$f_Measure_Door_01 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'f_Measure_Door_01') # <AP13> | Door_01 | Calc.Set.Building | Real | f_Measure_Door_01 | 245
  # Data_Calc_Unc$d_Insulation_Measure_Roof_01 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'd_Insulation_Measure_Roof_01'
  #     ) # <AQ13> | m | Calc.Set.Building | Real | d_Insulation_Measure_Roof_01 | 207
  # Data_Calc_Unc$d_Insulation_Measure_Roof_02 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'd_Insulation_Measure_Roof_02'
  #     ) # <AR13> | m | Calc.Set.Building | Real | d_Insulation_Measure_Roof_02 | 208
  # Data_Calc_Unc$d_Insulation_Measure_Wall_01 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'd_Insulation_Measure_Wall_01'
  #     ) # <AS13> | m | Calc.Set.Building | Real | d_Insulation_Measure_Wall_01 | 209
  # Data_Calc_Unc$d_Insulation_Measure_Wall_02 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'd_Insulation_Measure_Wall_02'
  #     ) # <AT13> | m | Calc.Set.Building | Real | d_Insulation_Measure_Wall_02 | 210
  # Data_Calc_Unc$d_Insulation_Measure_Wall_03 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'd_Insulation_Measure_Wall_03'
  #     ) # <AU13> | m | Calc.Set.Building | Real | d_Insulation_Measure_Wall_03 | 211
  # Data_Calc_Unc$d_Insulation_Measure_Floor_01 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'd_Insulation_Measure_Floor_01'
  #     ) # <AV13> | m | Calc.Set.Building | Real | d_Insulation_Measure_Floor_01 | 212
  # Data_Calc_Unc$d_Insulation_Measure_Floor_02 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'd_Insulation_Measure_Floor_02'
  #     ) # <AW13> | m | Calc.Set.Building | Real | d_Insulation_Measure_Floor_02 | 213


  ###################################################################################X
  ## . Determine effective thermal conductivities of measures  -----

  # used as reference for respective uncertainty

  Data_Calc_Unc$Lambda_Measure_Roof_01 <-
      AuxFunctions::Replace_NA (
          Data_Calc_Unc$d_Insulation_Measure_Roof_01 / Data_Calc_Unc$R_Measure_Roof_01,
          0.04
      ) # <AX13> | W/(m·K) | Calc.Set.Building | Real | R_Measure_Roof_01 | 214
  Data_Calc_Unc$Lambda_Measure_Roof_02 <-
      AuxFunctions::Replace_NA (
          Data_Calc_Unc$d_Insulation_Measure_Roof_02 / Data_Calc_Unc$R_Measure_Roof_02,
          0.04
      ) # <AY13> | W/(m·K) | Calc.Set.Building | Real | R_Measure_Roof_02 | 215
  Data_Calc_Unc$Lambda_Measure_Wall_01 <-
      AuxFunctions::Replace_NA (
          Data_Calc_Unc$d_Insulation_Measure_Wall_01 / Data_Calc_Unc$R_Measure_Wall_01,
          0.04
      ) # <AZ13> | W/(m·K) | Calc.Set.Building | Real | R_Measure_Wall_01 | 216
  Data_Calc_Unc$Lambda_Measure_Wall_02 <-
      AuxFunctions::Replace_NA (
          Data_Calc_Unc$d_Insulation_Measure_Wall_02 / Data_Calc_Unc$R_Measure_Wall_02,
          0.04
      ) # <BA13> | W/(m·K) | Calc.Set.Building | Real | R_Measure_Wall_02 | 217
  Data_Calc_Unc$Lambda_Measure_Wall_03 <-
      AuxFunctions::Replace_NA (
          Data_Calc_Unc$d_Insulation_Measure_Wall_03 / Data_Calc_Unc$R_Measure_Wall_03,
          0.04
      ) # <BB13> | W/(m·K) | Calc.Set.Building | Real | R_Measure_Wall_03 | 218
  Data_Calc_Unc$Lambda_Measure_Floor_01 <-
      AuxFunctions::Replace_NA (
          Data_Calc_Unc$d_Insulation_Measure_Floor_01 / Data_Calc_Unc$R_Measure_Floor_01,
          0.04
      ) # <BC13> | W/(m·K) | Calc.Set.Building | Real | R_Measure_Floor_01 | 219
  Data_Calc_Unc$Lambda_Measure_Floor_02 <-
      AuxFunctions::Replace_NA (
          Data_Calc_Unc$d_Insulation_Measure_Floor_02 / Data_Calc_Unc$R_Measure_Floor_02,
          0.04
      ) # <BD13> | W/(m·K) | Calc.Set.Building | Real | R_Measure_Floor_02 | 220

  # Data_Calc_Unc$R_Measure_Window_01 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'R_Measure_Window_01') # <BE13> | m²K/W | Calc.Set.Building | Real | R_Measure_Window_01 | 221
  # Data_Calc_Unc$R_Measure_Window_02 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'R_Measure_Window_02') # <BF13> | m²K/W | Calc.Set.Building | Real | R_Measure_Window_02 | 222
  # Data_Calc_Unc$R_Measure_Door_01 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'R_Measure_Door_01') # <BG13> | m²K/W | Calc.Set.Building | Real | R_Measure_Door_01 | 223


  ###################################################################################X
  ## . Determine effective U-values (including effect of measures)  -----

  # used as reference for respective uncertainty

  Data_Calc_Unc$U_Effective_Roof_01 <-
      (1 - Data_Calc_Unc$f_Measure_Roof_01) *
          Data_Calc_Unc$U_Roof_Original_effective_1 +
      Data_Calc_Unc$f_Measure_Roof_01 * 1 /
      (1 / Data_Calc_Unc$U_Roof_Original_effective_1 +
           Data_Calc_Unc$d_Insulation_Measure_Roof_01 / Data_Calc_Unc$Lambda_Measure_Roof_01)
  # <BH13> | U_Effective | Roof_01 | Calc.Set.Building | Real
  Data_Calc_Unc$U_Effective_Roof_02 <-
      (1 - Data_Calc_Unc$f_Measure_Roof_02) *
      Data_Calc_Unc$U_Roof_Original_effective_2 +
      Data_Calc_Unc$f_Measure_Roof_02 * 1 /
      (1 / Data_Calc_Unc$U_Roof_Original_effective_2 +
           Data_Calc_Unc$d_Insulation_Measure_Roof_02 / Data_Calc_Unc$Lambda_Measure_Roof_02)
  # <BI13> | U_Effective | Roof_02 | Calc.Set.Building | Real
  Data_Calc_Unc$U_Effective_Wall_01 <-
      (1 - Data_Calc_Unc$f_Measure_Wall_01) *
      Data_Calc_Unc$U_Wall_Original_effective_1 +
      Data_Calc_Unc$f_Measure_Wall_01 * 1 / (
          1 / Data_Calc_Unc$U_Wall_Original_effective_1 +
              Data_Calc_Unc$d_Insulation_Measure_Wall_01 / Data_Calc_Unc$Lambda_Measure_Wall_01)
  # <BJ13> | U_Effective | Wall_01 | Calc.Set.Building | Real
  Data_Calc_Unc$U_Effective_Wall_02 <-
      (1 - Data_Calc_Unc$f_Measure_Wall_02) *
      Data_Calc_Unc$U_Wall_Original_effective_2 +
      Data_Calc_Unc$f_Measure_Wall_02 * 1 / (
          1 / Data_Calc_Unc$U_Wall_Original_effective_2 +
              Data_Calc_Unc$d_Insulation_Measure_Wall_02 / Data_Calc_Unc$Lambda_Measure_Wall_02)
  # <BK13> | U_Effective | Wall_02 | Calc.Set.Building | Real
  Data_Calc_Unc$U_Effective_Wall_03 <-
      (1 - Data_Calc_Unc$f_Measure_Wall_03) *
      Data_Calc_Unc$U_Wall_Original_effective_3 +
      Data_Calc_Unc$f_Measure_Wall_03 * 1 / (
          1 / Data_Calc_Unc$U_Wall_Original_effective_3 +
              Data_Calc_Unc$d_Insulation_Measure_Wall_03 / Data_Calc_Unc$Lambda_Measure_Wall_03)
  # <BL13> | U_Effective | Wall_03 | Calc.Set.Building | Real
  Data_Calc_Unc$U_Effective_Floor_01 <-
      (1 - Data_Calc_Unc$f_Measure_Floor_01) *
      Data_Calc_Unc$U_Floor_Original_effective_1 +
      Data_Calc_Unc$f_Measure_Floor_01 * 1 / (
          1 / Data_Calc_Unc$U_Floor_Original_effective_1 +
              Data_Calc_Unc$d_Insulation_Measure_Floor_01 / Data_Calc_Unc$Lambda_Measure_Floor_01)
  # <BM13> | U_Effective | Floor_01 | Calc.Set.Building | Real
  Data_Calc_Unc$U_Effective_Floor_02 <-
      (1 - Data_Calc_Unc$f_Measure_Floor_02) *
      Data_Calc_Unc$U_Floor_Original_effective_2 +
      Data_Calc_Unc$f_Measure_Floor_02 * 1 / (
          1 / Data_Calc_Unc$U_Floor_Original_effective_2 +
              Data_Calc_Unc$d_Insulation_Measure_Floor_02 / Data_Calc_Unc$Lambda_Measure_Floor_02)
  # <BN13> | U_Effective | Floor_02 | Calc.Set.Building | Real

  # Data_Calc_Unc$U_Actual_Window_01 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'U_Actual_Window_01') # <BO13> | Calc.Set.Building | Real | U_Actual_Window_01 | 300
  # Data_Calc_Unc$U_Actual_Window_02 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'U_Actual_Window_02') # <BP13> | Calc.Set.Building | Real | U_Actual_Window_02 | 301
  # Data_Calc_Unc$U_Actual_Door_01 <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'U_Actual_Door_01') # <BQ13> | Calc.Set.Building | Real | U_Actual_Door_01 | 302

  # Data_Calc_Unc$H_Transmission_Roof_01 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'H_Transmission_Roof_01'
  #     ) # <BR13> | heat transfer coefficient by transmission | element type roof 1 | W/K | Calc.Set.Building | Real | H_Transmission_Roof_01 | 306
  # Data_Calc_Unc$H_Transmission_Roof_02 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'H_Transmission_Roof_02'
  #     ) # <BS13> | heat transfer coefficient by transmission | element type roof 2 | W/K | Calc.Set.Building | Real | H_Transmission_Roof_02 | 307
  # Data_Calc_Unc$H_Transmission_Wall_01 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'H_Transmission_Wall_01'
  #     ) # <BT13> | heat transfer coefficient by transmission | element type wall 1 | W/K | Calc.Set.Building | Real | H_Transmission_Wall_01 | 308
  # Data_Calc_Unc$H_Transmission_Wall_02 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'H_Transmission_Wall_02'
  #     ) # <BU13> | heat transfer coefficient by transmission | element type wall 2 | W/K | Calc.Set.Building | Real | H_Transmission_Wall_02 | 309
  # Data_Calc_Unc$H_Transmission_Wall_03 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'H_Transmission_Wall_03'
  #     ) # <BV13> | heat transfer coefficient by transmission | element type wall 3 | W/K | Calc.Set.Building | Real | H_Transmission_Wall_03 | 310
  # Data_Calc_Unc$H_Transmission_Floor_01 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'H_Transmission_Floor_01'
  #     ) # <BW13> | heat transfer coefficient by transmission | element type floor 1 | W/K | Calc.Set.Building | Real | H_Transmission_Floor_01 | 311
  # Data_Calc_Unc$H_Transmission_Floor_02 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'H_Transmission_Floor_02'
  #     ) # <BX13> | heat transfer coefficient by transmission | element type floor 2 | W/K | Calc.Set.Building | Real | H_Transmission_Floor_02 | 312
  # Data_Calc_Unc$H_Transmission_Window_01 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'H_Transmission_Window_01'
  #     ) # <BY13> | heat transfer coefficient by transmission | element type window 1 | W/K | Calc.Set.Building | Real | H_Transmission_Window_01 | 313
  # Data_Calc_Unc$H_Transmission_Window_02 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'H_Transmission_Window_02'
  #     ) # <BZ13> | heat transfer coefficient by transmission | element type window 2 | W/K | Calc.Set.Building | Real | H_Transmission_Window_02 | 314
  # Data_Calc_Unc$H_Transmission_Door_01 <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'H_Transmission_Door_01'
  #     ) # <CA13> | heat transfer coefficient by transmission | element type door 1 | W/K | Calc.Set.Building | Real | H_Transmission_Door_01 | 315
  # Data_Calc_Unc$H_Transmission_ThermalBridging <-
  #     Value_ParTab (
  #         'Calc.Set.Building',
  #         Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #         'H_Transmission_ThermalBridging'
  #     ) # <CB13> | heat transfer coefficient by transmission | supplemental heat loss due to thermal bridging  | W/K | Calc.Set.Building | Real | H_Transmission_ThermalBridging | 316

  # Data_Calc_Unc$q_ht_tr <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'q_ht_tr') # <CC13> | floor area related annual transmission losses | kWh/(m²a) | Calc.Set.Building | Real | q_ht_tr | 323
  # Data_Calc_Unc$q_ht_ve <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'q_ht_ve') # <CD13> | floor area related annual ventilation losses | kWh/(m²a) | Calc.Set.Building | Real | q_ht_ve | 324

  # Data_Calc_Unc$A_Calc_Env_Sum
  # Data_Calc_Unc$A_Envelope <-
  #     SUM(
  #         OFFSET(
  #             'Calc.Set.Building',
  #             Data_Calc_Unc$Index_Row_SheetCalcBuilding - 1,
  #             A_Calc_Roof_01 - 1,
  #             1,
  #             10
  #         )
  #     ) # <CE13> | m² | Calc.Set.Building | VarChar | A_Calc_Roof_01 | 100


  Data_Calc_Unc$U_Average <-
      Data_Calc_Unc$h_Transmission * Data_Calc_Unc$A_C_Ref / Data_Calc_Unc$A_Calc_Env_Sum
  # <CF13> modified | Total heat transfer coefficient by transmission devided by envelope surface area | W/(m²K) | Calc.Set.Building | Real

  # Data_Calc_Unc$n_air_use <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'n_air_use') # <CG13> | average air change rate, due to use of the building | hygienical nessary air exchange rate by opening of windows, by ventilation systems, by parts of infiltration which are usable for necessary air exchange | 1/h | Calc.Set.Building | Real | n_air_use | 264

  # Data_Calc_Unc$theta_e <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'Theta_e') # <CH13> | average external air temperature during the heating season | if values are not available they can be determined from monthly climate data by use of the auxiliary calculation sheet "Tab.AuxCalc.Climate" | °C | Calc.Set.Building | Real | Theta_e | 250
  # Data_Calc_Unc$theta_i_calc <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'theta_i_calc') # <CI13> | internal temperature used for calculation | interpolation between theta_i_htr1 and theta_i_htr4 if theta_i is not available | °C | Calc.Set.Building | Real | theta_i_calc | 319
  # Data_Calc_Unc$I_Sol_South <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'I_Sol_South') # <CJ13> | average global irradiation on vertical surface oriented South during the heating season | kWh/a | Calc.Set.Building | Real | I_Sol_South | 253
  # Data_Calc_Unc$q_sol <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'q_sol') # <CK13> | floar area related solar heat load during heating season | kWh/(m²a) | Calc.Set.Building | Real | q_sol | 332
  # Data_Calc_Unc$q_int <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'q_int') # <CL13> | floar area related internal heat sources during heating season | kWh/(m²a) | Real | q_int | 333
  # Data_Calc_Unc$q_h_nd <-
  #     Value_ParTab ('Calc.Set.Building',
  #                   Data_Calc_Unc$Index_Row_SheetCalcBuilding,
  #                   'q_h_nd') # <CM13> | energy need for heating | kWh/(m²a) | Calc.Set.Building | Real | q_h_nd | 338
  # Data_Calc_Unc$q_s_w_h_usable <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'q_s_w_h_usable') # <CN13> | usable part of recoverable heat loss dhw storage | annual values in kWh per m² reference area  | kWh/(m²a) | Real | q_s_w_h_usable | 89
  # Data_Calc_Unc$q_d_w_h_usable <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'q_d_w_h_usable') # <CO13> | usable part of recoverable heat loss dhw distribution | annual values in kWh per m² reference area  | kWh/(m²a) | Real | q_d_w_h_usable | 90
  # Data_Calc_Unc$q_ve_rec_h_usable <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'q_ve_rec_h_usable') # <CP13> | usable contribution of ventilation heat recovery | annual values in kWh per m² reference area  | kWh/(m²a) | Real | q_ve_rec_h_usable | 91

  ###################################################################################X
  ## . Determine effective energy need for heating (including effect of ventilation heat recovery)  -----

  # used as reference for respective uncertainty

  ## 2022-12-02: Moved to CalcSytem.R
  #
  # Data_Calc_Unc$q_h_nd_eff <-
  #     AuxFunctions::Replace_NA (
  #         Data_Calc_Unc$q_h_nd -
  #             Data_Calc_Unc$q_ve_rec_h_usable -
  #             Data_Calc_Unc$q_s_w_h_usable -
  #             Data_Calc_Unc$q_d_w_h_usable,
  #         0)
  # <CQ13> | effective energy need for heating | to be covered by the space heating system: annual heat demand minus contribution by DHW heat loss and ventilation heat recovery | kWh/(m²a) | Real | q_h_nd_net_eff

  # Data_Calc_Unc$q_w_nd <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'q_w_nd') # <CR13> | contribution of ventilation heat recovery | annual values in kWh per m² reference area  | kWh/(m²a) | Calc.Set.System | Real | q_w_nd | 33

  # Data_Calc_Unc$q_del_h_1 <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'q_del_h_1') # <CS13> | delivered energy heat generator 1 | annual values in kWh per m² reference area  | kWh/(m²a) | Calc.Set.System | Real | q_del_h_1 | 94
  # Data_Calc_Unc$q_del_h_2 <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'q_del_h_2') # <CT13> | delivered energy heat generator 2 | annual values in kWh per m² reference area  | kWh/(m²a) | Calc.Set.System | Real | q_del_h_2 | 95
  # Data_Calc_Unc$q_del_h_3 <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'q_del_h_3') # <CU13> | delivered energy heat generator 3 | annual values in kWh per m² reference area  | kWh/(m²a) | Calc.Set.System | Real | q_del_h_3 | 96
  # Data_Calc_Unc$q_prod_el_h_1 <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'q_prod_el_h_1') # <CV13> | produced electricity heat generator 1 | only in case of chp engines / annual values in kWh per m² reference area | kWh/(m²a) | Calc.Set.System | Real | q_prod_el_h_1 | 97
  # Data_Calc_Unc$q_prod_el_h_2 <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'q_prod_el_h_2') # <CW13> | produced electricity heat generator 2 | only in case of chp engines / annual values in kWh per m² reference area | kWh/(m²a) | Calc.Set.System | Real | q_prod_el_h_2 | 98
  # Data_Calc_Unc$q_prod_el_h_3 <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'q_prod_el_h_3') # <CX13> | produced electricity heat generator 3 | only in case of chp engines / annual values in kWh per m² reference area | kWh/(m²a) | Calc.Set.System | Real | q_prod_el_h_3 | 99
  # Data_Calc_Unc$q_del_w_1 <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'q_del_w_1') # <CY13> | delivered energy heat generator 1 | annual values in kWh per m² reference area  | kWh/(m²a) | Calc.Set.System | Real | q_del_w_1 | 48
  # Data_Calc_Unc$q_del_w_2 <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'q_del_w_2') # <CZ13> | delivered energy heat generator 2 | annual values in kWh per m² reference area  | kWh/(m²a) | Calc.Set.System | Real | q_del_w_2 | 49
  # Data_Calc_Unc$q_del_w_3 <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'q_del_w_3') # <DA13> | delivered energy heat generator 3 | annual values in kWh per m² reference area  | kWh/(m²a) | Calc.Set.System | Real | q_del_w_3 | 50
  # Data_Calc_Unc$q_prod_el_w_1 <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'q_prod_el_w_1') # <DB13> | produced electricity heat generator 1 | only in case of chp engines / annual values in kWh per m² reference area | kWh/(m²a) | Calc.Set.System | Real | q_prod_el_w_1 | 51
  # Data_Calc_Unc$q_prod_el_w_2 <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'q_prod_el_w_2') # <DC13> | produced electricity heat generator 2 | only in case of chp engines / annual values in kWh per m² reference area | kWh/(m²a) | Calc.Set.System | Real | q_prod_el_w_2 | 52
  # Data_Calc_Unc$q_prod_el_w_3 <-
  #     Value_ParTab ('Calc.Set.System',
  #                   Data_Calc_Unc$Index_Row_SheetCalcSystem,
  #                   'q_prod_el_w_3') # <DD13> | produced electricity heat generator 3 | only in case of chp engines / annual values in kWh per m² reference area | kWh/(m²a) | Calc.Set.System | Real | q_prod_el_w_3 | 53

  ###################################################################################X
  ## . Determine reduction factor for utilisation uncertainty in buildings with more than 1 dwelling -----

  # 2023-01-26 Variable not used anymore, can later be commented / deleted
  Data_Calc_Unc$f_Reduction_VariationUtilisation_MultiDwelling <-
      AuxFunctions::Replace_NA (
          1 / sqrt (Data_Calc_Unc$n_Dwelling),
          1)
  # <DE13> | Reduction factor applied to variation of utilisation conditions defined on a one-dwelling basis for use in multi-dwelling buildings | Real

  # Data_Calc_Unc$Index_Row_SheetEnergyProfile <-
  #     AuxFunctions::Replace_NA (
  #         MATCH(
  #             Data_Calc_Unc$Code_UncertaintyAssessment,
  #             '[EnergyProfile.xlsm]Data.Out.TABULA!A:A',
  #             0
  #         ),
  #         0
  #     ) # <DF13> | Integer

  # Data_Calc_Unc$Code_TypeInput_Envelope_SurfaceArea <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_TypeInput_Envelope_SurfaceArea'
  #         ),
  #
  #     ) # <DG13> | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_TypeInput_Envelope_SurfaceArea | 35
  # Data_Calc_Unc$Code_TypeInput_Envelope_ThermalTransmittance <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_TypeInput_Envelope_ThermalTransmittance'
  #         ),
  #
  #     ) # <DH13> | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_TypeInput_Envelope_ThermalTransmittance | 36
  # Data_Calc_Unc$Code_Uncertainty_A_Envelope <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_A_Envelope'
  #         ),
  #         "_NA_"
  #     ) # <DI13> | SurfaceEnvelope | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_A_Envelope | 1553
  # Data_Calc_Unc$Code_Uncertainty_InputManual_U_Top <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_InputManual_U_Top'
  #         ),
  #
  #     ) # <DJ13> | Used when CodeTypeInput="Manual" | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_InputManual_U_Top | 1555
  # Data_Calc_Unc$Code_Uncertainty_InputManual_U_Wall <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_InputManual_U_Wall'
  #         ),
  #
  #     ) # <DK13> | Used when CodeTypeInput="Manual" | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_InputManual_U_Wall | 1556
  # Data_Calc_Unc$Code_Uncertainty_InputManual_U_Window <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_InputManual_U_Window'
  #         ),
  #
  #     ) # <DL13> | Used when CodeTypeInput="Manual" | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_InputManual_U_Window | 1557
  # Data_Calc_Unc$Code_Uncertainty_InputManual_U_Bottom <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_InputManual_U_Bottom'
  #         ),
  #
  #     ) # <DM13> | Used when CodeTypeInput="Manual" | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_InputManual_U_Bottom | 1558
  # Data_Calc_Unc$RelativeUncertainty_U_Input_Top <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_U_Input_Top'
  #         ),
  #
  #     ) # <DN13> | RelativeUncertainty | Used when CodeTypeInput="Manual" | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | RelativeUncertainty_U_Input_Top | 1559
  # Data_Calc_Unc$RelativeUncertainty_U_Input_Wall <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_U_Input_Wall'
  #         ),
  #
  #     ) # <DO13> | RelativeUncertainty | Used when CodeTypeInput="Manual" | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | RelativeUncertainty_U_Input_Wall | 1560
  # Data_Calc_Unc$RelativeUncertainty_U_Input_Window <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_U_Input_Window'
  #         ),
  #
  #     ) # <DP13> | RelativeUncertainty | Used when CodeTypeInput="Manual" | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | RelativeUncertainty_U_Input_Window | 1561
  # Data_Calc_Unc$RelativeUncertainty_U_Input_Bottom <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_U_Input_Bottom'
  #         ),
  #
  #     ) # <DQ13> | RelativeUncertainty | Used when CodeTypeInput="Manual" | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | RelativeUncertainty_U_Input_Bottom | 1562
  # Data_Calc_Unc$Code_Uncertainty_U_Original <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_U_Original'
  #         ),
  #
  #     ) # <DR13> | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_U_Original | 1563
  # Data_Calc_Unc$Code_Uncertainty_f_Insulation_Roof <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_f_Insulation_Roof'
  #         ),
  #
  #     ) # <DS13> | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_f_Insulation_Roof | 1564
  # Data_Calc_Unc$Code_Uncertainty_f_Insulation_Ceiling <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_f_Insulation_Ceiling'
  #         ),
  #
  #     ) # <DT13> | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_f_Insulation_Ceiling | 1565
  # Data_Calc_Unc$Code_Uncertainty_f_Insulation_Wall <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_f_Insulation_Wall'
  #         ),
  #
  #     ) # <DU13> | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_f_Insulation_Wall | 1566
  # Data_Calc_Unc$Code_Uncertainty_f_Insulation_Floor <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_f_Insulation_Floor'
  #         ),
  #
  #     ) # <DV13> | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_f_Insulation_Floor | 1567
  # Data_Calc_Unc$Code_Uncertainty_d_Insulation_Roof <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_d_Insulation_Roof'
  #         ),
  #
  #     ) # <DW13> | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_d_Insulation_Roof | 1568
  # Data_Calc_Unc$Code_Uncertainty_d_Insulation_Ceiling <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_d_Insulation_Ceiling'
  #         ),
  #
  #     ) # <DX13> | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_d_Insulation_Ceiling | 1569
  # Data_Calc_Unc$Code_Uncertainty_d_Insulation_Wall <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_d_Insulation_Wall'
  #         ),
  #
  #     ) # <DY13> | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_d_Insulation_Wall | 1570
  # Data_Calc_Unc$Code_Uncertainty_d_Insulation_Floor <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_d_Insulation_Floor'
  #         ),
  #
  #     ) # <DZ13> | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_d_Insulation_Floor | 1571
  # Data_Calc_Unc$Code_Uncertainty_Lambda_Insulation_Roof <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_Lambda_Insulation_Roof'
  #         ),
  #
  #     ) # <EA13> | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_Lambda_Insulation_Roof | 1572
  # Data_Calc_Unc$Code_Uncertainty_Lambda_Insulation_Ceiling <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_Lambda_Insulation_Ceiling'
  #         ),
  #
  #     ) # <EB13> | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_Lambda_Insulation_Ceiling | 1573
  # Data_Calc_Unc$Code_Uncertainty_Lambda_Insulation_Wall <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_Lambda_Insulation_Wall'
  #         ),
  #
  #     ) # <EC13> | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_Lambda_Insulation_Wall | 1574
  # Data_Calc_Unc$Code_Uncertainty_Lambda_Insulation_Floor <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_Lambda_Insulation_Floor'
  #         ),
  #
  #     ) # <ED13> | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_Lambda_Insulation_Floor | 1575
  # Data_Calc_Unc$RelativeUncertainty_A_Envelope <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_A_Envelope'
  #         ),
  #
  #     ) # <EE13> | RelativeUncertainty | A_Envelope | related to A_Envelope | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_A_Envelope | 1554
  # Data_Calc_Unc$RelativeUncertainty_U_Original <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_U_Original'
  #         ),
  #
  #     ) # <EF13> | RelativeUncertainty | U_Original | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_U_Original | 1578
  # Data_Calc_Unc$AbsoluteUncertainty_f_Insulation_Roof <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'AbsoluteUncertainty_f_Insulation_Roof'
  #         ),
  #
  #     ) # <EG13> | AbsoluteUncertainty | f_Insulation_Roof | [EnergyProfile.xlsm]Data.Out.TABULA | Real | AbsoluteUncertainty_f_Insulation_Roof | 1579
  # Data_Calc_Unc$AbsoluteUncertainty_f_Insulation_Ceiling <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'AbsoluteUncertainty_f_Insulation_Ceiling'
  #         ),
  #
  #     ) # <EH13> | AbsoluteUncertainty | f_Insulation_Ceiling | [EnergyProfile.xlsm]Data.Out.TABULA | Real | AbsoluteUncertainty_f_Insulation_Ceiling | 1580
  # Data_Calc_Unc$AbsoluteUncertainty_f_Insulation_Wall <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'AbsoluteUncertainty_f_Insulation_Wall'
  #         ),
  #
  #     ) # <EI13> | AbsoluteUncertainty | f_Insulation_Wall | [EnergyProfile.xlsm]Data.Out.TABULA | Real | AbsoluteUncertainty_f_Insulation_Wall | 1581
  # Data_Calc_Unc$AbsoluteUncertainty_f_Insulation_Floor <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'AbsoluteUncertainty_f_Insulation_Floor'
  #         ),
  #
  #     ) # <EJ13> | AbsoluteUncertainty | f_Insulation_Floor | [EnergyProfile.xlsm]Data.Out.TABULA | Real | AbsoluteUncertainty_f_Insulation_Floor | 1582
  # Data_Calc_Unc$RelativeUncertainty_d_Insulation_Roof <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_d_Insulation_Roof'
  #         ),
  #
  #     ) # <EK13> | RelativeUncertainty | d_Insulation_Roof | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_d_Insulation_Roof | 1583
  # Data_Calc_Unc$RelativeUncertainty_d_Insulation_Ceiling <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_d_Insulation_Ceiling'
  #         ),
  #
  #     ) # <EL13> | RelativeUncertainty | d_Insulation_Ceiling | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_d_Insulation_Ceiling | 1584
  # Data_Calc_Unc$RelativeUncertainty_d_Insulation_Wall <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_d_Insulation_Wall'
  #         ),
  #
  #     ) # <EM13> | RelativeUncertainty | d_Insulation_Wall | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_d_Insulation_Wall | 1585
  # Data_Calc_Unc$RelativeUncertainty_d_Insulation_Floor <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_d_Insulation_Floor'
  #         ),
  #
  #     ) # <EN13> | RelativeUncertainty | d_Insulation_Floor | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_d_Insulation_Floor | 1586
  # Data_Calc_Unc$AbsoluteUncertainty_d_Insulation_Roof <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'AbsoluteUncertainty_d_Insulation_Roof'
  #         ),
  #
  #     ) # <EO13> | AbsoluteUncertainty | d_Insulation_Roof | [EnergyProfile.xlsm]Data.Out.TABULA | Real | AbsoluteUncertainty_d_Insulation_Roof | 1587
  # Data_Calc_Unc$AbsoluteUncertainty_d_Insulation_Ceiling <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'AbsoluteUncertainty_d_Insulation_Ceiling'
  #         ),
  #
  #     ) # <EP13> | AbsoluteUncertainty | d_Insulation_Ceiling | [EnergyProfile.xlsm]Data.Out.TABULA | Real | AbsoluteUncertainty_d_Insulation_Ceiling | 1588
  # Data_Calc_Unc$AbsoluteUncertainty_d_Insulation_Wall <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'AbsoluteUncertainty_d_Insulation_Wall'
  #         ),
  #
  #     ) # <EQ13> | AbsoluteUncertainty | d_Insulation_Wall | [EnergyProfile.xlsm]Data.Out.TABULA | Real | AbsoluteUncertainty_d_Insulation_Wall | 1589
  # Data_Calc_Unc$AbsoluteUncertainty_d_Insulation_Floor <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'AbsoluteUncertainty_d_Insulation_Floor'
  #         ),
  #
  #     ) # <ER13> | AbsoluteUncertainty | d_Insulation_Floor | [EnergyProfile.xlsm]Data.Out.TABULA | Real | AbsoluteUncertainty_d_Insulation_Floor | 1590
  # Data_Calc_Unc$RelativeUncertainty_Lambda_Insulation_Roof <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_Lambda_Insulation_Roof'
  #         ),
  #
  #     ) # <ES13> | RelativeUncertainty | Lambda_Insulation_Roof | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_Lambda_Insulation_Roof | 1591
  # Data_Calc_Unc$RelativeUncertainty_Lambda_Insulation_Ceiling <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_Lambda_Insulation_Ceiling'
  #         ),
  #
  #     ) # <ET13> | RelativeUncertainty | Lambda_Insulation_Ceiling | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_Lambda_Insulation_Ceiling | 1592
  # Data_Calc_Unc$RelativeUncertainty_Lambda_Insulation_Wall <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_Lambda_Insulation_Wall'
  #         ),
  #
  #     ) # <EU13> | RelativeUncertainty | Lambda_Insulation_Wall | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_Lambda_Insulation_Wall | 1593
  # Data_Calc_Unc$RelativeUncertainty_Lambda_Insulation_Floor <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_Lambda_Insulation_Floor'
  #         ),
  #
  #     ) # <EV13> | RelativeUncertainty | Lambda_Insulation_Floor | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_Lambda_Insulation_Floor | 1594

  #.---------------------------------------------------------------------------------------------------


  ###################################################################################X
  ##   Determine effect of input uncertainties on calculation uncertainty  -----
  ###################################################################################X


  ###################################################################################X
  ## . Change of effective U-value caused by alteration of single input quantities  -----

  Data_Calc_Unc$Delta_U_Eff_Unc_By_U_Original_Roof_01 <-
      (1 + Data_Calc_Unc$f_Measure_Roof_01 *
           (1 / (1 + Data_Calc_Unc$d_Insulation_Measure_Roof_01 /
                   Data_Calc_Unc$Lambda_Measure_Roof_01 *
                   Data_Calc_Unc$U_Roof_Original_effective_1) ^ 2 - 1)
       ) * Data_Calc_Unc$RelativeUncertainty_U_Original *
      Data_Calc_Unc$U_Roof_Original_effective_1
  # <EW13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | U_Original_eff | Roof_01 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_U_Original_Roof_02 <-
      (1 + Data_Calc_Unc$f_Measure_Roof_02 *
           (1 / (1 + Data_Calc_Unc$d_Insulation_Measure_Roof_02 /
                  Data_Calc_Unc$Lambda_Measure_Roof_02 *
                  Data_Calc_Unc$U_Roof_Original_effective_2) ^ 2 - 1)
       ) * Data_Calc_Unc$RelativeUncertainty_U_Original *
      Data_Calc_Unc$U_Roof_Original_effective_2
  # <EX13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | U_Original_eff | Roof_02 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_U_Original_Wall_01 <-
      (1 + Data_Calc_Unc$f_Measure_Wall_01 * (
          1 / (
              1 + Data_Calc_Unc$d_Insulation_Measure_Wall_01 /
                  Data_Calc_Unc$Lambda_Measure_Wall_01 *
                  Data_Calc_Unc$U_Wall_Original_effective_1
          ) ^ 2 - 1
      )) * Data_Calc_Unc$RelativeUncertainty_U_Original *
      Data_Calc_Unc$U_Wall_Original_effective_1
  # <EY13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | U_Original_eff | Wall_01 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_U_Original_Wall_02 <-
      (1 + Data_Calc_Unc$f_Measure_Wall_02 * (
          1 / (
              1 + Data_Calc_Unc$d_Insulation_Measure_Wall_02 /
                  Data_Calc_Unc$Lambda_Measure_Wall_02 *
                  Data_Calc_Unc$U_Wall_Original_effective_2
          ) ^ 2 - 1
      )) * Data_Calc_Unc$RelativeUncertainty_U_Original *
      Data_Calc_Unc$U_Wall_Original_effective_2
  # <EZ13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | U_Original_eff | Wall_02 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_U_Original_Wall_03 <-
      (1 + Data_Calc_Unc$f_Measure_Wall_03 * (
          1 / (
              1 + Data_Calc_Unc$d_Insulation_Measure_Wall_03 /
                  Data_Calc_Unc$Lambda_Measure_Wall_03 *
                  Data_Calc_Unc$U_Wall_Original_effective_3
          ) ^ 2 - 1
      )) * Data_Calc_Unc$RelativeUncertainty_U_Original *
      Data_Calc_Unc$U_Wall_Original_effective_3
  # <FA13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | U_Original_eff | Wall_03 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_U_Original_Floor_01 <-
      (1 + Data_Calc_Unc$f_Measure_Floor_01 * (
          1 / (
              1 + Data_Calc_Unc$d_Insulation_Measure_Floor_01 /
                  Data_Calc_Unc$Lambda_Measure_Floor_01 *
                  Data_Calc_Unc$U_Floor_Original_effective_1
          ) ^ 2 - 1
      )) * Data_Calc_Unc$RelativeUncertainty_U_Original *
      Data_Calc_Unc$U_Floor_Original_effective_1
  # <FB13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | U_Original_eff | Floor_01 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_U_Original_Floor_02 <-
      (1 + Data_Calc_Unc$f_Measure_Floor_02 * (
          1 / (
              1 + Data_Calc_Unc$d_Insulation_Measure_Floor_02 /
                  Data_Calc_Unc$Lambda_Measure_Floor_02 *
                  Data_Calc_Unc$U_Floor_Original_effective_2
          ) ^ 2 - 1
      )) * Data_Calc_Unc$RelativeUncertainty_U_Original *
      Data_Calc_Unc$U_Floor_Original_effective_2
  # <FC13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | U_Original_eff | Floor_02 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_f_Insulation_Roof_01 <-
      (-Data_Calc_Unc$U_Roof_Original_effective_1 + 1 / (
              1 / Data_Calc_Unc$U_Roof_Original_effective_1 +
                  Data_Calc_Unc$d_Insulation_Measure_Roof_01 /
                  Data_Calc_Unc$Lambda_Measure_Roof_01
          )
      ) * pmin (
          Data_Calc_Unc$AbsoluteUncertainty_f_Insulation_Roof,
          Data_Calc_Unc$f_Measure_Roof_01,
          1 - Data_Calc_Unc$f_Measure_Roof_01
      )
  # <FD13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | f_Insulation | Roof_01 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_f_Insulation_Roof_02 <-
      (-Data_Calc_Unc$U_Roof_Original_effective_2 + 1 / (
              1 / Data_Calc_Unc$U_Roof_Original_effective_2 +
                  Data_Calc_Unc$d_Insulation_Measure_Roof_02 /
                  Data_Calc_Unc$Lambda_Measure_Roof_02
          )
      ) * pmin (
          Data_Calc_Unc$AbsoluteUncertainty_f_Insulation_Ceiling,
          Data_Calc_Unc$f_Measure_Roof_02,
          1 - Data_Calc_Unc$f_Measure_Roof_02
      )
  # <FE13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | f_Insulation | Roof_02 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_f_Insulation_Wall_01 <-
      (-Data_Calc_Unc$U_Wall_Original_effective_1 + 1 / (
              1 / Data_Calc_Unc$U_Wall_Original_effective_1 +
                  Data_Calc_Unc$d_Insulation_Measure_Wall_01 /
                  Data_Calc_Unc$Lambda_Measure_Wall_01
          )
      ) * pmin (
          Data_Calc_Unc$AbsoluteUncertainty_f_Insulation_Wall,
          Data_Calc_Unc$f_Measure_Wall_01,
          1 - Data_Calc_Unc$f_Measure_Wall_01
      )
  # <FF13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | f_Insulation | Wall_01 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_f_Insulation_Wall_02 <-
      (-Data_Calc_Unc$U_Wall_Original_effective_2 + 1 / (
              1 / Data_Calc_Unc$U_Wall_Original_effective_2 +
                  Data_Calc_Unc$d_Insulation_Measure_Wall_02 /
                  Data_Calc_Unc$Lambda_Measure_Wall_02
          )
      ) * pmin (
          Data_Calc_Unc$AbsoluteUncertainty_f_Insulation_Wall,
          Data_Calc_Unc$f_Measure_Wall_02,
          1 - Data_Calc_Unc$f_Measure_Wall_02
      )
  # <FG13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | f_Insulation | Wall_02 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_f_Insulation_Wall_03 <-
      (-Data_Calc_Unc$U_Wall_Original_effective_3 + 1 / (
              1 / Data_Calc_Unc$U_Wall_Original_effective_3 +
                  Data_Calc_Unc$d_Insulation_Measure_Wall_03 /
                  Data_Calc_Unc$Lambda_Measure_Wall_03
          )
      ) * pmin (
          Data_Calc_Unc$AbsoluteUncertainty_f_Insulation_Wall,
          Data_Calc_Unc$f_Measure_Wall_03,
          1 - Data_Calc_Unc$f_Measure_Wall_03
      )
  # <FH13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | f_Insulation | Wall_03 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_f_Insulation_Floor_01 <-
      (-Data_Calc_Unc$U_Floor_Original_effective_1 + 1 / (
              1 / Data_Calc_Unc$U_Floor_Original_effective_1 +
                  Data_Calc_Unc$d_Insulation_Measure_Floor_01 /
                  Data_Calc_Unc$Lambda_Measure_Floor_01
          )
      ) * pmin (
          Data_Calc_Unc$AbsoluteUncertainty_f_Insulation_Floor,
          Data_Calc_Unc$f_Measure_Floor_01,
          1 - Data_Calc_Unc$f_Measure_Floor_01
      )
  # <FI13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | f_Insulation | Floor_01 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_f_Insulation_Floor_02 <-
      (-Data_Calc_Unc$U_Floor_Original_effective_2 + 1 / (
              1 / Data_Calc_Unc$U_Floor_Original_effective_2 +
                  Data_Calc_Unc$d_Insulation_Measure_Floor_02 /
                  Data_Calc_Unc$Lambda_Measure_Floor_02
          )
      ) * pmin (
          Data_Calc_Unc$AbsoluteUncertainty_f_Insulation_Floor,
          Data_Calc_Unc$f_Measure_Floor_02,
          1 - Data_Calc_Unc$f_Measure_Floor_02
      )
  # <FJ13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | f_Insulation | Floor_02 | Real

  Data_Calc_Unc$Delta_U_Eff_Unc_By_d_Insulation_Roof_01 <-
      -Data_Calc_Unc$f_Measure_Roof_01 * Data_Calc_Unc$Lambda_Measure_Roof_01 / (
          Data_Calc_Unc$Lambda_Measure_Roof_01 /
              Data_Calc_Unc$U_Roof_Original_effective_1 +
              Data_Calc_Unc$d_Insulation_Measure_Roof_01
      ) ^ 2 * pmin (
          Data_Calc_Unc$RelativeUncertainty_d_Insulation_Roof *
              Data_Calc_Unc$d_Insulation_Measure_Roof_01,
          Data_Calc_Unc$AbsoluteUncertainty_d_Insulation_Roof / 100
      )
  # <FK13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | d_Insulation | Roof_01 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_d_Insulation_Roof_02 <-
      -Data_Calc_Unc$f_Measure_Roof_02 * Data_Calc_Unc$Lambda_Measure_Roof_02 / (
          Data_Calc_Unc$Lambda_Measure_Roof_02 /
              Data_Calc_Unc$U_Roof_Original_effective_2 +
              Data_Calc_Unc$d_Insulation_Measure_Roof_02
      ) ^ 2 * pmin (
          Data_Calc_Unc$RelativeUncertainty_d_Insulation_Ceiling *
              Data_Calc_Unc$d_Insulation_Measure_Roof_02,
          Data_Calc_Unc$AbsoluteUncertainty_d_Insulation_Ceiling / 100
      )
  # <FL13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | d_Insulation | Roof_02 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_d_Insulation_Wall_01 <-
      -Data_Calc_Unc$f_Measure_Wall_01 * Data_Calc_Unc$Lambda_Measure_Wall_01 / (
          Data_Calc_Unc$Lambda_Measure_Wall_01 /
              Data_Calc_Unc$U_Wall_Original_effective_1 +
              Data_Calc_Unc$d_Insulation_Measure_Wall_01
      ) ^ 2 * pmin (
          Data_Calc_Unc$RelativeUncertainty_d_Insulation_Wall *
              Data_Calc_Unc$d_Insulation_Measure_Wall_01,
          Data_Calc_Unc$AbsoluteUncertainty_d_Insulation_Wall / 100
      )
  # <FM13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | d_Insulation | Wall_01 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_d_Insulation_Wall_02 <-
      -Data_Calc_Unc$f_Measure_Wall_02 * Data_Calc_Unc$Lambda_Measure_Wall_02 / (
          Data_Calc_Unc$Lambda_Measure_Wall_02 /
              Data_Calc_Unc$U_Wall_Original_effective_2 +
              Data_Calc_Unc$d_Insulation_Measure_Wall_02
      ) ^ 2 * pmin (
          Data_Calc_Unc$RelativeUncertainty_d_Insulation_Wall *
              Data_Calc_Unc$d_Insulation_Measure_Wall_02,
          Data_Calc_Unc$AbsoluteUncertainty_d_Insulation_Wall / 100
      )
  # <FN13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | d_Insulation | Wall_02 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_d_Insulation_Wall_03 <-
      -Data_Calc_Unc$f_Measure_Wall_03 * Data_Calc_Unc$Lambda_Measure_Wall_03 / (
          Data_Calc_Unc$Lambda_Measure_Wall_03 /
              Data_Calc_Unc$U_Wall_Original_effective_3 +
              Data_Calc_Unc$d_Insulation_Measure_Wall_03
      ) ^ 2 * pmin (
          Data_Calc_Unc$RelativeUncertainty_d_Insulation_Wall *
              Data_Calc_Unc$d_Insulation_Measure_Wall_03,
          Data_Calc_Unc$AbsoluteUncertainty_d_Insulation_Wall / 100
      )
  # <FO13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | d_Insulation | Wall_03 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_d_Insulation_Floor_01 <-
      -Data_Calc_Unc$f_Measure_Floor_01 * Data_Calc_Unc$Lambda_Measure_Floor_01 / (
          Data_Calc_Unc$Lambda_Measure_Floor_01 /
              Data_Calc_Unc$U_Floor_Original_effective_1 +
              Data_Calc_Unc$d_Insulation_Measure_Floor_01
      ) ^ 2 * pmin (
          Data_Calc_Unc$RelativeUncertainty_d_Insulation_Floor *
              Data_Calc_Unc$d_Insulation_Measure_Floor_01,
          Data_Calc_Unc$AbsoluteUncertainty_d_Insulation_Floor / 100
      )
  # <FP13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | d_Insulation | Floor_01 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_d_Insulation_Floor_02 <-
      -Data_Calc_Unc$f_Measure_Floor_02 * Data_Calc_Unc$Lambda_Measure_Floor_02 / (
          Data_Calc_Unc$Lambda_Measure_Floor_02 /
              Data_Calc_Unc$U_Floor_Original_effective_2 +
              Data_Calc_Unc$d_Insulation_Measure_Floor_02
      ) ^ 2 * pmin (
          Data_Calc_Unc$RelativeUncertainty_d_Insulation_Floor *
              Data_Calc_Unc$d_Insulation_Measure_Floor_02,
          Data_Calc_Unc$AbsoluteUncertainty_d_Insulation_Floor / 100
      )
  # <FQ13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | d_Insulation | Floor_02 | Real

  Data_Calc_Unc$Delta_U_Eff_Unc_By_Lambda_Insulation_Roof_01 <-
      Data_Calc_Unc$f_Measure_Roof_01 * Data_Calc_Unc$d_Insulation_Measure_Roof_01 / (
          Data_Calc_Unc$Lambda_Measure_Roof_01 /
              Data_Calc_Unc$U_Roof_Original_effective_1 +
              Data_Calc_Unc$d_Insulation_Measure_Roof_01
      ) ^ 2 * Data_Calc_Unc$RelativeUncertainty_Lambda_Insulation_Roof *
      Data_Calc_Unc$Lambda_Measure_Roof_01
  # <FR13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | Lambda_Insulation | Roof_01 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_Lambda_Insulation_Roof_02 <-
      Data_Calc_Unc$f_Measure_Roof_02 * Data_Calc_Unc$d_Insulation_Measure_Roof_02 / (
          Data_Calc_Unc$Lambda_Measure_Roof_02 /
              Data_Calc_Unc$U_Roof_Original_effective_2 +
              Data_Calc_Unc$d_Insulation_Measure_Roof_02
      ) ^ 2 * Data_Calc_Unc$RelativeUncertainty_Lambda_Insulation_Ceiling *
      Data_Calc_Unc$Lambda_Measure_Roof_02
  # <FS13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | Lambda_Insulation | Roof_02 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_Lambda_Insulation_Wall_01 <-
      Data_Calc_Unc$f_Measure_Wall_01 * Data_Calc_Unc$d_Insulation_Measure_Wall_01 / (
          Data_Calc_Unc$Lambda_Measure_Wall_01 /
              Data_Calc_Unc$U_Wall_Original_effective_1 +
              Data_Calc_Unc$d_Insulation_Measure_Wall_01
      ) ^ 2 * Data_Calc_Unc$RelativeUncertainty_Lambda_Insulation_Wall *
      Data_Calc_Unc$Lambda_Measure_Wall_01
  # <FT13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | Lambda_Insulation | Wall_01 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_Lambda_Insulation_Wall_02 <-
      Data_Calc_Unc$f_Measure_Wall_02 * Data_Calc_Unc$d_Insulation_Measure_Wall_02 / (
          Data_Calc_Unc$Lambda_Measure_Wall_02 /
              Data_Calc_Unc$U_Wall_Original_effective_2 +
              Data_Calc_Unc$d_Insulation_Measure_Wall_02
      ) ^ 2 * Data_Calc_Unc$RelativeUncertainty_Lambda_Insulation_Wall *
      Data_Calc_Unc$Lambda_Measure_Wall_02
  # <FU13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | Lambda_Insulation | Wall_02 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_Lambda_Insulation_Wall_03 <-
      Data_Calc_Unc$f_Measure_Wall_03 * Data_Calc_Unc$d_Insulation_Measure_Wall_03 / (
          Data_Calc_Unc$Lambda_Measure_Wall_03 /
              Data_Calc_Unc$U_Wall_Original_effective_3 +
              Data_Calc_Unc$d_Insulation_Measure_Wall_03
      ) ^ 2 * Data_Calc_Unc$RelativeUncertainty_Lambda_Insulation_Wall *
      Data_Calc_Unc$Lambda_Measure_Wall_03
  # <FV13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | Lambda_Insulation | Wall_03 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_Lambda_Insulation_Floor_01 <-
      Data_Calc_Unc$f_Measure_Floor_01 * Data_Calc_Unc$d_Insulation_Measure_Floor_01 / (
          Data_Calc_Unc$Lambda_Measure_Floor_01 /
              Data_Calc_Unc$U_Floor_Original_effective_1 +
              Data_Calc_Unc$d_Insulation_Measure_Floor_01
      ) ^ 2 * Data_Calc_Unc$RelativeUncertainty_Lambda_Insulation_Floor * Data_Calc_Unc$Lambda_Measure_Floor_01
  # <FW13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | Lambda_Insulation | Floor_01 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_By_Lambda_Insulation_Floor_02 <-
      Data_Calc_Unc$f_Measure_Floor_02 * Data_Calc_Unc$d_Insulation_Measure_Floor_02 / (
          Data_Calc_Unc$Lambda_Measure_Floor_02 /
              Data_Calc_Unc$U_Floor_Original_effective_2 +
              Data_Calc_Unc$d_Insulation_Measure_Floor_02
      ) ^ 2 * Data_Calc_Unc$RelativeUncertainty_Lambda_Insulation_Floor * Data_Calc_Unc$Lambda_Measure_Floor_02
  # <FX13> | Change of effective U-value caused by alteration of input quantity (increase by amount of uncertainty) | Lambda_Insulation | Floor_02 | Real


  ###################################################################################X
  ## . Resulting absolute uncertainty of effective U-values  -----

  Data_Calc_Unc$Delta_U_Eff_Unc_Roof_01 <-
      sqrt(
          Data_Calc_Unc$Delta_U_Eff_Unc_By_U_Original_Roof_01 ^ 2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_f_Insulation_Roof_01 ^
              2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_d_Insulation_Roof_01 ^ 2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_Lambda_Insulation_Roof_01 ^
              2
      ) # <FY13> | Uncertainty of U-value caused by uncertainties of all input quantities | Roof_01 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_Roof_02 <-
      sqrt(
          Data_Calc_Unc$Delta_U_Eff_Unc_By_U_Original_Roof_02 ^ 2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_f_Insulation_Roof_02 ^
              2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_d_Insulation_Roof_02 ^ 2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_Lambda_Insulation_Roof_02 ^
              2
      ) # <FZ13> | Uncertainty of U-value caused by uncertainties of all input quantities | Roof_02 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_Wall_01 <-
      sqrt(
          Data_Calc_Unc$Delta_U_Eff_Unc_By_U_Original_Wall_01 ^ 2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_f_Insulation_Wall_01 ^
              2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_d_Insulation_Wall_01 ^ 2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_Lambda_Insulation_Wall_01 ^
              2
      ) # <GA13> | Uncertainty of U-value caused by uncertainties of all input quantities | Wall_01 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_Wall_02 <-
      sqrt(
          Data_Calc_Unc$Delta_U_Eff_Unc_By_U_Original_Wall_02 ^ 2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_f_Insulation_Wall_02 ^
              2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_d_Insulation_Wall_02 ^ 2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_Lambda_Insulation_Wall_02 ^
              2
      ) # <GB13> | Uncertainty of U-value caused by uncertainties of all input quantities | Wall_02 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_Wall_03 <-
      sqrt(
          Data_Calc_Unc$Delta_U_Eff_Unc_By_U_Original_Wall_03 ^ 2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_f_Insulation_Wall_03 ^
              2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_d_Insulation_Wall_03 ^ 2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_Lambda_Insulation_Wall_03 ^
              2
      ) # <GC13> | Uncertainty of U-value caused by uncertainties of all input quantities | Wall_03 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_Floor_01 <-
      sqrt(
          Data_Calc_Unc$Delta_U_Eff_Unc_By_U_Original_Floor_01 ^ 2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_f_Insulation_Floor_01 ^
              2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_d_Insulation_Floor_01 ^ 2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_Lambda_Insulation_Floor_01 ^
              2
      ) # <GD13> | Uncertainty of U-value caused by uncertainties of all input quantities | Floor_01 | Real
  Data_Calc_Unc$Delta_U_Eff_Unc_Floor_02 <-
      sqrt(
          Data_Calc_Unc$Delta_U_Eff_Unc_By_U_Original_Floor_02 ^ 2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_f_Insulation_Floor_02 ^
              2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_d_Insulation_Floor_02 ^ 2 + Data_Calc_Unc$Delta_U_Eff_Unc_By_Lambda_Insulation_Floor_02 ^
              2
      ) # <GE13> | Uncertainty of U-value caused by uncertainties of all input quantities | Floor_02 | Real


  # Data_Calc_Unc$Code_Uncertainty_U_WindowType1 <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_U_WindowType1'
  #         ),
  #
  #     ) # <GF13> | [EnergyProfile.xlsm]Data.Out.TABULA | Real | Code_Uncertainty_U_WindowType1 | 1576
  # Data_Calc_Unc$Code_Uncertainty_U_WindowType2 <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_U_WindowType2'
  #         ),
  #
  #     ) # <GG13> | [EnergyProfile.xlsm]Data.Out.TABULA | Real | Code_Uncertainty_U_WindowType2 | 1577
  # Data_Calc_Unc$RelativeUncertainty_U_WindowType1 <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_U_WindowType1'
  #         ),
  #
  #     ) # <GH13> | RelativeUncertainty | U_WindowType1 | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_U_WindowType1 | 1595
  # Data_Calc_Unc$RelativeUncertainty_U_WindowType2 <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_U_WindowType2'
  #         ),
  #
  #     ) # <GI13> | RelativeUncertainty | U_WindowType2 | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_U_WindowType2 | 1596
  # Data_Calc_Unc$Code_Uncertainty_ThermalBridging <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_ThermalBridging'
  #         ),
  #
  #     ) # <GJ13> | ThermalBridging | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_ThermalBridging | 1597
  # Data_Calc_Unc$AbsoluteUncertainty_DeltaU_ThermalBridging <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'AbsoluteUncertainty_DeltaU_ThermalBridging'
  #         ),
  #
  #     ) # <GK13> | ThermalBridging | [EnergyProfile.xlsm]Data.Out.TABULA | Real | AbsoluteUncertainty_DeltaU_ThermalBridging | 1598

  ###################################################################################X
  ## . Resulting relative uncertainty of effective U-values  -----

  Data_Calc_Unc$RelativeUncertainty_DeltaU_ThermalBridging <-
      AuxFunctions::Replace_NA (Data_Calc_Unc$AbsoluteUncertainty_DeltaU_ThermalBridging / Data_Calc_Unc$U_Average,
                  0)
  # <GL13> | ThermalBridging | related to U_Average (total heat transfer by transmission divided by envelope area) | Calc.Demo.Uncertainty | Real
  Data_Calc_Unc$RelativeUncertainty_U_eff_Roof_01 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_Unc$Code_TypeInput_Envelope_ThermalTransmittance, "-") == "Manual",
          Data_Calc_Unc$RelativeUncertainty_U_Input_Top,
          Data_Calc_Unc$Delta_U_Eff_Unc_Roof_01 / Data_Calc_Unc$U_Effective_Roof_01
      )
  # <GM13> | U_eff_Roof_01 | related to U_eff | Real
  Data_Calc_Unc$RelativeUncertainty_U_eff_Roof_02 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_Unc$Code_TypeInput_Envelope_ThermalTransmittance, "-") == "Manual",
          Data_Calc_Unc$RelativeUncertainty_U_Input_Top,
          Data_Calc_Unc$Delta_U_Eff_Unc_Roof_02 / Data_Calc_Unc$U_Effective_Roof_02
      )
  # <GN13> | U_eff_Roof_02 | related to U_eff | Real
  Data_Calc_Unc$RelativeUncertainty_U_eff_Wall_01 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_Unc$Code_TypeInput_Envelope_ThermalTransmittance, "-") == "Manual",
          Data_Calc_Unc$RelativeUncertainty_U_Input_Wall,
          Data_Calc_Unc$Delta_U_Eff_Unc_Wall_01 / Data_Calc_Unc$U_Effective_Wall_01
      )
  # <GO13> | U_eff_Wall_01 | related to U_eff | Real
  Data_Calc_Unc$RelativeUncertainty_U_eff_Wall_02 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_Unc$Code_TypeInput_Envelope_ThermalTransmittance, "-") == "Manual",
          Data_Calc_Unc$RelativeUncertainty_U_Input_Wall,
          Data_Calc_Unc$Delta_U_Eff_Unc_Wall_02 / Data_Calc_Unc$U_Effective_Wall_02
      ) # <GP13> | U_eff_Wall_02 | related to U_eff | Real
  Data_Calc_Unc$RelativeUncertainty_U_eff_Wall_03 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_Unc$Code_TypeInput_Envelope_ThermalTransmittance, "-") == "Manual",
          Data_Calc_Unc$RelativeUncertainty_U_Input_Wall,
          Data_Calc_Unc$Delta_U_Eff_Unc_Wall_03 / Data_Calc_Unc$U_Effective_Wall_03
      ) # <GQ13> | U_eff_Wall_03 | related to U_eff | Real
  Data_Calc_Unc$RelativeUncertainty_U_eff_Floor_01 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_Unc$Code_TypeInput_Envelope_ThermalTransmittance, "-") == "Manual",
          Data_Calc_Unc$RelativeUncertainty_U_Input_Bottom,
          Data_Calc_Unc$Delta_U_Eff_Unc_Floor_01 / Data_Calc_Unc$U_Effective_Floor_01
      ) # <GR13> | U_eff_Floor_01 | related to U_eff | Real
  Data_Calc_Unc$RelativeUncertainty_U_eff_Floor_02 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_Unc$Code_TypeInput_Envelope_ThermalTransmittance, "-") == "Manual",
          Data_Calc_Unc$RelativeUncertainty_U_Input_Bottom,
          Data_Calc_Unc$Delta_U_Eff_Unc_Floor_02 / Data_Calc_Unc$U_Effective_Floor_02
      ) # <GS13> | U_eff_Floor_02 | related to U_eff | Real
  Data_Calc_Unc$RelativeUncertainty_U_eff_Window_01 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_Unc$Code_TypeInput_Envelope_ThermalTransmittance, "-") == "Manual",
          Data_Calc_Unc$RelativeUncertainty_U_Input_Window,
          Data_Calc_Unc$RelativeUncertainty_U_WindowType1
      ) # <GT13> | U_eff_Window_01 | related to U_eff | Real
  Data_Calc_Unc$RelativeUncertainty_U_eff_Window_02 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_Unc$Code_TypeInput_Envelope_ThermalTransmittance, "-") == "Manual",
          Data_Calc_Unc$RelativeUncertainty_U_Input_Window,
          Data_Calc_Unc$RelativeUncertainty_U_WindowType2
      ) # <GU13> | U_eff_Window_02 | related to U_eff | Real
  Data_Calc_Unc$RelativeUncertainty_U_eff_Door_01 <-
      ifelse (
          AuxFunctions::Replace_NA (Data_Calc_Unc$Code_TypeInput_Envelope_ThermalTransmittance, "-") == "Manual",
          Data_Calc_Unc$RelativeUncertainty_U_Input_Window,
          Data_Calc_Unc$RelativeUncertainty_U_WindowType1
      ) # <GV13> | U_eff_Door_01 | related to U_eff | Real


  ###################################################################################X
  ## . Resulting uncertainty of heat transmission losses   -----

  Data_Calc_Unc$Delta_H_Transmission <-
      sqrt (
          (Data_Calc_Unc$RelativeUncertainty_U_eff_Roof_01   * Data_Calc_Unc$H_Transmission_Roof_01)^2 +
              (Data_Calc_Unc$RelativeUncertainty_U_eff_Roof_02   * Data_Calc_Unc$H_Transmission_Roof_02)^2 +
              (Data_Calc_Unc$RelativeUncertainty_U_eff_Wall_01   * Data_Calc_Unc$H_Transmission_Wall_01)^2 +
              (Data_Calc_Unc$RelativeUncertainty_U_eff_Wall_02   * Data_Calc_Unc$H_Transmission_Wall_02)^2 +
              (Data_Calc_Unc$RelativeUncertainty_U_eff_Wall_03   * Data_Calc_Unc$H_Transmission_Wall_03)^2 +
              (Data_Calc_Unc$RelativeUncertainty_U_eff_Floor_01  * Data_Calc_Unc$H_Transmission_Floor_01)^2 +
              (Data_Calc_Unc$RelativeUncertainty_U_eff_Floor_02  * Data_Calc_Unc$H_Transmission_Floor_02)^2 +
              (Data_Calc_Unc$RelativeUncertainty_U_eff_Window_01 * Data_Calc_Unc$H_Transmission_Window_01)^2 +
              (Data_Calc_Unc$RelativeUncertainty_U_eff_Window_02 * Data_Calc_Unc$H_Transmission_Window_02)^2 +
              (Data_Calc_Unc$RelativeUncertainty_U_eff_Door_01   * Data_Calc_Unc$H_Transmission_Door_01)^2 +
              (Data_Calc_Unc$AbsoluteUncertainty_DeltaU_ThermalBridging * Data_Calc_Unc$A_Calc_Env_Sum)^2
      )
  # sqrt(
      #     SUMPRODUCT(
      #         Data_Calc_Unc$RelativeUncertainty_U_eff_Roof_01:Data_Calc_Unc$RelativeUncertainty_U_eff_Door_01,
      #         Data_Calc_Unc$H_Transmission_Roof_01:Data_Calc_Unc$H_Transmission_Door_01,
      #         Data_Calc_Unc$RelativeUncertainty_U_eff_Roof_01:Data_Calc_Unc$RelativeUncertainty_U_eff_Door_01,
      #         Data_Calc_Unc$H_Transmission_Roof_01:Data_Calc_Unc$H_Transmission_Door_01
      #     ) + (
      #         Data_Calc_Unc$AbsoluteUncertainty_DeltaU_ThermalBridging * Data_Calc_Unc$A_Calc_Env_Sum
      #     ) ^ 2
      #)
  # <GW13>

  Data_Calc_Unc$Delta_h_tr <-
      Data_Calc_Unc$Delta_H_Transmission / Data_Calc_Unc$A_C_Ref # <GX13>

  # Data_Calc_Unc$Code_Uncertainty_n_Air_HeatLosses <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_n_Air_HeatLosses'
  #         ),
  #
  #     ) # <GY13> | n_Air_HeatLosses | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_n_Air_HeatLosses | 1599
  # Data_Calc_Unc$AbsoluteUncertainty_n_Air_HeatLosses <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'AbsoluteUncertainty_n_Air_HeatLosses'
  #         ),
  #
  #     ) # <GZ13> | n_Air_HeatLosses | [EnergyProfile.xlsm]Data.Out.TABULA | Real | AbsoluteUncertainty_n_Air_HeatLosses | 1600

  ###################################################################################X
  ## . Uncertainty of utilisation input quantities  -----

  Data_Calc_Unc$RelativeUncertainty_n_Air_Heatlosses <-
      Data_Calc_Unc$AbsoluteUncertainty_n_Air_HeatLosses / Data_Calc_Unc$n_air_use # <HA13> | n_Air_Use | related to n_air_use | Calc.Demo.Uncertainty | Real

  Data_Calc_Unc$Code_Uncertainty_theta_i_User <-
      Data_Calc_Unc$Code_Uncertainty_theta_i
   # <HB13> | InternalTemperature | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_theta_i | 1601

  Data_Calc_Unc$AbsoluteUncertainty_theta_i_User <-
      Data_Calc_Unc$AbsoluteUncertainty_theta_i
  # <HC13> | InternalTemperature | [EnergyProfile.xlsm]Data.Out.TABULA | Real | AbsoluteUncertainty_theta_i | 1602

  Data_Calc_Unc$RelativeUncertainty_theta_i <-
      Data_Calc_Unc$AbsoluteUncertainty_theta_i_User /
      (Data_Calc_Unc$theta_i_calc - Data_Calc_Unc$theta_e) # <HD13> | InternalTemperature | related to temperature difference relevant for heat losses | Calc.Demo.Uncertainty | Real

  # Data_Calc_Unc$Code_Uncertainty_HDD_Climate <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_HDD_Climate'
  #         ),
  #
  #     ) # <HE13> | HDD_Climate | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_HDD_Climate | 1605

  # Data_Calc_Unc$Code_Uncertainty_A_Aperture_PassiveSolar_EquivalentSouth <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_A_Aperture_PassiveSolar_EquivalentSouth'
  #         ),
  #
  #     ) # <HF13> | A_Aperture_PassiveSolar_EquivalentSouth | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_A_Aperture_PassiveSolar_EquivalentSouth | 1607
  # Data_Calc_Unc$Code_Uncertainty_I_Sol <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_I_Sol'
  #         ),
  #
  #     ) # <HG13> | I_Sol | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_I_Sol | 1606
  # Data_Calc_Unc$Code_Uncertainty_phi_int <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_phi_int'
  #         ),
  #
  #     ) # <HH13> | phi_int | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_phi_int | 1608
  # Data_Calc_Unc$Code_Uncertainty_eta_ve_rec <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_eta_ve_rec'
  #         ),
  #
  #     ) # <HI13> | eta_ve_rec | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_eta_ve_rec | 1609
  # Data_Calc_Unc$Code_Uncertainty_q_w_nd <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_q_w_nd'
  #         ),
  #
  #     ) # <HJ13> | q_w_nd | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_q_w_nd | 1610
  # Data_Calc_Unc$Code_Uncertainty_e_SysH <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_e_SysH'
  #         ),
  #
  #     ) # <HK13> | e_SysH | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_e_SysH | 1611
  # Data_Calc_Unc$Code_Uncertainty_e_SysW <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'Code_Uncertainty_e_SysW'
  #         ),
  #
  #     ) # <HL13> | e_SysW | [EnergyProfile.xlsm]Data.Out.TABULA | VarChar | Code_Uncertainty_e_SysW | 1612

  # Data_Calc_Unc$RelativeUncertainty_HDD_Climate <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_HDD_Climate'
  #         ),
  #
  #     ) # <HM13> | HDD_Climate | related to total heat losses | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_HDD_Climate | 1613
  # Data_Calc_Unc$RelativeUncertainty_Aperture_PassiveSolar <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_Aperture_PassiveSolar'
  #         ),
  #
  #     ) # <HN13> | A_Aperture_PassiveSolar_EquivalentSouth | related to solar heat load during heating season | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_Aperture_PassiveSolar | 1614
  # Data_Calc_Unc$RelativeUncertainty_SolarRadiation <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_SolarRadiation'
  #         ),
  #
  #     ) # <HO13> | I_Sol | related to solar heat load during heating season | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_SolarRadiation | 1615
  # Data_Calc_Unc$RelativeUncertainty_phi_int <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_phi_int'
  #         ),
  #
  #     ) # <HP13> | phi_int | related to internal heat load during heating season | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_phi_int | 1616
  # Data_Calc_Unc$RelativeUncertainty_eta_ve_rec <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_eta_ve_rec'
  #         ),
  #
  #     ) # <HQ13> | eta_ve_rec | related to recovered heat loss | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_eta_ve_rec | 1617
  # Data_Calc_Unc$RelativeUncertainty_q_w_nd <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_q_w_nd'
  #         ),
  #
  #     ) # <HR13> | q_w_nd | related to respective quantity | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_q_w_nd | 1618
  # Data_Calc_Unc$RelativeUncertainty_e_SysH <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_e_SysH'
  #         ),
  #
  #     ) # <HS13> | e_SysH | related to the respective energy expenditure factor | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_e_SysH | 1619
  # Data_Calc_Unc$RelativeUncertainty_e_SysW <-
  #     AuxFunctions::Replace_NA (
  #         Value_ParTab (
  #             '[EnergyProfile.xlsm]Data.Out.TABULA',
  #             Data_Calc_Unc$Index_Row_SheetEnergyProfile,
  #             'RelativeUncertainty_e_SysW'
  #         ),
  #
  #     ) # <HT13> | e_SysW | related to the respective energy expenditure factor | [EnergyProfile.xlsm]Data.Out.TABULA | Real | RelativeUncertainty_e_SysW | 1620

  Data_Calc_Unc$A_Aperture_PassiveSolar_EquivalentSouth <-
      Data_Calc_Unc$A_C_Ref * Data_Calc_Unc$q_sol / Data_Calc_Unc$I_Sol_HD_South # <HU13> | Equivalent South aperture area of windows, fictive South oriented area receiving the same amount of solar radiation as is actually coming through the windows in the heating season (solar heat load during heating season divided by solar irradation on 1 m² vertical South oriented area during heating season); considering reduction of solar transmission by window frame, reflexion, absorption, non-optimal orientation (deviation from vertical South) and shading | m² | Real

  #.---------------------------------------------------------------------------------------------------


  ###################################################################################X
  ##   Determine uncertainty of the energy need for heating caused by uncertainty of single quantities  -----
  ###################################################################################X

  Data_Calc_Unc$Delta_q_h_nd_Unc_A_Envelope <-
      abs (Data_Calc_Unc$q_ht_tr * Data_Calc_Unc$RelativeUncertainty_A_Envelope) # <HV13> | Uncertainty of heat need | Caused by the uncertainty of envelope surface | kWh/(m²a) | Real

  Data_Calc_Unc$Delta_q_h_nd_Unc_Roof_01 <-
      Data_Calc_Unc$RelativeUncertainty_U_eff_Roof_01 * Data_Calc_Unc$H_Transmission_Roof_01 /
      (Data_Calc_Unc$h_Transmission * Data_Calc_Unc$A_C_Ref) *
      Data_Calc_Unc$q_ht_tr
  # <HW13> | Uncertainty of heat need caused by the uncertainty of U-value  | Delta_q_h_nd_Unc | Roof_01 | kWh/(m²a) | Real
  Data_Calc_Unc$Delta_q_h_nd_Unc_Roof_02 <-
      Data_Calc_Unc$RelativeUncertainty_U_eff_Roof_02 * Data_Calc_Unc$H_Transmission_Roof_02 /
      (Data_Calc_Unc$h_Transmission * Data_Calc_Unc$A_C_Ref) *
      Data_Calc_Unc$q_ht_tr
  # <HX13> | Uncertainty of heat need caused by the uncertainty of U-value  | Delta_q_h_nd_Unc | Roof_02
  Data_Calc_Unc$Delta_q_h_nd_Unc_Wall_01 <-
      Data_Calc_Unc$RelativeUncertainty_U_eff_Wall_01 * Data_Calc_Unc$H_Transmission_Wall_01 /
      (Data_Calc_Unc$h_Transmission * Data_Calc_Unc$A_C_Ref) *
      Data_Calc_Unc$q_ht_tr
  # <HY13> | Uncertainty of heat need caused by the uncertainty of U-value  | Delta_q_h_nd_Unc | Wall_01
  Data_Calc_Unc$Delta_q_h_nd_Unc_Wall_02 <-
      Data_Calc_Unc$RelativeUncertainty_U_eff_Wall_02 * Data_Calc_Unc$H_Transmission_Wall_02 /
      (Data_Calc_Unc$h_Transmission * Data_Calc_Unc$A_C_Ref) *
      Data_Calc_Unc$q_ht_tr
  # <HZ13> | Uncertainty of heat need caused by the uncertainty of U-value  | Delta_q_h_nd_Unc | Wall_02
  Data_Calc_Unc$Delta_q_h_nd_Unc_Wall_03 <-
      Data_Calc_Unc$RelativeUncertainty_U_eff_Wall_03 * Data_Calc_Unc$H_Transmission_Wall_03 /
      (Data_Calc_Unc$h_Transmission * Data_Calc_Unc$A_C_Ref) *
      Data_Calc_Unc$q_ht_tr
  # <IA13> | Uncertainty of heat need caused by the uncertainty of U-value  | Delta_q_h_nd_Unc | Wall_03
  Data_Calc_Unc$Delta_q_h_nd_Unc_Floor_01 <-
      Data_Calc_Unc$RelativeUncertainty_U_eff_Floor_01 * Data_Calc_Unc$H_Transmission_Floor_01 /
      (Data_Calc_Unc$h_Transmission * Data_Calc_Unc$A_C_Ref) *
      Data_Calc_Unc$q_ht_tr
  # <IB13> | Uncertainty of heat need caused by the uncertainty of U-value  | Delta_q_h_nd_Unc | Floor_01
  Data_Calc_Unc$Delta_q_h_nd_Unc_Floor_02 <-
      Data_Calc_Unc$RelativeUncertainty_U_eff_Floor_02 * Data_Calc_Unc$H_Transmission_Floor_02 /
      (Data_Calc_Unc$h_Transmission * Data_Calc_Unc$A_C_Ref) *
      Data_Calc_Unc$q_ht_tr
  # <IC13> | Uncertainty of heat need caused by the uncertainty of U-value  | Delta_q_h_nd_Unc | Floor_02
  Data_Calc_Unc$Delta_q_h_nd_Unc_Window_01 <-
      Data_Calc_Unc$RelativeUncertainty_U_eff_Window_01 * Data_Calc_Unc$H_Transmission_Window_01 /
      (Data_Calc_Unc$h_Transmission * Data_Calc_Unc$A_C_Ref) *
      Data_Calc_Unc$q_ht_tr
  # <ID13> | Uncertainty of heat need caused by the uncertainty of U-value  | Delta_q_h_nd_Unc | Window_01
  Data_Calc_Unc$Delta_q_h_nd_Unc_Window_02 <-
      Data_Calc_Unc$RelativeUncertainty_U_eff_Window_02 * Data_Calc_Unc$H_Transmission_Window_02 /
      (Data_Calc_Unc$h_Transmission * Data_Calc_Unc$A_C_Ref) *
      Data_Calc_Unc$q_ht_tr
  # <IE13> | Uncertainty of heat need caused by the uncertainty of U-value  | Delta_q_h_nd_Unc | Window_02
  Data_Calc_Unc$Delta_q_h_nd_Unc_Door_01 <-
      Data_Calc_Unc$RelativeUncertainty_U_eff_Door_01 * Data_Calc_Unc$H_Transmission_Door_01 /
      (Data_Calc_Unc$h_Transmission * Data_Calc_Unc$A_C_Ref) *
      Data_Calc_Unc$q_ht_tr
  # <IF13> | Uncertainty of heat need caused by the uncertainty of U-value  | Delta_q_h_nd_Unc | Door_01

  Data_Calc_Unc$Delta_q_h_nd_Unc_DeltaU_ThermalBridging <-
      abs (Data_Calc_Unc$q_ht_tr * Data_Calc_Unc$RelativeUncertainty_DeltaU_ThermalBridging)
  # <IG13> | Uncertainty of heat need | Caused by the uncertainty of thermal bridging | kWh/(m²a) | Real

  Data_Calc_Unc$Delta_q_h_nd_Unc_n_air <-
    AuxFunctions::Replace_NA (
      abs ((Data_Calc_Unc$q_ht_ve < 1000) * Data_Calc_Unc$q_ht_ve *
             Data_Calc_Unc$RelativeUncertainty_n_Air_Heatlosses),
      0
    )
  # <IH13> | Uncertainty of heat need | Caused by the uncertainty of air exchange | kWh/(m²a) | Real


  Data_Calc_Unc$Delta_q_h_nd_Unc_theta_i <-
    AuxFunctions::Replace_NA (
      abs (
        (Data_Calc_Unc$q_ht_tr + (Data_Calc_Unc$q_ht_ve < 1000) * Data_Calc_Unc$q_ht_ve) *
          Data_Calc_Unc$RelativeUncertainty_theta_i
      ),
      0
    )
  # <II13> | Uncertainty of heat need | Caused by the uncertainty of internal temperature | kWh/(m²a) | Real



  # 2023-01-26: Concept and formula changed; reduction factor multi-dwelling not used any more (too optimistic since the uncertainty of modelling the average value is not considered); a better way is to include a differentiation between SFH and MFH in the uncertainty classification
  #
  # Data_Calc_Unc$Delta_q_h_nd_Unc_n_air <-
  #     AuxFunctions::Replace_NA (
  #         abs ((Data_Calc_Unc$q_ht_ve < 1000) * Data_Calc_Unc$q_ht_ve *
  #                  Data_Calc_Unc$RelativeUncertainty_n_Air_Heatlosses *
  #                  Data_Calc_Unc$f_Reduction_VariationUtilisation_MultiDwelling),
  #         0
  #     )
  # # <IH13> | Uncertainty of heat need | Caused by the uncertainty of air exchange | kWh/(m²a) | Real
  #
  # Data_Calc_Unc$Delta_q_h_nd_Unc_theta_i <-
  #     AuxFunctions::Replace_NA (
  #         abs (
  #             (Data_Calc_Unc$q_ht_tr + (Data_Calc_Unc$q_ht_ve < 1000) * Data_Calc_Unc$q_ht_ve) *
  #                 Data_Calc_Unc$RelativeUncertainty_theta_i *
  #             Data_Calc_Unc$f_Reduction_VariationUtilisation_MultiDwelling
  #         ),
  #         0
  #     )
  # # <II13> | Uncertainty of heat need | Caused by the uncertainty of internal temperature | kWh/(m²a) | Real

  Data_Calc_Unc$Delta_q_h_nd_Unc_F_HDD <-
      AuxFunctions::Replace_NA (abs (
          (Data_Calc_Unc$q_ht_tr + (Data_Calc_Unc$q_ht_ve < 1000) * Data_Calc_Unc$q_ht_ve) *
              Data_Calc_Unc$RelativeUncertainty_HDD_Climate),
          0)
  # <IJ13> | Uncertainty of heat need | Caused by the uncertainty of external temperature during heating season (related to heating degree days HDD) | kWh/(m²a) | Real

  Data_Calc_Unc$Delta_q_h_nd_Unc_A_Aperture_PassiveSolar_EquivalentSouth <-
      abs (Data_Calc_Unc$q_sol * Data_Calc_Unc$RelativeUncertainty_Aperture_PassiveSolar)
  # <IK13> | Uncertainty of heat need | Caused by the uncertainty of reduction of solar gains by window frame, reflexion, absorption, non-optimal orientation (deviation from vertical South) and shading | kWh/(m²a) | Real

  Data_Calc_Unc$Delta_q_h_nd_Unc_I_Sol <-
      abs (Data_Calc_Unc$q_sol * Data_Calc_Unc$RelativeUncertainty_SolarRadiation)
  # <IL13> | Uncertainty of heat need | Caused by the uncertainty of solar global radiation in the heating period of the considered year | kWh/(m²a) | Real


  Data_Calc_Unc$Delta_q_h_nd_Unc_phi_int <-
    abs ((Data_Calc_Unc$q_int > 0) * Data_Calc_Unc$q_int *
           Data_Calc_Unc$RelativeUncertainty_phi_int)
  # <IM13> | Uncertainty of heat need | Caused by the uncertainty of internal heat loads | kWh/(m²a) | Real
  # 2023-01-26: Concept and formula changed; reduction factor multi-dwelling not used any more (too optimistic since the uncertainty of modelling the average value is not considered); a better way is to include a differentiation between SFH and MFH in the uncertainty classification

  # Data_Calc_Unc$Delta_q_h_nd_Unc_phi_int <-
  #     abs ((Data_Calc_Unc$q_int > 0) * Data_Calc_Unc$q_int *
  #              Data_Calc_Unc$RelativeUncertainty_phi_int *
  #              Data_Calc_Unc$f_Reduction_VariationUtilisation_MultiDwelling)
  # <IM13> | Uncertainty of heat need | Caused by the uncertainty of internal heat loads | kWh/(m²a) | Real



  #.---------------------------------------------------------------------------------------------------


  ###################################################################################X
  ##  Resulting uncertainty of calculated energy use (heating and DHW)   -----
  ###################################################################################X

  Data_Calc_Unc$Uncertainty_q_h_nd <-
      AuxFunctions::Replace_NA (
          sqrt (
              Data_Calc_Unc$Delta_q_h_nd_Unc_A_Envelope ^ 2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_Roof_01 ^ 2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_Roof_02 ^ 2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_Wall_01 ^ 2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_Wall_02 ^ 2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_Wall_03 ^ 2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_Floor_01 ^ 2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_Floor_02 ^ 2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_Window_01 ^ 2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_Window_02 ^ 2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_Door_01 ^ 2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_DeltaU_ThermalBridging ^ 2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_n_air ^ 2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_theta_i ^ 2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_F_HDD ^ 2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_A_Aperture_PassiveSolar_EquivalentSouth ^
                  2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_I_Sol ^ 2 +
                  Data_Calc_Unc$Delta_q_h_nd_Unc_phi_int ^ 2
          )
      , 0)
  # <IN13> | Uncertainty of heat need | Energy need for heating | kWh/(m²a) | Real

  Data_Calc_Unc$Uncertainty_q_w_nd <-
      abs (
          Data_Calc_Unc$q_w_nd * Data_Calc_Unc$RelativeUncertainty_q_w_nd
      )

  # 2022-04-22: Concept and formula changed; reduction factor multi-dwelling not used any more for DHW heat need (uncertainty for MFH too optimistic, since the m² per person may differ from average in the building stock, depending on apartment size, location of the building, etc.).
  # Data_Calc_Unc$Uncertainty_q_w_nd <-
  #   abs (
  #     Data_Calc_Unc$q_w_nd * Data_Calc_Unc$RelativeUncertainty_q_w_nd * Data_Calc_Unc$f_Reduction_VariationUtilisation_MultiDwelling
  #   )

  # <IO13> | Uncertainty of heat need | Energy need for DHW | kWh/(m²a) | Real


  # 2023-03-17: The next two variables are newly introduced, value to be multiplied by uncertainty of heat need to get the uncertainty of delivered energy. Before the total expenditure factor also including the distribution and storage losses was used, but this was not correct, because the distribution and storage losses are (in first approximation) not affected by variations of heat need.

  Data_Calc_Unc$e_g_h <-
    AuxFunctions::Replace_NA (
      (Data_Calc_Unc$q_del_h_1 +
         Data_Calc_Unc$q_del_h_2 +
         Data_Calc_Unc$q_del_h_3) /
        Data_Calc_Unc$q_g_h_out,
      0)

  Data_Calc_Unc$e_g_w <-
    AuxFunctions::Replace_NA (
      (Data_Calc_Unc$q_del_w_1 +
         Data_Calc_Unc$q_del_w_2 +
         Data_Calc_Unc$q_del_w_3) /
        Data_Calc_Unc$q_g_w_out,
      0)


  Data_Calc_Unc$e_SysH <-
      AuxFunctions::Replace_NA (
          (Data_Calc_Unc$q_del_h_1 +
          Data_Calc_Unc$q_del_h_2 +
          Data_Calc_Unc$q_del_h_3) /
              Data_Calc_Unc$q_h_nd_eff,
          0)
  # <IP13> | Simplified energy expenditure factor heating system | simplified = not differentiating by energy carrier | Real

  Data_Calc_Unc$e_SysW <-
      AuxFunctions::Replace_NA (
          (Data_Calc_Unc$q_del_w_1 +
           Data_Calc_Unc$q_del_w_2 +
           Data_Calc_Unc$q_del_w_3) /
              Data_Calc_Unc$q_w_nd,
          0)
  # <IQ13> | Energy expenditure factor heating system | simplified = not differentiating by energy carrier | Real

  Data_Calc_Unc$Delta_q_del_Unc_q_h_nd <-
      Data_Calc_Unc$Uncertainty_q_h_nd * Data_Calc_Unc$e_g_h
  # <IR13> | Uncertainty of delivered energy (simplified = not differentiating by energy carrier) | Caused by the uncertainty of energy need for heating | kWh/(m²a) | Real

  Data_Calc_Unc$Delta_q_del_Unc_q_w_nd <-
      Data_Calc_Unc$Uncertainty_q_w_nd * Data_Calc_Unc$e_g_w
  # <IS13> | Uncertainty of delivered energy (simplified = not differentiating by energy carrier) | Caused by the uncertainty of DHW heat need | kWh/(m²a) | Real

  Data_Calc_Unc$Delta_q_del_Unc_eta_ve_rec <-
    abs (
      Data_Calc_Unc$q_ve_rec_h_usable *
        Data_Calc_Unc$RelativeUncertainty_eta_ve_rec *
        Data_Calc_Unc$e_g_h
    )
  # <IT13> | Uncertainty of delivered energy (simplified = not differentiating by energy carrier) | Caused by the uncertainty of ventilation heat recovery | kWh/(m²a) | Real

  # 2023-01-27 Concept changed
  # Data_Calc_Unc$Delta_q_del_Unc_eta_ve_rec <-
  #     abs (
  #         Data_Calc_Unc$q_ve_rec_h_usable *
  #             Data_Calc_Unc$RelativeUncertainty_eta_ve_rec *
  #             Data_Calc_Unc$f_Reduction_VariationUtilisation_MultiDwelling *
  #             Data_Calc_Unc$e_SysH
  #     )
  # # <IT13> | Uncertainty of delivered energy (simplified = not differentiating by energy carrier) | Caused by the uncertainty of ventilation heat recovery | kWh/(m²a) | Real



  Data_Calc_Unc$Delta_q_del_Unc_e_SysH <-
      abs (Data_Calc_Unc$q_h_nd_eff *
               Data_Calc_Unc$RelativeUncertainty_e_SysH *
               Data_Calc_Unc$e_SysH
           )
  # <IU13> | Uncertainty of delivered energy (simplified = not differentiating by energy carrier) | Caused by the uncertainty of the energy performance of the heating system | kWh/(m²a) | Real

  Data_Calc_Unc$Delta_q_del_Unc_e_SysW <-
      abs (Data_Calc_Unc$q_w_nd *
               Data_Calc_Unc$RelativeUncertainty_e_SysW *
               Data_Calc_Unc$e_SysW
           )
  # <IV13> | Uncertainty of delivered energy (simplified = not differentiating by energy carrier) | Caused by the uncertainty of the DHW system | kWh/(m²a) | Real

  Data_Calc_Unc$Uncertainty_q_del_h <-
      sqrt(
          Data_Calc_Unc$Delta_q_del_Unc_q_h_nd ^ 2 +
              Data_Calc_Unc$Delta_q_del_Unc_eta_ve_rec ^ 2 +
              Data_Calc_Unc$Delta_q_del_Unc_e_SysH ^ 2
      )
  # <IW13> | Uncertainty of delivered energy (simplified = not differentiating by energy carrier) | Caused by the uncertainties of the energy need for heating and the energy performance of the heating system | kWh/(m²a) | Real

  Data_Calc_Unc$Uncertainty_q_del_w <-
      sqrt(Data_Calc_Unc$Delta_q_del_Unc_q_w_nd ^ 2 +
               Data_Calc_Unc$Delta_q_del_Unc_e_SysW ^ 2
           )
  # <IX13> | Uncertainty of delivered energy (simplified = not differentiating by energy carrier) | Caused by the uncertainties of the DHW heat need and the energy performance of the DHW heat supply system | kWh/(m²a) | Real

  Data_Calc_Unc$Uncertainty_q_del <-
      sqrt(
          Data_Calc_Unc$Uncertainty_q_del_h ^ 2 +
              Data_Calc_Unc$Uncertainty_q_del_w ^ 2
          )
  # <IY13> | Uncertainty of delivered energy (simplified = not differentiating by energy carrier) | Caused by the uncertainties of all input quantities for the calculation of the delivered energy demand for heating and DHW | kWh/(m²a) | Real



  #.---------------------------------------------------------------------------------------------------


  ###################################################################################X
  #  4  OUTPUT   -----
  ###################################################################################X

  Data_Calc_Unc$Date_Change <- TimeStampForDataset ()

  return (Data_Calc_Unc)

} # End of function


## End of the function UncEPCalc () -----
#####################################################################################X


# . -----
