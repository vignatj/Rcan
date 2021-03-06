########################################
## EJERCICIO 3 - PREPARACION DE DATOS ##
########################################

############### Ejercicio I #############
#?# Establecer el directorio de trabajo del ejercicio "3-Manipulacion"
#?# Leer el archivo de datos "Ejercicio3_datos.csv" en un marco de datos llamado 'dat'
#?# A continuaci�n, ejecute los siguientes R comandos
############# FIN DEL EJERCICIO #############

# ESTABLECER EL DIRECTORIO DE TRABAJO
...

# LEER EL ARCHIVO DE DATOS
...

# CALCULAR LA FECHA DE INCIDENCIA
dat$INCID[substr(dat$INCID,5,8)=="9999"] <- paste(substr(dat$INCID[substr(dat$INCID,5,8) == "9999"],1,4),"0715",sep="")
dat$INC_DATE = strptime(dat$INCID, format = "%Y%m%d")

# CALCULAR LA FECHA DE NACIMIENTO 
dat$BIRTHD[substr(dat$BIRTHD,5,8)=="9999"] <- paste(substr(dat$BIRTHD[substr(dat$BIRTHD,5,8) == "9999"],1,4),"0715",sep="")
dat$BTH_DATE = strptime(dat$BIRTHD, format = "%Y%m%d")

# CALCULAR LA EDAD
dat$AGE = as.numeric(round(difftime(dat$INC_DATE,dat$BTH_DATE,units = "days") / 365.25))
dat$AGE[substr(dat$BIRTHD,1,4)=="9999"] <- NA

#CONVERTIR LA EDAD EN GRUPOS DE EDAD
dat$AGEGRP = as.integer(cut(dat$AGE, breaks=c(seq(0, 85, by=5),115), right=FALSE))
dat$AGEGRP[is.na(dat$AGEGRP)] <- 19

#CREAR EL ANO DE INCIDENCIA
dat$YEAR = as.numeric(substr(dat$INCID,1,4))

#CREAR LA VARIABLE DE CODIGO ICD
dat$ICD = substr(dat$I10,1,3)

#CONVERTIR LOS CODIGOS ICD EN ETIQUETAS
icd = read.table(file="Datos-icd.txt", header=TRUE, stringsAsFactors=FALSE)
dat = merge(x=dat, y=icd, by="ICD", all.x=TRUE)
dat$CANCER[is.na(dat$CANCER)] <- "OTHER"

#CREAR UNA "CASES" VARIABLE
dat$CASES = 1

#CALCULAR LOS DATOS AGREGADOS
datag = aggregate(CASES ~ SEX+AGEGRP+YEAR+CANCER,data=dat,sum)

#ORDENAR LOS DATOS POR "SEX", "YEAR", "CANCER" y "AGEGRP"
datag = datag[order(datag$SEX, datag$YEAR, datag$CANCER, datag$AGEGRP),]

#ASIGNAR LA INFORMACION DE POBLACION
pop = read.table(file="Datos-poblacion.txt", header=TRUE)
datag = merge(x=datag, y=pop, by=c("SEX","AGEGRP","YEAR"), all.x=TRUE, sort = TRUE)

############### Ejercicio II #############
#?# Exportar el marco de datos 'datag' en un archivo de salida llamado "Ejercicio3_salida.csv" 
#?# Y compruebe el archivo de datos resultante en su directorio de trabajo
############# FIN DEL EJERCICIO #############

#ESCRIBIR UN ARCHIVO DE DATOS DE SALIDA
...





##
## Este es el final de los pasos equivalentes de Excel para manipular el archivo de datos. 
##

#####################################################################
## MATERIAL Y COMANDOS ADICIONALES SOBRE LA MANIPULACI�N DE DATOS  ##
#####################################################################

# ELIMINAR TODOS LOS OBJETOS DEL DIRECTORIO DE TRABAJO
remove(list = ls())

# ESTABLECER EL DIRECTORIO DE TRABAJO
setwd("D:/LMICourse/Ejercicios/3-Manipulacion")

## FUENTE: DATOS ARTIFICIALES DEL REGISTRO DE C�NCER DE VIDA REAL
## FUENTE: DATOS ARTIFICIALES DEL REGISTRO DE C�NCER DE VIDA REAL
## FUENTE: DATOS ARTIFICIALES DEL REGISTRO DE C�NCER DE VIDA REAL

#############################################
# ------ IMPORTAR EL ARCHIVO DE DATOS -------
#############################################

# LEA EL FICHERO DE DATOS
dat = read.csv(file="EJEMPLO_3.csv", header=TRUE, sep=",")

# MIRE LA ESTRUCTURA INTERNA DEL DATASET
str(dat)

# MOSTRAR LAS PRIMERAS L�NEAS
head(dat)

# MOSTRAR LOS NOMBRES DE VARIABLES
names(dat)

#VER EL FICHERO DE DATOS
View(dat)

#############################################
# ------ TRANSFORMAR EL FICHERO DE DATOS ----
#############################################

# SELECCI�N DE VARIABLES
dat = dat[,c("AGE", "INCID", "SEX", "BIRTHD", "LABEL", "I10", "TOP")]

# CAMBIAR EL NOMBRE DE UNA VARIABLE
names(dat)[names(dat) == "LABEL"] = "CANCER_LAB"

# A�ADIR UNA VARIABLE
dat$REGISTRY_LAB <- "COUNTRY_1"


###################################
# ------ DESCRIBA LOS DATOS -------
###################################

# RESUMEN DE LAS VARIABLES
summary(dat)

# CATEGORIZACI�N EN EL SEXO
table(dat$SEX)

# CATEGORIZACI�N EN EL C�NCER
table(dat$CANCER_LAB)

# RANGO DE EDAD
range(dat$AGE)
range(dat$AGE[dat$AGE!=999])
# N�mero de registros que faltan c�digos para AGE
nrow(dat[dat$AGE==999,]) #El marco de datos
length(dat$AGE[dat$AGE==999]) #El vector

# DISTRIBUCI�N DE EDAD
hist(dat$AGE[dat$AGE!=999])


####################################
# ------ CONVERTIR LOS DATOS -------
####################################

# REEMPLAZAR LA EDAD PERDIDA
dat$AGE[is.na(dat$AGE)] <- 999
dat$AGE[dat$AGE %in% c(""," ")] <- 999
table(dat$AGE, exclude = NULL)
sum(table(dat$AGE))


######################################
# ------ GENERAR NUEVAS VARIABLES ----
######################################

# GRUPOS DE EDAD
dat = transform(dat, 
        AGEGRP = as.integer(cut(AGE, breaks=c(seq(0, 85, by=5),100), right=FALSE)))

table(dat$AGEGRP)

dat$AGEGRP[dat$AGE==100] <- 18

dat$AGEGRP[is.na(dat$AGEGRP)] <- 19

sum(table(dat$AGEGRP))

with(dat, tapply(AGE, AGEGRP, mean))

# A�O DE INCIDENCIA
dat$YEAR = as.numeric(substr(dat$INCID,1,4))

table(dat$YEAR)

sum(table(dat$YEAR))

# FECHA DE NACIMIENTO
dat$BIRTH_DATE = as.Date(dat$BIRTHD, format='%Y%m%d')

# Fijaci�n del �ltimo d�a del mes en fechas
dat$BIRTHD[substr(dat$BIRTHD,5,8) == "0230"] <- paste(substr(dat$BIRTHD[substr(dat$BIRTHD,5,8) == "0230"],1,4),"0228",sep="")
dat$BIRTHD[substr(dat$BIRTHD,5,8) == "0231"] <- paste(substr(dat$BIRTHD[substr(dat$BIRTHD,5,8) == "0231"],1,4),"0228",sep="")
dat$BIRTHD[substr(dat$BIRTHD,5,8) == "0229"] <- paste(substr(dat$BIRTHD[substr(dat$BIRTHD,5,8) == "0229"],1,4),"0228",sep="")
dat$BIRTHD[substr(dat$BIRTHD,5,8) == "0431"] <- paste(substr(dat$BIRTHD[substr(dat$BIRTHD,5,8) == "0431"],1,4),"0430",sep="")
dat$BIRTHD[substr(dat$BIRTHD,5,8) == "0631"] <- paste(substr(dat$BIRTHD[substr(dat$BIRTHD,5,8) == "0631"],1,4),"0630",sep="")
dat$BIRTHD[substr(dat$BIRTHD,5,8) == "0931"] <- paste(substr(dat$BIRTHD[substr(dat$BIRTHD,5,8) == "0931"],1,4),"0930",sep="")
dat$BIRTHD[substr(dat$BIRTHD,5,8) == "1131"] <- paste(substr(dat$BIRTHD[substr(dat$BIRTHD,5,8) == "1131"],1,4),"1130",sep="")

dat$BIRTH_DATE = as.Date(dat$BIRTHD, format='%Y%m%d')

# Conversi�n de fecha que falla
nrow(dat[is.na(dat$BIRTH_DATE),])
nrow(dat[substr(dat$BIRTHD,1,4) == "9999",])

# REEMPLAZAR LA INFORMACI�N DEL MES Y EL D�A QUE FALTA
dat$BIRTH_DATE[substr(dat$BIRTHD,5,8) == "9999" & substr(dat$BIRTHD,1,4) != "9999"] = as.Date(paste(substr(dat$BIRTHD[substr(dat$BIRTHD,5,8) == "9999" & substr(dat$BIRTHD,1,4) != "9999"],1,4),"0715",sep=""), format='%Y%m%d')
nrow(dat[is.na(dat$BIRTH_DATE),])

# GENERACI�N DE GRUPOS DE C�NCER
summary(dat$I10)
dat$ICD = as.factor(substr(dat$I10,0,3))
table(dat$ICD)

dat$CANCER = 29
dat$CANCER[dat$TOP >= 500 & dat$TOP <= 509] = 14
dat$CANCER[dat$TOP >= 320 & dat$TOP <= 329] = 10
dat$CANCER[dat$TOP >= 670 & dat$TOP <= 679] = 21
dat$CANCER[dat$TOP >= 530 & dat$TOP <= 539] = 15
dat$CANCER[dat$TOP >= 190 & dat$TOP <= 209] = 62
dat$CANCER[dat$TOP >= 0 & dat$TOP <= 89] = 1
dat$CANCER[dat$TOP >= 110 & dat$TOP <= 119] = 2
dat$CANCER[(dat$TOP >= 90 & dat$TOP <= 109) | (dat$TOP >= 120 & dat$TOP <= 149)] = 3
dat$CANCER[dat$TOP >= 150 & dat$TOP <= 159] = 4
dat$CANCER[dat$TOP >= 160 & dat$TOP <= 169] = 5
dat$CANCER[dat$TOP >= 180 & dat$TOP <= 189] = 61
dat$CANCER[dat$TOP >= 220 & dat$TOP <= 229] = 7
dat$CANCER[dat$TOP >= 230 & dat$TOP <= 249] = 8
dat$CANCER[dat$TOP >= 250 & dat$TOP <= 259] = 9
dat$CANCER[dat$TOP >= 330 & dat$TOP <= 349] = 11
dat$CANCER[dat$TOP >= 430 & dat$TOP <= 439] = 12
dat$CANCER[dat$TOP >= 460 & dat$TOP <= 469] = 13
dat$CANCER[dat$TOP >= 540 & dat$TOP <= 549] = 16
dat$CANCER[dat$TOP >= 560 & dat$TOP <= 569] = 17
dat$CANCER[dat$TOP >= 610 & dat$TOP <= 619] = 18
dat$CANCER[dat$TOP >= 620 & dat$TOP <= 629] = 19
dat$CANCER[dat$TOP >= 640 & dat$TOP <= 669] = 20
dat$CANCER[dat$TOP >= 700 & dat$TOP <= 729] = 22
dat$CANCER[dat$TOP >= 730 & dat$TOP <= 739] = 23

table(dat$CANCER)

# ASIGNACI�N DE LA ETIQUETA A LOS GRUPOS DE C�NCER
dat$fCANCER = factor(dat$CANCER, 
              levels = c(1, 2, 3, 4, 5, 61, 62, 7, 8, 9, 10, 11, 12, 13, 
                         14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29),
              labels = c("Lip oral cavity",
                          "Nasopharynx",
                          "Other pharynx",
                          "Oesophagus",
                          "Stomach",
                          "Colon",
                          "Rectum" , 
                          "Liver",
                          "Gallbladder",
                          "Pancreas",
                          "Larynx",
                          "Lung",
                          "Melanoma of skin",
                          "Kaposi sarcoma",
                          "Breast",
                          "Cervix uteri",
                          "Corpus uteri",
                          "Ovary",
                          "Prostate",
                          "Testis",
                          "Kidney",
                          "Bladder",
                          "Brain, nervous system",
                          "Thyroid",
                          "Hodgkin lymphoma",
                          "Non-Hodgkin lymphoma",
                          "Multiple myeloma",
                          "Leukaemia",
                          "All cancers excl. non-melanoma skin cancer",
                          "All other cancers")
                          )

table(dat$fCANCER)


####################################
# ------ COMPRUEBE LOS DATOS -------
####################################

# FUNCI�N PARA MOSTRAR EL N�MERO DE VALORES 'NA'
NAPerVariable = function(X) {
  D = is.na(X)
  colSums(D)
}

NAPerVariable(dat)

# FUNCI�N PARA MOSTRAR EL N�MERO DE VALORES '0'
ZerosPerVariable = function(X) {
  D = (X == 0)
  colSums(D)
}

ZerosPerVariable(dat)

# FUNCI�N PARA MOSTRAR EL N�MERO DE VALORES 'N'
NumPerVariable = function(X, N) {
  D = (X == N)
  colSums(D)
}

NumPerVariable(dat,999)

# COMPRUEBE LA FECHA DE NACIMIENTO

# A�O
sort(unique(substr(dat$BIRTHD,1,4)))
# MES
sort(unique(substr(dat$BIRTHD,5,6)))
# D�A
sort(unique(substr(dat$BIRTHD,7,8)))

# DISTRIBUCI�N DEL A�O DE NACIMIENTO
barplot(table(substr(dat$BIRTHD,1,4)), las=2, cex.axis = 0.8, cex.names = 0.6)

# COMPRUEBE LA FECHA DEL DIAGN�STICO

# A�O
sort(unique(substr(dat$INCID,1,4)))
# MES
sort(unique(substr(dat$INCID,5,6)))
# D�A
sort(unique(substr(dat$INCID,7,8)))

# DISTRIBUCI�N DEL A�O DE DIAGN�STICO
barplot(table(substr(dat$INCID,1,4)), las=2, cex.axis = 0.8, cex.names = 0.7)

# COMPARAR LA EDAD CON LA FECHA DEL DIAGN�STICO - FECHA DE NACIMIENTO
dat$YEARc = as.Date(paste(as.character(dat$YEAR),"0715",sep=""), format='%Y%m%d')
age = with(dat, (YEARc - BIRTH_DATE) / 365.25)
class(age)
attr(age,'units') = 'years'
head(age)
check = dat[!is.na(age) & abs(dat$AGE - age) > 2,]
check$warning = "Age, Date of Birth and Date of Diagnosis not consistent"

# EXPORTACI�N DE UN INFORME DE VERIFICACI�N
write.table(check, paste(dat$REGISTRY_LAB[1],"_informeverificacion.txt",sep=""), row.names=FALSE, sep="\t")


###################################
# ------ AGREGAR LOS DATOS -------
###################################

# INICIALIZACI�N DE LA AGRUPACI�N
dat$CASES = 1

# AGREGADO POR SEXO, GRUPO DE EDAD Y A�O
datag = aggregate(CASES ~ SEX+AGEGRP+YEAR+CANCER_LAB+REGISTRY_LAB,data=dat,sum)

sum(datag$CASES)


####################################
# ------ MEZCLA CON OTROS DATOS ----
####################################

## Fuente: DATOS DE LA POBLACI�N DE C�NCER DE VIDA REAL ARTIFICIAL, SOLAMENTE PARA EL A�O 2007

# IMPORTAR LOS DATOS DE POBLACI�N
pop = read.table(file="EJEMPLO_3-pob2007.txt", header=TRUE, sep="\t")

# COMPROBAR LA POBLACI�N TOTAL POR SEXO
as.table(by(pop$pop, pop$sex, sum))

# SUBSETE LOS DATOS DEL REGISTRO DE C�NCER DE 2007
datag.2007 = datag[datag$YEAR == 2007,]

# FUNDA LOS DOS CONJUNTOS DE DATOS
datag.pop = merge(x=datag.2007, y=pop, by.x=c("SEX", "AGEGRP"), by.y=c("sex", "age"))


###############################################
# ------ EXPORTAR LOS DATOS RESULTANTES -------
###############################################

# EN R AMBIENTE
save(datag, file="miarchivo.Rdata") # Luego utilizar load('myfile.Rdata') para recuperarlo m�s tarde

# COMO ARCHIVO DE TEXTO DELIMITADO DE LA TABLA
write.table(datag, "miarchivo.txt") # Entonces utilizar dat = read.table('miarchivo.txt') para recuperarlo m�s tarde


