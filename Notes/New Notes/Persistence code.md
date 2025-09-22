Everything is kept as usual to extract trajectories from trackmate data.
I remove tracks that are shorter than 10 time steps (depending on the framerate). 

### Persistence
To distiguish between random events from more persistence interaction I'll create a connection history of the particles. 

- For each time point, record which specific particle is connected. 
```matlab
particle_history = cell(length(X), 1); % One cell per particle

for i = 1:length(X)

% Each particle gets an array: 1 = connected, 0 = not connected, -1 = not present

particle_history{i} = -ones(length(analysis_times), 1); % Start as "not present"

end
```
- `-1` = particle not present at this time
- `0` = particle present but not connected
- `1` = particle present and connected
---
Then loop over all the particles present at each time point and compute the distance between all the present particles, **use pdist** from matlab to avoid looping as $||\mathbf{R}||$ 
The same distance threshold that in the initial analysis is use to distiguish between the connected and not connected, and particle_history{i} is filled. 

```matlab 
% For each connected particle:

%1. Look backwards from current time

%2. Count consecutive connected frames

%3. Allow some gap tolerance (1 frame disconnection is OK)

%4. If >= 5 consecutive frames = "stable"

%5. If < 5 consecutive frames = "transient"
%%% key 

% Is this particle currently connected?

if particle_history{particle_idx}(t_idx) == 1 %yes

----


% Look backwards from current time

for k = t_idx:-1:1 % t inverse

if particle_history{particle_idx}(k) == 1

consecutive_frames = consecutive_frames + 1;

gap_count = 0; % Reset gap counter when connected

```

