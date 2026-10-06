# Surat Restaurant Recommendation System (SWI-Prolog)

An AI expert system developed in **SWI-Prolog** for constraint-based restaurant recommendations in Surat, Gujarat. The system uses **Depth-First Search (DFS) with Backtracking**, **Automated Constraint Relaxation**, and a **Multi-Attribute Weighted Scoring Engine** to recommend the best dining spots based on user preferences.

---

## 🌟 Key Features

1. **Curated Knowledge Base (`surat_restaurants.pl`)**:
   - 100 real restaurants in Surat with data on name, area, primary cuisine, cost for two (INR), vegetarian type (`veg`, `nonveg`, `both`), average rating, cuisine tags, and data confidence levels.
   - Popular areas covered: Adajan, Vesu, Piplod, Athwa, City Light, Nanpura, Varachha, Pal, Althan, etc.

2. **Constraint-Based Search (DFS + Backtracking)**:
   - Evaluates constraints sequentially: Cuisine $\rightarrow$ Area $\rightarrow$ Budget $\rightarrow$ Veg Preference $\rightarrow$ Minimum Rating.
   - Leverages Prolog's native backtracking to prune candidate choices.

3. **Intelligent Constraint Relaxation**:
   - If no restaurant satisfies all strict criteria, the system relaxes constraints step-by-step:
     1. **Step 1:** Relax minimum rating constraint
     2. **Step 2:** Relax area constraint (search city-wide)
     3. **Step 3:** Relax budget constraint by +20%
     4. **Step 4:** Relax cuisine to nearest related cuisine (e.g., Italian $\rightarrow$ Continental/Pizza, Chinese $\rightarrow$ Asian)

4. **Multi-Attribute Scoring & Ranking (Score out of 100)**:
   - **Average Rating (40% weight)**: Normalized against 5.0 scale.
   - **Budget Fit (25% weight)**: Uses a sweet-spot ratio curve that rewards reasonable prices without penalizing quality.
   - **Cuisine Match (20% weight)**: Full points for primary cuisine; partial points for secondary tags or nearest related cuisines.
   - **Area Proximity (10% weight)**: Full points for target area; 0 if relaxed.
   - **Data Confidence (5% weight)**: Verified platform confidence (High: 5, Medium: 3, Low: 1).

5. **Robust Console User Interface**:
   - Interactive prompt supporting navigation, input correction, `back` commands, and preference review before searching.
   - Graceful error handling (never crashes on invalid input or EOF).

6. **Automated Test Suite**:
   - Built-in unit tests (`plunit`) covering data integrity, score bounds, sorting orders, budget constraints, and relaxation logic.

---

## 📁 Repository Structure

```
.
├── restaurant.pl         # Core expert system, inference engine, scoring & UI
├── surat_restaurants.pl  # Fact base containing 100 restaurant records
├── .gitignore            # Git exclusion rules
└── README.md             # Project documentation
```

---

## 🚀 Getting Started

### Prerequisites
Install **SWI-Prolog** (version 8.x or 9.x / 10.x):
* **Windows:** Download installer from [swi-prolog.org](https://www.swi-prolog.org/)
* **Ubuntu/Debian:** `sudo apt install swi-prolog`
* **macOS:** `brew install swi-prolog`

### Running the Interactive System

Launch SWI-Prolog with the file:
```bash
swipl restaurant.pl
```

Once inside the Prolog prompt (`?-`), start the interactive menu:
```prolog
?- start.
```

*(Remember to include the terminating period `.`)*

### Direct Command-Line Execution
Run directly from terminal without entering the interactive Prolog shell:
```bash
swipl -g start restaurant.pl
```

To run the built-in demo sample queries and exit immediately:
```bash
swipl -g run_samples -t halt restaurant.pl
```

---

## 🧪 Running Tests

To verify knowledge base consistency and inference correctness:

```prolog
?- run_tests.
```

Expected output:
```text
% All 7 tests passed in 0.025 seconds
true.
```

---

## 📊 Sample Menu Options

```text
=== Surat Restaurant Recommendation System ===

 1. Get recommendations
 2. Show all restaurants
 3. Search by cuisine only
 4. Search by area only
 5. Top rated restaurants
 6. Budget restaurants (under X)
 7. Run built-in sample queries
 0. Exit
```

---

## 📋 Course & Project Information
* **Subject:** Artificial Intelligence (GTU Subject Code: 3170716)
* **Topic:** Knowledge Representation & Expert Systems (Console Expert System in SWI-Prolog)
