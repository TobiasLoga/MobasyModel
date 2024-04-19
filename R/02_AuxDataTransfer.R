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
## User-defined functions for data transfer------------------------------------
###################################################################################X


#. ---------------------------------------------------------------------------------


###################################################################################X
## . Function: Load Excel table
###################################################################################X

#' @export
Load_ExcelTable <- function (myFileName,
                             mySubfolderName,
                             mySheetName,
                             myHeaderRowCount) {

  cat ("Load_ExcelTable: [", myFileName, "]", mySheetName, fill = TRUE, sep ="")

  # Input for test of function
  # myFileName <- "Gradtagzahlen-Deutschland.xlsx"
  # mySubfolderName <- "Input/Climate"
  # mySheetName <- "Data.TA.HD"
  # myHeaderRowCount <- 1


  # Test of function:
  # Code_Type_Datafield <- "Input"


  ## Read header of the table

  Header_myDataFrame	<- NA
  Header_myDataFrame <-
      openxlsx::read.xlsx (
        paste (mySubfolderName, myFileName, sep = "/"),
        sheet = mySheetName,
        colNames = TRUE) [(1 : max(1, myHeaderRowCount-1)),]


  n_Col_Header <- ncol (Header_myDataFrame)
  if (is.null (n_Col_Header)) {
    n_Col_Header <- 1
  }
  #cat (n_Col_Header)

  # if (n_Col_Header == 1) {
  #
  # }


  ## Read values of the table

  myDataFrame <- NA
  myDataFrame <-
      openxlsx::read.xlsx (
        paste (mySubfolderName, myFileName, sep = "/"),
        sheet = mySheetName,
        rowNames = FALSE,
        colNames = FALSE,
        startRow = (myHeaderRowCount+1),
        cols = (1:n_Col_Header),
        skipEmptyCols = FALSE,
        na.strings = c('NA',""))

  n_Col_Data <- ncol (myDataFrame)
  if (is.null (n_Col_Data)) {
    n_Col_Data <- 1
  }
  #cat (n_Col_Data)

  myDataFrame <-
    if (n_Col_Data < n_Col_Header) {
      cbind (
        myDataFrame,
        matrix (
          data = NA,
          nrow = nrow (myDataFrame),
          ncol = (n_Col_Header - n_Col_Data))
      )
    } else {
      myDataFrame
    }

  #ncol (myDataFrame)

  colnames(myDataFrame) <- colnames(Header_myDataFrame)
  #myDataFrame[1:10,]

  rownames (myDataFrame) <- myDataFrame [ ,1]

  return (myDataFrame)

}




#. ---------------------------------------------------------------------------------



###################################################################################X
## . Function: Load script settings
###################################################################################X


Load_Settings <- function (
    mySettingsID            = "Example.01",
    myFileName_Settings     = "R-Settings_EnergyProfile.xlsx",
    mySubDir_Settings       = "Input/Settings",
    myAbsolutePath_Settings = ""
) {

  DF_AllGlobalSettings <-
    Load_ExcelTable (
      myFileName       = myFileName_Settings,
      mySubfolderName  = mySubDir_Settings,
      mySheetName      = "Global",
      myHeaderRowCount = 1)

  myFilterName <-
    DF_AllGlobalSettings$Filter_BuildingDataset [
      DF_AllGlobalSettings$ID_Settings == mySettingsID
    ]

  if (is.na (myFilterName)) {
    DF_DatasetFilter <- NA
  } else {
    DF_DatasetFilter <-
      openxlsx::read.xlsx (
        paste (mySubDir_Settings, myFileName_Settings, sep = "/"),
        sheet = myFilterName,
        colNames = TRUE
      )
  }


  # old version, did not work with Filter consisting of only 1 column
  # DF_DatasetFilter <-
  #   Load_ExcelTable (
  #     myFileName = myFileName_Settings,
  #     mySubfolderName = mySubDir_Settings,
  #     mySheetName =
  #       DF_AllGlobalSettings$Filter_BuildingDataset [
  #         DF_AllGlobalSettings$ID_Settings == mySettingsID
  #         ],
  #     myHeaderRowCount = 1)

  return (
    list (
      DF_Global = DF_AllGlobalSettings [DF_AllGlobalSettings$ID_Settings == mySettingsID, ],
      DF_DatasetFilter = DF_DatasetFilter
    )
  )

}








#. ---------------------------------------------------------------------------------





###################################################################################X
## . Function load TABULA library values from specified table
###################################################################################X

#' @export
Load_Lib_TABULA <- function (
    mySheetName_Lib_TABULA,
    myFileName_Lib_TABULA     = "tabula-values.xlsx",
    mySubDir_Lib_TABULA       = "Input/Lib_TABULA",
    myAbsolutePath_Lib_TABULA = ""
    ) {

  ## Internal test of the function
  # mySheetName_Lib_TABULA    <- "Tab.System.HG"
  # # mySheetName_Lib_TABULA    <- "Tab.ConstrYearClass"
  # myFileName_Lib_TABULA     <- "tabula-values.xlsx"
  # mySubDir_Lib_TABULA       <- "Input/Lib_TABULA"
  # myAbsolutePath_Lib_TABULA <- ""


  # myDataFrameName <- "ParTab_EnvArEst" # Use for test of function
  # myDataFrameName <- "ParTab_SysHD" # Use for test of function

  # mySheetName_Lib_TABULA <-
  #   NamesByCodes_Sheet_Lib_TABULA [NamesByCodes_Sheet_Lib_TABULA$Codes_Lib == myDataFrameName ,"Names_Table_Lib"]


  cat ("Load_Lib_TABULA: [", myFileName_Lib_TABULA, "]", mySheetName_Lib_TABULA, fill = TRUE, sep ="")


  myAbsolutePath_Lib_TABULA <-
    if (myAbsolutePath_Lib_TABULA == "") {
      ""
    } else {
      paste0 (myAbsolutePath_Lib_TABULA, "/")
    }

  temp_header <- NA
  temp_header <-
    openxlsx::read.xlsx (
      paste0 (myAbsolutePath_Lib_TABULA,
             mySubDir_Lib_TABULA, "/",
             myFileName_Lib_TABULA),
      sheet = mySheetName_Lib_TABULA,
      startRow = 1,
      colNames = TRUE #,
      #detectDates = TRUE # not used, causes errors if different
      # date formats are used in one column
    )
  # Data frame used as a header (datafield names)
  #ncol(temp_header)
  #str(temp_header)


  ParTab <-
    openxlsx::read.xlsx (
      paste0 (myAbsolutePath_Lib_TABULA,
              mySubDir_Lib_TABULA, "/",
              myFileName_Lib_TABULA),
      sheet = mySheetName_Lib_TABULA,
      startRow = 11,
      colNames = FALSE,
      skipEmptyCols = FALSE #,
      #detectDates = TRUE # not used, causes errors if different
      # date formats are used in one column
      # for example values '11.09.2015' and '14.09.2016  14:07:09'
      # as input values (even if Excel cell format is the same;
      # If detectDates = FALSE both versions are read as integer
      # in the same Excel systematics)
    )
  #ncol(ParTab)
  #

  n_Col_Min_Temp <- min (ncol(ParTab), ncol(temp_header))
  # Due to notes and auxiliary cells the number of columns can be different.
  temp_header <- temp_header [,1:n_Col_Min_Temp]
  ParTab <- ParTab [,1:n_Col_Min_Temp]
  colnames (ParTab) <-  colnames(temp_header)

  ParTab <- ParTab [! is.na (ParTab [,1]), ]
  # Rows with dataset name (first column) not available are removed

  rownames (ParTab) <- ParTab [,1]

  ColsFormat <- temp_header [5, ]
  i_Cols_DateFormat <- which (ColsFormat == "Date")

  for (i_Col in i_Cols_DateFormat) {
    ParTab [ ,i_Col] <-
      AuxFunctions::xl_ConvertDate (ParTab [ ,i_Col])
  }

  return (ParTab)


} # End function



#. ---------------------------------------------------------------------------------


###################################################################################X
## . Function: Load all TABULA tables with calculation parameters (Excel or R data package)
###################################################################################X

#' @export
Load_ParameterTables <- function (
    mySwitch_LoadLibFromRDataPackage = 0,
    myFileName_Lib_TABULA            = "tabula-values.xlsx",
    mySubDir_Lib_TABULA              = "Input/Lib_TABULA",
    myAbsolutePath_Lib_TABULA        = "") {

  ## Internal test of the function
  # mySheetName_Lib_TABULA    <- "Tab.ConstrYearClass"
  # myFileName_Lib_TABULA     <- "tabula-values.xlsx"
  # mySubDir_Lib_TABULA       <- "Input/Lib_TABULA"
  # myAbsolutePath_Lib_TABULA <- ""


  if (mySwitch_LoadLibFromRDataPackage == 0) {

    ## Option 1: Load tables from local Excel file

    ParTab_EnvArEst             <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.Par.EnvAreaEstim",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_ConstrYearClass      <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.ConstrYearClass",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_UClassConstr         <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.U.Class.Constr",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_InsulationDefault    <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.Insulation.Default",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_MeasurefDefault      <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.Measure.f.Default",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_ThermalBridging      <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.Const.ThermalBridging",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )


    ParTab_Infiltration         <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.Const.Infiltration",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_WindowTypePeriods    <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.U.WindowType.Periods",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_BoundaryCond         <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.BoundaryCond",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_Climate              <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.Climate",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_Uncertainty          <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.Uncertainty.Levels",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_System_HG            <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.System.HG",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_System_HS            <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.System.HS",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_System_HD            <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.System.HD",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_System_HA            <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.System.HA",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_System_WG            <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.System.WG",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_System_WS            <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.System.WS",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_System_WD            <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.System.WD",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_System_WA            <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.System.WA",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_System_H             <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.System.H",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_System_W             <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.System.W",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_System_Vent          <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.System.Vent",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_System_PVPanel       <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.System.PVPanel",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_System_PV            <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.System.PV",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    #ParTab_System_Coverage      <-
    #  Load_Lib_TABULA (
    #   mySheetName_Lib_TABULA    = "Tab.System.Coverage") # Currently not used
    #ParTab_System_ElProd        <-
    #  Load_Lib_TABULA (
    #   mySheetName_Lib_TABULA    = "Tab.System.ElProd") # Currently not used

    ParTab_System_SetECAssess   <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.System.SetECAssess",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_System_EC            <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.System.EC",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_Meter_EnergyDensity            <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.Meter.EnergyDensity",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

    ParTab_CalcAdapt            <-
      Load_Lib_TABULA (
        mySheetName_Lib_TABULA    = "Tab.CalcAdapt",
        myFileName_Lib_TABULA     = myFileName_Lib_TABULA,
        mySubDir_Lib_TABULA       = mySubDir_Lib_TABULA,
        myAbsolutePath_Lib_TABULA = myAbsolutePath_Lib_TABULA
      )

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

  Code_ParTab_U_Class_Constr_National <- "MOBASY"
  ParTab_UClassConstr <-
    ParTab_UClassConstr [
      ParTab_UClassConstr$Code_U_Class_Constr_National == Code_ParTab_U_Class_Constr_National,
      ]

  Code_ParTab_InsulationDefault <- "MOBASY"
  ParTab_InsulationDefault <-
    ParTab_InsulationDefault [
      ParTab_InsulationDefault$Code_d_Insulation_Default_National == Code_ParTab_InsulationDefault,
      ]

  Code_ParTab_MeasurefDefault <- "MOBASY"
  ParTab_MeasurefDefault <-
    ParTab_MeasurefDefault [
      ParTab_MeasurefDefault$Code_f_Measure_National_Basic == Code_ParTab_MeasurefDefault,
      ]

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
## . Function: GetParameterTables_LocalExcel

#' Get TABULA tables with calculation parameters from local Excel workbook
#'
#' GetParameterTables_LocalExcel () loads a data library with parameters
#' for the energy performance calculation from the Excel workbook "tabula-values.xlsx".
#' The data tables of the package are basically identical to the tables of the workbook
#' "tabula-values.xlsx" from the European projects TABULA and EPISCOPE
#' (Download at: https://episcope.eu/communication/download/)
#' However some tables have been added used by the MOBASY algorithms for
#' target/actual comparison and for uncertainty assessment.
#' In some of the existing tables additional parameter sets (rows) have been added.
#'
#' The file name and subfolder are fixed to:
#' Subfolder: "Input/Lib"
#' File name: "tabula-values.xlsx"
#' GetParameterTables_LocalExcel () is a wrapper for the function Load_ParameterTables ()
#' in which arguments are used specifying the data source (local Excel or R data package
#' and the location of the local file).
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
#'   GetParameterTables_LocalExcel ()
#'
#' ## Show structure and content of some of the dataframes
#' str (TabulaTables$ParTab_InsulationDefault)
#' str (TabulaTables$ParTab_System_HG)
#' str (TabulaTables$ParTab_Meter_EnergyDensity)
#' str (TabulaTables$ParTab_Uncertainty)
#'
#' @export
GetParameterTables_LocalExcel <- function () {

  TabulaTables <-
    Load_ParameterTables (mySwitch_LoadLibFromRDataPackage = 0)

  return (
    TabulaTables
  )


}



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
    Load_ParameterTables (mySwitch_LoadLibFromRDataPackage = 1)

  return (
    TabulaTables
  )


}



#. ---------------------------------------------------------------------------------



###################################################################################X
## . Function: Load tables with station climate data from local workbook
###################################################################################X


#' @export
Load_StationClimateTables_Excel <- function (
    myFileName_StationClimate         = "Gradtagzahlen-Deutschland.xlsx",
    mySubDir_StationClimate           = "Input/Climate",
    myAbsolutePath_StationClimate     = ""
) {

  ClimateData_StationTA <-
    #Data_ClimateMonth_StationTA <-
    Load_ExcelTable (
      myFileName       = myFileName_StationClimate,
      mySubfolderName  = mySubDir_StationClimate,
      mySheetName      = "List.Station.TA",
      myHeaderRowCount = 1
    )

  ClimateData_PostCodes <-
    #Data_ClimateMonth_StationMapping <-
    Load_ExcelTable (
      myFileName       = myFileName_StationClimate,
      mySubfolderName  = mySubDir_StationClimate,
      mySheetName      = "Tab.StationMapping",
      myHeaderRowCount = 1
    )

  ClimateData_TA_HD <-
    #Data_ClimateMonth_TA_HD <-
    Load_ExcelTable (
      myFileName       = myFileName_StationClimate,
      mySubfolderName  = mySubDir_StationClimate,
      mySheetName      = "Data.TA.HD",
      myHeaderRowCount = 1
    )

  ClimateData_Sol <-
    #Data_ClimateMonth_Sol <-
    Load_ExcelTable (
      myFileName       = myFileName_StationClimate,
      mySubfolderName  = mySubDir_StationClimate,
      mySheetName      = "Data.Sol",
      myHeaderRowCount = 1
    )

  ParTab_SolOrientEst <-
    Load_ExcelTable (
      myFileName       = myFileName_StationClimate,
      mySubfolderName  = mySubDir_StationClimate,
      mySheetName      = "Tab.Estim.Sol.Orient",
      myHeaderRowCount = 1
    )

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
## . Function: GetStationClimate_LocalExcel

#' Get station climate data from local Excel file
#'
#' GetStationClimate_LocalExcel () loads all station climate data from a local Excel file.
#' The source is fixed to:
#' Subfolder:    "Input/Climate"
#' File name:    "Gradtagzahlen-Deutschland.xlsx"
#' It is a wrapper for the function Load_StationClimateTables_Excel () in which
#' arguments are used specifying the type of data source (local Excel or R data package)
#' and the localisation of the local file.
#'
#' @param None
#'
#' @return StationClimateTables a list of dataframes
#' @examples
#'
#' StationClimateTables <- GetStationClimate_LocalExcel ()
#'
#' ## Show structure and content of exemplary dataframes included in the list
#'
#' str (StationClimateTables$ClimateData_PostCodes)
#' str (StationClimateTables$ClimateData_TA_HD)
#'
#'
#' @export
GetStationClimate_LocalExcel <- function (
) {

  ClimateStationTables <- Load_StationClimateTables_Excel (
    myFileName_StationClimate         = "Gradtagzahlen-Deutschland.xlsx",
    mySubDir_StationClimate           = "Input/Climate",
    myAbsolutePath_StationClimate     = ""
  )

  return (
    ClimateStationTables
  )

}



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
## . Function: Load building data from Excel workbook
###################################################################################X

#' @export
Load_BuildingData_Excel <- function (
    Code_Type_Datafield,
    myFilterVariableName_01 = NA,
    myFilter_01 = NA,
    myFilterVariableName_02 = NA,
    myFilter_02 = NA
    ) {


  ## Test of function:
  # Code_Type_Datafield <- "Input"
  # myFilterVariableName_01 <- "Status_DataBase_Admin"
  # myFilter_01             <- "Project"
  # myFilterVariableName_02 <- NA # "Status_DataBase_Admin"
  # myFilter_02             <- NA # "Test_Calc"


  ## Constants

  n_Row_Header_DataBuilding <- 100
  i_Row_ColumnFormat <- 98

  WorkingDir <- getwd ()

  Name_File_BuildingData   <- "Building-Data"
  Name_Sheet_BuildingData  <- "Data.Building"
  Subfolder_BuildingData   <- "Input/BuildingData"
  Path_File_BuildingData   <-
    paste (
      WorkingDir, "/",
      Subfolder_BuildingData, "/",
      Name_File_BuildingData, ".xlsx",
      sep = ""
    )


  ## Print information about current step

  cat ("Load_ExcelTable: [", Name_File_BuildingData, "]",
       Name_Sheet_BuildingData,
       fill = TRUE, sep ="")

  ## Read header of BuildingData table (building data)
  Header_DataBuilding	<- NA
  Header_DataBuilding <- openxlsx::read.xlsx (Path_File_BuildingData,
                                    sheet=Name_Sheet_BuildingData,
                                    colNames = TRUE)[
                                      (1 : n_Row_Header_DataBuilding),
                                      ]

  ## Identify input variables (monitoring variables, additional model-input variables, boundary conditions)

  i_Row_Code_Type_DataFlow <-
    which (Header_DataBuilding [,1] == "Type_Datafield_WebTool")

  i_Col_Selected <-
    which (Header_DataBuilding [i_Row_Code_Type_DataFlow,] == Code_Type_Datafield)
  #i_Col_Selected <- which (Header_DataBuilding [i_Row_Code_Type_DataFlow,] == "Input")
  #Header_DataBuilding

  n_Col_Header <- length (colnames (Header_DataBuilding))
  #n_Col_Header

  # Note: The following row in the header should be used to identify the monitoring indicators and the input indicators of the calculation model.
  # Only these should be retained.
  #
  # Possible codes:
  # Info | Monitoring | Metering | Input_Building_Detailed | Input_Model_Parameters | Output_Model
  #
  #Header_DataBuilding [Header_DataBuilding$ID_Dataset == "Index_Level_DataAcquisition", 1:50]

  ## Read BuildingData table (building data)
  BuildingData <- NA
  BuildingData <- openxlsx::read.xlsx (Path_File_BuildingData,
                             sheet=Name_Sheet_BuildingData,
                             rowNames = FALSE,
                             colNames = FALSE,
                             startRow = (n_Row_Header_DataBuilding+1),
                             cols = (1:n_Col_Header),
                             skipEmptyCols = FALSE,
                             na.strings = c('NA','#',""))
  #BuildingData <- read.xlsx (Path_File_BuildingData, sheet=Name_Sheet_BuildingData, colNames = FALSE, startRow = (n_Row_Header_DataBuilding+1), cols = (1:n_Col_Header),  skipEmptyCols = FALSE, na.strings = c('NA','#',""), detectDates = TRUE)
  #BuildingData <- read.xlsx (Path_File_BuildingData, sheet=Name_Sheet_BuildingData, colNames = FALSE, startRow = (n_Row_Header_DataBuilding+1), skipEmptyCols = FALSE, na.strings = c('NA','#',""))
  #BuildingData <- read.xlsx (Path_File_BuildingData, sheet=Name_Sheet_BuildingData, colNames = FALSE, startRow = (n_Row_Header_DataBuilding+1), skipEmptyCols = FALSE)

  #BuildingData[(1:10),]

  #colnames (BuildingData)
  #length (colnames (BuildingData))

  n_Col_Data <- ncol (BuildingData)

  BuildingData <-
    if (n_Col_Data < n_Col_Header) {
      cbind (
        BuildingData,
        matrix (data = NA, nrow = nrow (BuildingData), ncol = (n_Col_Header - n_Col_Data))
      )
    } else {
      BuildingData
    }
  length (colnames (BuildingData))




  colnames (BuildingData) <- colnames (Header_DataBuilding)
  #BuildingData[1:10,]


  if (! is.na (myFilterVariableName_01) & is.na (myFilterVariableName_02)) {
    BuildingData <- BuildingData [BuildingData [ ,myFilterVariableName_01] %in%
                                  myFilter_01, ]

  }


  if (! is.na (myFilterVariableName_01) & ! is.na (myFilterVariableName_02)) {
    BuildingData <- BuildingData [BuildingData [ ,myFilterVariableName_01] %in%
                                  myFilter_01  &
                                  BuildingData [ ,myFilterVariableName_02] %in%
                                  myFilter_02,]
  } # 2022-11-25: Changed from OR (|) to AND (&)

  # BuildingData <- BuildingData [BuildingData$Status_DataBase_Admin == "Project" |
  #                                             BuildingData$Status_DataBase_Admin == "Test_Calc",]

  #BuildingData [1:10, ]
  #View (BuildingData)

  rownames (BuildingData) <- BuildingData$ID_Dataset # not yet necessary

  BuildingData <- BuildingData [, c(1, i_Col_Selected)]
  #BuildingData <- BuildingData [, c(1, 2, 3, 4, i_Col_Selected)]
  # colnames (BuildingData)



  ## Convert boolean Excel input
  #  2024-04-12 supplemented
  #  Convert from {"1", "0", 1, 0, TRUE, FALSE, NA}
  #  to {TRUE, FALSE, NA}

  Header_DataBuilding <- Header_DataBuilding [ , colnames (BuildingData)]

  Colnames_Header_VarTypeBoolean <-
    colnames (
      Header_DataBuilding [ ,
        as.integer (which (Header_DataBuilding [i_Row_ColumnFormat, ] == "Boolean"))
      ]
    )

  if (sum (Colnames_Header_VarTypeBoolean %in% colnames (BuildingData)) > 0) {
    BuildingData [ ,Colnames_Header_VarTypeBoolean] <-
      as.logical (
        Reformat_InputData_Boolean (
          BuildingData [ , Colnames_Header_VarTypeBoolean]
        )
      )
  }



  return (
    list (
      BuildingData        = BuildingData,
      Header_BuildingData = Header_DataBuilding
      )
  )
}


#. ---------------------------------------------------------------------------------


###################################################################################X
## . Function: GetDataMobasy ()

#' Get MOBASY data from specific sources
#'
#' GetDataMobasy () loads the data used for the functions EnergyProfileCalc ()
#' and MobasyCalc () from sources that are specified by the parameters
#' (local Excel workbooks or R data packages).
#'
#' @param Indicator_Load_ParameterTables_Excel             an integer (possible values: 0, 1)
#' @param Indicator_Load_ParameterTables_RDataPackage      an integer (possible values: 0, 1)
#' @param Indicator_Load_StationClimateTables_Excel        an integer (possible values: 0, 1)
#' @param Indicator_Load_StationClimateTables_RDataPackage an integer (possible values: 0, 1)
#' @param Indicator_Load_BuildingData_Excel                an integer (possible values: 0, 1)
#' @param Indicator_Load_BuildingData_RDataPackage         an integer (possible values: 0, 1)
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
#'  Indicator_Load_ParameterTables_Excel              = 1,
#'  Indicator_Load_ParameterTables_RDataPackage       = 0,
#'  Indicator_Load_StationClimateTables_Excel         = 1,
#'  Indicator_Load_StationClimateTables_RDataPackage  = 0,
#'  Indicator_Load_BuildingData_Excel                 = 1,
#'  Indicator_Load_BuildingData_RDataPackage          = 0,
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
    Indicator_Load_ParameterTables_Excel              = 1,
    Indicator_Load_ParameterTables_RDataPackage       = 0,
    Indicator_Load_StationClimateTables_Excel         = 1,
    Indicator_Load_StationClimateTables_RDataPackage  = 0,
    Indicator_Load_BuildingData_Excel                 = 1,
    Indicator_Load_BuildingData_RDataPackage          = 0,
    FilterVariableName_1                    = "Status_DataBase_Admin",
    FilterValueList_1                       = c ("Public", "Project", "Test_Calc"),
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


  ## Option 1: Load tabula values from Excel file

  if (Indicator_Load_ParameterTables_Excel * 1 == 1) {

    Lib_TABULA <-
      Load_ParameterTables (
        mySwitch_LoadLibFromRDataPackage = 0,
        myFileName_Lib_TABULA     = "tabula-values.xlsx",
        mySubDir_Lib_TABULA       = "Input/Lib_TABULA",
      )

  }


  ## Option 2: Load tabula values from R data package

  if (Indicator_Load_ParameterTables_RDataPackage * 1 == 1) {

    Lib_TABULA <-
      Load_ParameterTables (
        mySwitch_LoadLibFromRDataPackage = 1,
        myFileName_Lib_TABULA     = NA,
        mySubDir_Lib_TABULA       = NA,
      )

  }


  #####################################################################################X
  ## Load climate station values


  ## Option 1: Load climate station values from Excel file

  if (Indicator_Load_StationClimateTables_Excel * 1 == 1) {

    Lib_ClimateStation <-
      Load_StationClimateTables_Excel  (
        myFileName_StationClimate         = "Gradtagzahlen-Deutschland.xlsx",
        mySubDir_StationClimate           = "Input/Climate",
        myAbsolutePath_StationClimate     = ""
      )

  }


  ## Option 2: Load climate station values from R data packaage

  if (Indicator_Load_StationClimateTables_RDataPackage * 1 == 1) {

    Lib_ClimateStation <-
      Load_StationClimateTables_RDataPackage  (
      )

  }


  #####################################################################################X
  ## Load building data


  ## Option 1: Load building data from Excel file

  if (Indicator_Load_BuildingData_Excel * 1 == 1) {

    List_Temp <-
      Load_BuildingData_Excel (
        Code_Type_Datafield = "Input",
        myFilterVariableName_01 = FilterVariableName_1,
        myFilter_01             = FilterValueList_1,
        myFilterVariableName_02 = FilterVariableName_2,
        myFilter_02             = FilterValueList_2
      ) # Function defined in AuxDataTransfer
    Data_Input          <- List_Temp$BuildingData
    Header_BuildingData <- List_Temp$Header_BuildingData

    List_Temp <-
      Load_BuildingData_Excel (
        Code_Type_Datafield = "Output",
        myFilterVariableName_01 = FilterVariableName_1,
        myFilter_01             = FilterValueList_1,
        myFilterVariableName_02 = FilterVariableName_2,
        myFilter_02             = FilterValueList_2
      ) # Function defined in AuxDataTransfer
    Data_Output_PreCalculated <- List_Temp$BuildingData
    #colnames (Data_Output_PreCalculated)

    # Data_Output_PreCalculated <-
    #   Data_Output_PreCalculated [rownames (Data_Input), ]

    Data_Output <- Data_Output_PreCalculated
    Data_Output [ , 2:ncol(Data_Output)] <- NA

    Data_Calc <-
      Data_Input

    DF_FilterBuildingData <-
      Load_ExcelTable (myFileName = "Building-Data.xlsx",
                       mySubfolderName = "Input/BuildingData",
                       mySheetName = "Filter.Dataset",
                       myHeaderRowCount = 1)

    myFilterName = "All"

    # n_Dataset <-
    #   nrow (Data_Calc)

  } # End if (load building data from Excel file )


  ## Option 2: Load building data from R data packaage

  if (Indicator_Load_BuildingData_RDataPackage * 1 == 1) {

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


  } # End if (load building data from *.rda files)

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
## . Function: GetBuildingData_LocalExcel

#' Get MOBASY building data from local Excel file
#'
#' GetBuildingData_LocalExcel () loads the MOBASY building data table from a local Excel file
#' and returns a dataframe with datasets specified by the function argument.
#' Subfolder:    "Input/BuildingData"
#' File name:    "Building-Data.xlsx"
#' Sheet name:   "Data.Building"
#' GetDataMobasy_Local () is a wrapper for the function GetDataMobasy () in which
#' arguments are used specifying the data source (local Excel or R data package)
#' and the building datasets to be loaded.
#'
#' @param myFilterName a character string using predefined lists of datasets.
#' The currently defined subsets are:
#' "MOBASY-Sample":    Datasets of more than 100 multi-family houses used for target / actual
#'                     comparison and benchmarking in the MOBASY project
#'                     (see https://www.iwu.de/forschung/energie/mobasy/)
#' "WebTool":          One dataset used for the webtool
#' "Examples":         Several example datasets
#' "ParameterStudy-CESB-2022":  10 datasets of the parameter study, published in
#'                     Loga, Tobias; Stein, Britta; Behem, Guillaume (2023):
#'                     Use of Energy Profile Indicators to Determine the Expected Range
#'                     of Heating Energy Consumption;
#'                     Proceedings of the Conference "Central Europe towards Sustainable Building"
#'                     2022 (CESB22), 4 to 6 July 2022;
#'                     Acta Polytechnica CTU Proceedings 38:470–477, 2022, published 2023
#'                     https://doi.org/10.14311/APP.2022.38.0470
#' "ParameterStudy-PHSP-2023": 32 datasets of a parameter study on the
#'                    "PassivHausSozialPlus" buildings, implemented in the MOBASY project
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
#' ## Show structure and content of the main dataframes
#' str (myBuildingDataTables$Data_Input)
#' str (myBuildingDataTables$Data_Output)
#'
#' ## Show the names of the predefined filter lists
#' colnames (myBuildingDataTables$DF_FilterBuildingData)
#'
#' @export
GetBuildingData_LocalExcel <- function (
    myFilterName = "All"
) {


  myDataTables <-
    GetDataMobasy (
      Indicator_Load_ParameterTables_Excel              = 0,
      Indicator_Load_ParameterTables_RDataPackage       = 0,
      Indicator_Load_StationClimateTables_Excel         = 0,
      Indicator_Load_StationClimateTables_RDataPackage  = 0,
      Indicator_Load_BuildingData_Excel                 = 1,
      Indicator_Load_BuildingData_RDataPackage          = 0,
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
  # will be returned by GetBuildingData_LocalExcel ()
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
#' "MOBASY-Sample":    Datasets of more than 100 multi-family houses used for target / actual
#'                     comparison and benchmarking in the MOBASY project
#'                     (see https://www.iwu.de/forschung/energie/mobasy/)
#' "WebTool":          One dataset used for the webtool
#' "Examples":         Several example datasets
#' "ParameterStudy-CESB-2022"  10 datasets of the parameter study, published in
#'                     Loga, Tobias; Stein, Britta; Behem, Guillaume (2023):
#'                     Use of Energy Profile Indicators to Determine the Expected Range
#'                     of Heating Energy Consumption;
#'                     Proceedings of the Conference "Central Europe towards Sustainable Building"
#'                     2022 (CESB22), 4 to 6 July 2022;
#'                     Acta Polytechnica CTU Proceedings 38:470–477, 2022, published 2023
#'                     https://doi.org/10.14311/APP.2022.38.0470
#' "ParameterStudy-PHSP-2023": 32 datasets of a parameter study on the
#'                     "PassivHausSozialPlus" buildings, implemented in the MOBASY project
#' "All" (default):    All datasets listed above
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
#' # (2) Load all datasets from the MOBASY sample
#' myBuildingDataTables <- GetBuildingData_RDataPackage ("MOBASY-Sample")
#'
#' # (3) Load dataset of 1 building (example for webtool)
#' myBuildingDataTables <- GetBuildingData_RDataPackage ("WebTool")
#'
#' # (4) Load some example datasets
#' myBuildingDataTables <- GetBuildingData_RDataPackage ("Examples")
#'
#' # (5) Load dataset of the target/actual comparison study performed
#' # for the two "PassivHausSozialPlus" (PHSP) buildings (2 x 16 variants)
#' myBuildingDataTables <- GetBuildingData_RDataPackage ("ParameterStudy-PHSP-2023")
#'
#' # (6) Load datasets of 6 buildings from a parameter study on climate types
#' myBuildingDataTables <- GetBuildingData_RDataPackage ("ParameterStudy-CESB-2022")
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
      Indicator_Load_ParameterTables_Excel              = 0,
      Indicator_Load_ParameterTables_RDataPackage       = 0,
      Indicator_Load_StationClimateTables_Excel         = 0,
      Indicator_Load_StationClimateTables_RDataPackage  = 0,
      Indicator_Load_BuildingData_Excel                 = 0,
      Indicator_Load_BuildingData_RDataPackage          = 1,
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
## . Function: Store calculation and result data in Excel workbook
###################################################################################X


#' @export
Save_Data_Calc <- function (Data_Calc)  {
  #str (Data_Calc)

  ## Constants

  Subfolder_Output_Calc     <- "Output/Calc"
  Name_File_Output_Calc     <- "Calc"
  Name_Sheet_Output_Calc    <- "Data"


  ## Function script

  WorkingDir <- getwd ()

  WB_Data_Calc <- openxlsx::createWorkbook()
  openxlsx::addWorksheet (WB_Data_Calc, Name_Sheet_Output_Calc)
  openxlsx::writeData (WB_Data_Calc, Name_Sheet_Output_Calc, Data_Calc)
  openxlsx::saveWorkbook (WB_Data_Calc,
                paste (WorkingDir, "/",
                       Subfolder_Output_Calc, "/",
                       Name_File_Output_Calc, "_",
                       TimeStampForFileName () ,
                       ".xlsx",
                       sep="")
                )
}


#. ---------------------------------------------------------------------------------


###################################################################################X
## . Function: Store specific output as result for "Model1" in Excel workbook
###################################################################################X

#' @export
Save_Result_MonitoringTable <- function (DF_Result, myName_Result)  {
  #str (DF_Result)

  ## Constants

  Subfolder_Result          <- "Output/Result"
  Name_Sheet_Result         <- "Data"


  ## Function script

  WorkingDir <- getwd ()

  WB_Result <- openxlsx::createWorkbook()
  openxlsx::addWorksheet (WB_Result, Name_Sheet_Result)
  openxlsx::writeData (WB_Result, Name_Sheet_Result, DF_Result)

  openxlsx::saveWorkbook (WB_Result,
                paste (WorkingDir, "/",
                       Subfolder_Result, "/",
                       myName_Result, "_",
                       TimeStampForFileName () ,
                       ".xlsx",
                       sep="")
                )
}

#
# Save_DataFrame_XLSX <- function (MyDataFrame, MyOutPutPath, MyFileNameWithoutSuffix, MySheetName)  {
#
#   #str (MyDataFrame)
#   WB_Data_Out <- createWorkbook()
#   addWorksheet (WB_Data_Out, "Data")
#   writeData (WB_Data_Out, MySheetName, MyDataFrame)
#   saveWorkbook (WB_Data_Out, paste (MyOutPutPath, "/", MyFileNameWithoutSuffix, ".xlsx", sep=""))
#
# }



#
# #str (Data_Calc)
# WB_Data_Calc <- createWorkbook()
# addWorksheet (WB_Data_Calc, "Data")
# writeData (WB_Data_Calc, "Data", Data_Calc)
# saveWorkbook (WB_Data_Calc, paste (WorkingDir, "/",  Subfolder_Calc, "/", Name_File_Calc, "_", TimeStampForFileName () , ".xlsx", sep=""))
#
#

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
## . Save_BuildingData_LocalExcel

#' Save the building data tables to an Excel workbook
#'
#' Save all current building data including calculation results to an Excel workbook
#'
#' The following tables are exported to the respective subfolders:
#'
#' Subfolder "Output/Calc/":
#'
#' > "Data_Calc_{YYYY-MM-DD_hh-mm-ss}.xlsx"
#'
#'
#'Subfolder "Output/Result/":
#'
#' > "Data_Input_{YYYY-MM-DD_hh-mm-ss}.xlsx"
#'
#' > "Data_Output_{YYYY-MM-DD_hh-mm-ss}.xlsx"
#'
#' > "Data_Output_PreCalculated_{YYYY-MM-DD_hh-mm-ss}.xlsx"
#'
#'
#' @param myBuildingDataTables a list of data frames. THese are:
#' Data_Input, Data_Output_PreCalculated, Data_Output, Data_Calc
#'
#' @examples
#'
#' ## Load building data tables and calculation parameters
#'
#' ## Get parameter tables
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
#' Save_BuildingData_LocalExcel (
#'    myOutputTables$Data_Output,
#'    myOutputTables$Data_Calc,
#'    myBuildingDataTables$Data_Output_PreCalculated
#' )
#'
#' @export
Save_BuildingData_LocalExcel <- function (
    Data_Output,
    Data_Calc,
    Data_Output_PreCalculated
) {


Save_Result_MonitoringTable (
  Data_Output,
  "Data_Output"
)

Save_Data_Calc (
  Data_Calc
)

Save_Result_MonitoringTable (
  Data_Output_PreCalculated,
  "Result_PreCalculated"
)

DF_OutputDifferencesToPrecalc <-
  DetectDifferencesToPrecalculatedResult (
    Data_Output,
    Data_Output_PreCalculated
  )

Save_Result_MonitoringTable (
  DF_OutputDifferencesToPrecalc,
  "DifferencesToPrecalc")



}




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
    myFilterName
) {


  Data_Input <-
    as.data.frame (
      Data_Input,
    )

  save (
    Data_Input,
    file = "Output/RDA/Data_Input.rda"
  )


  Data_Output <-
    as.data.frame (
      Data_Output
    )

  save (
    Data_Output,
    file = "Output/RDA/Data_Output.rda"
  )


  Data_Output_PreCalculated <- as.data.frame (
    Data_Output_PreCalculated
  )

  save (
    Data_Output_PreCalculated,
    file = "Output/RDA/Data_Output_PreCalculated.rda"
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
    file = "Output/RDA/InfoVariables.rda"
  )


  DF_FilterBuildingData <- as.data.frame (
    DF_FilterBuildingData
  )
  save (
    DF_FilterBuildingData,
    file = "Output/RDA/DF_FilterBuildingData.rda"
  )


  myFilterName <- as.data.frame (
    myFilterName
  )
  save (
    myFilterName,
    file = "Output/RDA/myFilterName.rda"
  )

}


