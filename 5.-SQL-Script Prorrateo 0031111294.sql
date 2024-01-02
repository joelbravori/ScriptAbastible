LET vInicio0031111294 = Now();

Trace---------------------------------------------------------------------;
Trace-----------------------Tiempo 1 Meses-------------------------------;
Trace---------------------------------------------------------------------;


Set vCantPeriodos = 3;
PeriodosAux6:
Load
	chr(39)&(Year(AddMonths(Today()-1,1 - RowNo()))
	&num(Month(AddMonths(Today()-1,1 - RowNo())), 00))&chr(39)					as Periodo
AutoGenerate $(vCantPeriodos);


PeriodosAux7:
NoConcatenate LOAD
	Concat(Periodo,', ')									as Periodo
Resident PeriodosAux6;
//order by Periodo asc;
DROP Table PeriodosAux6;

Let varPeriodos2	= Peek('Periodo',0,'PeriodosAux7');

DROP Table PeriodosAux7;




MpTipoCline:
Mapping
LOAD
    Código,
    "Tipo Cliente"
FROM [lib://Raiz/EXT/INFOCUS/Base Tipo Cliente(958).xlsx]
(ooxml, embedded labels, table is [Clasificación tipo cliente]);


MPBIOMar:
Mapping
LOAD Distinct
   Cliente,
   Canal

FROM [lib://Raiz/QVD/CONSOLIDADOS/COMERCIAL/NIVEL_2/Eliminaciones_2.0.qvd]
(qvd);

Cuentas:
LOAD
    KEY_FLAG,
    FUENTE									as Canje
FROM [lib://Raiz/QVD/CONSOLIDADOS/COMERCIAL/NIVEL_2/Cuentas.qvd]
(qvd)Where FUENTE ='Canjeado';


LOAD Distinct
   FUENTE									as  KEY_FLAG,
    FUENTE									as Canje
FROM [lib://Raiz/QVD/CONSOLIDADOS/COMERCIAL/NIVEL_2/Cuentas.qvd]
(qvd)Where FUENTE ='Canjeado';



For Each vPeriodo2 in $(varPeriodos2)

  
Let vFechaIni2 = Date(Date#('$(vPeriodo2)','YYYYMM'),'YYYYMMDD');
Let vFechaFin2 = Date(MonthEnd(Date#('$(vPeriodo2)','YYYYMM')),'YYYYMMDD');  
LET vFecha_Qvd2 = Left(vPeriodo2,4)&num(Right(vPeriodo2,2));
LET vFecha_Año = Left(vPeriodo2,4);

Trace $(vFechaIni2);
Trace $(vFechaFin2);
Trace $(vFecha_Qvd2);



Libre_Ventas:
LOAD
    KEY_FLAG,    
    Año,
    Mes,
    Cuenta,
    Zona,
    ZonaFranca,
    Región,
    Comuna,
    Sector,
    Cliente,
    Canal,
    Material,
    Documento,

    Volumen
FROM [lib://Raiz/QVD/CONSOLIDADOS/COMERCIAL/NIVEL_2/Libre_Ventas_2.0_$(vFecha_Año)*.qvd]
(qvd)
;


Next;

KG_CANJE_CANAL:
LOAD
    KEY_FLAG,    
    Año									as YEAR_KG_CANAL,
    Mes									as MONTH_KG_CANAL,
    MonthName(MakeDate(Año,Num(Evaluate(Mes)),1))				as MONTHNAME_KG_CANAL, 
    Num(MonthName(MakeDate(Año,Num(Evaluate(Mes)),1)))				as NUMMONTHNAME_KG_CANAL,
    Cuenta,
    Zona								as ZONA_KG_CANAL,
    ZonaFranca,
    Región								as REGION_KG_CANAL,
    Comuna								as COMUNA_KG_CANAL,
    Sector								as SECTOR_KG_CANAL,
    
        ApplyMap('MPBIOMar',Cliente,
    
    
   if(IsNull( if(Sector='Granel' and Canal<>'Medidores',
	ApplyMap('MpTipoCline',Cliente,null())
	,Canal)),Canal, 
	(	 if(Sector='Granel' and Canal<>'Medidores',
	ApplyMap('MpTipoCline',Cliente,null())
	,Canal)))	)												as  CANAL_KG_CANAL,

    Cliente								as CLIENTE_KG_CANAL,
          if((IsNull(Material) and Canal = 'Industrial'),'GR NOR',
     Material)																as MATNR_KG_CANAL,
     Documento						as DoCUMENT_CANAL,

    Volumen								as NTGEW_KG_CN
Resident Libre_Ventas
Where Exists(KEY_FLAG,KEY_FLAG) and Año&num(Mes)='$(vFecha_Qvd2)';
Drop Table Libre_Ventas;

Join(KG_CANJE_CANAL)
LOAD * Inline [

CANJE_KG_CANAL

CU - Canjeados
IN - Comercial

];



Trace---------------------------------------------------------------------;
Trace-----------------------Tiempo 1 Meses-------------------------------;
Trace---------------------------------------------------------------------;

Set vCantPeriodos = 2;
PeriodosAux6:
Load
	chr(39)&(Year(AddMonths(Today()-1,1 - RowNo()))
	&num(Month(AddMonths(Today()-1,1 - RowNo())), 00))&chr(39)					as Periodo
AutoGenerate $(vCantPeriodos);


PeriodosAux7:
NoConcatenate LOAD
	Concat(Periodo,', ')									as Periodo
Resident PeriodosAux6;
//order by Periodo asc;
DROP Table PeriodosAux6;

Let varPeriodos2	= Peek('Periodo',0,'PeriodosAux7');

DROP Table PeriodosAux7;


For Each vPeriodo2 in $(varPeriodos2)

  
Let vFechaIni2 = Date(Date#('$(vPeriodo2)','YYYYMM'),'YYYYMMDD');
Let vFechaFin2 = Date(MonthEnd(Date#('$(vPeriodo2)','YYYYMM')),'YYYYMMDD');  
LET vFecha_Qvd2 = Left(vPeriodo2,4)&num(Right(vPeriodo2,2));
LET vFecha_Año = Left(vPeriodo2,4);

Trace $(vFechaIni2);
Trace $(vFechaFin2);
Trace $(vFecha_Qvd2);

KG_CANJE:
LOAD YEAR_KG_CANAL, 
    YEAR_KG_CANAL&'|'&MONTH_KG_CANAL&'|'&CANJE_KG_CANAL									as YM_KG_CANAL,
YEAR_KG_CANAL&'|'&MONTH_KG_CANAL&'|'&CANJE_KG_CANAL						as YM_KG_CANAL2,
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
Resident KG_CANJE_CANAL Where YEAR_KG_CANAL&num(MONTH_KG_CANAL)= '$(vFecha_Qvd2)';// Where CANAL_KG_CANAL <> 'Total';



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
     (sum(NTGEW_KG_CN))													as 	NTGEW_KG_CN
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



 
 INFOCUS_GENERAL:
LOAD YBUDAT_INFOCUS_CU&'|'&MBUDAT_INFOCUS_CU										as YM_KG_CANAL,
     YBUDAT_INFOCUS_CU, 
     MBUDAT_INFOCUS_CU, 
     HKONT_INFOCUS_CU, 
     DMBTR_INFOCUS_CU																as DMBTR_INFOCUS_CU
FROM
lib://Raiz/QVD\PROCESADOS/INFOCUS/OFIC/NIVEL1/2_INFOCUS_PROCESADO_$(vFecha_Qvd2).qvd
(qvd)Where (HKONT_INFOCUS_CU = '0031111294');



Join(INFOCUS_GENERAL)
LOAD * INLINE [
    CANJE
    CU - Canjeados
    IN - Comercial
];

BD_CONTABILIDAD:
LOAD 
2,
    YM_KG_CANAL&'|'&CANJE						as YM_KG_CANAL,
     YBUDAT_INFOCUS_CU, 
     MBUDAT_INFOCUS_CU, 
     HKONT_INFOCUS_CU, 
     sum(DMBTR_INFOCUS_CU)						as DMBTR_INFOCUS_CU
Resident INFOCUS_GENERAL Group By
2,
     YM_KG_CANAL&'|'&CANJE,
     YBUDAT_INFOCUS_CU, 
     MBUDAT_INFOCUS_CU, 
     HKONT_INFOCUS_CU;
 DROP Table INFOCUS_GENERAL;
 
 
     
Left Join(BD_CONTABILIDAD)     
LOAD *,
3
Resident CANAL_CANJE;
DROP Table CANAL_CANJE;


BD_CONTABILIDAD_AUX:
LOAD 
*,
DMBTR_INFOCUS_CU*NTGEW_KG_%						as DMBTR_INFOCUS_PRORRATEO
Resident BD_CONTABILIDAD;
DROP Table BD_CONTABILIDAD;
 

Set vQvdFile 	= '3_TB_PRORRATEO_COSTO_1294_';	
Set vQvdFile2 	= 'BD_CONTABILIDAD_AUX';																		// Nombre de Archivo a crear
Set vFileOri	= 'BD_CONTABILIDAD_AUX'; 																		// Nombre de archivo a cargar
Set vDesc		= 'Qvd Residual Infocus Prorrateo';									// Descripción de la Tabla
Set vExtension	= '.qvd';


TRACE ----------------------------------------------------------------------------------------------------------------------;
TRACE Carga Tabla $(vQvdFile) de tabla Origen $(vFileOri);
TRACE ----------------------------------------------------------------------------------------------------------------------;	
Let vRegistro = NoOfRows('$(vFileOri)');

STORE BD_CONTABILIDAD_AUX into lib://Raiz/QVD\PROCESADOS/INFOCUS/OFIC/NIVEL1\3_TB_PRORRATEO_COSTO_1294_$(vFecha_Qvd2).qvd;
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

DROP Table KG_CANJE_CANAL;
DROP Table Cuentas;

LET vFin0031111294 = Now();


