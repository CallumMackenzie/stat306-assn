# TODO

## R/Latex

- [ ] Save the new plots to disk 
- [ ] Removed extraneous summary calls/print statements 
- [ ] Add new covariates to stargazer table

## Report  

- [ ] Explain the meaning of the covariates
- [ ] Explain why the adjustment was made
- [ ] Add new covariate plots
- [ ] Add Q-Q plots
- [ ] Change the analysis/conclusions to address the new covariates 

# Final Report TODO
1. Model Selection (5 pts): The R script has our Mallow's Cp calculations, but the report doesn't mention them. We need to add a "Model Selection" subsection, explain that we used Best Subset Selection with Mallow's Cp, and drop the mallows.png plot in there to mathematically justify why we removed the interaction term.

2. Data Source (2 pts): We can't just cite Kaggle. Someone needs to check the Kaggle link, find the actual original data source, and describe the collection methodology (or explicitly state if it is a simulated dataset).

3. Exploratory Analysis (2 pts): We need to generate a quick summary statistics table (Mean, Median, Min, Max, SD) and put it in the report. We also need to write out our exact transformation formula $\log(\text{annual\_premium} - \min(\text{annual\_premium}) + 1)$ and explain why we shifted the baseline by the minimum value.

4. Submission (1 pt): Whoever submits to Canvas must make sure the .csv data file is attached alongside the .R script.


I've gone ahead and updated the LaTeX file to fix the missing points. The Data Source methodology, the explanation for our log transformation, the Model Selection write-up, and the skeleton for the summary statistics table are all in the document now.

I need someone to do a quick final pass on two things:

1. Verify the Table Numbers: Could someone run analysis.R and double-check the exact summary statistics (Min, Median, Mean, Max, SD) for our continuous variables? Update the numbers in the LaTeX table (\label{tab:summary_stats}) so they perfectly match our specific R output.

2. Add the Plot: Make sure the mallows.png plot (generated during the model selection part of the R script) is actually saved in the images/ folder and compiles correctly into the PDF.

TODO(RESUBMITION)

1) Please add a page to the beginning of your report summarizing changes that were made since the first draft. Bullet point is fine. This page does not count towards page limits. A penalty will be applied if this is not done. If no changes were made, please indicate that on the page.

2) Please indicate which group member submitted the code/data files at the end of the final report.

3) Remember to complete peer evaluations after submitting the second draft.