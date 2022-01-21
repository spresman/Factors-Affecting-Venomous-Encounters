--Number of instances of venomous animal contact per 100,000 individuals in countries (2017). 
--Venomous animals include all animals which deliver toxins as venom through a bite or sting.

SELECT *
FROM PopulationDensityVenom..['incidence-of-venomous-animal-co$']
WHERE Year = 2017
ORDER BY 1

--The number of people per km² of land area in countries (2017).

SELECT *
FROM PopulationDensityVenom..['population-density$']
WHERE Year = 2017
ORDER BY 4

--Creating a table for countries and their venomous encounter data.

DROP TABLE IF EXISTS #VenomousIncidence
CREATE TABLE #VenomousIncidence
(
Country nvarchar(255),
[Log of Venomous Contact Per km²] numeric
)

--Inserting into Venom table.
--NOTE: Only data from the year 2017 was used, and data was log-transformed (normalized).

INSERT INTO #VenomousIncidence
SELECT Venom.Entity,
LOG(Venom.[Incidence - Venomous animal contact - Sex: Both - Age: Age-stand]
*Pop.[Population density (people per sq# km of land area)] / 100000) AS [Log of Venom Contact]

FROM PopulationDensityVenom..['incidence-of-venomous-animal-co$'] Venom
INNER JOIN PopulationDensityVenom..['population-density$'] Pop ON Venom.Entity= Pop.Entity
WHERE Venom.Year = 2017 AND Pop.Year = 2017
ORDER BY 1

--Creating a Population Density Venom view.

CREATE VIEW VenInc AS
SELECT Venom.Entity,
LOG(Venom.[Incidence - Venomous animal contact - Sex: Both - Age: Age-stand]
*Pop.[Population density (people per sq# km of land area)] / 100000) AS [Log of Venomous Contact Per km²]

FROM PopulationDensityVenom..['incidence-of-venomous-animal-co$'] Venom
INNER JOIN PopulationDensityVenom..['population-density$'] Pop ON Venom.Entity= Pop.Entity
WHERE Venom.Year = 2017 AND Pop.Year = 2017


--Sample select with just Venomous Contact Per km².

--SELECT Venom.Entity,
--Venom.[Incidence - Venomous animal contact - Sex: Both - Age: Age-stand]
--*Pop.[Population density (people per sq# km of land area)] / 100000 AS [Venomous Contact Per km²]

--FROM PopulationDensityVenom..['incidence-of-venomous-animal-co$'] Venom
--INNER JOIN PopulationDensityVenom..['population-density$'] Pop ON Venom.Entity= Pop.Entity
--WHERE Venom.Year = 2017 AND Pop.Year = 2017
--ORDER BY 1


--Data normalized and placed in a single view.
--NOTE: As some countries had no endemic species, log(x+1) was used to normalize instead of log(x).

CREATE VIEW EntireTable AS
SELECT Terr.Entity, 
LOG(Terr.[Terrestrial protected areas (% of total land area)]) AS [Log of Terrestrial Protected areas], 
LOG(Venom.[Incidence - Venomous animal contact - Sex: Both - Age: Age-stand]) AS [Log of Venom Encounters],
LOG(Endemic.[Total Endemic Species] +1) AS [Log of Total Endemic Species + 1],
LOG(Pop.[Population density (people per sq# km of land area)]) AS [Log of Population Density]

FROM PopulationDensityVenom..['terrestrial-protected-areas$'] Terr
INNER JOIN PopulationDensityVenom..['incidence-of-venomous-animal-co$'] Venom
	ON Terr.Entity= Venom.Entity
JOIN PopulationDensityVenom..['TotalEndemicSpecies$'] Endemic
	ON Terr.Entity= Endemic.Entity
JOIN PopulationDensityVenom..['population-density$'] Pop
	ON Pop.Entity = Terr.Entity
WHERE Terr.Year= 2017 and Venom.Year= 2017 and Pop.Year= 2017

SELECT * 
FROM EntireTable