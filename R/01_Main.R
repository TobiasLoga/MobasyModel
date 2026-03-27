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

# renv::init()
# renv::status()
# renv::snapshot()
#
# renv::install (packages = "IWUGERMANY/tabuladata")
# renv::install (packages = "TobiasLoga/MobasyBuildingData")
# renv::install (packages = "TobiasLoga/AuxFunctions")
# devtools::install_github ("TobiasLoga/CliDaMon")
# renv::snapshot()


#####################################################################################X
##  Function: EnergyProfile ()   -----

#' The function EnergyProfile () consists of a physical model for calculating the energy demand for heating and domestic hot water.
#' The simple energy performance calculation based on the TABULA method can be optionally supplemented by the following methods:
#' Options
#' (1) Energy Profile calculation: Uses state indicators ("energy profile indicators") to estimate the input data of a physical model and calculate the energy demand for heating and DHW
#' (2) Uncertainty assessment: Supplements an estimation of the uncertainties of the energy performance calculation depending of the origin, level of detail and completeness of input data
#' (3) Local climate data: Supplements an estimation of the actual climate at the building location identified by the postcode and the years to be considered
#' (4) Target/actual comparison: Supplements a comparison of measured energy consumption data with calculated values
#'
#' An overview of the method can be found in:
#' Loga, Tobias; Stein, Britta; Behem, Guillaume: Use of Energy Profile Indicators to Determine
#' the Expected Range of Heating Energy Consumption; Proceedings of the Conference
#' "Central Europe towards Sustainable Building" 2022 (CESB22),
#' 4 to 6 July 2022; Acta Polytechnica CTU Proceedings 38:470–477, 2022
#' https://ojs.cvut.cz/ojs/index.php/APP/article/view/8299/6839
#' https://doi.org/10.14311/APP.2022.38.0470
#'
#' @param DF_BuildingFeatures a dataframe containing datasets for building features to be used in the calculation, only column names identical to the MOBASY input building data structure are considered
#' @param DF_Settings an optional dataframe of 1 row (or optionally of the same row number as the building features) containing additional columns that might be the same for all buildings (e.g. boundary conditions), these can be also defined by building
#' @param ID_BuildingData_Template an optional character string indicating which dataset of the data package MobasyBuildingData should be used as template (default: "DE.Gen.Template.01"),
#' @param List_BuildingData_Template_Input an optional list of two dataframes ('Data_Input' and 'Data_Output') used as a template (default: NA), if this is NA then the parameter ID_BuildingData_Template is used
#' @param Indicator_Include_ClimateStationValues an indicator 0 or 1 (default = 0) indicating if the script module determining local climate station values should be used
#' @param Indicator_Include_UncertaintyAssessment an indicator 0 or 1 (default = 1) indicating if the script module assessing the calculation uncertainty should be usd
#' @param Indicator_Include_CalcMeterComparison an indicator 0 or 1 (default = 0) indicating if the script module comparing calculated and metered energy performance should be used
#' @return myOutputTables a list of two output dataframes 'Data_Output' (main results in a predefined structure), 'Data_Calc' (values of all temporary variables) and 'DF_Display_Energy' including the most important energy balance indicators
#' @examples
#'
#' ## Define building features
#'
#' To enable an energy performance calculation at least the reference floor area, the number of full storeys and the selection of a heat generator must be provided.
#' If the other indicators are not included average and default values will be used for the calculation.
#' Due to the undefined input (very little knowledgte of the building) the estimated uncertainty of the calculation will be large.
#'
#' DF_BuildingFeatures <-
#'    data.frame (
#'      ID_Dataset                     = c (1001, 1002, 1003),
#'      A_C_Floor_Intake               = c (100, 500, 1000),
#'      n_Storey                       = c (1, 2, 4),
#'      Indicator_Boiler_OilGas        = c (1, 1, 1),
#'      Indicator_Boiler_OilGas_SysH   = c (1, 1, 1),
#'      Indicator_Boiler_OilGas_SysW   = c (1, 1, 1)
#'    )
#'
#' DF_Settings_1 <-
#'   data.frame (
#'     ID_Settings       = c ("mySettings"),
#'     Name_Settings     = c ("MOBASY.Standard"),
#'     Code_BoundaryCond = c ("DE.MOBASY.Development.*"),
#'     Code_Climate      = c ("DE.N")
#'   )
#'
#' DF_Settings_2 <-
#'   data.frame (
#'     ID_Settings       = c (1,2,3),
#'     Name_Settings     = c ("MOBASY.Standard", "TABULA.Flex", "TABULA.MUH"),
#'     Code_BoundaryCond = c ("DE.MOBASY.Development.*", "EU.*", "EU.MUH"),
#'     Code_Climate      = c ("DE.KR12-Mannheim", "DE.N",  "DE.N")
#'   )
#'
#' DF_Settings <- DF_Settings_1
#' #DF_Settings <- DF_Settings_2
#'
#'
#' ## Calculate energy performance (Energy Profile procedure)
#'
#' myOutputTables <-
#'   EnergyProfile (
#'      DF_BuildingFeatures                     = DF_BuildingFeatures,
#'      DF_Settings                             = DF_Settings,
#'      ID_BuildingData_Template                = "DE.Gen.Template.01",
#'      List_BuildingData_Template_Input        = NA,
#'      Indicator_Include_UncertaintyAssessment = 1,
#'      Indicator_Include_ClimateStationValues  = 0,
#'      Indicator_Include_CalcMeterComparison   = 0
#'    )
#'
#' ## Show exemplary result
#'
#' myOutputTables$DF_Display_Energy$q_h_nd
#'
#'
#' ## Show structure and content of the two output dataframes
#'
#' str (myOutputTables$Data_Output)
#' str (myOutputTables$Data_Calc)
#' str (myOutputTables$DF_Display_Energy)
#'
#' View (myOutputTables$Data_Output)
#' View (myOutputTables$Data_Calc)
#' View (myOutputTables$DF_Display_Energy)
#'
#' @export
EnergyProfile <- function (
     DF_BuildingFeatures                     = DF_BuildingFeatures,
     DF_Settings                             = NA,
     ID_BuildingData_Template                = "DE.Gen.Template.01",
     List_BuildingData_Template_Input        = NA,
     Indicator_Include_ClimateStationValues  = 0,
     Indicator_Include_UncertaintyAssessment = 1,
     Indicator_Include_CalcMeterComparison   = 0
) {

  TabulaTables <- GetParameterTables_RDataPackage ()

  if (is.na (List_BuildingData_Template_Input)) {

    List_MOBASY_BuildingDataTables <- GetBuildingData_RDataPackage ()
    #View (MobasyBuildingData::Data_Input)

    DF_Template <- List_MOBASY_BuildingDataTables$Data_Input  [ID_BuildingData_Template, ]
    Data_Output <- List_MOBASY_BuildingDataTables$Data_Output [ID_BuildingData_Template, ]

  } else {

    DF_Template <- List_BuildingData_Template_Input$Data_Input  [1, ]
    Data_Output <- List_BuildingData_Template_Input$Data_Output [1, ]

  }



  n_Dataset <- nrow (DF_BuildingFeatures)
  n_Col_BuildingFeatures <- ncol (DF_BuildingFeatures)
  i_Col_Features_Use <- which ((colnames (DF_BuildingFeatures)) %in% colnames (DF_Template))

  DF_Template [1:n_Dataset, ] <- DF_Template [1, ]

  Data_Input <- DF_Template

  Data_Input [ , colnames (DF_BuildingFeatures [ , i_Col_Features_Use])] <-
    DF_BuildingFeatures [ ,i_Col_Features_Use]

  ID_Dataset <- DF_BuildingFeatures [ ,1]

  if (is.numeric (ID_Dataset)) {
    ID_Dataset <- AuxFunctions::Format_Integer_LeadingZeros (
      myInteger = ID_Dataset,
      myWidth = nchar (as.character(abs(max (ID_Dataset)))),
      myPrefix = "DS."
    )
  }
  Data_Input [ ,1] <- ID_Dataset
  rownames (Data_Input) <- ID_Dataset



  if (!is.na (DF_Settings)[1]) {

    n_Col_Settings <- ncol (DF_Settings)
    i_Col_Settings_Use <- which ((colnames (DF_Settings)) %in% colnames (Data_Input))

    Data_Input [ , colnames (DF_Settings [ , i_Col_Settings_Use])] <-
      DF_Settings [ , i_Col_Settings_Use]

    #n_Row_Settings <- nrow (DF_Settings)
    # Data_Input [1:n_Dataset,   colnames (DF_Settings [ , i_Col_Settings_Use])] <-
    #   DF_Settings [1:n_Row_Settings , i_Col_Settings_Use]

  }





  Data_Output [1:n_Dataset, ] <- Data_Output
  Data_Output [ ,1] <- Data_Input [ ,1]
  rownames (Data_Output) <- rownames (Data_Input)

  myBuildingDataTables <-
    list (
      Data_Input  = Data_Input,
      Data_Output = Data_Output
    )

  myOutputTables <-
    MobasyCalc (
      TabulaTables                            = TabulaTables,
      myBuildingDataTables                    = myBuildingDataTables,
      StationClimateTables                    = NA,
      Indicator_Include_ClimateStationValues  = Indicator_Include_ClimateStationValues,
      Indicator_Include_UncertaintyAssessment = Indicator_Include_UncertaintyAssessment,
      Indicator_Include_CalcMeterComparison   = Indicator_Include_CalcMeterComparison
    )


  return (
    myOutputTables
  )


}




#####################################################################################X
##  Function: EnergyProfileCalc ()   -----

#'  Perform Energy Profile calculation - use state indicators to estimate the input data of a physical model and calculate the energy demand for heating and DHW
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
#' @return myOutputTables a list of two output dataframes 'Data_Output' (main results in a predefined structure), 'Data_Calc' (values of all temporary variables) and 'DF_Display_Energy' including the most important energy balance indicators
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
    myBuildingDataTables,
    Indicator_Include_UncertaintyAssessment = 0
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
      Indicator_Include_UncertaintyAssessment = Indicator_Include_UncertaintyAssessment,
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
#' @param Indicator_Include_ClimateStationValues an indicator 0 or 1 (default = 1) indicating if the script module determining local climate station values should be used
#' @param Indicator_Include_UncertaintyAssessment an indicator 0 or 1 (default = 1) indicating if the script module assessing the calculation uncertainty should be usd
#' @param Indicator_Include_CalcMeterComparison an indicator 0 or 1 (default = 1) indicating if the script module comparing calculated and metered energy performance should be used
#' @return myOutputTables a list of two output dataframes 'Data_Output' (main results in a predefined structure), 'Data_Calc' (values of all temporary variables) and 'DF_Display_Energy' including the most important energy balance indicators
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
#' ## Calculate energy performance (MOBASY calculation)
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
    StationClimateTables = NA,
    Indicator_Include_ClimateStationValues  = 1,
    Indicator_Include_UncertaintyAssessment = 1,
    Indicator_Include_CalcMeterComparison   = 1
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
      Indicator_Include_ClimateStationValues  = Indicator_Include_ClimateStationValues,
      Indicator_Include_UncertaintyAssessment = Indicator_Include_UncertaintyAssessment,
      Indicator_Include_CalcMeterComparison   = Indicator_Include_CalcMeterComparison
    )


  return (
    myOutputTables
  )


}





