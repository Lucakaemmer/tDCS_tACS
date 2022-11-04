import numpy as np
import pandas as pd
from statsmodels.stats.anova import AnovaRM
from scipy.stats import ttest_rel
import pingouin as pt
from constants import (ACCURACIES_PATH)


accuracies_data = pd.read_csv(ACCURACIES_PATH, header=None)

accuracy = accuracies_data.to_numpy().flatten()

subject = range(1, len(accuracies_data)+1)
subject = np.repeat(subject, 12)

day = [1,2]
day = np.repeat(day, 6)
day = np.tile(day, len(accuracies_data))

run = np.arange(1, 7)
run = np.tile(run, len(accuracies_data)*2)

stats_data = pd.DataFrame({'Subject': subject, 'Day': day, 'Run': run, 'Accuracy': accuracy},
                          columns=['Subject', 'Day', 'Run', 'Accuracy'])


model = AnovaRM(data=stats_data, depvar='Accuracy', subject='Subject', within=['Day', 'Run'])
fitted_model = model.fit()
print(fitted_model)


sham_4 = stats_data.query('Day == 1 and Run == 4')['Accuracy']
stim_4 = stats_data.query('Day == 2 and Run == 4')['Accuracy']

print(np.mean(sham_4))
print(np.mean(stim_4))


t_test_1 = ttest_rel(sham_4, stim_4)

t_test_2 = pt.ttest(sham_4, stim_4, paired=True)


print("yay")