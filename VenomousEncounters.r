fulltable <- read.csv("C:/Users/sam/Downloads/FullTable.csv")


venom <- fulltable$Log.of.Venom.Encounters

density <- fulltable$Log.of.Population.Density

terrestrial <- fulltable$Log.of.Terrestrial.Protected.areas

endemic <- fulltable$Log.of.Total.Endemic.Species...1


three.way <- aov(venom ~ terrestrial + endemic + density, data=fulltable)

summary(three.way)
