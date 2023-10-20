#####################################################################################X
##
##    File name:        "EnergyProfile.R"
##    R project name:   "EnergyProfile-Work.Rproj"
##
##    Script:           Call of functions for Energy Profile and MOBASY calculations
##
##    Projects:         TABULA / EPISCOPE / MOBASY
##
##    Authors:          Tobias Loga / Jens Calisti
##                      t.loga@iwu.de
##                      IWU - Institut Wohnen und Umwelt, Darmstadt / Germany
##
##    Created:          23-03-2020
##    Last changes:     08-09-2023
##
#####################################################################################X

# library (openxlsx)
# library (AuxFunctions)
# library (CliDaMon)





#####################################################################################X
##  Function: EnergyProfileCalc ()   -----

#'  Perform Energy Profile calculation  (MOBASY energy performance calculation without local climate, uncertainties and target/actual comparison)
#'
#' EnergyProfileCalc consists of a physical model for calculating the energy demand for heating and domestic hot water.
#' Energy Profile Indicators or detailed building data may be used as input data.
#' The energy performance is calculated by use of a standard climate.
#' NOT included is the use of local climate by postcode, the calculation of uncertainties
#' and a comparison with measured consumption data (target/actual comparison).
#'
#' An overview of the method can be found in:
#' Loga, Tobias; Stein, Britta; Behem, Guillaume: Use of Energy Profile Indicators to Determine
#' the Expected Range of Heating Energy Consumption; Proceedings of the Conference
#' "Central Europe towards Sustainable Building" 2022 (CESB22),
#' 4 to 6 July 2022; Acta Polytechnica CTU Proceedings 38:470–477, 2022
#' https://ojs.cvut.cz/ojs/index.php/APP/article/view/8299/6839
#' https://doi.org/10.14311/APP.2022.38.0470
#'
#' @param TabulaTables a list of dataframes with parameters used for the calculation
#' @param myBuildingDataTables a list of dataframes including the calculation input data
#' "Data_Input", an empty dataframe "Data_Output" providing the structure for the output,
#' the dataframe "Data_Output_PreCalculated" providing data calculated by the Excel tool
#' (useful for comparison by developers) and the dataframe "Data_Calc" which is used to
#' collect all variables and their values used in the different calculation functions.
#' @return myOutputTables a list of two output dataframes Data_Output (main results in
#' a predefined structure) and Data_Calc (values of all temporary variables)
#' @examples
#'
#' ## Get local parameter tables
#' TabulaTables <- GetParameterTables_LocalExcel ()
#'
#'
#' ## Get local building data
#' # Different options of dataset selection:
#'
#' # (1) Get all datasets from the MOBASY sample
#' myBuildingDataTables <- GetBuildingData_LocalExcel ("MOBASY-Sample")
#'
#' # (2) Get dataset of 1 building (example for webtool)
#' myBuildingDataTables <- GetBuildingData_LocalExcel ("WebTool")
#'
#'
#' ## Calculate energy performance (Energy Profile procedure)
#'
#' myOutputTables <- EnergyProfileCalc (
#'    TabulaTables,
#'    myBuildingDataTables
#'    )
#'
#'
#' ## Show structure and content of the two output dataframes
#'
#' str (myOutputTables$Data_Output)
#' str (myOutputTables$Data_Calc)
#'
#' @export
EnergyProfileCalc <- function (
    TabulaTables,
    myBuildingDataTables
    ) {

  myOutputTables <-
    calc (
      data_input                = myBuildingDataTables$Data_Input,
      data_output               = myBuildingDataTables$Data_Output,
      ParTab_EnvArEst           = TabulaTables$ParTab_EnvArEst,
      ParTab_ConstrYearClass    = TabulaTables$ParTab_ConstrYearClass,
      ParTab_UClassConstr       = TabulaTables$ParTab_UClassConstr,
      ParTab_InsulationDefault  = TabulaTables$ParTab_InsulationDefault,
      ParTab_MeasurefDefault    = TabulaTables$ParTab_MeasurefDefault,
      ParTab_ThermalBridging    = TabulaTables$ParTab_ThermalBridging,
      ParTab_Infiltration       = TabulaTables$ParTab_Infiltration,
      ParTab_WindowTypePeriods  = TabulaTables$ParTab_WindowTypePeriods,
      ParTab_BoundaryCond       = TabulaTables$ParTab_BoundaryCond,
      ParTab_System_HG          = TabulaTables$ParTab_System_HG,
      ParTab_System_HS          = TabulaTables$ParTab_System_HS,
      ParTab_System_HD          = TabulaTables$ParTab_System_HD,
      ParTab_System_HA          = TabulaTables$ParTab_System_HA,
      ParTab_System_WG          = TabulaTables$ParTab_System_WG,
      ParTab_System_WS          = TabulaTables$ParTab_System_WS,
      ParTab_System_WD          = TabulaTables$ParTab_System_WD,
      ParTab_System_WA          = TabulaTables$ParTab_System_WA,
      # ParTab_System_H           = TabulaTables$ParTab_System_H,
      # ParTab_System_W           = TabulaTables$ParTab_System_W,
      ParTab_System_Vent        = TabulaTables$ParTab_System_Vent,
      ParTab_System_PVPanel     = TabulaTables$ParTab_System_PVPanel,
      ParTab_System_PV          = TabulaTables$ParTab_System_PV,
      # ParTab_System_Coverage   = TabulaTables$ParTab_System_Coverage,
      # ParTab_System_ElProd     = TabulaTables$ParTab_System_ElProd,
      ParTab_System_SetECAssess = TabulaTables$ParTab_System_SetECAssess,
      ParTab_System_EC          = TabulaTables$ParTab_System_EC,
    ParTab_Meter_EnergyDensity  = TabulaTables$ParTab_Meter_EnergyDensity,
      ParTab_CalcAdapt          = TabulaTables$ParTab_CalcAdapt,
      ParTab_Climate            = TabulaTables$ParTab_Climate,
      ParTab_Uncertainty        = TabulaTables$ParTab_Uncertainty,
      ClimateData_PostCodes     = NA,
      ClimateData_StationTA     = NA,
      ClimateData_TA_HD         = NA,
      ClimateData_Sol           = NA,
      ParTab_SolOrientEst       = NA,
      Indicator_Include_ClimateStationValues  = 0,
      Indicator_Include_UncertaintyAssessment = 0,
      Indicator_Include_CalcMeterComparison   = 0
    )


  return (
    myOutputTables
  )


}


#####################################################################################X
##  Function: MobasyCalc ()   -----

#'  Perform full MOBASY energy performance calculation  (including local climate, uncertainties and target/actual comparison)
#'
#' MobasyCalc consists of a physical model for calculating the energy demand for heating and domestic hot water.
#' Energy Profile Indicators or detailed building data may be used as input data.
#' The energy performance is calculated by use of German local climate by postcode.
#' The calculation also includes an uncertainty assessment
#' and a comparison with measured consumption data (target/actual comparison).
#' (If a simplified version is needed the function EnergyProfileCalc () can be used, which is a subset of MobasyCalc ()
#'
#' An overview of the method can be found in:
#' Loga, Tobias; Stein, Britta; Behem, Guillaume: Use of Energy Profile Indicators to Determine
#' the Expected Range of Heating Energy Consumption; Proceedings of the Conference
#' "Central Europe towards Sustainable Building" 2022 (CESB22),
#' 4 to 6 July 2022; Acta Polytechnica CTU Proceedings 38:470–477, 2022
#' https://ojs.cvut.cz/ojs/index.php/APP/article/view/8299/6839
#' https://doi.org/10.14311/APP.2022.38.0470
#'
#' @param TabulaTables a list of dataframes with parameters used for the calculation
#' @param myBuildingDataTables a list of dataframes including the calculation input data
#' "Data_Input", an empty dataframe "Data_Output" providing the structure for the output,
#' the dataframe "Data_Output_PreCalculated" providing data calculated by the Excel tool
#' (useful for comparison by developers) and the dataframe "Data_Calc" which is used to
#' collect all variables and their values used in the different calculation functions.
#' @param StationClimateTables a list of dataframes with climate data from local weather stations
#' @return myOutputTables a list of two output dataframes Data_Output (main results in
#' a predefined structure) and Data_Calc (values of all temporary variables)
#' @examples
#'
#' ## Get local parameter tables
#' TabulaTables <- GetParameterTables_LocalExcel ()
#'
#'
#' ## Get data from weather stations
#' StationClimateTables <- GetStationClimate_LocalExcel ()
#'
#'
#' ## Get local building data
#' # Different options of dataset selection:
#'
#' # (1) Load all available datasets from the MOBASY building data table
#' myBuildingDataTables <- GetBuildingData_LocalExcel ()
#'
#' # (2) Load all datasets from the MOBASY sample
#' myBuildingDataTables <- GetBuildingData_LocalExcel ("MOBASY-Sample")
#'
#' # (3) Load dataset of 1 building (example for webtool)
#' myBuildingDataTables <- GetBuildingData_LocalExcel ("WebTool")
#'
#' # (4) Load dataset of the target/actual comparison study performed
#' #     for the two "PassivHausSozialPlus" (PHSP) buildings (2 x 16 variants)
#' myBuildingDataTables <- GetBuildingData_LocalExcel ("ParameterStudy-PHSP-2023")
#'
#' # (5) Load datasets of 6 buildings from a parameter study on uncertainties
#' myBuildingDataTables <- GetBuildingData_LocalExcel ("ParameterStudy-CESB-2022")
#'
#'
#' ## Calculate energy performance (Energy Profile procedure)
#'
#' myOutputTables <- MobasyCalc (
#'    TabulaTables,
#'    myBuildingDataTables,
#'    StationClimateTables
#'    )
#'
#'
#' ## Show structure and content of the two output dataframes
#'
#' str (myOutputTables$Data_Output)
#' str (myOutputTables$Data_Calc)
#'
#' @export
MobasyCalc <- function (
    TabulaTables,
    myBuildingDataTables,
    StationClimateTables = NA
) {

  myOutputTables <-
    calc (
      data_input                = myBuildingDataTables$Data_Input,
      data_output               = myBuildingDataTables$Data_Output,
      ParTab_EnvArEst           = TabulaTables$ParTab_EnvArEst,
      ParTab_ConstrYearClass    = TabulaTables$ParTab_ConstrYearClass,
      ParTab_UClassConstr       = TabulaTables$ParTab_UClassConstr,
      ParTab_InsulationDefault  = TabulaTables$ParTab_InsulationDefault,
      ParTab_MeasurefDefault    = TabulaTables$ParTab_MeasurefDefault,
      ParTab_ThermalBridging    = TabulaTables$ParTab_ThermalBridging,
      ParTab_Infiltration       = TabulaTables$ParTab_Infiltration,
      ParTab_WindowTypePeriods  = TabulaTables$ParTab_WindowTypePeriods,
      ParTab_BoundaryCond       = TabulaTables$ParTab_BoundaryCond,
      ParTab_System_HG          = TabulaTables$ParTab_System_HG,
      ParTab_System_HS          = TabulaTables$ParTab_System_HS,
      ParTab_System_HD          = TabulaTables$ParTab_System_HD,
      ParTab_System_HA          = TabulaTables$ParTab_System_HA,
      ParTab_System_WG          = TabulaTables$ParTab_System_WG,
      ParTab_System_WS          = TabulaTables$ParTab_System_WS,
      ParTab_System_WD          = TabulaTables$ParTab_System_WD,
      ParTab_System_WA          = TabulaTables$ParTab_System_WA,
      # ParTab_System_H           = TabulaTables$ParTab_System_H,
      # ParTab_System_W           = TabulaTables$ParTab_System_W,
      ParTab_System_Vent        = TabulaTables$ParTab_System_Vent,
      ParTab_System_PVPanel     = TabulaTables$ParTab_System_PVPanel,
      ParTab_System_PV          = TabulaTables$ParTab_System_PV,
      # ParTab_System_Coverage   = TabulaTables$ParTab_System_Coverage,
      # ParTab_System_ElProd     = TabulaTables$ParTab_System_ElProd,
      ParTab_System_SetECAssess = TabulaTables$ParTab_System_SetECAssess,
      ParTab_System_EC          = TabulaTables$ParTab_System_EC,
    ParTab_Meter_EnergyDensity  = TabulaTables$ParTab_Meter_EnergyDensity,
      ParTab_CalcAdapt          = TabulaTables$ParTab_CalcAdapt,
      ParTab_Climate            = TabulaTables$ParTab_Climate,
      ParTab_Uncertainty        = TabulaTables$ParTab_Uncertainty,
      ClimateData_PostCodes  = AuxFunctions::Replace_NULL (
        StationClimateTables$ClimateData_PostCodes, NA),
      ClimateData_StationTA  = AuxFunctions::Replace_NULL (
        StationClimateTables$ClimateData_StationTA, NA),
      ClimateData_TA_HD      = AuxFunctions::Replace_NULL (
        StationClimateTables$ClimateData_TA_HD, NA),
      ClimateData_Sol        = AuxFunctions::Replace_NULL (
        StationClimateTables$ClimateData_Sol, NA),
      ParTab_SolOrientEst    = AuxFunctions::Replace_NULL (
        StationClimateTables$ParTab_SolOrientEst, NA),
      Indicator_Include_ClimateStationValues  = 1,
      Indicator_Include_UncertaintyAssessment = 1,
      Indicator_Include_CalcMeterComparison   = 1
    )


  return (
    myOutputTables
  )


}





