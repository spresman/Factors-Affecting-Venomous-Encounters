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
--NOTE: Only data from the year 2017 was used, and data was log-transformed (normalized) for better visualization. 

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

SELECT VenInc.Entity, VenInc.[Log of Venomous Contact Per km²]
FROM VenInc

SELECT *
FROM PopulationDensityVenom..['terrestrial-protected-areas$']
WHERE Year = 2017
ORDER BY 1


SELECT Terr.Entity, Terr.[Terrestrial protected areas (% of total land area)], 
LOG(Venom.[Incidence - Venomous animal contact - Sex: Both - Age: Age-stand]) AS [Log of Venomous Contact]

FROM PopulationDensityVenom..['terrestrial-protected-areas$'] Terr
INNER JOIN PopulationDensityVenom..['incidence-of-venomous-animal-co$'] Venom 
	ON Terr.Entity= Venom.Entity
JOIN PopulationDensityVenom..
WHERE Terr.Year= 2017 AND Venom.Year = 2017
