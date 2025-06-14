# ISTRICI/CIG_V1 MANUAL: ***Software for the geological inversion of seismic data by using CIG analysis***

Produced by Umberta Tinivella and michela Giustiniani (OGS)  
Rewritten by Lining Yang (CNR) 

Please, after dowoading the software, write to utinivella@ogs.it and mgiustiniani@ogs.it to inform about it.
Please, cite ISTRICI and acknowledge the authors in the scientific products in which ISTRICI has been used.

ISTRICI is a software based on SU and fortran codes to determine seismic velocity in selected layers by using Common Image Gather (CIG) analysis

For more details about the Seismic Unix (SU) command and adopted algorithms, you can see the SU help, just typing the name of the command

The list of available command can be visualised typing 
```bash
suhelp
```
or
```bash
suname
```

Please, consult ximage and suximage help in order to know as to perform the picking!

-----------------
First of all, copy the ISTRICI/CIG_V1 directory in the directory where the analysis will be performed

-----------------
Then, you need to create the SeimicUnix file, by using, for example, the following commands:

```bash
segyread tape=file.sgy endian=0 conv=1 | segyclean >file.su
```

-----------------
Check if the coordinates (trace header sx and gx) are stored in the SU file. If not, you can use the sushw command, such as:

```bash
sushw <file.su key=sx a=XX b=XX j=XX | suchw key1=gx key2=sx key3=offset a=0 b=1 c=1 >file_coo.su
```
or
```bash
suchw <file.su key1=sx key2=fldr a=XX b=XX | suchw key1=gx key2=sx key3=offset a=0 b=1 c=1 >file_coo.su
```

-----------------
Create the initial vfile, the binary velocity field with constant velocity. 
In this step, you need to decide the geometry parameters of the grid: nx,dx,nz,dz

Input: **nx,nz,constant velocity**
```bash
sh ISTRICI/CIG_V1/CreateVfile
```
Output: **vfile, given filename for the initial vfile (float32 binary file)**

-----------------
## 1. Perform the Pre-stack Depth Migration and create the stacked migrated section

Input: **vfile, seismic data (*.su)**
```bash
sh ISTRICI/CIG_V1/PerformPSDM
```
Output: **kd.data_complete (migration), outfile1_complete (additional migration), stackPSDM.su (stack of the CIGs)**

-----------------
## 2. Extraction of selected CIGs to perform the velocity analysis
In this step, you decide the CIG step for the velocity analysis

Input: **kd.data_complete (migration), outfile1_complete (additional migration)**
```bash
sh ISTRICI/CIG_V1/CIGextraction
```
Output: **kd.data, outfile1**

The output files are used to perform the velocity analysis.  

-----------------
## 3. Make the picking of the first horizon
Attention: the required dx and nx are the grid values of the vfile!

Input: **stackPSDM.su**
```bash
sh ISTRICI/CIG_V1/MakePicking
```
Output: **horizon.dat, picks.dat, horizon_pick.dat** 

**horizon.dat** is the interpolation of the performed picking.  
**horizon.dat format:[X(distance) Z(depth)]**  
Suggestion: before starting the folllowing step, change the name of horizon.dat 

**horizon_pick.dat** is the file that can be used to visualise the picking in the seismic data by using the SU command, such as suximage and suxwigb.
  
-----------------
## 4. Update of velocity field (vfile) by using CIG analysis

<ins>This STEP needs to be revised.<ins>

~Some INPUT files are missing~  

Before starting this step, if you work on the first layer, it is necessary to create a file with information about its top. The file format has to be equal to horizon.dat in which the second column is equal to fz. For example, if fz=0 you can create the top file by using the following command:
```bash
awk '{print $1,0}' filenamebottom >filenametop
```
Attention: the step must be a multiple of the step used in the CIGextraction!

Suggestion: during the velocity analysis, it can be useful to visualise the stacking section, for example by using the command:
```bash
suximage <stackPSDM.su perc=98 curve=horizon_pick.dat npair=nx
```
Input: **top and bottom file of the inverted layer, vfile, kd.data, outfile1** 
```bash
sh ISTRICI/CIG_V1/UPDATEvelocity 
```
Output: **updated vfile, updated bottom file, horizon_info** 

Suggestion: change the name of the updated vfile!
Note that the old files are saved in filename_old

The file horizon_info is organized as follow sorted by column:
CDP, updated depth of the layer bottom, initial depth of layer bottom, updated velocity layer, initial velocity layer

-----------------

REPEATE the steps 1-4 until you obtain a satisfactory velocity field.  
When you decide that the velocity layer is satisfactory, you must perform the "last layer" pre-stack depth migration (step 1), make the definitive picking for the bottom of the analysed layer (step 3), which will be used as the top of the new layer. After this, move to step 5.

-----------------
## 5. Insert a new horizon or go to step 6.

Input: **vfile and its parameters, bottom of the last inverted layer, costant velocity for the new layer**
```bash
sh ISTRICI/CIG_V1/InsertNewLayer
```
Output: **new vfile**

Suggestion: change the name of the new vfile

-----------------
Go to **`step 1`** to perform the new pre-stack depth migration and the velocity analysis of the new layer

-----------------

When the velocity analysis of the last layer is completed, you must to perform the picking of the bottom inverted layer (step 3) and insert a new layer in order to create the bottom of the model (step 5). Then, you can insert a velocity gradient in depth.

-----------------
## 6. Insert a velocity gradient below the last horizon

input: **vfile, bottom file of the last inverted layer, constant velocity of the bottom layer**
```bash
sh ISTRICI/CIG_V1/InsertVelocityGradient
```
Output: **new vfile**

Suggestion: change the name of the new vfile

-----------------
## 7. Smooth the vfile and perform the final pre-stack depth migration

Input: **vfile and its parameters, seismic data** 
```bash
sh ISTRICI/CIG_V1/PerformLastPSDM
```
Output: **vfile_smooth, kd.data_complete, stackFinalPSDM.su** 

Suggestion: you can improve the final stacked section by using only selected offset in the CIG to create a stacked section. 

-----------------

GENERAL SUGGESTION: in order to remember the adopted parameters, it is possible to create a input file information.

