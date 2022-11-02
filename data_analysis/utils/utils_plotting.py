import numpy as np
import pandas as pd
import glob
import os
from scipy.stats import sem
import matplotlib.pyplot as plt
from constants import (BLOCK_INDEXES, RUNS_PLOT, COLORS, TEXT_X, TEXT_Y, TEXT_CONT, TEXT_FONT, TEXT_WEIGHT, RUNS)


def graph_background(runs):
    plt.xticks(runs)
    plt.ylim(ymin=0, ymax=1.0)
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


def graph_mean_run(mean_run_measure, run_error, title, yaxis):
    runs = range(len(mean_run_measure))
    runs = [x + 1 for x in runs]
    midpoint = int(len(mean_run_measure) / 2)
    plt.plot(runs[:midpoint], mean_run_measure[:midpoint], marker='o', color=COLORS[3])
    plt.plot(runs[midpoint:], mean_run_measure[midpoint:], marker='o', color=COLORS[3])
    plt.errorbar(runs[:midpoint], mean_run_measure[:midpoint], yerr=run_error[:midpoint], ecolor="black", capsize=4)
    plt.errorbar(runs[midpoint:], mean_run_measure[midpoint:], yerr=run_error[midpoint:], ecolor="black", capsize=4)
    graph_background(runs=runs)
    for i in range(len(runs)):
        plt.text(x=runs[i] - 0.25, y=mean_run_measure[i] - 0.08, s=str(round(mean_run_measure[i], 2)))
    plt.xlabel('Runs')
    plt.ylabel(yaxis)
    plt.title(title)
    plt.show()
    return


def graph_mean_run_day(mean_run_measure, run_error,  ymin, ymax, title, label_1, label_2, yaxis):
    runs = range(len(mean_run_measure))
    runs = [x + 1 for x in runs]
    midpoint = int(len(mean_run_measure) / 2)
    plt.plot(runs[:midpoint], mean_run_measure[:midpoint], "b", marker='o', label=label_1)
    plt.plot(runs[:midpoint], mean_run_measure[midpoint:], "r", marker='o', label=label_2)
    plt.errorbar(runs[:midpoint], mean_run_measure[:midpoint], yerr=run_error[:midpoint], ecolor="b", capsize=4)
    plt.errorbar(runs[:midpoint], mean_run_measure[midpoint:], yerr=run_error[midpoint:], ecolor="r", capsize=4)

    plt.ylim(ymin=ymin, ymax=ymax)
    plt.axhspan(ymin=0, ymax=1, xmin=0.33, xmax=0.67, color='black', alpha=0.20, lw=0)

    plt.text(3.5, 0.77, "Stimulation\nPhase", fontsize=15, horizontalalignment='center', verticalalignment='top',
             multialignment='center')
    plt.xlabel('Runs')
    plt.ylabel(yaxis)
    plt.title(title)
    plt.legend()

    plt.show()
    return


def graph_subj_run(mean_run_measure):
    runs = range(len(mean_run_measure))
    runs = [x + 1 for x in runs]
    midpoint = int(len(mean_run_measure) / 2)
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


def plot_cond_RT(cond_measure):
    x = len(cond_measure.columns)
    x_axis = np.arange(x)
    y = cond_measure

    plt.bar(x_axis[0], y[0], 1, label="Correct RT")
    plt.bar(x_axis[1], y[1], 1, label="Wrong RT")

    plt.xticks(range(x), ["correct", "wrong"])
    plt.ylim(ymin=0, ymax=1)

    plt.xlabel("Outcome")
    plt.ylabel("Reaction Time")
    plt.title("RT for correct vs. wrong trials")
    plt.legend()

    plt.show()
    return
