# =============================================================================
#                         Importing packages
# =============================================================================

import pandas as pd
import numpy as np
import os
import glob
from Constants import (BOUNDS, DATA_PATH, COL_NAMES)
from utils import get_accuracies

# =============================================================================
#                          Importing data
# =============================================================================

# Creating a list with the directories to the data of each participant
subject_folders = glob.glob(os.path.join(DATA_PATH, "SUB*"))

# Creating list in which to store the data for each subject
data_set = []

# Iterating through that list to access the data of each participant
for s in subject_folders:

    # Creating a list with the directories to each run of a given participant
    data_files = glob.glob(os.path.join(s, "*.tsv"))

    # Creating the df in which to store all runs of a participant
    data = pd.DataFrame(columns=COL_NAMES)

    # Iterating through that list to access each runs of a participant
    for f in data_files:
        df = pd.read_csv(f, sep='\t')
        data = data.append(df)

    # Add each participant's data to our data set
    data_set.append(data)


# =============================================================================
#               Accuracy of each participant in the 12 runs
# =============================================================================

participant_accuracies = get_accuracies(data=data_set, 
                                        param="Response",
                                        bounds=BOUNDS)

np.savetxt("accuracies_.csv", participant_accuracies, delimiter=",")






