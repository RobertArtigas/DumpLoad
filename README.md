## Development
IF you want me to continue improving this code generator, THEN e-mail me that you are using it. 
 It might be useful to include your use case scenario and a description of why you want this 
 improvement and how it helps the business you are involved in working.

SI desea que continúe mejorando este generador de código, ENTONCES envíeme un correo electrónico que lo está utilizando. 
 Puede ser útil incluir el escenario de su caso de uso y una descripción de por qué desea esta mejora
 y cómo ayuda a la empresa en la que está involucrado.
 
# DumpLoad: Backup Code Generator (Generador código de reserva)

The **DUMPLOAD** template will take all your ISAM tables and EXPORT them as CSV comma delimited files.
 This template will also IMPORT them and restore your table with previous data. This will give you
 and additional way of saving data for backup and restore purposes in a TEXT like format.

The EXTENSION template generates all the procedure code automagically for each table into sequencialy numbered CLW modules.
 It will then add one more module that puts everything together.

IF you have one hundred tables, THEN your will generate one hundred and one CLW modules.
 
You will have to call he procedures to be able to use them.  The standard that I tend to use, is to call the _Dump_ and _Load_ from the main menu at a point where the files have not be oppened.

The **DUMPLOAD** template will also have registered additional TEMPLATES that will: 1) Dump all tables, 2) Load all tables, 3) Dump selected tables, 4) Load selected tables.

### Conversion of DATA from ISAM to SQL task
Where this utility can become even more handy, is when you are doing the DATA conversions from ISAM to the SQL.
 The [**DCT2SQL**](https://github.com/RobertArtigas/DCT2SQL) SQL DDL code generator templates do not handle conversion of the data in your ISAM files.
 The additional task where you have to create procedures to output all your table's data as a CSV file is done by this **DUMPLOAD** code generator.
 You will still have to create the SQL server table LOAD query script. That is dependent on your SQL
 server and you will have to build that QUERY yourself.

## Template Generation 
There is an additonal template that will generate CODE and CONTROL templates for all the tables. 
 Just select the options on this generating template to generete the templates you want.


There is a TEMPLATE that generate additional TEMPLATE's for each table. You should only have to generate this resulting template once.

Once you register the generated resulting template, you should have two CODE (Dump,Load) templates and two CONTROL (Dump,Load) templates for each table.
 Please, use a bit of caution and judgement with the automatic template generation. 
 
IF you have one hundred tables, THEN you will generate four hundred and four templates.

Please be kind to your Template Registry and think about the size of it.

## Webinars explaining how to use the DumpLoad templates

ClarionLive: 595 : Jan 22, 2021 : https://www.youtube.com/watch?v=fAH3LsPadyg&feature=youtu.be

Clarioneros: 178 : 2021-01-23 : https://clarionlive.com/clarioneros.htm (**OneDrive** link)




[Code](https://github.com/RobertArtigas/DumpLoad) 
[Wiki](https://github.com/RobertArtigas/DumpLoad/wiki) 
[Main](https://github.com/RobertArtigas) 
[Repositories](https://github.com/RobertArtigas?tab=repositories)

 