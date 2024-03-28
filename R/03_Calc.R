library(data.table)
library(dplyr)

#' @export
calc <- function (
    data_input,
    data_output,
    ParTab_EnvArEst, # TL: Name geändert, Bezeichnung vorher: ParTab_EnvAreaEstim,
    ParTab_ConstrYearClass,
    ParTab_Infiltration,
    ParTab_UClassConstr,
    ParTab_InsulationDefault,
    ParTab_MeasurefDefault,
    ParTab_WindowTypePeriods,
    ParTab_ThermalBridging,
    ParTab_BoundaryCond,
    ParTab_System_HG,
    ParTab_System_HS,
    ParTab_System_HD,
    ParTab_System_HA,
    ParTab_System_WG,
    ParTab_System_WS,
    ParTab_System_WD,
    ParTab_System_WA,
    ParTab_System_Vent,
    ParTab_System_PVPanel,
    ParTab_System_PV,
    ParTab_System_SetECAssess,
    ParTab_System_EC,
  ParTab_Meter_EnergyDensity, # TL: hinzugefügt
    ParTab_CalcAdapt,
    ParTab_Climate,
  ParTab_Uncertainty,         # TL: hinzugefügt
    ClimateData_PostCodes  = NA, # only needed when station values are required, see indicator below
    ClimateData_StationTA  = NA, #        "
    ClimateData_TA_HD      = NA, #        "
    ClimateData_Sol        = NA, #        "
    ParTab_SolOrientEst    = NA, #        "
    Indicator_Include_ClimateStationValues  = 0,  # TL: hinzugefügt
    Indicator_Include_UncertaintyAssessment = 0,  # TL: hinzugefügt
    Indicator_Include_CalcMeterComparison   = 0   # TL: hinzugefügt
    # n_Dataset = 1  entfällt / Anmerkung TL: Die Anzahl der Datensätze muss nicht mehr
    # übergeben werden, die Zahl wird jeweils innerhalb der Funktionen bestimmt
) {
        # 1
        data_calc <- EnvArEst (
          myInputData = data_input,
          myCalcData = data_input,
          ParTab_EnvArEst = ParTab_EnvArEst
        )
        ## vorher:
        # data_calc <- env_area_estimate(
        #     buildingDataInput = data_input,
        #     data_calc = data_input,
        #     partab_envarest = ParTab_EnvAreaEstim
        # )

        # 2
        data_calc <- UValEst (
          myInputData               = data_input,
          myCalcData                = data_calc,
          ParTab_ConstrYearClass    = ParTab_ConstrYearClass,
          ParTab_Infiltration       = ParTab_Infiltration,
          ParTab_UClassConstr       = ParTab_UClassConstr,
          ParTab_InsulationDefault  = ParTab_InsulationDefault,
          ParTab_MeasurefDefault    = ParTab_MeasurefDefault,
          ParTab_WindowTypePeriods  = ParTab_WindowTypePeriods,
          ParTab_ThermalBridging    = ParTab_ThermalBridging
        )
        # Anmerkung TL: n_Dataset wird innerhalb der Funktion bestimmt, muss also nicht mehr übergeben werden.
        ## vorher:
        # data_calc <- u_val_est(
        #     buildingDataInput = data_input,
        #     data_calc = data_calc,
        #     ParTab_ConstrYearClass = ParTab_ConstrYearClass,
        #     ParTab_Infiltration = ParTab_Infiltration,
        #     ParTab_UClassConstr = ParTab_UClassConstr,
        #     ParTab_InsulationDefault = ParTab_InsulationDefault,
        #     ParTab_MeasurefDefault = ParTab_MeasurefDefault,
        #     ParTab_WindowTypePeriods = ParTab_WindowTypePeriods,
        #     ParTab_ThermalBridging = ParTab_ThermalBridging,
        #     n_Dataset = n_Dataset
        # )

        # Anmerkung TL: h_Transmission_Estim_Total ist hier nicht mehr nötig, habe ich am Ende der Funktion UValEst () eingebaut,
        # (die Variable ist umbenannt und heißt h_Transmission_EnvArEst)
        ## vorher:
        # # Global
        # data_calc$h_Transmission_Estim_Total <-
        # (data_calc$b_Transmission_Roof_01   * data_calc$A_Estim_Roof_01    * data_calc$U_Actual_Roof_01  +
        # data_calc$b_Transmission_Roof_02   * data_calc$A_Estim_Roof_02    * data_calc$U_Actual_Roof_02  +
        # data_calc$b_Transmission_Wall_01   * data_calc$A_Estim_Wall_01    * data_calc$U_Actual_Wall_01+
        # data_calc$b_Transmission_Wall_02   * data_calc$A_Estim_Wall_02    * data_calc$U_Actual_Wall_02 +
        # data_calc$b_Transmission_Wall_03   * data_calc$A_Estim_Wall_03    * data_calc$U_Actual_Wall_03 +
        # data_calc$b_Transmission_Floor_01  * data_calc$A_Estim_Floor_01   * data_calc$U_Actual_Floor_01 +
        # data_calc$b_Transmission_Floor_02  * data_calc$A_Estim_Floor_02   * data_calc$U_Actual_Floor_02 +
        #                                         data_calc$A_Estim_Window_01  * data_calc$U_Actual_Window_01 +
        #                                         data_calc$A_Estim_Window_02  * data_calc$U_Actual_Window_02 +
        #                                         data_calc$A_Estim_Door_01    * data_calc$U_Actual_Door_01) /
        #     data_calc$A_C_Ref
        #
        # data_calc$h_Transmission_Estim_Total


        # 3
        data_calc <- UtilOpCond (
          myInputData         = data_input,
          myCalcData          = data_calc,
          ParTab_BoundaryCond = ParTab_BoundaryCond
        )
        ## vorher:
        # data_calc <- util_op_cond(
        #     buildingDataInput = data_input,
        #     data_calc = data_calc,
        #     ParTab_BoundaryCond = ParTab_BoundaryCond
        # )


        # 4
        data_calc <-
          ClimateLibValues (
            myDataCalc_ClimLib = data_calc,
            myParTab_Climate   = ParTab_Climate
          )
        if (Indicator_Include_ClimateStationValues == 0) {
          data_calc <-
            ClimateForPhysicalModel (
              myDataCalc_ClimatePhysMod = data_calc,
              myCode_ForceClimateType   = "Lib"  # Forces to use lib values for simplification
            )
        } else {
          ## Extended version, enabling the use of climate data specified in the datasets
          ## including local climate
          #
          ## Assign long-term averages of climate stations to variables with suffix "_LTA_Stations"
          data_calc <-
            ClimateStationValues (
              myCode_TypeClimateYear    = "LTA",
              myDataCalc_ClimateStation = data_calc,
              # Tables from  data package: "clidamonger" "Climate Data Monthly Germany"
              myClimateData_PostCodes   = ClimateData_PostCodes,
              myClimateData_StationTA   = ClimateData_StationTA,
              myClimateData_TA_HD       = ClimateData_TA_HD,
              myClimateData_Sol         = ClimateData_Sol,
              myParTab_SolOrientEst     = ParTab_SolOrientEst
            )

          ## Assign climate station values of specific years to variables with suffix "_Stations"
          ## (without "_LTA").
          data_calc <-
            ClimateStationValues (
              myCode_TypeClimateYear    = "Period",
              myDataCalc_ClimateStation = data_calc,
              # Tables from  data package: "clidamonger" "Climate Data Monthly Germany"
              myClimateData_PostCodes   = ClimateData_PostCodes,
              myClimateData_StationTA   = ClimateData_StationTA,
              myClimateData_TA_HD       = ClimateData_TA_HD,
              myClimateData_Sol         = ClimateData_Sol,
              myParTab_SolOrientEst     = ParTab_SolOrientEst
            )
          ## Assign climate station values of origin specified in each dataset
          ## to the variables used for the physical model.
          data_calc <-
            ClimateForPhysicalModel (
              myDataCalc_ClimatePhysMod = data_calc,
              myCode_ForceClimateType   = NA  # Use "Lib" to force the use of lib values
            )
        }

        ## TL vorher:
        # # Simple climate data, national standard values
        # # (Alternative to measured data included in the package “CliDaMonGer”,
        # # that is differentiated by postcode and month, the work to use the detailed measured data is still in progress)
        #
        # # ParTab_Climate              <- Load_Lib_TABULA ("Tab.Climate")
        #
        #
        # data_calc <- altsimpleclim(
        #     buildingDataInput = data_input,
        #     data_calc = data_calc,
        #     ParTab_Climate = ParTab_Climate
        # )

        # 5
        data_calc <- SuSysConf (
          myInputData                   = data_input,
          myCalcData                    = data_calc,
          ParTab_BoundaryCond           = ParTab_BoundaryCond,
          ParTab_System_HG              = ParTab_System_HG,
          ParTab_System_HS              = ParTab_System_HS,
          ParTab_System_HD              = ParTab_System_HD,
          ParTab_System_HA              = ParTab_System_HA,
          ParTab_System_WG              = ParTab_System_WG,
          ParTab_System_WS              = ParTab_System_WS,
          ParTab_System_WD              = ParTab_System_WD,
          ParTab_System_WA              = ParTab_System_WA,
          ParTab_System_H               = ParTab_System_H,
          ParTab_System_W               = ParTab_System_W,
          ParTab_System_Vent            = ParTab_System_Vent,
          ParTab_System_PVPanel         = ParTab_System_PVPanel,
          ParTab_System_PV              = ParTab_System_PV,
          ParTab_System_Coverage        = ParTab_System_Coverage,
          ParTab_System_ElProd          = ParTab_System_ElProd,
          ParTab_System_EC              = ParTab_System_EC,
          ParTab_CalcAdapt              = ParTab_CalcAdapt
        )

        ## vorher:
        # data_calc <- susysconf(
        #     buildingDataInput = data_input,
        #     data_calc = data_calc,
        #     ParTab_System_HG = ParTab_System_HG,
        #     ParTab_System_HS = ParTab_System_HS,
        #     ParTab_System_HD = ParTab_System_HD,
        #     ParTab_System_HA = ParTab_System_HA,
        #     ParTab_System_WG = ParTab_System_WG,
        #     ParTab_System_WS = ParTab_System_WS,
        #     ParTab_System_WD = ParTab_System_WD,
        #     ParTab_System_WA = ParTab_System_WA,
        #     ParTab_System_Vent = ParTab_System_Vent,
        #     ParTab_System_PVPanel = ParTab_System_PVPanel,
        #     ParTab_System_PV = ParTab_System_PV,
        #     ParTab_System_SetECAssess = ParTab_System_SetECAssess,
        #     ParTab_System_EC = ParTab_System_EC,
        #     ParTab_CalcAdapt = ParTab_CalcAdapt,
        #     ParTab_BoundaryCond = ParTab_BoundaryCond
        # )


        # 6
        data_calc <- CalcBuilding (
          myInputData     = data_input,
          myCalcData      = data_calc,
          ParTab_EnvArEst = ParTab_EnvArEst

        )
        ## vorher:
        # data_calc <- calcbuilding(
        #     buildingDataInput = data_input,
        #     data_calc = data_calc,
        #     partab_envarest = ParTab_EnvAreaEstim
        # )


        # 7
        data_calc <- CalcSystem (
          myCalcData = data_calc
        )
        ## vorher:
        # data_calc <- calcsystem(
        #     buildingDataInput = data_input,
        #     data_calc = data_calc,
        #     partab_envarest = ParTab_EnvAreaEstim
        # )


        # 8
        if (Indicator_Include_UncertaintyAssessment == 1) {
          data_calc <- UncEPCalc (
            myInputData        = data_input,
            Data_Calc_Unc      = data_calc,
            ParTab_Uncertainty = ParTab_Uncertainty
          )
        }
        # 2023-07-14 | Anmerkung TL: Wenn das WebTool läuft, können wir schauen,
        # ob wir die Unsicherheitsbewertung mit der Funktion UncEPCalc () aufnehmen können.
        # Könnte aber sein, dass die Berechnung dann zu langsam wird.
        # Daher derzeit erstmal durch den Defaultwert 0 für
        # Indicator_Include_UncertaintyAssessment im Regelfall abgeschaltet.


        # 9
        if (Indicator_Include_CalcMeterComparison == 1) {
          data_calc <-
            CalcMeterComparison (

              # Tables from  data package: "clidamonger" "Climate Data Monthly Germany"
              myClimateData_PostCodes = ClimateData_PostCodes,
              myClimateData_StationTA = ClimateData_StationTA,
              myClimateData_TA_HD     = ClimateData_TA_HD,
              myClimateData_Sol       = ClimateData_Sol,
              myParTab_SolOrientEst         = ParTab_SolOrientEst,
              myParTab_Meter_EnergyDensity  = ParTab_Meter_EnergyDensity,

              myDataInput             = data_input,
              myDataCalc_CMC          = data_calc

            )
        }
        # 2023-07-14 | Anmerkung TL: Wenn das WebTool läuft, können wir schauen,
        # ob wir die Unsicherheitsbewertung mit der Funktion UncEPCalc () aufnehmen können.
        # Könnte aber sein, dass die Berechnung dann zu langsam wird.
        # Daher derzeit erstmal durch den Defaultwert 0 für
        # Indicator_Include_UncertaintyAssessment im Regelfall abgeschaltet.

        output <-
          AssignOutput (
            myDataOut  = data_output,
            myDataCalc = data_calc
          )
        # Anmerkung TL: buildingDataOutput wird nicht mehr als Vorlage für die Ausgabe gebraucht
        # und muss daher auch nicht vorher eingelesen werden. Der Dataframe mit allen
        # Output-Variablen wird in meiner Funktion AssignOutput () erzeugt.
        ## vorher:
        # temp <- buildingDataOutput %>% mutate_all(function(x) NA) %>% slice_head()
        # output <- assignOutput(temp, data_calc)
        #

        return (
          list (
            Data_Output = output,
            Data_Calc   = data_calc)
        )
        # TL: Musste ich ändern, um Zwischenergebnisse für die Überprüfung einsehen zu können
        # vorher:
        # return (output)
}

#' @export
getData <- function() {

    ## TL: wird jetzt direkt aus dem Package "MobasyBuildingData" geladen, siehe unten
    data_input <- MobasyBuildingData::Data_Input  ["Example.01" , ]
    data_output <-MobasyBuildingData::Data_Output ["Example.01" , ]
    # data_input <- system.file("data", "building.input.data.rda", package = "mobasycalc")
    # data_output <- system.file("data", "building.output.data.rda", package = "mobasycalc")
    #
    # load(data_input, verbose = TRUE)
    # load(data_output, verbose = TRUE)


    # Prepare data
    Code_ParTab_EnvAreaEst_ParameterSet = "EU.01"
    ParTab_EnvArEst <- tabuladata::par.envareaestim [tabuladata::par.envareaestim$Code_Par_EnvAreaEstim == Code_ParTab_EnvAreaEst_ParameterSet, ]

    Code_ParTab_U_Class_Constr_National = "MOBASY"
    ParTab_UClassConstr <- tabuladata::u.class.constr [tabuladata::u.class.constr$Code_U_Class_Constr_National == Code_ParTab_U_Class_Constr_National, ]

    Code_ParTab_InsulationDefault = "MOBASY"
    ParTab_InsulationDefault <- tabuladata::insulation.default [tabuladata::insulation.default$Code_d_Insulation_Default_National == Code_ParTab_InsulationDefault, ]

    Code_ParTab_MeasurefDefault = "MOBASY"
    ParTab_MeasurefDefault <- tabuladata::measure.f.default [tabuladata::measure.f.default$Code_f_Measure_National_Basic == Code_ParTab_MeasurefDefault, ]

    Code_ParTab_ConstrYearClass_StatusDataset    <- "Typology"
    Code_ParTab_ConstrYearClass_Country          <- "DE"
    ParTab_ConstrYearClass <-
    tabuladata::constryearclass [(tabuladata::constryearclass$Code_StatusDataset ==
                                Code_ParTab_ConstrYearClass_StatusDataset) &
                                (tabuladata::constryearclass$Code_Country ==
                                    Code_ParTab_ConstrYearClass_Country) &
                                (tabuladata::constryearclass$Number_ConstructionYearClass > 0), ]

    ## Die Zuordnung des Beispielgebäudes erfolg schon oben
    # Assign the first row
    #data_input <- buildingDataInput[1,]
    #data_output <- buildingDataOutput[1,]

    # Strange cleansing
    n_Row_Data_Input <- nrow (data_input)

    # Replace values if input for codes are empty by accident, usually "_NA_" is expected
    for (i_Row in (1:n_Row_Data_Input)) {
    data_input [i_Row,
                which (
                    grepl("Code_", colnames(data_input)) & is.na(data_input[i_Row,])
                    )
                ] <- "_NA_"
    }

    # data_calc <- data_input

    ## TL:wird nicht mehr benötigt, da dies in den einzelnen Funktionen ermittelt wird
    #   n_Dataset <- 1

    return (list(
        input = data_input,
        output = data_output,
        ParTab_EnvArEst = ParTab_EnvArEst,
        # TL: Name geändert, Bezeichnung vorher: ParTab_EnvAreaEstim,
        ParTab_ConstrYearClass = ParTab_ConstrYearClass,
        ParTab_Infiltration = tabuladata::const.infiltration,
        ParTab_UClassConstr = ParTab_UClassConstr,
        ParTab_InsulationDefault = ParTab_InsulationDefault,
        ParTab_MeasurefDefault = ParTab_MeasurefDefault,
        ParTab_WindowTypePeriods = tabuladata::u.windowtype.periods,
        ParTab_ThermalBridging = tabuladata::const.thermalbridging,
        ParTab_BoundaryCond = tabuladata::boundarycond,
        ParTab_System_HG = tabuladata::system.hg,
        ParTab_System_HS = tabuladata::system.hs,
        ParTab_System_HD = tabuladata::system.hd,
        ParTab_System_HA = tabuladata::system.ha,
        ParTab_System_WG = tabuladata::system.wg,
        ParTab_System_WS = tabuladata::system.ws,
        ParTab_System_WD = tabuladata::system.wd,
        ParTab_System_WA = tabuladata::system.wa,
        ParTab_System_Vent = tabuladata::system.vent,
        ParTab_System_PVPanel = tabuladata::system.pvpanel,
        ParTab_System_PV      = tabuladata::system.pv,
        ParTab_System_SetECAssess = tabuladata::system.setecassess,
        ParTab_System_EC      = tabuladata::system.ec,
        ParTab_CalcAdapt      = tabuladata::calcadapt,
        ParTab_Climate        = tabuladata::climate,
        ParTab_Uncertainty    = tabuladata::uncertainty.levels, # TL: hinzugefügt
#        n_Dataset = 1 # entfernt, wird nicht mehr benötigt, da dies in den einzelnen
#        Funktionen ermittelt wird
        ClimateData_PostCodes = clidamonger::tab.stationmapping,
        ClimateData_StationTA = clidamonger::list.station.ta,
        ClimateData_TA_HD     = clidamonger::data.ta.hd,
        ClimateData_Sol       = clidamonger::data.sol,
        ParTab_SolOrientEst   = clidamonger::tab.estim.sol.orient

    ))

}

