import numpy as np
import pandas as pd

def stats_preprocessing(data):
    accuracy = data.to_numpy().flatten()
    subject = range(1, len(data) + 1)
    subject = np.repeat(subject, 12)
    treatment = [1, 2]
    treatment = np.repeat(treatment, 6)
    treatment = np.tile(treatment, len(data))
    run = np.arange(1, 7)
    run = np.tile(run, len(data) * 2)
    stats_data = pd.DataFrame({'Subject': subject, 'Treatment': treatment, 'Run': run, 'Accuracy': accuracy},
                              columns=['Subject', 'Treatment', 'Run', 'Accuracy'])
    stats_data["Subject"] = pd.Categorical(stats_data.Subject)
    stats_data["Treatment"] = pd.Categorical(stats_data.Treatment)
    stats_data["Run"] = pd.Categorical(stats_data.Run)
    return stats_data
