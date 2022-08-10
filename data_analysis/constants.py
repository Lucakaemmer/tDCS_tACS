# =============================================================================
#                           Computing Accuracies
# =============================================================================

BOUNDS = [0, 24, 48, 72, 96, 120, 144, 168, 192, 216, 240, 264, 288]

DATA_PATH = "C:/Users/lucak/Desktop/Uni/Berlin/Kurse/Semester 3/InternshipReseachWorkshop/Data"

COL_NAMES = ['Trial Onset', 'Trial Duration', 'Trial Type', 'Stimulus Set', 'Stimulus 1', 'Stimulus 2', 'Stimulus 3',
             'Stimulus 4', 'WM delay', 'ITI', 'Timing', 'Keypress', 'Response', 'Too late', 'RT']

STIMULATION_GROUP_1 = [0, 2, 5, 7, 8, 10, 12]

STIMULATION_GROUP_2 = [1, 3, 4, 6, 9, 11, 13]

EXCLUDE = [2, 3]


# =============================================================================
#                                   Plotting
# =============================================================================

ACCURACIES_PATH = "C:/Users/lucak/Documents/GitHub/tDCS_tACS/data_analysis/accuracies.csv"
RTs_PATH = "C:/Users/lucak/Documents/GitHub/tDCS_tACS/data_analysis/RTs.csv"

RUNS_PLOT = [2.5, 4.5, 6.5, 8.5, 10.5]
BLOCK_INDEXES = [0, 2, 4, 6, 8, 10]

COLORS = ["lightcoral", "maroon", "red", "darkorange", "gold", "olive", "yellowgreen", "darkgreen", "lime",
          "turquoise", "lightseagreen", "darkslategray", "aqua", "cadetblue", "deepskyblue", "dodgerblue",
          "lightslategray", "midnightblue", "thistle", "violet", "mediumvioletred", "hotpink", "lightpink",  "bisque"]

TEXT_X = [1.5, 6.55, 0.8, 3.0, 5.1, 6.8, 8.4, 11.1]
TEXT_Y = [0.93, 0.93, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2]
TEXT_CONT = ["sham-condition", "experimental-condition", "baseline", "sham", "post", "baseline", "stimulation", "post"]
TEXT_FONT = [15, 15, 10, 10, 10, 10, 10, 10]
TEXT_WEIGHT = ["normal", "normal", "normal", "bold", "normal", "normal", "bold","normal"]
