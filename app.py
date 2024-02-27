# Importer les bibliothèques nécessaires
from fastapi import FastAPI
from pydantic import BaseModel
import numpy as np
from scipy.special import softmax
import random
import nltk
from nltk.stem import WordNetLemmatizer
from joblib import load 
from joblib import dump



# Charger le modèle pickle
# with open('modele_chatbot.pkl', 'rb') as model_file:
#     model = pickle.load(model_file)
# model = load("model_saved.joblib")
# Charger le modèle joblib
# model = load("model_saved.joblib")
# reponses = load("reponses.joblib")
from keras.models import load_model

# Load the saved model
model = load_model("model_saved.h5")



# Initialiser le Lemmatizer
lemma = WordNetLemmatizer()

# fonction de tokenisation et lemmatisation
def tk_lm_func(text):
    tkns = nltk.word_tokenize(text)
    tkns = [lemma.lemmatize(word) for word in tkns]
    return tkns

# fonction de vectorisation
def vectorizer_func(text, vocab):
    tkns = tk_lm_func(text)
    sent_vec = [0] * len(vocab)
    for w in tkns:
        for idx, word in enumerate(vocab):
            if word == w:
                sent_vec[idx] = 1
    return np.array(sent_vec)

# fonction de prédiction
def Pred_funct(texte, vocab, labels):
    sent_vec = vectorizer_func(texte, vocab)
    result = model.predict(np.array([sent_vec]))

    # Appliquer la fonction softmax pour obtenir des probabilités
    prob_scores = softmax(result, axis=1)

    # Récupérer la classe prédite et le score de confiance associé
    predicted_class = np.argmax(prob_scores)
    tag = labels[predicted_class]
    confidence = prob_scores[0, predicted_class]

    return tag, confidence

# fonction pour obtenir la réponse
def get_res(tag, fJson):
    list_intents = fJson['intentions']
    for i in list_intents:
        if i["tag"] == tag:
            ourResult = random.choice(i['reponses'])
            break
    return ourResult

# Charger les données 
words = []  
classes = [] 
df = {}  

# Définir une classe Pydantic pour spécifier la structure des données d'entrée
class Question(BaseModel):
    text: str

# Définir une classe Pydantic pour spécifier la structure des données de sortie
class Response(BaseModel):
    intent: str
    reponse: str
    confidence: float

# Initialiser FastAPI
app = FastAPI()

# Définir une route pour votre API
@app.post("/chat", response_model=Response)
def chat(question: Question):
    # Appeler la fonction de prédiction
    tag, confidence = Pred_funct(question.text, words, classes)
    reponse = get_res(tag, df)

    # Retourner la réponse au format Response
    return {"intent": tag, "confidence": confidence, "reponse": reponse}
