
### Import libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
 
# Instructions for errorbars read from excel data: https://www.sciencescroll.com/2020/08/plotting-growth-curve-using-python.html
# Function to get the standard deviation of replicates.
def std_jm(repl_list):

    # Get the number of replicates into a variable.
    n_repl = len(repl_list)

    # Make an array with the mean of each group or replicates. If replicates are not 3, the indices here must be changed manually.
    mean_array = (repl_list[0] + repl_list[1] + repl_list[2]) / n_repl

    # Initialize empty list for std.
    std_array = []
    
    # Loop to calculate variance of each group or replicates.
    for i, j, k, in zip(repl_list[0], repl_list[1], repl_list[2]):
        tmp_mean = (i + j + k) / 3
        tmp_var = (pow((i-tmp_mean),2) + pow((j-tmp_mean),2) + pow((k-tmp_mean),2)) / n_repl
        tmp_std = np.sqrt(tmp_var)
        std_array.append(tmp_std)
    
    return(std_array)

### Dataset from first Acid Shock (2122WT, DphoPR, ::pMV306phoB, ::pMV306phoTB) phoPR Overexpressed ###
daycount = np.array([0, 2, 4, 6, 9])

#MOPS 6.8
wt1 = np.array([0.1, 0.22, 0.61, 1.29, 1.9])
wt2 = np.array([0.1, 0.23, 0.63, 1.32, 1.94])
wt3 = np.array([0.1, 0.22, 0.6, 1.29, 1.91])
dpho1 = np.array([0.1, 0.17, 0.28, 0.6, 0.99])
dpho2 = np.array([0.1, 0.18, 0.3, 0.62, 1.03])
dpho3 = np.array([0.1, 0.17, 0.29, 0.59, 0.98])
pMVbov1 = np.array([0.1, 0.2, 0.54, 1.2, 1.84])
pMVbov2 = np.array([0.1, 0.21, 0.57, 1.28, 1.92])
pMVbov3 = np.array([0.1, 0.2, 0.54, 1.23, 1.87])
MCZbov1 = np.array([0.1, 0.17, 0.35, 0.77, 1.36])
MCZbov2 = np.array([0.1, 0.17, 0.36, 0.79, 1.39])
MCZbov3 = np.array([0.1, 0.17, 0.35, 0.78, 1.38])

# Calculate the mean and standard deviation for each group or replicates.
wt_mean = sum([wt1, wt2, wt3]) / 3
wt_std = std_jm([wt1, wt2, wt3])
dpho_mean = sum([dpho1, dpho2, dpho3]) / 3
dpho_std = std_jm([dpho1, dpho2, dpho3])
c_mean = sum([pMVbov1, pMVbov2, pMVbov3]) / 3
c_std = std_jm([pMVbov1, pMVbov2, pMVbov3])
m_mean = sum([MCZbov1, MCZbov2, MCZbov3]) / 3
m_std = std_jm([MCZbov1, MCZbov2, MCZbov3])

# Create a datframe with columns being the mean and std for each group of replicates. Std is needed to plot the error bars.
df = pd.DataFrame(zip(daycount, wt_mean, wt_std, dpho_mean, dpho_std, c_mean, c_std, m_mean, m_std),
columns = ["daycount", "wt_mean", "wt_std", "dpho_mean", "dpho_std", "c_mean", "c_std", "m_mean", "m_std"])
print(df)

# Plot with matplotlib.
plt.errorbar(df.daycount, df.wt_mean, color = "g", yerr = df.wt_std, fmt = "-o", capsize = 5, label = "2122 WT")
#plt.errorbar(df.daycount, df.h37dpho_mean, linestyle = "--", color = "g", yerr = df.h37dpho_std, fmt = "-o", capsize = 5, label = "H37RvDpho")
plt.errorbar(df.daycount, df.dpho_mean, color = "r", yerr = df.dpho_std, fmt = "-^", capsize = 5, label = "2122 Dpho")
#plt.errorbar(df.daycount, df.afdpho_mean, linestyle = "--", color = "r", yerr = df.afdpho_std, fmt = "-^", capsize = 5, label = "::2122Dpho")
plt.errorbar(df.daycount, df.c_mean, color = "b", yerr = df.c_std, fmt = "-o", capsize = 5, label = "Dpho::pMVBov")
plt.errorbar(df.daycount, df.m_mean, color = "c", yerr = df.m_std, fmt = "-s", capsize = 5, label = "Dpho::MCZBov")


#plt.errorbar(df.daycount, df.wta_mean, linestyle = "--", color = "g", yerr = df.wta_std, fmt = "-o", capsize = 5)
#plt.errorbar(df.daycount, df.dphoa_mean, linestyle = "--", color = "r", yerr = df.dphoa_std, fmt = "-^", capsize = 5)
#plt.errorbar(df.daycount, df.pMVbova_mean, linestyle = "--", color = "b", yerr = df.pMVbova_std, fmt = "s", capsize = 5)
#plt.errorbar(df.daycount, df.MCZbova_mean, linestyle = "--", color = "c", yerr = df.MCZbova_std, fmt = "D", capsize = 5)

#plt.plot(df.daycount, df.dpho_mean, label = "2122 DphoPR")
#plt.errorbar(df.daycount, df.dphoa_mean, linestyle = "--", color = "r", yerr = df.dphoa_std, fmt = "^", capsize = 5, label = "DphoPR pH 5.8")
#plt.plot(df.daycount, df.wt_mean, linestyle = "--", marker = "o", label = "2122 WT")
#plt.errorbar(df.daycount, df.wta_mean, linestyle = "--", color = "r", yerr = df.wta_std, fmt = "-o", capsize = 5, label = "2122WT pH5.8")
#plt.plot(df.daycount, df.dpho_mean, label = "2122 DphoPR")
#plt.errorbar(df.daycount, df.dphoa_mean, linestyle = "--", color = "r", yerr = df.dphoa_std, fmt = "^", capsize = 5, label = "2122DphoPR pH5.8")
#plt.plot(df.daycount, df.pMVbov_mean, label = "DphoPR::pMVBov")
#plt.errorbar(df.daycount, df.pMVbov_mean, linestyle = "--", color = "b", yerr = df.pMVbov_std, fmt = "s", capsize = 5, label = "Dpho::pMVBov")
#plt.plot(df.daycount, df.pMVtb_mean, label = "DphoPR::pMVTB")
#plt.errorbar(df.daycount, df.pMVtb_mean, linestyle = "--", color = "m", yerr = df.pMVtb_std, fmt = "D", capsize = 5, label = "Dpho::pMVTb")
#plt.plot(df.daycount, df.pDEbov_mean, label = "DphoPR::pDEBov")
#plt.errorbar(df.daycount, df.pDEbov_mean, linestyle = "--", color = "c", yerr = df.pDEbov_std, fmt = "+", capsize = 5, label = "Dpho::pDEBov")
#plt.plot(df.daycount, df.pDEtb_mean, label = "DphoPR::pDETb")
#plt.errorbar(df.daycount, df.pDEtb_mean, linestyle = "--", color = "k", yerr = df.pDEtb_std, fmt = "x", capsize = 5, label = "Dpho::pDETb")


#plt.title("7H9 + Pyr + Tylox + FA-freeBSA + NaCl PH=6.8", fontsize = 12)
plt.xlabel("Days", fontsize = 10)
plt.ylabel("Optical Density", fontsize = 10)
plt.legend()
plt.show()

