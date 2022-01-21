
--Create a view with total endemic species 

CREATE VIEW TotalEndemic AS
SELECT
Mammal.Entity,
Mammal.[Mammals (total endemic)]
+ Amphibian.[Amphibians (total endemic)]
+ Bird.[Birds (total endemic)]
+ Crab.[Freshwater crabs (total endemics)]
+ Reef.[Reef-forming corals (total endemics)]
+ Ray.[Sharks & Rays (total endemic)] AS [Total Endemic Species]

FROM EndemicSpecies..['endemic-mammal-species-by-count$'] Mammal
JOIN EndemicSpecies..['endemic-amphibian-species-by-co$'] Amphibian
	ON Mammal.Entity= Amphibian.Entity
JOIN EndemicSpecies..['endemic-bird-species-by-country$'] Bird
	ON Mammal.Entity= Bird.Entity
JOIN EndemicSpecies..['endemic-freshwater-crab-species$'] Crab
	ON Mammal.Entity= Crab.Entity
JOIN EndemicSpecies..['endemic-reef-forming-coral-spec$'] Reef
	ON Mammal.Entity= Reef.Entity
JOIN EndemicSpecies..['endemic-shark-and-ray-species$'] Ray
	ON Mammal.Entity= Ray.Entity


SELECT *
FROM TotalEndemic