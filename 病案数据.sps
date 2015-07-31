comp v85_96=v85+v96.
comp v87_98=v87+v98.
comp v88_89_91=v88+v89+v91.
exec.
variable labels  v85_96 '中成药/草药费' / v87_98 '检查治疗费'
  / v88_89_91 '手术/血/氧费'.


USE ALL.
COMPUTE filter_$=(range(v83,0.1,50000)=1 & range(v29,2,200)).
FILTER BY filter_$.
EXECUTE.

comp lgv83=lg10(v83).
comp lgv29=lg10(v29).
EXECUTE.
VARIABLE LABELS lgv83 'lg(住院总费用)' / lgv29 'lg(住院天数)'.


DATASET COPY 全中医.
DATASET ACTIVATE 全中医.
DELETE VARIABLES lgv83 lgv29 v41.
comp v55=1.
exec.
DATASET COPY 全西医.
DATASET ACTIVATE 全西医.
comp v55=2.
exec.
DATASET COPY 全中西医.
DATASET ACTIVATE 全中西医.
comp v55=3.
exec.
DATASET ACTIVATE 数据集1.

ADD FILES /FILE=*
  /FILE='全中医'
  /FILE='全西医'
  /FILE='全中西医'.
EXECUTE.

DATASET CLOSE 全中医.
DATASET CLOSE 全西医.
DATASET CLOSE 全中西医.



SELECT IF (missing(lgv29)=1).
EXECUTE.

comp Pred_V83=10**(MLP_PredictedValue_2).
comp Pred_V29=10**(MLP_PredictedValue_3).
EXECUTE.
VARIABLE LABELS Pred_V83 '费用预测值' Pred_V29 '天数预测值'.
