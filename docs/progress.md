---
layout: default
---

### 2019/10/26

**First Phase - 80%**
1. Front-end program can extract sentence from speech with high accuracy 
3. Currently no parameters or specific actions can be determined

```markdown
Python speech to text → Part-Of-Speech tagger
```

**TODO**
1. Extract of device name (NOUN type)
2. Start of second phase

### 2019/11/2

**First Phase - 100%**
1. Actions can be determined
2. Back-end analysis can extract `DEVICE NOUN` from text 


**TODO**
1. Continue onto second phase


### 2019/11/9

**Second Phase -- 40%**
1. Added *Syntatic Dependency Parsing* allowing creation of parse trees
2. Separation of `DEVICE NOUN`, `PARAMETER NOUN` and their corresponding `VERB`
3. Elimination of stopwords

```markdown
Python speech to text → Part-Of-Speech tagger → Syntatic Dependency Parser → Rule Matching
```


**TODO**
1. Rule-based matching to account for inaccuracy in parse trees
2. Word embeddings(BERT/Flair) for synonyms

### 2019/11/16

**Second Phase -- 60%**
1. Started revising output format to a 4 element tuple
2. Research about how to handle if statement


**TODO**
1. Finish the 4 element tuple
2. Re-dig into SpaCy for different command structure

### 2019/11/23

**Second Phase -- 85%**
1. Synonym partially done
2. New output format basically done with some minor errors to deal with


**TODO**
1. Add robustness of strcture analysis
2. Wrap off handling synonym & acronym

### 2019/11/30

**Second Phase -- 100%**
1. Synonym & acronym handling done
2. Robustness enhanced


**TODO**
1. Start doing research for the stretch goal
2. Extra effort on system robustness
3. Handle if statement

### 2019/12/7

**Third Phase Head Start**
1. Research about third phase
2. If statement partially done



**TODO**
1. Final presentation preparation
2. Finish if statement
3. Weblite update
4. Final video
