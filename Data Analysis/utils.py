import numpy as np


def get_accuracy(subj_data, param, bounds): 
    acc = []
    for bound in range(len(bounds)-1):
        lower_bound = bounds[bound]  
        upper_bound = bounds[bound+1]     
        acc.append(np.mean([subj_data][param][lower_bound:upper_bound]))
    return acc


def get_accuracies(data, param, bounds):
    n_subj = len(data)
    n_runs = len (bounds)-1
    participant_accuracies = np.zeros((n_subj,n_runs))
    for subj in range(len(data)):
        participant_accuracies[subj] = get_accuracy(subj_data=data[subj], 
                                                    param=param, 
                                                    bounds=bounds)
    return participant_accuracies

