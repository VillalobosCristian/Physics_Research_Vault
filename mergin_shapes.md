# **Merging Algorithm - Step by Step Explanation** 

Great question! This is a classic **gap-filling algorithm**. Let me break it down completely.

---

## **The Problem We're Solving**

After detecting events, we might have:

```
Frame:   1 ─────────────────────────────────────────────── 300

Events:  ■■■■■■■■■■         ■■■■■■■■■■         ■■■■■■■■
         Event 1            Event 2            Event 3
         100-120            135-155            280-295
              └─ gap: 15 ─┘      └─ gap: 125 ─┘
```

**Question:** Are Event 1 and Event 2 part of the **same deformation** with brief recovery?

**Answer:** If gap < 30 frames → YES, merge them!

---

## **The Data Structure**

`shape_zones` is a **matrix** where each row is one event:

```matlab
shape_zones = [
    100, 120;  % Row 1: Event 1 (start=100, end=120)
    135, 155;  % Row 2: Event 2 (start=135, end=155)
    280, 295   % Row 3: Event 3 (start=280, end=295)
];
```

**Columns:**

- Column 1: Start frame
- Column 2: End frame

**Rows:** Each row = one event

---

## **The Algorithm - Line by Line**

### **Line 1: Check if merging needed**

```matlab
if size(shape_zones, 1) > 1
```

**What this does:**

- `size(shape_zones, 1)` = number of rows = number of events
- If only 1 event → no merging needed
- If 2+ events → need to check gaps

**Example:**

```matlab
shape_zones = [100, 120; 135, 155; 280, 295];
size(shape_zones, 1) = 3  % 3 events → proceed
```

---

### **Line 2: Initialize with first event**

```matlab
merged_shape = shape_zones(1, :);
```

**What this does:**

- Start the merged list with Event 1
- `shape_zones(1, :)` = first row = `[100, 120]`

**State:**

```matlab
merged_shape = [100, 120];  % Just Event 1 so far
```

---

### **Line 3: Loop through remaining events**

```matlab
for k = 2:size(shape_zones, 1)
```

**What this does:**

- Loop through Event 2, Event 3, Event 4, etc.
- Compare each with the last merged event
- Decide: merge or keep separate?

---

## **Full Example: Three Events**

Let's trace the algorithm with real data:

```matlab
shape_zones = [
    100, 120;  % Event 1: gap to next = 15
    135, 155;  % Event 2: gap to next = 125
    280, 295   % Event 3
];

min_shape_gap = 30;
```

---

### **Iteration 1: k=2 (Event 2)**

```matlab
merged_shape = [100, 120];  % Current merged list
```

**Calculate gap:**

```matlab
gap = shape_zones(k, 1) - merged_shape(end, 2);
    = shape_zones(2, 1) - merged_shape(1, 2)
    = 135 - 120
    = 15  % frames
```

**Visual:**

```
Event 1:     100 ──────────── 120
                              └─ gap: 15 ─┘
Event 2:                           135 ──────── 155
```

**Decision:**

```matlab
if gap < min_shape_gap  % 15 < 30 → TRUE!
    merged_shape(end, 2) = shape_zones(k, 2);
```

**What happens:**

- `merged_shape(end, 2)` = last row, column 2 = 120
- Replace it with `shape_zones(2, 2)` = 155
- **Effect:** Extend Event 1 to include Event 2!

**After this iteration:**

```matlab
merged_shape = [100, 155];  % Extended! (was 100-120)
```

**Visual:**

```
Before: Event 1: 100───120    Event 2: 135───155
After:  Event 1: 100──────────────────────155  (merged!)
```

---

### **Iteration 2: k=3 (Event 3)**

```matlab
merged_shape = [100, 155];  % Current merged list
```

**Calculate gap:**

```matlab
gap = shape_zones(k, 1) - merged_shape(end, 2);
    = shape_zones(3, 1) - merged_shape(1, 2)
    = 280 - 155
    = 125  % frames
```

**Visual:**

```
Merged Event 1-2:  100 ───────────────── 155
                                        └─── gap: 125 ────┘
Event 3:                                               280 ─── 295
```

**Decision:**

```matlab
if gap < min_shape_gap  % 125 < 30 → FALSE!
else
    merged_shape = [merged_shape; shape_zones(k, :)];
```

**What happens:**

- Gap is TOO LARGE (125 > 30)
- Keep as separate event
- Add Event 3 as **new row**

**After this iteration:**

```matlab
merged_shape = [
    100, 155;  % Merged Event 1+2
    280, 295   % Event 3 (separate)
];
```

---

## **Final Result**

```matlab
shape_zones = merged_shape;

% Before merging: 3 events
% [100, 120]
% [135, 155]
% [280, 295]

% After merging: 2 events
% [100, 155]  ← Event 1 and 2 merged!
% [280, 295]  ← Event 3 separate
```

**Visual:**

```
Before:
  ■■■■■■■■        ■■■■■■■■                    ■■■■■■
  100-120         135-155                     280-295

After:
  ■■■■■■■■■■■■■■■■■■■■■■■                    ■■■■■■
  100-155 (merged)                            280-295
```

---

## **Key Lines Explained**

### **Line: `merged_shape(end, 2)`**

```matlab
merged_shape(end, 2) = shape_zones(k, 2);
```

**Breaking it down:**

- `merged_shape` is a matrix (rows × 2 columns)
- `end` = last row index
- `(end, 2)` = last row, column 2 = **end frame of last event**
- Replacing it **extends the event**

**Example:**

```matlab
merged_shape = [100, 120];
merged_shape(end, 2) = 155;
% Result: [100, 155]  (extended from 120 to 155)
```

---

### **Line: `merged_shape(end, 2)` in gap calculation**

```matlab
gap = shape_zones(k, 1) - merged_shape(end, 2);
```

**Breaking it down:**

- `shape_zones(k, 1)` = start of **next** event
- `merged_shape(end, 2)` = end of **last merged** event
- Difference = gap between them

**Example:**

```
Last merged event ends at: 155
Next event starts at: 280
Gap = 280 - 155 = 125
```

---

### **Line: Append new row**

```matlab
merged_shape = [merged_shape; shape_zones(k, :)];
```

**Breaking it down:**

- `;` = vertical concatenation (stack rows)
- `shape_zones(k, :)` = entire row k (both columns)
- Adds new event as separate row

**Example:**

```matlab
merged_shape = [100, 155];
merged_shape = [merged_shape; [280, 295]];
% Result:
% [100, 155]
% [280, 295]  ← added as new row
```

---

## **Another Example: Four Events**

Let's do a more complex one:

```matlab
shape_zones = [
    50,  70;   % Event 1
    80,  95;   % Event 2: gap from 1 = 10
    110, 130;  % Event 3: gap from 2 = 15
    200, 220   % Event 4: gap from 3 = 70
];

min_shape_gap = 30;
```

**Step-by-step:**

**k=2 (Event 2):**

- Gap: 80 - 70 = 10 < 30 → **MERGE**
- merged_shape = [50, 95]

**k=3 (Event 3):**

- Gap: 110 - 95 = 15 < 30 → **MERGE**
- merged_shape = [50, 130]

**k=4 (Event 4):**

- Gap: 200 - 130 = 70 > 30 → **SEPARATE**
- merged_shape = [[50, 130]; [200, 220]]

**Result:** 2 events instead of 4!

```
Before:
  ■■■■  ■■■■  ■■■■              ■■■■
  50-70 80-95 110-130           200-220

After:
  ■■■■■■■■■■■■■■■■■■■■■■■■     ■■■■
  50-130 (all merged!)          200-220
```

---

## **Why This Matters Physically**

### **Without merging:**

```
Roughness spikes:
  Frame 100-120: High
  Frame 121-134: Brief dip (roughness just below threshold)
  Frame 135-155: High again

→ Detected as 2 separate events
```

### **With merging:**

```
→ Detected as 1 continuous deformation event
```

**Physical interpretation:**

- The vesicle didn't fully recover between 120-135
- It's all part of one **deformation episode**
- Brief dip might be measurement noise or slight relaxation

---

## **The `min_shape_gap` Parameter**

```matlab
min_shape_gap = 30;  % frames (1 second at 30 fps)
```

**Tuning this:**

- **Smaller gap (10-20):** Only merge very close events (stricter)
- **Larger gap (50-100):** Merge events with longer recovery (looser)

**Your data:** 30 frames ≈ 1 second

- If roughness drops below threshold for < 1 second → same event
- If roughness stays low for > 1 second → separate events

---

## **Summary**

1. **Start** with first event in merged list
2. **Loop** through remaining events
3. For each event:
    - **Calculate gap** to last merged event
    - **If gap < 30:** Extend last merged event
    - **If gap ≥ 30:** Add as new separate event
4. **Result:** Fewer, longer events (gaps filled)

**The key insight:** The algorithm looks **backward** (comparing to the last thing in merged_shape), not forward!

---

**Does this make sense now?** Try tracing through with your own example! 🎯

Want to continue with Section 3 (Regime Classification)?