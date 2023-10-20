#####################################################################################X
##
##    File name:        "EnvArEst.R" 
##
##    Module of:        "EnergyProfile.R"
##    
##    Task:             Estimation of envelope area 
##    
##    Method:           Energy Profile / envelope surface area estimation procedure
##                      (https://www.iwu.de/forschung/energie/kurzverfahren-energieprofil/)
##
##    Projects:         TABULA / EPISCOPE / MOBASY
##
##    Authors:          Tobias Loga (t.loga@iwu.de)
##                      Jens Calisti
##                      IWU - Institut Wohnen und Umwelt, Darmstadt / Germany
##
##    Created:          23-03-2020
##    Last changes:     26-05-2023
##
#####################################################################################X
##
##    Content:          Function "EnvArEst ()"
##    
##    Source:           R-Script derived from Excel workbooks / worksheets 
##                      "[EnergyProfile.xlsm]Data.out.TABULA"
##                      "[tabula-calculator.xlsx]Calc.Set.Building"   
##  
#####################################################################################X



#####################################################################################X
##  Dependencies / requirements ------
# 
#   Script "AuxFunctions.R"
#   Script "AuxConstants.R"



#####################################################################################X
## FUNCTION "EnvArEst ()" -----
#####################################################################################X



EnvArEst <- function (
    myInputData, 
    myCalcData, 
    ParTab_EnvArEst
) {
  
  cat ("EnvArEst ()", fill = TRUE)
  
  ###################################################################################X
  # 1  DESCRIPTION   -----
  ###################################################################################X
  
  # This function estimates the surface envelope area of buildings
  # using information about size and geometrical features ("energy profile indicators").  
  # The method provides input data for the energy performance calculation. 
  
  
  
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
  ##  Preparation  -----
  ###################################################################################X
  
  
  ###################################################################################X
  ###  Preparation of dataframe -----

  ## Assign values to the data frame used for all variables and auxiliary quantities
  ## "Data_Calc_EnvArEst"

  Data_Calc_EnvArEst <- as.data.frame (myInputData$ID_Dataset)
  colnames (Data_Calc_EnvArEst) <- "ID_Dataset"


  ###################################################################################X
  ###  Replace NA and _NA_ by default values  ----------------------------------

  ## Notice: The input for empty data fields is only used for the envelope area estimation, 
  ## the entered indicators must not be used for statistical evaluation 
  ## of the characteristics of the respective building stock 
  ## and should thus not be stored in the monitoring table.
  
  Data_Calc_EnvArEst$A_C_Floor_Intake <-
    ifelse (is.na (myInputData$A_C_Floor_Intake),
            0,
            myInputData$A_C_Floor_Intake)
  
  Data_Calc_EnvArEst$Code_TypeFloorArea_A_C_Floor_Intake <-
    ifelse (
      myInputData$Code_TypeFloorArea_A_C_Floor_Intake == "_NA_",
      "A_C_Living",
      myInputData$Code_TypeFloorArea_A_C_Floor_Intake
    )
  
  Data_Calc_EnvArEst$Code_BuildingPart_A_C_Floor_Intake <-
    ifelse (
      myInputData$Code_BuildingPart_A_C_Floor_Intake == "_NA_",
      "Building",
      myInputData$Code_BuildingPart_A_C_Floor_Intake
    )
  
  Data_Calc_EnvArEst$n_Block <-
    ifelse ((is.na (myInputData$n_Block)) |
              (myInputData$n_Block == 0), 1, myInputData$n_Block)
  
  Data_Calc_EnvArEst$n_Dwelling <-
    ifelse (
      is.na (myInputData$n_Dwelling),
      ifelse (
        Data_Calc_EnvArEst$Code_BuildingPart_A_C_Floor_Intake == "Building",
        round (Data_Calc_EnvArEst$A_C_Floor_Intake / 80) + 1,
        round (Data_Calc_EnvArEst$A_C_Floor_Intake * myInputData$n_Storey / 80) + 1
      ),
      myInputData$n_Dwelling
    )
  # Assumption in case of NA input: Typical size of a dwelling 80 m?
  
  Data_Calc_EnvArEst$n_Storey <-
    ifelse (is.na (myInputData$n_Storey),
            min (4, round (myInputData$n_Dwelling / 3, digits = 0) +
                   1),
            myInputData$n_Storey)
  # Assumptions in case of NA input: 1 dwelling --> 1 storey, 2 dwellings --> 2 storeys,
  # 3 and more dwellings --> 3 dwellings per storey, but less than 5 storeys
  
  Data_Calc_EnvArEst$Code_AttachedNeighbours <-
    ifelse (
      myInputData$Code_AttachedNeighbours == "_NA_",
      "N1",
      myInputData$Code_AttachedNeighbours
    )
  # Assumption in case of NA input: 1 attached neighbour building
  
  Data_Calc_EnvArEst$Code_ComplexFootprint <-
    ifelse (
      myInputData$Code_ComplexFootprint == "_NA_",
      "Standard",
      myInputData$Code_ComplexFootprint
    )
  # Assumption in case of NA input: standard footprint
  
  Data_Calc_EnvArEst$Code_CellarCond <-
    ifelse (myInputData$Code_CellarCond == "_NA_",
            "N",
            myInputData$Code_CellarCond)
  # Assumption in case of NA input: Cellar not conditioned
  
  Data_Calc_EnvArEst$Indicator_Cellar_Insulated <-
    ifelse (
      is.na(myInputData$Indicator_Cellar_Insulated),
      0,
      myInputData$Indicator_Cellar_Insulated
    )
  # Assumption in case of NA input: Cellar floor and walls not insulated
  
  Data_Calc_EnvArEst$Code_AtticCond <-
    ifelse (
      myInputData$Code_AtticCond == "_NA_",
      ifelse(Data_Calc_EnvArEst$n_Storey >= 3, "N", "C"),
      myInputData$Code_AtticCond
    )
  # Assumption in case of NA input: 
  # 1 or 2 full storeys -> attic conditioned; 
  # 3 and more full storeys --> Attic not conditioned
  
  Data_Calc_EnvArEst$Code_ComplexRoof <-
    ifelse (myInputData$Code_ComplexRoof == "_NA_",
            "Standard",
            myInputData$Code_ComplexRoof)
  # Assumption in case of NA input: standard
  
  Data_Calc_EnvArEst$h_Ceiling <-
    ifelse (is.na (myInputData$h_Ceiling) |
              myInputData$h_Ceiling == 0,
            2.5,
            myInputData$h_Ceiling)
  # Assumption in case of NA input: 2.5 m
  
  Data_Calc_EnvArEst$d_Insulation_Roof <-
    ifelse (is.na (myInputData$d_Insulation_Roof),
            0,
            myInputData$d_Insulation_Roof)
  # Assumption in case of NA input: 0 cm
  
  Data_Calc_EnvArEst$d_Insulation_Ceiling <-
    ifelse (is.na (myInputData$d_Insulation_Ceiling),
            0,
            myInputData$d_Insulation_Ceiling)
  # Assumption in case of NA input: 0 cm
  
  Data_Calc_EnvArEst$d_Insulation_Floor <-
    ifelse (is.na (myInputData$d_Insulation_Floor),
            0,
            myInputData$d_Insulation_Floor)
  # Assumption in case of NA input: 0 cm
  
  Data_Calc_EnvArEst$f_Insulation_Roof <-
    ifelse (is.na (myInputData$f_Insulation_Roof),
            0,
            myInputData$f_Insulation_Roof)
  # Assumption in case of NA input: 0
  
  Data_Calc_EnvArEst$f_Insulation_Ceiling <-
    ifelse (is.na (myInputData$f_Insulation_Ceiling),
            0,
            myInputData$f_Insulation_Ceiling)
  # Assumption in case of NA input: 0
  
  Data_Calc_EnvArEst$f_Insulation_Floor <-
    ifelse (is.na (myInputData$f_Insulation_Floor),
            0,
            myInputData$f_Insulation_Floor)
  # Assumption in case of NA input: 0
  
  #View (Data_Calc_EnvArEst)

  #. ---------------------------------------------------------------------------------
  
  
  ###################################################################################X
  ## Estimation of envelope surface area  ------------------------------------
  ###################################################################################X
  
    
  ###################################################################################X
  ## . Step 1 - Thermal envelope location basement and attic ----------------------

  ## (a) Location of the thermal envelope in the basement / cellar

  Data_Calc_EnvArEst$Code_CellarCondEnv  <- 
    paste (Data_Calc_EnvArEst$Code_CellarCond,
  				ifelse ((Data_Calc_EnvArEst$Code_CellarCond == "N" | 
  				           Data_Calc_EnvArEst$Code_CellarCond == "P") &
  								Data_Calc_EnvArEst$Indicator_Cellar_Insulated == 1 &
  								Data_Calc_EnvArEst$d_Insulation_Floor >= 2.0 &
  								Data_Calc_EnvArEst$f_Insulation_Floor >= 0.9, "I",""), sep="")
  # New variable based on Code_CellarCond
  
  ## (b) Location of the thermal envelope in the attic
  
  Data_Calc_EnvArEst$Code_AtticCondEnv  <- 
    paste (Data_Calc_EnvArEst$Code_AtticCond,
  				ifelse ((Data_Calc_EnvArEst$Code_AtticCond == "N" | 
  				           Data_Calc_EnvArEst$Code_AtticCond == "P") &
  								Data_Calc_EnvArEst$d_Insulation_Roof >= 2.0 &
  								Data_Calc_EnvArEst$f_Insulation_Roof >= 0.9  &
  								Data_Calc_EnvArEst$d_Insulation_Ceiling < 2.0 &
  								Data_Calc_EnvArEst$f_Insulation_Ceiling < 0.1, "I",""), sep="")
  		# New variable based on Code_AtticCond
  
  
  ###################################################################################X
  ## . Step 2 - Effective number of storeys -----------------------------------
  
  ## Effective number of conditioned storeys - with respect to the allocation 
  ## of reference area (n_Storey_Eff_Cond)
  
  Data_Calc_EnvArEst$f_CellarCond <- NA
  Data_Calc_EnvArEst$f_CellarCond <- 0
  Data_Calc_EnvArEst$f_CellarCond <-
    ifelse (Data_Calc_EnvArEst$Code_CellarCond == "P",
            0.5,
            Data_Calc_EnvArEst$f_CellarCond)
  Data_Calc_EnvArEst$f_CellarCond <-
    ifelse (Data_Calc_EnvArEst$Code_CellarCond == "C",
            1.0,
            Data_Calc_EnvArEst$f_CellarCond)
  
  Data_Calc_EnvArEst$f_AtticCond <- NA
  Data_Calc_EnvArEst$f_AtticCond <- 0
  Data_Calc_EnvArEst$f_AtticCond <-
    ifelse (Data_Calc_EnvArEst$Code_AtticCond == "P",
            0.5,
            Data_Calc_EnvArEst$f_AtticCond)
  Data_Calc_EnvArEst$f_AtticCond <-
    ifelse (Data_Calc_EnvArEst$Code_AtticCond == "C",
            1.0,
            Data_Calc_EnvArEst$f_AtticCond)
  
  Data_Calc_EnvArEst$n_Storey_Eff_Cond <-
    Data_Calc_EnvArEst$f_CellarCond + Data_Calc_EnvArEst$n_Storey + 
    0.7 * Data_Calc_EnvArEst$f_AtticCond
  #print (Data_Calc_EnvArEst$n_Storey_Eff_Cond)
  
  ## Effective number of thermally enveloped storeys (n_Storey_Eff_Env)
  
  Data_Calc_EnvArEst$f_CellarEnv <- NA
  Data_Calc_EnvArEst$f_CellarEnv <- 0
  Data_Calc_EnvArEst$f_CellarEnv <-
    ifelse (Data_Calc_EnvArEst$Code_CellarCondEnv == "P",
            0.5,
            Data_Calc_EnvArEst$f_CellarEnv)
  Data_Calc_EnvArEst$f_CellarEnv <-
    ifelse (
      Data_Calc_EnvArEst$Code_CellarCondEnv == "C"  |
        Data_Calc_EnvArEst$Code_CellarCondEnv == "PI" |
        Data_Calc_EnvArEst$Code_CellarCondEnv == "NI",
      1.0,
      Data_Calc_EnvArEst$f_CellarEnv
    )
  
  Data_Calc_EnvArEst$f_AtticEnv <- NA
  Data_Calc_EnvArEst$f_AtticEnv <- 0
  Data_Calc_EnvArEst$f_AtticEnv <-
    ifelse (Data_Calc_EnvArEst$Code_AtticCondEnv == "P",
            0.5,
            Data_Calc_EnvArEst$f_AtticEnv)
  Data_Calc_EnvArEst$f_AtticEnv <-
    ifelse (
      Data_Calc_EnvArEst$Code_AtticCondEnv == "C" |
        Data_Calc_EnvArEst$Code_AtticCondEnv == "PI" |
        Data_Calc_EnvArEst$Code_AtticCondEnv == "NI",
      1.0,
      Data_Calc_EnvArEst$f_AtticEnv
    )
  
  Data_Calc_EnvArEst$n_Storey_Eff_Env <-
    Data_Calc_EnvArEst$f_CellarEnv + Data_Calc_EnvArEst$n_Storey + 
    0.7 * Data_Calc_EnvArEst$f_AtticEnv
  #print (Data_Calc_EnvArEst$n_Storey_Eff_Env)
  
  
  ###################################################################################X
  ## . Step 3 - TABULA reference area (total area and area per storey) --------
  
  ## Conversion from different area types
  
  Data_Calc_EnvArEst$f_Conversion_FloorArea <-
    1.0 # Case "A_C_Ref" and "A_C_IntDim"
  Data_Calc_EnvArEst$f_Conversion_FloorArea <-
    ifelse (
      Data_Calc_EnvArEst$Code_TypeFloorArea_A_C_Floor_Intake == "A_C_Ext_Dim",
      0.85,
      Data_Calc_EnvArEst$f_Conversion_FloorArea
    )
  Data_Calc_EnvArEst$f_Conversion_FloorArea <-
    ifelse (
      Data_Calc_EnvArEst$Code_TypeFloorArea_A_C_Floor_Intake == "A_C_Use",
      1.4,
      Data_Calc_EnvArEst$f_Conversion_FloorArea
    )
  Data_Calc_EnvArEst$f_Conversion_FloorArea <-
    ifelse (
      Data_Calc_EnvArEst$Code_TypeFloorArea_A_C_Floor_Intake == "A_C_Living",
      1.1 ,
      Data_Calc_EnvArEst$f_Conversion_FloorArea
    )
  Data_Calc_EnvArEst$f_Conversion_FloorArea <-
    ifelse (
      Data_Calc_EnvArEst$Code_TypeFloorArea_A_C_Floor_Intake == "V_C",
      0.85 / 3.0 ,
      Data_Calc_EnvArEst$f_Conversion_FloorArea
    )
  
  ## Conversion if entered area is related to the footprint of the building 
  ## (represents basement area instead of total area)
  
  Data_Calc_EnvArEst$f_Conversion_FloorArea <-
    ifelse (
      Data_Calc_EnvArEst$Code_BuildingPart_A_C_Floor_Intake == "Storey",
      Data_Calc_EnvArEst$n_Storey_Eff_Cond,
      1
    ) * Data_Calc_EnvArEst$f_Conversion_FloorArea
  
  ## TABULA reference floor area
  Data_Calc_EnvArEst$A_C_Ref <-
    Data_Calc_EnvArEst$f_Conversion_FloorArea * Data_Calc_EnvArEst$A_C_Floor_Intake
  
  ## Reference area per storey (important auxiliary quantity)
  Data_Calc_EnvArEst$A_C_Storey <-
    Data_Calc_EnvArEst$A_C_Ref / Data_Calc_EnvArEst$n_Storey_Eff_Cond
  
  ## Special case: Combination of "A_C_Ext_Dim" and reference "Storey" 
  ## (inversion of envelope area estimation, e.g. in case of GIS data use)
  Data_Calc_EnvArEst$A_C_Storey <-
    ifelse (
      Data_Calc_EnvArEst$Code_TypeFloorArea_A_C_Floor_Intake == "A_C_Ext_Dim" &
        Data_Calc_EnvArEst$Code_BuildingPart_A_C_Floor_Intake == "Storey",
      (
        myInputData$A_C_Floor_Intake - Data_Calc_EnvArEst$n_Block * ParTab_EnvArEst$q_Floor
      ) / ParTab_EnvArEst$p_Floor,
      Data_Calc_EnvArEst$A_C_Storey
    )
  Data_Calc_EnvArEst$A_C_Ref <-
    Data_Calc_EnvArEst$n_Storey_Eff_Cond * Data_Calc_EnvArEst$A_C_Storey # (no condition needed, assignment always correct)
  #print (Data_Calc_EnvArEst$A_C_Ref)
  
  Data_Calc_EnvArEst$A_GIA_Env <-
    Data_Calc_EnvArEst$A_C_Ref * Data_Calc_EnvArEst$n_Storey_Eff_Env / 
    Data_Calc_EnvArEst$n_Storey_Eff_Cond   
  # 2021-06-04 / iwu / tl: Formula supplemented
  #print (Data_Calc_EnvArEst$A_GIA_Env)
  
  
  ###################################################################################X
  ## . Step 4 - Horizontal thermal envelope area at the bottom ----------------
  
  ## Estimate the horizontal thermal envelope area at the bottom of a building
  ## ground floor area / floor area adjacent to cellar or soil (A_Estim_Floor_1)
  
  Data_Calc_EnvArEst$A_Estim_Floor_1 <- 0
  
  Data_Calc_EnvArEst$A_Estim_Floor_1 <-
    ParTab_EnvArEst$p_Floor * Data_Calc_EnvArEst$A_C_Storey +
    Data_Calc_EnvArEst$n_Block * ParTab_EnvArEst$q_Floor
  
  Data_Calc_EnvArEst$A_Estim_Floor_2 <-
    0 # data field currently not used by estimation
  
  
  
  ###################################################################################X
  ## . Step 5 - Horizontal or sloped thermal envelope area at the top -------
  
  ## Estimate of the roof and ceiling area defining the thermal envelope at the top of a building
  
  ## Parameters for roof area estimation
  Data_Calc_EnvArEst$p_Roof <- 0
  Data_Calc_EnvArEst$p_Roof <-
    ifelse (
      Data_Calc_EnvArEst$Code_AtticCondEnv == "-",
      ParTab_EnvArEst$p_Roof_FR,
      Data_Calc_EnvArEst$p_Roof
    ) # Flat roof / no attic
  Data_Calc_EnvArEst$p_Roof <-
    ifelse (
      Data_Calc_EnvArEst$Code_AtticCondEnv == "P",
      ParTab_EnvArEst$p_Roof_P,
      Data_Calc_EnvArEst$p_Roof
    ) # Attic partly enclosed by thermal envelope
  Data_Calc_EnvArEst$p_Roof <-
    ifelse (
      Data_Calc_EnvArEst$Code_AtticCondEnv == "C" |
        Data_Calc_EnvArEst$Code_AtticCondEnv == "PI" |
        Data_Calc_EnvArEst$Code_AtticCondEnv == "NI",
      ParTab_EnvArEst$p_Roof_C,
      Data_Calc_EnvArEst$p_Roof
    )  # Attic completely enclosed by thermal envelope
  Data_Calc_EnvArEst$q_Roof <- 0
  Data_Calc_EnvArEst$q_Roof <-
    ifelse (
      Data_Calc_EnvArEst$Code_AtticCondEnv == "-",
      ParTab_EnvArEst$q_Roof_FR,
      Data_Calc_EnvArEst$q_Roof
    ) # Flat roof / no attic
  Data_Calc_EnvArEst$q_Roof <-
    ifelse (
      Data_Calc_EnvArEst$Code_AtticCondEnv == "P",
      ParTab_EnvArEst$q_Roof_P,
      Data_Calc_EnvArEst$q_Roof
    ) # Attic partly enclosed by thermal envelope
  Data_Calc_EnvArEst$q_Roof <-
    ifelse (
      Data_Calc_EnvArEst$Code_AtticCondEnv == "C" |
        Data_Calc_EnvArEst$Code_AtticCondEnv == "PI" |
        Data_Calc_EnvArEst$Code_AtticCondEnv == "NI",
      ParTab_EnvArEst$q_Roof_C,
      Data_Calc_EnvArEst$q_Roof
    )  # Attic completely enclosed by thermal envelope
  
  ## Parameters for top ceiling area estimation
  Data_Calc_EnvArEst$p_Ceiling <- 0
  Data_Calc_EnvArEst$p_Ceiling <-
    ifelse (
      Data_Calc_EnvArEst$Code_AtticCondEnv == "N",
      ParTab_EnvArEst$p_Ceiling_N,
      Data_Calc_EnvArEst$p_Ceiling
    ) # Attic not included in thermal envelope
  Data_Calc_EnvArEst$p_Ceiling <-
    ifelse (
      Data_Calc_EnvArEst$Code_AtticCondEnv == "P",
      ParTab_EnvArEst$p_Ceiling_P,
      Data_Calc_EnvArEst$p_Ceiling
    ) # Attic partly enclosed by thermal envelope
  Data_Calc_EnvArEst$q_Ceiling <- 0
  Data_Calc_EnvArEst$q_Ceiling <-
    ifelse (
      Data_Calc_EnvArEst$Code_AtticCondEnv == "N",
      ParTab_EnvArEst$q_Ceiling_N,
      Data_Calc_EnvArEst$q_Ceiling
    ) # Attic not included in thermal envelope
  Data_Calc_EnvArEst$q_Ceiling <-
    ifelse (
      Data_Calc_EnvArEst$Code_AtticCondEnv == "P",
      ParTab_EnvArEst$q_Ceiling_P,
      Data_Calc_EnvArEst$q_Ceiling
    ) # Attic partly enclosed by thermal envelope
  
  ## Factor considering the complexity of the roof
  Data_Calc_EnvArEst$f_ComplexRoof <- 1
  Data_Calc_EnvArEst$f_ComplexRoof <-
    ifelse (
      Data_Calc_EnvArEst$Code_ComplexRoof == "Simple",
      ifelse (Data_Calc_EnvArEst$Code_AtticCond == "-",
        1,
        ParTab_EnvArEst$f_ComplexRoof_Min),
        Data_Calc_EnvArEst$f_ComplexRoof
    )
  Data_Calc_EnvArEst$f_ComplexRoof <-
    ifelse (
      Data_Calc_EnvArEst$Code_ComplexRoof == "Complex",
      ParTab_EnvArEst$f_ComplexRoof_Max,
      Data_Calc_EnvArEst$f_ComplexRoof
    )
  
  ## Estimated roof area (A_Estim_Roof_1)
  Data_Calc_EnvArEst$A_Estim_Roof_1 <- 0
  Data_Calc_EnvArEst$A_Estim_Roof_1 <-
    Data_Calc_EnvArEst$f_ComplexRoof * (
      Data_Calc_EnvArEst$p_Roof * Data_Calc_EnvArEst$A_C_Storey +
        Data_Calc_EnvArEst$n_Block * Data_Calc_EnvArEst$q_Roof
    )
  
  ## Estimated top ceiling area (A_Estim_Roof_2)
  Data_Calc_EnvArEst$A_Estim_Roof_2 <- 0
  Data_Calc_EnvArEst$A_Estim_Roof_2 <-
    Data_Calc_EnvArEst$p_Ceiling * Data_Calc_EnvArEst$A_C_Storey +
    Data_Calc_EnvArEst$n_Block * Data_Calc_EnvArEst$q_Ceiling
  # Test
  #(Data_Calc_EnvArEst$A_Estim_Roof_1 + Data_Calc_EnvArEst$A_Estim_Roof_2) / Data_Calc_EnvArEst$A_C_Storey
  
  
  ###################################################################################X
  ## . Step 6 - Gross fa?ade area per storey ----------------------------------
  
  ## Parameters
  Data_Calc_EnvArEst$p_GrossWall <- ParTab_EnvArEst$p_GrossWall
  Data_Calc_EnvArEst$q_GrossWall <-
    ParTab_EnvArEst$q_GrossWall_N1 # 1 directly attached building
  Data_Calc_EnvArEst$q_GrossWall <-
    ifelse (
      Data_Calc_EnvArEst$Code_AttachedNeighbours == "N0",
      ParTab_EnvArEst$q_GrossWall_N0,
      Data_Calc_EnvArEst$q_GrossWall
    ) # detached building
  Data_Calc_EnvArEst$q_GrossWall <-
    ifelse (
      Data_Calc_EnvArEst$Code_AttachedNeighbours == "N2",
      ParTab_EnvArEst$q_GrossWall_N2,
      Data_Calc_EnvArEst$q_GrossWall
    ) # 2 directly attached buildings
  
  ## Ceiling height factor
  Data_Calc_EnvArEst$f_CeilingHeight <-
    Data_Calc_EnvArEst$h_Ceiling / 2.5
  
  ## Factor considering the complexity of the footprint
  Data_Calc_EnvArEst$f_ComplexFootprint <- 1
  Data_Calc_EnvArEst$f_ComplexFootprint <-
    ifelse (
      Data_Calc_EnvArEst$Code_ComplexFootprint == "Simple",
      ParTab_EnvArEst$f_ComplexFootprint_Min,
      Data_Calc_EnvArEst$f_ComplexFootprint
    )
  Data_Calc_EnvArEst$f_ComplexFootprint <-
    ifelse (
      Data_Calc_EnvArEst$Code_ComplexFootprint == "Complex",
      ParTab_EnvArEst$f_ComplexFootprint_Max,
      Data_Calc_EnvArEst$f_ComplexFootprint
    )
  
  ## Estimated gross fa?ade area per storey (A_Facade_Storey)
  Data_Calc_EnvArEst$A_Facade_Storey <- 0
  Data_Calc_EnvArEst$A_Facade_Storey <-
    Data_Calc_EnvArEst$f_CeilingHeight * Data_Calc_EnvArEst$f_ComplexFootprint *
    (
      Data_Calc_EnvArEst$p_GrossWall * Data_Calc_EnvArEst$A_C_Storey + 
        Data_Calc_EnvArEst$n_Block * Data_Calc_EnvArEst$q_GrossWall
    )
  
  
  ###################################################################################X
  ## . Step 7 - Windows and doors ---------------------------------------------
  
  ## Parameters
  Data_Calc_EnvArEst$p_Door <- ParTab_EnvArEst$p_Door
  Data_Calc_EnvArEst$q_Door <- ParTab_EnvArEst$q_Door
  Data_Calc_EnvArEst$p_Window <- ParTab_EnvArEst$p_Window
  
  ## Estimated surface area of external doors
  Data_Calc_EnvArEst$A_Estim_Door_1 <-
    Data_Calc_EnvArEst$p_Door * Data_Calc_EnvArEst$A_C_Ref + Data_Calc_EnvArEst$n_Block * Data_Calc_EnvArEst$q_Door
  
  ## Estimated surface area of windows
  Data_Calc_EnvArEst$A_Estim_Window_1 <-
    Data_Calc_EnvArEst$p_Window * Data_Calc_EnvArEst$A_C_Ref - Data_Calc_EnvArEst$A_Estim_Door_1
  Data_Calc_EnvArEst$A_Estim_Window_2 <- 0
  
  
  ###################################################################################X
  ## . Step 8 - Walls ---------------------------------------------------------
  
  ## Parameters
  
  ## Estimated wall area adjacent to soil
  Data_Calc_EnvArEst$A_Estim_Wall_2 <-
    0.5 * Data_Calc_EnvArEst$f_CellarEnv * Data_Calc_EnvArEst$A_Facade_Storey
  
  ## Estimated wall area adjacent to external air
  Data_Calc_EnvArEst$A_Estim_Wall_1 <-
    (Data_Calc_EnvArEst$n_Storey_Eff_Env * Data_Calc_EnvArEst$A_Facade_Storey) - 	Data_Calc_EnvArEst$A_Estim_Wall_2 -
    Data_Calc_EnvArEst$A_Estim_Window_1 - Data_Calc_EnvArEst$A_Estim_Door_1
  
  ## Third wall area part not used
  Data_Calc_EnvArEst$A_Estim_Wall_3 <- 0
  
  
  ###################################################################################X
  ## . Step 9 - Building volume -----------------------------------------------
  
  ## Estimated conditioned gross building volume
  Data_Calc_EnvArEst$V_Estim_C_Gross <-
    3.5 * Data_Calc_EnvArEst$f_CeilingHeight * Data_Calc_EnvArEst$A_C_Ref
  
  #. --------------------------------------------------------------------------------
  
  
  
  ###################################################################################X
  #  4  OUTPUT   -----
  ###################################################################################X
  
  Data_Calc_EnvArEst$A_Estim_Wall_4 <-
    Data_Calc_EnvArEst$A_Estim_Wall_1
  
  Data_Calc_EnvArEst$A_Estim_Total <-
    Data_Calc_EnvArEst$A_Estim_Roof_1 + Data_Calc_EnvArEst$A_Estim_Roof_2 +
    Data_Calc_EnvArEst$A_Estim_Wall_1 + Data_Calc_EnvArEst$A_Estim_Wall_2 +
    Data_Calc_EnvArEst$A_Estim_Wall_3 +
    Data_Calc_EnvArEst$A_Estim_Floor_1 + Data_Calc_EnvArEst$A_Estim_Floor_2 +
    Data_Calc_EnvArEst$A_Estim_Window_1 + Data_Calc_EnvArEst$A_Estim_Window_2 +
    Data_Calc_EnvArEst$A_Estim_Door_1
  #print (Data_Calc_EnvArEst$A_Estim_Total)
  
  i_Col_Double <-
    which (colnames (Data_Calc_EnvArEst) %in% colnames (myInputData))
  
  Data_Calc_EnvArEst <-
    cbind (myInputData, Data_Calc_EnvArEst [, -i_Col_Double])
  #colnames(Data_Calc_EnvArEst)
  
  
  
  ###################################################################################X
  ##  . Assign results to the dataframe "myCalcData"  ------
  
  ## . Output variables  
  
  myCalcData$ID_Dataset                               <- Data_Calc_EnvArEst$ID_Dataset
  myCalcData$Date_Change                              <- TimeStampForDataset ()
  myCalcData$Remark_Model1_01                         <- Data_Calc_EnvArEst$Remark_Model1_01
  myCalcData$Remark_Model1_02                         <- Data_Calc_EnvArEst$Remark_Model1_02
  myCalcData$Date_Model1_Change                       <- Data_Calc_EnvArEst$Date_Model1_Change
  myCalcData$Code_CellarCondEnv                       <- Data_Calc_EnvArEst$Code_CellarCondEnv
  myCalcData$Code_AtticCondEnv                        <- Data_Calc_EnvArEst$Code_AtticCondEnv
  myCalcData$f_CellarCond                             <- round (Data_Calc_EnvArEst$f_CellarCond, digits = 3)
  myCalcData$f_AtticCond                              <- round (Data_Calc_EnvArEst$f_AtticCond, digits = 3)
  myCalcData$n_Storey_Eff_Cond                        <- round (Data_Calc_EnvArEst$n_Storey_Eff_Cond, digits = 3)
  myCalcData$f_CellarEnv                              <- round (Data_Calc_EnvArEst$f_CellarEnv, digits = 3)
  myCalcData$f_AtticEnv                               <- round (Data_Calc_EnvArEst$f_AtticEnv, digits = 3)
  myCalcData$n_Storey_Eff_Env                         <- round (Data_Calc_EnvArEst$n_Storey_Eff_Env, digits = 3)
  myCalcData$f_Conversion_FloorArea                   <- round (Data_Calc_EnvArEst$f_Conversion_FloorArea, digits = 3)
  myCalcData$A_C_Storey                               <- round (Data_Calc_EnvArEst$A_C_Storey, digits = 1)
  myCalcData$A_GIA_Env                                <- round (Data_Calc_EnvArEst$A_GIA_Env, digits = 1)
  myCalcData$A_C_Ref                           <- round (Data_Calc_EnvArEst$A_C_Ref, digits = 1)
  myCalcData$Code_Model1_Type_EnvelopeArea            <- Data_Calc_EnvArEst$Code_Model1_Type_EnvelopeArea
  myCalcData$V_Estim_C_Gross                          <- round (Data_Calc_EnvArEst$V_Estim_C_Gross, digits = 1)
  myCalcData$A_Estim_Roof_01                          <- round (Data_Calc_EnvArEst$A_Estim_Roof_1, digits = 1)
  myCalcData$A_Estim_Roof_02                          <- round (Data_Calc_EnvArEst$A_Estim_Roof_2, digits = 1)
  myCalcData$A_Estim_Wall_01                          <- round (Data_Calc_EnvArEst$A_Estim_Wall_1, digits = 1)
  myCalcData$A_Estim_Wall_02                          <- round (Data_Calc_EnvArEst$A_Estim_Wall_2, digits = 1)
  myCalcData$A_Estim_Wall_03                          <- round (Data_Calc_EnvArEst$A_Estim_Wall_3, digits = 1)
  myCalcData$A_Estim_Floor_01                         <- round (Data_Calc_EnvArEst$A_Estim_Floor_1, digits = 1)
  myCalcData$A_Estim_Floor_02                         <- round (Data_Calc_EnvArEst$A_Estim_Floor_2, digits = 1)
  myCalcData$A_Estim_Window_01                        <- round (Data_Calc_EnvArEst$A_Estim_Window_1, digits = 1)
  myCalcData$A_Estim_Window_02                        <- round (Data_Calc_EnvArEst$A_Estim_Window_2, digits = 1)
  myCalcData$A_Estim_Door_01                          <- round (Data_Calc_EnvArEst$A_Estim_Door_1, digits = 1)
  
  myCalcData$A_Estim_Total                   <- round (Data_Calc_EnvArEst$A_Estim_Total, digits = 1)
  
  # Data_Calc_EnvArEst <- NA # Save memory
  

  return (myCalcData)

} # End of function 


## End of the function EnvArEst () -----
#####################################################################################X


#.------------------------------------------------------------------------------------




