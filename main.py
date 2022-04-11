import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import StandardScaler
from sklearn.tree import DecisionTreeRegressor
from sklearn.model_selection import cross_val_score
from sklearn import preprocessing
import matplotlib.pyplot as plt
import pandas as pd
from sklearn.ensemble import GradientBoostingRegressor


def calculateFeaturesImportance(x, y, wave, to_drop=None):
    if to_drop is not None:
        x = x.drop(to_drop, axis=1)

    rf = RandomForestRegressor(max_depth=5, n_estimators=100)
    score = sum(cross_val_score(rf, x, y, cv=5, scoring="neg_mean_absolute_error")) / 5
    print(score)

    rf = RandomForestRegressor(max_depth=5, n_estimators=100)
    rf.fit(x, y)

    features = list(x.columns)
    forest_importances = pd.Series(rf.feature_importances_, index=features)
    forest_importances = forest_importances.sort_values(ascending=False)
    fig, ax = plt.subplots()
    forest_importances.plot.bar(ax=ax)
    ax.set_title("Feature importances\nMean decrease in impurity " + wave)
    ax.set_ylabel("Mean decrease in impurity")
    fig.tight_layout()

    fig.savefig("Feature importances - Mean decrease in impurity  {}.png".format(wave))
    fig.clf()


df = pd.read_csv('DatasetPreprocessed.csv')
cases_density1 = df["First_wave_density"]
cases_density2 = df["Second_wave_density"]

df = df.drop(["First_wave_density",
              "Second_wave_density",
              "Latitude",
              "Longitude",
              "NUTS"],
             axis=1)

cases_density1 = (cases_density1.to_numpy()).reshape((-1, 1))
cases_density2 = (cases_density2.to_numpy()).reshape((-1, 1))

scaler = StandardScaler()
scaler.fit(cases_density1)
cases_density1 = scaler.transform(cases_density1)
cases_density1 = cases_density1.flatten()

scaler = StandardScaler()
scaler.fit(cases_density2)
cases_density2 = scaler.transform(cases_density2)
cases_density2 = cases_density2.flatten()

le = preprocessing.LabelEncoder()
df = df.apply(le.fit_transform)
calculateFeaturesImportance(df, cases_density1, "First Wave")
calculateFeaturesImportance(df, cases_density1, "First Wave - drop life_expectancy", to_drop=["Life_expectancy"])
calculateFeaturesImportance(df, cases_density2, "Second Wave")

plt.hist(cases_density1)
plt.title("Distribution of cases density during the 1st wave\n after standardization")
plt.xlabel("Cases density")
plt.savefig("Distribution of cases density during the 1st wave after standardization.png")
plt.clf()

plt.hist(cases_density2)
plt.title("Distribution of cases density during the 2nd wave\n after standardization")
plt.xlabel("Cases density")
plt.savefig("Distribution of cases density during the 2nd wave after standardization.png")
plt.clf()