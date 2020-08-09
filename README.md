## Development
IF you want me to continue improving this code generator, THEN send me an e-mail that you are using it.
 It might be useful to include your use case scenario and a description of why you want this improvement and how it helps the business you are involved in working.
 
# DumpLoad
This EXTENSION template will take all your ISAM tables and Export them as CSV comma delimited files.
 The EXTENSION template will also IMPORT them and restore your table with previous data. This will give you
 and additional way of saving data for backup and restore purposes in a TEXT like format.
 The EXTENSION template generates all the procedure code automagically.
 You will have to call the procedures to be able to use them. And that is just a menu item call.

Where this utility can become even more handy, is when you are doing conversions from ISAM to SQL.
 Please note the DCT2SQL templates do not handle conversion of the data in your ISAM files.
 The part where you have to create procedures to output all your table's data as a CSV file is done by this code generator.
 You will still have to create the SQL backend table LOAD query script. That is dependent on your SQL
 backend and you will have to build that QUERY.
