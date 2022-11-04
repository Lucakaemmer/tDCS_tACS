import numpy as np
import pandas as pd
import glob
import os
from scipy.stats import sem
from constants import (BLOCK_INDEXES, TRIALS, RUNS)


def import_data(data_path, col_names):
    subject_folders = glob.glob(os.path.join(data_path, "SUB*"))
    subject_folders = sorted(subject_folders)
    data_set = []
    for s in subject_folders:
        data_files = glob.glob(os.path.join(s, "*.tsv"))
        data_files = sorted(data_files)
        data = pd.DataFrame(columns=col_names)
        for f in range(len(data_files)):
            run_column = np.repeat(f + 1, 24)
            df = pd.read_csv(data_files[f], sep='\t')
            df['Run'] = run_column
            data = pd.concat([data, df])
        data_set.append(data)
    return data_set


def exclude_timeout_runs(data):
    n_subj = len(data)
    data_exc = []
    for subj in range(n_subj):
        subject = data[subj]
        subject_exc = subject.loc[subject['Too late'] == 0]
        data_exc.append(subject_exc)
    return data_exc


def get_subj_outcome(data, param):
    n_subj = len(data)
    subj_outcome = np.zeros((n_subj, len(TRIALS)))
    for subj in range(n_subj):
        subj_outcome[subj] = data[subj][param]
    return subj_outcome


def get_measure(data, param):
    measure = []
    for run in RUNS:
        measure.append(np.mean(data.loc[data['Run'] == run, param]))
    return measure


def get_subjects_measure(data, param):
    n_subj = len(data)
    n_runs = len(RUNS)
    subjects_measure = np.zeros((n_subj, n_runs))
    for subj in range(n_subj):
        subjects_measure[subj] = get_measure(data=data[subj], param=param)
    return subjects_measure


def get_conditional_measure(data, measure, condition, group):
    n_subj = len(data)
    conditional_measure = np.zeros(n_subj)
    for subj in range(n_subj):
        subject_data = data[subj]
        subject_conditional_measure = subject_data.loc[subject_data[condition] == group, measure]
        conditional_measure[subj] = np.mean(subject_conditional_measure)
    return conditional_measure


def shift_runs(measure, stim_group_1, shift):
    for i in stim_group_1:
        measure[i] = np.roll(measure[i], shift)
    return


def get_mean_run_measure(measure):
    mean_run_measure = np.zeros(measure.shape[1])
    for i in range(measure.shape[1]):
        mean_run_measure[i] = measure.iloc[:, i].mean()
    return mean_run_measure


def get_mean_subj_measure(measure):
    mean_subj_measure = np.zeros(measure.shape[0])
    for i in range(measure.shape[0]):
        mean_subj_measure[i] = measure.iloc[i, :].mean()
    return mean_subj_measure


def get_mean_block_measure(measure):
    mean_run_measure = get_mean_run_measure(measure=measure)
    mean_block_measure = np.zeros(6)
    for i in range(len(mean_block_measure)):
        runs_of_interest = mean_run_measure[[BLOCK_INDEXES[i], BLOCK_INDEXES[i] + 1]]
        mean_block_measure[i] = runs_of_interest.mean()
    return mean_block_measure


def get_run_error(measure):
    run_error = np.zeros(12)
    for i in range(measure.shape[1]):
        run_error[i] = sem(measure.iloc[:, i])
    return run_error


def get_subj_error(measure):
    subj_error = np.zeros(measure.shape[0])
    for i in range(len(subj_error)):
        subj_error[i] = sem(measure.iloc[i, :])
    return subj_error


def get_block_error(measure):
    run_error = get_run_error(measure=measure)
    block_error = np.zeros(6)
    for i in range(len(block_error)):
        runs_of_interest = run_error[[BLOCK_INDEXES[i], BLOCK_INDEXES[i] + 1]]
        block_error[i] = runs_of_interest.mean()
    return block_error