import numpy as np
import pandas as pd
import glob
import os
from scipy.stats import sem
import matplotlib.pyplot as plt
from constants import (BLOCK_INDEXES, RUNS_PLOT, COLORS, TEXT_X, TEXT_Y, TEXT_CONT, TEXT_FONT, TEXT_WEIGHT)


# =============================================================================
#                           Preprocessing
# =============================================================================


def import_data(data_path, col_names):
    subject_folders = glob.glob(os.path.join(data_path, "SUB*"))
    subject_folders = sorted(subject_folders)
    data_set = []
    for s in subject_folders:
        data_files = glob.glob(os.path.join(s, "*.tsv"))
        data_files = sorted(data_files)
        data = pd.DataFrame(columns=col_names)
        for f in data_files:
            df = pd.read_csv(f, sep='\t')
            data = pd.concat([data, df])
        data_set.append(data)
    return data_set


def get_measure(data, param, bounds):
    measure = []
    for bound in range(len(bounds) - 1):
        lower_bound = bounds[bound]
        upper_bound = bounds[bound + 1]
        measure.append(np.mean(data[param][lower_bound:upper_bound]))
    return measure


def get_subjects_measure(data, param, bounds):
    n_subj = len(data)
    n_runs = len(bounds) - 1
    subjects_measure = np.zeros((n_subj, n_runs))
    for subj in range(n_subj):
        subjects_measure[subj] = get_measure(data=data[subj], param=param, bounds=bounds)
    return subjects_measure


def get_conditional_measure(data, bounds):
    measure_1 = []
    measure_2 = []
    n_subj = len(data)
    stim_1 = np.zeros(n_subj)
    stim_2 = np.zeros(n_subj)
    for subj in range(n_subj):
        for bound in range(len(bounds) - 1):
            lower_bound = bounds[bound]
            upper_bound = bounds[bound + 1]
            measure = data[subj][lower_bound:upper_bound]
            measure_1.append(np.mean(measure.loc[measure['Stimulus 1'] == 1, 'Response']))
            measure_2.append(np.mean(measure.loc[measure['Stimulus 1'] == 2, 'Response']))
        stim_1[subj] = np.mean(measure_1)
        stim_2[subj] = np.mean(measure_2)
    return stim_1, stim_2


def shift_runs(measure, stim_group_1):
    for i in stim_group_1:
        measure[i] = np.roll(measure[i], 6)
    return measure


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
    for i in range(measure.shape[0]):
        subj_error[i] = sem(measure.iloc[i, :])
    return subj_error


def get_block_error(measure):
    run_error = get_run_error(measure=measure)
    block_error = np.zeros(6)
    for i in range(len(block_error)):
        runs_of_interest = run_error[[BLOCK_INDEXES[i], BLOCK_INDEXES[i] + 1]]
        block_error[i] = runs_of_interest.mean()
    return block_error


# =============================================================================
#                                   Plotting
# =============================================================================

def graph_background(runs):
    plt.xticks(runs)
    plt.ylim(ymin=0, ymax=1)
    for i in RUNS_PLOT:
        plt.axvline(x=i, color='b', alpha=0.3, linestyle='--')
    plt.axhline(y=0.5, color='black', alpha=0.5, linestyle=':')
    plt.axhspan(ymin=0, ymax=1, xmin=0.5, xmax=1, color='black', alpha=0.20, lw=0)
    for i in range(len(TEXT_X)):
        plt.text(TEXT_X[i], TEXT_Y[i], TEXT_CONT[i], fontsize=TEXT_FONT[i], weight=TEXT_WEIGHT[i])
    return


def graph_all_participants(measure):
    runs = range(measure.shape[1])
    runs = [x + 1 for x in runs]
    for i in range(measure.shape[0]):
        plt.plot(runs, measure.iloc[i], marker='.', color=COLORS[i])
    graph_background(runs=runs)
    plt.xlabel('Runs')
    plt.ylabel('Accuracy')
    plt.title("Accuracy of all participants over all 12 runs")
    plt.show()
    return


def graph_mean_run(mean_run_measure, run_error):
    runs = range(len(mean_run_measure))
    runs = [x + 1 for x in runs]
    midpoint = int(len(mean_run_measure)/2)
    plt.plot(runs[:midpoint], mean_run_measure[:midpoint], marker='o', color=COLORS[3])
    plt.plot(runs[midpoint:], mean_run_measure[midpoint:], marker='o', color=COLORS[3])
    plt.errorbar(runs[:midpoint], mean_run_measure[:midpoint], yerr=run_error[:midpoint], ecolor="black", capsize=4)
    plt.errorbar(runs[midpoint:], mean_run_measure[midpoint:], yerr=run_error[midpoint:], ecolor="black", capsize=4)
    graph_background(runs=runs)
    for i in range(len(runs)):
        plt.text(x=runs[i] - 0.25, y=mean_run_measure[i] - 0.08, s=str(round(mean_run_measure[i], 2)))
    plt.xlabel('Runs')
    plt.ylabel('Accuracy')
    plt.title("Mean Accuracy over all 12 runs")
    plt.show()
    return


def graph_subj_run(mean_run_measure):
    runs = range(len(mean_run_measure))
    runs = [x + 1 for x in runs]
    midpoint = int(len(mean_run_measure)/2)
    plt.plot(runs[:midpoint], mean_run_measure[:midpoint], marker='o', color=COLORS[3])
    plt.plot(runs[midpoint:], mean_run_measure[midpoint:], marker='o', color=COLORS[3])
    graph_background(runs=runs)
    for i in range(len(runs)):
        plt.text(x=runs[i] - 0.25, y=mean_run_measure[i] - 0.08, s=str(round(mean_run_measure[i], 2)))
    plt.xlabel('Runs')
    plt.ylabel('Accuracy')
    plt.title("Mean Accuracy over all 12 runs")
    plt.show()
    return


def barplot_mean_subject(mean_subj_measure, subj_error):
    part_id = range(len(mean_subj_measure))
    part_id = [x + 1 for x in part_id]
    plt.bar(x=part_id, height=mean_subj_measure)
    plt.errorbar(x=part_id, y=mean_subj_measure, yerr=subj_error, fmt=".", ecolor="black", capsize=5)
    plt.xticks(part_id, part_id)
    plt.axhline(y=0.6, color='r', linestyle='-')
    plt.axhline(y=0.5, color='black', alpha=0.5, linestyle=':')
    plt.title('Mean Participant Accuracy')
    plt.xlabel('Participant ID')
    plt.ylabel('Accuracy')
    plt.show()
    return


def barplot_mean_block(mean_block_measure, block_error):
    x = TEXT_CONT[2:]
    y = mean_block_measure
    plt.bar(x=range(len(x)), height=y)
    plt.errorbar(x=range(len(x)), y=y, yerr=block_error, ecolor="black", fmt=".", capsize=5)
    plt.xticks(range(len(x)), x)
    plt.ylim(ymin=0, ymax=0.8)
    for i in range(len(y)):
        plt.text(x=range(len(x))[i] - 0.2, y=y[i] - 0.08, s=str(round(y[i], 2)), weight=TEXT_WEIGHT[2:][i])
    plt.axhline(y=0.5, color='black', alpha=0.5, linestyle=':')
    plt.axhspan(ymin=0, ymax=1, xmin=0.5, xmax=1, color='black', alpha=0.20, lw=0)
    plt.show()
    return


def plot_cond_measure(cond_measure):
    x = len(cond_measure)
    x_axis = np.arange(x)
    y = cond_measure

    plt.bar(x_axis - 0.2, y[0], 0.4, label="Remember Stimulus 1")
    plt.bar(x_axis + 0.2, y[1], 0.4, label="Remember Stimulus 2")

    x_axis = [x + 1 for x in x_axis]
    plt.xticks(range(x), x_axis)
    plt.ylim(ymin=0, ymax=0.8)

    plt.xlabel("Participants")
    plt.ylabel("Accuracy")
    plt.title("Participants Accuracies if First vs Second Stimulus was the one to remember")
    plt.legend()

    plt.show()
    return
