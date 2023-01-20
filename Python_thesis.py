import pandas as pd
import numpy as np
import random
import torch
from transformers import AutoTokenizer, AutoModelForSequenceClassification, AutoModelForMaskedLM
from tqdm import tqdm
from sklearn.metrics import accuracy_score, precision_score
from sklearn import metrics


#read in csv file with cleaned text and natuur milieu
df = pd.read_csv("~/thesis-code/df_klimaatoqai-v.csv")

# # bert model can only perform sentiment analysis on 512 length, so create seperate row for each sentence
# #https://stackoverflow.com/questions/17116814/how-to-split-text-in-a-column-into-multiple-rows
copy = df

split = copy["text"].str.split(".") 

split_series = split.apply(pd.Series, 1)
split_series_clean = split_series.stack()
split_series_clean.index = split_series_clean.index.droplevel(-1)
df_split = pd.DataFrame(split_series_clean)

del copy['text']
copy = copy.join(df_split)

df_full = copy
df_full.rename(columns={0 :"text"}, inplace=True )

#check for missing values
df_full.isna().sum()
#delete rows with missing text in text column
df_full = df_full[df_full['text'].notna()]

#get random sample of 100 sentence for manual annotations
random.seed(1000)
annotations = df_full[['id_verg','id_fact','text']]
annotations = annotations.sample(n=100)
annotations[33381]

annotations.to_csv("~/thesis-code/annotations.csv")
annotated = pd.read_csv("~/thesis-code/data/annotations_final.csv")

#get labels from annotated dataset
annotated['sum_label'] = annotated[['label_1','label_2','label_3']].sum(axis=1)
annotated['label'] = 0

def full_agreement(score):
  if score == 3 or score == -3:
    return 1
annotated['full_agreement'] = annotated['sum_label'].apply(lambda x: full_agreement(x))

raw_agreement = annotated['full_agreement'].sum() / len(annotated['full_agreement'])

def final_label(score):
    if score >= 2:
        return 1
    elif score <= -2:
        return -1
    else:
        return 0

# labelled sample      
annotated['label'] = annotated['sum_label'].apply(lambda x: final_label(x))

# calculate krippendorff's alpha
import krippendorff
krippendorff.alpha(agg)

# calculate fleiss's kappa
# https://stackoverflow.com/questions/51919897/is-fleiss-kappa-a-reliable-measure-for-interannotator-agreement-the-following-r
from statsmodels.stats import inter_rater as irr
arr = annotated[['label_1','label_2','label_3']]
agg = irr.aggregate_raters(arr)
irr.fleiss_kappa(agg[0], method='fleiss')
# fleiss's kappa = 0.356

annotated['label'].value_counts()  


#performing sentiment analysis on the annotations dataset to check performance of each model
tokenizer = AutoTokenizer.from_pretrained("nlptown/bert-base-multilingual-uncased-sentiment")
model = AutoModelForSequenceClassification.from_pretrained("nlptown/bert-base-multilingual-uncased-sentiment")

def sentiment_score(text):
    tokens = tokenizer.encode(text, return_tensors='pt')
    result = model(tokens)
    return int(torch.argmax(result.logits))+1

annotated['label'].value_counts()
#use tqdm to track progress of the apply function
tqdm.pandas()  
annotated['sentiment_score_multi'] = annotated['text'].progress_apply(lambda x: sentiment_score(x))
# 32 seconds

def analysis_multi(score):
    if score < 3:
        return -1
    elif score == 3:
        return 0
    else:
        return 1
      
annotated['sentiment_multi'] = annotated['sentiment_score_multi'].progress_apply(lambda x: analysis_multi(x))
print(metrics.classification_report(annotated['label'],annotated['sentiment_multi'], digits = 3))

#model robbertje
tokenizerDTAI = AutoTokenizer.from_pretrained("DTAI-KULeuven/robbert-v2-dutch-sentiment")
modelDTAI = AutoModelForSequenceClassification.from_pretrained("DTAI-KULeuven/robbert-v2-dutch-sentiment")

def softmax(z): return np.exp(z)/((np.exp(z)).sum())

def sentiment_score_DTAI(text):
  encoded_input = tokenizer(text, return_tensors='pt')
  output = model(**encoded_input)
  scores = output[0][0].detach().numpy()
  scores = softmax(scores)
  scores_dict = {
    -1 : scores[0],
    0 : scores[1],
    1 : scores[2]
  }
  max_value = max(scores_dict, key=scores_dict.get)
  return max_value
  
annotated['sentiment_score_DTAI'] = annotated['text'].progress_apply(lambda x: sentiment_score_DTAI(x))
print(metrics.classification_report(annotated['label'],annotated['sentiment_score_DTAI'], digits = 3))


#gilesitorr finetuned
tokenizergil = AutoTokenizer.from_pretrained("gilesitorr/bert-base-multilingual-uncased-sentiment-3labels")
modelgil = AutoModelForSequenceClassification.from_pretrained("gilesitorr/bert-base-multilingual-uncased-sentiment-3labels")

def sentiment_score_gil(text):
    tokens = tokenizergil.encode(text, return_tensors='pt')
    result = modelgil(tokens)
    return int(torch.argmax(result.logits))+1
  
annotated['sentiment_score_gil'] = annotated['text'].progress_apply(lambda x: sentiment_score_gil(x))
# -> took 30 seconds

def analysis_gil(score):
    if score == 3:
        return 1
    if score == 2:
        return 0
    elif score == 1:
      return -1
    
annotated['sentiment_gil'] = annotated['sentiment_score_gil'].progress_apply(lambda x: analysis_gil(x))
print(metrics.classification_report(annotated['label'],annotated['sentiment_gil'], digits = 3))

#agreed labels of the models
annotated[]

# apply multi to full dataset
df_full['sentiment_score_multi'] = df_full['text'].progress_apply(lambda x: sentiment_score(x))
df_full.to_csv("~/thesis-code/data/df_full_sent_multi.csv")

df_full = pd.read_csv("~/thesis-code/data/df_full_sent_multi.csv")
df_full = df_full[df_full['text'].notna()]
df_full['sentiment'] = df_full['sentiment_score_multi'].apply(lambda x: analysis_multi(x))
df_full.to_csv("~/thesis-code/data/df_full_sent_multi.csv")

#binding each splitted speech fragment back together
test = df_full.groupby(['journaallijn_id','id_fact','id_mp'])['sentiment_score_multi'].mean()
test
#visualizations
import matplotlib.pyplot as plt
mean_per_party = df_full.groupby(['naam.y'])['sentiment_score_multi'].mean()
mean_per_year = df_full.groupby(['result_zittingsjaar','naam.y'])['sentiment_score_multi'].mean()

fig, ax = plt.subplots(figsize=(15,7))
df_full.groupby(['result_zittingsjaar','naam.y'])['sentiment_score_multi'].mean().unstack().plot(ax=ax)
plt.show()
plt.savefig("1")

df_full['sentiment_score_multi'].value_counts()

df_full['sentiment_multi'] = annotated['sentiment_score_multi'].progress_apply(lambda x: analysis_multi(x))



