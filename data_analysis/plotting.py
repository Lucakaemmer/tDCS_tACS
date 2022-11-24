import pandas as pd
from constants import (ACCURACIES_PATH, COND_ACC_PATH, RTs_PATH, COND_RTs_PATH, ACC_UNSHIFTED_PATH)
from utils.utils_preprocessing import (get_mean_run_measure, get_mean_block_measure, get_run_error,
                                       get_mean_subj_measure, get_subj_error, get_block_error)
from utils.utils_plotting import (graph_all_participants, graph_mean_run, barplot_mean_subject, barplot_mean_block,
                                  plot_cond_measure, graph_mean_run_layered)

### Plotting Graphs ###

# Importing the tables with the accuracies and RTs of all participants
accuracies = pd.read_csv(ACCURACIES_PATH, header=None)
cond_acc = pd.read_csv(COND_ACC_PATH, header=None)
acc_unshifted = pd.read_csv(ACC_UNSHIFTED_PATH, header=None)
RT = pd.read_csv(RTs_PATH, header=None)
cond_RT = pd.read_csv(COND_RTs_PATH, header=None)

# Plotting a graph of the accuracies of all participants over the 12 runs
graph_all_participants(measure=accuracies)

# Plotting a graph of the overall accuracy over the 12 runs
mean_run_accuracies = get_mean_run_measure(measure=accuracies)
run_error_acc = get_run_error(measure=accuracies)
graph_mean_run(mean_run_measure=mean_run_accuracies, run_error=run_error_acc, title="Mean Accuracy over all 12 runs",
               yaxis="Accuracy")

# Plotting a graph of the overall accuracy comparing first to second day
mean_run_acc_unshifted = get_mean_run_measure(measure=acc_unshifted)
run_error_acc_uns = get_run_error(measure=acc_unshifted)
graph_mean_run(mean_run_measure=mean_run_acc_unshifted, run_error=run_error_acc_uns,
               title="Mean Accuracy comparing the days", yaxis="Accuracy")

# Plotting a graph of the overall RT over the 12 runs
mean_run_RT = get_mean_run_measure(measure=RT)
run_error_RT = get_run_error(measure=RT)
graph_mean_run(mean_run_measure=mean_run_RT, run_error=run_error_RT, title="Mean RT over all 12 runs",
               yaxis="Reaction Time")

# Plotting a graph of the overall accuracy over the 12 runs with the days laid on top of each other
graph_mean_run_layered(mean_run_measure=mean_run_accuracies, run_error=run_error_acc, ymin=0.5, ymax=0.8,
                       title="Mean Accuracy over all 12 runs, layered", label_1="Sham Condition",
                       label_2="Experimental Condition", yaxis="Accuracy")

# Plotting a graph of the overall accuracy over the 12 runs with the days laid on top of each other
graph_mean_run_layered(mean_run_measure=mean_run_acc_unshifted, run_error=run_error_acc_uns, ymin=0.5, ymax=0.8,
                       title="Mean Accuracy comparing the days, layered", label_1="Day 1", label_2="Day 2",
                       yaxis="Accuracy")

# Plotting a graph of the overall accuracy over the 12 runs with the days laid on top of each other
graph_mean_run_layered(mean_run_measure=mean_run_RT, run_error=run_error_RT, ymin=0.3, ymax=0.8,
                       title="Mean Reaction Time over all 12 runs, layered", label_1="Sham Condition",
                       label_2="Experimental Condition", yaxis="Reaction Time")

# Plotting a graph of the accuracies of one single participant
#graph_subj_run(mean_run_measure=accuracies.iloc[2])

## Plotting Barplots ###

# Plotting a barplot of the overall accuracy of each participant
mean_subj_accuracies = get_mean_subj_measure(measure=accuracies)
subj_error = get_subj_error(measure=accuracies)
barplot_mean_subject(mean_subj_measure=mean_subj_accuracies, subj_error=subj_error)

# Plotting a barplot of the accuracy during sham vs accuracy during stim
mean_block_accuracies = get_mean_block_measure(measure=accuracies)
block_error = get_block_error(measure=accuracies)
barplot_mean_block(mean_block_measure=mean_block_accuracies, block_error=block_error)

# Plotting all participants accuracies if first vs second stimulus was the one to remember
plot_cond_measure(cond_measure=cond_acc)

# Plotting RT for correct and wrong trials
#plot_cond_RT(cond_measure=cond_RT)
