{\rtf1\ansi\ansicpg1252\cocoartf2709
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 LET vPerio1 = Year(Today());\
LET vPerio2 = Year(Today())-1;\
LET vPerio3 = Year(Today())-2;\
LET vPerio4 = Year(Today())-3;\
LET vPerio5 = Year(Today())-4;\
LET vPerio6 = Year(Today())-5;\
LET vPerio7 = Year(Today())-6;\
\
// Input\
\
KNA1:\
LOAD\
    COUNC_KNA1,\
    KUNNR_KNA1,\
    REGIO_KNA1,\
    BRSCH_KNA1\
FROM [lib://Raiz/QVD/BASE/SAP/UNICA/KNA1.qvd]\
(qvd);\
\
let vYT = year(today())-1;\
let vA\'f1oActual = year(today());\
\
\
\
Do while vYT<=vA\'f1oActual\
\
VBRK:\
LOAD\
\
  \
     VBELN,\
     VKORG,\
     ERNAM,\
     FKDAT,\
     SPART,\
     FKART,\
     VTWEG,\
     REGIO,\
     KUNAG\
FROM [lib://Raiz/QVD/BASE/SAP/INCREMENTAL/VBRK_$(vYT)*.qvd]\
(qvd);\
\
\
Trace 'vYT=$(vYT)';\
Let vYT=vYT+1;\
//Next;\
Loop\
\
\
\
let vYT = year(today())-6;\
let vA\'f1oActual = year(today());\
\
\
Do while vYT<=vA\'f1oActual\
\
VBRKZT:\
LOAD\
\
     VBELN,\
     FKDAT,\
     KUNAG\
FROM [lib://Raiz/QVD/BASE/SAP/INCREMENTAL/VBRK_$(vYT)*.qvd]\
(qvd);\
\
\
Trace 'vYT=$(vYT)';\
Let vYT=vYT+1;\
//Next;\
Loop\
\
\
SAP_SDD:\
LOAD\
    YEAR_VBRK,\
    FKART_VBRK,\
    FKDAT_VBRK,\
    VBELN_KEY,\
    NTGEW_VBRP,\
    MATNR_VBRP\
FROM [lib://Raiz/QVD/PROCESADOS/COMERCIAL/COMPARTIDOS/SAP_SD.qvd]\
(qvd);\
\
let vYT = year(today())-1;\
let vA\'f1oActual = year(today());\
\
\
Do while vYT <= vA\'f1oActual\
\
\
VBFA:\
LOAD\
\
    VBELN_VBFA,\
    VBELV_VBFA,\
    VBTYP_N_VBFA,\
    VBTYP_V_VBFA\
  \
FROM [lib://Raiz/QVD/BASE/SAP/INCREMENTAL/VBFA_PURO_$(vYT)*.qvd]\
(qvd);\
\
\
\
Trace 'vYT=$(vYT)';\
Let vYT=vYT+1;\
Loop\
\
Trace---------------------------------------------------------------------;\
Trace-----------------------Tiempo 12 Meses-------------------------------;\
Trace---------------------------------------------------------------------;\
\
\
\
Set vCantPeriodos = 6;\
PeriodosAux:\
Load\
	chr(39)&(Year(AddMonths(Today()-1,1 - RowNo()))\
	&num(Month(AddMonths(Today()-1,1 - RowNo())), 00))&chr(39)					as Periodo\
AutoGenerate $(vCantPeriodos);\
\
\
PeriodosAux2:\
NoConcatenate LOAD\
	Concat(Periodo,', ')									as Periodo\
Resident PeriodosAux;\
//order by Periodo asc;\
DROP Table PeriodosAux;\
\
Let varPeriodos	= Peek('Periodo',0,'PeriodosAux2');\
\
DROP Table PeriodosAux2;\
\
\
\
For Each vPeriodo in $(varPeriodos)\
\
  \
Let vFechaIni = Date(Date#('$(vPeriodo)','YYYYMM'),'YYYYMMDD');\
Let vFechaFin = Date(MonthEnd(Date#('$(vPeriodo)','YYYYMM')),'YYYYMMDD');  \
LET vFecha_Qvd = Left(vPeriodo,4)&num(Right(vPeriodo,2));\
\
Trace $(vFechaIni);\
Trace $(vFechaFin);\
Trace $(vFecha_Qvd);\
\
\
VTTK:\
LOAD\
      TKNUM_VTTP,\
      EXTI1_VTTK\
FROM\
lib://Raiz/QVD\\BASE\\SAP\\INCREMENTAL\\VTTK_$(vFecha_Qvd).qvd\
(qvd);\
\
Next;\
\
Trace---------------------------------------------------------------------;\
Trace---------------------_-Cabecera Pedidos------------------------------;\
Trace---------------------------------------------------------------------;\
\
\
\
\
For Each vPeriodo in $(varPeriodos)\
\
  \
Let vFechaIni = Date(Date#('$(vPeriodo)','YYYYMM'),'YYYYMMDD');\
Let vFechaFin = Date(MonthEnd(Date#('$(vPeriodo)','YYYYMM')),'YYYYMMDD');  \
LET vFecha_Qvd = Left(vPeriodo,4)&(Right(vPeriodo,2));\
\
Trace $(vFechaIni);\
Trace $(vFechaFin);\
Trace $(vFecha_Qvd);\
\
\
VBAK:\
LOAD \
     VBELN, \
     KUNNR,\
     AUART\
FROM\
lib://Raiz/QVD\\BASE\\SAP\\INCREMENTAL\\VBAK_$(vFecha_Qvd).qvd\
(qvd);\
\
NEXT;\
\
\
For Each vPeriodo in $(varPeriodos)\
\
  \
Let vFechaIni = Date(Date#('$(vPeriodo)','YYYYMM'),'YYYYMMDD');\
Let vFechaFin = Date(MonthEnd(Date#('$(vPeriodo)','YYYYMM')),'YYYYMMDD');  \
LET vFecha_Qvd = Left(vPeriodo,4)&(Right(vPeriodo,2));\
\
Trace $(vFechaIni);\
Trace $(vFechaFin);\
Trace $(vFecha_Qvd);\
\
\
LIPS0:\
LOAD  \
     VBELN_LIPS, \
     VGBEL_LIPS,\
      SPART_LIPS, \
     MATNR_LIPS,\
     VTWEG_LIPS \
FROM\
lib://Raiz/QVD\\BASE\\SAP\\INCREMENTAL\\LIPS_$(vFecha_Qvd).qvd\
(qvd);\
\
NEXT;\
\
For Each vPeriodo in $(varPeriodos)\
\
  \
Let vFechaIni = Date(Date#('$(vPeriodo)','YYYYMM'),'YYYYMMDD');\
Let vFechaFin = Date(MonthEnd(Date#('$(vPeriodo)','YYYYMM')),'YYYYMMDD');  \
LET vFecha_Qvd = Left(vPeriodo,4)&(Right(vPeriodo,2));\
\
Trace $(vFechaIni);\
Trace $(vFechaFin);\
Trace $(vFecha_Qvd);\
\
LIKP:\
LOAD \
     KUNAG_LIKP, \
     VBELN_LIKP\
FROM\
lib://Raiz/QVD\\BASE\\SAP\\INCREMENTAL\\LIKP_$(vFecha_Qvd).qvd\
(qvd);\
\
\
\
NEXT;\
\
\
For Each vPeriodo in $(varPeriodos)\
\
  \
Let vFechaIni = Date(Date#('$(vPeriodo)','YYYYMM'),'YYYYMMDD');\
Let vFechaFin = Date(MonthEnd(Date#('$(vPeriodo)','YYYYMM')),'YYYYMMDD');  \
LET vFecha_Qvd = Left(vPeriodo,4)&num(Right(vPeriodo,2));\
\
Trace $(vFechaIni);\
Trace $(vFechaFin);\
Trace $(vFecha_Qvd);\
\
\
\
DET_SD:  \
LOAD \
	VBELN,\
	KVGR3,\
     WAVWR,\
	MATNR,\
	NTGEW							 // Codigo_Grupo_Granel_Factura\
				 // Material  \
\
FROM lib://Raiz/QVD\\BASE\\SAP\\INCREMENTAL\\VBRP_$(vFecha_Qvd).qvd (qvd) ;\
\
NEXT;\
\
\
Trace---------------------------------------------------------------------;\
Trace---------------------Movimientos Mercancia---------------------------;\
Trace---------------------------------------------------------------------;\
\
\
\
For Each vPeriodo in $(varPeriodos)\
\
  \
Let vFechaIni = Date(Date#('$(vPeriodo)','YYYYMM'),'YYYYMMDD');\
Let vFechaFin = Date(MonthEnd(Date#('$(vPeriodo)','YYYYMM')),'YYYYMMDD');  \
LET vFecha_Qvd = Left(vPeriodo,4)&num(Right(vPeriodo,2));\
\
Trace $(vFechaIni);\
Trace $(vFechaFin);\
Trace $(vFecha_Qvd);\
\
MKPF:\
LOAD \
     XBLNR_MKPF, \
     MBLNR_MKPF,\
     MJAHR_MKPF\
FROM\
lib://Raiz/QVD\\PROCESADOS\\QMGER\\MKPF_$(vFecha_Qvd).QVD\
(qvd);\
\
\
\
MSEG_aux:\
LOAD MBLNR,\
     MJAHR,\
     CHARG\
     \
FROM\
lib://Raiz/QVD\\PROCESADOS\\QMGER\\MSEG_$(vFecha_Qvd).qvd\
(qvd);\
\
NEXT;\
\
\
MCHA:\
LOAD \
     CHARG_MCHA, \
     CUOBJ_BM_MCHA\
FROM\
lib://Raiz/QVD\\BASE\\EQSAPU\\MCHA.qvd\
(qvd);\
\
\
AUSP:\
LOAD  \
     ATWRT_AUSP, \
     OBJEK_AUSP,\
     KLART_AUSP,\
     ATINN_AUSP\
FROM\
lib://Raiz/QVD\\BASE\\EQSAPU\\AUSP.qvd\
(qvd);\
\
IFLO_INFOCUS:\
LOAD  \
     ADRNR, \
     TPLNR\
FROM\
lib://Raiz/QVD\\BASE\\SAP\\UNICA\\IFLO_INFOCUS.qvd\
(qvd);\
\
FOR Each vPerio in  '$(vPerio1)','$(vPerio2)'//,'$(vPerio3)'//,'$(vPerio4)'\
\
CE4AB00_ACCT0:\
LOAD PAOBJNR, \
     VTWEG, \
     SPART, \
     KNDNR\
FROM\
lib://Raiz/QVD\\BASE\\SAP\\INCREMENTAL\\CE4AB00_ACCT_$(vPerio).qvd\
(qvd);\
\
NEXT;\
\
\
\
CE4AB00:\
LOAD\
\
    PAOBJNR_CE4AB00,\
    KNDNR_CE4AB00,\
    VTWEG_CE4AB00,\
    SPART_CE4AB00\
FROM [lib://Raiz/QVD/BASE/SAP/UNICA/CE4AB00.qvd]\
(qvd);\
\
\
Concatenate(CE4AB00_ACCT0)\
LOAD\
\
    PAOBJNR_CE4AB00				as PAOBJNR,\
    KNDNR_CE4AB00				as KNDNR,\
    VTWEG_CE4AB00				as VTWEG,\
    SPART_CE4AB00				as SPART\
Resident CE4AB00;\
\
Drop Table CE4AB00;\
\
Set vCantPeriodos = 8;\
PeriodosAux:\
Load\
	chr(39)&(Year(AddMonths(Today()-1,1 - RowNo()))\
	&num(Month(AddMonths(Today()-1,1 - RowNo())), 00))&chr(39)					as Periodo\
AutoGenerate $(vCantPeriodos);\
\
\
PeriodosAux2:\
NoConcatenate LOAD\
	Concat(Periodo,', ')									as Periodo\
Resident PeriodosAux;\
//order by Periodo asc;\
DROP Table PeriodosAux;\
\
Let varPeriodos	= Peek('Periodo',0,'PeriodosAux2');\
\
DROP Table PeriodosAux2;\
\
For Each vPeriodo in $(varPeriodos)\
\
  \
Let vFechaIni = Date(Date#('$(vPeriodo)','YYYYMM'),'YYYYMMDD');\
Let vFechaFin = Date(MonthEnd(Date#('$(vPeriodo)','YYYYMM')),'YYYYMMDD');  \
LET vFecha_Qvd = Left(vPeriodo,4)&num(Right(vPeriodo,2));\
\
Trace $(vFechaIni);\
Trace $(vFechaFin);\
Trace $(vFecha_Qvd);\
\
BKPF:\
LOAD\
    BELNR_BKPF,\
    BUKRS_BKPF,\
    BUDAT_BKPF,\
    BLDAT_BKPF,\
    GJAHR_BKPF,\
    KURSF_BKPF,\
    XBLNR_BKPF,\
    GLVOR_BKPF,\
    BKTXT_BKPF,\
    TCODE_BKPF,\
    STGRD_BKPF,\
    AWKEY_BKPF,\
    BLART_BKPF,\
    USNAM_BKPF,\
    CPUTM_BKPF,\
    BSTAT_BKPF,\
    WAERS_BKPF,\
    AWTYP_BKPF,\
    MONAT_BKPF,\
    STBLG_BKPF,\
    HWAER_BKPF,\
    REINDAT_BKPF,\
    XREVERSAL_BKPF,\
    RLDNR_BKPF,\
    STJAH_BKPF,\
    CPUDT_BKPF\
FROM [lib://Raiz/QVD/BASE/SAP/INCREMENTAL/BKPF_$(vFecha_Qvd).qvd]\
(qvd);\
\
\
\
\
NEXT;\
\
\
\
For Each vPeriodo in $(varPeriodos)\
\
  \
Let vFechaIni = Date(Date#('$(vPeriodo)','YYYYMM'),'YYYYMMDD');\
Let vFechaFin = Date(MonthEnd(Date#('$(vPeriodo)','YYYYMM')),'YYYYMMDD');  \
LET vFecha_Qvd = Left(vPeriodo,4)&num(Right(vPeriodo,2));\
\
Trace $(vFechaIni);\
Trace $(vFechaFin);\
Trace $(vFecha_Qvd);\
\
\
\
BSEG:\
LOAD\
    MATNR_BSEG,\
    GJAHR_BSEG,\
    WERKS_BSEG,\
    BUKRS_BSEG,\
    SGTXT_BSEG,\
    SHKZG_BSEG,\
    KUNNR_BSEG,\
    PAOBJNR_BSEG,\
    VBELN_BSEG,\
    EBELN_BSEG,\
    EBELP_BSEG,\
    VBEL2_BSEG,\
    HBKID_BSEG,\
    POSN2_BSEG,\
    GVTYP_BSEG,\
    DMBTR_BSEG,\
    KOSTL_BSEG,\
    HKONT_BSEG,\
    BUZEI_BSEG,\
    AUGCP_BSEG,\
    AUGDT_BSEG,\
    AUGBL_BSEG,\
    BSCHL_BSEG,\
    PPRCT_BSEG,\
    BUZID_BSEG,\
    WMWST_BSEG,\
    ZLSPR_BSEG,\
    ZUONR_BSEG,\
    LIFNR_BSEG,\
    AUFNR_BSEG,\
    BELNR_BSEG,\
    GSBER_BSEG,\
    KOART_BSEG,\
    UMSKZ_BSEG,\
    MWSKZ_BSEG,\
    QSSKZ_BSEG,\
    WRBTR_BSEG,\
    MWSTS_BSEG,\
    HWBAS_BSEG,\
    FWBAS_BSEG,\
    QSSHB_BSEG,\
    ANLN1_BSEG,\
    ANLN2_BSEG,\
    ANBWA_BSEG,\
    XINVE_BSEG,\
    ZFBDT_BSEG,\
    ZTERM_BSEG,\
    ZLSCH_BSEG,\
    MENGE_BSEG,\
    MEINS_BSEG,\
    RYACQ_BSEG,\
    RPACQ_BSEG,\
    PRCTR_BSEG,\
    NPLNR_BSEG,\
    PROJK_BSEG,\
    DMBE2_BSEG,\
    PSWSL_BSEG,\
    REBZT_BSEG,\
    PSWBT_BSEG\
FROM [lib://Raiz/QVD/BASE/SAP/INCREMENTAL/BSEG_$(vFecha_Qvd).qvd]\
(qvd);\
\
\
\
Next;\
\
\
For Each vYCu in '$(vPerio1)','$(vPerio2)'//'$(vA\'f1oCupon)','$(vA\'f1oCupon_1)'\
\
ZTCUPONESQVD:\
LOAD \
     MATNR_KGCUPONES, \
     MATNR_ZTCUPONES, \
     KUNNR_ZTCUPONES, \
     LIDAT_ZTCUPONES, \
     ENTRE_ZTCUPONES,\
     CSUMI_ZTCUPONES,\
     TRANS_ZTCUPONES, \
     FACTU_ZTCUPONES, \
     CUPON_ZTCUPONES, \
     NGUIA_ZTCUPONES, \
	 STATU_ZTCUPONES,\
     ZVALVTACUP_ZTCUPONES, \
     ZVALDESC_ZTCUPONES\
FROM\
lib://Raiz/QVD\\BASE\\SAP\\INCREMENTAL\\ZTCUPONES_$(vYCu).qvd\
(qvd);\
\
\
Next;\
\
\
\
T001WQ:\
LOAD \
     WERKS_T001W,\
     KUNNR_T001W, \
     REGIO_T001W\
FROM\
[lib://Raiz/QVD\\BASE\\SAP\\UNICA\\T001W.qvd]\
(qvd);\
\
FICA0:\
LOAD\
    NUMBER_DOCUMENT_ERDK,\
    AWKEY_FICA,\
    Regi\'f3n_Cenopers,\
    "Codigo Cliente",\
    "Comunas Suministro",\
    BUDAT_DFKKKO,\
    CMED,\
    UEBUD_DFKKSUM,\
    NBUDAT_CMED,\
    YEAR_DFKKSUM,\
    MONTH_DFKKSUM,\
    M3,\
    KG_M3\
FROM [lib://Raiz/QVD/PROCESADOS/INFOCUS/OFIC/NIVEL1/0_FICA_2020.qvd]\
(qvd);// Where YEAR_DFKKSUM&num(MONTH_DFKKSUM)= '$(vFecha_Qvd2)'	;\
\
\
MAKT:\
LOAD \
     MATNR_MAKT, \
     MAKTX_CLEAR\
    \
  \
FROM\
lib://Raiz/QVD\\BASE\\EQSAPU\\MAKT.qvd\
(qvd);\
\
T005U:\
LOAD \
BLAND_T005U,\
BEZEI_T005U,\
LAND1_T005U,\
SPRAS_T005U\
FROM\
lib://Raiz/QVD\\BASE\\SAP\\UNICA\\T005U.qvd\
(qvd);\
\
TVTWT:\
LOAD \
     VTWEG_TVTWT, \
     VTEXT_TVTWT\
FROM\
lib://Raiz/QVD\\BASE\\SAP\\UNICA\\TVTWT.qvd\
(qvd);\
\
\
T005F:\
LOAD \
     REGIO,\
     LAND1,\
     SPRAS,\
     COUNC, \
     BEZEI\
FROM\
lib://Raiz/QVD\\BASE\\SAP\\UNICA\\T005F.qvd\
(qvd);\
\
\
Cliente958:\
\
LOAD \
     C\'f3digo, \
     [Tipo Cliente]\
FROM\
[lib://Raiz/EXT\\INFOCUS\\Base Tipo Cliente(958).xlsx]\
(ooxml, embedded labels, table is [Clasificaci\'f3n tipo cliente]);\
\
Ramo958:\
LOAD Ramo, \
     Clasificaci\'f3n\
FROM\
[lib://Raiz/EXT\\INFOCUS\\Base Tipo Cliente(958).xlsx]\
(ooxml, embedded labels, table is [Clasificaci\'f3n Ramo]);\
\
\
SAP_SD:\
LOAD\
\
    VBELN_KEY				as Documento\
\
Resident SAP_SDD Where YEAR_VBRK >= '$(vYT)' and (FKART_VBRK ='ZFOC' or FKART_VBRK ='ZFS2');\
\
\
\
\
VBFA_PURO_2023:\
LOAD\
\
    VBELN_VBFA				as Documento,\
    VBELV_VBFA\
  \
Resident VBFA Where Exists(Documento,VBELN_VBFA) and VBTYP_N_VBFA = 'M';\
\
\
Drop Table SAP_SD;\
\
\
\
Left Join(VBFA_PURO_2023)\
LOAD\
\
    VBELN_VBFA				as VBELV_VBFA,\
    VBELV_VBFA				as VBELV_VBFA2\
  \
Resident VBFA Where Exists(VBELV_VBFA,VBELN_VBFA) and VBTYP_V_VBFA = 'M';\
\
\
\
Left Join(VBFA_PURO_2023)\
LOAD\
\
    VBELN					as VBELV_VBFA2,\
    FKART,\
    VTWEG,\
    KUNAG\
Resident VBRK;\
\
\
\
\
Left Join(VBFA_PURO_2023)\
LOAD\
    VBELN_KEY				as Documento,\
    VBELN_KEY&'|'&MATNR_VBRP	as DocMAt\
\
Resident SAP_SDD Where YEAR_VBRK >= '$(vYT)' and (FKART_VBRK ='ZFOC' or FKART_VBRK ='ZFS2');\
\
\
 \
\
Drop Table VBFA;\
\
\
Trace---------------------------------------------------------------------;\
Trace-----------------------------ZVCU------------------------------------;\
Trace---------------------------------------------------------------------;\
\
\
\
\
AUART:\
LOAD VBELN														as VGBEL_LIPS, \
     AUART\
Resident VBAK Where AUART = 'ZVCU';\
\
\
\
LIPSx:\
//Left Keep(Contabilidad)\
LOAD Distinct \
     VBELN_LIPS													as XBLNR_BKPF, \
     //'ZVCU'														as AUART,\
     VGBEL_LIPS\
Resident LIPS0 Where Exists(VGBEL_LIPS,VGBEL_LIPS);\
\
\
\
Left Join(LIPSx)\
LOAD\
VGBEL_LIPS,\
AUART\
Resident AUART;\
DROP Table AUART;\
\
KG_CUPO:\
LOAD\
VBELN									as VBELN_CUPO,\
VBELN&'|'&MATNR							as KG_CUPO,\
NTGEW									as NTGEW_CUPO,\
WAVWR									as WAVWR_CUPO\
Resident DET_SD;\
\
Left Join(KG_CUPO)\
LOAD\
     VBELN						as VBELN_CUPO, \
     FKART						as FKART_CUPO\
     Resident VBRK;\
     \
\
\
MSEG:\
LOAD MBLNR&MJAHR								as KEEY_MKPF,\
     CHARG\
     \
Resident MSEG_aux;\
Drop Table MSEG_aux;\
\
\
Left Join(MSEG)\
LOAD \
XBLNR_MKPF,\
MBLNR_MKPF&MJAHR_MKPF						as AWKEY_BKPF,\
 MBLNR_MKPF&MJAHR_MKPF						as KEEY_MKPF\
Resident MKPF;\
DROP Table MKPF;\
\
\
\
Left Join(MSEG)\
LOAD Distinct\
     CHARG_MCHA							as CHARG, \
     CUOBJ_BM_MCHA						as OBJEK_AUSP\
Resident MCHA;\
\
\
Left Join(MSEG)\
LOAD Distinct \
     ATWRT_AUSP, \
     OBJEK_AUSP\
Resident AUSP Where KLART_AUSP = '022' and ATINN_AUSP= '0000000508';\
\
//IFLO:\
Left Join(MSEG)\
LOAD Distinct \
     ADRNR, \
     TPLNR						as ATWRT_AUSP\
Resident IFLO_INFOCUS;\
\
\
\
Drop Table MCHA;\
Drop Table AUSP;\
Drop Table IFLO_INFOCUS;\
\
LIPS:\
LOAD \
     SPART_LIPS, \
     VBELN_LIPS						as VBELN_LIKP, \
     MATNR_LIPS,\
     VTWEG_LIPS \
   \
Resident LIPS0;\
\
\
Left Join(LIPS)\
LOAD  KUNAG_LIKP, \
      VBELN_LIKP,\
      VBELN_LIKP						as XBLNR_MKPF\
Resident LIKP;\
\
\
\
\
Left Join(MSEG)\
LOAD Distinct \
XBLNR_MKPF,\
KUNAG_LIKP,\
VBELN_LIKP,\
MATNR_LIPS,\
SPART_LIPS,\
VTWEG_LIPS\
Resident LIPS;\
DROP Table LIPS;\
\
\
DROP Table LIPS0;\
\
\
CE4AB00_ACCT:\
LOAD 111111,\
     PAOBJNR, \
     VTWEG, \
     SPART, \
     KNDNR\
Resident CE4AB00_ACCT0 Where \
(if(KNDNR = '' or KNDNR = ' ' or IsNull(KNDNR),0,1) = 1) and \
(if(VTWEG = '' or VTWEG = ' ' or IsNull(VTWEG),0,1) = 1) and\
(if(SPART = '' or SPART = ' ' or IsNull(SPART),0,1) = 1);\
Drop Table CE4AB00_ACCT0;\
\
\
MPBKPF:\
\
LOAD //Distinct\
XBLNR_BKPF,\
AWKEY_BKPF\
Resident BKPF where BUKRS_BKPF='10';\
\
\
ZUONR_BSEG:\
\
LOAD\
BELNR_BSEG,\
ZUONR_BSEG\
Resident BSEG Where if(ZUONR_BSEG = ' ' or ZUONR_BSEG='' or IsNull(ZUONR_BSEG),0,1)=1 and\
(HKONT_BSEG = '0031111110' or \
HKONT_BSEG = '0021205003' or \
HKONT_BSEG = '0021205004' or \
HKONT_BSEG = '0031111222 ' or \
HKONT_BSEG = '0031111111' or \
HKONT_BSEG = '0031111107' or \
HKONT_BSEG = '0031111101' or \
HKONT_BSEG = '0031111115' or \
HKONT_BSEG = '0031111102' or\
HKONT_BSEG = '0031111120' or\
HKONT_BSEG = '0031111121' or\
HKONT_BSEG = '0031111122' or\
HKONT_BSEG = '0031111123' or\
HKONT_BSEG = '0031111124' or\
HKONT_BSEG = '0031111140' or\
HKONT_BSEG = '0031111141' or\
HKONT_BSEG = '0031111142' or\
HKONT_BSEG = '0031111144' or\
HKONT_BSEG = '0031111145' or\
HKONT_BSEG = '0031111147' or\
HKONT_BSEG = '0031111116' or\
HKONT_BSEG = '0031111148' or\
HKONT_BSEG = '0031111201' or\
HKONT_BSEG = '0031111202' or\
HKONT_BSEG = '0031111203' or\
HKONT_BSEG = '0031111204' or\
HKONT_BSEG = '0031111207' or\
HKONT_BSEG = '0031111212' or\
HKONT_BSEG = '0031111828' or\
HKONT_BSEG = '0031111146' or\
HKONT_BSEG = '0031111222' or\
HKONT_BSEG = '0031111149' or\
HKONT_BSEG = '0031111250' or \
HKONT_BSEG = '0031111251' or\
HKONT_BSEG = '0031111247' or\
HKONT_BSEG = '0031111248' or\
\
HKONT_BSEG = '0031111139' or\
HKONT_BSEG = '0031111142' or\
HKONT_BSEG = '0011106047' or\
\
HKONT_BSEG = '0032100153' or\
HKONT_BSEG = '0032100154' or\
HKONT_BSEG = '0032100150' or\
HKONT_BSEG = '0032100151' or\
HKONT_BSEG = '0032100152' or\
HKONT_BSEG = '0031111140' or\
HKONT_BSEG = '0031111141' or\
HKONT_BSEG = '0031111143'\
)\
and (BUKRS_BSEG = '10');\
\
\
Drop Table BKPF;\
\
Drop Table BSEG;\
\
TIPO_CLIENTE:\
Mapping\
//Left Join(CUPON_INFOCUS)\
LOAD Distinct\
     C\'f3digo															as KUNNR_INFOCUS_NM, \
//     [Destinatario mc\'eda.], \
//     Regi\'f3n, \
     Capitalize([Tipo Cliente])										as [Tipo Cliente]\
Resident Cliente958;\
\
\
Trace---------------------------------------------------------------------;\
Trace-----------------------Tiempo 1 Meses-------------------------------;\
Trace---------------------------------------------------------------------;\
\
\
Set vCantPeriodos = 1;\
PeriodosAux6:\
Load\
	chr(39)&(Year(AddMonths(Today()-1,1 - RowNo()))\
	&num(Month(AddMonths(Today()-1,1 - RowNo())), 00))&chr(39)					as Periodo\
AutoGenerate $(vCantPeriodos);\
\
\
PeriodosAux7:\
NoConcatenate LOAD\
	Concat(Periodo,', ')									as Periodo\
Resident PeriodosAux6;\
//order by Periodo asc;\
DROP Table PeriodosAux6;\
\
Let varPeriodos2	= Peek('Periodo',0,'PeriodosAux7');\
\
DROP Table PeriodosAux7;\
\
\
\
For Each vPeriodo2 in $(varPeriodos2)\
\
  \
Let vFechaIni2 = Date(Date#('$(vPeriodo2)','YYYYMM'),'YYYYMMDD');\
Let vFechaFin2 = Date(MonthEnd(Date#('$(vPeriodo2)','YYYYMM')),'YYYYMMDD');  \
LET vFecha_Qvd2 = Left(vPeriodo2,4)&num(Right(vPeriodo2,2));\
LET vFecha_A\'f1o = Left(vPeriodo2,4);\
\
Trace $(vFechaIni2);\
Trace $(vFechaFin2);\
Trace $(vFecha_Qvd2);\
\
\
BKPF:\
LOAD\
    BELNR_BKPF,\
    BUKRS_BKPF,\
    BUDAT_BKPF,\
    BLDAT_BKPF,\
    GJAHR_BKPF,\
    KURSF_BKPF,\
    XBLNR_BKPF,\
    GLVOR_BKPF,\
    BKTXT_BKPF,\
    TCODE_BKPF,\
    STGRD_BKPF,\
    AWKEY_BKPF,\
    BLART_BKPF,\
    USNAM_BKPF,\
    CPUTM_BKPF,\
    BSTAT_BKPF,\
    WAERS_BKPF,\
    AWTYP_BKPF,\
    MONAT_BKPF,\
    STBLG_BKPF,\
    HWAER_BKPF,\
    REINDAT_BKPF,\
    XREVERSAL_BKPF,\
    RLDNR_BKPF,\
    STJAH_BKPF,\
    CPUDT_BKPF\
FROM [lib://Raiz/QVD/BASE/SAP/INCREMENTAL/BKPF_$(vFecha_Qvd2).qvd]\
(qvd);\
\
\
BSEG:\
LOAD\
    MATNR_BSEG,\
    GJAHR_BSEG,\
    WERKS_BSEG,\
    BUKRS_BSEG,\
    SGTXT_BSEG,\
    SHKZG_BSEG,\
    KUNNR_BSEG,\
    PAOBJNR_BSEG,\
    VBELN_BSEG,\
    EBELN_BSEG,\
    EBELP_BSEG,\
    VBEL2_BSEG,\
    HBKID_BSEG,\
    POSN2_BSEG,\
    GVTYP_BSEG,\
    DMBTR_BSEG,\
    KOSTL_BSEG,\
    HKONT_BSEG,\
    BUZEI_BSEG,\
    AUGCP_BSEG,\
    AUGDT_BSEG,\
    AUGBL_BSEG,\
    BSCHL_BSEG,\
    PPRCT_BSEG,\
    BUZID_BSEG,\
    WMWST_BSEG,\
    ZLSPR_BSEG,\
    ZUONR_BSEG,\
    LIFNR_BSEG,\
    AUFNR_BSEG,\
    BELNR_BSEG,\
    GSBER_BSEG,\
    KOART_BSEG,\
    UMSKZ_BSEG,\
    MWSKZ_BSEG,\
    QSSKZ_BSEG,\
    WRBTR_BSEG,\
    MWSTS_BSEG,\
    HWBAS_BSEG,\
    FWBAS_BSEG,\
    QSSHB_BSEG,\
    ANLN1_BSEG,\
    ANLN2_BSEG,\
    ANBWA_BSEG,\
    XINVE_BSEG,\
    ZFBDT_BSEG,\
    ZTERM_BSEG,\
    ZLSCH_BSEG,\
    MENGE_BSEG,\
    MEINS_BSEG,\
    RYACQ_BSEG,\
    RPACQ_BSEG,\
    PRCTR_BSEG,\
    NPLNR_BSEG,\
    PROJK_BSEG,\
    DMBE2_BSEG,\
    PSWSL_BSEG,\
    REBZT_BSEG,\
    PSWBT_BSEG\
FROM [lib://Raiz/QVD/BASE/SAP/INCREMENTAL/BSEG_$(vFecha_Qvd2).qvd]\
(qvd);\
\
\
Left Join(BKPF)\
// XBLNR_BKPF:\
// Mapping\
//Left Join(Contabilidad)\
LOAD Distinct \
XBLNR_BKPF,\
AUART\
Resident LIPSx;\
\
\
\
Cabecera_Contabilidad:\
LOAD \
BELNR_BKPF & ' | ' & BUKRS_BKPF																						as ID_BELNR ,\
BUKRS_BKPF,\
BELNR_BKPF,\
BUDAT_BKPF,\
BLART_BKPF,\
num(BUDAT_BKPF)																										    as NBUDAT_BKPF,\
Year(BUDAT_BKPF)																										as YBUDAT_BKPF,\
Month(BUDAT_BKPF)																										as MBUDAT_BKPF,\
Capitalize(MonthName(BUDAT_BKPF))																						as MNBUDAT_BKPF,\
Num(MonthName(BUDAT_BKPF))																								as MNNBUDAT_BKPF,\
// ApplyMap('XBLNR_BKPF',XBLNR_BKPF,null())																				as AUART,\
XBLNR_BKPF,\
AUART,\
\
// USNAM_BKPF&'-'&Trim(PurgeChar(mid(BKTXT_BKPF,FindOneOf(BKTXT_BKPF,' ')+1,20),' '))&'-'&Num((BUDAT_BKPF))&'-'&Time(CPUTM_BKPF,'hh:mm')		as BKTXT_AWKEY,\
\
AWKEY_BKPF,\
\
\
Trim(PurgeChar(mid(BKTXT_BKPF,FindOneOf(BKTXT_BKPF,' ')+1,20),' '))														as KeyKUNAG_AWKEY,\
Trim(PurgeChar(mid(BKTXT_BKPF,FindOneOf(BKTXT_BKPF,' ')+1,20),' '))														as BKTXT_AWKEY,\
\
// ApplyMap('MAPMSEG4',AWKEY_BKPF,null())																					as ATWRT_AUSP,\
\
AWTYP_BKPF,\
FileBaseName()	as	FileBaseName					\
Resident BKPF where BUKRS_BKPF='10' ;\
\
Drop Table BKPF;\
\
\
Left Join(Cabecera_Contabilidad)\
LOAD Distinct\
 VBELN						as AWKEY_BKPF,\
 if(VTWEG='VL','RP',VTWEG)  as VTWEG_VBRK1,\
SPART						as SPART_VBRK1,\
VTWEG						as VTWEG_ORIG1,\
KUNAG						as KUNAG_VBRK1,\
FKART						as FKART_VBRK\
Resident VBRK;\
\
\
Left Join(Cabecera_Contabilidad)\
LOAD Distinct \
 VBELN						as KeyKUNAG_AWKEY, \
KUNAG						as KUNAG_AWKEY\
Resident VBRK;\
\
Left Join(Cabecera_Contabilidad)\
LOAD Distinct\
     VBELN						as BKTXT_AWKEY, \
     KUNNR						as KUNNR_AWKEY2//KUNNRCU		\
Resident VBAK;\
\
\
Left Join(Cabecera_Contabilidad)\
LOAD Distinct\
VBELN						as AWKEY_BKPF,\
KVGR3						as KVGR3_KEY\
Resident DET_SD;\
\
\
\
\
Left Join(Cabecera_Contabilidad)\
LOAD Distinct\
AWKEY_BKPF,\
KUNAG_LIKP,\
VBELN_LIKP,\
SPART_LIPS,\
VTWEG_LIPS,\
ATWRT_AUSP\
Resident MSEG;\
\
\
\
00:\
Left Keep(BSEG)\
LOAD //Distinct\
BELNR_BSEG,\
ZUONR_BSEG,\
0001\
Resident ZUONR_BSEG;\
\
\
Left Join(00)\
LOAD //Distinct\
XBLNR_BKPF																										as ZUONR_BSEG,\
AWKEY_BKPF																										as AWKEY_ZUONR\
Resident MPBKPF;\
\
\
Left Join(00)\
LOAD //Distinct\
 VBELN						as AWKEY_ZUONR,\
 if(VTWEG='VL','RP',VTWEG)  as VTWEG_ZUONR\
Resident VBRK;\
\
Left Join(00)\
// MAP1:\
// Mapping\
LOAD //Distinct\
 VBELN						as AWKEY_ZUONR,\
SPART						as SPART_ZUONR,\
if(VTWEG='VL','RP',VTWEG)	as VTWEG_ZUONR,\
KUNAG						as KUNAG_ZUONR\
Resident VBRK;\
\
\
\
\
TMP_BSEG:\
LOAD \
BELNR_BSEG,\
HKONT_BSEG,\
BUKRS_BSEG,\
PAOBJNR_BSEG\
Resident BSEG;\
\
Left Join(TMP_BSEG)\
LOAD\
BELNR_BKPF						as BELNR_BSEG,\
AWTYP_BKPF\
Resident Cabecera_Contabilidad;\
\
\
PAOBJNR:\
\
LOAD Distinct\
BELNR_BSEG,\
PAOBJNR_BSEG\
Resident TMP_BSEG Where (PAOBJNR_BSEG <> '0000000000') and \
(HKONT_BSEG = '0031111110' or \
HKONT_BSEG = '0021205003' or \
HKONT_BSEG = '0021205004' or \
HKONT_BSEG = '0031111222 ' or \
HKONT_BSEG = '0031111111' or \
HKONT_BSEG = '0031111107' or \
HKONT_BSEG = '0031111101' or \
HKONT_BSEG = '0031111115' or \
HKONT_BSEG = '0031111102' or\
HKONT_BSEG = '0031111120' or\
HKONT_BSEG = '0031111121' or\
HKONT_BSEG = '0031111122' or\
HKONT_BSEG = '0031111123' or\
HKONT_BSEG = '0031111124' or\
HKONT_BSEG = '0031111140' or\
HKONT_BSEG = '0031111141' or\
HKONT_BSEG = '0031111142' or\
HKONT_BSEG = '0031111144' or\
HKONT_BSEG = '0031111145' or\
HKONT_BSEG = '0031111147' or\
HKONT_BSEG = '0031111116' or\
HKONT_BSEG = '0031111148' or\
HKONT_BSEG = '0031111201' or\
HKONT_BSEG = '0031111202' or\
HKONT_BSEG = '0031111203' or\
HKONT_BSEG = '0031111204' or\
HKONT_BSEG = '0031111207' or\
HKONT_BSEG = '0031111212' or\
HKONT_BSEG = '0031111828' or\
HKONT_BSEG = '0031111146' or\
HKONT_BSEG = '0031111222' or\
HKONT_BSEG = '0031111149' or\
HKONT_BSEG = '0031111250' or \
HKONT_BSEG = '0031111251' or\
HKONT_BSEG = '0031111247' or\
HKONT_BSEG = '0031111248' or\
\
HKONT_BSEG = '0031111295' or\
HKONT_BSEG = '0031111296' or\
HKONT_BSEG = '0031111297' or\
\
HKONT_BSEG = '0031111139' or\
HKONT_BSEG = '0031111142' or\
HKONT_BSEG = '0011106047' or\
\
HKONT_BSEG = '0032100127' or\
HKONT_BSEG = '0031111276' or\
\
HKONT_BSEG = '0032100153' or\
HKONT_BSEG = '0032100154' or\
HKONT_BSEG = '0032100150' or\
HKONT_BSEG = '0032100151' or\
HKONT_BSEG = '0032100152' or\
HKONT_BSEG = '0031111140' or\
HKONT_BSEG = '0031111141' or\
HKONT_BSEG = '0031111294' or\
HKONT_BSEG = '0032100101' or\
HKONT_BSEG = '0031111253' or\
\
\
HKONT_BSEG = '0032100158' or\
HKONT_BSEG = '0032100159' or\
HKONT_BSEG = '0032100160' or\
HKONT_BSEG = '0032100161' or\
HKONT_BSEG = '0032100162' or\
HKONT_BSEG = '0032100163' or\
\
\
\
\
\
HKONT_BSEG = '0031111143'\
// HKONT_BSEG = '0031111119' or\
// HKONT_BSEG = '0031111269'\
)\
and (BUKRS_BSEG = '10') And AWTYP_BKPF = 'BKPF';\
DROP Table TMP_BSEG;\
\
Left Join(PAOBJNR)\
LOAD \
BELNR_BSEG,\
Count(DISTINCT PAOBJNR_BSEG)					as CNT_PAOBJNR\
\
Resident PAOBJNR Group By BELNR_BSEG;\
\
\
\
Left Join(BSEG)\
// CU_BELNR_BSEGII:\
// Mapping\
LOAD Distinct\
BELNR_BSEG,\
'CU'																												as CU_BELNR\
Resident BSEG  Where (HKONT_BSEG = '0021205003' or \
HKONT_BSEG = '0021205004') and (BUKRS_BSEG = '10');\
\
\
Left Join(BSEG)\
// BELNR_KUNNRII:\
// Mapping\
LOAD  Distinct\
BELNR_BSEG,\
KUNNR_BSEG\
Resident BSEG \
Where (if(IsNull(KUNNR_BSEG) or KUNNR_BSEG = '' or KUNNR_BSEG = ' ',0,1) = 1) and (BUKRS_BSEG = '10');\
\
Left Join(BSEG)\
// CE4AB00_VTWEG:\
// Mapping\
LOAD Distinct \
     PAOBJNR								as PAOBJNR_BSEG,  \
     VTWEG									as VTWEG_ACCT2,\
     SPART									as SPART_ACCT2,\
     KNDNR									as KUNAG_ACCT2\
Resident CE4AB00_ACCT;\
\
//***********************\
//***********************\
//***********************\
// Problemas Frecuencia\
//***********************\
//***********************\
//***********************\
//***********************\
\
\
// Left Join(BSEG)\
// LOAD Distinct\
//  VBELN						as ZUONR_BSEG,\
// SPART						as SPART_ZUO,\
// if(VTWEG='VL','RP',VTWEG)	as VTWEG_ZUO,\
// KUNAG						as KUNAG_ZUO\
// Resident VBRK;\
\
\
VTWEG_ZUONR00:\
// Left Keep(BSEG)\
LOAD Distinct\
BELNR_BSEG,\
SPART_ZUONR,\
VTWEG_ZUONR,\
KUNAG_ZUONR\
Resident 00;\
Drop Table 00;\
\
\
\
PAOBJNR_BSEG:\
// Mapping\
LOAD Distinct\
BELNR_BSEG,\
PAOBJNR_BSEG								as PAOBJNR_BSEG2\
Resident PAOBJNR Where CNT_PAOBJNR=1;\
DROP Table PAOBJNR;\
\
Left Join(PAOBJNR_BSEG)\
LOAD Distinct \
     PAOBJNR								as PAOBJNR_BSEG2,  \
     VTWEG									as VTWEG_ACCT,\
     SPART									as SPART_ACCT,\
     KNDNR									as KUNAG_ACCT\
Resident CE4AB00_ACCT;\
\
\
Left Join(BSEG)\
LOAD Distinct \
BELNR_BSEG,\
VTWEG_ACCT,\
SPART_ACCT,\
KUNAG_ACCT\
Resident PAOBJNR_BSEG;\
Drop Table PAOBJNR_BSEG;\
\
\
Left Join(BSEG)\
// MPFIL:\
// Mapping\
LOAD Distinct\
BELNR_BSEG,\
'N'											as NMPFIL\
Resident BSEG Where HKONT_BSEG = '0031111222';			\
\
Mp1:\
Mapping\
LOAD Distinct\
BELNR_BSEG,\
SPART_ZUONR\
// VTWEG_ZUONR\
// KUNAG_ZUONR\
Resident VTWEG_ZUONR00;\
\
\
Mp2:\
Mapping\
LOAD Distinct\
BELNR_BSEG,\
// SPART_ZUONR,\
VTWEG_ZUONR\
// KUNAG_ZUONR\
Resident VTWEG_ZUONR00;\
\
Mp3:\
Mapping\
LOAD Distinct\
BELNR_BSEG,\
// SPART_ZUONR,\
// VTWEG_ZUONR\
KUNAG_ZUONR\
Resident VTWEG_ZUONR00;\
\
\
\
Drop Table VTWEG_ZUONR00;\
\
DMBTR_BSEG:\
LOAD\
CU_BELNR,\
BELNR_BSEG,\
if(IsNull(CU_BELNR),'NO MATCH',CU_BELNR)																			as MATCH_CU,\
\
KUNNR_BSEG,\
\
SPART_ACCT2,\
VTWEG_ACCT2,\
KUNAG_ACCT2,\
\
SPART_ACCT,\
VTWEG_ACCT,\
KUNAG_ACCT,\
\
//// SPART_ZUO,\
//// VTWEG_ZUO,\
//// KUNAG_ZUO,\
\
\
ApplyMap('Mp1',BELNR_BSEG,null())      as SPART_ZUONR,\
ApplyMap('Mp2',BELNR_BSEG,null())      as VTWEG_ZUONR,\
ApplyMap('Mp3',BELNR_BSEG,null())      as KUNAG_ZUONR,\
\
\
\
BELNR_BSEG & ' | ' & BUKRS_BSEG																						as ID_BELNR,\
SGTXT_BSEG,\
if(HKONT_BSEG = '0031111201',if(IsNull(NMPFIL),'Y',NMPFIL),'Y')														as MPFIL,\
\
if(HKONT_BSEG='0031111101' or HKONT_BSEG='0031111202','GR NOR',null())													as MATNR_CMED,\
if(HKONT_BSEG='0031111101' or HKONT_BSEG='0031111202','GR',null())														as SPART_CMED,\
if(HKONT_BSEG='0031111101' or HKONT_BSEG='0031111202','ME',null())														as VTWEG_CMED,\
\
\
if(\
HKONT_BSEG = '0031111110' or \
HKONT_BSEG = '0021205003' or \
HKONT_BSEG = '0021205005' or\
HKONT_BSEG = '0031111111' or \
HKONT_BSEG = '0031111107' or \
HKONT_BSEG = '0031111101' or \
HKONT_BSEG = '0011106047'  or \
HKONT_BSEG = '0031111115','Ingreso por venta de gas',\
if(\
HKONT_BSEG = '0031111102' or\
HKONT_BSEG = '0021205004' or \
HKONT_BSEG = '0021205006' or\
HKONT_BSEG = '0031111120' or\
HKONT_BSEG = '0031111121' or\
HKONT_BSEG = '0031111122' or\
HKONT_BSEG = '0031111123' or\
HKONT_BSEG = '0031111124' or\
HKONT_BSEG = '0031111140' or\
HKONT_BSEG = '0031111141' or\
HKONT_BSEG = '0031111142' or\
HKONT_BSEG = '0031111144' or\
HKONT_BSEG = '0031111145' or\
HKONT_BSEG = '0031111147' or\
HKONT_BSEG = '0031111149' or\
HKONT_BSEG = '0031111116' or\
HKONT_BSEG = '0031111148' or\
HKONT_BSEG = '0031111146','Descuentos por gas',\
if(	\
HKONT_BSEG = '0031111201' or\
HKONT_BSEG = '0031111202' or\
HKONT_BSEG = '0031111250' or \
HKONT_BSEG = '0031111251','Costo por venta de gas licuado',\
if(\
HKONT_BSEG = '0031111203' or\
HKONT_BSEG = '0031111204' or\
HKONT_BSEG = '0031111207' or\
HKONT_BSEG = '0031111212' or\
HKONT_BSEG = '0031111247' or\
HKONT_BSEG = '0031111248' or\
HKONT_BSEG = '0031111296' or\
HKONT_BSEG = '0031111294' or\
HKONT_BSEG = '0032100101' or\
HKONT_BSEG = '0031111253' or\
HKONT_BSEG = '0031111295' or\
HKONT_BSEG = '0031111297' or\
HKONT_BSEG = '0031111828','Otros Costos de venta de gas'))))\
																						as GRUPP_BSEG,																								\
if((HKONT_BSEG='0031111107') and \
(MATNR_BSEG = '' or MATNR_BSEG = ' ' or IsNull(MATNR_BSEG)),'GR CAT',MATNR_BSEG)										as MATNR_BSEG,\
HKONT_BSEG,\
DMBTR_BSEG,\
\
// Round(if(HKONT_BSEG = '0021205003' or HKONT_BSEG = '0021205004'or HKONT_BSEG = '0021205005' or HKONT_BSEG = '0021205006',0,if(SHKZG_BSEG='S',DMBTR_BSEG*100,DMBTR_BSEG*-100)/1))									as DMBTR_$2,\
Round(if(SHKZG_BSEG='S',DMBTR_BSEG*100,DMBTR_BSEG*-100))																							as DMBTR_$_Aux,\
// Round(if(HKONT_BSEG = '0021205003' or HKONT_BSEG = '0021205004'or HKONT_BSEG = '0021205005' or HKONT_BSEG = '0021205006',0,if(SHKZG_BSEG='S',DMBTR_BSEG*100,DMBTR_BSEG*-100)/1000))								as DMBTR_M$,\
// Round(if(HKONT_BSEG = '0021205003' or HKONT_BSEG = '0021205004'or HKONT_BSEG = '0021205005' or HKONT_BSEG = '0021205006',0,if(SHKZG_BSEG='S',DMBTR_BSEG*100,DMBTR_BSEG*-100)/1000000))							as DMBTR_MM$,\
\
PAOBJNR_BSEG\
Resident BSEG Where \
(HKONT_BSEG = '0031111110' or \
HKONT_BSEG = '0021205003' or \
HKONT_BSEG = '0021205004' or \
HKONT_BSEG = '0031111222 ' or \
HKONT_BSEG = '0031111111' or \
HKONT_BSEG = '0031111107' or \
HKONT_BSEG = '0031111101' or \
HKONT_BSEG = '0031111115' or \
HKONT_BSEG = '0031111102' or\
HKONT_BSEG = '0031111120' or\
HKONT_BSEG = '0031111121' or\
HKONT_BSEG = '0031111122' or\
HKONT_BSEG = '0031111123' or\
HKONT_BSEG = '0031111124' or\
HKONT_BSEG = '0031111140' or\
HKONT_BSEG = '0031111141' or\
HKONT_BSEG = '0031111142' or\
HKONT_BSEG = '0031111144' or\
HKONT_BSEG = '0031111145' or\
HKONT_BSEG = '0031111147' or\
HKONT_BSEG = '0031111116' or\
HKONT_BSEG = '0031111148' or\
HKONT_BSEG = '0031111201' or\
HKONT_BSEG = '0031111202' or\
HKONT_BSEG = '0031111203' or\
HKONT_BSEG = '0031111204' or\
HKONT_BSEG = '0031111207' or\
HKONT_BSEG = '0031111212' or\
HKONT_BSEG = '0031111828' or\
HKONT_BSEG = '0031111146' or\
HKONT_BSEG = '0031111222' or\
HKONT_BSEG = '0031111149' or\
HKONT_BSEG = '0031111250' or \
HKONT_BSEG = '0031111251' or\
HKONT_BSEG = '0031111247' or\
HKONT_BSEG = '0031111248' or\
HKONT_BSEG = '0031111295' or\
HKONT_BSEG = '0031111296' or\
HKONT_BSEG = '0031111297' or\
\
HKONT_BSEG = '0032100127' or\
HKONT_BSEG = '0031111276' or\
\
HKONT_BSEG = '0031111139' or\
HKONT_BSEG = '0031111142' or\
HKONT_BSEG = '0011106047' or\
\
\
HKONT_BSEG = '0032100158' or\
HKONT_BSEG = '0032100159' or\
HKONT_BSEG = '0032100160' or\
HKONT_BSEG = '0032100161' or\
HKONT_BSEG = '0032100162' or\
HKONT_BSEG = '0032100163' or\
\
\
HKONT_BSEG = '0032100153' or\
HKONT_BSEG = '0032100154' or\
HKONT_BSEG = '0032100150' or\
HKONT_BSEG = '0032100151' or\
HKONT_BSEG = '0032100152' or\
HKONT_BSEG = '0031111140' or\
HKONT_BSEG = '0031111141' or\
HKONT_BSEG = '0031111294' or\
HKONT_BSEG = '0032100101' or\
HKONT_BSEG = '0031111253' or\
HKONT_BSEG = '0031111143'\
\
)\
and BUKRS_BSEG = '10';\
\
\
\
\
left join(DMBTR_BSEG)\
\
LOAD *\
\
Resident Cabecera_Contabilidad;\
DROP Table Cabecera_Contabilidad;\
\
\
\
Contabilidad:\
LOAD *,\
if(HKONT_BSEG='0011106047',0,\
if(HKONT_BSEG = '0031111149' and MNNBUDAT_BKPF < '43405' ,0, \
 DMBTR_$_Aux))                                                                                	as DMBTR_$,\
 \
//  if((HKONT_BSEG='0011106047') \
//  or (HKONT_BSEG = '0031111149' \
//  and MNNBUDAT_BKPF < '43405') ,0,DMBTR_$_Aux)                                               	 as $DMBTR_$,\
 \
Coalesce(SPART_VBRK1,SPART_ACCT2,SPART_ACCT,SPART_ZUONR)								as SPART_VBRK,\
Coalesce(VTWEG_VBRK1,VTWEG_ACCT2,VTWEG_ACCT,VTWEG_ZUONR)								as VTWEG_VBRK,\
Coalesce(VTWEG_ORIG1,VTWEG_ACCT2,VTWEG_ACCT,VTWEG_ZUONR)								as VTWEG_ORIG,\
Coalesce(KUNAG_VBRK1,KUNAG_ACCT2,KUNAG_ACCT,KUNAG_ZUONR)								as KUNAG_VBRK,    //Borrar\
\
if((YBUDAT_BKPF >= 2017) and  (MATCH_CU = 'CU') and (HKONT_BSEG = '0031111110' or HKONT_BSEG = '0031111102' or HKONT_BSEG = '0031111115' or HKONT_BSEG = '0031111116' or HKONT_BSEG = '0031111207'),'N','Y')					as YCU_BKPF\
\
\
Resident DMBTR_BSEG;\
Drop Table DMBTR_BSEG;\
\
DROP Field DMBTR_$_Aux From Contabilidad;\
\
\
\
Contabilidadxx:\
\
LOAD *,\
AWKEY_BKPF&'|'&MATNR_BSEG																					as AWKEY_MATNR,\
\
Coalesce(KUNAG_VBRK,KUNNR_BSEG,KUNAG_LIKP,ATWRT_AUSP,KUNNR_AWKEY2)											as KUNAG_BSEG,\
\
\
\
\
if((KVGR3_KEY = '070' or\
KVGR3_KEY = '080' or\
KVGR3_KEY = '090' or\
KVGR3_KEY = '100' or\
KVGR3_KEY = '120' or\
KVGR3_KEY = '130') and \
if(\
HKONT_BSEG =' 0031111115' or HKONT_BSEG = '0031111116' or\
HKONT_BSEG = '0021205003' or HKONT_BSEG = '0021205004' or\
HKONT_BSEG = '0021205005' or HKONT_BSEG = '0021205006' or\
HKONT_BSEG = '0031111102' or HKONT_BSEG = '0031111110' or\
HKONT_BSEG = '0031111120' or HKONT_BSEG = '0031111140' or\
HKONT_BSEG = '0031111141' or HKONT_BSEG = '0031111204' or\
HKONT_BSEG = '0031111212' or HKONT_BSEG = '0031111828'\
,'EN',\
\
if(IsNull(AUART),\
if(IsNull(CU_BELNR),\
if(IsNull(Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)) or \
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)='' or\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)=' ','NA',\
\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)),'EN'),'EN')	) = 'GR','Nautigas')									as SP_NAUTIGAS,\
\
\
if((VTWEG_ZUONR='DI' or VTWEG_ZUONR='RP') and \
\
(\
if(HKONT_BSEG ='0031111115' or HKONT_BSEG = '0031111116','CU',\
\
if(\
\
if(IsNull(AUART),\
if(IsNull(CU_BELNR),\
if(\
IsNull(Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)) or \
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)='' or\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)=' ','NA',\
\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)),CU_BELNR),'CU')='VL','RP',\
\
if(IsNull(AUART),\
if(IsNull(CU_BELNR),\
if(\
IsNull(Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)) or \
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)='' or\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)=' ','NA',\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)),CU_BELNR),'CU'))\
\
)	\
)\
\
 ='NA','Envasado',\
 \
if(\
if(IsNull(AUART),\
if(IsNull(CU_BELNR),\
if(\
IsNull(Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)) or \
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)='' or\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)=' ','NA',\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)),'EN'),'EN')	='EN' or \
\
if(IsNull(AUART),\
if(IsNull(CU_BELNR),\
if(IsNull(Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)) or \
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)='' or\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)=' ','NA',\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)),'EN'),'EN')= 'PM' or \
\
(HKONT_BSEG ='0031111115' or HKONT_BSEG = '0031111116' or\
HKONT_BSEG = '0021205003' or HKONT_BSEG = '0021205004' or\
HKONT_BSEG = '0021205005' or HKONT_BSEG = '0021205006' or\
HKONT_BSEG = '0031111102' or HKONT_BSEG = '0031111110' or\
HKONT_BSEG = '0031111120' or HKONT_BSEG = '0031111140' or\
HKONT_BSEG = '0031111141' or HKONT_BSEG = '0031111204' or\
HKONT_BSEG = '0031111212' or HKONT_BSEG = '0031111828'),'Envasado',\
\
if(\
\
if(IsNull(AUART),\
if(IsNull(CU_BELNR),\
if(\
\
IsNull(Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)) or \
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)='' or\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)=' ','NA',\
\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)),'EN'),'EN')	= 'GR' and (MATNR_BSEG <> 'GR CAT') or (HKONT_BSEG='0031111123' or HKONT_BSEG='0031111207'),'Granel',\
\
if(\
\
if(IsNull(AUART),\
if(IsNull(CU_BELNR),\
if(IsNull(Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)) or \
\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)='' or\
\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)=' ','NA',\
\
\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)),'EN'),'EN')	='GR' or \
\
\
if(IsNull(AUART),\
if(IsNull(CU_BELNR),\
if(IsNull(Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)) or \
\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)='' or\
\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)=' ','NA',\
\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)),'EN'),'EN')='LG' and MATNR_BSEG='GR CAT','Autogas',\
if(\
\
if(IsNull(AUART),\
if(IsNull(CU_BELNR),\
if(IsNull(Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)) or \
\
\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)='' or\
\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)=' ','NA',\
\
\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)),'EN'),'EN')='NA' or (HKONT_BSEG= '0031111203'),'Sin Linea'))))	)								as SECTOR_NEGOCIO,\
\
\
\
\
if(HKONT_BSEG = '0031111107','GR',\
\
if(\
HKONT_BSEG = '0031111115' or HKONT_BSEG = '0031111116' or\
HKONT_BSEG = '0021205003' or HKONT_BSEG = '0021205004' or\
HKONT_BSEG = '0021205005' or HKONT_BSEG = '0021205006' or\
HKONT_BSEG = '0031111102' or HKONT_BSEG = '0031111110' or\
HKONT_BSEG = '0031111120' or HKONT_BSEG = '0031111140' or\
HKONT_BSEG = '0031111141' or HKONT_BSEG = '0031111204' or\
HKONT_BSEG = '0031111212' or HKONT_BSEG = '0031111828'\
,'EN',\
\
if(IsNull(AUART),\
if(IsNull(CU_BELNR),\
if(IsNull(Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)) or \
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)='' or\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)=' ','NA',\
\
Coalesce(SPART_VBRK,SPART_LIPS,SPART_CMED)),'EN'),'EN')	))																					as SPART_BSEG,\
\
\
\
\
\
if(HKONT_BSEG ='0031111115' or HKONT_BSEG = '0031111116','CU',\
if(\
if(IsNull(AUART),\
if(IsNull(CU_BELNR),\
if(IsNull(\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)) or \
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)='' or\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)=' ','NA',\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)),CU_BELNR),'CU')='VL','RP',\
\
if(IsNull(AUART),\
if(IsNull(CU_BELNR),\
if(IsNull(Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)) or \
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)='' or\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)=' ','NA',\
\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)),CU_BELNR),'CU')))																				as VTWEG_BSEG,\
\
\
if(\
if(HKONT_BSEG ='0031111115' or HKONT_BSEG = '0031111116','CU',\
if(\
\
if(IsNull(AUART),\
if(IsNull(CU_BELNR),\
if(IsNull(Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)) or \
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)='' or\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)=' ','NA',\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)),CU_BELNR),'CU')='VL','RP',\
\
if(IsNull(AUART),\
if(IsNull(CU_BELNR),\
if(IsNull(\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)) or \
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)='' or\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)=' ','NA',\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)),CU_BELNR),'CU')))='RP',VTWEG_ORIG,\
\
if(HKONT_BSEG ='0031111115' or HKONT_BSEG = '0031111116','CU',\
if(\
\
if(IsNull(AUART),\
if(IsNull(CU_BELNR),\
if(IsNull(Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)) or \
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)='' or\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)=' ','NA',\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)),CU_BELNR),'CU')='VL','RP',\
\
\
\
if(IsNull(AUART),\
if(IsNull(CU_BELNR),\
if(IsNull(Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)) or \
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)='' or\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)=' ','NA',\
\
Coalesce(VTWEG_ORIG,VTWEG_LIPS,VTWEG_CMED)),CU_BELNR),'CU'))))																				as VTWEG_BSEG2\
\
\
\
Resident Contabilidad;\
DROP Table Contabilidad;\
\
LET vTiempo1 = Now();\
LET vA\'f1oCupon = Year(Today());\
LET vA\'f1oCupon_1 = Year(Today())-1;\
LET vA\'f1oCupon_2 = Year(Today())-2;\
LET vA\'f1oCupon_3 = Year(Today())-3;\
\
CUPONES_TEMPORALES:\
LOAD \
\
     DMBTR_$,  \
     HKONT_BSEG, \
     YBUDAT_BKPF, \
     MBUDAT_BKPF \
Resident Contabilidadxx Where (HKONT_BSEG = '0031111115' or HKONT_BSEG = '0031111110') and VTWEG_BSEG = 'CU';\
\
\
Total:\
LOAD\
YBUDAT_BKPF							as YBUDAT_INFOCUS_RE, \
MBUDAT_BKPF							as MBUDAT_INFOCUS_RE,\
HKONT_BSEG							as HKONT_INFOCUS_RE,\
fabs(sum(DMBTR_$))					as DMBTR_INFOCUS_RE\
Resident CUPONES_TEMPORALES Group By YBUDAT_BKPF, \
MBUDAT_BKPF,\
HKONT_BSEG;\
\
\
ZTCUPONES:\
LOAD \
     MATNR_KGCUPONES, \
     MATNR_ZTCUPONES, \
//      ApplyMap('REGIO_INFOCUS',KUNNR_ZTCUPONES)		as REGIO_FCCUPONES,\
     KUNNR_ZTCUPONES, \
     LIDAT_ZTCUPONES, \
     ENTRE_ZTCUPONES,\
     CSUMI_ZTCUPONES,\
     Year(LIDAT_ZTCUPONES)							as YEART_ZTCUPONES,\
     Month(LIDAT_ZTCUPONES)							as MONTT_ZTCUPONES,\
     TRANS_ZTCUPONES, \
     FACTU_ZTCUPONES, \
     CUPON_ZTCUPONES, \
     NGUIA_ZTCUPONES, \
     ZVALVTACUP_ZTCUPONES*100						as ZVALVTACUP_ZTCUPONES, \
     ZVALDESC_ZTCUPONES*100							as ZVALDESC_ZTCUPONES\
Resident ZTCUPONESQVD Where (STATU_ZTCUPONES = '3') and ((Year(LIDAT_ZTCUPONES)&num(Month(LIDAT_ZTCUPONES))) = '$(vFecha_Qvd2)');\
\
\
// Next;\
\
Left Join(ZTCUPONES)\
LOAD Distinct\
VBELN											as FACTU_ZTCUPONES,\
FKDAT											as FLAG_FACTU,\
KUNAG											as KUNAG_FACTU,\
num(MonthName(FKDAT))							as FKDAT_MONTH\
Resident VBRKZT Where num(FKDAT) >= '42705';\
\
\
\
Left Join(ZTCUPONES)\
LOAD\
VBELN											as NGUIA_ZTCUPONES,\
KUNAG											as KUNAG_ZTCUPONES\
// ApplyMap('REGIO_INFOCUS',KUNAG)						as REGIO_ZTCUPONES\
Resident VBRK;\
\
\
Left Join(ZTCUPONES)\
LOAD\
TKNUM_VTTP										AS TRANS_ZTCUPONES,\
EXTI1_VTTK										as KUNAG_TRCUPONES\
// ApplyMap('REGIO_INFOCUS',EXTI1_VTTK)					as REGIO_TRCUPONES\
Resident VTTK;\
\
\
Left Join(ZTCUPONES)\
LOAD\
VBELN_LIKP										AS ENTRE_ZTCUPONES,\
KUNAG_LIKP										as KUNAG_ETCUPONES\
// ApplyMap('REGIO_INFOCUS',KUNAG_LIKP)					as REGIO_ETCUPONES\
Resident LIKP;\
\
Left Join(ZTCUPONES)\
LOAD Distinct\
     WERKS_T001W								as CSUMI_ZTCUPONES,\
     KUNNR_T001W, \
     REGIO_T001W\
Resident T001WQ;\
\
\
TB_CUPONES:\
LOAD *,\
if(FKDAT_MONTH = '42705',1,0)					as MFLAG_ZTCUPONES,\
'0031111115'									as HKONT_ZTCUPONES\
Resident ZTCUPONES Where FKDAT_MONTH = '42705';\
\
Concatenate(TB_CUPONES)\
LOAD *,\
\
if(FKDAT_MONTH = '42705',1,0)					as MFLAG_ZTCUPONES,\
'0031111110'									as HKONT_ZTCUPONES\
Resident ZTCUPONES Where FKDAT_MONTH >= '42705';\
// DROP Table ZTCUPONES;\
\
Concatenate(Total)\
LOAD\
YEART_ZTCUPONES									as YBUDAT_INFOCUS_RE, \
MONTT_ZTCUPONES								    as MBUDAT_INFOCUS_RE,\
HKONT_ZTCUPONES								    as HKONT_INFOCUS_RE,\
(sum(ZVALVTACUP_ZTCUPONES))*-1					as  DMBTR_INFOCUS_RE\
Resident TB_CUPONES Group By YEART_ZTCUPONES, \
MONTT_ZTCUPONES,\
HKONT_ZTCUPONES;\
\
Concatenate(TB_CUPONES)\
LOAD\
0												as MFLAG_ZTCUPONES,\
YBUDAT_INFOCUS_RE								as YEART_ZTCUPONES, \
MBUDAT_INFOCUS_RE								as MONTT_ZTCUPONES,\
HKONT_INFOCUS_RE								as HKONT_ZTCUPONES,\
DMBTR_INFOCUS_RE								as ZVALVTACUP_ZTCUPONES,\
null()											as CUPON_ZTCUPONES,\
null()											as TRANS_ZTCUPONES,\
null()											as NGUIA_ZTCUPONES,\
null()											as FACTU_ZTCUPONES,\
null()											as KUNAG_ZTCUPONES,\
null()											as KUNAG_FACTU,\
null()											as ENTRE_ZTCUPONES,\
null()											as MATNR_ZTCUPONES,\
null()											as REGIO_ZTCUPONES\
Resident Total;\
DROP Table Total;\
\
\
CUPONES:\
LOAD\
MFLAG_ZTCUPONES,\
'DELTA_BSEG'																	as ORIGEN_DATA,\
'Ingreso por venta de gas'														as GRUPP_INFOCUS_CU,\
'Envasado'																		as SPART_ZTCUPONES,\
'Cupones'																		as VTWEG_ZTCUPONES,\
\
YEART_ZTCUPONES,\
MONTT_ZTCUPONES,\
\
HKONT_ZTCUPONES																    as HKONT_ZTCUPONES,\
KUNAG_FACTU,\
\
// if(IsNull(if(IsNull(\
// if(IsNull(\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)),REGIO_ETCUPONES,\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES))),REGIO_T001W,\
// if(IsNull(\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)),REGIO_ETCUPONES,\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)))),REGIO_FCCUPONES,\
\
// if(IsNull(\
// if(IsNull(\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)),REGIO_ETCUPONES,\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES))),REGIO_T001W,\
// if(IsNull(\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)),REGIO_ETCUPONES,\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES))))					as REGION_CUCUPONES,\
\
\
\
KUNAG_TRCUPONES,\
KUNAG_ZTCUPONES,\
KUNAG_ETCUPONES,\
KUNNR_T001W,\
\
\
// if(IsNull(if(IsNull\
// (if(IsNull\
// (if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)),KUNAG_ETCUPONES,\
// if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES))\
// ),KUNNR_T001W,\
// if(IsNull\
// (if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)),KUNAG_ETCUPONES,\
// if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)))),KUNNR_ZTCUPONES,\
// if(IsNull\
// (if(IsNull\
// (if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)),KUNAG_ETCUPONES,\
// if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES))\
// ),KUNNR_T001W,\
// if(IsNull\
// (if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)),KUNAG_ETCUPONES,\
// if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES))))					as KUNAG_CUCUPONES,\
\
\
// if(IsNull(if(IsNull\
// (if(IsNull\
// (Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)),KUNAG_ETCUPONES,\
// Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES))\
// ),KUNNR_T001W,\
// if(IsNull\
// (Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)),KUNAG_ETCUPONES,\
// Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)))),KUNNR_ZTCUPONES,\
// if(IsNull\
// (if(IsNull\
// (Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)),KUNAG_ETCUPONES,\
// Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES))\
// ),KUNNR_T001W,\
// if(\
// IsNull(Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES))\
// ,KUNAG_ETCUPONES,\
// Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES))))									as KUNAG_CUCUPONES2,\
\
\
Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES,KUNAG_ETCUPONES,KUNNR_T001W)			as KUNAG_CUCUPONES,\
\
CUPON_ZTCUPONES																	as CUPON_ZTCUPONES,\
TRANS_ZTCUPONES																	as TRANS_ZTCUPONES, \
FACTU_ZTCUPONES																	as FACTU_ZTCUPONES,\
ENTRE_ZTCUPONES																	as ENTRE_ZTCUPONES,\
MATNR_ZTCUPONES																	as MATNR_ZTCUPONES,\
//0																				as MATNR_KGCUPONES,\
if(HKONT_ZTCUPONES='0031111110',sum(ZVALVTACUP_ZTCUPONES),sum(ZVALVTACUP_ZTCUPONES)*-1)		as ZVALDESC_ZTCUPONES,\
if(HKONT_ZTCUPONES='0031111110',(sum(MATNR_KGCUPONES)),(sum(MATNR_KGCUPONES))*-1)	        as CANJE_FISICO_ZTCUPONES\
\
Resident TB_CUPONES Group By\
MFLAG_ZTCUPONES,\
'DELTA_BSEG',\
'Ingreso por venta de gas',\
'Envasado',\
'Cupones',\
\
YEART_ZTCUPONES,\
\
MONTT_ZTCUPONES,\
HKONT_ZTCUPONES,\
KUNAG_FACTU,\
// if(IsNull(if(IsNull(\
// if(IsNull(\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)),REGIO_ETCUPONES,\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES))),REGIO_T001W,\
// if(IsNull(\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)),REGIO_ETCUPONES,\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)))),REGIO_FCCUPONES,\
\
// if(IsNull(\
// if(IsNull(\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)),REGIO_ETCUPONES,\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES))),REGIO_T001W,\
// if(IsNull(\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)),REGIO_ETCUPONES,\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)))),\
\
KUNAG_TRCUPONES,\
KUNAG_ZTCUPONES,\
KUNAG_ETCUPONES,\
KUNNR_T001W,\
\
\
// if(IsNull(if(IsNull\
// (if(IsNull\
// (if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)),KUNAG_ETCUPONES,\
// if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES))\
// ),KUNNR_T001W,\
// if(IsNull\
// (if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)),KUNAG_ETCUPONES,\
// if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)))),KUNNR_ZTCUPONES,\
// if(IsNull\
// (if(IsNull\
// (if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)),KUNAG_ETCUPONES,\
// if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES))\
// ),KUNNR_T001W,\
// if(IsNull\
// (if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)),KUNAG_ETCUPONES,\
// if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES))))	,\
\
// if(IsNull(if(IsNull\
// (if(IsNull\
// (Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)),KUNAG_ETCUPONES,\
// Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES))\
// ),KUNNR_T001W,\
// if(IsNull\
// (Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)),KUNAG_ETCUPONES,\
// Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)))),KUNNR_ZTCUPONES,\
// if(IsNull\
// (if(IsNull\
// (Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)),KUNAG_ETCUPONES,\
// Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES))\
// ),KUNNR_T001W,\
// if(\
// IsNull(Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES))\
// ,KUNAG_ETCUPONES,\
// Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)))),\
\
Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES,KUNAG_ETCUPONES,KUNNR_T001W),\
CUPON_ZTCUPONES,\
TRANS_ZTCUPONES, \
FACTU_ZTCUPONES,\
ENTRE_ZTCUPONES,\
MATNR_ZTCUPONES;\
DROP Table TB_CUPONES;\
\
DROP Table CUPONES_TEMPORALES;\
\
// STORE CUPONES into lib://Raiz/QVD\\PROCESADOS\\INFOCUS\\OFIC\\NIVEL1\\0_ZSALDO_INGRESOS_CUPONES_$(vFecha_Qvd2).qvd;\
\
\
LET vTiempo1 = Now();\
\
CUPONES_TEMPORALES:\
LOAD \
\
     DMBTR_$,  \
     HKONT_BSEG, \
     YBUDAT_BKPF, \
     MBUDAT_BKPF \
Resident Contabilidadxx Where (HKONT_BSEG = '0031111116' or HKONT_BSEG = '0031111102') and VTWEG_BSEG = 'CU';\
\
\
Total:\
LOAD\
YBUDAT_BKPF							as YBUDAT_INFOCUS_RE, \
MBUDAT_BKPF							as MBUDAT_INFOCUS_RE,\
HKONT_BSEG							as HKONT_INFOCUS_RE,\
fabs(sum(DMBTR_$))					as DMBTR_INFOCUS_RE\
Resident CUPONES_TEMPORALES Group By YBUDAT_BKPF, \
MBUDAT_BKPF,\
HKONT_BSEG;\
\
TB_CUPONES:\
LOAD *,\
'Cuentas'										as Saldo,\
if(FKDAT_MONTH = '42705',1,0)					as MFLAG_ZTCUPONES,\
'0031111116'									as HKONT_ZTCUPONES\
Resident ZTCUPONES Where FKDAT_MONTH = '42705';\
\
Concatenate(TB_CUPONES)\
LOAD *,\
'Cuentas'										as Saldo,\
if(FKDAT_MONTH = '42705',1,0)					as MFLAG_ZTCUPONES,\
'0031111102'									as HKONT_ZTCUPONES\
Resident ZTCUPONES Where FKDAT_MONTH >= '42705';\
DROP Table ZTCUPONES;\
\
\
Concatenate(Total)\
LOAD\
\
YEART_ZTCUPONES									as YBUDAT_INFOCUS_RE, \
MONTT_ZTCUPONES								    as MBUDAT_INFOCUS_RE,\
HKONT_ZTCUPONES								    as HKONT_INFOCUS_RE,\
(sum(ZVALDESC_ZTCUPONES))*-1					as DMBTR_INFOCUS_RE\
Resident TB_CUPONES Group By YEART_ZTCUPONES, \
MONTT_ZTCUPONES,\
HKONT_ZTCUPONES;\
\
\
Concatenate(TB_CUPONES)\
LOAD\
0												as MFLAG_ZTCUPONES,\
YBUDAT_INFOCUS_RE								as YEART_ZTCUPONES, \
MBUDAT_INFOCUS_RE								as MONTT_ZTCUPONES,\
HKONT_INFOCUS_RE								as HKONT_ZTCUPONES,\
DMBTR_INFOCUS_RE								as ZVALDESC_ZTCUPONES,\
null()											as CUPON_ZTCUPONES,\
null()											as TRANS_ZTCUPONES,\
null()											as NGUIA_ZTCUPONES,\
null()											as FACTU_ZTCUPONES,\
null()											as KUNAG_ZTCUPONES,\
null()											as KUNAG_FACTU,\
null()											as ENTRE_ZTCUPONES,\
null()											as MATNR_ZTCUPONES,\
null()											as REGIO_ZTCUPONES\
Resident Total;\
DROP Table Total;\
\
\
\
Concatenate(CUPONES)\
LOAD\
MFLAG_ZTCUPONES,\
'DELTA_BSEG'																	as ORIGEN_DATA,\
'Descuentos por gas'															as GRUPP_INFOCUS_CU,\
'Envasado'																		as SPART_ZTCUPONES,\
'Cupones'																		as VTWEG_ZTCUPONES,\
\
 YEART_ZTCUPONES,\
\
 MONTT_ZTCUPONES,\
\
HKONT_ZTCUPONES																    as HKONT_ZTCUPONES,\
KUNAG_FACTU,\
//\
//if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)						as REGION_CUCUPONES,\
\
\
// if(IsNull(if(IsNull(\
// if(IsNull(\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)),REGIO_ETCUPONES,\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES))),REGIO_T001W,\
// if(IsNull(\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)),REGIO_ETCUPONES,\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)))),REGIO_FCCUPONES,\
\
// if(IsNull(\
// if(IsNull(\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)),REGIO_ETCUPONES,\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES))),REGIO_T001W,\
// if(IsNull(\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)),REGIO_ETCUPONES,\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES))))					as REGION_CUCUPONES,\
\
//if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)					as KUNAG_CUCUPONES,\
\
\
// if(IsNull(if(IsNull\
// (if(IsNull\
// (if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)),KUNAG_ETCUPONES,\
// if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES))\
// ),KUNNR_T001W,\
// if(IsNull\
// (if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)),KUNAG_ETCUPONES,\
// if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)))),KUNNR_ZTCUPONES,\
// if(IsNull\
// (if(IsNull\
// (if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)),KUNAG_ETCUPONES,\
// if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES))\
// ),KUNNR_T001W,\
// if(IsNull\
// (if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)),KUNAG_ETCUPONES,\
// if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES))))					as KUNAG_CUCUPONES,\
\
\
\
// if(IsNull(if(IsNull\
// (if(IsNull\
// (Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)),KUNAG_ETCUPONES,\
// Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES))\
// ),KUNNR_T001W,\
// if(IsNull\
// (Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)),KUNAG_ETCUPONES,\
// Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)))),KUNNR_ZTCUPONES,\
// if(IsNull\
// (if(IsNull\
// (Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)),KUNAG_ETCUPONES,\
// Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES))\
// ),KUNNR_T001W,\
// if(\
// IsNull(Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES))\
// ,KUNAG_ETCUPONES,\
// Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES))))									as KUNAG_CUCUPONES2,\
\
\
Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES,KUNAG_ETCUPONES,KUNNR_T001W)           as KUNAG_CUCUPONES,\
CUPON_ZTCUPONES																	as CUPON_ZTCUPONES,\
TRANS_ZTCUPONES																	as TRANS_ZTCUPONES, \
FACTU_ZTCUPONES																	as FACTU_ZTCUPONES,\
ENTRE_ZTCUPONES																	as ENTRE_ZTCUPONES,\
MATNR_ZTCUPONES																	as MATNR_ZTCUPONES,\
//0																				as MATNR_KGCUPONES,\
if(HKONT_ZTCUPONES='0031111102',sum(ZVALDESC_ZTCUPONES),sum(ZVALDESC_ZTCUPONES)*-1)		as ZVALDESC_ZTCUPONES\
\
Resident TB_CUPONES Group By\
MFLAG_ZTCUPONES,\
'DELTA_BSEG',\
'Descuentos por gas',\
'Envasado',\
'Cupones',\
\
YEART_ZTCUPONES,\
\
MONTT_ZTCUPONES,\
\
HKONT_ZTCUPONES,\
KUNAG_FACTU,\
// if(IsNull(if(IsNull(\
// if(IsNull(\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)),REGIO_ETCUPONES,\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES))),REGIO_T001W,\
// if(IsNull(\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)),REGIO_ETCUPONES,\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)))),REGIO_FCCUPONES,\
\
// if(IsNull(\
// if(IsNull(\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)),REGIO_ETCUPONES,\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES))),REGIO_T001W,\
// if(IsNull(\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)),REGIO_ETCUPONES,\
// if(IsNull(REGIO_ZTCUPONES),REGIO_TRCUPONES,REGIO_ZTCUPONES)))),\
\
//if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)					as KUNAG_CUCUPONES,\
\
\
\
// if(IsNull(if(IsNull\
// (if(IsNull\
// (if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)),KUNAG_ETCUPONES,\
// if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES))\
// ),KUNNR_T001W,\
// if(IsNull\
// (if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)),KUNAG_ETCUPONES,\
// if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)))),KUNNR_ZTCUPONES,\
// if(IsNull\
// (if(IsNull\
// (if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)),KUNAG_ETCUPONES,\
// if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES))\
// ),KUNNR_T001W,\
// if(IsNull\
// (if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES)),KUNAG_ETCUPONES,\
// if(IsNull(KUNAG_ZTCUPONES),KUNAG_TRCUPONES,KUNAG_ZTCUPONES))))	,\
\
// if(IsNull(if(IsNull\
// (if(IsNull\
// (Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)),KUNAG_ETCUPONES,\
// Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES))\
// ),KUNNR_T001W,\
// if(IsNull\
// (Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)),KUNAG_ETCUPONES,\
// Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)))),KUNNR_ZTCUPONES,\
// if(IsNull\
// (if(IsNull\
// (Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)),KUNAG_ETCUPONES,\
// Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES))\
// ),KUNNR_T001W,\
// if(\
// IsNull(Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES))\
// ,KUNAG_ETCUPONES,\
// Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES)))),\
\
Coalesce(KUNAG_ZTCUPONES,KUNAG_TRCUPONES,KUNAG_ETCUPONES,KUNNR_T001W),\
CUPON_ZTCUPONES,\
TRANS_ZTCUPONES, \
FACTU_ZTCUPONES,\
ENTRE_ZTCUPONES,\
MATNR_ZTCUPONES;\
DROP Table TB_CUPONES;\
\
\
\
DROP Table CUPONES_TEMPORALES;\
\
\
\
Left Join(CUPONES)\
LOAD \
     KUNNR_KNA1																as KUNAG_CUCUPONES, \
     REGIO_KNA1																as REGION_CUCUPONES\
Resident KNA1;\
\
MAKTMp:\
Mapping\
//left join(CUPON_INFOCUS)\
LOAD Distinct\
     MATNR_MAKT																			as MATNR_INFOCUS_CU, \
\
     If(IsNum(num(MATNR_MAKT)),num(MATNR_MAKT),MATNR_MAKT)&' - '&MAKTX_CLEAR			as MAKTX_INFOCUS_CU\
  \
Resident MAKT;\
\
\
RAMO_XLS:\
Mapping\
LOAD Ramo, \
     Clasificaci\'f3n\
Resident Ramo958;\
\
\
\
CUPON_INFOCUS:\
LOAD \
     'Cupones'														as ORIGEN_INFOCUS_CU,\
	 'Y'															as YCU_BKPF_INFOCUS_CU,\
	 'Y'															as VISUALIZACION_INFOCUS_CU,\
	 'Y'															as MPFIL_INFOCUS_CU,\
     GRUPP_INFOCUS_CU,\
     HKONT_ZTCUPONES												as HKONT_INFOCUS_CU,\
	 'Envasado'														as SECTOR_INFOCUS_CU,\
     'EN'															as SPART_INFOCUS_CU,\
     'CU'															as VTWEG_INFOCUS_CU,\
     'CU'															as VTWE2_INFOCUS_CU,\
     MATNR_ZTCUPONES												as MATNR_INFOCUS_CU,\
     'NO'															as NAUTI_INFOCUS_CU,    \
     \
\
     num(MakeDate(YEART_ZTCUPONES,MONTT_ZTCUPONES,1))				as NBUDAT_INFOCUS_CU,\
     YEART_ZTCUPONES												as YBUDAT_INFOCUS_CU,\
     MONTT_ZTCUPONES												as MBUDAT_INFOCUS_CU,\
     Capitalize(MonthName(MONTT_ZTCUPONES))							as MNBUDAT_INFOCUS_CU,\
     num(Capitalize(MonthName(num(MakeDate(YEART_ZTCUPONES,MONTT_ZTCUPONES,1)))))		as MNNBUDAT_INFOCUS_CU,\
     \
     \
     if(IsNull(KUNAG_FACTU),'Sin Asignar',KUNAG_FACTU)				as KUNNR_INFOCUS_CU,\
     KUNAG_CUCUPONES												as KUNNR_INFOCUS_OR,\
     num(KUNAG_CUCUPONES)										as KUNNR_INFOCUS_NM,\
     CUPON_ZTCUPONES&'|'&num(MakeDate(YEART_ZTCUPONES,MONTT_ZTCUPONES,1))												as BELNR_INFOCUS_CU,\
     null()															as SGTXT_INFOCUS_CU,\
     CUPON_ZTCUPONES												as DOCUM_INFOCUS_CU,\
     null()															as XBLNR_INFOCUS_CU,\
     'ZTCUPONES'													as AWTYP_INFOCUS_CU,\
     null()															as INFOCUS_CU_VTWEG_ZUONR,\
// null()														        as INFOCUS_CU_AWKEY_ZUONR,\
\
if(HKONT_ZTCUPONES='0031111102',sum(ZVALDESC_ZTCUPONES)*-1,\
     \
   if(num(MakeDate(YEART_ZTCUPONES,MONTT_ZTCUPONES,1)) ='44713' and HKONT_ZTCUPONES='0031111116',\
     sum(ZVALDESC_ZTCUPONES)*-1, sum(ZVALDESC_ZTCUPONES)))										as DMBTR_INFOCUS_CU\
    \
Resident CUPONES Group By\
'Cupones',\
'Y',\
'Y',\
'Y',\
     GRUPP_INFOCUS_CU,\
     HKONT_ZTCUPONES,\
	 'Envasado',\
     'EN',\
     'CU',\
     'CU',\
     MATNR_ZTCUPONES,\
     'NO',    \
     num(MakeDate(YEART_ZTCUPONES,MONTT_ZTCUPONES,1)),\
     YEART_ZTCUPONES,\
     MONTT_ZTCUPONES,\
     Capitalize(MonthName(MONTT_ZTCUPONES)),\
     num(Capitalize(MonthName(num(MakeDate(YEART_ZTCUPONES,MONTT_ZTCUPONES,1))))),\
     KUNAG_CUCUPONES,\
     if(IsNull(KUNAG_FACTU),'Sin Asignar',KUNAG_FACTU),\
     null(),\
     CUPON_ZTCUPONES,\
     CUPON_ZTCUPONES,\
     null(),\
//      null(),\
//      null(),\
          null(),\
      'ZTCUPONES',\
     null();\
     \
FICA:\
LOAD\
    123456,\
    NUMBER_DOCUMENT_ERDK,\
    AWKEY_FICA,\
    Regi\'f3n_Cenopers,\
    "Codigo Cliente",\
    "Comunas Suministro",\
    BUDAT_DFKKKO,\
    CMED,\
    UEBUD_DFKKSUM,\
    NBUDAT_CMED,\
    YEAR_DFKKSUM,\
    MONTH_DFKKSUM,\
    M3,\
    KG_M3\
Resident FICA0 Where YEAR_DFKKSUM&num(MONTH_DFKKSUM)= '$(vFecha_Qvd2)'	;\
\
\
\
\
Concatenate(CUPON_INFOCUS)\
LOAD \
'Medidores'														as ORIGEN_INFOCUS_CU,\
'Y'																as YCU_BKPF_INFOCUS_CU,\
'Y'															    as VISUALIZACION_INFOCUS_CU,\
'Y'																as MPFIL_INFOCUS_CU,\
'Ingreso por venta de gas'										as GRUPP_INFOCUS_CU,\
'0031111101'													as HKONT_INFOCUS_CU,\
'Granel'														as SECTOR_INFOCUS_CU,\
'GR'															as SPART_INFOCUS_CU,\
'ME'															as VTWEG_INFOCUS_CU,\
'ME'															as VTWE2_INFOCUS_CU,\
'GR NOR'														as MATNR_INFOCUS_CU,\
'NO'															as NAUTI_INFOCUS_CU,\
NBUDAT_CMED														as NBUDAT_INFOCUS_CU,\
YEAR_DFKKSUM													as YBUDAT_INFOCUS_CU,\
MONTH_DFKKSUM													as MBUDAT_INFOCUS_CU,\
Capitalize(MonthName(NBUDAT_CMED))								as MNBUDAT_INFOCUS_CU,\
num(Capitalize(MonthName(NBUDAT_CMED)))							as MNNBUDAT_INFOCUS_CU,\
[Codigo Cliente]												as KUNNR_INFOCUS_CU,\
[Codigo Cliente]												as KUNNR_INFOCUS_OR,\
num([Codigo Cliente])															as KUNNR_INFOCUS_NM,\
Regi\'f3n_Cenopers,	\
[Comunas Suministro],\
NUMBER_DOCUMENT_ERDK											as BELNR_INFOCUS_CU,\
null()															as SGTXT_INFOCUS_CU,\
NUMBER_DOCUMENT_ERDK											as DOCUM_INFOCUS_CU,\
null()															as XBLNR_INFOCUS_CU,\
'FICA'  													as AWTYP_INFOCUS_CU,\
null()														as INFOCUS_CU_VTWEG_ZUONR,\
// null()														as INFOCUS_CU_AWKEY_ZUONR,\
sum(CMED)*-1													as DMBTR_INFOCUS_CU\
Resident FICA \
Group By 'Medidores',\
'Y',\
'Y',\
'Y',\
'Ingreso por venta de gas',\
'0031111101',\
'GR',\
'ME',\
'GR NOR',\
'NO',\
NBUDAT_CMED,\
YEAR_DFKKSUM,\
MONTH_DFKKSUM,\
Capitalize(MonthName(NBUDAT_CMED)),\
num(Capitalize(MonthName(NBUDAT_CMED))),\
[Codigo Cliente],\
Regi\'f3n_Cenopers,\
[Comunas Suministro]\
,NUMBER_DOCUMENT_ERDK,\
Null(),\
// null(),\
// Null(),\
'FICA',\
null(),\
null();\
\
Drop Table FICA;\
\
// Left Join(Contabilidadxx)\
VBFA_temp:\
Left Keep(Contabilidadxx)\
Load\
DocMAt,\
KUNAG,\
VTWEG\
Resident VBFA_PURO_2023;\
\
VBFA_VTWEG:\
Mapping\
Load Distinct\
DocMAt								as AWKEY_MATNR,\
VTWEG								as VBFA_VTWEG\
Resident VBFA_temp Where not IsNull(KUNAG);\
\
\
VBFA_KUNAG:\
Mapping\
Load Distinct\
DocMAt								as AWKEY_MATNR,\
KUNAG								as VBFA_KUNAG\
Resident VBFA_temp Where not IsNull(KUNAG);\
Drop Table VBFA_temp;\
\
Concatenate(CUPON_INFOCUS)\
// TR1:\
LOAD \
'Contabilidad Sin Cu'											as ORIGEN_INFOCUS_CU,\
YCU_BKPF														as YCU_BKPF_INFOCUS_CU,\
MPFIL															as MPFIL_INFOCUS_CU,\
if(\
(HKONT_BSEG='0031111110' or HKONT_BSEG='0031111115' or\
HKONT_BSEG='0031111102' or HKONT_BSEG='0031111116' or HKONT_BSEG='0021205003' or HKONT_BSEG='0021205004') and VTWEG_BSEG='CU','N','Y')    as VISUALIZACION_INFOCUS_CU,\
\
// if(if(\
// (HKONT_BSEG='0031111110' or HKONT_BSEG='0031111115' or\
// HKONT_BSEG='0031111102' or HKONT_BSEG='0031111116' or HKONT_BSEG='0021205003' or HKONT_BSEG='0021205004') and VTWEG_BSEG='CU','N','Y')='N' and \
// (HKONT_BSEG='0031111110' or HKONT_BSEG='0031111115' or\
// HKONT_BSEG='0031111102' or HKONT_BSEG='0031111116') and \
// if(HKONT_BSEG='0031111140' \
// or HKONT_BSEG='0031111141' \
// or HKONT_BSEG='0031111120' ,'DI',VTWEG_BSEG)='CU','N','Y')																					as RESTRICCION_CUPONES,\
\
\
SGTXT_BSEG														as SGTXT_INFOCUS_CU,\
\
GRUPP_BSEG														as GRUPP_INFOCUS_CU,\
HKONT_BSEG 													    as HKONT_INFOCUS_CU,\
if(HKONT_BSEG= '0031111107',\
'Autogas',SECTOR_NEGOCIO) 										as SECTOR_INFOCUS_CU,\
\
SPART_BSEG														as SPART_INFOCUS_CU,\
\
ApplyMap('VBFA_VTWEG',AWKEY_MATNR,\
\
if(HKONT_BSEG='0031111140' \
or HKONT_BSEG='0031111141' \
or HKONT_BSEG='0031111120' ,'DI',if(VTWEG_BSEG='NA',VTWEG_ZUONR,VTWEG_BSEG)))					as VTWEG_INFOCUS_CU,\
\
ApplyMap('VBFA_VTWEG',AWKEY_MATNR,\
if(HKONT_BSEG='0031111140' \
or HKONT_BSEG='0031111141' \
or HKONT_BSEG='0031111120' ,'DI',VTWEG_BSEG2))					as VTWE2_INFOCUS_CU,\
\
\
MATNR_BSEG														as MATNR_INFOCUS_CU,\
SP_NAUTIGAS														as NAUTI_INFOCUS_CU,\
NBUDAT_BKPF														as NBUDAT_INFOCUS_CU,\
Year(NBUDAT_BKPF)												as YBUDAT_INFOCUS_CU,\
Month(NBUDAT_BKPF)												as MBUDAT_INFOCUS_CU,\
Capitalize(MonthName(NBUDAT_BKPF))								as MNBUDAT_INFOCUS_CU,\
num(Capitalize(MonthName(NBUDAT_BKPF)))							as MNNBUDAT_INFOCUS_CU,\
\
// Coalesce(VBFA_KUNAG,KUNAG_BSEG)\
\
ApplyMap('VBFA_KUNAG',AWKEY_MATNR,KUNAG_BSEG)\
																as KUNNR_INFOCUS_CU,\
num(ApplyMap('VBFA_KUNAG',AWKEY_MATNR,KUNAG_BSEG))\
																as KUNNR_INFOCUS_NM,\
ApplyMap('VBFA_KUNAG',AWKEY_MATNR,KUNAG_BSEG)						\
// Coalesce(VBFA_KUNAG,KUNAG_BSEG)									\
                                                                as KUNNR_INFOCUS_OR,\
\
AWKEY_MATNR 													as BELNR_INFOCUS_CU,\
BELNR_BKPF														as BELNR_BKPF,\
XBLNR_BKPF														as XBLNR_INFOCUS_CU,\
AWTYP_BKPF														as AWTYP_INFOCUS_CU,\
VTWEG_ZUONR														as INFOCUS_CU_VTWEG_ZUONR,\
// AWKEY_ZUONR														as INFOCUS_CU_AWKEY_ZUONR,\
if(HKONT_BSEG='0031111115' \
or HKONT_BSEG='0031111116',0,DMBTR_$)	*-1							as DMBTR_INFOCUS_CU\
Resident Contabilidadxx Where (HKONT_BSEG <> '0031111101') and \
if(\
if(\
(\
HKONT_BSEG='0031111110' or HKONT_BSEG='0031111115' or\
HKONT_BSEG='0031111102' or HKONT_BSEG='0031111116' or \
HKONT_BSEG='0021205003' or HKONT_BSEG='0021205004') \
\
and VTWEG_BSEG='CU','N','Y')='N' and \
\
(HKONT_BSEG='0031111110' or HKONT_BSEG='0031111115' or\
HKONT_BSEG='0031111102' or HKONT_BSEG='0031111116') and \
if(HKONT_BSEG='0031111140' \
or HKONT_BSEG='0031111141' \
or HKONT_BSEG='0031111120' ,'DI',VTWEG_BSEG)='CU','N','Y')='Y';\
\
\
Concatenate(CUPON_INFOCUS)\
// Concatenate(TR1)\
LOAD \
'ContabilidadII'												as ORIGEN_INFOCUS_CU,\
YCU_BKPF														as YCU_BKPF_INFOCUS_CU,\
MPFIL															as MPFIL_INFOCUS_CU,\
'Y'    															as VISUALIZACION_INFOCUS_CU,\
GRUPP_BSEG														as GRUPP_INFOCUS_CU,\
HKONT_BSEG 													    as HKONT_INFOCUS_CU,\
'Granel'														as SECTOR_INFOCUS_CU,\
SPART_BSEG														as SPART_INFOCUS_CU,\
ApplyMap('VBFA_VTWEG',AWKEY_BKPF,\
// if(IsNull(VBFA_VTWEG),\
if(VTWEG_BSEG='NA',VTWEG_ZUONR,VTWEG_BSEG))//,VBFA_VTWEG)			\
\
as VTWEG_INFOCUS_CU,\
// if(IsNull(VBFA_VTWEG),VTWEG_BSEG2,VBFA_VTWEG)\
ApplyMap('VBFA_VTWEG',AWKEY_BKPF,VTWEG_BSEG2)					\
as VTWE2_INFOCUS_CU,\
\
MATNR_BSEG														as MATNR_INFOCUS_CU,\
SP_NAUTIGAS														as NAUTI_INFOCUS_CU,\
NBUDAT_BKPF														as NBUDAT_INFOCUS_CU,\
Year(NBUDAT_BKPF)												as YBUDAT_INFOCUS_CU,\
Month(NBUDAT_BKPF)												as MBUDAT_INFOCUS_CU,\
Capitalize(MonthName(NBUDAT_BKPF))								as MNBUDAT_INFOCUS_CU,\
num(Capitalize(MonthName(NBUDAT_BKPF)))							as MNNBUDAT_INFOCUS_CU,\
ApplyMap('VBFA_KUNAG',AWKEY_BKPF,KUNAG_BSEG)					as KUNNR_INFOCUS_CU,\
num(ApplyMap('VBFA_KUNAG',AWKEY_BKPF,KUNAG_BSEG))				as KUNNR_INFOCUS_NM,\
ApplyMap('VBFA_KUNAG',AWKEY_BKPF,KUNAG_BSEG)\
// Coalesce(VBFA_KUNAG,KUNAG_BSEG)									\
																as KUNNR_INFOCUS_OR,\
\
AWKEY_MATNR	    as BELNR_INFOCUS_CU,\
\
BELNR_BKPF,\
SGTXT_BSEG														as SGTXT_INFOCUS_CU,\
XBLNR_BKPF														as XBLNR_INFOCUS_CU,\
VTWEG_ZUONR														as INFOCUS_CU_VTWEG_ZUONR,\
// AWKEY_ZUONR														as INFOCUS_CU_AWKEY_ZUONR,\
null()															as AWTYP_INFOCUS_CU,\
DMBTR_$	*-1															as DMBTR_INFOCUS_CU\
\
Resident Contabilidadxx Where HKONT_BSEG = '0031111101' and AWTYP_BKPF = 'BKPF';\
\
\
DBT:\
left Keep(CUPON_INFOCUS)\
// REGIO_TMP1:\
// Mapping\
LOAD Distinct\
     KUNNR_KNA1													as KUNNR_INFOCUS_CU,\
     REGIO_KNA1													as REGIO_INFOCUS_CU,\
     BRSCH_KNA1,\
     num(REGIO_KNA1)&'|'&num(COUNC_KNA1)						as COUNC_REGIO_INFOCUS_CU\
Resident KNA1;\
\
BRSCH_KNA1:\
Mapping\
Load Distinct\
KUNNR_INFOCUS_CU,\
BRSCH_KNA1\
Resident DBT;\
\
REGIO_INFOCUS_MP:\
Mapping\
Load Distinct\
KUNNR_INFOCUS_CU,\
REGIO_INFOCUS_CU\
Resident DBT;\
\
COUNC_REGIO_INFOCUS_MP:\
Mapping\
Load Distinct\
KUNNR_INFOCUS_CU,\
COUNC_REGIO_INFOCUS_CU\
Resident DBT;\
\
\
Drop Table DBT;\
\
\
COUNC_INFOCUS_CU:\
Mapping\
LOAD \
     num(Evaluate(REGIO))&'|'&num(Evaluate(COUNC))				as COUNC_REGIO_INFOCUS_CU, \
     Capitalize(BEZEI)											as COUNC_INFOCUS_CU\
Resident T005F Where SPRAS = 'S' and LAND1 = 'CL';\
\
// Concatenate(CUPON_INFOCUS)\
// LOAD\
// ORIGEN_INFOCUS_CU,\
// YCU_BKPF_INFOCUS_CU,\
// MPFIL_INFOCUS_CU,\
// VISUALIZACION_INFOCUS_CU,\
// GRUPP_INFOCUS_CU,\
// HKONT_INFOCUS_CU,\
// SECTOR_INFOCUS_CU,\
// SPART_INFOCUS_CU,\
// VTWEG_INFOCUS_CU,\
// VTWE2_INFOCUS_CU,\
// MATNR_INFOCUS_CU,\
// NAUTI_INFOCUS_CU,\
// NBUDAT_INFOCUS_CU,\
// YBUDAT_INFOCUS_CU,\
// MBUDAT_INFOCUS_CU,\
// MNBUDAT_INFOCUS_CU,\
// MNNBUDAT_INFOCUS_CU,\
// KUNNR_INFOCUS_CU,\
// KUNNR_INFOCUS_OR,\
// // KUNAG_LIKP,\
// BELNR_INFOCUS_CU,\
// // PAOBJNR_BSEG,\
// BELNR_BKPF,\
// SGTXT_INFOCUS_CU,\
// XBLNR_INFOCUS_CU,\
// AWTYP_INFOCUS_CU,\
// INFOCUS_CU_VTWEG_ZUONR,\
// // INFOCUS_CU_AWKEY_ZUONR,\
// sum(DMBTR_$)*-1													as DMBTR_INFOCUS_CU\
// Resident TR1 Group By ORIGEN_INFOCUS_CU,\
// YCU_BKPF_INFOCUS_CU,\
// MPFIL_INFOCUS_CU,\
// VISUALIZACION_INFOCUS_CU,\
// GRUPP_INFOCUS_CU,\
// HKONT_INFOCUS_CU,\
// SECTOR_INFOCUS_CU,\
// SPART_INFOCUS_CU,\
// VTWEG_INFOCUS_CU,\
// VTWE2_INFOCUS_CU,\
// MATNR_INFOCUS_CU,\
// NAUTI_INFOCUS_CU,\
// NBUDAT_INFOCUS_CU,\
// YBUDAT_INFOCUS_CU,\
// MBUDAT_INFOCUS_CU,\
// MNBUDAT_INFOCUS_CU,\
// MNNBUDAT_INFOCUS_CU,\
// KUNNR_INFOCUS_CU,\
// KUNNR_INFOCUS_OR,\
// // KUNAG_LIKP,\
// BELNR_INFOCUS_CU,\
// // PAOBJNR_BSEG,\
// BELNR_BKPF,\
// SGTXT_INFOCUS_CU,\
// XBLNR_INFOCUS_CU,\
// AWTYP_INFOCUS_CU,\
// INFOCUS_CU_VTWEG_ZUONR;\
// // INFOCUS_CU_AWKEY_ZUONR;\
// DROP Table TR1;\
\
\
\
\
\
// left join(CUPON_INFOCUS)\
// // ZONA_REGION:\
// // Mapping\
//  LOAD * INLINE [\
//     REGIO_INFOCUS_CU, ZONA_INFOCUS_CUOR\
//     01, Zona Norte\
//     02, Zona Norte\
//     03, Zona Centro Norte\
//     04, Zona Centro Norte\
//     05, Zona Centro Norte\
//     06, Zona Centro \
//     07, Zona Sur\
//     08, Zona Sur \
//     09, Zona Sur\
//     10, Zona Sur\
//     11, Zona Sur \
//     12, Zona Sur \
//     13, Zona Centro\
//     14, Zona Sur\
//     15, Zona Norte \
//     16, Zona Sur\
    \
// ];\
\
// left join(CUPON_INFOCUS)\
// // ZONA_REGION:\
// // Mapping\
//  LOAD * INLINE [\
//     Regi\'f3n_Cenopers, Zona_Cenopers\
//     01, Zona Norte\
//     02, Zona Norte\
//     03, Zona Centro Norte\
//     04, Zona Centro Norte\
//     05, Zona Centro Norte\
//     06, Zona Centro \
//     07, Zona Sur\
//     08, Zona Sur \
//     09, Zona Sur\
//     10, Zona Sur\
//     11, Zona Sur \
//     12, Zona Sur \
//     13, Zona Centro\
//     14, Zona Sur\
//     15, Zona Norte \
//     16, Zona Sur\
    \
// ];\
\
\
\
\
REGION_TEXTO:\
Mapping\
LOAD Distinct\
Evaluate(BLAND_T005U)														as Regi\'f3n_Cenopers,\
BEZEI_T005U																as RTEXTRegi\'f3n_Cenopers  \
Resident T005U Where LAND1_T005U = 'CL' and SPRAS_T005U = 'S';\
\
\
VTEXT_INFOCUS_CU:\
Mapping\
LOAD Distinct\
     VTWEG_TVTWT													as VTWEG_INFOCUS_CU, \
     VTWEG_TVTWT&' - '&VTEXT_TVTWT							   		as VTEXT_INFOCUS_CU\
Resident TVTWT;\
\
\
\
TMP1:\
LOAD *,\
\
ApplyMap('VTEXT_INFOCUS_CU',VTWEG_INFOCUS_CU,null())				as VTEXT_INFOCUS_CU, \
ApplyMap('VTEXT_INFOCUS_CU',VTWE2_INFOCUS_CU,null())				   as VTEX2_INFOCUS_CU, \
\
\
\
ApplyMap('REGION_TEXTO',Regi\'f3n_Cenopers,null())				   as RTEXTRegi\'f3n_Cenopers, \
\
ApplyMap('REGIO_INFOCUS_MP',KUNNR_INFOCUS_CU,null())				as REGIO_INFOCUS_CU,     \
ApplyMap('COUNC_REGIO_INFOCUS_MP',KUNNR_INFOCUS_CU,null())				as COUNC_REGIO_INFOCUS_CU,     \
\
\
     \
      \
//      if(HKONT_INFOCUS_CU='0031111101',Zona_Cenopers,\
//      ZONA_INFOCUS_CUOR)												as ZONA_INFOCUS_CU, \
        \
     \
          if(IsNull(ApplyMap('TIPO_CLIENTE',KUNNR_INFOCUS_NM,null())),\
    \
      ApplyMap('RAMO_XLS',ApplyMap('BRSCH_KNA1',KUNNR_INFOCUS_CU) ),\
     \
     \
     ApplyMap('TIPO_CLIENTE',KUNNR_INFOCUS_NM,null()))		as [Tipo Cliente]\
\
     \
\
\
Resident CUPON_INFOCUS;\
DROP Table CUPON_INFOCUS;\
\
\
left join(TMP1)\
//Left Join(CUPON_INFOCUS)\
LOAD * INLINE [\
    REGIO_INFOCUS_CU, ROMAN_INFOCUS_O_R\
    01, I\
    02, II\
    03, III\
    04, IV\
    05, V\
    06, VI\
    07, VII\
    08, VIII\
    09, IX\
    10, X\
    11, XI\
    12, XII\
    13, XIII\
    14, XIV\
    15, XV\
    16, XVI\
];\
\
\
TB_INFOCUS:\
LOAD *,\
ApplyMap('REGION_TEXTO',REGIO_INFOCUS_CU,null())				as RTEXT_INFOCUS_CUor, \
  if(HKONT_INFOCUS_CU='0031111101',RTEXTRegi\'f3n_Cenopers,\
     ApplyMap('REGION_TEXTO',REGIO_INFOCUS_CU,null()))											as RTEXT_INFOCUS_CU, \
     \
ApplyMap('COUNC_INFOCUS_CU',COUNC_REGIO_INFOCUS_CU,null())				as COUNC_INFOCUS_CU,    \
ApplyMap('MAKTMp',MATNR_INFOCUS_CU,null())					as MAKTX_INFOCUS_CU,\
\
if(MATNR_INFOCUS_CU='GAS05C','5KG C',\
if(MATNR_INFOCUS_CU='GAS05N','5KG',\
if(MATNR_INFOCUS_CU='GAS11C','11KG C',\
if(MATNR_INFOCUS_CU='GAS11N','11KG',\
if(MATNR_INFOCUS_CU='GAS15C','15KG C',\
if(MATNR_INFOCUS_CU='GAS15N','15KG',\
if(MATNR_INFOCUS_CU='GAS15VM','CIL. Vehicular',\
if(MATNR_INFOCUS_CU='GAS15VMA','CIL. Vehicular',\
if(MATNR_INFOCUS_CU='GAS45C','45KG C',\
if(MATNR_INFOCUS_CU='GAS45N','45KG',\
if(MATNR_INFOCUS_CU='GR BUT','Granel',\
if(MATNR_INFOCUS_CU='GR CAT','Granel Veh.',\
if(MATNR_INFOCUS_CU='GR ENE','Granel',\
if(MATNR_INFOCUS_CU='GR NOR','Granel'))))))))))))))																	as CARGA_INFOCUS_CU,\
//\
//\
//\
//\
\
num(MonthName(NBUDAT_INFOCUS_CU))&'|'&if(SECTOR_INFOCUS_CU='Envasado','Envasado','Granel')&'|'&ROMAN_INFOCUS_O_R\
&'|'&if(MATNR_INFOCUS_CU='GAS05C','5KG C',\
if(MATNR_INFOCUS_CU='GAS05N','5KG',\
if(MATNR_INFOCUS_CU='GAS11C','11KG C',\
if(MATNR_INFOCUS_CU='GAS11N','11KG',\
if(MATNR_INFOCUS_CU='GAS15C','15KG C',\
if(MATNR_INFOCUS_CU='GAS15N','15KG',\
if(MATNR_INFOCUS_CU='GAS15VM','CIL. Vehicular',\
if(MATNR_INFOCUS_CU='GAS15VMA','CIL. Vehicular',\
if(MATNR_INFOCUS_CU='GAS45C','45KG C',\
if(MATNR_INFOCUS_CU='GAS45N','45KG',\
if(MATNR_INFOCUS_CU='GR BUT','Granel',\
if(MATNR_INFOCUS_CU='GR CAT','Granel Veh.',\
if(MATNR_INFOCUS_CU='GR ENE','Granel',\
if(MATNR_INFOCUS_CU='GR NOR','Granel'))))))))))))))					as KEY_PM_GBL,\
if(SECTOR_INFOCUS_CU='Envasado','Envasado','Granel')				as SECTOR_GLOBAL_CU,\
\
\
\
\
if(VTWEG_INFOCUS_CU='ME','Medidores',\
\
if(SECTOR_INFOCUS_CU='Granel',[Tipo Cliente],\
if(NAUTI_INFOCUS_CU='Autogas','Autogas',\
if(VTWEG_INFOCUS_CU='ME','Medidores',\
if(VTWEG_INFOCUS_CU='DI','Distribuidores',\
if(VTWEG_INFOCUS_CU = 'CU','Cupones',\
if(SECTOR_INFOCUS_CU='Autogas','Autogas',\
if(SPART_INFOCUS_CU = 'EN' and VTWEG_INFOCUS_CU='RP', 'Reparto Publico Envasado',\
if(VTWEG_INFOCUS_CU='RP' and SPART_INFOCUS_CU = 'GR', 'Reparto Publico Granel')))))))))								as INFOCUS_NEGOCIO_TC,\
\
\
\
YBUDAT_INFOCUS_CU&'|'&num(MBUDAT_INFOCUS_CU)&'|'&num(REGIO_INFOCUS_CU)&'|'&\
\
if(IsNull\
(if(SECTOR_INFOCUS_CU='Autogas','Autogas',\
if(SECTOR_INFOCUS_CU='Envasado',\
\
if(NAUTI_INFOCUS_CU='Autogas','Autogas',\
if(VTWEG_INFOCUS_CU='ME','Medidores',\
if(VTWEG_INFOCUS_CU='DI','Distribuidores',\
if(VTWEG_INFOCUS_CU = 'CU','Cupones',\
if(SECTOR_INFOCUS_CU='Autogas','Autogas',\
if(SPART_INFOCUS_CU = 'EN', 'Reparto Publico Envasado')))))))))	,\
\
if(IsNull(\
if(SECTOR_INFOCUS_CU='Autogas','Autogas',\
if(SECTOR_INFOCUS_CU='Envasado',\
\
if(NAUTI_INFOCUS_CU='Autogas','Autogas',\
if(VTWEG_INFOCUS_CU='ME','Medidores',\
if(VTWEG_INFOCUS_CU='DI','Distribuidores',\
if(VTWEG_INFOCUS_CU = 'CU','Cupones',\
if(SECTOR_INFOCUS_CU='Autogas','Autogas',\
if(SPART_INFOCUS_CU = 'EN', 'Reparto Publico Envasado',\
if(VTWEG_INFOCUS_CU='RP' and SPART_INFOCUS_CU = 'GR', 'Reparto Publico Granel'))))))),\
\
if(VTWEG_INFOCUS_CU='ME','Medidores',\
\
if(SECTOR_INFOCUS_CU='Granel',[Tipo Cliente],\
if(NAUTI_INFOCUS_CU='Autogas','Autogas',\
if(VTWEG_INFOCUS_CU='ME','Medidores',\
if(VTWEG_INFOCUS_CU='DI','Distribuidores',\
if(VTWEG_INFOCUS_CU = 'CU','Cupones',\
if(SECTOR_INFOCUS_CU='Autogas','Autogas',\
if(SPART_INFOCUS_CU = 'EN', 'Reparto Publico Envasado',\
if(VTWEG_INFOCUS_CU='RP' and SPART_INFOCUS_CU = 'GR', 'Reparto Publico Granel'))))))))))))\
and VTWEG_INFOCUS_CU='RP' and SECTOR_INFOCUS_CU='Granel' ,'Reparto Publico Granel',\
if(SECTOR_INFOCUS_CU='Autogas','Autogas',\
if(SECTOR_INFOCUS_CU='Envasado',\
\
if(NAUTI_INFOCUS_CU='Autogas','Autogas',\
if(VTWEG_INFOCUS_CU='ME','Medidores',\
if(VTWEG_INFOCUS_CU='DI','Distribuidores',\
if(VTWEG_INFOCUS_CU = 'CU','Cupones',\
if(SECTOR_INFOCUS_CU='Autogas','Autogas',\
if(SPART_INFOCUS_CU = 'EN', 'Reparto Publico Envasado',\
if(VTWEG_INFOCUS_CU='RP' and SPART_INFOCUS_CU = 'GR', 'Reparto Publico Granel'))))))),\
\
if(VTWEG_INFOCUS_CU='ME','Medidores',\
\
if(SECTOR_INFOCUS_CU='Granel',[Tipo Cliente],\
if(NAUTI_INFOCUS_CU='Autogas','Autogas',\
if(VTWEG_INFOCUS_CU='ME','Medidores',\
if(VTWEG_INFOCUS_CU='DI','Distribuidores',\
if(VTWEG_INFOCUS_CU = 'CU','Cupones',\
if(SECTOR_INFOCUS_CU='Autogas','Autogas',\
if(SPART_INFOCUS_CU = 'EN', 'Reparto Publico Envasado',\
if(VTWEG_INFOCUS_CU='RP' and SPART_INFOCUS_CU = 'GR', 'Reparto Publico Granel'))))))))))))	,\
\
\
(if(SECTOR_INFOCUS_CU='Autogas','Autogas',\
if(SECTOR_INFOCUS_CU='Envasado',\
\
if(NAUTI_INFOCUS_CU='Autogas','Autogas',\
if(VTWEG_INFOCUS_CU='ME','Medidores',\
if(VTWEG_INFOCUS_CU='DI','Distribuidores',\
if(VTWEG_INFOCUS_CU = 'CU','Cupones',\
if(SECTOR_INFOCUS_CU='Autogas','Autogas',\
if(SPART_INFOCUS_CU = 'EN', 'Reparto Publico Envasado'))))))))))								as INFOCUS_POA_ANUAL,\
YBUDAT_INFOCUS_CU&'|'&num(MBUDAT_INFOCUS_CU)&'|'&num(REGIO_INFOCUS_CU)&'|'&SECTOR_INFOCUS_CU	as INFOCUS_POA_$KG,\
YBUDAT_INFOCUS_CU&'|'&num(MBUDAT_INFOCUS_CU)&'|'&SECTOR_INFOCUS_CU								as INFOCUS_POA_PON,\
YBUDAT_INFOCUS_CU&'|'&num(REGIO_INFOCUS_CU)&'|'&SECTOR_INFOCUS_CU								as INFOCUS_POA_PON_ANUAL\
Resident TMP1;\
Drop Table TMP1;\
\
// STORE TB_INFOCUS into lib://Raiz/QVD\\PROCESADOS\\INFOCUS\\OFIC\\NIVEL1\\1_INFOCUS_GENERAL_$(vFecha_Qvd2).qvd;\
// Drop Table TB_INFOCUS;\
// STORE CUPONES into lib://Raiz/QVD\\PROCESADOS\\INFOCUS\\OFIC\\NIVEL1\\0_CUPONES_$(vFecha_Qvd2).qvd;\
\
\
// Trace---------------------------------------------------------------------;\
// Trace-------------1_INFOCUS_GENERAL_$(vFecha_Qvd2)------------------------;\
// Trace---------------------------------------------------------------------;\
\
// Trace---------------------------------------------------------------------;\
// Trace-------------1_INFOCUS_GENERAL_$(vFecha_Qvd2)------------------------;\
// Trace---------------------------------------------------------------------;\
// Trace---------------------------------------------------------------------;\
// Trace-------------1_INFOCUS_GENERAL_$(vFecha_Qvd2)------------------------;\
// Trace---------------------------------------------------------------------;\
// Trace---------------------------------------------------------------------;\
// Trace-------------1_INFOCUS_GENERAL_$(vFecha_Qvd2)------------------------;\
// Trace---------------------------------------------------------------------;\
// Trace---------------------------------------------------------------------;\
// Trace-------------1_INFOCUS_GENERAL_$(vFecha_Qvd2)------------------------;\
// Trace---------------------------------------------------------------------;\
// Trace---------------------------------------------------------------------;\
// Trace-------------1_INFOCUS_GENERAL_$(vFecha_Qvd2)------------------------;\
// Trace---------------------------------------------------------------------;\
// Trace---------------------------------------------------------------------;\
// Trace-------------1_INFOCUS_GENERAL_$(vFecha_Qvd2)------------------------;\
// Trace---------------------------------------------------------------------;\
// Trace---------------------------------------------------------------------;\
// Trace-------------1_INFOCUS_GENERAL_$(vFecha_Qvd2)------------------------;\
// Trace---------------------------------------------------------------------;\
// Trace---------------------------------------------------------------------;\
// Trace-------------1_INFOCUS_GENERAL_$(vFecha_Qvd2)------------------------;\
// Trace---------------------------------------------------------------------;\
// Trace---------------------------------------------------------------------;\
// Trace-------------1_INFOCUS_GENERAL_$(vFecha_Qvd2)------------------------;\
// Trace---------------------------------------------------------------------;\
Drop Table BSEG;\
\
Drop Table Contabilidadxx;\
Drop Table CUPONES;\
Next;\
\
\
\
DROP Table LIPSx;\
Drop Table T005F;\
Drop Table Ramo958;\
Drop Table MAKT;\
Drop Table VBFA_PURO_2023;\
// Drop Table FICA0;\
Drop Table TVTWT;\
Drop Table Cliente958;\
DROP Table DET_SD;\
DROP Table VBRKZT;\
\
DROP Table MSEG;\
\
Drop Table VTTK;\
Drop Table ZUONR_BSEG;\
DROP Table CE4AB00_ACCT;  \
DROP Table VBAK;\
Drop Table VBRK;\
DROP Table LIKP;\
Drop Table MPBKPF;\
Drop Table T001WQ;\
Drop Table KNA1;\
Drop Table  ZTCUPONESQVD;\
Drop Table T005U;// DROP Table SAP_SD;\
// DROP Table VBRK;\
// DROP Table BSEG;\
// DROP Table VTTK;\
// DROP Table LIKP;\
\
\
}


LET VAñoMin = Year(Today())-2;


SAP_SD:
//Left Keep(Contabilidadx)
LOAD VBELN_KEY,
     FKDAT_VBRK,
     MATNR_VBRP, 
     NTGEW_VBRP
//      POSNR_VBRP,
//      VGPOS_VBRP
// //     VTWEG_VBRK,
// 	 SPART_VBRK, 
//     KUNAG_VBRK
FROM
lib://Raiz/QVD\PROCESADOS\COMERCIAL\COMPARTIDOS\SAP_SD.qvd
(qvd)Where YEAR_VBRK >= '$(VAñoMin)';



KGSD:
LOAD 'SD'														as [INFOCUS OKG],
//num(REGIO_VBRKx)&'|'&SPART_VBRK&'|'&VTWEG_VBRK&'|'&KUNAG_VBRK&'|'&VBELN_KEY&'|'&MATNR_VBRP&'|'&MATNR_VBRP			as KEY_UNION,
    VBELN_KEY&'|'&MATNR_VBRP									as BELNR_INFOCUS_CU,
//     FKDAT_VBRK,
//     MATNR_VBRP, 

     SUM(NTGEW_VBRP)/1											as NTGEW_KG,
     SUM(NTGEW_VBRP)/1000										as NTGEW_TON
Resident SAP_SD Group By 'SD',VBELN_KEY&'|'&MATNR_VBRP;;
DROP Table SAP_SD;

FICA:
LOAD
    NUMBER_DOCUMENT_ERDK,
    AWKEY_FICA,
    Región_Cenopers,
    "Codigo Cliente",
    "Comunas Suministro",
    BUDAT_DFKKKO,
    CMED,
    UEBUD_DFKKSUM,
    NBUDAT_CMED,
    YEAR_DFKKSUM,
    MONTH_DFKKSUM,
    M3,
    KG_M3
FROM [lib://Raiz/QVD/PROCESADOS/INFOCUS/OFIC/NIVEL1/0_FICA_*.qvd]
(qvd);


Concatenate(KGSD)
LOAD 
'ME'															as [INFOCUS OKG],
NUMBER_DOCUMENT_ERDK											as BELNR_INFOCUS_CU,
KG_M3															as NTGEW_KG,
KG_M3/1000														as NTGEW_TON
Resident FICA;

DROP Table FICA;



CUPONES:
LOAD
    MFLAG_ZTCUPONES,
    ORIGEN_DATA,
    GRUPP_INFOCUS_CU,
    SPART_ZTCUPONES,
    VTWEG_ZTCUPONES,
    YEART_ZTCUPONES,
    MONTT_ZTCUPONES,
    HKONT_ZTCUPONES,
    KUNAG_FACTU,
    REGION_CUCUPONES,
    KUNAG_CUCUPONES,
    CUPON_ZTCUPONES,
    TRANS_ZTCUPONES,
    FACTU_ZTCUPONES,
    ENTRE_ZTCUPONES,
    MATNR_ZTCUPONES,
    ZVALDESC_ZTCUPONES,
    CANJE_FISICO_ZTCUPONES
FROM [lib://Raiz/QVD/PROCESADOS/INFOCUS/OFIC/NIVEL1/0_CUPONES_*.qvd]
(qvd);


Concatenate(KGSD)
//INFOCUS1:	
LOAD
'CU'															as [INFOCUS OKG],
CUPON_ZTCUPONES&'|'&num(MakeDate(YEART_ZTCUPONES,MONTT_ZTCUPONES,1))												    as BELNR_INFOCUS_CU,
CANJE_FISICO_ZTCUPONES											as NTGEW_KG,
CANJE_FISICO_ZTCUPONES/1000										as NTGEW_TON		
Resident CUPONES;
DROP Table CUPONES;

CUPO_KG:
LOAD
KG_CUPO															as BELNR_INFOCUS_CU,
FKART_CUPO,
if(
FKART_CUPO='ZFCU' or 
FKART_CUPO = 'ZFFI' or 
FKART_CUPO = 'S2',NTGEW_CUPO,NTGEW_CUPO*-1)
																as NTGEW_CUPO_KG,
(if(
FKART_CUPO='ZFCU' or 
FKART_CUPO = 'ZFFI' or 
FKART_CUPO = 'S2',NTGEW_CUPO,NTGEW_CUPO*-1))/1000	
																as NTGEW_CUPO_TON,
																WAVWR_CUPO
Resident KG_CUPO;
DROP Table KG_CUPO;

STORE KGSD into lib://Raiz/QVD\PROCESADOS\INFOCUS\OFIC\NIVEL1\1_INFOCUS_KGSD.qvd;
STORE CUPO_KG into lib://Raiz/QVD\PROCESADOS\INFOCUS\OFIC\NIVEL1\1_INFOCUS_CUPON_KG.qvd;