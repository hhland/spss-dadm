* 本程序用于拼接RFM表和买家数据表.
GET
  FILE='C:\卖家张三_买家表.sav'.
DATASET NAME 买家表.

RECODE BUY_CRED
  (MISSING = SYSMIS) ("信用得分=0" = 0) ("信用得分<=3"=0)
  ("1星级"=1.1) ("2星级"=1.2) ("3星级"=1.3) ("4星级"=1.4)  ("5星级"=1.5)
  ("1钻"=2.1) ("2钻"=2.2) ("3钻"=2.3) ("4钻"=2.4) ("5钻"=2.5)
  ("1皇冠"=3.1) ("2皇冠"=3.2) ("3皇冠"=3.3) ("4皇冠"=3.4) ("5皇冠"=3.5)
  ("1红冠"=4.1) ( "2红冠"=4.2) ("3红冠"=4.3) ("4红冠"=4.4) ("5红冠"=4.5)
  INTO BUY_CRED1.
EXEC.
VARIABLE LEVEL BUY_CRED1(ORDINAL).

STRING  BUY_PROV1 (A10).
COMPUTE BUY_PROV1=BUY_PROV.
IF BUY_PROV1="未知" OR BUY_PROV1="0"  BUY_PROV1="".
EXEC.

AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=BUY_PROV
  /N_BREAK=N.
EXEC.

IF N_BREAK<30 BUY_PROV1="其它地区".
EXEC.

* 开始对RFM分析所生成的RFM表进行操作.
DATASET ACTIVATE RFM表.
RECODE 交易_计数
  (1 = 0) (ELSE= 1)  INTO REP.
EXEC.

VARIABLE LABELS REP "是否多次交易".
VALUE LABELS REP 0"单次交易" 1"多次交易".

COMPUTE 次均金额=金额/交易_计数.
EXEC.

* 合并两文件.
SORT CASES BY buyer_id(A).
DATASET ACTIVATE 买家表.
SORT CASES BY buyer_id(A).
MATCH FILES /FILE=*
  /TABLE='RFM表'
  /BY buyer_id.
EXECUTE.



