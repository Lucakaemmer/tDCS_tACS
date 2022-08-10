import pandas as pd
from data_analysis.constants import (RTs_PATH)
from data_analysis.utils import (graph_all_participants, get_mean_run_measure, graph_mean_run, get_mean_subj_measure,
                                 barplot_mean_subject, get_mean_block_measure, barplot_mean_block, get_run_error,
                                 get_subj_error, get_block_error)


### Plotting Graphs ###

# Importing the table with the accuracies of all participants over the 12 runs
RTs = pd.read_csv(RTs_PATH, header=None)

# Plotting a graph of the accuracies of all participants over the 12 runs
graph_all_participants(measure=RTs)

# Plotting a graph of the overall accuracy over the 12 runs
mean_run_accuracies = get_mean_run_measure(measure=RTs)
run_error = get_run_error(measure=RTs)
graph_mean_run(mean_run_measure=mean_run_accuracies, run_error=run_error)

# Plotting a graph of the accuracies of one single participant
#graph_mean_run(mean_run_measure=RTs.iloc[8])



### Plotting Barplots ###

# Plotting a barplot of the overall accuracy of each participant
mean_subj_RTs = get_mean_subj_measure(measure=RTs)
subj_error = get_subj_error(measure=RTs)
barplot_mean_subject(mean_subj_measure=mean_subj_RTs, subj_error=subj_error)

# Plotting a barplot of the accuracy during sham vs accuracy during stim
mean_block_RTs = get_mean_block_measure(measure=RTs)
block_error = get_block_error(measure=RTs)
barplot_mean_block(mean_block_measure=mean_block_RTs, block_error=block_error)


