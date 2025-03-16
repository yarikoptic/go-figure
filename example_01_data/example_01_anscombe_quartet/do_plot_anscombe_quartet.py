#!/usr/bin/env python

# Make images of standard Anscombe Quartet, from:
# 
#   Anscombe FJ (1973). Graphs in Statistical Analysis. 
#   The American Statistician 27(1):17-21
#
# To create the img*.svg, run as follows:
# 
#   python do_plot_anscombe_quartet.py
#
# ---------------------------------------------------------------------------

# libraries
import numpy             as np
import matplotlib.pyplot as plt

# ---------------------------------------------------------------------------
# Anscombe's Quartet values

x13 = [10.0, 8.0, 13.0, 9.0, 11.0, 14.0, 6.0, 4.0, 12.0, 7.0, 5.0]
x4  = [8.0, 8.0, 8.0, 8.0, 8.0, 8.0, 8.0, 19.0, 8.0, 8.0, 8.0]
y1  = [8.04, 6.95, 7.58, 8.81, 8.33, 9.96, 7.24, 4.26, 10.84, 4.82, 5.68]
y2  = [9.14, 8.14, 8.74, 8.77, 9.26, 8.1, 6.13, 3.1, 9.13, 7.26, 4.74]
y3  = [7.46, 6.77, 12.74, 7.11, 7.81, 8.84, 6.08, 5.39, 8.15, 6.42, 5.73]
y4  = [6.58, 5.76, 7.71, 8.84, 8.47, 7.04, 5.25, 12.5, 5.56, 7.91, 6.89]

x = np.array([x13, x13, x13, x4])
y = np.array([y1, y2, y3, y4])

# ---------------------------------------------------------------------------
# make plots

fff   = plt.figure( "Anscombe's Quartet", figsize=(12,3) )
nrow  = 1
ncol  = 4
sss   = fff.subplots( nrow, ncol )
xmin  = 2
xmax  = 20
ymin  = 2
ymax  = 14
step  = 2
npt   = 100

#fff.suptitle("Anscombe's quartet")

# plot the Quartet
for ii in range(ncol):
    # linear regression fit
    slope, intercept = np.polyfit(x[ii], y[ii], deg=1)
    corrx = np.linspace(xmin, xmax, npt)
    corry = corrx*slope + intercept

    # start plot
    pp = sss[ii]
    pp.set_aspect('equal',adjustable='box')
    pp.set_xlim((xmin, xmax))
    pp.set_ylim((ymin, ymax))

    # add lines/dots
    pp.plot(x[ii], y[ii], marker='o', lw=0, alpha=0.8, 
            mec='tab:red', mfc='tab:red')
    pp.plot(corrx, corry, '-', alpha=0.7, color='tab:blue')

    # which numbers to show
    pp.set_xticks(np.arange(xmin+step, xmax, step))
    pp.set_yticks(np.arange(ymin+step, ymax, step))

    # turn off ytick labels after first plot
    if ii :
        # first expression here purely to avoid this warn:
        #   UserWarning: FixedFormatter should only be used together 
        #   with FixedLocator
        pp.set_yticks(pp.get_yticks()) 
        nlabs = len(pp.get_yticklabels())
        pp.yaxis.set_ticklabels(['']*nlabs)

    pp.tick_params( axis='both', which='major', direction='in', color='0.5',
                    bottom=True, left=True, right=True, top=True )

plt.tight_layout()
plt.show()
fff.savefig('img_anscombe_quartet.svg')
