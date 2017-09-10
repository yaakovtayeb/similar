import pandas as pd

df1 = pd.DataFrame({'site': ['ynet', 'walla', 'ynet', 'pinterest'],
                    'value': np.random.randn(4),
                    'year': [17, 17, 16, 16]})
df2 = pd.DataFrame({'site': ['ynet', 'wix'],
                    'visits': np.random.randn(2),
                    'year': [16, 17]})

# INNER JOIN
# RESULT IS EVERYTHING THAT IS DIFFERENT

pd.merge(df1, df2, on=['site'])
# pd.merge(df1, df2, on=['site', 'year'], how='right')

frames = [df1, df2]
results = pd.concat(frames, axis=0, ignore_index=True)