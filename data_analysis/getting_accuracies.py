import numpy as np
from data_analysis.constants import (BOUNDS, DATA_PATH, COL_NAMES, STIMULATION_GROUP_1, EXCLUDE)
from data_analysis.utils import (get_subjects_measure, import_data, shift_runs)


# Importing data from all participants
data_set = import_data(data_path=DATA_PATH, col_names=COL_NAMES)

# Calculating mean accuracies from all participants over the 12 runs
participant_accuracies = get_subjects_measure(data=data_set, param="Response", bounds=BOUNDS)

#conditional_accuracies =

# Calculating mean RTs from all participants over the 12 runs
participant_RTs = get_subjects_measure(data=data_set, param="RT", bounds=BOUNDS)

# Shifting around the runs to align the stimulation conditions for all participants
shift_runs(measure=participant_accuracies, stim_group_1=STIMULATION_GROUP_1)
shift_runs(measure=participant_RTs, stim_group_1=STIMULATION_GROUP_1)

# Excluding participants that did not meet the performance threshold
#participant_accuracies = np.delete(participant_accuracies, EXCLUDE, 0)
#participant_RTs = np.delete(participant_RTs, EXCLUDE, 0)

# Saving the table of accuracies for later use
np.savetxt("accuracies.csv", participant_accuracies, delimiter=",")
np.savetxt("RTs.csv", participant_RTs, delimiter=",")
