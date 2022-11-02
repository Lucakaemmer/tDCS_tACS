import numpy as np
from constants import (DATA_PATH, COL_NAMES, STIMULATION_GROUP_1, EXCLUDE)
from utils.utils_preprocessing import (get_subjects_measure, import_data, exclude_timeout_runs, shift_runs,
                                       get_conditional_measure)

# Importing data from all participants
data_set = import_data(data_path=DATA_PATH, col_names=COL_NAMES)

# Excluding timeouts from data_set
data_set = exclude_timeout_runs(data=data_set)

# Calculating mean accuracies from all participants over the 12 runs
participant_accuracies = get_subjects_measure(data=data_set, param="Response")

# Getting accuracies for correct stim first and correct stim second
accuracy_stimulus_1 = get_conditional_measure(data=data_set, measure='Response', condition='Stimulus 1', group=1)
accuracy_stimulus_2 = get_conditional_measure(data=data_set, measure='Response', condition='Stimulus 1', group=2)
conditional_accuracies = np.asarray([accuracy_stimulus_1, accuracy_stimulus_2])

# Calculating mean RTs from all participants over the 12 runs
participant_RTs = get_subjects_measure(data=data_set, param="RT")

# Getting RT for correct vs for wrong trials
correct_RT = get_conditional_measure(data=data_set, measure='RT', condition='Response', group=1)
wrong_RT = get_conditional_measure(data=data_set, measure='RT', condition='Response', group=0)
conditional_RT = np.asarray([np.mean(correct_RT), np.mean(wrong_RT)])

# Saving accuracies before shifting to compare the days
np.savetxt("accuracies_unshifted.csv", participant_accuracies, delimiter=",")

# Shifting around the runs to align the stimulation conditions for all participants
shift_runs(measure=participant_accuracies, stim_group_1=STIMULATION_GROUP_1)
shift_runs(measure=participant_RTs, stim_group_1=STIMULATION_GROUP_1)

# Excluding participants that did not meet the performance threshold
# participant_accuracies = np.delete(participant_accuracies, EXCLUDE, 0)
# participant_RTs = np.delete(participant_RTs, EXCLUDE, 0)

# Saving the table of accuracies for later use
np.savetxt("accuracies.csv", participant_accuracies, delimiter=",")
np.savetxt("cond_accuracies.csv", conditional_accuracies, delimiter=",")
np.savetxt("RTs.csv", participant_RTs, delimiter=",")
np.savetxt("cond_RTs.csv", conditional_RT, delimiter=",")
