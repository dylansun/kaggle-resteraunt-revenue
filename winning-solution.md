#### 1) Feature Engineering
* i) Square root transformation was applied to the obfuscated P variables with maximum value >= 10, to make them into the same scale, as well as the target variable “revenue”.

* ii) Random assignments of uncommon city levels to the common city levels in both training and test set, which I believe, diversified the geo location information contained in the city variable and in some of the obfuscated P variables.

Note: I discovered this to be helpful by chance. My intention was to assign uncommon city levels to their nearest common city levels. But it read the city levels differently on my laptop and on the server. It performed significantly better on the server. I am not 100% sure, but my explanation were given above.

* iii) Missing value indicator for multiple P variables, i.e. P14 to P18, P24 to P27, and P30 to P37 was created to help differentiate synthetic and real test data.

**Note**: These variables were all zeroes on 88 out of 137 rows in the training set. The proportion was much less on the test set, i.e. those rows on which these variables were not zeroes at the same time has higher probability to be synthetic. 

* iv) Type “MB”, which did not occur in training set, was changed to Type “DT” in test set.

* v) Time / Age related information was also extracted, including open day, week, month and lasting years and days.

* vi) Zeroes were treated as missing values and mice imputation was applied on training and test set separately.

#### 2) Modelling and Selection Criteria
* i ) Gradient boosting models were trained on the feature-engineered training set. I used R caret package and 10-fold cv repeated 10 times (default setting) to train the gbm models. The parameters grid used was simple to reduce over-fitting:

gbmGrid <- expand.grid(interaction.depth = c(6, 7, 8, 9),
n.trees = (3:7) * 10,
shrinkage = 0.05)

* ii ) Two statistics were used to determine the model(s) to choose: training error and training error with outliers removed. The error limits are 3.7 * 10^12 and 1.4 * 10^12, respectively.

**Note**: I tested this strategy post-deadline, it was very effective choosing the "right" models. Around one in 15-20 models trained in step i) satisfied the two constraints. i.e. I trained about 200 models (using different seed) and 11 of them had training error and training error with outliers removed both lower than the limit I set. I randomly averaged 4 of them to make it more robust as a final model. These final models scored ~1718 to ~1735 privately and ~1675 to ~1707 publicly. (I guess taking average was more effective on the public data.) 

#### 3) Possible Improvements
I read from the forum that dealing with outliers properly could improve scores, although I did not try it out myself. And in this situation, my strategy in 2) ii) might need modification.

#### 4) Conclusion
I got lucky on this competition, while my true intention was to stabilize my performance on top 5%. As you guys can see, I am trying hard to stay in top 5% on two other competitions near its end. The techniques or methods I used here might not be a good strategy for other problems/competitions, and vice versa. I am learning a lot from the Kaggle forum and by participating in Kaggle competitions and gathering experience throughout these practices. Cheers!

PS: I am also from a mathematical background, and I personally am very impressed by team BAYZ's work. It seems to me that hundreds of submissions would do the job, but 110, it's just amazing and it must have involved really smart strategies.

PS2: I wrote about my story of this competition and submitted to Kaggle's winners blog. This post has already covered all the details in my solution, so reading that blog will help you know a little bit about me. I will post the link here once it's ready. You guys are welcome to take a look.
