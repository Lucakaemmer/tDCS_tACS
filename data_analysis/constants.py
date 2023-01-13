# =============================================================================
#                           Computing Accuracies
# =============================================================================

TRIALS = list(range(0, 288))

RUNS = list(range(1, 13))

DATA_PATH = "/Users/lucakammer/Documents/Academia/Uni_BerlinFU/Semester3/Master_Thesis/Data"

COL_NAMES = ['Trial Onset', 'Trial Duration', 'Trial Type', 'Stimulus Set', 'Stimulus 1', 'Stimulus 2', 'Stimulus 3',
             'Stimulus 4', 'WM delay', 'ITI', 'Timing', 'Keypress', 'Response', 'Too late', 'RT', 'Run']

STIMULATION_GROUP_1 = [0, 2, 5, 7, 8, 10, 12, 15, 16, 18, 21, 22, 24, 27, 29, 31]
STIMULATION_GROUP_2 = [1, 3, 4, 6, 9, 11, 13, 14, 17, 19, 20, 23, 25, 26, 28, 30]

EXCLUDE = [20, 26]

# =============================================================================
#                                   Plotting
# =============================================================================

ACCURACIES_PATH = "/Users/lucakammer/Documents/GitHub/tDCS_tACS/data_analysis/data/accuracies.csv"
COND_ACC_PATH = "/Users/lucakammer/Documents/GitHub/tDCS_tACS/data_analysis/data/cond_accuracies.csv"
RTs_PATH = "/Users/lucakammer/Documents/GitHub/tDCS_tACS/data_analysis/data/RTs.csv"
COND_RTs_PATH = "/Users/lucakammer/Documents/GitHub/tDCS_tACS/data_analysis/data/cond_RTs.csv"
ACC_UNSHIFTED_PATH = "/Users/lucakammer/Documents/GitHub/tDCS_tACS/data_analysis/data/accuracies_unshifted.csv"
TRIAL_AVERAGE_PATH = "/Users/lucakammer/Documents/GitHub/tDCS_tACS/data_analysis/data/trials_average.csv"

TRIAL_DISTANCE = [24.5, 48.5, 72.5, 96.5, 120.5, 144.5, 168.5, 192.5, 216.5, 240.5, 264.5]
RUNS_PLOT = [2.5, 4.5, 6.5, 8.5, 10.5]
BLOCK_INDEXES = [0, 2, 4, 6, 8, 10]

COLORS = ["lightcoral", "maroon", "red", "darkorange", "gold", "olive", "yellowgreen", "darkgreen", "lime",
          "turquoise", "lightseagreen", "darkslategray", "aqua", "cadetblue", "deepskyblue", "dodgerblue",
          "lightslategray", "midnightblue", "thistle", "violet", "mediumvioletred", "hotpink", "lightpink", "bisque",
          "springgreen", "mintcream", "teal", "blueviolet", "plum", "chocolate", "LavenderBlush", "MistyRose"]

TEXT_X = [1.5, 6.55, 0.8, 3.0, 5.1, 6.8, 8.4, 11.1]
TEXT_Y = [0.93, 0.93, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2]
TEXT_CONT = ["sham-condition", "experimental-condition", "baseline", "sham", "post", "baseline", "stimulation", "post"]
TEXT_FONT = [15, 15, 10, 10, 10, 10, 10, 10]
TEXT_WEIGHT = ["normal", "normal", "normal", "bold", "normal", "normal", "bold", "normal"]
