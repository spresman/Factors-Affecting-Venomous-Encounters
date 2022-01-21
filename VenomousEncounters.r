fulltable <- read.csv("C:/Users/sam/Downloads/FullTable.csv")

#Log transformed venomous encounters data (Outcome variable)
venom <- fulltable$Log.of.Venom.Encounters

#Log transformed population density data
density <- fulltable$Log.of.Population.Density

#Log transformed terrestrial protected areas data
terrestrial <- fulltable$Log.of.Terrestrial.Protected.areas

#Log transformed number of endemic species data
endemic <- fulltable$Log.of.Total.Endemic.Species...1

#Three-way anova testing statistical interactions 
three.way <- aov(venom ~ terrestrial + endemic + density, data=fulltable)

summary(three.way)
