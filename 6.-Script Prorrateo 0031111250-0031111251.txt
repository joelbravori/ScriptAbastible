LET vInicio050_51 = Now();

For Each vPeriodo2 in $(varPeriodos2)

  
Let vFechaIni2 = Date(Date#('$(vPeriodo2)','YYYYMM'),'YYYYMMDD');
Let vFechaFin2 = Date(MonthEnd(Date#('$(vPeriodo2)','YYYYMM')),'YYYYMMDD');  
LET vFecha_Qvd2 = Left(vPeriodo2,4)&num(Right(vPeriodo2,2));
LET vFecha_Año = Left(vPeriodo2,4);

Trace $(vFechaIni2);
Trace $(vFechaFin2);
Trace $(vFecha_Qvd2);

KG_CANJE_CANAL:
LOAD KEY_KG_CANAL, 
     YEAR_KG_CANAL, 
     MONTH_KG_CANAL, 
     MONTHNAME_KG_CANAL, 
     NUMMONTHNAME_KG_CANAL, 
     ZONA_KG_CANAL, 
     REGION_KG_CANAL, 
     COMUNA_KG_CANAL, 
     SECTOR_KG_CANAL, 
     CANJE_KG_CANAL, 
     CANAL_KG_CANAL, 
     CLIENTE_KG_CANAL, 
      if((IsNull(MATNR_KG_CANAL) and CANAL_KG_CANAL = 'Industrial'),'GR NOR',
     MATNR_KG_CANAL)																as MATNR_KG_CANAL,
     DoCUMENT_CANAL, 
     NTGEW_KG_CN
FROM
lib://Raiz/QVD\PROCESADOS/INFOCUS/OFIC/NIVEL1\3_CANJE_CANAL_INFOCUS_KG_$(vFecha_Qvd2).qvd
(qvd)Where (CLIENTE_KG_CANAL <> 'ZOC0000001') and 
if(CANJE_KG_CANAL= 'CU - Canjeados',1,
if(CANJE_KG_CANAL='IN - Comercial'/* and CANAL_KG_CANAL <> 'Cupones'*/,1))=1 and (SECTOR_KG_CANAL = 'Autogas' or SECTOR_KG_CANAL = 'Granel') and (CANAL_KG_CANAL <> 'Medidores');



KG_CANJE:
LOAD YEAR_KG_CANAL, 
     YEAR_KG_CANAL&'|'&MONTH_KG_CANAL&'|'&SECTOR_KG_CANAL											as YM_KG_CANAL,
     YEAR_KG_CANAL&'|'&MONTH_KG_CANAL&'|'&SECTOR_KG_CANAL&'|'&CANJE_KG_CANAL						as YM_KG_CANAL2,
     MONTH_KG_CANAL, 
     MONTHNAME_KG_CANAL,
     NUMMONTHNAME_KG_CANAL,
     ZONA_KG_CANAL, 
     REGION_KG_CANAL, 
     COMUNA_KG_CANAL,
     SECTOR_KG_CANAL, 
     CANJE_KG_CANAL, 
     CANAL_KG_CANAL, 
     CLIENTE_KG_CANAL,
     MATNR_KG_CANAL,
     NTGEW_KG_CN
Resident KG_CANJE_CANAL;// Where CANAL_KG_CANAL <> 'Total';
DROP Table KG_CANJE_CANAL;



CANJE_CANAL:
LOAD 1,
     YEAR_KG_CANAL, 
     YM_KG_CANAL,
     YM_KG_CANAL2,
     MONTH_KG_CANAL, 
     MONTHNAME_KG_CANAL,
     NUMMONTHNAME_KG_CANAL,
     ZONA_KG_CANAL, 
     REGION_KG_CANAL, 
     COMUNA_KG_CANAL,
     SECTOR_KG_CANAL, 
     CANJE_KG_CANAL, 
     CANAL_KG_CANAL, 
     CLIENTE_KG_CANAL,
     MATNR_KG_CANAL,
     Round(sum(NTGEW_KG_CN))													as 	NTGEW_KG_CN
     Resident KG_CANJE Group By
     1,
     YEAR_KG_CANAL, 
     YM_KG_CANAL,
     YM_KG_CANAL2,	
     MONTH_KG_CANAL, 
     MONTHNAME_KG_CANAL,
NUMMONTHNAME_KG_CANAL,
     ZONA_KG_CANAL, 
     REGION_KG_CANAL,
     COMUNA_KG_CANAL, 
     SECTOR_KG_CANAL, 
     CANJE_KG_CANAL, 
     CANAL_KG_CANAL, 
     CLIENTE_KG_CANAL,
     MATNR_KG_CANAL;
     DROP Table KG_CANJE;

Left Join(CANJE_CANAL)
LOAD
YM_KG_CANAL2,
(sum(NTGEW_KG_CN))													as 	NTGEW_KG_TOT
Resident CANJE_CANAL Group By YM_KG_CANAL2;

CANAL_CANJE:
LOAD *,
4,
num(NTGEW_KG_CN/NTGEW_KG_TOT,'#.##0,00000%')						    as NTGEW_KG_%
Resident CANJE_CANAL;
DROP Table CANJE_CANAL;

Set vQvdFile 	= 'Tab_Infocus_Volumen_Autogas_';	
Set vQvdFile2 	= 'CANAL_CANJE';																		// Nombre de Archivo a crear
Set vFileOri	= 'CANAL_CANJE'; 																		// Nombre de archivo a cargar
Set vDesc		= 'Qvd Residual Infocus Volumen Autogas';									// Descripción de la Tabla
Set vExtension	= '.qvd';


TRACE ----------------------------------------------------------------------------------------------------------------------;
TRACE Carga Tabla $(vQvdFile) de tabla Origen $(vFileOri);
TRACE ----------------------------------------------------------------------------------------------------------------------;	
Let vRegistro = NoOfRows('$(vFileOri)');

Let vTiempo2 = now();

//--------------------------------------------------------------------------------------------------------------------------
// Registro Estadístico de Carga
//--------------------------------------------------------------------------------------------------------------------------
LOG:
LOAD
	'$(vFileOri)'															as Tabla,
	'$(vRegistro)'															as Registros,
	Date('$(vTiempo1)', 'DD-MM-YYYY')										as Fecha,
	Time('$(vTiempo1)', 'hh:mm:ss')											as HoraInicio,
	Time('$(vTiempo2)', 'hh:mm:ss')											as HoraFin,
	'$(vQvdFile)$(vPerio1)'															as QVD,
	'$(vDesc)'																as Definicion,
	FileSize('$(vPathQvd)$(vQvdFile)$(vExtension)')							as Tamaño,
	Time(NumSum('$(vTiempo2)',-1*'$(vTiempo1)'), 'hh:mm:ss')				as Tiempo
AUTOGENERATE 1;



//Hoja2




tmp:
LOAD
trim(PurgeChar(Documento,'|'))&(num(CUENTA))										as KeyProrrateo,
'BKPFF'				as AWTYP
FROM [lib://Raiz/EXT/INFOCUS/Ajustes doc sin asignar.xlsx]
(ooxml, embedded labels, table is [% Abastecimiento GR norte]);

Concatenate(tmp)
LOAD
 trim(PurgeChar(Documento,'|'))&(num(CUENTA))										as KeyProrrateo,
'BKPFF'				as AWTYP
FROM [lib://Raiz/EXT/INFOCUS/Ajustes doc sin asignar.xlsx]
(ooxml, embedded labels, table is [% Abastecimiento GR-EN sur]);

Concatenate(tmp)
LOAD
    trim(PurgeChar(Documento,'|'))&num(CUENTABI)									 as KeyProrrateo,
'BKPFF'				as AWTYP
FROM [lib://Raiz/EXT/INFOCUS/Ajustes doc sin asignar.xlsx]
(ooxml, embedded labels, table is [% Lipigas]);



Concatenate(tmp)
LOAD
trim(PurgeChar(Documento,'|'))&num(CUENTA)									         as KeyProrrateo,  
'BKPFF'				as AWTYP
FROM [lib://Raiz/EXT/INFOCUS/Ajustes doc sin asignar.xlsx]
(ooxml, embedded labels, table is [% dcto RUT]);

Concatenate(tmp)
LOAD
trim(PurgeChar(Documento,'|'))&num(CUENTA)									         as KeyProrrateo, 
    'BKPFF'				as AWTYP
FROM [lib://Raiz/EXT/INFOCUS/Ajustes doc sin asignar.xlsx]
(ooxml, embedded labels, table is Ajustes);





//Hoja 3




INFOCUS_GENERAL:
LOAD YBUDAT_INFOCUS_CU&'|'&MBUDAT_INFOCUS_CU&'|'&if(HKONT_INFOCUS_CU='0031111250','Granel','Autogas')				as YM_KG_CANAL,
     YBUDAT_INFOCUS_CU, 
     MBUDAT_INFOCUS_CU, 
     HKONT_INFOCUS_CU, 
     Left(
     trim(PurgeChar(mid(BELNR_INFOCUS_CU,1,FindOneOf(BELNR_INFOCUS_CU,'|')),'|'))
     ,10)																			as BELNR_BSEG,
     BELNR_INFOCUS_CU,
     DMBTR_INFOCUS_CU																as DMBTR_INFOCUS_CU
FROM
lib://Raiz/QVD\PROCESADOS/INFOCUS/OFIC/NIVEL1/2_INFOCUS_PROCESADO_$(vFecha_Qvd2)*.qvd
(qvd)Where (HKONT_INFOCUS_CU = '0031111250' or HKONT_INFOCUS_CU = '0031111251') and (AWTYP_INFOCUS_CU = 'BKPF')
;

// BSEG:
Left Join(INFOCUS_GENERAL)
LOAD
   
    PAOBJNR_BSEG					as PAOBJNR,
    BELNR_BSEG
   
FROM [lib://Raiz/QVD/BASE/SAP/INCREMENTAL/BSEG_$(vFecha_Qvd2).qvd]
(qvd);

FOR Each vPerio in  '$(vY1)','$(vY2)'//,'$(vPerio3)'//,'$(vPerio4)'

CE4AB00:
// Left Keep(INFOCUS_GENERAL)
LOAD PAOBJNR, 
     KNDNR
FROM
lib://Raiz/QVD\BASE\SAP\INCREMENTAL\CE4AB00_ACCT_$(vPerio).qvd
(qvd)
;


NEXT;

Concatenate(CE4AB00)
LOAD

    PAOBJNR_CE4AB00				as PAOBJNR,
    KNDNR_CE4AB00				as KNDNR
FROM [lib://Raiz/QVD/BASE/SAP/UNICA/CE4AB00.qvd]
(qvd)
;

Left Join(INFOCUS_GENERAL)
Load
PAOBJNR,
KNDNR
Resident CE4AB00;
Drop Table CE4AB00;


Concatenate(tmp)
Load
trim(PurgeChar(mid(BELNR_INFOCUS_CU,1,FindOneOf(BELNR_INFOCUS_CU,'|')),'|'))&num(HKONT_INFOCUS_CU)				as KeyProrrateo, 
'BKPFF'				as AWTYP
Resident INFOCUS_GENERAL Where  (if(KNDNR = '' or KNDNR = ' ' or IsNull(KNDNR),0,1) = 1) ;
Drop Table INFOCUS_GENERAL;



//Hoja 4


 
Ajustesdoc:
Mapping
LOAD Distinct
KeyProrrateo,
AWTYP

Resident tmp;
Drop Table tmp;

INFOCUS_GENERAL:
LOAD YBUDAT_INFOCUS_CU&'|'&MBUDAT_INFOCUS_CU&'|'&if(HKONT_INFOCUS_CU='0031111250','Granel','Autogas')				as YM_KG_CANAL,
     YBUDAT_INFOCUS_CU, 
     MBUDAT_INFOCUS_CU, 
     HKONT_INFOCUS_CU, 
     //'Global'																		as SECTOR_INFOCUS_CU,
     DMBTR_INFOCUS_CU																as DMBTR_INFOCUS_CU
FROM
lib://Raiz/QVD\PROCESADOS/INFOCUS/OFIC/NIVEL1/2_INFOCUS_PROCESADO_$(vFecha_Qvd2)*.qvd
(qvd)Where (HKONT_INFOCUS_CU = '0031111250' or HKONT_INFOCUS_CU = '0031111251') and (AWTYP_INFOCUS_CU = 'BKPF')
and
applyMap('Ajustesdoc',trim(PurgeChar(mid(BELNR_INFOCUS_CU,1,FindOneOf(BELNR_INFOCUS_CU,'|')),'|'))&num(HKONT_INFOCUS_CU),'OK')='OK';// or AWTYP_INFOCUS_CU = 'MKPF');


BD_CONTABILIDAD:
LOAD 
2,
     YM_KG_CANAL,
     YBUDAT_INFOCUS_CU, 
     MBUDAT_INFOCUS_CU, 
     HKONT_INFOCUS_CU, 
     sum(DMBTR_INFOCUS_CU)						as DMBTR_INFOCUS_CU
Resident INFOCUS_GENERAL Group By
2,
     YM_KG_CANAL,
     YBUDAT_INFOCUS_CU, 
     MBUDAT_INFOCUS_CU, 
     HKONT_INFOCUS_CU;
 DROP Table INFOCUS_GENERAL;
 
 
 
 
 
     
Left Join(BD_CONTABILIDAD)     
LOAD *,
3
Resident CANAL_CANJE;
//DROP Table CANAL_CANJE;

BD_CONTABILIDAD_AUX:
LOAD 
*,
DMBTR_INFOCUS_CU*NTGEW_KG_%						as DMBTR_INFOCUS_PRORRATEO
Resident BD_CONTABILIDAD;
DROP Table BD_CONTABILIDAD;


//Join(BD_CONTABILIDAD_AUX)
//LOAD * INLINE [
//    CANJE_KG_CANAL
//    CU - Canjeados
//    IN - Comercial
//];

Set vQvdFile 	= 'TB_PRORRATEO_COSTO_50_51_';	
Set vQvdFile2 	= 'BD_CONTABILIDAD_AUX';																		// Nombre de Archivo a crear
Set vFileOri	= 'BD_CONTABILIDAD_AUX'; 																		// Nombre de archivo a cargar
Set vDesc		= 'Qvd Residual Infocus Prorrateo';									// Descripción de la Tabla
Set vExtension	= '.qvd';


TRACE ----------------------------------------------------------------------------------------------------------------------;
TRACE Carga Tabla $(vQvdFile) de tabla Origen $(vFileOri);
TRACE ----------------------------------------------------------------------------------------------------------------------;	
Let vRegistro = NoOfRows('$(vFileOri)');

STORE BD_CONTABILIDAD_AUX into lib://Raiz/QVD\PROCESADOS/INFOCUS/OFIC/NIVEL1\3_TB_PRORRATEO_COSTO_50_51_$(vFecha_Qvd2).qvd;
DROP Table BD_CONTABILIDAD_AUX;

 Let vTiempo2 = now();

//--------------------------------------------------------------------------------------------------------------------------
// Registro Estadístico de Carga
//--------------------------------------------------------------------------------------------------------------------------
LOG:
LOAD
	'$(vFileOri)'															as Tabla,
	'$(vRegistro)'															as Registros,
	Date('$(vTiempo1)', 'DD-MM-YYYY')										as Fecha,
	Time('$(vTiempo1)', 'hh:mm:ss')											as HoraInicio,
	Time('$(vTiempo2)', 'hh:mm:ss')											as HoraFin,
	'$(vQvdFile)$(vPerio1)'															as QVD,
	'$(vDesc)'																as Definicion,
	FileSize('$(vPathQvd)$(vQvdFile)$(vExtension)')							as Tamaño,
	Time(NumSum('$(vTiempo2)',-1*'$(vTiempo1)'), 'hh:mm:ss')				as Tiempo
AUTOGENERATE 1;


   
NEXT;




DROP Table CANAL_CANJE;

LET vFin050_51 = Now();

