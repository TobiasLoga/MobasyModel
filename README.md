# MobasyModel

### Estimate the energy consumption for heating and DHW by use of a physical model including uncertainty assessment

The package MobasyModel consists of a physical model for calculating the energy demand for heating and domestic hot water.
Monitoring indicators (Energy Profile Indicators) or detailed building data may be used as input data.

For a simple energy performance calculation the function **EnergyProfileCalc ()** can be used, which includes 

- an estimation of the envelope surface area

- an estimation of U-values

- an energy performance calculation (building and heat supply system) providing the final energy demand (heating + domestic hot water)


The full MOBASY calculation is implemented by the function **MobasyCalc ()**, 
which includes in additin to the above mentioned elements:

- the use of the German local climate by postcode

- an uncertainty assessment

- a comparison with measured consumption data (target/actual comparison).


The building data used as input can be loaded from a local Excel file or from an RDA file (R package "MobasyBuildingData").

The main output data can be found in the data frame "Data_Output". 
Interim results are accessible in the data frame "Data_Calc".    


---

### Method

An overview of the method can be found in
Loga, Tobias; Stein, Britta; Behem, Guillaume. Use of Energy Profile Indicators to Determine
the Expected Range of Heating Energy Consumption; Proceedings of the Conference
"Central Europe towards Sustainable Building" 2022 (CESB22),
4 to 6 July 2022; Acta Polytechnica CTU Proceedings 38.470–477, 2022
ojs.cvut.cz/ojs/index.php/APP/article/view/8299/6839
doi.org/10.14311/APP.2022.38.0470

As a template for the R script the Excel package "EnergyProfile-xlsm.zip" was used.
Download at: https://www.iwu.de/forschung/energie/mobasy/ 
How ever the results may slightly differ due to different averaging procedures.  


---

### Usage

```r
library (MobasyModel)

```
---

### License

<a rel="license" href="https://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/80x15.png" /></a><br />This work is licensed under a <a rel="license" href="https://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

---


### Variables

A description of the input and output variables of the different functions 
can be found in the help section of the package.

---

