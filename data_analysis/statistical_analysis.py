import numpy as np
import pandas as pd
from statsmodels.stats.anova import AnovaRM
from bioinfokit.analys import stat
from scipy.stats import ttest_rel
import pingouin as pg
import seaborn as sns
from constants import (ACCURACIES_PATH)


accuracies_data = pd.read_csv(ACCURACIES_PATH, header=None)

accuracy = accuracies_data.to_numpy().flatten()
subject = range(1, len(accuracies_data)+1)
subject = np.repeat(subject, 12)
treatment = [1, 2]
treatment = np.repeat(treatment, 6)
treatment = np.tile(treatment, len(accuracies_data))
run = np.arange(1, 7)
run = np.tile(run, len(accuracies_data)*2)
stats_data = pd.DataFrame({'Subject': subject, 'Treatment': treatment, 'Run': run, 'Accuracy': accuracy},
                          columns=['Subject', 'Treatment', 'Run', 'Accuracy'])

stats_data_pre = stats_data.loc[(stats_data['Run'] == 1) | (stats_data['Run'] == 2)]
stats_data_treatment = stats_data.loc[(stats_data['Run'] == 3) | (stats_data['Run'] == 4)]
stats_data_post = stats_data.loc[(stats_data['Run'] == 5) | (stats_data['Run'] == 6)]
stats_data_excluded = stats_data[(stats_data.Subject != 3) & (stats_data.Subject != 19)
                                 & (stats_data.Subject != 21)]


model = AnovaRM(data=stats_data, depvar='Accuracy', subject='Subject', within=['Run', 'Treatment'])
fitted_model = model.fit()
print(fitted_model)

model_2 = pg.rm_anova(dv='Accuracy', within=['Run', 'Treatment'], subject='Subject', data=stats_data_treatment)




# res = stat()
# res.tukey_hsd(df=stats_data, res_var='Accuracy', xfac_var=['Treatment', 'Run'],
#               anova_model='Accuracy ~ C(Treatment) + C(Run) + C(Treatment):C(Run)')
# res.tukey_summary
# print(res.tukey_summary.loc[35])




sham_4 = stats_data.query('Treatment == 1 and Run == 4')['Accuracy']
stim_4 = stats_data.query('Treatment == 2 and Run == 4')['Accuracy']

print(np.mean(sham_4))
print(np.mean(stim_4))

t_test_1 = ttest_rel(sham_4, stim_4, alternative='less')
t_test_2 = pg.ttest(sham_4, stim_4, paired=True)




print("yay")