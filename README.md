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

An overview of the method can be found in the following two articles:

Loga, Tobias; Stein, Britta; Behem, Guillaume. Use of Energy Profile Indicators to Determine
the Expected Range of Heating Energy Consumption; Proceedings of the Conference
"Central Europe towards Sustainable Building" 2022 (CESB22),
4 to 6 July 2022; Acta Polytechnica CTU Proceedings 38.470–477, 2022
ojs.cvut.cz/ojs/index.php/APP/article/view/8299/6839
doi.org/10.14311/APP.2022.38.0470

Loga, Tobias; Behem, Guillaume: Target/actual comparison and benchmarking used to safeguard low energy consumption in refurbished housing stocks; Proceedings of the eceee Summer Study 2021. https://www.researchgate.net/publication/355124720_Targetactual_comparison_and_benchmarking_used_to_safeguard_low_energy_consumption_in_refurbished_housing_stocks  


As a template for the R script the Excel package "EnergyProfile-xlsm.zip" was used.
Download at: https://www.iwu.de/forschung/energie/mobasy/ 
How ever the results may slightly differ due to different averaging procedures.  


For more detailed information the following reports and articles in German language are available: 

Loga, Tobias; Großklos, Marc; Müller, André; Swiderek, Stefan; Behem, Guillaume: Realbilanzierung für den Verbrauch-Bedarf-Vergleich (MOBASY Teilbericht). Realistische Bilanzierung und Quantifizierung von Unsicherheiten als Grundlage für den Soll-Ist-Vergleich beim Energieverbrauchscontrolling; IWU – Institut Wohnen und Umwelt, Darmstadt 2021; ISBN 978-3-941140-67-7; http://dx.doi.org/10.13140/RG.2.2.22472.24328/1  
https://www.iwu.de/fileadmin/publikationen/energie/mobasy/2021_IWU_LogaEtAl_MOBASY-Realbilanzierung-Verbrauch-Bedarf-Vergleich.pdf 

Loga, Tobias; Behem, Guillaume; Swiderek, Stefan; Stein, Britta: Verbrauchsbenchmarks für unterschiedliche Dämmstandards bei vermieteten Mehrfamilienhäusern (MOBASY-Teilbericht). Statistische Auswertung der MOBASY-Mehrfamilienhaus-Stichprobe; IWU – Institut Wohnen und Umwelt, Darmstadt 2022; ISBN 978-3-941140-73-8; 
DOI: http://dx.doi.org/10.13140/RG.2.2.19851.98087  
https://www.iwu.de/fileadmin/publikationen/energie/mobasy/2022_IWU_Loga-EtAl_Verbrauchsbenchmarks-Daemmstandards_MOBASY.pdf 

Loga, Tobias: Was hat der Energieverbrauch von Mehrfamilienhäusern mit dem Dämmstandard zu tun? IWU-Schlaglicht 02/2022; IWU – Institut Wohnen und Umwelt, Darmstadt 2022; ISBN 978-3-941140-73-8 https://www.iwu.de/fileadmin/publikationen/schlaglicht/2022_IWU_Loga_Schlaglicht_Energieverbrauch-von-MFH-und-Daemmstandard.pdf  

Loga, Tobias; Stein, Britta: Zusammenhang Energieverbrauch und Dämmstandard bei Mehrfamilienhäusern; Konferenzband der 14. EffizienzTagung Bauen+Modernisieren 11./12.11.2022; Energie- und Umweltzentrum am Deister e.u.[z.], Hannover 2022
https://www.iwu.de/fileadmin/publikationen/energie/mobasy/2022_EffizienzTagung_Loga-Stein_Zusammenhang-Energieverbrauch-und-Daemmstandard-bei-MFH.pdf  

Loga, Tobias; Großklos, Marc; Behem, Guillaume; Stein, Britta; Müller, André (2023): 
Unsicherheit der Energiebilanzierung und Vergleich mit Verbrauchsdaten für das PassivhausSozialPlus (MOBASY-Teilbericht). Verbrauchscontrolling auf der Grundlage von Energieprofil-Indikatoren im Vergleich zur Nutzung detaillierter Planungsdaten;
IWU – Institut Wohnen und Umwelt, Darmstadt 2023; ISBN 978-3-941140-77-6



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

