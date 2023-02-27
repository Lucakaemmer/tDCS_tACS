import numpy as np
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D

from constants import (RUNS_PLOT, TRIAL_DISTANCE, COLORS, TEXT_X, TEXT_Y, TEXT_CONT, TEXT_FONT, TEXT_WEIGHT)


def graph_background(runs):
    plt.xticks(runs)
    ymin = 0
    ymax = 1.0
    plt.ylim(ymin=ymin, ymax=ymax)
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
    plt.ylabel('% of Correct Responses')
    plt.title('Accuracy of all participants over all 12 runs')
    plt.show()
    return


def graph_performance_individual_participants(measure):
    ymin = 0
    ymax = 100
    # font = {'size': 11, 'family': 'Calibri'}
    # plt.rc('font', **font)
    subjects = range(measure.shape[0])
    subjects = [x + 1 for x in subjects]
    plt.ylim(ymin=ymin, ymax=ymax)

    for i in range(measure.shape[0]):
        plt.scatter([subjects[i]] * measure.shape[1], measure.iloc[i] * 100, facecolors='none',
                    edgecolors=["grey"])
    for i in range(measure.shape[0]):
        plt.scatter([subjects[i]], np.mean(measure.iloc[i]) * 100, c=COLORS[6], marker="s")

    plt.xlabel('Participants')
    plt.ylabel('% of Correct Responses')
    plt.axhline(y=50, color='black', alpha=0.5, linestyle=':')
    #plt.text(x=len(subjects) - 2.2, y=46, s="Chance")

    legend = [Line2D([0], [0], color='grey', markerfacecolor='none', marker='o', linestyle='None',
                     label='run performance'),
              Line2D([0], [0], color=COLORS[6], marker="s", linestyle='None', label='mean performance')]
    plt.legend(handles=legend)
    plt.show()
    return


def graph_mean_run(mean_run_measure, run_error, title, yaxis):
    runs = range(len(mean_run_measure))
    runs = [x + 1 for x in runs]
    midpoint = int(len(mean_run_measure) / 2)
    plt.plot(runs[:midpoint], mean_run_measure[:midpoint], marker='o', color=COLORS[3])
    plt.plot(runs[midpoint:], mean_run_measure[midpoint:], marker='s', color=COLORS[3])
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


def graph_mean_run_layered(mean_run_measure, run_error, ymin, ymax, title, label_1, label_2, yaxis):

    runs = range(len(mean_run_measure))
    runs = [x + 1 for x in runs]
    midpoint = int(len(mean_run_measure) / 2)
    plt.plot(runs[:midpoint], mean_run_measure[:midpoint], "b", marker='o', label=label_1)
    plt.plot(runs[:midpoint], mean_run_measure[midpoint:], "r", marker='s', label=label_2)
    plt.errorbar(runs[:midpoint], mean_run_measure[:midpoint], yerr=run_error[:midpoint], ecolor="b", capsize=4)
    plt.errorbar(runs[:midpoint], mean_run_measure[midpoint:], yerr=run_error[midpoint:], ecolor="r", capsize=4)

    plt.ylim(ymin=ymin, ymax=ymax)
    plt.axhspan(ymin=0, ymax=1, xmin=0.33, xmax=0.67, color='black', alpha=0.20, lw=0)
    plt.hlines(y=np.arange(ymin + 0.05, ymax, 0.05).tolist(), xmin=1, xmax=6.0, linestyles='dashed',
               colors='grey')
    my_yticks = ['50', '55', '60', '65', '70', '75', '80']
    plt.yticks(np.arange(ymin, ymax, 0.05), my_yticks)

    # plt.text(3.5, 0.79, "Stimulation\nPhase", fontsize=12, horizontalalignment='center', verticalalignment='top',
    #          multialignment='center')
    # plt.text(1.7, 0.79, "Baseline\nPhase", fontsize=12, horizontalalignment='center', verticalalignment='top',
    #          multialignment='center')
    # plt.text(5.3, 0.79, "Post-Stimulation\nPhase", fontsize=12, horizontalalignment='center', verticalalignment='top',
    #          multialignment='center')
    plt.xlabel('Runs')
    plt.ylabel(yaxis)
    # plt.title(title)
    plt.legend(loc='lower left', labels=[".", ","])

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


def plot_by_trial(data, resolution, ymin, ymax, trial_start, trial_finish):
    averages = data.to_numpy()
    averages = averages[range(trial_start, trial_finish)]
    averages = np.mean(averages.reshape(-1, resolution), axis=1)
    middle_point = ((len(averages) - 1) / 2)

    plt.vlines(middle_point, 0, 1, colors='red')
    plt.ylim(ymin=ymin, ymax=ymax)

    plt.plot(averages)
    plt.title('Plotting accuracy by trial')
    plt.ylabel('Accuracy')
    plt.show()
    return


def roving_window(data, window):
    ymin = 0.50
    ymax = 0.80

    average_data = []
    roving_data = data.to_numpy().ravel()
    mean_append_data = np.ones(len(range(window)) // 2) * roving_data.mean()
    roving_data = np.concatenate((mean_append_data, roving_data, mean_append_data), axis=0)
    for i in range(len(data)):
        average_data.append(np.mean(roving_data[i:i + window]))

    run_distance = (len(average_data) // 12)
    run_tick = run_distance // 2
    run_ticks = [run_tick]
    for i in range(5):
        run_tick = run_tick + run_distance
        run_ticks.append(run_tick)
    plt.xticks(ticks=run_ticks, labels=range(1, 7))
    plt.ylim(ymin=ymin, ymax=ymax)

    plt.hlines(y=np.arange(ymin + 0.05, ymax, 0.05).tolist(), xmin=0, xmax=len(average_data) // 2, linestyles='dashed',
               colors='grey')

    length_graph = ((len(average_data) - 1) / 2)
    position_line = length_graph / 6
    for i in range(5):
        plt.vlines(position_line, colors='grey', ymin=ymin, ymax=ymax, alpha=0.50)
        position_line = position_line + length_graph / 6

    plt.axhspan(ymin=ymin, ymax=ymax, xmin=0.344, xmax=0.65, color='black', alpha=0.20, lw=0)

    # plt.text(np.mean(run_ticks[:2]), ymax - 0.01, "Baseline\nPhase", fontsize=12, horizontalalignment='center',
    #          verticalalignment='top', multialignment='center')
    # plt.text(np.mean(run_ticks[2:4]), ymax - 0.01, "Stimulation\nPhase", fontsize=12, horizontalalignment='center',
    #          verticalalignment='top', multialignment='center')
    # plt.text(np.mean(run_ticks[4:]), ymax - 0.01, "Post-Stimulation\nPhase", fontsize=12, horizontalalignment='center',
    #          verticalalignment='top', multialignment='center')

    plt.plot(average_data[:len(average_data) // 2], "b", label="Sham Condition")
    plt.plot(average_data[len(average_data) // 2:], "r", label="Experimental Condition")
    # plt.plot(average_data)         # for debugging to plot whole line

    # plt.title('Running Mean')
    plt.ylabel('%  of Correct Responses')
    plt.xlabel('Runs')
    plt.legend(loc='lower left')
    plt.show()
    return


def barplot_mean_subject(mean_subj_measure, subj_error):
    part_id = range(len(mean_subj_measure))
    part_id = [x + 1 for x in part_id]
    plt.bar(x=part_id, height=mean_subj_measure)
    plt.errorbar(x=part_id, y=mean_subj_measure, yerr=subj_error, fmt=".", ecolor="black", capsize=5)
    plt.xticks(part_id, part_id)
    plt.axhline(y=0.55, color='r', linestyle='-')
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
    x = np.arange(len(cond_measure))
    x = [x + 1 for x in x]
    y = cond_measure.mean(axis=1).to_list()

    plt.bar(x, y)

    plt.xticks(x)
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
