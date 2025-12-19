#####################################################################################################X
##
##    File name:        "AuxDataTransfer.R"
##
##    Module of:        "EnergyProfile.R"
##
##    Task:             Auxiliary functions for loading and saving data
##
##    Methods:          Energy Profile monitoring variables (query and model variables)
##                      MOBASY building table (https://www.iwu.de/forschung/energie/mobasy/)
##
##    Project:          MOBASY
##
##    Author:           Tobias Loga (t.loga@iwu.de)
##                      IWU - Institut Wohnen und Umwelt, Darmstadt / Germany
##
##    Created:          23-03-2020
##    Last changes:     05-11-2021
##
#####################################################################################################X





#####################################################################################################X
## Useful information for running the script in RStudio ---------------------------------------------
#####################################################################################################X

#  Shortcuts:
#  <Ctrl>-<Alt>-<B>       Run script from beginning to current line
#  <Ctrl>-<Alt>-<E>       Run script from current line to end
#  <Ctrl>-<Alt>-<R>       Run complete script
#  <Ctrl>-<Enter>         Run current line or selected script range





#. ---------------------------------------------------------------------------------


###################################################################################X
## %xl_JoinStrings% ------------------------------------

# 2025-12-19 pasted here from package AuxFunctions
# Syntax is different when referencing to the package: AuxFunctions::`%xl_JoinStrings%`("A", "B")
# --> not useful because paste0 () could be used as well. So this function works similar to Excel only without package reference.


## %xl_JoinStrings%
#' Concatenate vectors of character strings by row (Excel equivalent operator &)
#'
#' %xl_JoinStrings% concatenates vectors of character strings by row.
#' The function is used to simplify parsing Excel formulas and to apply them to vector variables.
#' Definition of infix operators: https://www.datamentor.io/r-programming/infix-operator/
#'
#' @param myStr1 first vector of character strings.
#' @param myStr2 second vector of character strings.
#'
#' @return A character vector of the concatenated values.
#'
#' @examples
#' temp1 <- c ("cow ", "pig ", "elephant ", "tiger ")
#' temp2 <- c ("eats ", "loves ", "grows ", "has ")
#' temp3 <- c ("grass", "mud", "big", "stripes")
#' temp1 %xl_JoinStrings% temp2 %xl_JoinStrings% temp3
#' # Result: "cow eats grass"     "pig loves mud"      "elephant grows big" "tiger has has "
#'
`%xl_JoinStrings%` <- function (
    myStr1,
    myStr2
) {
  return (
    paste0 (myStr1, myStr2)
  )
}







#. ---------------------------------------------------------------------------------


###################################################################################X
## User-defined functions for data transfer------------------------------------
###################################################################################X


#. ---------------------------------------------------------------------------------


###################################################################################X
## . TabulaDataSourceXLSX::Load_ExcelTable () -----

# 2025-12-19 Note: The original function has been moved to the new package TabulaDataSourceXLSX
# Call: TabulaDataSourceXLSX::Load_ExcelTable ()





#. ---------------------------------------------------------------------------------


###################################################################################X
## . TabulaDataSourceXLSX::ConvertQueryToEnergyProfileInput () -----
###################################################################################X

# 2025-12-19 Note: The original function has been moved to the new package TabulaDataSourceXLSX
# Call: TabulaDataSourceXLSX::ConvertQueryToEnergyProfileInput ()







#. ---------------------------------------------------------------------------------



###################################################################################X
## . TabulaDataSourceXLSX::Load_Settings () -----

# Function: Load script settings

# 2025-12-19 Note: The original function has been moved to the new package TabulaDataSourceXLSX
# Call: TabulaDataSourceXLSX::Load_Settings ()








#. ---------------------------------------------------------------------------------





###################################################################################X
## . TabulaDataSourceXLSX::Load_Lib_TABULA () ----

# Function load TABULA library values from specified Excel table


# 2025-12-19 Note: The original function has been moved to the new package TabulaDataSourceXLSX
# Call: TabulaDataSourceXLSX::Load_Lib_TABULA ()





#. ---------------------------------------------------------------------------------


###################################################################################X
## . Function: Load all TABULA tables with calculation parameters (Excel or R data package)
###################################################################################X

# 2025-12-19 Note: The original function including option to import from Excel has been moved
# to the new package TabulaDataSourceXLSX.
# Call: TabulaDataSourceXLSX::Load_ParameterTables_XLSX_RDA ()

# The following version of the function only loads parameters from RDA files


#' @export
Load_ParameterTables <- function () {

# Load_ParameterTables <- function (
#     mySwitch_LoadLibFromRDataPackage = 1,  # 2025-12-19 changed from
#     myFileName_Lib_TABULA            = "tabula-values.xlsx",
#     mySubDir_Lib_TABULA              = "Input/Lib_TABULA",
#     myAbsolutePath_Lib_TABULA        = "") {

  ## Internal test of the function
  # mySheetName_Lib_TABULA    <- "Tab.ConstrYearClass"
  # myFileName_Lib_TABULA     <- "tabula-values.xlsx"
  # mySubDir_Lib_TABULA       <- "Input/Lib_TABULA"
  # myAbsolutePath_Lib_TABULA <- ""


  mySwitch_LoadLibFromRDataPackage <- 1

  if (mySwitch_LoadLibFromRDataPackage == 0) {

    ## Option 1: Load tables from local Excel file

    # 2025-12-19 this option is now only included in the package TabulaDataSourceXLSX as function Load_ParameterTables_XLSX_RDA ()
    # Now: Do nothing.

    # ParTab_EnvArEst             <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.Par.EnvAreaEstim",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_ConstrYearClass      <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.ConstrYearClass",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_UClassConstr         <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.U.Class.Constr",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_InsulationDefault    <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.Insulation.Default",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_MeasurefDefault      <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.Measure.f.Default",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_ThermalBridging      <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.Const.ThermalBridging",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    #
    # ParTab_Infiltration         <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.Const.Infiltration",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_WindowTypePeriods    <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.U.WindowType.Periods",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_BoundaryCond         <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.BoundaryCond",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_Climate              <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.Climate",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_Uncertainty          <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.Uncertainty.Levels",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_System_HG            <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.System.HG",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_System_HS            <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.System.HS",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_System_HD            <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.System.HD",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_System_HA            <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.System.HA",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_System_WG            <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.System.WG",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_System_WS            <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.System.WS",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_System_WD            <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.System.WD",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_System_WA            <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.System.WA",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_System_H             <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.System.H",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_System_W             <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.System.W",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_System_Vent          <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.System.Vent",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_System_PVPanel       <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.System.PVPanel",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_System_PV            <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.System.PV",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # #ParTab_System_Coverage      <-
    # #  Load_Lib_TABULA (
    # #   mySheetName_Lib_TABULA    = "Tab.System.Coverage") # Currently not used
    # #ParTab_System_ElProd        <-
    # #  Load_Lib_TABULA (
    # #   mySheetName_Lib_TABULA    = "Tab.System.ElProd") # Currently not used
    #
    # ParTab_System_SetECAssess   <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.System.SetECAssess",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_System_EC            <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.System.EC",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_Meter_EnergyDensity            <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.Meter.EnergyDensity",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )
    #
    # ParTab_CalcAdapt            <-
    #   Load_Lib_TABULA (
    #     mySheetName_Lib_TABULA    = "Tab.CalcAdapt",
    #     myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
    #     mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
    #     myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
    #   )

  } else {

    ## Option 2: Load tables from R data package

    ParTab_EnvArEst           <- tabuladata::par.envareaestim
    # TL: Name geändert Bezeichnung vorher: ParTab_EnvAreaEstim
    ParTab_ConstrYearClass    <- tabuladata::constryearclass
    ParTab_Infiltration       <- tabuladata::const.infiltration
    ParTab_UClassConstr       <- tabuladata::u.class.constr
    ParTab_InsulationDefault  <- tabuladata::insulation.default
    ParTab_MeasurefDefault    <- tabuladata::measure.f.default
    ParTab_WindowTypePeriods  <- tabuladata::u.windowtype.periods
    ParTab_ThermalBridging    <- tabuladata::const.thermalbridging
    ParTab_BoundaryCond       <- tabuladata::boundarycond
    ParTab_System_HG          <- tabuladata::system.hg
    ParTab_System_HS          <- tabuladata::system.hs
    ParTab_System_HD          <- tabuladata::system.hd
    ParTab_System_HA          <- tabuladata::system.ha
    ParTab_System_WG          <- tabuladata::system.wg
    ParTab_System_WS          <- tabuladata::system.ws
    ParTab_System_WD          <- tabuladata::system.wd
    ParTab_System_WA          <- tabuladata::system.wa
    ParTab_System_H           <- tabuladata::system.h
    ParTab_System_W           <- tabuladata::system.w
    ParTab_System_Vent        <- tabuladata::system.vent
    ParTab_System_PVPanel     <- tabuladata::system.pvpanel
    ParTab_System_PV          <- tabuladata::system.pv
    ParTab_System_SetECAssess <- tabuladata::system.setecassess
    ParTab_System_EC          <- tabuladata::system.ec
  ParTab_Meter_EnergyDensity    <- tabuladata::meter.energydensity
    ParTab_CalcAdapt          <- tabuladata::calcadapt
    ParTab_Climate            <- tabuladata::climate
    ParTab_Uncertainty        <- tabuladata::uncertainty.levels # TL: hinzugefügt




  } # End if (Load from Excel or R data package)


  ## For some parameter tables: Select specific ranges of datasets

  Code_ParTab_EnvAreaEst_ParameterSet <- "EU.01"
  ParTab_EnvArEst <-
    ParTab_EnvArEst [
      ParTab_EnvArEst$Code_Par_EnvAreaEstim == Code_ParTab_EnvAreaEst_ParameterSet,
      ]

  ## 2025-03-28 removed
  #
  # The filter is not needed, since the script in UValEst() uses the building data input
  # in "Code_U_Class_National" as a filter.
  # Now, more flexibility is needed using other parameters than the MOBASY ones.
  #
  # Code_ParTab_U_Class_Constr_National <- "MOBASY"
  # ParTab_UClassConstr <-
  #   ParTab_UClassConstr [
  #     ParTab_UClassConstr$Code_U_Class_Constr_National == Code_ParTab_U_Class_Constr_National,
  #     ]
  #
  # Code_ParTab_InsulationDefault <- "MOBASY"
  # ParTab_InsulationDefault <-
  #   ParTab_InsulationDefault [
  #     ParTab_InsulationDefault$Code_d_Insulation_Default_National == Code_ParTab_InsulationDefault,
  #     ]
  #
  # Code_ParTab_MeasurefDefault <- "MOBASY"
  # ParTab_MeasurefDefault <-
  #   ParTab_MeasurefDefault [
  #     ParTab_MeasurefDefault$Code_f_Measure_National_Basic == Code_ParTab_MeasurefDefault,
  #     ]

  Code_ParTab_ConstrYearClass_StatusDataset    <- "Typology"
  Code_ParTab_ConstrYearClass_Country          <- "DE"
  ParTab_ConstrYearClass <-
    ParTab_ConstrYearClass [
      (ParTab_ConstrYearClass$Code_StatusDataset == Code_ParTab_ConstrYearClass_StatusDataset) &
        (ParTab_ConstrYearClass$Code_Country == Code_ParTab_ConstrYearClass_Country) &
        (ParTab_ConstrYearClass$Number_ConstructionYearClass > 0),
      ]


  return (
    list (
      ParTab_EnvArEst           = ParTab_EnvArEst,
      ParTab_ConstrYearClass    = ParTab_ConstrYearClass,
      ParTab_UClassConstr       = ParTab_UClassConstr,
      ParTab_InsulationDefault  = ParTab_InsulationDefault,
      ParTab_MeasurefDefault    = ParTab_MeasurefDefault,
      ParTab_ThermalBridging    = ParTab_ThermalBridging,
      ParTab_Infiltration       = ParTab_Infiltration,
      ParTab_WindowTypePeriods  = ParTab_WindowTypePeriods,
      ParTab_BoundaryCond       = ParTab_BoundaryCond,
      ParTab_Climate            = ParTab_Climate,
      ParTab_Uncertainty        = ParTab_Uncertainty,
      ParTab_System_HG          = ParTab_System_HG,
      ParTab_System_HS          = ParTab_System_HS,
      ParTab_System_HD          = ParTab_System_HD,
      ParTab_System_HA          = ParTab_System_HA,
      ParTab_System_WG          = ParTab_System_WG,
      ParTab_System_WS          = ParTab_System_WS,
      ParTab_System_WD          = ParTab_System_WD,
      ParTab_System_WA          = ParTab_System_WA,
      ParTab_System_H           = ParTab_System_H,
      ParTab_System_W           = ParTab_System_W,
      ParTab_System_Vent        = ParTab_System_Vent,
      ParTab_System_PVPanel     = ParTab_System_PVPanel,
      ParTab_System_PV          = ParTab_System_PV,
      #ParTab_System_Coverage   = #ParTab_System_Coverage,
      #ParTab_System_ElProd     = #ParTab_System_ElProd,
      ParTab_System_SetECAssess = ParTab_System_SetECAssess,
      ParTab_System_EC          = ParTab_System_EC,
    ParTab_Meter_EnergyDensity   = ParTab_Meter_EnergyDensity,
      ParTab_CalcAdapt          = ParTab_CalcAdapt
    )
  )


}


#. ---------------------------------------------------------------------------------




###################################################################################X
## . TabulaDataSourceXLSX::GetParameterTables_LocalExcel -----


# 2025-12-19 Note: The original function has been moved to the new package TabulaDataSourceXLSX
# Call: TabulaDataSourceXLSX::GetParameterTables_LocalExcel ()




#. ---------------------------------------------------------------------------------




###################################################################################X
## . Function: GetParameterTables_RDataPackage

#' Get TABULA tables with calculation parameters from R data package
#'
#' GetParameterTables_RDataPackage () loads a data library with parameters
#' for the energy performance calculation from the R data package "tabuladata".
#' The data tables of the package are basically identical to the tables of the workbook
#' "tabula-values.xlsx" from the European projects TABULA and EPISCOPE
#' (Download at: https://episcope.eu/communication/download/)
#' However some tables have been added used by the MOBASY algorithms for
#' target/actual comparison and for uncertainty assessment.
#' In some of the existing tables additional parameter sets (rows) have been added.
#'
#' GetParameterTables_RDataPackage () is a wrapper for the function Load_ParameterTables ()
#' in which arguments are used specifying the data source (local Excel or R data package)
#'
#' @param None
#'
#' @return A List of 28 dataframes
#'
#' @examples
#'
#' ## Load data
#'
#' TabulaTables <-
#'   GetParameterTables_RDataPackage ()
#'
#' ## Show structure and content of some of the dataframes
#' str (TabulaTables$ParTab_InsulationDefault)
#' str (TabulaTables$ParTab_System_HG)
#' str (TabulaTables$ParTab_Uncertainty)
#'
#' @export
GetParameterTables_RDataPackage <- function () {

  TabulaTables <-
    Load_ParameterTables ()
  # Load_ParameterTables (mySwitch_LoadLibFromRDataPackage = 1)

  return (
    TabulaTables
  )


}



#. ---------------------------------------------------------------------------------



###################################################################################X
## . TabulaDataSourceXLSX::Load_StationClimateTables_Excel () -----
## Function: Load tables with station climate data from local workbook


# 2025-12-19 Note: The original function has been moved to the new package TabulaDataSourceXLSX
# Call: TabulaDataSourceXLSX::Load_StationClimateTables_Excel ()




#. ---------------------------------------------------------------------------------





###################################################################################X
## . TabulaDataSourceXLSX::GetStationClimate_LocalExcel () -----


# 2025-12-19 Note: The original function has been moved to the new package TabulaDataSourceXLSX
# Call: TabulaDataSourceXLSX::GetStationClimate_LocalExcel ()




#. ---------------------------------------------------------------------------------



###################################################################################X
## . Function: GetStationClimate_RDataPackage

#' Load tables with station climate data from package "clidamonger"
#'
#' GetStationClimate_RDataPackage () loads all station climate data from
#' the R data package clidamonger.
#'
#' @param None
#'
#' @return StationClimateTables a list of dataframes
#' @examples
#'
#' StationClimateTables <- GetStationClimate_RDataPackage ()
#'
#' ## Show structure and content of exemplary dataframes included in the list
#'
#' str (StationClimateTables$ClimateData_PostCodes)
#' str (StationClimateTables$ClimateData_TA_HD)
#'
#'
#' @export

#' @export
GetStationClimate_RDataPackage <- function (
) {

    ClimateData_PostCodes <-
      as.data.frame (clidamonger::tab.stationmapping)
    # Name of the original table is misleading --> better to be changed
    # (also in the Excel workbook)

    ClimateData_StationTA <-
      as.data.frame (clidamonger::list.station.ta)

    ClimateData_TA_HD <-
      as.data.frame (clidamonger::data.ta.hd)

    ClimateData_Sol <-
      as.data.frame (clidamonger::data.sol)

    ParTab_SolOrientEst <-
      as.data.frame (clidamonger::tab.estim.sol.orient)


  return (
    list (
      ClimateData_StationTA = ClimateData_StationTA,
      ClimateData_PostCodes = ClimateData_PostCodes,
      ClimateData_TA_HD     = ClimateData_TA_HD,
      ClimateData_Sol       = ClimateData_Sol,
      ParTab_SolOrientEst   = ParTab_SolOrientEst
    )
  )


} # End of function


#. ---------------------------------------------------------------------------------




###################################################################################X
## . TabulaDataSourceXLSX::Load_BuildingData_Excel -----

# 2025-12-19 Note: The original function has been moved to the new package TabulaDataSourceXLSX
# Call: TabulaDataSourceXLSX::Load_BuildingData_Excel ()




#. ---------------------------------------------------------------------------------


###################################################################################X
## . Function: GetDataMobasy ()

# 2025-12-19 Note: The original function including option to import from Excel has been moved
# to the new package TabulaDataSourceXLSX.
# Call: TabulaDataSourceXLSX::GetDataMobasy_XLSX_RDA ()

# The following version of the function only loads parameters from RDA files


#' Get MOBASY data from specific sources
#'
#' GetDataMobasy () loads the data used for the functions EnergyProfileCalc ()
#' and MobasyCalc () from R data packages.
#'
#' @param FilterVariableName_1                   a character string
#' @param FilterValueList_1                      a character string or a list of character strings
#' @param FilterVariableName_2                   a character string
#' @param FilterValueList_2                      a character string or a list of character strings
#'
#' @return MobasyData a list of dataframes used for the calculation.
#' The following dataframes are included:
#' Lib_TABULA, Lib_ClimateStation, Data_Input, Data_Output_PreCalculated, Data_Output, Data_Calc
#' @examples
#'
#' mydata <- GetDataMobasy (
#'  myFilterVariableName_1  = "ID_Dataset",
#'  myFilterValueList_1     = c (
#'    "DE.MOBASY.WBG.0008.61",
#'    "DE.MOBASY.WBG.0008.62",
#'    "DE.MOBASY.WBG.0008.63",
#'    "DE.MOBASY.WBG.0008.64",
#'    "DE.MOBASY.WBG.0008.65",
#'    "DE.MOBASY.WBG.0008.66"
#'    ),
#'    myFilterVariableName_2  = NA,
#'    myFilterValueList_2     = NA
#'  )
#'
#' # Show structure and content of exemplary dataframes (only first row)
#' str (mydata$Data_Input)
#' str (mydata$Data_Output_PreCalculated)
#' str (mydata$Lib_TABULA$ParTab_InsulationDefault)
#' str (mydata$Lib_TABULA$ParTab_EnvArEst)
#' str (mydata$Lib_TABULA$ParTab_Meter_EnergyDensity)
#' str (mydata$Lib_ClimateStation$ClimateData_PostCodes)
#' str (mydata$Data_Output)
#'
#' @export
GetDataMobasy <- function (
    FilterVariableName_1                    = "Status_DataBase_Admin",
    FilterValueList_1                       = c ("Public", "Project",
                                                 "Test_Calc", "Analysis"),
    FilterVariableName_2                    = NA,
    FilterValueList_2                       = NA
) {

  #####################################################################################X
  ## Initialisation (data frames have to be existing)

  Lib_TABULA                <- NA
  Lib_ClimateStation        <- NA
  Data_Input	              <- NA
  Data_Output_PreCalculated <- NA
  Data_Output               <- NA
  Data_Calc	                <- NA
  DF_FilterBuildingData     <- NA





  #####################################################################################X
  ## Load tabula values from library


    Lib_TABULA <-
      Load_ParameterTables ()



  #####################################################################################X
  ## Load climate station values

    Lib_ClimateStation <-
      GetStationClimate_RDataPackage ()

    # Lib_ClimateStation <-
    #   Load_StationClimateTables_RDataPackage  (
    #   )



  #####################################################################################X
  ## Load building data


    Data_Input                <- MobasyBuildingData::Data_Input
    Data_Output_PreCalculated <- MobasyBuildingData::Data_Output_PreCalculated
    Data_Output               <- MobasyBuildingData::Data_Output
    Data_Calc                 <- Data_Input
    Header_BuildingData       <- MobasyBuildingData::InfoVariables
    DF_FilterBuildingData     <- MobasyBuildingData::DF_FilterBuildingData
    myFilterName              <- MobasyBuildingData::myFilterName

    if (! is.na (FilterVariableName_1) & is.na (FilterVariableName_1)) {
      BuildingData <-
        BuildingData [
          BuildingData [ , FilterVariableName_1] %in% FilterValueList_1,
          ]
    }

    if (! is.na (FilterVariableName_1) & ! is.na (FilterVariableName_2)) {
      BuildingData <-
        BuildingData [
          BuildingData [ , FilterVariableName_1] %in% FilterValueList_1  &
                  BuildingData [ ,FilterVariableName_2] %in% FilterValueList_2,
          ]
    }



  MobasyData <-
    list (
      Lib_TABULA 	              =	Lib_TABULA,
      Lib_ClimateStation	      =	Lib_ClimateStation,
      Data_Input	              =	Data_Input,
      Data_Output_PreCalculated =	Data_Output_PreCalculated,
      Data_Output 	            =	Data_Output,
      Data_Calc	                =	Data_Calc,
      Header_BuildingData       = Header_BuildingData,
      DF_FilterBuildingData     = DF_FilterBuildingData,
      myFilterName              = myFilterName
    )

  return (
    MobasyData
  )



}

# . ----------------------------------------------------------------------------------




###################################################################################X
## . Function: ApplyFilterBuildingDatasets

#' Filter the building data tables by a list of dataset IDs
#'
#' This function provides a filtered version of all 4 building MOBASY data tables
#'
#' @param Data_Input                one of the building data frames to be filtered
#' @param Data_Output_Precalculated one of the building data frames to be filtered
#' @param Data_Output               one of the building data frames to be filtered
#' @param Data_Calc                 one of the building data frames to be filtered
#' @param Header_BuildingData       a data frame with meta information (no changes will be applied)
#' @param DF_FilterBuildingData     a data frame containing the available filter lists
#' @param myFilterName              a character string specifying the filter list to be used
#'
#' @return myBuildingDataTables     a list of all data frames used as arguments of the function,
#'                                  4 tables are modified if a filter is applied
#'
#' @examples
#'
#'myBuildingDataTables <-
#' ApplyFilterBuildingDatasets (
#'   Data_Input                = myBuildingDataTables$Data_Input,
#'   Data_Output_PreCalculated = myBuildingDataTables$Data_Output_PreCalculated,
#'   Data_Output               = myBuildingDataTables$Data_Output,
#'   Data_Calc                 = myBuildingDataTables$Data_Calc,
#'   Header_BuildingData       = myBuildingDataTables$Header_BuildingData,
#'   DF_FilterBuildingData     = myBuildingDataTables$DF_FilterBuildingData,
#'   myFilterName              = "MOBASY-Sample"
#' )
#'
#'
#' @export
#'
ApplyFilterBuildingDatasets <- function (
    Data_Input,
    Data_Output_PreCalculated,
    Data_Output,
    Data_Calc,
    Header_BuildingData,
    DF_FilterBuildingData,
    myFilterName = "All"
) {


  if (is.na (myFilterName) | myFilterName == "All") {

    # Do nothing

  } else {

    myIDFilterList <-
      DF_FilterBuildingData [
        !is.na (
          DF_FilterBuildingData [ ,myFilterName]
        ),
        myFilterName]


    if (is.na (myIDFilterList[1])) {

      # Do nothing

    } else {

      Data_Input <-
        Data_Input [
          myIDFilterList,
        ]

      Data_Output_PreCalculated <-
        Data_Output_PreCalculated [
          myIDFilterList,
        ]

      Data_Output <-
        Data_Output [
          myIDFilterList,
        ]

      Data_Calc <-
        Data_Calc [
          myIDFilterList,
        ]

    } # End if filter list is existing

  } # End if filter name is existing

  myBuildingDataTables <-
    list (
      Data_Input	              =	Data_Input,
      Data_Output_PreCalculated =	Data_Output_PreCalculated,
      Data_Output 	            =	Data_Output,
      Data_Calc	                =	Data_Calc,
      Header_BuildingData       = Header_BuildingData,
      DF_FilterBuildingData     = DF_FilterBuildingData
    )

  return (
    myBuildingDataTables
  )

}










#. ---------------------------------------------------------------------------------



###################################################################################X
## . TabulaDataSourceXLSX::GetBuildingData_LocalExcel () -----

# 2025-12-19 Note: The original function has been moved to the new package TabulaDataSourceXLSX
# Call: TabulaDataSourceXLSX::GetBuildingData_LocalExcel ()





#. ---------------------------------------------------------------------------------





###################################################################################X
## . Function: GetBuildingData_RDataPackage

#' Get MOBASY building data from local Excel file
#'
#' GetBuildingData_RDataPackage () loads the MOBASY building data table from the data package
#' "MobasyBuildingData".
#' GetBuildingData_RDataPackage () is a wrapper for the function GetDataMobasy () in which
#' arguments are used specifying the data source (local Excel or R data package)
#' and the building datasets to be loaded.
#'
#' @param myFilterName a character string using predefined lists of datasets.
#' The currently defined subsets are:
#' "Examples":         Several example datasets
#' "MOBASY-Sample":    Datasets of more than 100 multi-family houses used for target / actual
#'                     comparison and benchmarking in the MOBASY project
#'                     (see https://www.iwu.de/forschung/energie/mobasy/)
#' "MOBASY-Sample_Checked-OnSite":    Datasets of 12 buildings from the MOBASY sample which were checked onsite
#'                     Can be used to test the function MobasyCalc () including target actual comparison
#' "ParameterStudy-CESB-2022":  10 datasets of the parameter study, published in
#'                     Loga, Tobias; Stein, Britta; Behem, Guillaume (2023):
#'                     Use of Energy Profile Indicators to Determine the Expected Range
#'                     of Heating Energy Consumption;
#'                     Proceedings of the Conference "Central Europe towards Sustainable Building"
#'                     2022 (CESB22), 4 to 6 July 2022;
#'                     Acta Polytechnica CTU Proceedings 38:470–477, 2022, published 2023
#'                     https://doi.org/10.14311/APP.2022.38.0470
#'                     (also implemented in the MOBASY project)
#' "ParameterStudy-PHSP-2023": 32 datasets of a parameter study on the
#'                    "PassivHausSozialPlus" buildings, implemented in the MOBASY project
#' "MOBASY-All"        All datasets mentioned above
#' "WebTool":          One dataset used for the webtool
#' "Typology-DE_Example-Buildings"  Datasets of the example buildings from the German residential building typology
#' "EnergyProfileShinyApp"  includes the datasets from the following filters: "Typology-DE_Example-Buildings", "MOBASY-All"
#' "All" (default):       All datasets listed above
#'
#' @return BuildingDataTables a list of dataframes including the calculation input data
#' "Data_Input", an empty dataframe "Data_Output" providing the structure for the output,
#' the dataframe "Data_Output_PreCalculated" providing data calculated by the Excel tool
#' (useful for comparison by developers) and the dataframe "Data_Calc" which is used to
#' collect all variables and their values used in the different calculation functions.
#' Furthermore the dataframe with all available filter lists DF_FilterBuildingData and the
#' actually applied filter myFilterName are returned
#'
#' @examples
#'
#' ## Load data
#' # Different options of dataset selection:
#'
#' # (1) Load all available datasets from the MOBASY building data table
#' myBuildingDataTables <- GetBuildingData_RDataPackage ()
#' or
#' myBuildingDataTables <- GetBuildingData_RDataPackage ("All")
#'
#' # (2) Load some example datasets
#' myBuildingDataTables <- GetBuildingData_RDataPackage ("Examples")
#'
#' # (3) Load all datasets from the MOBASY sample
#' myBuildingDataTables <- GetBuildingData_RDataPackage ("MOBASY-Sample")
#'
#' # (4) Load a selection of datasets from the MOBASY sample (12 buildings)
#' myBuildingDataTables <- GetBuildingData_RDataPackage ("MOBASY-Sample_Checked-OnSite")
#'
#' # (5) Load datasets of 6 buildings from a parameter study on uncertainties
#' myBuildingDataTables <- GetBuildingData_RDataPackage ("ParameterStudy-CESB-2022")
#'
#' # (6) Load dataset of the target/actual comparison study performed
#' #     for the two "PassivHausSozialPlus" (PHSP) buildings (2 x 16 variants)
#' myBuildingDataTables <- GetBuildingData_RDataPackage ("ParameterStudy-PHSP-2023")
#'
#' # (7) Load dataset of 1 building (example for webtool)
#' myBuildingDataTables <- GetBuildingData_RDataPackage ("WebTool")
#'
#' # (8) Load datasets of the example buildings from the German residential building typology
#' myBuildingDataTables <- GetBuildingData_RDataPackage ("Typology-DE_Example-Buildings")
#'
#'
#'
#' ## Show structure and content of the main dataframes
#' str (myBuildingDataTables$Data_Input)
#' str (myBuildingDataTables$Data_Output)
#'
#' ## Show the names of the predefined filter lists
#' colnames (myBuildingDataTables$DF_FilterBuildingData)
#'
#' @export
GetBuildingData_RDataPackage <- function (
    myFilterName = "All"
) {


  myDataTables <-
    GetDataMobasy (
    )

  myDataTables <-
    ApplyFilterBuildingDatasets (
      Data_Input                = myDataTables$Data_Input,
      Data_Output_PreCalculated = myDataTables$Data_Output_PreCalculated,
      Data_Output               = myDataTables$Data_Output,
      Data_Calc                 = myDataTables$Data_Calc,
      Header_BuildingData       = myDataTables$Header_BuildingData,
      DF_FilterBuildingData     = myDataTables$DF_FilterBuildingData,
      myFilterName              = myFilterName
    )


  # Only a selection of the list returned by GetDataMobasy ()
  # will be returned by GetBuildingData_RDataPackage ()
  myBuildingDataTables <-
    list (
      Data_Input	              =	myDataTables$Data_Input,
      Data_Output_PreCalculated =	myDataTables$Data_Output_PreCalculated,
      Data_Output 	            =	myDataTables$Data_Output,
      Data_Calc	                =	myDataTables$Data_Calc,
      Header_BuildingData       = myDataTables$Header_BuildingData,
      DF_FilterBuildingData     = myDataTables$DF_FilterBuildingData,
      myFilterName              = myFilterName
    )

  return (
    myBuildingDataTables
  )

}



#. ---------------------------------------------------------------------------------






###################################################################################X
## . TabulaDataSourceXLSX::Save_Data_Calc () -----

# 2025-12-19 Note: The original function has been moved to the new package TabulaDataSourceXLSX
# Call: TabulaDataSourceXLSX::Save_Data_Calc ()



#. ---------------------------------------------------------------------------------



###################################################################################X
## . TabulaDataSourceXLSX::Save_Result_MonitoringTable () -----


# 2025-12-19 Note: The original function has been moved to the new package TabulaDataSourceXLSX
# Call: TabulaDataSourceXLSX::Save_Result_MonitoringTable ()



#. ---------------------------------------------------------------------------------



###################################################################################X
## . Function: Detect differences to precalulated model results
###################################################################################X


#' @export
DetectDifferencesToPrecalculatedResult <- function (
    myCurrentResult,
    myPrecalculatedResult
    )  {
  # Detect differences between the model results in the monitoring table
  # (usually calculated by EnergyProfile.xlsm)
  # and the model results of the R script

  ## Constants


  ## Function script


  myDifferencesToPrecalc <-
    as.data.frame (myCurrentResult)

  OutputColnames_Numeric <-
    colnames (
      myCurrentResult [ ,
                    which (
                      sapply (myCurrentResult, class) == "numeric"
                      & colnames (myCurrentResult) %in% colnames (myPrecalculatedResult)
                    )
      ]
    )

  OutputColnames_OtherType <-
    colnames (
      myCurrentResult [,
                   which (sapply (myCurrentResult, class) != "numeric"
                          & colnames (myCurrentResult) %in% colnames (myPrecalculatedResult)
                   )
      ]
    )



  myDifferencesToPrecalc [, OutputColnames_Numeric] <-
    round (
      myCurrentResult [, OutputColnames_Numeric] /
        myPrecalculatedResult [, OutputColnames_Numeric] - 1,
      2)

  # myDifferencesToPrecalc [, OutputColnames_Numeric] <-
  #     (myPrecalculatedResult [, OutputColnames_Numeric] > 0) *
  #   myPrecalculatedResult [, OutputColnames_Numeric]

  n_Dataset <- nrow (myCurrentResult)

  # Test of loop
  i_Row <- n_Dataset

  for (i_Row in (1:n_Dataset)) {

    myDifferencesToPrecalc [i_Row, OutputColnames_OtherType] <-
      ifelse (myCurrentResult [i_Row, OutputColnames_OtherType] ==
                myPrecalculatedResult [i_Row, OutputColnames_OtherType],
              "ok",
              paste0 ("! ",
                      myCurrentResult [i_Row, OutputColnames_OtherType],
                      " <> ",
                      myPrecalculatedResult [i_Row, OutputColnames_OtherType])
      )


    myDifferencesToPrecalc [i_Row, 1] <-
      ifelse (myCurrentResult [i_Row, 1] ==
                myPrecalculatedResult [i_Row, 1],
              myCurrentResult [i_Row, 1],
              paste0 ("! ",
                      myCurrentResult [i_Row, 1],
                      " <> ",
                      myPrecalculatedResult [i_Row, 1])
      )

  }

  return (myDifferencesToPrecalc)

}



#. ---------------------------------------------------------------------------------




###################################################################################X
## . TabulaDataSourceXLSX::Save_BuildingData_LocalExcel () -----

# 2025-12-19 Note: The original function has been moved to the new package TabulaDataSourceXLSX
# Call: TabulaDataSourceXLSX::Save_BuildingData_LocalExcel ()





#. ---------------------------------------------------------------------------------





###################################################################################X
## . Save_BuildingData_rda ()

#' Save building data as .rda in a subfolder of the working directory
#'
#' Save all current building data including calculation results as *.rda files
#'
#' The following tables are exported to the subfolder "Output/RDA/":
#'
#'     Data_Input.rda
#'
#'     Data_Output_PreCalculated.rda
#'
#'     Data_Output.rda
#'
#'     DF_FilterBuildingData.rda
#'
#'     myFilterName.rda
#'
#'     InfoVariables.rda
#'
#'
#' @param myBuildingDataTables a list of data frames. It includes:
#' Data_Input, Data_Output_PreCalculated, Data_Output, Data_Calc
#'
#' @examples
#'
#' ## Example 1:
#' ## Load parameters and building data, calculate and save input and output to RDA files
#'
#' TabulaTables <-
#'    GetParameterTables_RDataPackage ()
#'
#' myBuildingDataTables <-
#'    GetBuildingData_RDataPackage ("Examples")
#'
#' myOutputTables <- EnergyProfileCalc (
#'    TabulaTables,
#'    myBuildingDataTables
#'    )
#'
#' Save_BuildingData_rda (
#'    myBuildingDataTables$Data_Input,
#'    myBuildingDataTables$Data_Output_PreCalculated,
#'    myOutputTables$Data_Output,
#'    myBuildingDataTables$Header_BuildingData,
#'    myBuildingDataTables$DF_FilterBuildingData,
#'    myBuildingDataTables$myFilterName
#' )
#'
#'
#' ## Example 2:
#' ## Load local building data from Excel and save as RDA files used for input of calculation
#'
#' # The data frame "Data_Output" is empty and is used frame for the calculation output
#'
#' myBuildingDataTables <-
#'    GetBuildingData_LocalExcel ("All")
#'
#' Save_BuildingData_rda (
#'    myBuildingDataTables$Data_Input,
#'    myBuildingDataTables$Data_Output_PreCalculated,
#'    myBuildingDataTables$Data_Output,
#'    myBuildingDataTables$Header_BuildingData,
#'    myBuildingDataTables$DF_FilterBuildingData,
#'    myBuildingDataTables$myFilterName
#' )
#'
#' @export
Save_BuildingData_rda <- function (
    Data_Input,
    Data_Output_PreCalculated,
    Data_Output,
    Header_BuildingData,
    DF_FilterBuildingData,
    myFilterName,
    SubFolderName = "Output/RDA"
) {


  Data_Input <-
    as.data.frame (
      Data_Input,
    )

  save (
    Data_Input,
    file = paste0 (SubFolderName, "/Data_Input.rda")
  )


  Data_Output <-
    as.data.frame (
      Data_Output
    )

  save (
    Data_Output,
    file = paste0 (SubFolderName, "/Data_Output.rda")
  )


  Data_Output_PreCalculated <- as.data.frame (
    Data_Output_PreCalculated
  )

  save (
    Data_Output_PreCalculated,
    file = paste0 (SubFolderName, "/Data_Output_PreCalculated.rda")
  )

  InfoVariables <- Header_BuildingData

  InfoVariables <- as.data.frame (
    InfoVariables [- which (InfoVariables [ ,1] == "-") , ]
  ) # Deletes the (otherwise empty) rows which contain a  "-" in the first column.

  InfoVariables [which (InfoVariables [ , 1] == "VarChar"), 1] <-
    "DataFormat"

  rownames (InfoVariables) <- InfoVariables [, 1]

  save (
    InfoVariables,
    file = paste0 (SubFolderName, "/InfoVariables.rda")
  )


  DF_FilterBuildingData <- as.data.frame (
    DF_FilterBuildingData
  )
  save (
    DF_FilterBuildingData,
    file = paste0 (SubFolderName, "/DF_FilterBuildingData.rda")
  )


  myFilterName <- as.data.frame (
    myFilterName
  )
  save (
    myFilterName,
    file = paste0 (SubFolderName, "/myFilterName.rda")
  )

}


