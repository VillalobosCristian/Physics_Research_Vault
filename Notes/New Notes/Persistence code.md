Everything is kept as usual to extract trajectories from trackmate data.
I remove tracks that are shorter than 10 time steps (depending on the framerate). 

### Persistence
To distiguish between random events from more persistence interaction I'll create a connection history of the particles. 

- For each time point, record which specific particle is connected. 
```m