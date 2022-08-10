import pandas as pd
from data_analysis.constants import (ACCURACIES_PATH)
from data_analysis.utils import (graph_all_participants, get_mean_run_measure, graph_mean_run, get_mean_subj_measure,
                                 barplot_mean_subject, get_mean_block_measure, barplot_mean_block, get_run_error,
                                 get_subj_error, get_block_error, graph_subj_run)


### Plotting Graphs ###

# Importing the table with the accuracies of all participants over the 12 runs
accuracies = pd.read_csv(ACCURACIES_PATH, header=None)

# Plotting a graph of the accuracies of all participants over the 12 runs
graph_all_participants(measure=accuracies)

# Plotting a graph of the overall accuracy over the 12 runs
mean_run_accuracies = get_mean_run_measure(measure=accuracies)
run_error = get_run_error(measure=accuracies)
graph_mean_run(mean_run_measure=mean_run_accuracies, run_error=run_error)

# Plotting a graph of the accuracies of one single participant
graph_subj_run(mean_run_measure=accuracies.iloc[13])



### Plotting Barplots ###

# Plotting a barplot of the overall accuracy of each participant
mean_subj_accuracies = get_mean_subj_measure(measure=accuracies)
subj_error = get_subj_error(measure=accuracies)
barplot_mean_subject(mean_subj_measure=mean_subj_accuracies, subj_error=subj_error)

# Plotting a barplot of the accuracy during sham vs accuracy during stim
mean_block_accuracies = get_mean_block_measure(measure=accuracies)
block_error = get_block_error(measure=accuracies)
barplot_mean_block(mean_block_measure=mean_block_accuracies, block_error=block_error)


