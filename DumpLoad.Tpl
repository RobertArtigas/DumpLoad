#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#! File:        DumpLoad.Tpl
#! Purpose:     Dump and Load Files Generically
#! Owner:       1997.07.27 - Roberto Artigas Jr
#! Author:      1999.07.27 - Roberto Artigas Jr
#!              Copyright © 1999-2999 by Roberto Artigas Jr
#!              All Rights Reserved World Wide
#! Definition:  Michael Gorman - TopSpeed.Topic.Third_Party
#! Interfaces:  File Manager interface developed as a contract
#!              employee for Michael Gorman. No payment received.
#!---------------------------------------------------------------------
#!      NOTE: Need to think about better handling of GLO:FileName.
#!---------------------------------------------------------------------
#! Changes:
#! 2020.08.08 - Roberto Artigas
#!  *   Changed email address literal. Start rework of the template structure.
#! 2008.01.23 - Roberto Artigas
#!  *   Changed email address literal. Change default date and time mask.
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#! 2002.06.22 - Roberto Artigas Jr.
#!  *   Replaced the 'raDumpCRLF' and 'raLoadCRLF'. Needed logic upgrade.
#!      Passes parameters now. First parameter is the dump/load routine name.
#!      Will allow me to improve debugging areas if I need to later.
#! 2002.06.19 - Roberto Artigas Jr.
#!  *   Improved the debugging dumpload.log generation just a tiny bit.
#!      Now a bit easier to spot when a %FileName is in the incorrect format.
#!      This normally happens when new files are added to the dictionary and
#!      the RAEIFILE(NO) does not get added to a file that has to be excluded.
#! 2001.09.07 - Roberto Artigas Jr. 
#!  *   Changed module name generation to avoid duplicates at 8.3 time.
#!      It seems that the gererator/compiler gets confused and forgets.
#! 2001.08.30 - Roberto Artigas Jr.
#!  *   Changed the hidden variables box to before the sheet.
#!  *   Change the 'DumpLoad.Log' to include a sequence number for the files.
#! 2001.01.28 - Roberto Artigas Jr.
#!  *   Added #CONTROL (button) template generation for each file and ALL files.
#!  *   Added #CONTROL (button) template generation for generic routines.
#!  *   Reworked group template to have all the groups globaly available.
#!  *   Added #CODE (embed) template generation to groups.
#!  *   Added #CONTROL (button) template generation to groups.
#!  *   Comented out general procedure options (more testing required).
#! 2001.01.26 - Roberto Artigas Jr.
#!  *   Added #CONTROL (button) generic template as programmer example.
#! 2001.01.23 - Roberto Artigas Jr.
#!  *   Added #CODE (embed) template generation for each file and ALL files.
#! 2001.01.18 - Roberto Artigas Jr.
#!  *   Code consolidation and template cleanup.
#!  *   Additional 'FileDriver' types excluded from processing.
#! 2001.01.14 - Roberto Artigas Jr.
#!  *   Increased number of groups per file from 5 to 10.
#! 2001.01.13 - Roberto Artigas Jr
#!  *   Added group options template.
#!  *   Corrected EXTRACT of options when more than one option.
#! 2000.03.03 - Roberto Artigas Jr
#!  *   Detect posible bad file structure on import.
#! 2000.02.21 - Roberto Artigas Jr
#!  *   Add array variable support. 1 -> 4 dimensions.
#!  *   Cleaned up the TPS multi-file support.
#!---------------------------------------------------------------------
#! Copyright © 1999-2999 by Roberto Artigas Jr.
#! All Rights Reserved World Wide
#!---------------------------------------------------------------------
#TEMPLATE(zDumpLoad, '2002.06.22: Dump and Load Tables'),FAMILY('CW20','ABC')
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#EXTENSION(zDumpLoad,'2002.06.22: DumpLoad Procedure Generator'),APPLICATION
#!---------------------------------------------------------------------
#PREPARE
#ENDPREPARE
#!---------------------------------------------------------------------
#BOXED('Hidden Variables'),HIDE
  #PROMPT('Debug? ',CHECK),%TheDebug,DEFAULT(0)
  #PROMPT('This Count: ',@N3),%ThisCount,DEFAULT(0)
  #PROMPT('File Count: ',@N3),%FileCount,DEFAULT(0)
  #PROMPT('Pass Count: ',@N3),%PassCount,DEFAULT(0)
  #PROMPT('Proc Count: ',@N3),%ProcCount,DEFAULT(0)
  #BUTTON('Processed Files'),MULTI(%DoTheseFiles,%DoThisFile & ' ' & %DoThisDesc & ' ' & %DoThisText),INLINE
    #PROMPT('File Name: ',@s30),%DoThisFile,REQ
    #PROMPT('File Desc: ',@s30),%DoThisDesc,REQ
    #PROMPT('File Text: ',@s30),%DoThisText,REQ
  #ENDBUTTON
  #PROMPT('This Driver: ',@S30),%ThisDriver
  #PROMPT('User Option: ',@S30),%UserOpt
  #PROMPT('File Option: ',@S30),%FileOpt
  #PROMPT('Locate Begin: ',@N3),%LocB
  #PROMPT('Locate End: ',@N3),%LocE
  #PROMPT('Last Field Id: ',@S60),%lowerFieldId
#ENDBOXED
#!---------------------------------------------------------------------
#INSERT(%PreambleDUMPLOAD)
#SHEET,HSCROLL
#INSERT(%MITLicenseDUMPLOAD)
#INSERT(%ExplainUtilDUMPLOAD)
#INSERT(%ShowExplainUtilDUMPLOAD)
#TAB ('DUMPLOAD'),PROP(PROP:FontStyle,700)
#BOXED('')
  #!DISPLAY('Copyright © 1999-2999 by Roberto Artigas Jr.')
  #!DISPLAY('All Rights Reserved World Wide')
  #!DISPLAY('')
  #!DISPLAY('I can be reached at: roberto.artigas.dev@gmail.com')
  #!DISPLAY('')
  #DISPLAY('This template looks at your dictionary and automagically')
  #DISPLAY('creates all the routines and modules to export/import')
  #DISPLAY('each data table to Comma Delimited (CSV-BASIC) File.')
  #DISPLAY('')
  #DISPLAY('Output will have double quotes around each column.')
  #DISPLAY('Routines will handle embeded CR,LF pairs in MEMOs.')
  #DISPLAY('')
  #DISPLAY('CONSTRAINTS:'),PROP(PROP:FontStyle,700)
  #DISPLAY('1) CREATE must be ON for ALL export/import files.')
  #DISPLAY('2) Files drivers excluded: ASCII, BASIC, DOS.')
  #DISPLAY('3) BLOB''s are NOT supported in any way.')
  #DISPLAY('4) Arrays ARE supported. Be carefull! See Tab: Arrays')
  #DISPLAY('5) File names (in file path) MUST HAVE an extension.')
  #DISPLAY('6) Mutiple-Files format is: RealFile.Tps\!FileName.')
  #DISPLAY('7) Tested on the following drivers:')
  #DISPLAY('TPS, BTRIEVE.')
  #!DISPLAY('Any other drivers you will have to contact me before')
  #!DISPLAY('purchasing this template.')
  #DISPLAY('Any other drivers you will have to work on it yourself')
  #DISPLAY('and figure out how to do the template code.')
  #DISPLAY('')
#ENDBOXED
#ENDTAB
#TAB ('Connection')
#BOXED('')
  #DISPLAY('COMPLETE EXPORT/IMPORT:'),PROP(PROP:FontStyle,700)
  #DISPLAY('The main module will contain two main procedures:')
  #DISPLAY('1) raDumpAll - Procedure for export of all tables.')
  #DISPLAY('2) raLoadAll - Procedure for import of all tables.')
  #DISPLAY('These are the routines you call from a menu item')
  #DISPLAY('(or some other place) to export/import all tables.')
  #DISPLAY('')
  #DISPLAY('INDIVIDUAL EXPORT/IMPORT:'),PROP(PROP:FontStyle,700)
  #DISPLAY('Each table module will contain the export and import')
  #DISPLAY('procedure for that particular table. This allows you')
  #DISPLAY('the capability to export/import individual files.')
  #DISPLAY('The names for the table import/export procedures are')
  #DISPLAY('generated partly from the table name. Look inside the')
  #DISPLAY('created table module for the specific names.')
  #DISPLAY('1) raDOne[%File] - Procedure for single table export.')
  #DISPLAY('2) raLOne[%File] - Procedure for single table import.')
  #DISPLAY('Where ''[%File]'' is the name of the file that you are')
  #DISPLAY('attempting for Export/Import.')
  #DISPLAY('')
  #DISPLAY('ALL PROCEDURES:'),PROP(PROP:FontStyle,700)
  #DISPLAY('Will return a value =0 if processing finished OKAY.')
  #DISPLAY('Any value returned >0 means there where errors.')
  #DISPLAY('')
#ENDBOXED
#ENDTAB
#TAB ('Options')
#BOXED('')
  #PROMPT('Select CSV Location?',CHECK),%optLocate,DEFAULT(1),AT(10)
  #DISPLAY('ON: Select CSV Files Location. OFF: No Selection.')
  #DISPLAY('')
  #PROMPT('Error Messages?',CHECK),%optError,DEFAULT(1),AT(10)
  #DISPLAY('ON: Show Errors. OFF: Silent.')
  #DISPLAY('')
  #PROMPT('File Count Messages?',CHECK),%optCount,DEFAULT(1),AT(10)
  #DISPLAY('ON: Show File Count Messages. OFF: Silent.')
  #DISPLAY('')
  #PROMPT('Data Name Areas?',CHECK),%optFileGlo,DEFAULT(0),AT(10)
  #DISPLAY('ON: Create Global File Name Area. OFF: No Create.')
  #DISPLAY('')
  #PROMPT('Warn on Bad Names?',CHECK),%optBadName,DEFAULT(0),AT(10)
  #DISPLAY('ON: Warn On Bad File Mames. OFF: No Warnings.')
  #DISPLAY('')
  #PROMPT('File Headers?',CHECK),%optHeader,DEFAULT(0),AT(10)
  #DISPLAY('ON: Output First Line Header. OFF: No Header.')
  #DISPLAY('')
#ENDBOXED
#ENDTAB
#TAB ('Parameters')
#BOXED('')
  #PROMPT('CSV Location:',@S250),%optWhere,REQ,DEFAULT('.\')
  #DISPLAY('Default location for CSV files. Must have trailing ''\''.')
  #DISPLAY('')
  #PROMPT('File Extension:',@S10),%optExt,REQ,DEFAULT('TPB')
  #DISPLAY('Extension for the CSV files.')
  #DISPLAY('')
  #PROMPT('File Buffers:',@S10),%optBuf,REQ,DEFAULT('10')
  #DISPLAY('File Buffers is used to speed up processing.')
  #DISPLAY('')
  #PROMPT('Date Format:',@S10),%optDate,REQ,DEFAULT('@D010-B')
  #PROMPT('Time Format:',@S10),%optTime,REQ,DEFAULT('@T04B')
  #DISPLAY('Date/Time formats used by FORMAT/DEFORMAT.')
  #DISPLAY('')
  #PROMPT('(CR,LF) Marker:',@S10),%optCRLF,REQ,DEFAULT('$@$@')
  #DISPLAY('(CR,LF) Marker is used for MEMO translations.')
  #DISPLAY('')
  #!PROMPT('(Max * 2) Binary:',@S10),%optBin,REQ,DEFAULT('1024')
#ENDBOXED
#ENDTAB
#TAB ('Interfaces')
  #BOXED('Interface for File Manager')
    #DISPLAY('')
    #DISPLAY('Use simple path management when you want all of')
    #DISPLAY('your data files in one subdirectory, controlled by one')
    #DISPLAY('field or variable.')
    #DISPLAY('')
    #DISPLAY('Enter a field name or variable below that will contain')
    #DISPLAY('your directory path. When you set the variable, it')
    #DISPLAY('should not contain any ''\'' marks at the beginning or')
    #DISPLAY('the end of the variable.')
    #DISPLAY('')
    #PROMPT('Enable Simple Path Management',CHECK),%IntFM,AT(10,,170),DEFAULT(0)
    #ENABLE(%IntFM)
      #PROMPT('Path Field/Var:',@S250),%IntFMspv,REQ,DEFAULT('g:paths')
    #ENDENABLE
    #DISPLAY('')
    #DISPLAY('PATH MANAGER IS AVAILABLE FROM:'),PROP(PROP:FontStyle,700)
    #DISPLAY('POSitive Software Company')
    #DISPLAY('www.pointofsale.com/developer')
    #DISPLAY('e-mail: timesavers@pointofsale.com')
    #DISPLAY('')
  #ENDBOXED
#ENDTAB
#TAB ('Export')
#BOXED('')
  #PROMPT('Remove and Create?',CHECK),%expClear,DEFAULT(1),AT(10)
  #DISPLAY('ON: Remove destination export file and create new.')
  #DISPLAY('OFF: Append output records to destination export file.')
  #DISPLAY('')
  #DISPLAY('*** EXTREME WARNING ***'),PROP(PROP:FontStyle,700)
  #DISPLAY('If you set the above option to OFF, you have better')
  #DISPLAY('be sure of what you are doing. Appending duplicate')
  #DISPLAY('records to an export file can make it unusable.')
  #DISPLAY('*** EXTREME WARNING ***'),PROP(PROP:FontStyle,700)
#ENDBOXED
#ENDTAB
#TAB ('Import')
#BOXED('')
  #PROMPT('Remove and Create?',CHECK),%impClear,DEFAULT(1),AT(10)
  #DISPLAY('ON: Remove destination import file and create new.')
  #DISPLAY('OFF: Append input records to destination import file.')
  #DISPLAY('')
  #DISPLAY('*** EXTREME WARNING ***'),PROP(PROP:FontStyle,700)
  #DISPLAY('If you set the above option to OFF, you have better')
  #DISPLAY('be sure of what you are doing. Appending duplicate')
  #DISPLAY('records to an import file can make it unusable.')
  #DISPLAY('*** EXTREME WARNING ***'),PROP(PROP:FontStyle,700)
  #DISPLAY('')
  #DISPLAY('')
  #PROMPT('Check Import Structure?',CHECK),%impCheck,DEFAULT(0),AT(10)
  #DISPLAY('ON: Check import structure against known facts.')
  #DISPLAY('OFF: No structure checking of import file.')
  #DISPLAY('')
  #DISPLAY('*** EXTREME WARNING ***'),PROP(PROP:FontStyle,700)
  #DISPLAY('If you set the above option to ON, you have better')
  #DISPLAY('be sure of what you are doing. If one of structures')
  #DISPLAY('is BAD, the whole restore might be unusable, since')
  #DISPLAY('the destination data file will NOT be cleared of any')
  #DISPLAY('data and this will cause a MISMATCHED data set.')
  #DISPLAY('*** EXTREME WARNING ***'),PROP(PROP:FontStyle,700)
#ENDBOXED
#ENDTAB
#TAB ('Duplicates')
#BOXED('')
  #PROMPT('Duplicate Key Trace?',CHECK),%impDupKey,DEFAULT(1),AT(10)
  #DISPLAY('ON: Additional trace while importing files.')
  #DISPLAY('OFF: No additional trace while importing files.')
  #DISPLAY('')
  #DISPLAY('If you get duplicate records importing an exported')
  #DISPLAY('file, that means the duplicate key was set originally')
  #DISPLAY('to duplicates allowed, and somewhere along the line')
  #DISPLAY('it got set to unique. This option ON gives you trace')
  #DISPLAY('information to track down the problem.')
  #DISPLAY('')
  #DISPLAY('This option is the most usefull when developing your')
  #DISPLAY('original files and you are deciding on the keys.')
  #DISPLAY('')
#ENDBOXED
#ENDTAB
#TAB ('Properties')
#BOXED('')
  #DISPLAY('All property options start with "RAEI".')
  #DISPLAY('This stands for: Roberto Artigas Export Import.')
  #DISPLAY('This prefix is unique enough that it should not')
  #DISPLAY('conflict with option keywords from other vendors.')
  #DISPLAY('')
  #DISPLAY('In the Table|Properties|Option Tab you can enter')
  #DISPLAY('the keyword "RAEIFILE()". See Tab: Table.')
  #DISPLAY('')
  #DISPLAY('In the Column|Properties|Option Tab you can enter')
  #DISPLAY('the keyword "RAEIDATA()". See Tab: Column.')
#ENDBOXED
#ENDTAB
#TAB ('Table')
#BOXED('')
  #DISPLAY('Table (File) property option explanations:')
  #DISPLAY('')
  #DISPLAY('1) RAEIFILE(NO) - Does NOT output this table.')
  #DISPLAY('')
  #DISPLAY('The most common use for this property is to overide')
  #DISPLAY('files from dumping/loading their contents.')
  #DISPLAY('')
  #DISPLAY('')
  #DISPLAY('AUTOMATICALLY EXCLUDED ARE:'),PROP(PROP:FontStyle,700)
  #DISPLAY('Table Types: ALIAS, VIEW')
  #DISPLAY('Driver Types: DOS, ASCII, BASIC.')
  #DISPLAY('')
#ENDBOXED
#ENDTAB
#TAB ('Column')
#BOXED('')
  #DISPLAY('Column (Field) property option explanations:')
  #DISPLAY('')
  #DISPLAY('1) RAEIDATA(NO,) - Does NOT output this column.')
  #DISPLAY('')
  #DISPLAY('2) RAEIDATA(,DATE) - Overides type for this column.')
  #DISPLAY('An example of use for this property is to overide')
  #DISPLAY('the type LONG with DATE and TIME.')
  #DISPLAY('')
  #DISPLAY('')
  #DISPLAY('AUTOMATIC FIELD TYPE GENERATION:'),PROP(PROP:FontStyle,700)
  #DISPLAY('DATE and TIME are automatically detected and set if')
  #DISPLAY('the %FieldRecordPicture or the %FieldDisplayPicture')
  #DISPLAY('contains a @D (for DATE) or a @T (for TIME).')
  #DISPLAY('')
#ENDBOXED
#ENDTAB
#TAB ('Arrays')
#BOXED('')
  #DISPLAY('Arrays within tables is denormalized data, and while in')
  #DISPLAY('some cases you can not avoid this due to performance')
  #DISPLAY('reasons, use of arrays in tables should be mininimized.')
  #DISPLAY('')
  #DISPLAY('Normally, a GROUP is defined to get individual items.')
  #DISPLAY('Then a single item array is defined OVER() the GROUP')
  #DISPLAY('to get indexing into the individual items.')
  #DISPLAY('')
  #DISPLAY('Export/Import the individual GROUP items.')
  #DISPLAY('Use a "RAEIDATA(NO)" on the array item.')
  #DISPLAY('')
  #DISPLAY('')
  #DISPLAY('If you use plain arrays, they are handled correctly.')
  #DISPLAY('')
  #DISPLAY('Arrays of 1 to 4 dimensions can be exported. Exporting')
  #DISPLAY('arrays will create lots of fields so please check the code')
  #DISPLAY('generated to make absolutely sure that, what you are')
  #DISPLAY('expecting to happen, is actually happening.')
  #DISPLAY('')
#ENDBOXED
#ENDTAB
#TAB ('Acknowledgements')
#BOXED('')
  #DISPLAY('I would like to acknowledge the following individuals:')
  #DISPLAY('')
  #DISPLAY('Michael M. Gorman at Whitemarsh Information Systems')
  #DISPLAY('Corp. (www.wiscorp.com) for the original request that')
  #DISPLAY('got me started writing this template. And for the help')
  #DISPLAY('creating and testing of a very usefull tool.')
  #DISPLAY('')
  #DISPLAY('Bruce Johnson at Capesoft cc. (www.capesoft.com)')
  #DISPLAY('for the additional help in testing and the sugestions')
  #DISPLAY('in getting this template to the public.')
  #DISPLAY('')
  #DISPLAY('The individuals that provided all the dictionaries and')
  #DISPLAY('testing scenarios. Too many of you to mention all.')
  #DISPLAY('')
  #DISPLAY('Thank you.')
  #DISPLAY('Roberto Artigas Jr.')
#ENDBOXED
#ENDTAB
#ENDSHEET
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#ATSTART
#FIX(%Driver,'BASIC')                                       #! Going to need this
#PROJECT(%DriverLib)                                        #! Add driver to project
#FIX(%Driver,'ASCII')                                       #! Going to need this
#PROJECT(%DriverLib)                                        #! Add driver to project
#!--------------------------------------------------------------------!
#! 2001.01.18.THU - Roberto Artigas Jr - Part of code consolidation.  !
#!--------------------------------------------------------------------!
#! Logic that sees if the file is valid for processing was used in    !
#! almost every #FOR(%File) loop. I decided to speed up processing by !
#! preprocessing and creating a list of valid files at the beginning  !
#! of the template. This also minimizes template maintenance if the   !
#! criteria for a valid file changes. All in one place. Right here.   !
#!--------------------------------------------------------------------!
#IF(%TheDebug)
  #REMOVE('DumpLoad.Log')
  #CREATE('DumpLoad.Log')
  #SET(%PassCount, 0)
#ENDIF
#FREE(%DoTheseFiles)                                        #! Clear previous table
#SET(%ThisCount, 0)                                         #! Items so added so far
#FOR(%File)
#IF(%TheDebug)
  File: %File(%FileName), CREATE(%FileCreate), %FileType, %FileDriver, %FileUserOptions
#ENDIF
  #!--------------------------------------------------------------------!
  #IF(NOT %FileCreate)                                      #! Create attribute?
    #CYCLE                                                  #! No. Can't restore
  #ENDIF                                                    #! so do not use
  #!--------------------------------------------------------------------!
  #CASE(%FileType)                                          #! Real physical File?
    #OF('VIEW')                                             #! Not this one
  #OROF('ALIAS')                                            #! Not this one
    #CYCLE                                                  #! Imaginary files
  #ENDCASE                                                  #! are not used
  #!--------------------------------------------------------------------!
  #! File drivers tested so far by some production environment:         !
  #! CLARION, TOPSPEED, BTRIEVE                                         !
  #!--------------------------------------------------------------------!
  #! Things marked 'not tested' should work, but are not tested.        !
  #! Things marked 'ODBC' or 'SQL' should not work. Totally different.  !
  #!--------------------------------------------------------------------!
  #SET(%ThisDriver,UPPER(%FileDriver))                      #! Making sure for compare
  #CASE(%ThisDriver)                                        #! Backup type file?
    #OF('ASCII')                                            #! Not this one
  #OROF('BASIC')                                            #! Not this one
  #OROF('DOS')                                              #! Not this one
  #OROF('CLIPPER')                                          #! RAS.2001.01.18 - Not tested
  #OROF('DBASE3')                                           #! RAS.2001.01.18 - Not tested
  #OROF('DBASE4')                                           #! RAS.2001.01.18 - Not tested
  #OROF('FOXPRO')                                           #! RAS.2001.01.18 - Not tested
  #OROF('ODBC')                                             #! RAS.2001.01.18 - ODBC?
  #OROF('MSSQL')                                            #! RAS.2001.01.18 - SQL?
  #OROF('SCALABLE')                                         #! RAS.2001.01.18 - SQL?
  #OROF('SQLANYWHERE')                                      #! RAS.2001.01.18 - SQL?
    #CYCLE                                                  #! File driver not valid
  #ENDCASE                                                  #! Do not use this one
  #!--------------------------------------------------------------------!
  #IF(NOT ITEMS(%Field))                                    #! Fields found? No!
    #CYCLE                                                  #! Someone stubed in a
  #ENDIF                                                    #! file for future use
  #!--------------------------------------------------------------------!
  #SET(%LocB,INSTRING('RAEIFILE(',%FileUserOptions,1,1))    #! Get option begin
  #SET(%LocE,INSTRING(')',%FileUserOptions,1,%LocB))        #! Get option end
  #SET(%UserOpt,UPPER(SUB(%FileUserOptions,%LocB,%LocE)))   #! Specific File User Option
  #!SET(%UserOpt,EXTRACT(%FileUserOptions,'RAEIFILE'))       ! First line only (???)
  #SET(%FileOpt,EXTRACT(%UserOpt,'RAEIFILE',1))             #! Get 1st parameter
  #IF(%FileOpt='NO')                                        #! Process this file?
    #CYCLE                                                  #! Not this one
  #ENDIF                                                    #! User can choose
  #!--------------------------------------------------------------------!
#IF(%TheDebug)
  #SET(%PassCount,%PassCount+1)
  PassFile(%PassCount): %File
#ENDIF
  #SET(%ThisCount,%ThisCount+1)                             #! Count next item
  #ADD(%DoTheseFiles,%ThisCount)                            #! Create list item
  #SET(%DoThisFile,%File)                                   #! Set the item found
  #SET(%DoThisDesc,%FileDescription)                        #! RAS.2001.01.23
  #SET(%DoThisText,%FileLongDesc)                           #! RAS.2001.01.23
#ENDFOR
#IF(%TheDebug)

  #FOR(%DoTheseFiles)
  FileProc(%DoTheseFiles): %DoThisFile
  #ENDFOR

  #SET(%FileCount,ITEMS(%File))
  #SET(%ProcCount,ITEMS(%DoTheseFiles))
  FILECOUNT = %FileCount
  PASSCOUNT = %PassCount
  PROCCOUNT = %ProcCount
  #CLOSE ('DumpLoad.Log')
  #ERROR('Dumpload.Log is generated!')
#ENDIF
#ENDAT
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#ATEND
#ENDAT
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#AT(%CustomGlobalDeclarations)
#DECLARE (%RaFileDo00, STRING)
#DECLARE (%RaFileName, STRING)
#DECLARE (%RaClipName, STRING)
#DECLARE (%RaWorkName, STRING)
#!
#DECLARE (%WorkExt,    STRING)
#DECLARE (%FldOpt,     STRING)
#DECLARE (%FldType,    STRING)
#DECLARE (%FldLength,  LONG)
#DECLARE (%WrkLength,  LONG)
#!
#DECLARE (%FldCount,   LONG)
#DECLARE (%FldArray,   STRING)
#DECLARE (%FD1S,       STRING)
#DECLARE (%FD2S,       STRING)
#DECLARE (%FD3S,       STRING)
#DECLARE (%FD4S,       STRING)
#DECLARE (%FD1I,       LONG)
#DECLARE (%FD2I,       LONG)
#DECLARE (%FD3I,       LONG)
#DECLARE (%FD4I,       LONG)
#DECLARE (%FD1L,       LONG)
#DECLARE (%FD2L,       LONG)
#DECLARE (%FD3L,       LONG)
#DECLARE (%FD4L,       LONG)
#!
#SET (%RaClipName, SUB(%Application, 1, 5))
#SET (%RaFileDo00, %RaClipName & '_EI.clw')
#SET (%RaWorkName, %RaClipName & '_EI.$$$')
#MESSAGE('Building Export/Import Modules', 1)
#MESSAGE('Creating: ' & %RaFileDo00,2)
#PROJECT (%RaFileDo00)
#CREATE(%RaWorkName)
!BOF
!---------------------------------------------------------------------
!---------------------------------------------------------------------
! File:         %RaFileName
! Purpose:      Dump and Load Files
! Creator:      1999.07.27 - Roberto Artigas
! Copyright:    1999-2999 (c) by Roberto Artigas Jr
!               All Rights Reserved World Wide
!---------------------------------------------------------------------
  MEMBER('%Application.clw')

!
! Procedure:    raCountChar
! Purpose:      Count specific character in line
! Author:       2000.03.04 - Roberto Artigas Jr
raCountChar     PROCEDURE(strChar, strLine)
lngRc           LONG(0)
lngPos          LONG(0)
  CODE
  lngRc         = 0
  lngPos        = INSTRING(strChar, strLine, 1, 1)
  LOOP WHILE(lngPos)
    lngRc      += 1
    lngPos     += 1
    lngPos      = INSTRING(strChar, strLine, 1, lngPos)
  END
  RETURN(lngRc)

!
! Procedure:    raFileDrv2Ext
! Purpose:      Given Driver return Extension
! Author:       2000.01.17 - Roberto Artigas Jr
!
raFileDrv2Ext   PROCEDURE(xDriver)
  CODE
  CASE(UPPER(SUB(xDriver,1,3)))
  OF   'BTR' #<! Btrieve
  OROF 'CLA' #<! Clarion
    RETURN('.DAT')
  OF   'TOP' #<! Topspeed
    RETURN('.TPS')
  END
  RETURN('')

!
! Procedure:    raFileClean
! Purpose:      Clean File Name
! Author:       2000.01.12 - Roberto Artigas Jr
! NOTE:         Embeded tables (many files) within a file gives a bad count
!               for the files in the warning messages. However, the files
!               export and import correctly. While I could fake it and give
!               a correct count I rather leave the inconsistency in.
!               Do not have a solution at this time. Will see what happens.
!               2000.02.26 - Roberto Artigas Jr
!               Got some sugestions from Maarten Veenstra (Holand)
!
raFileClean     PROCEDURE(xFileName)
lngPos          LONG(0)
FileInp         STRING(256)
FileOut         STRING(256)
#IF(%optBadName)
strMsg          STRING(256)
#ENDIF
  CODE
  FileInp       = xFileName
  lngPos        = INSTRING('\!', FileInp, 1, 1)
  IF (lngPos) THEN
   !FileOut     = SUB(FileInp,(lngPos+2),(LEN(FileInp)-(lngPos+2)))
    FileOut     = SUB(FileInp,1,(lngPos-1)) #<! First part is real file
    lngPos      = INSTRING('.', FileOut, 1, 1) #<! Check for extension
    IF (~lngPos) THEN #<! No extension found
      FileOut   = CLIP(FileOut) & '.TPS' #<! Multi-files are TopSpeed
    END #<! Done
  ELSE
    FileOut     = FileInp
  END
#IF(%optBadName)
  !
  ! RAS.2000.02.26 - Eliminated Embeded message.
  ! --------------------------------------------
  ! Now checking the first file name for existance. That is the real file.
  ! --------------------------------------------
  !IF (lngPos) THEN
  !  strMsg      = 'WARNING: Embeded File Found.<13,10>Inp=''' & CLIP(FileInp) & '''<13,10>Out=''' & CLIP(FileOut) & ''''
  !  MESSAGE(strMsg, 'File Name: Warning!', ICON:Exclamation)
  !END
  lngPos        = INSTRING('.', FileOut, 1, 1)
  IF (~lngPos) THEN
    strMsg      = 'WARNING: File Extension Missing.<13,10>Inp=''' & CLIP(FileInp) & '''<13,10>Out=''' & CLIP(FileOut) & ''''
    MESSAGE(strMsg, 'File Name: Warning!', ICON:Exclamation)
  END
  IF (FileOut='') THEN
    strMsg      = 'WARNING: Blank File Name.<13,10>Inp=''' & CLIP(FileInp) & '''<13,10>Out=''' & CLIP(FileOut) & ''''
    MESSAGE(strMsg, 'File Name: Warning!', ICON:Exclamation)
  END
#ENDIF
  RETURN(CLIP(FileOut))

!
! Procedure:    raFileExists
! Purpose:      Does File Exist
! Author:       1999.09.03 - Roberto Artigas Jr
!
raFileExists    PROCEDURE (xFileName)
FileName        CSTRING(256)
CheckExist      EQUATE(0)   ! Check for existence
CheckWrite      EQUATE(2)   ! Check for write permission (not used here)
CheckRead       EQUATE(4)   ! Check for read permission (not used here)
CheckRW         EQUATE(6)   ! Check for read/write permission (not used here)
  CODE
  FileName      = raFileClean(xFileName) #<! Check File Names
  #IF(%IntFM)
  FileName      = CLIP(%IntFMspv) & FileName #<! File Manager Interface
  #ENDIF
  !STOP('raFileExists=''' & CLIP(FileName) & '''')
  RETURN(1 + Access(FileName,CheckExist)) #<! Check File Existance

!
! Procedure:    raAscSetDir
! Purpose:      Set the ASC directory
! Author:       2000.01.16 - Roberto Artigas Jr
!
raAscSetDir     PROCEDURE (xTitle)
FinalPath       STRING(256)
  CODE
  FinalPath     = '%OptWhere'
#IF(%optLocate)
  IF (FILEDIALOG(xTitle,FinalPath,,FILE:KeepDir+FILE:Directory)) THEN
    FinalPath   = CLIP(FinalPath) !& '\'
  END
#ENDIF
  RETURN(FinalPath)

!
! Procedure:    raAscSetFile
! Purpose:      Set the ASC file final location
! Author:       2000.01.16 - Roberto Artigas Jr
!
raAscSetFile    PROCEDURE (xFileName)
FinalPath       STRING(256)
  CODE
  FinalPath     = CLIP(GLO:EI_ADir) & xFileName
  RETURN(FinalPath)

!
! Procedure:    raAscExists
! Purpose:      Does *.TPB File Exist
! Author:       2000.01.15 - Roberto Artigas Jr
!
raAscExists     PROCEDURE (xFileName)
FileName        CSTRING(256)
CheckExist      EQUATE(0)   ! Check for existence
CheckWrite      EQUATE(2)   ! Check for write permission (not used here)
CheckRead       EQUATE(4)   ! Check for read permission (not used here)
CheckRW         EQUATE(6)   ! Check for read/write permission (not used here)
  CODE
  FileName      = raAscSetFile(xFileName)
  ! Add the value returned by ACCESS to 1
  ! in order to return TRUE to indicate existence and
  ! FALSE to indicate non-existence.
  ! ie: 1 + (-1) returns FALSE if file not found.
  ! ie: 1 + ( 0) returns TRUE if file is found.
  RETURN(1 + Access(FileName,CheckExist))
#!
#!!
#!! Procedure:    raDumpCRLF
#!! Purpose:      Convert CRLF to Defined Constant (MEMO's)
#!! Author:       1999.08.01 - Roberto Artigas Jr
#!!
#!raDumpCRLF      PROCEDURE(strData)
#!FoundCr         LONG(0)
#!  CODE
#!  FoundCR = INSTRING('<13,10>',strData,1,1)
#!  LOOP WHILE(FoundCR)
#!    IF (FoundCR = 1) THEN
#!      strData  = '%optCRLF' & SUB(strData,3,(LEN(strData)-(FoundCr+1)))
#!    ELSE
#!      strData = SUB(strData,1,(FoundCR-1)) & '%optCRLF' & SUB(strData,(FoundCR+2),(LEN(strData)-(FoundCr+1)))
#!    END
#!    FoundCR = INSTRING('<13,10>',strData,1,1)
#!  END
#!  RETURN
#!
#!!
#!! Procedure:    raLoadCRLF
#!! Purpose:      Convert Defined Constant to CRLF (MEMO's)
#!! Author:       1999.08.01 - Roberto Artigas Jr
#!!
#!raLoadCRLF      PROCEDURE(strData)
#!FoundCr         LONG(0)
#!LenCr           LONG(0)
#!  CODE
#!  LenCr   = LEN(CLIP('%optCRLF'))
#!  FoundCR = INSTRING('%optCRLF',strData,1,1)
#!  LOOP WHILE(FoundCR)
#!    IF (FoundCR = 1) THEN
#!      strData  = '<13,10>' & SUB(strData,LenCr,(LEN(strData)-(FoundCr+LenCr)))
#!    ELSE
#!      strData = SUB(strData,1,(FoundCR-1)) & '<13,10>' & SUB(strData,(FoundCR+LenCr+1),(LEN(strData)-(FoundCr+LenCr)))
#!    END
#!    FoundCR = INSTRING('%optCRLF',strData,1,1)
#!  END
#!  RETURN

!
! Procedure:    raDumpCRLF
! Purpose:      Convert CRLF to Defined Constant (MEMO's)
! Author:       2002.06.22 - Roberto Artigas Jr
!
raDumpCRLF      PROCEDURE(strWhere,optCRLF,strData)
LenCr           LONG(0)
FoundCr         LONG(0)
  CODE
  LenCr         = LEN(CLIP('<13,10>'))
  FoundCR       = INSTRING('<13,10>',strData,1,1)
  LOOP WHILE(FoundCR)
    IF (FoundCR = 1) THEN
      strData   = CLIP(optCRLF) & SUB(strData,3,(LEN(strData)-(FoundCr+1)))
    ELSE
      strData   = SUB(strData,1,(FoundCR-1)) & CLIP(optCRLF) & SUB(strData,(FoundCR+2),(LEN(CLIP(strData))-(FoundCr+1)))
    END
    FoundCR = INSTRING('<13,10>',strData,1,1)
  END
  RETURN

!
! Procedure:    raLoadCRLF
! Purpose:      Convert Defined Constant to CRLF (MEMO's)
! Author:       2002.06.22 - Roberto Artigas Jr
!
raLoadCRLF      PROCEDURE(strWhere,optCRLF,strData)
LenCr           LONG(0)
FoundCr         LONG(0)
  CODE
  LenCr         = LEN(CLIP(optCRLF))
  FoundCR       = INSTRING(CLIP(optCRLF),strData,1,1)
  LOOP WHILE(FoundCR)
    IF (FoundCR = 1) THEN
      strData   = '<13,10>' & SUB(strData,LenCr+1,(LEN(CLIP(strData))-(FoundCr+LenCr-1)))
    ELSE
      strData   = SUB(strData,1,(FoundCR-1)) & '<13,10>' & SUB(strData,(FoundCR+LenCr),(LEN(CLIP(strData))-(FoundCr+LenCr-2)))
    END
    FoundCR     = INSTRING(CLIP(optCRLF),strData,1,1)
  END
  RETURN

!
! Procedure:    raHEXUnpack
! Purpose:  Convert 1 byte binary value to 2 character hex value
! Author:   1999.08.10 - Roberto Artigas Jr
!
raHEXUnpack     PROCEDURE (strDst, byteSrc)
strHex          STRING(2)   ! Return data
  CODE
  strHex        = '00'      ! Initialize return variable
  EXECUTE byteSrc / 16      ! Format high-order nibble from
    strHex[1]   = '1'       ! result of division by 16
    strHex[1]   = '2'
    strHex[1]   = '3'
    strHex[1]   = '4'
    strHex[1]   = '5'
    strHex[1]   = '6'
    strHex[1]   = '7'
    strHex[1]   = '8'
    strHex[1]   = '9'
    strHex[1]   = 'A'
    strHex[1]   = 'B'
    strHex[1]   = 'C'
    strHex[1]   = 'D'
    strHex[1]   = 'E'
    strHex[1]   = 'F'
  END
  EXECUTE byteSrc % 16      ! Format low-order nibble from
    strHex[2]   = '1'       ! the remainder of division by 16
    strHex[2]   = '2'
    strHex[2]   = '3'
    strHex[2]   = '4'
    strHex[2]   = '5'
    strHex[2]   = '6'
    strHex[2]   = '7'
    strHex[2]   = '8'
    strHex[2]   = '9'
    strHex[2]   = 'A'
    strHex[2]   = 'B'
    strHex[2]   = 'C'
    strHex[2]   = 'D'
    strHex[2]   = 'E'
    strHex[2]   = 'F'
  END
  strDst        = strHex
  RETURN

!
! Procedure:    raHEXPack
! Purpose:  Convert 2 character hex value to 1 byte binary value
! Author:   1999.08.10 - Roberto Artigas Jr
!
raHEXPack       PROCEDURE (byteDst, strSrc)
byteVal         BYTE(0)
bytePos         BYTE(0)
  CODE
  LOOP I# = 1 TO 2
    byteVal    *= 16
    bytePos     = INSTRING(UPPER(strSrc[I#]), '123456789ABCDEF', 1, 1)
    byteVal    += bytePos
  END
  byteDst       = byteVal
  RETURN

!
! Procedure:    raDumpHEX
! Purpose:      Convert Binary Data to Hex - BLOB, STRING
! Author:       1999.08.09 - Roberto Artigas JR
!
raDumpHEX       PROCEDURE(strDst, strSrc, lngSrc)
byteData        BYTE(0)
strData         STRING(2)
  CODE
  D# = 1
  LOOP S# = 1 TO lngSrc
    byteData = VAL(strSrc[S#])
    raHEXUnpack(strData, byteData)
    strDst[D#:2] = strData
    D# += 2
  END
  RETURN

!
! Procedure:    raLoadHEX
! Purpose:      Convert Hex to Binary Data - BLOB, STRING
! Author:       1999.08.09 - Roberto Artigas JR
!
raLoadHEX       PROCEDURE(strDst, strSrc, lngSrc)
byteData        BYTE(0)
  CODE
  D# = 1
  LOOP S# = 1 TO lngSrc BY 2
    raHEXPack(byteData, strSrc[S#:2])
    strDst[D#] = CHR(byteData)
    D# += 1
  END
  RETURN

!
! Procedure:    raDumpAll
! Purpose:      Dump All Files in sequence
!
raDumpAll       PROCEDURE
lngRC           LONG(0) #<! Error File Counter
lngExp          LONG(0) #<! Count Export Files
lngImp          LONG(0) #<! Count Import Files
strMsg          STRING(255) #<! Message Body
strTit          STRING(255) #<! Message Title
  CODE
 !GLO:EI_ADir   = raAscSetDir('Select location of %optExt Files to Export')
  GLO:EI_ADir   = raAscSetDir('Select Export-To Directory for %optExt files.')
#IF(%optCount)
  lngExp        = raCountExport() #<! Count Export Files
  lngImp        = raCountImport() #<! Count Import Files
  strTit        = 'About to EXPORT files'  
  strMsg        = 'There are ' & lngImp & ' data base files.<13,10>'
  strMsg        = CLIP(strMsg) & 'There are ' & lngExp & ' back up files.<13,10>'
  IF (lngExp > 0) THEN
    strMsg      = CLIP(strMsg) & '<13,10>You will DESTROY your existing ASCII back up files.<13,10>'
  END
  strMsg        = CLIP(strMsg) & '<13,10>Do you want to continue?'
  CASE MESSAGE(strMsg, strTit, ICON:Question, BUTTON:Yes+BUTTON:No, BUTTON:No, 1)
  OF BUTTON:No
    RETURN(0)
  OF BUTTON:Yes
  END
#ENDIF
#IF (%expClear)

  IF (lngExp > 0) THEN
    strMsg      = 'This is your FINAL warning.<13,10>'
    strMsg      = CLIP(strMsg) & 'You will DESTROY your existing ASCII back up files.<13,10>'
    strMsg      = CLIP(strMsg) & 'You will create NEW back up files.<13,10>'
    strMsg      = CLIP(strMsg) & '<13,10>Do you want to continue?'
    CASE MESSAGE(strMsg, strTit, ICON:Question, BUTTON:Yes+BUTTON:No, BUTTON:No, 1)
    OF BUTTON:No
      RETURN(0)
    OF BUTTON:Yes
    END
  END
#ENDIF

#FOR (%DoTheseFiles)                                        #! RAS.2001.01.18
  #FIND(%File,%DoThisFile)                                  #! RAS.2001.01.18
  lngRc        += raDump%File() #<! %FileDescription
#ENDFOR
  RETURN(lngRc) #<! Return Errors

!
! Procedure:    raLoadAll
! Purpose:      Load All Files in sequence
!
raLoadAll       PROCEDURE
lngRC           LONG(0) #<! Error File Counter
lngExp          LONG(0) #<! Count Export Files
lngImp          LONG(0) #<! Count Import Files
strMsg          STRING(255) #<! Message Body
strTit          STRING(255) #<! Message Title
  CODE
 !GLO:EI_ADir   = raAscSetDir('Select location of %optExt Files to Import')
  GLO:EI_ADir   = raAscSetDir('Select Import-From Directory for %optExt files.')

#IF(%optCount)
  lngExp        = raCountExport() #<! Count Export Files
  lngImp        = raCountImport() #<! Count Import Files
  strTit        = 'About to IMPORT files'  
  strMsg        = 'There are ' & lngImp & ' data base files.<13,10>'
  strMsg        = CLIP(strMsg) & 'There are ' & lngExp & ' back up files.<13,10>'
  strMsg        = CLIP(strMsg) & '<13,10>You will DESTROY your existing data base files.<13,10>'
  strMsg        = CLIP(strMsg) & '<13,10>Do you want to continue?'
  CASE MESSAGE(strMsg, strTit, ICON:Question, BUTTON:Yes+BUTTON:No, BUTTON:No, 1)
  OF BUTTON:No
    RETURN(0)
  OF BUTTON:Yes
  END
#END
#IF (%impClear)

  IF (lngImp > 0) THEN
    strMsg      = 'This is your FINAL warning.<13,10>'
    strMsg      = CLIP(strMsg) & 'You will DESTROY your existing data base files.<13,10>'
    strMsg      = CLIP(strMsg) & 'You will create NEW data base files.<13,10>'
    IF (lngExp = 0) THEN
      strMsg    = CLIP(strMsg) & 'The NEW data base files will be EMPTY.<13,10>'
    END
    strMsg      = CLIP(strMsg) & '<13,10>Do you want to continue?'
    CASE MESSAGE(strMsg, strTit, ICON:Question, BUTTON:Yes+BUTTON:No, BUTTON:No, 1)
    OF BUTTON:No
      RETURN(0)
    OF BUTTON:Yes
    END
  END
#ENDIF

#FOR (%DoTheseFiles)                                        #! RAS.2001.01.18
  #FIND(%File,%DoThisFile)                                  #! RAS.2001.01.18
  lngRc        += raLoad%File() #<! %FileDescription
#ENDFOR
  RETURN(lngRc) #<! Return Errors

!
! Procedure:    raCountExport
! Purpose:      Count Export (ASCII CSV) Files
!
raCountExport   PROCEDURE
lngRC           LONG(0) #<! Error File Counter
  CODE
#FOR (%DoTheseFiles)                                        #! RAS.2001.01.18
  #FIND(%File,%DoThisFile)                                  #! RAS.2001.01.18
  lngRc        += raAscExists('%File.%optExt') #<! %FileDescription
#ENDFOR
  RETURN(lngRc) #<! Return Errors

!
! Procedure:    raCountImport
! Purpose:      Count Import (Data Base) Files
!
raCountImport   PROCEDURE
lngRC           LONG(0) #<! Error File Counter
  CODE
#FOR (%DoTheseFiles)                                        #! RAS.2001.01.18
  #FIND(%File,%DoThisFile)                                  #! RAS.2001.01.18
  #CASE(UPPER(SUB(%FileDriver,1,3)))
  #OF  ('BTR')
  #OROF('CLA')
    #SET(%WorkExt,'.DAT')
  #OF  ('TOP')
    #SET(%WorkExt,'.TPS')
  #ELSE
    #SET(%WorkExt,'')
  #ENDCASE
#!
  #IF(%FileName<>'')
    #IF(SUB(%FileName,1,1)='''')
      #IF(INSTRING('.',%FileName,1,1))
  lngRc        += raFileExists(%FileName) #<! %FileDescription
      #ELSE
  lngRc        += raFileExists((%FileName & '%WorkExt')) #<! %FileDescription
      #ENDIF
    #ELSE
  lngRc        += raFileExists(%FileName) #<! %FileDescription
    #ENDIF
  #ELSE
  lngRc        += raFileExists('%File%WorkExt') #<! %FileDescription
  #END
#ENDFOR
  RETURN(lngRc) #<! Return Errors

!---------------------------------------------------------------------
!---------------------------------------------------------------------
!EOF
#CLOSE (%RaWorkName)
#REPLACE (%RaFileDo00, %RaWorkName)
#REMOVE (%RaWorkName)
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#!--------------------------------------------------------------------!
#! 2001.09.07.FRI - Roberto Artigas Jr.                               !
#! Changed module name generation to avoid duplicates at 8.3 time.    !
#! 2001.01.18.THU - Roberto Artigas Jr.                               !
#! This area is the main loop of creating an EI_*.CLW source file for !
#! each application file that matched all conditions necessary to be  !
#! included in the dump/load process.                                 !
#!--------------------------------------------------------------------!
#SET (%PassCount,0)                                         #! RAS.2001.09.07
#FOR (%DoTheseFiles)                                        #! RAS.2001.01.18
  #FIND(%File,%DoThisFile)                                  #! RAS.2001.01.18
#!=1234567890
    #SET (%RaClipName, %FilePrefix)
    #SET (%PassCount, %PassCount + 1)                       #! RAS.2001.09.07
    #SET (%RaClipName, FORMAT(%PassCount,@N05))             #! RAS.2001.09.07
    #SET (%RaFileName, 'EI_' & %RaClipName & '.clw')
    #SET (%RaWorkName, 'EI_' & %RaClipName & '.$$$')
    #MESSAGE('Creating: ' & %RaFileName,2)
    #PROJECT (%RaFileName)
    #CREATE (%RaWorkName)
#! %File: CREATE(%FileCreate), %FileType, %FileDriver
#! %File: %LocB-%LocE: %UserOpt, %FileOpt
!BOF
!---------------------------------------------------------------------
!---------------------------------------------------------------------
! File:         %RaFileName
! Purpose:      %File Export/Import Routines
! File Type:    %FileType
! File Driver:  %FileDriver
!---------------------------------------------------------------------
  MEMBER('%Application.clw')

!
! Procedure:    raDump%File
! Purpose:      Dump %FileDescription
!
raDump%File PROCEDURE
ra%[10]File FILE,DRIVER('BASIC','/FILEBUFFERS=%optBuf'),OEM,NAME(GLO:EI_AFile),PRE(ra%FilePrefix),CREATE
Record         RECORD,PRE()
#FOR(%Field)
  #SET(%LocB,INSTRING('RAEIDATA(',%FieldUserOptions,1,1))
  #SET(%LocE,INSTRING(')',%FieldUserOptions,1,%LocB))
  #SET(%UserOpt,SUB(%FieldUserOptions,%LocB,%LocE))
  #!SET(%UserOpt,EXTRACT(%FieldUserOptions,'RAEIDATA'))
  #SET(%FldOpt,EXTRACT(%UserOpt,'RAEIDATA',1))
#! %LocB-%LocE: %UserOpt, %FldOpt
  #IF(UPPER(%FldOpt)='NO')
  #ELSE
    #IF(%optHeader)
      #SET(%FldLength,LEN(CLIP(%FieldId))+2)
    #ELSE
      #SET(%FldLength,1)
    #END
    #SET(%FldType,%FieldType)
    #SET(%LocB,INSTRING('RAEIDATA(',%FieldUserOptions,1,1))
    #SET(%LocE,INSTRING(')',%FieldUserOptions,1,%LocB))
    #SET(%UserOpt,SUB(%FieldUserOptions,%LocB,%LocE))
    #!SET(%UserOpt,EXTRACT(%FieldUserOptions,'RAEIDATA'))
    #SET(%FldOpt,EXTRACT(%UserOpt,'RAEIDATA',2))
    #IF(%FldOpt<>'')
      #SET(%FldType,%FldOpt)
    #ENDIF
    #!
    #IF(INSTRING('@D',UPPER(%FieldRecordPicture),1,1))
      #SET(%FldType,'DATE')
    #ENDIF
    #IF(INSTRING('@D',UPPER(%FieldDisplayPicture),1,1))
      #SET(%FldType,'DATE')
    #ENDIF
    #IF(INSTRING('@T',UPPER(%FieldRecordPicture),1,1))
      #SET(%FldType,'TIME')
    #ENDIF
    #IF(INSTRING('@T',UPPER(%FieldDisplayPicture),1,1))
      #SET(%FldType,'TIME')
    #ENDIF
    #!
    #CASE(%FldType)
    #OF('ASTRING')
      #SET(%FldLength,0)
    #OF('BFLOAT4')
      #IF(25 > %FldLength)
        #SET(%FldLength,25)
      #ENDIF
    #OF('BFLOAT8')
      #IF(25 > %FldLength)
        #SET(%FldLength,25)
      #ENDIF
    #OF('BLOB')
      #SET(%FldLength,0)
    #OF('BYTE')
      #IF(5 > %FldLength)
        #SET(%FldLength,5)
      #ENDIF
    #OF('CSTRING')
      #IF(%FieldMemoSize > %FldLength)
        #SET(%FldLength,%FieldMemoSize)
      #ENDIF
      #SET(%FldLength,%FldLength+2)
    #OF('DATE')
      #IF(25 > %FldLength)
        #SET(%FldLength,25)
      #ENDIF
    #OF('DECIMAL')
      #SET(%LocB,INSTRING('(',%FieldStatement,1,1))
      #SET(%LocE,INSTRING(')',%FieldStatement,1,1))
      #SET(%WrkLength,SUB(%FieldStatement,%LocB+1,%LocE))
      #IF(%WrkLength > %FldLength)
        #SET(%FldLength,%WrkLength)
      #ENDIF
      #SET(%FldLength,%FldLength+%FieldPlaces)
      #SET(%FldLength,%FldLength+4)
    #OF('END')
      #SET(%FldLength,0)
    #OF('GROUP')
      #SET(%FldLength,0)
    #OF('HEX')
      #SET(%FldLength,%FieldMemoSize)
      #SET(%FldLength,(%FldLength * 2) + 2)
    #OF('LIKE')
      #SET(%FldLength,0)
    #OF('LONG')
      #IF(12 > %FldLength)
        #SET(%FldLength,12)
      #ENDIF
    #OF('MEMO')
      #IF(%FieldMemoSize > %FldLength)
        #SET(%FldLength,%FieldMemoSize)
      #ENDIF
      #SET(%FldLength,%FldLength+2)
    #OF('PDECIMAL')
      #SET(%LocB,INSTRING('(',%FieldStatement,1,1))
      #SET(%LocE,INSTRING(')',%FieldStatement,1,1))
      #SET(%WrkLength,SUB(%FieldStatement,%LocB+1,%LocE))
      #IF(%WrkLength > %FldLength)
        #SET(%FldLength,%WrkLength)
      #ENDIF
      #SET(%FldLength,%FldLength+%FieldPlaces)
      #SET(%FldLength,%FldLength+4)
    #OF('PICTURE')
      #SET(%FldLength,0)
    #OF('PSTRING')
      #SET(%LocB,INSTRING('(',%FieldStatement,1,1))
      #SET(%LocE,INSTRING(')',%FieldStatement,1,1))
      #SET(%WrkLength,SUB(%FieldStatement,%LocB+1,%LocE))
      #IF(%WrkLength > %FldLength)
        #SET(%FldLength,%WrkLength)
      #ENDIF
      #SET(%FldLength,%FldLength+2)
    #OF('REAL')
      #IF(25 > %FldLength)
        #SET(%FldLength,25)
      #ENDIF
    #OF('SHORT')
      #IF(8 > %FldLength)
        #SET(%FldLength,8)
      #ENDIF
    #OF('STRING')
      #IF(%FieldMemoSize > %FldLength)
        #SET(%FldLength,%FieldMemoSize)
      #ENDIF
      #SET(%FldLength,%FldLength+2)
    #OF('SREAL')
      #IF(25 > %FldLength)
        #SET(%FldLength,25)
      #ENDIF
    #OF('TIME')
      #IF(25 > %FldLength)
        #SET(%FldLength,25)
      #ENDIF
    #OF('TYPE')
      #SET(%FldLength,0)
    #OF('ULONG')
      #IF(12 > %FldLength)
        #SET(%FldLength,12)
      #ENDIF
    #OF('USHORT')
      #IF(8 > %FldLength)
        #SET(%FldLength,8)
      #ENDIF
    #ENDCASE
    #IF((%FieldDimension1>0)OR(%FieldDimension2>0)OR(%FieldDimension3>0)OR(%FieldDimension4>0))
      #SET(%FD1L,%FieldDimension1)
      #SET(%FD2L,%FieldDimension2)
      #SET(%FD3L,%FieldDimension3)
      #SET(%FD4L,%FieldDimension4)
      #SET(%FD1S,'')
      #SET(%FD2S,'')
      #SET(%FD3S,'')
      #SET(%FD4S,'')
      #! Array of 1 Dimension
      #IF((%FieldDimension1>0)AND(%FieldDimension2=0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
        #LOOP,FOR(%FD1I,1,%FD1L)
          #SET(%FD1S,'_' & %FD1I)
          #SET(%FldArray,%FieldId & %FD1S)
%[16]FldArray STRING(%FldLength) #<! %FieldStatement
        #ENDLOOP
      #ENDIF
      #! Array of 2 Dimensions
      #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
        #LOOP,FOR(%FD1I,1,%FD1L)
          #SET(%FD1S,'_' & %FD1I)
          #LOOP,FOR(%FD2I,1,%FD2L)
            #SET(%FD2S,'_' & %FD2I)
            #SET(%FldArray,%FieldId & %FD1S & %FD2S)
%[16]FldArray STRING(%FldLength) #<! %FieldStatement
          #ENDLOOP
        #ENDLOOP
      #ENDIF
      #! Array of 3 Dimensions
      #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4=0))
        #LOOP,FOR(%FD1I,1,%FD1L)
          #SET(%FD1S,'_' & %FD1I)
          #LOOP,FOR(%FD2I,1,%FD2L)
            #SET(%FD2S,'_' & %FD2I)
            #LOOP,FOR(%FD3I,1,%FD3L)
              #SET(%FD3S,'_' & %FD3I)
              #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S)
%[16]FldArray STRING(%FldLength) #<! %FieldStatement
            #ENDLOOP
          #ENDLOOP
        #ENDLOOP
      #ENDIF
      #! Array of 4 Dimensions
      #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4>0))
        #LOOP,FOR(%FD1I,1,%FD1L)
          #SET(%FD1S,'_' & %FD1I)
          #LOOP,FOR(%FD2I,1,%FD2L)
            #SET(%FD2S,'_' & %FD2I)
            #LOOP,FOR(%FD3I,1,%FD3L)
              #SET(%FD3S,'_' & %FD3I)
              #LOOP,FOR(%FD4I,1,%FD4L)
                #SET(%FD4S,'_' & %FD4I)
                #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S & %FD4S)
%[16]FldArray STRING(%FldLength) #<! %FieldStatement
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDLOOP
      #ENDIF
      #SET(%FldLength,0)
    #ENDIF
    #IF(%FldLength)
%[16]FieldId STRING(%FldLength) #<! %FieldStatement
    #ENDIF
  #ENDIF
#ENDFOR
               END
             END                       
#IF(%optError)
strMsg       STRING(255) #<! Error Message Body
strTit       STRING(255) #<! Error Message Title
#ENDIF
lngCount     LONG(0) #<! File Counter
lngTotal     LONG(0) #<! File Total
lngCancel    LONG(FALSE) #<! Cancel button pressed
ReadDone     BYTE(FALSE) #<! File Done Flag
ReadName     STRING(20) #<! File Name
Window       WINDOW('Export File Progress...'),AT(,,110,33),CENTER,TIMER(1),GRAY
               PROMPT('File Name:'),AT(4,4),USE(?LOC:FileName:Prompt)
               ENTRY(@s20),AT(46,4,60,10),USE(ReadName),SKIP,COLOR(COLOR:BtnFace),READONLY
               PROGRESS,USE(?prgPercent),AT(4,20,102,8),RANGE(0,100)
               BUTTON('Cancel'),AT(6,10,10,10),USE(?btnCancel),SKIP,HIDE
             END
  CODE
  GLO:EI_AFile  = raAscSetFile('%File.%optExt')
#IF (%expClear)

  REMOVE(ra%File) #<! Remove Destination
  CASE(ERRORCODE())
  OF 0 #<! No Errors at all
  OF 2 #<! File not found IS okay
  ELSE #<! Unexpected Error
  #IF(%optError)
    strTit      = 'EXPORT: Remove Failed!'
    strMsg      = 'REMOVE(' & 'ra%File' & '): ' & ERRORCODE() & ': ' & ERROR()
    MESSAGE(strMsg, strTit, ICON:HAND)
  #ENDIF
    RETURN(1) #<! Return Error
  END

  CREATE(ra%File) #<! Create Destination
  IF ERRORCODE() THEN #<! Create Error
  #IF(%optError)
    strTit      = 'EXPORT: Create Failed!'
    strMsg      = 'CREATE(' & 'ra%File' & '): ' & ERRORCODE() & ': ' & ERROR()
    MESSAGE(strMsg, strTit, ICON:HAND)
  #ENDIF
    RETURN(1) #<! Return Error
  END
#ENDIF

  OPEN(ra%File) #<! Open Destination
  IF ERRORCODE() THEN #<! Open Error
#IF(%optError)
    strTit      = 'EXPORT: Open Failed!'
    strMsg      = 'OPEN(' & 'ra%File' & '): ' & ERRORCODE() & ': ' & ERROR()
    MESSAGE(strMsg, strTit, ICON:HAND)
#ENDIF
    RETURN(1) #<! Return Error
  END

  OPEN(%File) #<! Open Source
  IF ERRORCODE() THEN #<! Open Error
#IF(%optError)
    strTit      = 'EXPORT: Open Failed!'
    strMsg      = 'OPEN(' & '%File' & '): ' & ERRORCODE() & ': ' & ERROR()
    MESSAGE(strMsg, strTit, ICON:HAND)
#ENDIF
    CLOSE(ra%File) #<! Close Destination
    RETURN(1) #<! Return Error
  END

#IF(%optHeader AND %expClear) 
  #FOR(%Field)
    #SET(%LocB,INSTRING('RAEIDATA(',%FieldUserOptions,1,1))
    #SET(%LocE,INSTRING(')',%FieldUserOptions,1,%LocB))
    #SET(%UserOpt,SUB(%FieldUserOptions,%LocB,%LocE))
    #!SET(%UserOpt,EXTRACT(%FieldUserOptions,'RAEIDATA'))
    #SET(%FldOpt,EXTRACT(%UserOpt,'RAEIDATA',1))
    #IF(UPPER(%FldOpt)='NO')
    #ELSE
      #SET(%FldType,%FieldType)
      #SET(%LocB,INSTRING('RAEIDATA(',%FieldUserOptions,1,1))
      #SET(%LocE,INSTRING(')',%FieldUserOptions,1,%LocB))
      #SET(%UserOpt,SUB(%FieldUserOptions,%LocB,%LocE))
      #!SET(%UserOpt,EXTRACT(%FieldUserOptions,'RAEIDATA'))
      #SET(%FldOpt,EXTRACT(%UserOpt,'RAEIDATA',2))
      #IF(%FldOpt<>'')
        #SET(%FldType,%FldOpt)
      #ENDIF
      #CASE(%FldType)
      #OF('ASTRING')
      #OF('BLOB')
      #OF('END')
      #OF('GROUP')
      #OF('LIKE')
      #OF('PICTURE')
      #OF('TYPE')
      #ELSE
        #IF((%FieldDimension1>0)OR(%FieldDimension2>0)OR(%FieldDimension3>0)OR(%FieldDimension4>0)) 
          #SET(%FD1L,%FieldDimension1)
          #SET(%FD2L,%FieldDimension2)
          #SET(%FD3L,%FieldDimension3)
          #SET(%FD4L,%FieldDimension4)
          #SET(%FD1S,'')
          #SET(%FD2S,'')
          #SET(%FD3S,'')
          #SET(%FD4S,'')
          #! Array of 1 Dimension
          #IF((%FieldDimension1>0)AND(%FieldDimension2=0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
            #LOOP,FOR(%FD1I,1,%FD1L)
              #SET(%FD1S,'_' & %FD1I)
              #SET(%FldArray,%FieldId & %FD1S)
  ra%FilePrefix:%FldArray = '%FldArray' #<! %FieldDescription
            #ENDLOOP
          #ENDIF
          #! Array of 2 Dimensions
          #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
            #LOOP,FOR(%FD1I,1,%FD1L)
              #SET(%FD1S,'_' & %FD1I)
              #LOOP,FOR(%FD2I,1,%FD2L)
                #SET(%FD2S,'_' & %FD2I)
                #SET(%FldArray,%FieldId & %FD1S & %FD2S)
  ra%FilePrefix:%FldArray = '%FldArray' #<! %FieldDescription
              #ENDLOOP
            #ENDLOOP
          #ENDIF
          #! Array of 3 Dimensions
          #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4=0))
            #LOOP,FOR(%FD1I,1,%FD1L)
              #SET(%FD1S,'_' & %FD1I)
              #LOOP,FOR(%FD2I,1,%FD2L)
                #SET(%FD2S,'_' & %FD2I)
                #LOOP,FOR(%FD3I,1,%FD3L)
                  #SET(%FD3S,'_' & %FD3I)
                  #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S)
  ra%FilePrefix:%FldArray = '%FldArray' #<! %FieldDescription
                #ENDLOOP
              #ENDLOOP
            #ENDLOOP
          #ENDIF
          #! Array of 4 Dimensions
          #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4>0))
            #LOOP,FOR(%FD1I,1,%FD1L)
              #SET(%FD1S,'_' & %FD1I)
              #LOOP,FOR(%FD2I,1,%FD2L)
                #SET(%FD2S,'_' & %FD2I)
                #LOOP,FOR(%FD3I,1,%FD3L)
                  #SET(%FD3S,'_' & %FD3I)
                  #LOOP,FOR(%FD4I,1,%FD4L)
                    #SET(%FD4S,'_' & %FD4I)
                    #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S & %FD4S)
  ra%FilePrefix:%FldArray = '%FldArray' #<! %FieldDescription
                  #ENDLOOP
                #ENDLOOP
              #ENDLOOP
            #ENDLOOP
          #ENDIF
        #ELSE
  ra%FilePrefix:%FieldId = '%FieldId' #<! %FieldDescription
#!          #SET(%lowerFieldId,LOWER(%FieldId))
#!  ra%FilePrefix:%FieldId = '%lowerFieldId' #<! %FieldDescription
        #ENDIF
      #ENDCASE
    #ENDIF
  #ENDFOR
  ADD(ra%File) #<! Add Header Record
  IF ERRORCODE() THEN #<! Add Error
#IF(%optError)
    strTit      = 'EXPORT: Add Header Failed!'
    strMsg      = 'ADD(' & 'ra%File' & '): ' & ERRORCODE() & ': ' & ERROR()
    MESSAGE(strMsg, strTit, ICON:HAND)
#ENDIF
    CLOSE(ra%File) #<! Close Destination
    CLOSE(%File) #<! Close Source
    RETURN(1) #<! Return Error
  END

#ENDIF
  SET(%File) #<! Set Record Order

  ReadDone      = FALSE #<! We are smoking......
  ReadName      = UPPER('%File') #<! Set The Name
  lngTotal      = RECORDS(%File) #<! Total Records
  lngCount      = 1 #<! Begin Here
  OPEN(Window) #<! Open the window
  IF (TRUE) THEN #<! Disable Cancel Button?
    HIDE(?btnCancel) #<! Yes....
  END #<! You are commited

  ACCEPT #<! Accept Events
    CASE Field() #<! Window Field
      OF ?btnCancel #<! Cancel Button Field?
        CASE Event() #<! Field Events
          OF EVENT:Accepted #<! Cancel Button Pushed
            lngCancel = TRUE #<! Set Button Pushed
            ReadDone = TRUE #<! File Done
            POST(Event:CloseWindow) #<! Message to Close
            CYCLE #<! Next Event
        END #<! ENDCASE Event()
    END #<! ENDCASE Field()

    CASE Event() #<! Window Event
      OF EVENT:Timer #<! Timer Happened
      IF (ReadDone) THEN #<! Doing Closing?
        CYCLE #<! Yes - Next Event
      END #<! Doing Closing?

      Window{PROP:Timer} = 0 #<! Disable Timer
      NEXT(%File) #<! Next Source Record
      IF ERRORCODE() THEN #<! End of File?
        ReadDone = TRUE #<! Set Flag Done
        POST(Event:CloseWindow) #<! Message To Close
        CYCLE #<! Next Event
      END #<! End of File?

      lngCount += 1
      ?prgPercent{PROP:Progress} = INT((lngCount * 100) / lngTotal)
      DISPLAY(?prgPercent)

      CLEAR(ra%FilePrefix:Record) #<! Clear Destination Record
#FOR(%Field)
  #SET(%LocB,INSTRING('RAEIDATA(',%FieldUserOptions,1,1))
  #SET(%LocE,INSTRING(')',%FieldUserOptions,1,%LocB))
  #SET(%UserOpt,SUB(%FieldUserOptions,%LocB,%LocE))
  #!SET(%UserOpt,EXTRACT(%FieldUserOptions,'RAEIDATA'))
  #SET(%FldOpt,EXTRACT(%UserOpt,'RAEIDATA',1))
  #IF(UPPER(%FldOpt)='NO')
  #ELSE
    #IF((%FieldDimension1>0)OR(%FieldDimension2>0)OR(%FieldDimension3>0)OR(%FieldDimension4>0)) 
      #SET(%FldType,%FieldType)
      #SET(%LocB,INSTRING('RAEIDATA(',%FieldUserOptions,1,1))
      #SET(%LocE,INSTRING(')',%FieldUserOptions,1,%LocB))
      #SET(%UserOpt,SUB(%FieldUserOptions,%LocB,%LocE))
      #!SET(%UserOpt,EXTRACT(%FieldUserOptions,'RAEIDATA'))
      #SET(%FldOpt,EXTRACT(%UserOpt,'RAEIDATA',2))
      #IF(%FldOpt<>'')
        #SET(%FldType,%FldOpt)
      #ENDIF
      #!
      #IF(INSTRING('@D',UPPER(%FieldRecordPicture),1,1))
        #SET(%FldType,'DATE')
      #ENDIF
      #IF(INSTRING('@D',UPPER(%FieldDisplayPicture),1,1))
        #SET(%FldType,'DATE')
      #ENDIF
      #IF(INSTRING('@T',UPPER(%FieldRecordPicture),1,1))
        #SET(%FldType,'TIME')
      #ENDIF
      #IF(INSTRING('@T',UPPER(%FieldDisplayPicture),1,1))
        #SET(%FldType,'TIME')
      #ENDIF
      #!
      #CASE(%FldType)
      #OF('ASTRING')
      #OF('BLOB')
      #OF('DATE')
        #SET(%FD1L,%FieldDimension1)
        #SET(%FD2L,%FieldDimension2)
        #SET(%FD3L,%FieldDimension3)
        #SET(%FD4L,%FieldDimension4)
        #SET(%FD1S,'')
        #SET(%FD2S,'')
        #SET(%FD3S,'')
        #SET(%FD4S,'')
        #! Array of 1 Dimension
        #IF((%FieldDimension1>0)AND(%FieldDimension2=0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #SET(%FldArray,%FieldId & %FD1S)
      ra%FilePrefix:%FldArray = FORMAT(%FilePrefix:%FieldId[%FD1I],%optDate) #<! %FieldDescription
          #ENDLOOP
        #ENDIF
        #! Array of 2 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #SET(%FldArray,%FieldId & %FD1S & %FD2S)
      ra%FilePrefix:%FldArray = FORMAT(%FilePrefix:%FieldId[%FD1I,%FD2I],%optDate) #<! %FieldDescription
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 3 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S)
      ra%FilePrefix:%FldArray = FORMAT(%FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I],%optDate) #<! %FieldDescription
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 4 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4>0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #LOOP,FOR(%FD4I,1,%FD4L)
                  #SET(%FD4S,'_' & %FD4I)
                  #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S & %FD4S)
      ra%FilePrefix:%FldArray = FORMAT(%FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I,%FD4I],%optDate) #<! %FieldDescription
                #ENDLOOP
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
      #OF('END')
      #OF('GROUP')
      #OF('HEX')
        #SET(%FD1L,%FieldDimension1)
        #SET(%FD2L,%FieldDimension2)
        #SET(%FD3L,%FieldDimension3)
        #SET(%FD4L,%FieldDimension4)
        #SET(%FD1S,'')
        #SET(%FD2S,'')
        #SET(%FD3S,'')
        #SET(%FD4S,'')
        #! Array of 1 Dimension
        #IF((%FieldDimension1>0)AND(%FieldDimension2=0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #SET(%FldArray,%FieldId & %FD1S)
      raDumpHEX(ra%FilePrefix:%FldArray,%FilePrefix:%FieldId[%FD1I],%FieldMemoSize) #<! %FieldDescription
          #ENDLOOP
        #ENDIF
        #! Array of 2 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #SET(%FldArray,%FieldId & %FD1S & %FD2S)
      raDumpHEX(ra%FilePrefix:%FldArray,%FilePrefix:%FieldId[%FD1I,%FD2I],%FieldMemoSize) #<! %FieldDescription
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 3 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S)
      raDumpHEX(ra%FilePrefix:%FldArray,%FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I],%FieldMemoSize) #<! %FieldDescription
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 4 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4>0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #LOOP,FOR(%FD4I,1,%FD4L)
                  #SET(%FD4S,'_' & %FD4I)
                  #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S & %FD4S)
      raDumpHEX(ra%FilePrefix:%FldArray,%FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I,%FD4I],%FieldMemoSize) #<! %FieldDescription
                #ENDLOOP
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
      #OF('LIKE')
      #OF('MEMO')
        #SET(%FD1L,%FieldDimension1)
        #SET(%FD2L,%FieldDimension2)
        #SET(%FD3L,%FieldDimension3)
        #SET(%FD4L,%FieldDimension4)
        #SET(%FD1S,'')
        #SET(%FD2S,'')
        #SET(%FD3S,'')
        #SET(%FD4S,'')
        #! Array of 1 Dimension
        #IF((%FieldDimension1>0)AND(%FieldDimension2=0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #SET(%FldArray,%FieldId & %FD1S)
      raDumpCRLF('raDump%File','%optCRLF',%FilePrefix:%FieldId[%FD1I]) #<! CRLF to MARKER
      ra%FilePrefix:%FldArray = %FilePrefix:%FieldId[%FD1I] #<! %FieldDescription
          #ENDLOOP
        #ENDIF
        #! Array of 2 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #SET(%FldArray,%FieldId & %FD1S & %FD2S)
      raDumpCRLF('raDump%File','%optCRLF',%FilePrefix:%FieldId[%FD1I,%FD2I]) #<! CRLF to MARKER
      ra%FilePrefix:%FldArray = %FilePrefix:%FieldId[%FD1I,%FD2I] #<! %FieldDescription
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 3 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S)
      raDumpCRLF('raDump%File','%optCRLF',%FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I]) #<! CRLF to MARKER
      ra%FilePrefix:%FldArray = %FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I] #<! %FieldDescription
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 4 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4>0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #LOOP,FOR(%FD4I,1,%FD4L)
                  #SET(%FD4S,'_' & %FD4I)
                  #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S & %FD4S)
      raDumpCRLF('raDump%File','%optCRLF',%FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I,%FD4I]) #<! CRLF to MARKER
      ra%FilePrefix:%FldArray = %FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I,%FD4I] #<! %FieldDescription
                #ENDLOOP
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
      #OF('PICTURE')
      #OF('TIME')
        #SET(%FD1L,%FieldDimension1)
        #SET(%FD2L,%FieldDimension2)
        #SET(%FD3L,%FieldDimension3)
        #SET(%FD4L,%FieldDimension4)
        #SET(%FD1S,'')
        #SET(%FD2S,'')
        #SET(%FD3S,'')
        #SET(%FD4S,'')
        #! Array of 1 Dimension
        #IF((%FieldDimension1>0)AND(%FieldDimension2=0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #SET(%FldArray,%FieldId & %FD1S)
      ra%FilePrefix:%FldArray = FORMAT(%FilePrefix:%FieldId[%FD1I],%optTime) #<! %FieldDescription
          #ENDLOOP
        #ENDIF
        #! Array of 2 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #SET(%FldArray,%FieldId & %FD1S & %FD2S)
      ra%FilePrefix:%FldArray = FORMAT(%FilePrefix:%FieldId[%FD1I,%FD2I],%optTime) #<! %FieldDescription
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 3 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S)
      ra%FilePrefix:%FldArray = FORMAT(%FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I],%optTime) #<! %FieldDescription
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 4 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4>0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #LOOP,FOR(%FD4I,1,%FD4L)
                  #SET(%FD4S,'_' & %FD4I)
                  #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S & %FD4S)
      ra%FilePrefix:%FldArray = FORMAT(%FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I,%FD4I],%optTime) #<! %FieldDescription
                #ENDLOOP
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
      #OF('TYPE')
      #ELSE
        #SET(%FD1L,%FieldDimension1)
        #SET(%FD2L,%FieldDimension2)
        #SET(%FD3L,%FieldDimension3)
        #SET(%FD4L,%FieldDimension4)
        #SET(%FD1S,'')
        #SET(%FD2S,'')
        #SET(%FD3S,'')
        #SET(%FD4S,'')
        #! Array of 1 Dimension
        #IF((%FieldDimension1>0)AND(%FieldDimension2=0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #SET(%FldArray,%FieldId & %FD1S)
      ra%FilePrefix:%FldArray = %FilePrefix:%FieldId[%FD1I] #<! %FieldDescription
          #ENDLOOP
        #ENDIF
        #! Array of 2 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #SET(%FldArray,%FieldId & %FD1S & %FD2S)
      ra%FilePrefix:%FldArray = %FilePrefix:%FieldId[%FD1I,%FD2I] #<! %FieldDescription
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 3 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S)
      ra%FilePrefix:%FldArray = %FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I] #<! %FieldDescription
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 4 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4>0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #LOOP,FOR(%FD4I,1,%FD4L)
                  #SET(%FD4S,'_' & %FD4I)
                  #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S & %FD4S)
      ra%FilePrefix:%FldArray = %FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I,%FD4I] #<! %FieldDescription
                #ENDLOOP
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
      #ENDCASE
    #ELSE
      #SET(%FldType,%FieldType)
      #SET(%LocB,INSTRING('RAEIDATA(',%FieldUserOptions,1,1))
      #SET(%LocE,INSTRING(')',%FieldUserOptions,1,%LocB))
      #SET(%UserOpt,SUB(%FieldUserOptions,%LocB,%LocE))
      #!SET(%UserOpt,EXTRACT(%FieldUserOptions,'RAEIDATA'))
      #SET(%FldOpt,EXTRACT(%UserOpt,'RAEIDATA',2))
      #IF(%FldOpt<>'')
        #SET(%FldType,%FldOpt)
      #ENDIF
      #!
      #IF(INSTRING('@D',UPPER(%FieldRecordPicture),1,1))
        #SET(%FldType,'DATE')
      #ENDIF
      #IF(INSTRING('@D',UPPER(%FieldDisplayPicture),1,1))
        #SET(%FldType,'DATE')
      #ENDIF
      #IF(INSTRING('@T',UPPER(%FieldRecordPicture),1,1))
        #SET(%FldType,'TIME')
      #ENDIF
      #IF(INSTRING('@T',UPPER(%FieldDisplayPicture),1,1))
        #SET(%FldType,'TIME')
      #ENDIF
      #!
      #CASE(%FldType)
      #OF('ASTRING')
      #OF('BLOB')
      #OF('DATE')
      ra%FilePrefix:%FieldId = FORMAT(%FilePrefix:%FieldId,%optDate) #<! %FieldDescription
      #OF('END')
      #OF('GROUP')
      #OF('HEX')
      raDumpHEX(ra%FilePrefix:%FieldId,%FilePrefix:%FieldId,%FieldMemoSize) #<! %FieldDescription
      #OF('LIKE')
      #OF('MEMO')
      raDumpCRLF('raDump%File','%optCRLF',%FilePrefix:%FieldId) #<! CRLF to MARKER
      ra%FilePrefix:%FieldId = %FilePrefix:%FieldId #<! %FieldDescription
      #OF('PICTURE')
      #OF('TIME')
      ra%FilePrefix:%FieldId = FORMAT(%FilePrefix:%FieldId,%optTime) #<! %FieldDescription
      #OF('TYPE')
      #ELSE
      ra%FilePrefix:%FieldId = %FilePrefix:%FieldId #<! %FieldDescription
      #ENDCASE
    #ENDIF
  #ENDIF
#ENDFOR
      ADD(ra%File) #<! Add Destination Record
      IF ERRORCODE() THEN #<! Add Error
#IF(%optError)
        strTit      = 'EXPORT: Add Failed!'
        strMsg      = 'ADD(' & 'ra%File' & '): ' & ERRORCODE() & ': ' & ERROR()
        MESSAGE(strMsg, strTit, ICON:HAND)
#ENDIF
        CLOSE(ra%File) #<! Close Destination
        CLOSE(%File) #<! Close Source
        RETURN(1) #<! Return Error
      END
      Window{PROP:Timer} = 1 #<! Enable Timer

    END #<! CASE EVENT:Timer
  END #<! End ACCEPT
  CLOSE(Window) #<! Close Window

  CLOSE(ra%File) #<! Close Destination
  CLOSE(%File) #<! Close Source
  RETURN(0) #<! Return Good

!
! Procedure:    raLoad%File
! Purpose:      Load %FileDescription
!
raLoad%File PROCEDURE
ra%[10]File FILE,DRIVER('BASIC','/FILEBUFFERS=%optBuf'),OEM,NAME(GLO:EI_AFile),PRE(ra%FilePrefix),CREATE
Record         RECORD,PRE()
#SET(%FldCount,0)
#FOR(%Field)
  #SET(%LocB,INSTRING('RAEIDATA(',%FieldUserOptions,1,1))
  #SET(%LocE,INSTRING(')',%FieldUserOptions,1,%LocB))
  #SET(%UserOpt,SUB(%FieldUserOptions,%LocB,%LocE))
  #!SET(%UserOpt,EXTRACT(%FieldUserOptions,'RAEIDATA'))
  #SET(%FldOpt,EXTRACT(%UserOpt,'RAEIDATA',1))
#! %LocB-%LocE: %UserOpt, %FldOpt
  #IF(UPPER(%FldOpt)='NO')
  #ELSE
    #IF(%optHeader)
      #SET(%FldLength,LEN(CLIP(%FieldId))+2)
    #ELSE
      #SET(%FldLength,1)
    #END
    #SET(%FldType,%FieldType)
    #SET(%LocB,INSTRING('RAEIDATA(',%FieldUserOptions,1,1))
    #SET(%LocE,INSTRING(')',%FieldUserOptions,1,%LocB))
    #SET(%UserOpt,SUB(%FieldUserOptions,%LocB,%LocE))
    #!SET(%UserOpt,EXTRACT(%FieldUserOptions,'RAEIDATA'))
    #SET(%FldOpt,EXTRACT(%UserOpt,'RAEIDATA',2))
    #IF(%FldOpt<>'')
      #SET(%FldType,%FldOpt)
    #ENDIF
    #!
    #IF(INSTRING('@D',UPPER(%FieldRecordPicture),1,1))
      #SET(%FldType,'DATE')
    #ENDIF
    #IF(INSTRING('@D',UPPER(%FieldDisplayPicture),1,1))
      #SET(%FldType,'DATE')
    #ENDIF
    #IF(INSTRING('@T',UPPER(%FieldRecordPicture),1,1))
      #SET(%FldType,'TIME')
    #ENDIF
    #IF(INSTRING('@T',UPPER(%FieldDisplayPicture),1,1))
      #SET(%FldType,'TIME')
    #ENDIF
    #!
    #CASE(%FldType)
    #OF('ASTRING')
      #SET(%FldLength,0)
    #OF('BFLOAT4')
      #IF(25 > %FldLength)
        #SET(%FldLength,25)
      #ENDIF
    #OF('BFLOAT8')
      #IF(25 > %FldLength)
        #SET(%FldLength,25)
      #ENDIF
    #OF('BLOB')
      #SET(%FldLength,0)
    #OF('BYTE')
      #IF(5 > %FldLength)
        #SET(%FldLength,5)
      #ENDIF
    #OF('CSTRING')
      #IF(%FieldMemoSize > %FldLength)
        #SET(%FldLength,%FieldMemoSize)
      #ENDIF
      #SET(%FldLength,%FldLength+2)
    #OF('DATE')
      #IF(25 > %FldLength)
        #SET(%FldLength,25)
      #ENDIF
    #OF('DECIMAL')
      #SET(%LocB,INSTRING('(',%FieldStatement,1,1))
      #SET(%LocE,INSTRING(')',%FieldStatement,1,1))
      #SET(%WrkLength,SUB(%FieldStatement,%LocB+1,%LocE))
      #IF(%WrkLength > %FldLength)
        #SET(%FldLength,%WrkLength)
      #ENDIF
      #SET(%FldLength,%FldLength+%FieldPlaces)
      #SET(%FldLength,%FldLength+4)
    #OF('END')
      #SET(%FldLength,0)
    #OF('GROUP')
      #SET(%FldLength,0)
    #OF('HEX')
      #SET(%FldLength,%FieldMemoSize)
      #SET(%FldLength,(%FldLength * 2) + 2)
    #OF('LIKE')
      #SET(%FldLength,0)
    #OF('LONG')
      #IF(12 > %FldLength)
        #SET(%FldLength,12)
      #ENDIF
    #OF('MEMO')
      #IF(%FieldMemoSize > %FldLength)
        #SET(%FldLength,%FieldMemoSize)
      #ENDIF
      #SET(%FldLength,%FldLength+2)
    #OF('PDECIMAL')
      #SET(%LocB,INSTRING('(',%FieldStatement,1,1))
      #SET(%LocE,INSTRING(')',%FieldStatement,1,1))
      #SET(%WrkLength,SUB(%FieldStatement,%LocB+1,%LocE))
      #IF(%WrkLength > %FldLength)
        #SET(%FldLength,%WrkLength)
      #ENDIF
      #SET(%FldLength,%FldLength+%FieldPlaces)
      #SET(%FldLength,%FldLength+4)
    #OF('PICTURE')
      #SET(%FldLength,0)
    #OF('PSTRING')
      #SET(%LocB,INSTRING('(',%FieldStatement,1,1))
      #SET(%LocE,INSTRING(')',%FieldStatement,1,1))
      #SET(%WrkLength,SUB(%FieldStatement,%LocB+1,%LocE))
      #IF(%WrkLength > %FldLength)
        #SET(%FldLength,%WrkLength)
      #ENDIF
      #SET(%FldLength,%FldLength+2)
    #OF('REAL')
      #IF(25 > %FldLength)
        #SET(%FldLength,25)
      #ENDIF
    #OF('SHORT')
      #IF(8 > %FldLength)
        #SET(%FldLength,8)
      #ENDIF
    #OF('STRING')
      #IF(%FieldMemoSize > %FldLength)
        #SET(%FldLength,%FieldMemoSize)
      #ENDIF
      #SET(%FldLength,%FldLength+2)
    #OF('SREAL')
      #IF(25 > %FldLength)
        #SET(%FldLength,25)
      #ENDIF
    #OF('TIME')
      #IF(25 > %FldLength)
        #SET(%FldLength,25)
      #ENDIF
    #OF('TYPE')
      #SET(%FldLength,0)
    #OF('ULONG')
      #IF(12 > %FldLength)
        #SET(%FldLength,12)
      #ENDIF
    #OF('USHORT')
      #IF(8 > %FldLength)
        #SET(%FldLength,8)
      #ENDIF
    #ENDCASE
    #IF((%FieldDimension1>0)OR(%FieldDimension2>0)OR(%FieldDimension3>0)OR(%FieldDimension4>0)) 
      #SET(%FD1L,%FieldDimension1)
      #SET(%FD2L,%FieldDimension2)
      #SET(%FD3L,%FieldDimension3)
      #SET(%FD4L,%FieldDimension4)
      #SET(%FD1S,'')
      #SET(%FD2S,'')
      #SET(%FD3S,'')
      #SET(%FD4S,'')
      #! Array of 1 Dimension
      #IF((%FieldDimension1>0)AND(%FieldDimension2=0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
        #LOOP,FOR(%FD1I,1,%FD1L)
          #SET(%FD1S,'_' & %FD1I)
          #SET(%FldArray,%FieldId & %FD1S)
          #SET(%FldCount,%FldCount+1)
%[16]FldArray STRING(%FldLength) #<! %FieldStatement
        #ENDLOOP
      #ENDIF
      #! Array of 2 Dimensions
      #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
        #LOOP,FOR(%FD1I,1,%FD1L)
          #SET(%FD1S,'_' & %FD1I)
          #LOOP,FOR(%FD2I,1,%FD2L)
            #SET(%FD2S,'_' & %FD2I)
            #SET(%FldArray,%FieldId & %FD1S & %FD2S)
            #SET(%FldCount,%FldCount+1)
%[16]FldArray STRING(%FldLength) #<! %FieldStatement
          #ENDLOOP
        #ENDLOOP
      #ENDIF
      #! Array of 3 Dimensions
      #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4=0))
        #LOOP,FOR(%FD1I,1,%FD1L)
          #SET(%FD1S,'_' & %FD1I)
          #LOOP,FOR(%FD2I,1,%FD2L)
            #SET(%FD2S,'_' & %FD2I)
            #LOOP,FOR(%FD3I,1,%FD3L)
              #SET(%FD3S,'_' & %FD3I)
              #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S)
              #SET(%FldCount,%FldCount+1)
%[16]FldArray STRING(%FldLength) #<! %FieldStatement
            #ENDLOOP
          #ENDLOOP
        #ENDLOOP
      #ENDIF
      #! Array of 4 Dimensions
      #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4>0))
        #LOOP,FOR(%FD1I,1,%FD1L)
          #SET(%FD1S,'_' & %FD1I)
          #LOOP,FOR(%FD2I,1,%FD2L)
            #SET(%FD2S,'_' & %FD2I)
            #LOOP,FOR(%FD3I,1,%FD3L)
              #SET(%FD3S,'_' & %FD3I)
              #LOOP,FOR(%FD4I,1,%FD4L)
                #SET(%FD4S,'_' & %FD4I)
                #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S & %FD4S)
                #SET(%FldCount,%FldCount+1)
%[16]FldArray STRING(%FldLength) #<! %FieldStatement
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDLOOP
      #ENDIF
      #SET(%FldLength,0)
    #ENDIF
    #IF(%FldLength)
    #SET(%FldCount,%FldCount+1)
%[16]FieldId STRING(%FldLength) #<! %FieldStatement
    #ENDIF
  #ENDIF
#ENDFOR
               END
             END
#IF(%optError)
strMsg       STRING(255) #<! Error Message Body
strTit       STRING(255) #<! Error Message Title
#ENDIF
lngRecs      LONG(0) #<! Count Records
lngCount     LONG(0) #<! File Counter
lngTotal     LONG(0) #<! File Total
lngCancel    LONG(FALSE) #<! Cancel button pressed
ReadDone     BYTE(FALSE) #<! File Done Flag
ReadName     STRING(20) #<! File Name
Window       WINDOW('Import File Progress...'),AT(,,110,33),CENTER,TIMER(1),GRAY
               PROMPT('File Name:'),AT(4,4),USE(?LOC:FileName:Prompt)
               ENTRY(@s20),AT(46,4,60,10),USE(ReadName),SKIP,COLOR(COLOR:BtnFace),READONLY
               PROGRESS,USE(?prgPercent),AT(4,20,102,8),RANGE(0,100)
               BUTTON('Cancel'),AT(6,10,10,10),USE(?btnCancel),SKIP,HIDE
             END
#IF(%impCheck)
as%[10]File FILE,DRIVER('ASCII'),OEM,NAME(GLO:EI_AFile),PRE(as%FilePrefix),CREATE
Record         RECORD,PRE()
Line             STRING(65520)
               END
             END
lngFldCount  LONG(%FldCount) #<! Field Count Known
lngFldCheck  LONG(0) #<! Field Count Check
#ENDIF
  CODE
  GLO:EI_AFile  = raAscSetFile('%File.%optExt')
#IF (%impCheck)

  !
  ! Additional check of import structure against known facts.
  ! ---------------------------------------------------------
  ! You have got to know what you are doing here.
  ! If one of the import files is BAD, the whole restore might
  ! not be unusable since the destination data file will NOT
  ! be cleared and that WILL cause a mismatched data set.
  ! ---------------------------------------------------------
  OPEN(as%File) #<! Open Source
  IF ERRORCODE() THEN #<! Open Error
#IF(%optError)
    strTit      = 'IMPORT: Open Failed!'
    strMsg      = 'OPEN(' & 'as%File' & '): ' & ERRORCODE() & ': ' & ERROR()
    MESSAGE(strMsg, strTit, ICON:HAND)
#ENDIF
    RETURN(1) #<! Return Error
  END

  SET(as%File) #<! Set Record Order
  NEXT(as%File) #<! Source Record

  !
  ! Check the number of commas.
  ! ---------------------------
  lngFldCheck   = raCountChar(',', as%FilePrefix:Line)
  IF ((lngFldCount - 1) <> lngFldCheck) THEN
#IF(%optError)
    strTit      = 'IMPORT: BAD File Error!'
    strMsg      = 'File name: %File.%optExt<13,10>' & CLIP(GLO:EI_AFile) & |
                  '<13,10>Comma count needed: ' & (lngFldCount - 1) & |
                  '<13,10>Comma count found: ' & lngFldCheck & |
                  ''
    MESSAGE(strMsg, strTit, ICON:HAND)
#ENDIF
    CLOSE(as%File) #<! Close Source
    RETURN(1) #<! Return Error
  END

  !
  ! Check the number of double quotes.
  ! ----------------------------------
  lngFldCheck   = raCountChar('"', as%FilePrefix:Line)
  IF ((lngFldCount * 2) <> lngFldCheck) THEN
#IF(%optError)
    strTit      = 'IMPORT: BAD File Error!'
    strMsg      = 'File name: %File.%optExt<13,10>' & CLIP(GLO:EI_AFile) & |
                  '<13,10>Comma count needed: ' & (lngFldCount * 2) & |
                  '<13,10>Comma count found: ' & lngFldCheck & |
                  ''
    MESSAGE(strMsg, strTit, ICON:HAND)
#ENDIF
    CLOSE(as%File) #<! Close Source
    RETURN(1) #<! Return Error
  END

  CLOSE(as%File) #<! Close Source
  ! ---------------------------------------------------------
#ENDIF
#IF (%impClear)

  REMOVE(%File) #<! Remove Destination
  CASE(ERRORCODE())
  OF 0 #<! No errors at all
  OF 2 #<! File not found IS okay
  ELSE #<! Unexpected Error
  #IF(%optError)
    strTit      = 'IMPORT: Remove Failed!'
    strMsg      = 'REMOVE(' & '%File' & '): ' & ERRORCODE() & ': ' & ERROR()
    MESSAGE(strMsg, strTit, ICON:HAND)
  #ENDIF
    RETURN(1) #<! Return Error
  END

  CREATE(%File) #<! Create Destination
  IF ERRORCODE() THEN #<! Create Error
  #IF(%optError)
    strTit      = 'IMPORT: Create Failed!'
    strMsg      = 'CREATE(' & 'ra%File' & '): ' & ERRORCODE() & ': ' & ERROR()
    MESSAGE(strMsg, strTit, ICON:HAND)
  #ENDIF
    RETURN(1) #<! Return Error
  END
#ENDIF

  OPEN(%File) #<! Open Destination
  IF ERRORCODE() THEN #<! Open Error
#IF(%optError)
    strTit      = 'IMPORT: Open Failed!'
    strMsg      = 'OPEN(' & '%File' & '): ' & ERRORCODE() & ': ' & ERROR()
    MESSAGE(strMsg, strTit, ICON:HAND)
#ENDIF
    RETURN(1) #<! Return Error
  END

  OPEN(ra%File) #<! Open Source
  IF ERRORCODE() THEN #<! Open Error
#IF(%optError)
    strTit      = 'IMPORT: Open Failed!'
    strMsg      = 'OPEN(' & 'ra%File' & '): ' & ERRORCODE() & ': ' & ERROR()
    MESSAGE(strMsg, strTit, ICON:HAND)
#ENDIF
    CLOSE(%File) #<! Close Destination
    RETURN(1) #<! Return Error
  END

  SET(ra%File) #<! Set Record Order

  ReadDone      = FALSE #<! We are smoking......
  ReadName      = UPPER('%File') #<! Set The Name
  lngTotal      = BYTES(ra%File) #<! Total Records
  lngCount      = 0 #<! Begin Here
  lngRecs       = 0 #<! Count Records Read

#IF(%optHeader AND %impClear) 
  NEXT(ra%File) #<! Header Source Record
  lngCount += BYTES(ra%File) #<! Add File Count

#ENDIF
  OPEN(Window) #<! Open the window
  IF (TRUE) THEN #<! Disable Cancel Button?
    HIDE(?btnCancel) #<! Yes....
  END #<! You are commited

  ACCEPT #<! Accept Events
    CASE Field() #<! Window Field
      OF ?btnCancel #<! Cancel Button Field?
        CASE Event() #<! Field Events
          OF EVENT:Accepted #<! Cancel Button Pushed
            lngCancel = TRUE #<! Set Button Pushed
            ReadDone = TRUE #<! File Done
            POST(Event:CloseWindow) #<! Message to Close
            CYCLE #<! Next Event
        END #<! ENDCASE Event()
    END #<! ENDCASE Field()

    CASE Event() #<! Window Event
      OF EVENT:Timer #<! Timer Happened
      IF (ReadDone) THEN #<! Doing Closing?
        CYCLE #<! Yes - Next Event
      END #<! Doing Closing?

      Window{PROP:Timer} = 0 #<! Disable Timer
      NEXT(ra%File) #<! Next Source Record
      IF ERRORCODE() THEN #<! End of File?
        ReadDone = TRUE #<! Set Flag Done
        POST(Event:CloseWindow) #<! Message To Close
        CYCLE #<! Next Event
      END #<! End of File?

      lngCount += BYTES(ra%File)
      ?prgPercent{PROP:Progress} = INT((lngCount * 100) / lngTotal)
      DISPLAY(?prgPercent)

      lngRecs += 1
      CLEAR(%FilePrefix:Record) #<! Clear Destination Record
#FOR(%Field)
  #SET(%LocB,INSTRING('RAEIDATA(',%FieldUserOptions,1,1))
  #SET(%LocE,INSTRING(')',%FieldUserOptions,1,%LocB))
  #SET(%UserOpt,SUB(%FieldUserOptions,%LocB,%LocE))
  #!SET(%UserOpt,EXTRACT(%FieldUserOptions,'RAEIDATA'))
  #SET(%FldOpt,EXTRACT(%UserOpt,'RAEIDATA',1))
  #IF(UPPER(%FldOpt)='NO')
  #ELSE
    #IF((%FieldDimension1>0)OR(%FieldDimension2>0)OR(%FieldDimension3>0)OR(%FieldDimension4>0)) 
      #SET(%FldType,%FieldType)
      #SET(%LocB,INSTRING('RAEIDATA(',%FieldUserOptions,1,1))
      #SET(%LocE,INSTRING(')',%FieldUserOptions,1,%LocB))
      #SET(%UserOpt,SUB(%FieldUserOptions,%LocB,%LocE))
      #!SET(%UserOpt,EXTRACT(%FieldUserOptions,'RAEIDATA'))
      #SET(%FldOpt,EXTRACT(%UserOpt,'RAEIDATA',2))
      #IF(%FldOpt<>'')
        #SET(%FldType,%FldOpt)
      #ENDIF
      #!
      #IF(INSTRING('@D',UPPER(%FieldRecordPicture),1,1))
        #SET(%FldType,'DATE')
      #ENDIF
      #IF(INSTRING('@D',UPPER(%FieldDisplayPicture),1,1))
        #SET(%FldType,'DATE')
      #ENDIF
      #IF(INSTRING('@T',UPPER(%FieldRecordPicture),1,1))
        #SET(%FldType,'TIME')
      #ENDIF
      #IF(INSTRING('@T',UPPER(%FieldDisplayPicture),1,1))
        #SET(%FldType,'TIME')
      #ENDIF
      #!
      #CASE(%FldType)
      #OF('ASTRING')
      #OF('BLOB')
      #OF('DATE')
        #SET(%FD1L,%FieldDimension1)
        #SET(%FD2L,%FieldDimension2)
        #SET(%FD3L,%FieldDimension3)
        #SET(%FD4L,%FieldDimension4)
        #SET(%FD1S,'')
        #SET(%FD2S,'')
        #SET(%FD3S,'')
        #SET(%FD4S,'')
        #! Array of 1 Dimension
        #IF((%FieldDimension1>0)AND(%FieldDimension2=0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #SET(%FldArray,%FieldId & %FD1S)
      %FilePrefix:%FieldId[%FD1I] = DEFORMAT(ra%FilePrefix:%FldArray,%optDate) #<! %FieldDescription
          #ENDLOOP
        #ENDIF
        #! Array of 2 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #SET(%FldArray,%FieldId & %FD1S & %FD2S)
      %FilePrefix:%FieldId[%FD1I,%FD2I] = DEFORMAT(ra%FilePrefix:%FldArray,%optDate) #<! %FieldDescription
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 3 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S)
      %FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I] = DEFORMAT(ra%FilePrefix:%FldArray,%optDate) #<! %FieldDescription
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 4 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4>0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #LOOP,FOR(%FD4I,1,%FD4L)
                  #SET(%FD4S,'_' & %FD4I)
                  #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S & %FD4S)
      %FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I,%FD4I] = DEFORMAT(ra%FilePrefix:%FldArray,%optDate) #<! %FieldDescription
                #ENDLOOP
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
      #OF('END')
      #OF('GROUP')
      #OF('HEX')
        #SET(%FD1L,%FieldDimension1)
        #SET(%FD2L,%FieldDimension2)
        #SET(%FD3L,%FieldDimension3)
        #SET(%FD4L,%FieldDimension4)
        #SET(%FD1S,'')
        #SET(%FD2S,'')
        #SET(%FD3S,'')
        #SET(%FD4S,'')
        #! Array of 1 Dimension
        #IF((%FieldDimension1>0)AND(%FieldDimension2=0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #SET(%FldArray,%FieldId & %FD1S)
      raLoadHEX(%FilePrefix:%FieldId[%FD1I],ra%FilePrefix:%FldArray,%FieldMemoSize) #<! %FieldDescription
          #ENDLOOP
        #ENDIF
        #! Array of 2 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #SET(%FldArray,%FieldId & %FD1S & %FD2S)
      raLoadHEX(%FilePrefix:%FieldId[%FD1I,%FD2I],ra%FilePrefix:%FldArray,%FieldMemoSize) #<! %FieldDescription
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 3 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S)
      raLoadHEX(%FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I],ra%FilePrefix:%FldArray,%FieldMemoSize) #<! %FieldDescription
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 4 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4>0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #LOOP,FOR(%FD4I,1,%FD4L)
                  #SET(%FD4S,'_' & %FD4I)
                  #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S & %FD4S)
      raLoadHEX(%FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I,%FD4I],ra%FilePrefix:%FldArray,%FieldMemoSize) #<! %FieldDescription
                #ENDLOOP
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
      #OF('LIKE')
      #OF('MEMO')
        #SET(%FD1L,%FieldDimension1)
        #SET(%FD2L,%FieldDimension2)
        #SET(%FD3L,%FieldDimension3)
        #SET(%FD4L,%FieldDimension4)
        #SET(%FD1S,'')
        #SET(%FD2S,'')
        #SET(%FD3S,'')
        #SET(%FD4S,'')
        #! Array of 1 Dimension
        #IF((%FieldDimension1>0)AND(%FieldDimension2=0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #SET(%FldArray,%FieldId & %FD1S)
      %FilePrefix:%FieldId[%FD1I] = ra%FilePrefix:%FldArray #<! %FieldDescription
      raLoadCRLF('raLoad%File','%optCRLF',%FilePrefix:%FieldId[%FD1I]) #<! CRLF to MARKER
          #ENDLOOP
        #ENDIF
        #! Array of 2 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #SET(%FldArray,%FieldId & %FD1S & %FD2S)
      %FilePrefix:%FieldId[%FD1I,%FD2I] = ra%FilePrefix:%FldArray #<! %FieldDescription
      raLoadCRLF('raLoad%File','%optCRLF',%FilePrefix:%FieldId[%FD1I,%FD2I]) #<! CRLF to MARKER
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 3 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S)
      %FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I] = ra%FilePrefix:%FldArray #<! %FieldDescription
      raLoadCRLF('raLoad%File','%optCRLF',%FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I]) #<! CRLF to MARKER
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 4 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4>0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #LOOP,FOR(%FD4I,1,%FD4L)
                  #SET(%FD4S,'_' & %FD4I)
                  #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S & %FD4S)
      %FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I,%FD4I] = ra%FilePrefix:%FldArray #<! %FieldDescription
      raLoadCRLF('raLoad%File','%optCRLF',%FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I,%FD4I]) #<! CRLF to MARKER
                #ENDLOOP
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
      #OF('PICTURE')
      #OF('TIME')
        #SET(%FD1L,%FieldDimension1)
        #SET(%FD2L,%FieldDimension2)
        #SET(%FD3L,%FieldDimension3)
        #SET(%FD4L,%FieldDimension4)
        #SET(%FD1S,'')
        #SET(%FD2S,'')
        #SET(%FD3S,'')
        #SET(%FD4S,'')
        #! Array of 1 Dimension
        #IF((%FieldDimension1>0)AND(%FieldDimension2=0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #SET(%FldArray,%FieldId & %FD1S)
      %FilePrefix:%FieldId[%FD1I] = DEFORMAT(ra%FilePrefix:%FldArray,%optTime) #<! %FieldDescription
          #ENDLOOP
        #ENDIF
        #! Array of 2 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #SET(%FldArray,%FieldId & %FD1S & %FD2S)
      %FilePrefix:%FieldId[%FD1I,%FD2I] = DEFORMAT(ra%FilePrefix:%FldArray,%optTime) #<! %FieldDescription
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 3 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S)
      %FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I] = DEFORMAT(ra%FilePrefix:%FldArray,%optTime) #<! %FieldDescription
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 4 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4>0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #LOOP,FOR(%FD4I,1,%FD4L)
                  #SET(%FD4S,'_' & %FD4I)
                  #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S & %FD4S)
      %FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I,%FD4I] = DEFORMAT(ra%FilePrefix:%FldArray,%optTime) #<! %FieldDescription
                #ENDLOOP
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
      #OF('TYPE')
      #ELSE
        #SET(%FD1L,%FieldDimension1)
        #SET(%FD2L,%FieldDimension2)
        #SET(%FD3L,%FieldDimension3)
        #SET(%FD4L,%FieldDimension4)
        #SET(%FD1S,'')
        #SET(%FD2S,'')
        #SET(%FD3S,'')
        #SET(%FD4S,'')
        #! Array of 1 Dimension
        #IF((%FieldDimension1>0)AND(%FieldDimension2=0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #SET(%FldArray,%FieldId & %FD1S)
      %FilePrefix:%FieldId[%FD1I] = ra%FilePrefix:%FldArray #<! %FieldDescription
          #ENDLOOP
        #ENDIF
        #! Array of 2 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3=0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #SET(%FldArray,%FieldId & %FD1S & %FD2S)
      %FilePrefix:%FieldId[%FD1I,%FD2I] = ra%FilePrefix:%FldArray #<! %FieldDescription
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 3 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4=0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S)
      %FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I] = ra%FilePrefix:%FldArray #<! %FieldDescription
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
        #! Array of 4 Dimensions
        #IF((%FieldDimension1>0)AND(%FieldDimension2>0)AND(%FieldDimension3>0)AND(%FieldDimension4>0))
          #LOOP,FOR(%FD1I,1,%FD1L)
            #SET(%FD1S,'_' & %FD1I)
            #LOOP,FOR(%FD2I,1,%FD2L)
              #SET(%FD2S,'_' & %FD2I)
              #LOOP,FOR(%FD3I,1,%FD3L)
                #SET(%FD3S,'_' & %FD3I)
                #LOOP,FOR(%FD4I,1,%FD4L)
                  #SET(%FD4S,'_' & %FD4I)
                  #SET(%FldArray,%FieldId & %FD1S & %FD2S & %FD3S & %FD4S)
      %FilePrefix:%FieldId[%FD1I,%FD2I,%FD3I,%FD4I] = ra%FilePrefix:%FldArray #<! %FieldDescription
                #ENDLOOP
              #ENDLOOP
            #ENDLOOP
          #ENDLOOP
        #ENDIF
      #ENDCASE
    #ELSE
      #SET(%FldType,%FieldType)
      #SET(%LocB,INSTRING('RAEIDATA(',%FieldUserOptions,1,1))
      #SET(%LocE,INSTRING(')',%FieldUserOptions,1,%LocB))
      #SET(%UserOpt,SUB(%FieldUserOptions,%LocB,%LocE))
      #!SET(%UserOpt,EXTRACT(%FieldUserOptions,'RAEIDATA'))
      #SET(%FldOpt,EXTRACT(%UserOpt,'RAEIDATA',2))
      #IF(%FldOpt<>'')
        #SET(%FldType,%FldOpt)
      #ENDIF
      #!
      #IF(INSTRING('@D',UPPER(%FieldRecordPicture),1,1))
        #SET(%FldType,'DATE')
      #ENDIF
      #IF(INSTRING('@D',UPPER(%FieldDisplayPicture),1,1))
        #SET(%FldType,'DATE')
      #ENDIF
      #IF(INSTRING('@T',UPPER(%FieldRecordPicture),1,1))
        #SET(%FldType,'TIME')
      #ENDIF
      #IF(INSTRING('@T',UPPER(%FieldDisplayPicture),1,1))
        #SET(%FldType,'TIME')
      #ENDIF
      #!
      #CASE(%FldType)
      #OF('ASTRING')
      #OF('BLOB')
      #OF('DATE')
      %FilePrefix:%FieldId = DEFORMAT(ra%FilePrefix:%FieldId,%optDate) #<! %FieldDescription
      #OF('END')
      #OF('GROUP')
      #OF('HEX')
      raLoadHEX(%FilePrefix:%FieldId,ra%FilePrefix:%FieldId,%FieldMemoSize) #<! %FieldDescription
      #OF('LIKE')
      #OF('MEMO')
      %FilePrefix:%FieldId = ra%FilePrefix:%FieldId #<! %FieldDescription
      raLoadCRLF('raLoad%File','%optCRLF',%FilePrefix:%FieldId) #<! CRLF to MARKER
      #OF('PICTURE')
      #OF('TIME')
      %FilePrefix:%FieldId = DEFORMAT(ra%FilePrefix:%FieldId,%optTime) #<! %FieldDescription
      #OF('TYPE')
      #ELSE
      %FilePrefix:%FieldId = ra%FilePrefix:%FieldId #<! %FieldDescription
      #ENDCASE
    #ENDIF
  #ENDIF
#ENDFOR
      ADD(%File) #<! Add Destination Record
      IF ERRORCODE() THEN #<! Add Error
#IF(%optError)
        strTit = 'IMPORT: Add Failed!'
        strMsg = 'Record=''' & lngRecs & '''<13,10>'
        strMsg = CLIP(strMsg) & 'ADD(' & '%File' & '): ' & ERRORCODE() & ': ' & ERROR()
        strMsg = CLIP(strMsg) & '<13,10>Do you want to quit?'
        CASE MESSAGE(strMsg, strTit, ICON:QUESTION,BUTTON:Yes+BUTTON:No,BUTTON:No,1)
        OF BUTTON:No #<! Continue Processing
        OF BUTTON:Yes #<! Quit! 
          CLOSE(%File) #<! Close Destination
          CLOSE(ra%File) #<! Close Source
          RETURN(1) #<! Return Error
        END
  #IF(%impDupKey)
    #FOR(%Field)
      #SET(%LocB,INSTRING('RAEIDATA(',%FieldUserOptions,1,1))
      #SET(%LocE,INSTRING(')',%FieldUserOptions,1,%LocB))
      #SET(%UserOpt,SUB(%FieldUserOptions,%LocB,%LocE))
      #!SET(%UserOpt,EXTRACT(%FieldUserOptions,'RAEIDATA'))
      #SET(%FldOpt,EXTRACT(%UserOpt,'RAEIDATA',1))
      #IF(UPPER(%FldOpt)='NO')
      #ELSE
        #IF((%FieldDimension1>0)OR(%FieldDimension2>0)OR(%FieldDimension3>0)OR(%FieldDimension4>0)) 
        #ELSE
          #SET(%FldType,%FieldType)
          #SET(%LocB,INSTRING('RAEIDATA(',%FieldUserOptions,1,1))
          #SET(%LocE,INSTRING(')',%FieldUserOptions,1,%LocB))
          #SET(%UserOpt,SUB(%FieldUserOptions,%LocB,%LocE))
          #!SET(%UserOpt,EXTRACT(%FieldUserOptions,'RAEIDATA'))
          #SET(%FldOpt,EXTRACT(%UserOpt,'RAEIDATA',2))
          #IF(%FldOpt<>'')
            #SET(%FldType,%FldOpt)
          #ENDIF
          #CASE(%FldType)
          #OF('ASTRING')
          #OF('BLOB')
          #OF('DATE')
        strTit = 'Field=Data'
        strMsg = '%FilePrefix:%FieldId=''' & CLIP(ra%FilePrefix:%FieldId) & ''''
        MESSAGE(strMsg, strTit, ICON:HAND)
          #OF('END')
          #OF('GROUP')
          #OF('HEX')
          #OF('LIKE')
          #OF('MEMO')
          #OF('PICTURE')
          #OF('TIME')
        strTit = 'Field=Data'
        strMsg = '%FilePrefix:%FieldId=''' & CLIP(ra%FilePrefix:%FieldId) & ''''
        MESSAGE(strMsg, strTit, ICON:HAND)
          #OF('TYPE')
          #ELSE
        strTit = 'Field=Data'
        strMsg = '%FilePrefix:%FieldId=''' & CLIP(ra%FilePrefix:%FieldId) & ''''
        MESSAGE(strMsg, strTit, ICON:HAND)
          #ENDCASE
        #ENDIF
      #ENDIF
    #ENDFOR
  #ENDIF
#ENDIF
        !RAS.1999.08.20 - Salvage as many records as you can.
        !CLOSE(%File) #<! Close Destination
        !CLOSE(ra%File) #<! Close Source
        !RETURN(1) #<! Return Error
      END
      Window{PROP:Timer} = 1 #<! Enable Timer

    END #<! CASE EVENT:Timer
  END #<! End ACCEPT
  CLOSE(Window) #<! Close Window

  CLOSE(%File) #<! Close Destination
  CLOSE(ra%File) #<! Close Source
  RETURN(0) #<! Return Good

!
! Procedure:    raDOne%File
! Purpose:      Dump %FileDescription
! NOTE:         Dump this file only Interface
!
raDOne%File PROCEDURE
  CODE
  GLO:EI_ADir   = raAscSetDir('Select location of ''%File.%optExt'' Export')
  RETURN(raDump%File())

!
! Procedure:    raLOne%File
! Purpose:      Load %FileDescription
! NOTE:         Load this file only interface
!
raLOne%File PROCEDURE
  CODE
  GLO:EI_ADir   = raAscSetDir('Select location of ''%File.%optExt'' Import')
  RETURN(raLoad%File())

!---------------------------------------------------------------------
!---------------------------------------------------------------------
!EOF
    #CLOSE (%RaWorkName)
    #REPLACE (%RaFileName, %RaWorkName)
    #REMOVE (%RaWorkName)
#!=1234567890
#ENDFOR
#ENDAT
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#AT(%AfterGlobalIncludes)
#ENDAT
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#AT(%GlobalMap)
!RA-BEG: GlobalMap (zDumpLoad)
MODULE('Win00')
#INDENT(-5)
Access                 PROCEDURE(*CSTRING,SHORT),SHORT,RAW,NAME('_access')
#INDENT(5)
END

MODULE('%RaFileDo00')
#INDENT(-5)
raCountChar            PROCEDURE(STRING,STRING),LONG
raFileDrv2Ext          PROCEDURE(STRING),STRING
raFileClean            PROCEDURE(STRING),STRING
raFileExists           PROCEDURE(STRING),BYTE
raAscSetDir            PROCEDURE(STRING),STRING
raAscSetFile           PROCEDURE(STRING),STRING
raAscExists            PROCEDURE(STRING),BYTE
#!raDumpCRLF             PROCEDURE(*STRING)
#!raLoadCRLF             PROCEDURE(*STRING)
raDumpCRLF             PROCEDURE(STRING,STRING,*STRING)
raLoadCRLF             PROCEDURE(STRING,STRING,*STRING)
raHEXUnpack            PROCEDURE(*STRING,BYTE)
raHEXPack              PROCEDURE(*BYTE,STRING)
raDumpHEX              PROCEDURE(*STRING,STRING,LONG)
raLoadHEX              PROCEDURE(*STRING,STRING,LONG)
raDumpAll              PROCEDURE(),LONG
raLoadAll              PROCEDURE(),LONG
raCountExport          PROCEDURE(),LONG
raCountImport          PROCEDURE(),LONG
#INDENT(5)
END
#!--------------------------------------------------------------------!
#! 2001.09.07.FRI - Roberto Artigas Jr.                               !
#! Changed module name generation to avoid duplicates at 8.3 time.    !
#!--------------------------------------------------------------------!
#SET (%PassCount,0)                                         #! RAS.2001.09.07
#FOR (%DoTheseFiles)                                        #! RAS.2001.01.18
  #FIND(%File, %DoThisFile)                                 #! RAS.2001.01.18
  #SET(%RaClipName, %FilePrefix)                            #! RAS.2001.01.18
  #SET (%PassCount, %PassCount + 1)                         #! RAS.2001.09.07
  #SET (%RaClipName, FORMAT(%PassCount,@N05))               #! RAS.2001.09.07
  #SET(%RaFileName, %RaClipName & '.clw')                   #! RAS.2001.01.18
MODULE('EI_%RaFileName')
#INDENT(-5)
raDump%[16]File PROCEDURE(),LONG
raLoad%[16]File PROCEDURE(),LONG
raDOne%[16]File PROCEDURE(),LONG
raLOne%[16]File PROCEDURE(),LONG
#INDENT(5)
END
#ENDFOR
!RA-END: GlobalMap (zDumpLoad)
#ENDAT
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#AT(%BeforeFileDeclarations)
!RA-BEG: BeforeFileDeclarations (zDumpLoad)
GLO:EI_FDir            STRING(256) #<! Data Files Directory
GLO:EI_FFile           STRING(256) #<! Data Files Full Path
GLO:EI_ADir            STRING(256) #<! CSV Files Directory
GLO:EI_AFile           STRING(256) #<! CSV Files Full Path
#IF(%optFileGlo)
  #DECLARE(%MoreFiles),MULTI,UNIQUE
  #FOR (%File)
    #SET(%LocB,INSTRING('RAEIFILE(',%FileUserOptions,1,1))
    #SET(%LocE,INSTRING(')',%FileUserOptions,1,%LocB))
    #SET(%UserOpt,SUB(%FileUserOptions,%LocB,%LocE))
    #!SET(%UserOpt,EXTRACT(%FileUserOptions,'RAEIFILE'))
    #SET(%FileOpt,EXTRACT(%UserOpt,'RAEIFILE',1))
#! %File: %LocB-%LocE: %UserOpt, %FileOpt
#! %File: %UserOpt, %FileOpt
    #IF(UPPER(%FileOpt)='NO')
      #CYCLE
    #ENDIF
    #IF(SUB(%FileName,1,1)<>'''')
      #IF(SUB(%FileName,1,1)<>'')
        #ADD(%MoreFiles,%FileName)
      #ELSE
! DUMPLOAD WARNING: '%File' HAS NO filename in the dictionary Full Path.
      #END
    #ENDIF
  #ENDFOR
  #FOR (%MoreFiles)
    #FIND(%File,%MoreFiles)                                 #! RAS.2001.01.18
%[22]MoreFiles STRING(256)
  #ENDFOR
#ENDIF
!RA-END: BeforeFileDeclarations (zDumpLoad)
#ENDAT
#!---------------------------------------------------------------------
#GROUP(%zDumpLoadEnd)
#!---------------------------------------------------------------------

#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#CONTROL(zDumpAll,'2001.01.18: Export All Tables'),REQ(zDumpLoad),WINDOW,MULTI
#!---------------------------------------------------------------------
#BOXED('Export ALL Tables')
  #DISPLAY('Copyright © 1999-2999 by Roberto Artigas Jr.')
  #DISPLAY('All Rights Reserved World Wide')
  #DISPLAY('')
  #DISPLAY('Creates a button control to export all files.')
#ENDBOXED
#!---------------------------------------------------------------------
  CONTROLS
    BUTTON('Export All'),AT(,,80,14),USE(?btnDumpAll),MSG('Export all files.'),TIP('Export all files.')
  END
#!---------------------------------------------------------------------
#LOCALDATA
#ENDLOCALDATA
#!---------------------------------------------------------------------
#ATSTART
#DECLARE(%ctlDumpAll)
#FOR(%Control),WHERE(%ControlInstance=%ActiveTemplateInstance)
  #SET(%ctlDumpAll,%Control)
  #BREAK
#ENDFOR
#ENDAT
#!---------------------------------------------------------------------
#AT(%ControlEventHandling,%ctlDumpAll,'Accepted')
!BOE: ctlDumpAll
IF raDumpAll() THEN
#EMBED(%ctlDumpAllEr,'RAEI: Dump All: Errors'),%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActiveTemplateInstanceDescription)
ELSE
#EMBED(%ctlDumpAllOk,'RAEI: Dump All: Okay'),%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActiveTemplateInstanceDescription)
END
!EOE: ctlDumpAll
#ENDAT
#!
#!---------------------------------------------------------------------
#GROUP(%zDumpAllEnd)
#!---------------------------------------------------------------------

#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#CONTROL(zLoadAll,'2001.01.18: Import All Tables'),REQ(zDumpLoad),WINDOW,MULTI
#!---------------------------------------------------------------------
#BOXED('Import All Tables')
  #DISPLAY('Copyright © 1999-2999 by Roberto Artigas Jr.')
  #DISPLAY('All Rights Reserved World Wide')
  #DISPLAY('')
  #DISPLAY('Creates a button control to import all files.')
#ENDBOXED
#!---------------------------------------------------------------------
  CONTROLS
    BUTTON('Import All'),AT(,,80,14),USE(?btnLoadAll),MSG('Import all files.'),TIP('Import all files.')
  END
#!---------------------------------------------------------------------
#LOCALDATA
#ENDLOCALDATA
#!---------------------------------------------------------------------
#ATSTART
#DECLARE(%ctlLoadAll)
#FOR(%Control),WHERE(%ControlInstance=%ActiveTemplateInstance)
  #SET(%ctlLoadAll,%Control)
  #BREAK
#ENDFOR
#ENDAT
#!---------------------------------------------------------------------
#AT(%ControlEventHandling,%ctlLoadAll,'Accepted')
!BOE: ctloadAll
IF raLoadAll() THEN
#EMBED(%ctlLoadAllEr,'RAEI: Load All: Errors'),%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActiveTemplateInstanceDescription)
ELSE
#EMBED(%ctlLoadAllOk,'RAEI: Load All: Okay'),%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActiveTemplateInstanceDescription)
END
!EOE: ctlLoadAll
#ENDAT
#!---------------------------------------------------------------------
#GROUP(%zLoadAllEnd)
#!---------------------------------------------------------------------

#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#CONTROL(zDumpSelected,'2001.01.18: Export Selected Tables'),REQ(zDumpLoad),WINDOW,MULTI
#!---------------------------------------------------------------------
#PREPARE
#DECLARE(%AllowedTables),MULTI,UNIQUE
#FOR(%DoTheseFiles)                                         #! RAS.2001.01.18
  #ADD(%AllowedTables,%DoThisFile)                          #! RAS.2001.01.18
#ENDFOR                                                     #! RAS.2001.01.18
#ENDPREPARE
#!---------------------------------------------------------------------
#BOXED('Export Selected Tables')
  #DISPLAY('Copyright © 1999-2999 by Roberto Artigas Jr.')
  #DISPLAY('All Rights Reserved World Wide')
  #DISPLAY('')
  #DISPLAY('Creates a button control to export selected files.')
  #BUTTON('Select Tables For Export'),MULTI(%SelectedTables,%SelectedTable)
   #PROMPT('Selected Table:',FROM(%AllowedTables)),%SelectedTable,REQ,DEFAULT('')
  #ENDBUTTON
#ENDBOXED
#!---------------------------------------------------------------------
  CONTROLS
    BUTTON('Export Selected'),AT(,,80,14),USE(?btnDumpSelected),MSG('Export selected files.'),TIP('Export selected files.')
  END
#!---------------------------------------------------------------------
#LOCALDATA
#ENDLOCALDATA
#!---------------------------------------------------------------------
#ATSTART
#DECLARE(%ctlDumpSelected)
#FOR(%Control),WHERE(%ControlInstance=%ActiveTemplateInstance)
  #SET(%ctlDumpSelected,%Control)
  #BREAK
#ENDFOR
#ENDAT
#!---------------------------------------------------------------------
#AT(%ControlEventHandling,%ctlDumpSelected,'Accepted')
#DECLARE(%SortedTables),MULTI,UNIQUE
#FREE(%SortedTables)
#FOR(%SelectedTables)
  #ADD(%SortedTables,%SelectedTable)
#ENDFOR
!BOE: btnDumpSelected
GLO:EI_ADir = raAscSetDir('Export-To Directory for ASCII files.')
Errors#     = 0
#FOR(%SortedTables)
Errors#    += raDump%SortedTables()
#ENDFOR
IF (Errors# > 0) THEN
#EMBED(%btnDumpSelectedEr,'RAEI: Dump Selected: Errors'),%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActiveTemplateInstanceDescription)
ELSE
#EMBED(%btnDumpSelectedOk,'RAEI: Dump Selected: Okay'),%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActiveTemplateInstanceDescription)
END
!EOE: btnDumpSelected
#ENDAT
#!---------------------------------------------------------------------
#GROUP(%zDumpSelectedEnd)
#!---------------------------------------------------------------------

#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#CONTROL(zLoadSelected,'2001.01.18: Import Selected Tables'),REQ(zDumpLoad),WINDOW,MULTI
#!---------------------------------------------------------------------
#PREPARE
#DECLARE(%AllowedTables),MULTI,UNIQUE
#FOR(%DoTheseFiles)                                         #! RAS.2001.01.18
  #ADD(%AllowedTables,%DoThisFile)                          #! RAS.2001.01.18
#ENDFOR                                                     #! RAS.2001.01.18
#ENDPREPARE
#!---------------------------------------------------------------------
#BOXED('Import Selected Tables')
  #DISPLAY('Copyright © 1999-2999 by Roberto Artigas Jr.')
  #DISPLAY('All Rights Reserved World Wide')
  #DISPLAY('')
  #DISPLAY('Creates a button control to import selected files.')
  #BUTTON('Select Tables For Import'),MULTI(%SelectedTables,%SelectedTable)
   #PROMPT('Selected Table:',FROM(%AllowedTables)),%SelectedTable,REQ,DEFAULT('')
  #ENDBUTTON
#ENDBOXED
#!---------------------------------------------------------------------
  CONTROLS
    BUTTON('Import Selected'),AT(,,80,14),USE(?btnLoadSelected),MSG('Import selected files.'),TIP('Import selected files.')
  END
#!---------------------------------------------------------------------
#LOCALDATA
#ENDLOCALDATA
#!---------------------------------------------------------------------
#ATSTART
#DECLARE(%ctlLoadSelected)
#FOR(%Control),WHERE(%ControlInstance=%ActiveTemplateInstance)
  #SET(%ctlLoadSelected,%Control)
  #BREAK
#ENDFOR
#ENDAT
#!---------------------------------------------------------------------
#AT(%ControlEventHandling,%ctlLoadSelected,'Accepted')
#DECLARE(%SortedTables),MULTI,UNIQUE
#FREE(%SortedTables)
#FOR(%SelectedTables)
  #ADD(%SortedTables,%SelectedTable)
#ENDFOR
!BOE: btnLoadSelected
GLO:EI_ADir = raAscSetDir('Import-From Directory for ASCII files.')
Errors#     = 0
#FOR(%SortedTables)
Errors#    += raLoad%SortedTables()
#ENDFOR
IF (Errors# > 0) THEN
#EMBED(%btnLoadSelectedEr,'RAEI: Load Selected: Errors'),%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActiveTemplateInstanceDescription)
ELSE
#EMBED(%btnLoadSelectedOk,'RAEI: Load Selected: Okay'),%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActiveTemplateInstanceDescription)
END
!EOE: btnLoadSelected
#ENDAT
#!---------------------------------------------------------------------
#GROUP(%zLoadSelectedEnd)
#!---------------------------------------------------------------------

#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#EXTENSION(zDumpLoadGroup,'2002.01.30: Group Dump and Load Tables'),REQ(ZDumpLoad),APPLICATION
#!---------------------------------------------------------------------
#INSERT(%PreambleDUMPLOAD)
#SHEET,HSCROLL
#INSERT(%MITLicenseDUMPLOAD)
#!---------------------------------------------------------------------
#PREPARE
#DECLARE(%TheCLW)
#SET(%TheCLW,SUB(%Application,1,5) & '_gl.clw')
#ENDPREPARE
#!---------------------------------------------------------------------
#TAB ('Group Dump and Load Procedures')
#BOXED('')
  #!DISPLAY('Copyright © 1999-2999 by Roberto Artigas Jr.')
  #!DISPLAY('All Rights Reserved World Wide')
  #!DISPLAY('')
  #!DISPLAY('I can be reached at: roberto.artigas.dev@gmail.com')
  #!DISPLAY('')
  #DISPLAY('WARNING: THIS HAS NOT BEEN LOOKED AT IN 18+ YEARS (TESTING ON IT)'),PROP(PROP:FontStyle,700)
  #DISPLAY('')
  #DISPLAY('This template looks at your dictionary and automagically')
  #DISPLAY('creates all the routines and modules to export/import')
  #DISPLAY('groups of data tables to comma delimited (CSV) files.')
  #DISPLAY('')
  #DISPLAY('File group options have a maximum of ten paramaters:')
  #DISPLAY('')
  #DISPLAY('With 1 parameter: RAEIGROUP(1)')
  #DISPLAY('With 2 parameters: RAEIGROUP(1,2)')
  #DISPLAY('With 3 parameters: RAEIGROUP(1,2,3)')
  #DISPLAY('With 4 parameters: RAEIGROUP(1,2,3,4)')
  #DISPLAY('With 5 parameters: RAEIGROUP(1,2,3,4,5)')
  #DISPLAY('And so on, until a maximum of ten.')
  #DISPLAY('')
  #DISPLAY('Group Dump/Load procedure names will be created in')
  #DISPLAY('a file called    ' & UPPER(%TheCLW) & '   and will look like:')
  #DISPLAY('')
  #DISPLAY('For Dump groups: raDumpGroup_001')
  #DISPLAY('For Load groups: raLoadGroup_001')
  #DISPLAY('')
#ENDBOXED
  #BOXED(''),HIDE
    #BUTTON('Dump/Load Group Options'),MULTI(%Groupings,%GroupFile & ' ' & %GroupList),INLINE,AT(,,,240)
      #PROMPT('File Name: ',@S30), %GroupFile, REQ
      #PROMPT('File Groups: ',@S30), %GroupList, REQ
    #ENDBUTTON
    #PROMPT('GEnd',@N01),%GEnd,DEFAULT(0)
    #PROMPT('GCnt',@N04),%GCnt
#!    #PROMPT('UOpt',@S30),%UOpt                            #! RAS.2001.01.18
#!    #PROMPT('FOpt',@s30),%FOpt                            #! RAS.2001.01.18
    #PROMPT('GLst',@S30),%GLst
    #BUTTON('Dump/Load Group List'),MULTI(%RaEiList,%RaEiItem),INLINE,AT(,,,240)
      #PROMPT('List Item: ',@S30), %RaEIItem, REQ
    #ENDBUTTON
  #ENDBOXED
#ENDTAB
#ENDSHEET
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#ATSTART
#ENDAT
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#AT(%CustomGlobalDeclarations)
#DECLARE (%RaEiSort),UNIQUE
#DECLARE (%RaFileDo01, STRING)
#DECLARE (%RaFileList, STRING)
#DECLARE (%RaClipList, STRING)
#DECLARE (%RaWorkList, STRING)
#!
#DECLARE (%GOpts,      STRING)                              #! Group Options [RAEIGROUP]
#DECLARE (%GOpt0,      LONG)                                #! RAEIGROUP(1)
#DECLARE (%GOpt1,      LONG)                                #! RAEIGROUP(?,2)
#DECLARE (%GOpt2,      LONG)                                #! RAEIGROUP(?,?,3)
#DECLARE (%GOpt3,      LONG)                                #! RAEIGROUP(?,?,?,4)
#DECLARE (%GOpt4,      LONG)                                #! RAEIGROUP(?,?,?,?,5)
#DECLARE (%GOpt5,      LONG)                                #! RAEIGROUP(?,?,?,?,?,6)
#DECLARE (%GOpt6,      LONG)                                #! RAEIGROUP(?,?,?,?,?,?,7)
#DECLARE (%GOpt7,      LONG)                                #! RAEIGROUP(?,?,?,?,?,?,?,8)
#DECLARE (%GOpt8,      LONG)                                #! RAEIGROUP(?,?,?,?,?,?,?,?,9)
#DECLARE (%GOpt9,      LONG)                                #! RAEIGROUP(?,?,?,?,?,?,?,?,?,10)
#DECLARE (%GSort,      STRING)                              #! RAEILIST(Group,File)
#DECLARE (%GName,      STRING)                              #! File Name for list
#DECLARE (%GItem,      STRING)                              #! Group number for list
#DECLARE (%GSave,      STRING)                              #! Save group for compare
#!
#COMMENT(49)
#!
#SET (%RaClipList, SUB(%Application, 1, 5))
#SET (%RaFileDo01, %RaClipList & '_gl.clw')
#SET (%RaWorkList, %RaClipList & '_gl.$$$')
#MESSAGE('Building Group Export/Import Module', 1)
#MESSAGE('Creating: ' & %RaFileDo01, 2)
#PROJECT(%RaFileDo01)
#CREATE(%RaWorkList)
!BOF
!---------------------------------------------------------------------
!---------------------------------------------------------------------
! File:         %RaFileDo01
! Purpose:      Dump and Load File Groups
! Creator:      2001.01.13 - Roberto Artigas
! Copyright:    1999-2999 (c) by Roberto Artigas Jr
!               All Rights Reserved World Wide
!---------------------------------------------------------------------
  MEMBER('%Application.clw')

  #!-------------------------------------------------!
  #! Begin building the assorted group options list. !
  #!-------------------------------------------------!
  #SET (%GCnt, 0)
  #FOR (%DoTheseFiles)                                      #! RAS.2001.01.18
    #FIND(%File, %DoThisFile)                               #! RAS.2001.01.18
    #MESSAGE('File Name: ' & %File, 3)                      #! Processing message
    #SET(%GLst,'')
    #SET(%LocB,INSTRING('RAEIGROUP(',%FileUserOptions,1,1))
    #SET(%LocE,INSTRING(')',%FileUserOptions,1,%LocB))
    #SET(%GLst,SUB(%FileUserOptions,%LocB,%LocE))
    #!SET(%GLst,EXTRACT(%FileUserOptions,'RAEIGROUP'))
#! File: "%File", GLst: "%GLst", FileUserOptions: "%FileUserOptions"
    #IF(%GLst<>'')
      #SET(%GCnt, %GCnt + 1)
      #ADD(%Groupings, %GCnt)
      #SET(%GroupFile, %File)
      #SET(%GroupList, %GLst)
    #ENDIF
  #ENDFOR
  #!--------------------------------------------------------------------!
  #! RAS.2001.01.14 - Increased number of groups per file to 10 groups. !
  #! If you need more, you better go to better backup methods.          !
  #!--------------------------------------------------------------------!
  #IF(ITEMS(%Groupings))
    #SET (%GCnt, 0)
    #FOR(%Groupings)
      #SET(%GOpts,EXTRACT(%GroupList,'RAEIGROUP'))
      #SET(%GOpt0,EXTRACT(%GOpts,'RAEIGROUP',1))
      #SET(%GOpt1,EXTRACT(%GOpts,'RAEIGROUP',2))
      #SET(%GOpt2,EXTRACT(%GOpts,'RAEIGROUP',3))
      #SET(%GOpt3,EXTRACT(%GOpts,'RAEIGROUP',4))
      #SET(%GOpt4,EXTRACT(%GOpts,'RAEIGROUP',5))
      #SET(%GOpt5,EXTRACT(%GOpts,'RAEIGROUP',6))            #! RAS.2001.01.14
      #SET(%GOpt6,EXTRACT(%GOpts,'RAEIGROUP',7))            #! RAS.2001.01.14
      #SET(%GOpt7,EXTRACT(%GOpts,'RAEIGROUP',8))            #! RAS.2001.01.14
      #SET(%GOpt8,EXTRACT(%GOpts,'RAEIGROUP',9))            #! RAS.2001.01.14
      #SET(%GOpt9,EXTRACT(%GOpts,'RAEIGROUP',10))           #! RAS.2001.01.14
      #IF(%GOpt0 > 0)
        #SET(%GCnt,%GCnt+1)
        #ADD(%RaEiList,%GCnt)
        #SET(%RaEiItem,'RAEILIST(' & FORMAT(%GOpt0,@N03) & ',' & %GroupFile & ')')
      #ENDIF
      #IF(%GOpt1 > 0)
        #SET(%GCnt,%GCnt+1)
        #ADD(%RaEiList,%GCnt)
        #SET(%RaEiItem,'RAEILIST(' & FORMAT(%GOpt1,@N03) & ',' & %GroupFile & ')')
      #ENDIF
      #IF(%GOpt2 > 0)
        #SET(%GCnt,%GCnt+1)
        #ADD(%RaEiList,%GCnt)
        #SET(%RaEiItem,'RAEILIST(' & FORMAT(%GOpt2,@N03) & ',' & %GroupFile & ')')
      #ENDIF
      #IF(%GOpt3 > 0)
        #SET(%GCnt,%GCnt+1)
        #ADD(%RaEiList,%GCnt)
        #SET(%RaEiItem,'RAEILIST(' & FORMAT(%GOpt3,@N03) & ',' & %GroupFile & ')')
      #ENDIF
      #IF(%GOpt4 > 0)
        #SET(%GCnt,%GCnt+1)
        #ADD(%RaEiList,%GCnt)
        #SET(%RaEiItem,'RAEILIST(' & FORMAT(%GOpt4,@N03) & ',' & %GroupFile & ')')
      #ENDIF
      #IF(%GOpt5 > 0)                                       #! RAS.2001.01.14
        #SET(%GCnt,%GCnt+1)
        #ADD(%RaEiList,%GCnt)
        #SET(%RaEiItem,'RAEILIST(' & FORMAT(%GOpt5,@N03) & ',' & %GroupFile & ')')
      #ENDIF
      #IF(%GOpt6 > 0)                                       #! RAS.2001.01.14
        #SET(%GCnt,%GCnt+1)
        #ADD(%RaEiList,%GCnt)
        #SET(%RaEiItem,'RAEILIST(' & FORMAT(%GOpt6,@N03) & ',' & %GroupFile & ')')
      #ENDIF
      #IF(%GOpt7 > 0)                                       #! RAS.2001.01.14
        #SET(%GCnt,%GCnt+1)
        #ADD(%RaEiList,%GCnt)
        #SET(%RaEiItem,'RAEILIST(' & FORMAT(%GOpt7,@N03) & ',' & %GroupFile & ')')
      #ENDIF
      #IF(%GOpt8 > 0)                                       #! RAS.2001.01.14
        #SET(%GCnt,%GCnt+1)
        #ADD(%RaEiList,%GCnt)
        #SET(%RaEiItem,'RAEILIST(' & FORMAT(%GOpt8,@N03) & ',' & %GroupFile & ')')
      #ENDIF
      #IF(%GOpt9 > 0)                                       #! RAS.2001.01.14
        #SET(%GCnt,%GCnt+1)
        #ADD(%RaEiList,%GCnt)
        #SET(%RaEiItem,'RAEILIST(' & FORMAT(%GOpt9,@N03) & ',' & %GroupFile & ')')
      #ENDIF
    #ENDFOR
  #ENDIF
  #!
  #FREE(%RaEiSort)
  #FOR(%RaEiList)
    #ADD(%RaEISort,%RaEiItem)
  #ENDFOR
  #FREE(%RaEiList)
  #SET(%GCnt,0)
  #FOR(%RaEiSort)
    #SET(%GCnt,%GCnt+1)
    #ADD(%RaEiList,%GCnt)
    #SET(%RaEiItem,%RaEiSort)
  #ENDFOR
  #!
  #IF(ITEMS(%RaEiList))
    #SET(%GSave,'')
    #FOR(%RaEiList)
      #SET(%GOpts,EXTRACT(%RaEiItem,'RAEILIST'))
      #SET(%GItem,EXTRACT(%GOpts,'RAEILIST',1))
      #SET(%GName,EXTRACT(%GOpts,'RAEILIST',2))
      #FIND(%File,%GName)
#! %GOpts: "%GSave"  "%GItem"  "%GName"
      #MESSAGE('Group Item: ' & %GItem, 3)
      #IF(%GSave = '')
        #SET(%GSave, %GItem)
!--------------------------------------------------------------------!
! Group Dump Procedures                                              !
!--------------------------------------------------------------------!
raDumpGroup_%[7]GSave PROCEDURE
lngCount%[11]NULL LONG(0)
  CODE
#!GLO:EI_ADir = raAscSetDir('Select Export-To Directory for %optExt files.')
  GLO:EI_ADir%[6]NULL = raAscSetDir('Select Export-To Directory for %GSave group files.')
      #ENDIF
      #IF(%GSave <> %GItem)
        #SET(%GSave, %GItem)
  RETURN (lngCount)
!
raDumpGroup_%[7]GSave PROCEDURE
lngCount%[11]NULL LONG(0)
  CODE
#!GLO:EI_ADir = raAscSetDir('Select Export-To Directory for %optExt files.')
  GLO:EI_ADir%[6]NULL = raAscSetDir('Select Export-To Directory for %GSave group files.')
      #ENDIF
  lngCount%[8]NULL += raDump%File() #<! %FileDescription
    #ENDFOR
  RETURN (lngCount)

    #SET(%GSave,'')
    #FOR(%RaEiList)
      #SET(%GOpts,EXTRACT(%RaEiItem,'RAEILIST'))
      #SET(%GItem,EXTRACT(%GOpts,'RAEILIST',1))
      #SET(%GName,EXTRACT(%GOpts,'RAEILIST',2))
      #FIND(%File,%GName)
#! %GOpts: "%GSave"  "%GItem"  "%GName"
      #MESSAGE('Group Item: ' & %GItem, 3)
      #IF(%GSave = '')
        #SET(%GSave, %GItem)
!--------------------------------------------------------------------!
! Group Load Procedures                                              !
!--------------------------------------------------------------------!
raLoadGroup_%[7]GSave PROCEDURE
lngCount%[11]NULL LONG(0)
  CODE
#!GLO:EI_ADir = raAscSetDir('Select Import-From Directory for %optExt files.')
  GLO:EI_ADir%[6]NULL = raAscSetDir('Select Import-From Directory for %GSave group files.')
      #ENDIF
      #IF(%GSave <> %GItem)
        #SET(%GSave, %GItem)
  RETURN (lngcount)
!
raLoadGroup_%[7]GSave PROCEDURE
lngCount%[11]NULL LONG(0)
  CODE
#!GLO:EI_ADir = raAscSetDir('Select Import-From Directory for %optExt files.')
  GLO:EI_ADir%[6]NULL = raAscSetDir('Select Import-From Directory for %GSave group files.')
      #ENDIF
#! RAS.2002.01.30 - Changed 'raDump' to 'raLoad' (error)
  lngCount%[8]NULL += raLoad%File() #<! %FileDescription
    #ENDFOR
  RETURN (lngCount)
  #ENDIF
!---------------------------------------------------------------------
!---------------------------------------------------------------------
!EOF
#CLOSE(%RaWorkList)
#REPLACE(%RaFileDo01, %RaWorkList)
#REMOVE(%RaWorkList)
#ENDAT
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#AT(%GlobalMap)
!RA-BEG: GlobalMap (zDumpLoadGroup)
MODULE('%RaFileDo01')
#INDENT(-5)
#IF(ITEMS(%RaEiList))
  #SET(%GSave,'')
  #FOR(%RaEiList)
    #SET(%GOpts,EXTRACT(%RaEiItem,'RAEILIST'))
    #SET(%GItem,EXTRACT(%GOpts,'RAEILIST',1))
    #SET(%GName,EXTRACT(%GOpts,'RAEILIST',2))
    #IF(%GSave = %GItem)
      #CYCLE
    #END
    #SET(%GSave,%GItem)
raDumpGroup_%[10]GItem PROCEDURE(),LONG
raLoadGroup_%[10]GItem PROCEDURE(),LONG
  #ENDFOR
#ENDIF
#INDENT(5)
END
!RA-END: GlobalMap (zDumpLoadGroup)
#ENDAT
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#AT(%BeforeFileDeclarations)
#ENDAT
#!---------------------------------------------------------------------
#GROUP(%zDumpLoadGroupEnd)
#!---------------------------------------------------------------------

#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#EXTENSION(zTpl_DumpLoad,'2001.01.23: Dumpload Template Generator'),REQ(zDumpLoad),MULTI
#!---------------------------------------------------------------------
#INSERT(%PreambleDUMPLOAD)
#SHEET,HSCROLL
#INSERT(%MITLicenseDUMPLOAD)
#INSERT(%ExplainUtilDUMPLOADTPL)
#INSERT(%ShowExplainUtilDUMPLOADTPL)
#TAB ('Dumpload Template Generator')
#BOXED('')
  #!DISPLAY('Copyright © 1999-2999 by Roberto Artigas Jr.')
  #!DISPLAY('All Rights Reserved World Wide')
  #!DISPLAY('')
  #!DISPLAY('WARNING: THIS HAS NOT BEEN LOOKED AT IN 18+ YEARS (TESTING ON IT)'),PROP(PROP:FontStyle,700)
  #!DISPLAY('')
  #PROMPT('Template Description: ',@s60),%TPLDesc,REQ,DEFAULT(UPPER(%Application) & ': Application Comment')
  #DISPLAY('')
  #BOXED('Generate Code Templates')
  #PROMPT('For ALL files Dump''ed and Load''ed? ',CHECK),%GenCodeAll,DEFAULT(1),AT(10)
  #PROMPT('For each file Dump''ed and Load''ed? ',CHECK),%GenCodeEach,DEFAULT(1),AT(10)
  #ENDBOXED
  #DISPLAY('')
  #BOXED('Generate Button Templates')
  #PROMPT('For ALL files Dump''ed and Load''ed? ',CHECK),%GenBtnAll,DEFAULT(1),AT(10)
  #PROMPT('For each file Dump''ed and Load''ed? ',CHECK),%GenBtnEach,DEFAULT(1),AT(10)
  #ENDBOXED
#ENDBOXED
#ENDTAB
#ENDSHEET
#BOXED(''),HIDE
  #PROMPT('For all general procedures? ',CHECK),%GenCodeProc,DEFAULT(0),AT(10)
  #PROMPT('For all general procedures? ',CHECK),%GenBtnProc,DEFAULT(0),AT(10)
#ENDBOXED
#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#AT(%CustomGlobalDeclarations)
  #DECLARE(%x)
  #DECLARE(%y)
  #DECLARE(%counter)
  #DECLARE(%FileName1)
  #DECLARE(%FileName2)
  #DECLARE(%ClipName)
  #DECLARE(%AllProto)
  #DECLARE(%OneProto)
  #DECLARE(%ListDriver),UNIQUE
  #DECLARE(%ASCIIFileRecord)
  #DECLARE(%TemplateLine)
  #DECLARE(%RangeNumber)
  #DECLARE(%LongName)
  #DECLARE(%Family)
#!
  #IF(SUB(%CwTemplateVersion,1,2) = 'v2')
    #SET(%Family,'CW20')
  #ELSE
    #SET(%Family,'ABC')
  #ENDIF
#!
  #DECLARE(%GroupVar)
  #DECLARE(%ProjectName)
  #DECLARE(%TemplateSet)
  #DECLARE(%TemplateName)
  #DECLARE(%CodeDesc)
  #DECLARE(%CodeCmnt)
  #DECLARE(%PlProc)
  #DECLARE(%PLDesc)
  #DECLARE(%LDescr)
  #DECLARE(%LDBeg,LONG)
  #DECLARE(%LDEnd,LONG)
  #DECLARE(%LDCnt,LONG)
  #DECLARE(%LDaSP,LONG)
  #DECLARE(%LDaCR,LONG)
  #DECLARE(%LDaLF,LONG)
#!
  #SET(%ProjectName,UPPER(%Application))
  #SET(%ClipName,SUB(%ProjectName,1,5))
  #SET(%TemplateSet,'RA_DL')
  #SET(%TemplateName,'DL_' & %ClipName)
#!
#INSERT(%MakeTemplate)
#ENDAT
#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#GROUP(%MakeTemplate)
#IF(%TemplateName)
  #SET(%FileName1,UPPER(%TemplateName))
  #IF(INSTRING('.',%FileName1,1,1) = 0)
    #SET(%FileName1,UPPER(%TemplateName) & '.TPW')
  #ENDIF
  #SET(%FileName2, %TemplateSet & '.$$$')
  #CREATE(%FileName2)
#INSERT(%MakeTemplateBody)
  #CLOSE(%FileName2)
  #REPLACE(%FileName1,%FileName2)
  #IF(%TemplateSet <> '')
    #SET(%Counter,0)
    #SET(%TemplateLine,'#INCLUDE(''' & %FileName1 & ''')')
    #SET(%FileName2,%TemplateSet)
    #IF(INSTRING('.',%FileName2,1,1) = 0)
      #SET(%FileName2,UPPER(%TemplateSet) & '.TPL')
    #ENDIF
    #IF(FILEEXISTS(%FileName2) = 0)
      #CREATE(%FileName2)
#INSERT(%MakeTemplateSetBody)
      #CLOSE(%FileName2)
    #ELSE
      #OPEN(%FileName2),READ
      #LOOP
        #READ(%ASCIIFileRecord)
        #IF(%ASCIIFileRecord = %TemplateLine)
          #SET(%Counter,1)
          #BREAK
        #ELSIF(%ASCIIFileRecord = %EOF)
          #BREAK
        #END
      #END
      #CLOSE(%FileName2)
      #IF(%Counter = 0)
        #OPEN(%FileName2)
#INSERT(%AddToTemplateSetBody)
        #CLOSE(%fileName2)
      #ENDIF
    #ENDIF
  #ENDIF
#ENDIF
#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#GROUP(%MakeTemplateSetBody)
  #IF(%TemplateSet<>'')
    #SET(%TemplateLine,%TemplateSet)
  #ELSE
    #SET(%TemplateLine,%TemplateName)
  #ENDIF
  #IF(INSTRING('.',%templateLine,1,1) > 0)
    #SET(%TemplateLine,SUB(%TemplateLine,1,INSTRING('.',%templateLine,1,1)-1))
  #ENDIF
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
%#TEMPLATE(%TemplateLine,'DumpLoad Generated Template Class'),FAMILY('CW20','ABC')
%#!--------------------------------------------------------------------
#INSERT(%AddToTemplateSetBody)
#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#GROUP(%AddToTemplateSetBody)
  #IF(%TemplateSet<>'')
%#INCLUDE('%FileName1')
  #ENDIF
#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#GROUP(%MakeTemplateBody)
  #IF(%TemplateSet = '')
#INSERT(%MakeTemplateSetBody)
  #ELSE
  #ENDIF
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
%#EXTENSION(DL_%ProjectName,'%TPLDesc'),APPLICATION
%#!--------------------------------------------------------------------
%#BOXED('')
  %#DISPLAY('Copyright © 1999-2999 by Roberto Artigas Jr.')
  %#DISPLAY('All Rights Reserved World Wide')
%#ENDBOXED
%#AT(%%CustomGlobalDeclarations)
  %#PROJECT('%ProjectName.LIB')
#!%#PROJECT('%ClipName.LIB')
%#ENDAT
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
#INSERT(%DLCodeFile)
#INSERT(%DLCodeCode)
%#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#GROUP(%DLCodeCode)
#IF(%GenCodeProc)
  #FOR(%Procedure)
    #CASE(%ProgramExtension)
    #OF  ('DLL')
    #OROF('LIB')
      #IF(%ProcedureExported)
#INSERT(%CodeMainLine)
      #ENDIF
    #OF  ('EXE')
      #IF(%Procedure = %FirstProcedure)
        #IF(UPPER(%Procedure) = 'MAIN')
          #CYCLE
        #ENDIF
      #ENDIF
#INSERT(%CodeMainLine)
    #ENDCASE
  #ENDFOR
#ENDIF
#!
#IF(%GenBtnProc)
  #FOR(%Procedure)
    #CASE(%ProgramExtension)
    #OF  ('DLL')
    #OROF('LIB')
      #IF(%ProcedureExported)
#INSERT(%BtnMainLine)
      #ENDIF
    #OF  ('EXE')
      #IF(%Procedure = %FirstProcedure)
        #IF(UPPER(%Procedure) = 'MAIN')
          #CYCLE
        #ENDIF
      #ENDIF
#INSERT(%BtnMainLine)
    #ENDCASE
  #ENDFOR
#ENDIF
#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#GROUP(%CodeMainLine)
  #SET(%y,0)
  #IF(%ProcedureDescription)
    #SET(%CodeDesc,UPPER(%ProjectName) & ': ' & %Procedure & ': ' & %ProcedureDescription)
    #SET(%CodeCmnt,UPPER(%ProjectName) & ': ' & %ProcedureDescription)
  #ELSE
    #SET(%CodeDesc,UPPER(%ProjectName) & ': ' & %Procedure & ': This IS NOT documented!')
    #SET(%CodeCmnt,UPPER(%ProjectName) & ': This IS NOT documented!')
  #ENDIF
%#CODE(DLC_%Procedure,'%CodeDesc')
%#SHEET,HSCROLL
  %#TAB('Parameters')
  #IF((INSTRING(')',%Prototype,1,1) < 3) OR (SUB(%Prototype,1,1) = ','))
    %#DISPLAY('This procedure takes no parameters')
    #IF(%ProcedureType <> 'FUNCTION')
    %#DISPLAY('and returns no values')
    #ENDIF
  #ELSE
    #SET(%AllProto,SUB(%Prototype,2,INSTRING(')',%Prototype,1,1)-2) & ',')
    #LOOP
      #SET(%x,INSTRING(',',%AllProto,1,1))
      #SET(%OneProto,SUB(%AllProto,1,%x-1))
      #IF(%OneProto = '')
        #BREAK
      #ENDIF
      #SET(%OneProto,Quote(%OneProto))
      #SET(%y,%y+1)
    %#PROMPT('%OneProto p%y',@s100),%%Param%y
      #SET(%AllProto,SUB(%Allproto,%x+1,200))
    #ENDLOOP
  #ENDIF
  #SET(%x,0)
  #SET(%AllProto,'')
  #LOOP
    #IF(%x = %y)
      #BREAK
    #ENDIF
    #SET(%x,%x+1)
    #IF(%x > 1)
      #SET(%AllProto,%AllProto & ',')
    #ENDIF
    #SET(%AllProto,%AllProto & '%param' & %x)
  #ENDLOOP
  #IF(%ProcedureType = 'FUNCTION')
    %#PROMPT('Return Variable',@s100),%%ReturnIn
  #ENDIF
  %#ENDTAB
  %#TAB('Documentation')
    %#DISPLAY('Routine is: %Procedure')
    %#DISPLAY('Located in: %Application')
    %#DISPLAY('')
    #SET(%PLProc,%Procedure)
    #SET(%PLDesc,%ProcedureLongDescription)
    #INSERT(%CodeLDescr)
  %#ENDTAB
%#ENDSHEET
  #IF(%ProcedureType = 'FUNCTION')
%%ReturnIn = %Procedure(%AllProto) %#<! %CodeCmnt
  #ELSE
%Procedure(%AllProto) %#<! %CodeCmnt
  #ENDIF
  #SET(%GroupVar,'%DLC' & %Procedure & 'End')
%#GROUP(%GroupVar)
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#GROUP(%BtnMainLine)
  #SET(%y,0)
  #IF(%ProcedureDescription)
    #SET(%CodeDesc,UPPER(%ProjectName) & ': Button: ' & %Procedure & ': ' & %ProcedureDescription)
    #SET(%CodeCmnt,UPPER(%ProjectName) & ': ' & %ProcedureDescription)
  #ELSE
    #SET(%CodeDesc,UPPER(%ProjectName) & ': Button: ' & %Procedure & ': This IS NOT documented!')
    #SET(%CodeCmnt,UPPER(%ProjectName) & ': This IS NOT documented!')
  #ENDIF
%#CONTROL(DLCB_%Procedure,'%CodeDesc'),WINDOW,MULTI
%#SHEET,HSCROLL
  %#TAB('Parameters')
  #IF((INSTRING(')',%Prototype,1,1) < 3) OR (SUB(%Prototype,1,1) = ','))
    %#DISPLAY('This procedure takes no parameters')
    #IF(%ProcedureType <> 'FUNCTION')
    %#DISPLAY('and returns no values')
    #ENDIF
  #ELSE
    #SET(%AllProto,SUB(%Prototype,2,INSTRING(')',%Prototype,1,1)-2) & ',')
    #LOOP
      #SET(%x,INSTRING(',',%AllProto,1,1))
      #SET(%OneProto,SUB(%AllProto,1,%x-1))
      #IF(%OneProto = '')
        #BREAK
      #ENDIF
      #SET(%OneProto,Quote(%OneProto))
      #SET(%y,%y+1)
    %#PROMPT('%OneProto p%y',@s100),%%Param%y
      #SET(%AllProto,SUB(%Allproto,%x+1,200))
    #ENDLOOP
  #ENDIF
  #SET(%x,0)
  #SET(%AllProto,'')
  #LOOP
    #IF(%x = %y)
      #BREAK
    #ENDIF
    #SET(%x,%x+1)
    #IF(%x > 1)
      #SET(%AllProto,%AllProto & ',')
    #ENDIF
    #SET(%AllProto,%AllProto & '%param' & %x)
  #ENDLOOP
  #IF(%ProcedureType = 'FUNCTION')
    %#PROMPT('Return Variable',@s100),%%ReturnIn
  #ENDIF
  %#ENDTAB
  %#TAB('Documentation')
    %#DISPLAY('Routine is: %Procedure')
    %#DISPLAY('Located in: %Application')
    %#DISPLAY('')
    #SET(%PLProc,%Procedure)
    #SET(%PLDesc,%ProcedureLongDescription)
    #INSERT(%CodeLDescr)
  %#ENDTAB
%#ENDSHEET
%#!--------------------------------------------------------------------
  CONTROLS
    BUTTON('Call %Procedure'),AT(,,100,14),USE(?btn%Procedure),LEFT,ICON(''), |
      MSG('Call %Procedure.'),TIP('Call %Procedure.')
  END
%#!--------------------------------------------------------------------
%#AT(%%CustomGlobalDeclarations)
%#!#PROJECT('CallProc.Ico')
%#ENDAT
%#!--------------------------------------------------------------------
%#ATSTART
  %#DECLARE(%%btn%Procedure)
  %#FOR(%%Control),WHERE(%%ControlInstance=%%ActiveTemplateInstance)
    %#SET(%%btn%Procedure,%%Control)
  %#ENDFOR
%#ENDAT
%#!--------------------------------------------------------------------
%#AT(%%ControlEventHandling,%%btn%Procedure,'Accepted'),PRIORITY(100)
  #IF(%ProcedureType = 'FUNCTION')
%%ReturnIn = %Procedure(%AllProto) %#<! %CodeCmnt
  #ELSE
%Procedure(%AllProto) %#<! %CodeCmnt
  #ENDIF
%#ENDAT
%#!--------------------------------------------------------------------
%#AT(%%ControlEventHandling,%%btn%Procedure,'Selected'),PRIORITY(100)
%#ENDAT
%#!--------------------------------------------------------------------
  #SET(%GroupVar,'%DLCB' & %Procedure & 'End')
%#GROUP(%GroupVar)
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#! WARNING:     Do NOT allow single quotes in the long description.
#!              That action will cause generatation of bad templates.
#GROUP(%CodeLDescr)
#IF(%PLDesc)
#!
  #SET(%LDBeg,1)
  #SET(%LDEnd,50)
  #IF(LEN(CLIP(%PLDesc)) < 50)
    #SET(%LDEnd,LEN(CLIP(%PLDesc)))
  #ENDIF
  #SET(%LDCnt,0)
  #SET(%LDaSP,0)
  #SET(%LDaCR,0)
  #SET(%LDaLF,0)
#!
  #LOOP UNTIL(%LDBeg>LEN(CLIP(%PLDesc)))
    #SET(%LDescr,SUB(%PLDesc,%LDBeg,%LDEnd))
    #SET(%LDaCR,INSTRING('<13>',%LDescr,1,1))
    #IF (%LDaCR)
      #IF(%LDaCR < %LDEnd)
        #SET(%LDEnd,%LDaCR)
      #ENDIF
    #ENDIF
    #SET(%LDaLF,INSTRING('<10>',%LDescr,1,1))
    #IF (%LDaLF)
      #IF(%LDaLF < %LDEnd)
        #SET(%LDEnd,%LDaLF)
      #ENDIF
    #ENDIF
    #LOOP FOR(%LDCnt,1,50)
      #IF(SUB(%LDescr,%LDCnt,1)=' ')
        #SET(%LDaSp,%LDCnt)
      #ENDIF
    #ENDLOOP
    #IF(%LDaSP < %LDEnd)
      #IF   (%LDaCR)
      #ELSIF(%LDaLF)
      #ELSE
        #SET(%LDEnd,%LDaSP)
      #ENDIF
    #ENDIF
    #IF   (%LDaCR)
      #SET(%LDescr,SUB(%PLDesc,%LDBeg,(%LDEnd-1)))
    #ELSIF(%LDaLF)
      #SET(%LDescr,SUB(%PLDesc,%LDBeg,(%LDEnd-1)))
    #ELSE
      #SET(%LDescr,CLIP(SUB(%PLDesc,%LDBeg,%LDEnd)))
    #ENDIF
%#DISPLAY('%LDescr')
    #SET(%LDBeg,%LDBeg+%LDEnd)
    #IF(%LDaCR)
      #SET(%LDBeg,%LDBeg+1)
    #END
#!  #IF(%LDaLF)
#!    #SET(%LDBeg,%LDBeg+1)
#!  #END
    #SET(%LDEnd,50)
  #ENDLOOP
#!
#ELSE
%#DISPLAY('%PLProc: This IS NOT documented!')
#ENDIF
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#GROUP(%DLCodeFile)
#IF(%GenCodeAll)
  #SET(%CodeDesc,UPPER(%ProjectName) & ': ' & 'AllFiles' & ': This IS NOT documented!')
  #SET(%CodeCmnt,UPPER(%ProjectName) & ': This IS NOT documented!')
%#CODE(DL0_AllFiles_Dump,'%ProjectName: All Files')
%#SHEET,HSCROLL
  %#TAB('Parameters')
    %#DISPLAY('This procedure takes no parameters')
    %#DISPLAY('')
    %#PROMPT('Return Variable',@s100),%%ReturnIn,REQ,DEFAULT('RC#')
  %#ENDTAB
  %#TAB('Documentation')
    %#DISPLAY('Purpose is: Dump All Files')
    %#DISPLAY('Routine is: raDumpAll')
    %#DISPLAY('Located in: %ProjectName')
    %#DISPLAY('')
    #SET(%PLProc,'raDumpAll')
    #SET(%PLDesc,'This procedure is generated by DumpLoad.')
    #INSERT(%CodeLDescr)
  %#ENDTAB
%#ENDSHEET
%%ReturnIn = raDumpAll() %#<! Dump All Files
%#GROUP(%%DL0AllFilesDumpEnd)
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
%#CODE(DL0_AllFiles_Load,'%ProjectName: All Files')
%#SHEET,HSCROLL
  %#TAB('Parameters')
    %#DISPLAY('This procedure takes no parameters')
    %#DISPLAY('')
    %#PROMPT('Return Variable',@s100),%%ReturnIn,REQ,DEFAULT('RC#')
  %#ENDTAB
  %#TAB('Documentation')
    %#DISPLAY('Purpose is: Load All Files')
    %#DISPLAY('Routine is: raLoadAll')
    %#DISPLAY('Located in: %ProjectName')
    %#DISPLAY('')
    #SET(%PLProc,'raLoadAll')
    #SET(%PLDesc,'This procedure is generated by DumpLoad.')
    #INSERT(%CodeLDescr)
  %#ENDTAB
%#ENDSHEET
%%ReturnIn = raLoadAll() %#<! Load All Files
%#GROUP(%%DL0AllFilesLoadEnd)
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
#ENDIF
#!
#IF(%GenBtnAll)
  #SET(%CodeDesc,UPPER(%ProjectName) & ': ' & 'AllFiles' & ': This IS NOT documented!')
  #SET(%CodeCmnt,UPPER(%ProjectName) & ': This IS NOT documented!')
%#CONTROL(DL0B_AllFiles_Dump,'%ProjectName: Button: All Files'),WINDOW,MULTI
%#SHEET,HSCROLL
  %#TAB('Parameters')
    %#DISPLAY('This procedure takes no parameters')
    %#DISPLAY('')
    %#PROMPT('Return Variable',@s100),%%ReturnIn,REQ,DEFAULT('RC#')
  %#ENDTAB
  %#TAB('Documentation')
    %#DISPLAY('Purpose is: Dump All Files')
    %#DISPLAY('Routine is: raDumpAll')
    %#DISPLAY('Located in: %ProjectName')
    %#DISPLAY('')
    #SET(%PLProc,'raDumpAll')
    #SET(%PLDesc,'This procedure is generated by DumpLoad.')
    #INSERT(%CodeLDescr)
  %#ENDTAB
%#ENDSHEET
%#!--------------------------------------------------------------------
  CONTROLS
    BUTTON('Dump All'),AT(,,100,14),USE(?btnDumpAll),LEFT,ICON(''), |
      MSG('Dump All Files.'),TIP('Dump All Files.')
  END
%#!--------------------------------------------------------------------
%#AT(%%CustomGlobalDeclarations)
%#!#PROJECT('DumpLoad.Ico')
%#ENDAT
%#!--------------------------------------------------------------------
%#ATSTART
  %#DECLARE(%%btnDumpAll)
  %#FOR(%%Control),WHERE(%%ControlInstance=%%ActiveTemplateInstance)
    %#SET(%%btnDumpAll,%%Control)
  %#ENDFOR
%#ENDAT
%#!--------------------------------------------------------------------
%#AT(%%ControlEventHandling,%%btnDumpAll,'Accepted'),PRIORITY(100)
%%ReturnIn = raDumpAll() %#<! Dump All Files
%#ENDAT
%#!--------------------------------------------------------------------
%#AT(%%ControlEventHandling,%%btnDumpAll,'Selected'),PRIORITY(100)
%#ENDAT
%#!--------------------------------------------------------------------
%#GROUP(%%DL0BAllFilesDumpEnd)
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
%#CONTROL(DL0B_AllFiles_Load,'%ProjectName: Button: All Files'),WINDOW,MULTI
%#SHEET,HSCROLL
  %#TAB('Parameters')
    %#DISPLAY('This procedure takes no parameters')
    %#DISPLAY('')
    %#PROMPT('Return Variable',@s100),%%ReturnIn,REQ,DEFAULT('RC#')
  %#ENDTAB
  %#TAB('Documentation')
    %#DISPLAY('Purpose is: Load All Files')
    %#DISPLAY('Routine is: raLoadAll')
    %#DISPLAY('Located in: %ProjectName')
    %#DISPLAY('')
    #SET(%PLProc,'raLoadAll')
    #SET(%PLDesc,'This procedure is generated by DumpLoad.')
    #INSERT(%CodeLDescr)
  %#ENDTAB
%#ENDSHEET
%#!--------------------------------------------------------------------
  CONTROLS
    BUTTON('Load All'),AT(,,100,14),USE(?btnLoadAll),LEFT,ICON(''), |
      MSG('Load All Files.'),TIP('Load All Files.')
  END
%#!--------------------------------------------------------------------
%#AT(%%CustomGlobalDeclarations)
%#!#PROJECT('DumpLoad.Ico')
%#ENDAT
%#!--------------------------------------------------------------------
%#ATSTART
  %#DECLARE(%%btnLoadAll)
  %#FOR(%%Control),WHERE(%%ControlInstance=%%ActiveTemplateInstance)
    %#SET(%%btnLoadAll,%%Control)
  %#ENDFOR
%#ENDAT
%#!--------------------------------------------------------------------
%#AT(%%ControlEventHandling,%%btnLoadAll,'Accepted'),PRIORITY(100)
%%ReturnIn = raLoadAll() %#<! Load All Files
%#ENDAT
%#!--------------------------------------------------------------------
%#AT(%%ControlEventHandling,%%btnLoadAll,'Selected'),PRIORITY(100)
%#ENDAT
%#!--------------------------------------------------------------------
%#GROUP(%%DL0BAllFilesLoadEnd)
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
#ENDIF
#!
#IF(%GenCodeEach)
  #FOR(%DoTheseFiles)
    #IF(%DoThisDesc)
      #SET(%CodeDesc,UPPER(%ProjectName) & ': ' & %DoThisFile & ': ' & %DoThisDesc)
      #SET(%CodeCmnt,UPPER(%ProjectName) & ': ' & %DoThisDesc)
    #ELSE
      #SET(%CodeDesc,UPPER(%ProjectName) & ': ' & %DoThisFile & ': This IS NOT documented!')
      #SET(%CodeCmnt,UPPER(%ProjectName) & ': This IS NOT documented!')
    #ENDIF
%#CODE(DL2_%DoThisFile_Dump,'%ProjectName: %DoThisDesc')
%#SHEET,HSCROLL
  %#TAB('Parameters')
    %#DISPLAY('This procedure takes no parameters')
    %#DISPLAY('')
    %#PROMPT('Return Variable',@s100),%%ReturnIn,REQ,DEFAULT('RC#')
  %#ENDTAB
  %#TAB('Documentation')
    %#DISPLAY('Purpose is: Dump ''%DoThisFile''')
    %#DISPLAY('Routine is: raDOne%DoThisFile')
    %#DISPLAY('Located in: %ProjectName')
    %#DISPLAY('')
    #SET(%PLProc,%DoThisFile)
    #SET(%PLDesc,%DoThisText)
    #IF(%PLDesc='')
      #SET(%PLDesc,'This procedure is generated by DumpLoad.')
    #ENDIF
    #INSERT(%CodeLDescr)
  %#ENDTAB
%#ENDSHEET
%%ReturnIn = raDOne%DoThisFile() %#<! %DoThisDesc
  #SET(%GroupVar,'%DL2' & %DoThisFile & 'DumpEnd')
%#GROUP(%GroupVar)
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
%#CODE(DL2_%DoThisFile_Load,'%ProjectName: %DoThisDesc')
%#SHEET,HSCROLL
  %#TAB('Parameters')
    %#DISPLAY('This procedure takes no parameters')
    %#DISPLAY('')
    %#PROMPT('Return Variable',@s100),%%ReturnIn,REQ,DEFAULT('RC#')
  %#ENDTAB
  %#TAB('Documentation')
    %#DISPLAY('Purpose is: Load ''%DoThisFile''')
    %#DISPLAY('Routine is: raDOne%DoThisFile')
    %#DISPLAY('Located in: %ProjectName')
    %#DISPLAY('')
    #SET(%PLProc,%DoThisFile)
    #SET(%PLDesc,%DoThisText)
    #IF(%PLDesc='')
      #SET(%PLDesc,'This procedure is generated by DumpLoad.')
    #ENDIF
    #INSERT(%CodeLDescr)
  %#ENDTAB
%#ENDSHEET
%%ReturnIn = raLOne%DoThisFile() %#<! %DoThisDesc
  #SET(%GroupVar,'%DL2' & %DoThisFile & 'LoadEnd')
%#GROUP(%GroupVar)
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
  #ENDFOR
#ENDIF
#!
#IF(%GenBtnEach)
  #FOR(%DoTheseFiles)
    #IF(%DoThisDesc)
      #SET(%CodeDesc,UPPER(%ProjectName) & ': ' & %DoThisFile & ': ' & %DoThisDesc)
      #SET(%CodeCmnt,UPPER(%ProjectName) & ': ' & %DoThisDesc)
    #ELSE
      #SET(%CodeDesc,UPPER(%ProjectName) & ': ' & %DoThisFile & ': This IS NOT documented!')
      #SET(%CodeCmnt,UPPER(%ProjectName) & ': This IS NOT documented!')
    #ENDIF
%#CONTROL(DL2B_%DoThisFile_Dump,'%ProjectName: Button: %DoThisDesc'),WINDOW,MULTI
%#SHEET,HSCROLL
  %#TAB('Parameters')
    %#DISPLAY('This procedure takes no parameters')
    %#DISPLAY('')
    %#PROMPT('Return Variable',@s100),%%ReturnIn,REQ,DEFAULT('RC#')
  %#ENDTAB
  %#TAB('Documentation')
    %#DISPLAY('Purpose is: Dump ''%DoThisFile''')
    %#DISPLAY('Routine is: raDOne%DoThisFile')
    %#DISPLAY('Located in: %ProjectName')
    %#DISPLAY('')
    #SET(%PLProc,%DoThisFile)
    #SET(%PLDesc,%DoThisText)
    #IF(%PLDesc='')
      #SET(%PLDesc,'This procedure is generated by DumpLoad.')
    #ENDIF
    #INSERT(%CodeLDescr)
  %#ENDTAB
%#ENDSHEET
%#!--------------------------------------------------------------------
  CONTROLS
    BUTTON('Dump %DoThisFile'),AT(,,100,14),USE(?btnDump%DoThisFile),LEFT,ICON(''), |
      MSG('Dump File %DoThisFile.'),TIP('Dump File %DoThisFile.')
  END
%#!--------------------------------------------------------------------
%#AT(%%CustomGlobalDeclarations)
%#!#PROJECT('DumpLoad.Ico')
%#ENDAT
%#!--------------------------------------------------------------------
%#ATSTART
  %#DECLARE(%%btnDump%DoThisFile)
  %#FOR(%%Control),WHERE(%%ControlInstance=%%ActiveTemplateInstance)
    %#SET(%%btnDump%DoThisFile,%%Control)
  %#ENDFOR
%#ENDAT
%#!--------------------------------------------------------------------
%#AT(%%ControlEventHandling,%%btnDump%DoThisFile,'Accepted'),PRIORITY(100)
%%ReturnIn = raDOne%DoThisFile() %#<! %DoThisDesc
%#ENDAT
%#!--------------------------------------------------------------------
%#AT(%%ControlEventHandling,%%btnDump%DoThisFile,'Selected'),PRIORITY(100)
%#ENDAT
%#!--------------------------------------------------------------------
  #SET(%GroupVar,'%DL2B' & %DoThisFile & 'DumpEnd')
%#GROUP(%GroupVar)
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
%#CONTROL(DL2B_%DoThisFile_Load,'%ProjectName: Button: %DoThisDesc'),WINDOW,MULTI
%#SHEET,HSCROLL
  %#TAB('Parameters')
    %#DISPLAY('This procedure takes no parameters')
    %#DISPLAY('')
    %#PROMPT('Return Variable',@s100),%%ReturnIn,REQ,DEFAULT('RC#')
  %#ENDTAB
  %#TAB('Documentation')
    %#DISPLAY('Purpose is: Load ''%DoThisFile''')
    %#DISPLAY('Routine is: raDOne%DoThisFile')
    %#DISPLAY('Located in: %ProjectName')
    %#DISPLAY('')
    #SET(%PLProc,%DoThisFile)
    #SET(%PLDesc,%DoThisText)
    #IF(%PLDesc='')
      #SET(%PLDesc,'This procedure is generated by DumpLoad.')
    #ENDIF
    #INSERT(%CodeLDescr)
  %#ENDTAB
%#ENDSHEET
%#!--------------------------------------------------------------------
  CONTROLS
    BUTTON('Load %DoThisFile'),AT(,,100,14),USE(?btnLoad%DoThisFile),LEFT,ICON(''), |
      MSG('Load File %DoThisFile.'),TIP('Load File %DoThisFile.')
  END
%#!--------------------------------------------------------------------
%#AT(%%CustomGlobalDeclarations)
%#!#PROJECT('DumpLoad.Ico')
%#ENDAT
%#!--------------------------------------------------------------------
%#ATSTART
  %#DECLARE(%%btnLoad%DoThisFile)
  %#FOR(%%Control),WHERE(%%ControlInstance=%%ActiveTemplateInstance)
    %#SET(%%btnLoad%DoThisFile,%%Control)
  %#ENDFOR
%#ENDAT
%#!--------------------------------------------------------------------
%#AT(%%ControlEventHandling,%%btnLoad%DoThisFile,'Accepted'),PRIORITY(100)
%%ReturnIn = raLOne%DoThisFile() %#<! %DoThisDesc
%#ENDAT
%#!--------------------------------------------------------------------
%#AT(%%ControlEventHandling,%%btnLoad%DoThisFile,'Selected'),PRIORITY(100)
%#ENDAT
%#!--------------------------------------------------------------------
  #SET(%GroupVar,'%DL2B' & %DoThisFile & 'LoadEnd')
%#GROUP(%GroupVar)
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
  #ENDFOR
#ENDIF
#!--------------------------------------------------------------------
#!---------------------------------------------------------------------
#GROUP(%zTplDumpLoadEnd)
#!---------------------------------------------------------------------

#!--------------------------------------------------------------------
#!---------------------------------------------------------------------
#CONTROL(zButtonDumpLoad,'2001.01.26: Generic DumpLoad Button Template'),WINDOW,MULTI
#!--------------------------------------------------------------------
#INSERT(%PreambleDUMPLOAD)
#SHEET,HSCROLL
#INSERT(%MITLicenseDUMPLOAD)
#TAB ('Generic DumpLoad Button Template')
  #DISPLAY('Copyright © 1999-2999 by Roberto Artigas Jr.')
  #DISPLAY('All Rights Reserved World Wide')
  #DISPLAY('')
  #DISPLAY('This is a generic dumpload button template.')
  #DISPLAY('It is here as a programmer''s example.')
#ENDTAB
#ENDSHEET
#!--------------------------------------------------------------------
  CONTROLS
    BUTTON('DumpLoad'),AT(,,60,14),USE(?btnDumpLoad),LEFT,ICON(''), |
      MSG('DumpLoad Files.'),TIP('DumpLoad Files.')
  END
#!--------------------------------------------------------------------
#AT(%CustomGlobalDeclarations)
#!#PROJECT('DumpLoad.Ico')          #! Example: No icon really exists
#ENDAT
#!--------------------------------------------------------------------
#ATSTART
  #DECLARE(%btnDumpLoad)
  #FOR(%Control),WHERE(%ControlInstance=%ActiveTemplateInstance)
    #SET(%btnDumpLoad,%Control)
  #ENDFOR
#ENDAT
#!--------------------------------------------------------------------
#AT(%ControlEventHandling,%btnDumpLoad,'Accepted'),PRIORITY(100)
#ENDAT
#!--------------------------------------------------------------------
#AT(%ControlEventHandling,%btnDumpload,'Selected'),PRIORITY(100)
#ENDAT
#!--------------------------------------------------------------------
#!---------------------------------------------------------------------
#GROUP(%zDumpLoadButtonEnd)
#!---------------------------------------------------------------------

#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#EXTENSION(zTpl_DumpLoadGroup,'2001.01.28: Dumpload Group Template Generator'),REQ(zDumpLoadGroup),MULTI
#!---------------------------------------------------------------------
#INSERT(%PreambleDUMPLOAD)
#SHEET,HSCROLL
#INSERT(%MITLicenseDUMPLOAD)
#TAB ('Dumpload Group Template Generator')
  #!DISPLAY('Copyright © 1999-2999 by Roberto Artigas Jr.')
  #!DISPLAY('All Rights Reserved World Wide')
  #!DISPLAY('')
  #DISPLAY('WARNING: THIS HAS NOT BEEN LOOKED AT IN 18+ YEARS (TESTING ON IT)'),PROP(PROP:FontStyle,700)
  #DISPLAY('')
  #PROMPT('Template Description: ',@s60),%TPLDescG,REQ,DEFAULT(UPPER(%Application) & ': Application Group Comment')
  #DISPLAY('')
  #BOXED('Generate Code Templates')
  #PROMPT('For each group Dump''ed and Load''ed? ',CHECK),%GenCodeGroup,DEFAULT(1),AT(10)
  #ENDBOXED
  #DISPLAY('')
  #BOXED('Generate Button Templates')
  #PROMPT('For each group Dump''ed and Load''ed? ',CHECK),%GenBtnGroup,DEFAULT(1),AT(10)
  #ENDBOXED
#ENDTAB
#ENDSHEET
#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#AT(%CustomGlobalDeclarations)
  #DECLARE(%counter)
  #DECLARE(%FileName1)
  #DECLARE(%FileName2)
  #DECLARE(%ClipName)
  #DECLARE(%AllProto)
  #DECLARE(%OneProto)
  #DECLARE(%ListDriver),UNIQUE
  #DECLARE(%ASCIIFileRecord)
  #DECLARE(%TemplateLine)
  #DECLARE(%RangeNumber)
  #DECLARE(%LongName)
  #DECLARE(%Family)
#!
  #IF(SUB(%CwTemplateVersion,1,2) = 'v2')
    #SET(%Family,'CW20')
  #ELSE
    #SET(%Family,'ABC')
  #ENDIF
#!
  #DECLARE(%GroupVar)
  #DECLARE(%ProjectName)
  #DECLARE(%TemplateSet)
  #DECLARE(%TemplateName)
  #DECLARE(%CodeDesc)
  #DECLARE(%CodeCmnt)
  #DECLARE(%PlProc)
  #DECLARE(%PLDesc)
  #DECLARE(%LDescr)
  #DECLARE(%LDBeg,LONG)
  #DECLARE(%LDEnd,LONG)
  #DECLARE(%LDCnt,LONG)
  #DECLARE(%LDaSP,LONG)
  #DECLARE(%LDaCR,LONG)
  #DECLARE(%LDaLF,LONG)
#!
  #SET(%ProjectName,UPPER(%Application))
  #SET(%ClipName,SUB(%ProjectName,1,5))
  #SET(%TemplateSet,'RA_DL')
  #SET(%TemplateName,'DLG' & %ClipName)
#!
#INSERT(%MakeTemplateG)
#ENDAT
#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#GROUP(%MakeTemplateG)
#IF(%TemplateName)
  #SET(%FileName1,UPPER(%TemplateName))
  #IF(INSTRING('.',%FileName1,1,1) = 0)
    #SET(%FileName1,UPPER(%TemplateName) & '.TPW')
  #ENDIF
  #SET(%FileName2, %TemplateSet & '.$$$')
  #CREATE(%FileName2)
#INSERT(%MakeTemplateBodyG)
  #CLOSE(%FileName2)
  #REPLACE(%FileName1,%FileName2)
  #IF(%TemplateSet <> '')
    #SET(%Counter,0)
    #SET(%TemplateLine,'#INCLUDE(''' & %FileName1 & ''')')
    #SET(%FileName2,%TemplateSet)
    #IF(INSTRING('.',%FileName2,1,1) = 0)
      #SET(%FileName2,UPPER(%TemplateSet) & '.TPL')
    #ENDIF
    #IF(FILEEXISTS(%FileName2) = 0)
      #CREATE(%FileName2)
#INSERT(%MakeTemplateSetBodyG)
      #CLOSE(%FileName2)
    #ELSE
      #OPEN(%FileName2),READ
      #LOOP
        #READ(%ASCIIFileRecord)
        #IF(%ASCIIFileRecord = %TemplateLine)
          #SET(%Counter,1)
          #BREAK
        #ELSIF(%ASCIIFileRecord = %EOF)
          #BREAK
        #END
      #END
      #CLOSE(%FileName2)
      #IF(%Counter = 0)
        #OPEN(%FileName2)
#INSERT(%AddToTemplateSetBodyG)
        #CLOSE(%fileName2)
      #ENDIF
    #ENDIF
  #ENDIF
#ENDIF
#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#GROUP(%MakeTemplateSetBodyG)
  #IF(%TemplateSet<>'')
    #SET(%TemplateLine,%TemplateSet)
  #ELSE
    #SET(%TemplateLine,%TemplateName)
  #ENDIF
  #IF(INSTRING('.',%templateLine,1,1) > 0)
    #SET(%TemplateLine,SUB(%TemplateLine,1,INSTRING('.',%templateLine,1,1)-1))
  #ENDIF
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
%#TEMPLATE(%TemplateLine,'DumpLoad Group Generated Template Class'),FAMILY('CW20','ABC')
%#!--------------------------------------------------------------------
#INSERT(%AddToTemplateSetBody)
#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#GROUP(%AddToTemplateSetBodyG)
  #IF(%TemplateSet<>'')
%#INCLUDE('%FileName1')
  #ENDIF
#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#GROUP(%MakeTemplateBodyG)
  #IF(%TemplateSet = '')
#INSERT(%MakeTemplateSetBodyG)
  #ELSE
  #ENDIF
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
%#EXTENSION(DL_%ProjectName_GROUP,'%TPLDescG'),APPLICATION
%#!--------------------------------------------------------------------
%#BOXED('')
  %#DISPLAY('Copyright © 1999-2999 by Roberto Artigas Jr.')
  %#DISPLAY('All Rights Reserved World Wide')
%#ENDBOXED
%#AT(%%CustomGlobalDeclarations)
  %#PROJECT('%ProjectName.LIB')
#!%#PROJECT('%ClipName.LIB')
%#ENDAT
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
#INSERT(%DLCodeGroup)
%#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#!--------------------------------------------------------------------
#GROUP(%DLCodeGroup)
#IF(%GenCodeGroup)
  #SET(%GSave,'')
  #FOR(%RaEiList)
    #SET(%GOpts,EXTRACT(%RaEiItem,'RAEILIST'))
    #SET(%GItem,EXTRACT(%GOpts,'RAEILIST',1))
    #SET(%GName,EXTRACT(%GOpts,'RAEILIST',2))
    #IF(%GSave=%GItem)
      #CYCLE
    #ENDIF
    #SET(%GSave,%GItem)
%#CODE(DL1_Group_%GItem_Dump,'%ProjectName: Group %GItem')
%#SHEET,HSCROLL
  %#TAB('Parameters')
    %#DISPLAY('This procedure takes no parameters')
    %#DISPLAY('')
    %#PROMPT('Return Variable',@s100),%%ReturnIn,REQ,DEFAULT('RC#')
  %#ENDTAB
  %#TAB('Documentation')
    %#DISPLAY('Purpose is: Dump Group ''%GItem''')
    %#DISPLAY('Routine is: raDumpGroup_%GItem')
    %#DISPLAY('Located in: %ProjectName')
    %#DISPLAY('')
    #SET(%PLProc,'raDumpGroup_' & %GItem)
    #SET(%PLDesc,'')
    #IF(%PLDesc='')
      #SET(%PLDesc,'This procedure is generated by DumpLoad.')
    #ENDIF
    #INSERT(%CodeLDescr)
  %#ENDTAB
%#ENDSHEET
%%ReturnIn = raDumpGroup_%GItem() %#<! Dump Group %GItem
  #SET(%GroupVar,'%DL1Group' & %GItem & 'DumpEnd')
%#GROUP(%GroupVar)
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
%#CODE(DL1_Group_%GItem_Load,'%ProjectName: Group %GItem')
%#SHEET,HSCROLL
  %#TAB('Parameters')
    %#DISPLAY('This procedure takes no parameters')
    %#DISPLAY('')
    %#PROMPT('Return Variable',@s100),%%ReturnIn,REQ,DEFAULT('RC#')
  %#ENDTAB
  %#TAB('Documentation')
    %#DISPLAY('Purpose is: Load Group ''%GItem''')
    %#DISPLAY('Routine is: raLoadGroup_%GItem')
    %#DISPLAY('Located in: %ProjectName')
    %#DISPLAY('')
    #SET(%PLProc,'raLoadGroup_' & %GItem)
    #SET(%PLDesc,'')
    #IF(%PLDesc='')
      #SET(%PLDesc,'This procedure is generated by DumpLoad.')
    #ENDIF
    #INSERT(%CodeLDescr)
  %#ENDTAB
%#ENDSHEET
%%ReturnIn = raLoadGroup_%GItem() %#<! Load Group %GItem
  #SET(%GroupVar,'%DL1Group' & %GItem & 'LoadEnd')
%#GROUP(%GroupVar)
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
  #ENDFOR
#ENDIF
#!
#IF(%GenBtnGroup)
  #SET(%GSave,'')
  #FOR(%RaEiList)
    #SET(%GOpts,EXTRACT(%RaEiItem,'RAEILIST'))
    #SET(%GItem,EXTRACT(%GOpts,'RAEILIST',1))
    #SET(%GName,EXTRACT(%GOpts,'RAEILIST',2))
    #IF(%GSave=%GItem)
      #CYCLE
    #ENDIF
    #SET(%GSave,%GItem)
%#CONTROL(DL1B_Group_%GItem_Dump,'%ProjectName: Button: Group %GItem'),WINDOW,MULTI
%#SHEET,HSCROLL
  %#TAB('Parameters')
    %#DISPLAY('This procedure takes no parameters')
    %#DISPLAY('')
    %#PROMPT('Return Variable',@s100),%%ReturnIn,REQ,DEFAULT('RC#')
  %#ENDTAB
  %#TAB('Documentation')
    %#DISPLAY('Purpose is: Dump Group ''%GItem''')
    %#DISPLAY('Routine is: raDumpGroup_%GItem')
    %#DISPLAY('Located in: %ProjectName')
    %#DISPLAY('')
    #SET(%PLProc,'raDumpGroup_' & %GItem)
    #SET(%PLDesc,'')
    #IF(%PLDesc='')
      #SET(%PLDesc,'This procedure is generated by DumpLoad.')
    #ENDIF
    #INSERT(%CodeLDescr)
  %#ENDTAB
%#ENDSHEET
%#!--------------------------------------------------------------------
  CONTROLS
    BUTTON('Dump Group %GItem'),AT(,,100,14),USE(?btnDumpGroup%GItem),LEFT,ICON(''), |
      MSG('Dump Group %GItem.'),TIP('Dump Group %GItem.')
  END
%#!--------------------------------------------------------------------
%#AT(%%CustomGlobalDeclarations)
%#!#PROJECT('DumpLoad.Ico')
%#ENDAT
%#!--------------------------------------------------------------------
%#ATSTART
  %#DECLARE(%%btnDumpGroup%GItem)
  %#FOR(%%Control),WHERE(%%ControlInstance=%%ActiveTemplateInstance)
    %#SET(%%btnDumpGroup%GItem,%%Control)
  %#ENDFOR
%#ENDAT
%#!--------------------------------------------------------------------
%#AT(%%ControlEventHandling,%%btnDumpGroup%GItem,'Accepted'),PRIORITY(100)
%%ReturnIn = raDumpGroup_%GItem() %#<! Dump Group %GItem
%#ENDAT
%#!--------------------------------------------------------------------
%#AT(%%ControlEventHandling,%%btnDumpGroup%GItem,'Selected'),PRIORITY(100)
%#ENDAT
%#!--------------------------------------------------------------------
  #SET(%GroupVar,'%DL1BGroup' & %GItem & 'DumpEnd')
%#GROUP(%GroupVar)
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
%#CONTROL(DL1B_Group_%GItem_Load,'%ProjectName: Button: Group %GItem'),WINDOW,MULTI
%#SHEET,HSCROLL
  %#TAB('Parameters')
    %#DISPLAY('This procedure takes no parameters')
    %#DISPLAY('')
    %#PROMPT('Return Variable',@s100),%%ReturnIn,REQ,DEFAULT('RC#')
  %#ENDTAB
  %#TAB('Documentation')
    %#DISPLAY('Purpose is: Load Group ''%GItem''')
    %#DISPLAY('Routine is: raLoadGroup_%GItem')
    %#DISPLAY('Located in: %ProjectName')
    %#DISPLAY('')
    #SET(%PLProc,'raLoadGroup_' & %GItem)
    #SET(%PLDesc,'')
    #IF(%PLDesc='')
      #SET(%PLDesc,'This procedure is generated by DumpLoad.')
    #ENDIF
    #INSERT(%CodeLDescr)
  %#ENDTAB
%#ENDSHEET
%#!--------------------------------------------------------------------
  CONTROLS
    BUTTON('Load Group %GItem'),AT(,,100,14),USE(?btnLoadGroup%GItem),LEFT,ICON(''), |
      MSG('Load Group %GItem.'),TIP('Load Group %GItem.')
  END
%#!--------------------------------------------------------------------
%#AT(%%CustomGlobalDeclarations)
%#!#PROJECT('DumpLoad.Ico')
%#ENDAT
%#!--------------------------------------------------------------------
%#ATSTART
  %#DECLARE(%%btnLoadGroup%GItem)
  %#FOR(%%Control),WHERE(%%ControlInstance=%%ActiveTemplateInstance)
    %#SET(%%btnLoadGroup%GItem,%%Control)
  %#ENDFOR
%#ENDAT
%#!--------------------------------------------------------------------
%#AT(%%ControlEventHandling,%%btnLoadGroup%GItem,'Accepted'),PRIORITY(100)
%%ReturnIn = raLoadGroup_%GItem() %#<! Load Group %GItem
%#ENDAT
%#!--------------------------------------------------------------------
%#AT(%%ControlEventHandling,%%btnLoadGroup%GItem,'Selected'),PRIORITY(100)
%#ENDAT
%#!--------------------------------------------------------------------
  #SET(%GroupVar,'%DL1BGroup' & %GItem & 'LoadEnd')
%#GROUP(%GroupVar)
%#!--------------------------------------------------------------------
%#!--------------------------------------------------------------------
  #ENDFOR
#ENDIF
#!--------------------------------------------------------------------
#!---------------------------------------------------------------------
#GROUP(%zTplDumpLoadGroupEnd)
#!---------------------------------------------------------------------

#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#GROUP(%PreambleDUMPLOAD)
#PREPARE
  #IF(NOT VAREXISTS(%PreambleTextDUMPLOAD))
    #DECLARE(%PreambleTextDUMPLOAD)
  #ENDIF
  #SET(%PreambleTextDUMPLOAD,                         'Dump and Load (DUMPLOAD) data in ISAM tables.')
  #SET(%PreambleTextDUMPLOAD, %PreambleTextDUMPLOAD & '<13,10>Copyright © 1999-2999 by Roberto Artigas y Soler.')
  #SET(%PreambleTextDUMPLOAD, %PreambleTextDUMPLOAD & '<13,10>Collection created by Roberto Artigas y Soler.')
  #SET(%PreambleTextDUMPLOAD, %PreambleTextDUMPLOAD & '<13,10>All rights reserved world wide.')
  #SET(%PreambleTextDUMPLOAD, %PreambleTextDUMPLOAD & '<13,10>E-MAIL: roberto.artigas.dev@gmail.com')
  #SET(%PreambleTextDUMPLOAD, %PreambleTextDUMPLOAD & '<13,10>SKYPE: Clarion Live | CW-Talk')
#ENDPREPARE
#BOXED('Created: 1999.07.27, Released: 2002.06.22'),AT(,,,),PROP(PROP:FontStyle,700)
  #DISPLAY(''),AT(,,,1)
  #!DISPLAY(%PreambleTextDUMPLOAD),AT(,,260,44)
  #DISPLAY(%PreambleTextDUMPLOAD),AT(,,260,48)
#ENDBOXED
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#GROUP(%MITLicenseDUMPLOAD)
#TAB('License'),PROP(PROP:FontStyle,700)
#INSERT(%MITLicense)
#ENDTAB
#!
#GROUP(%MITLicense)
#PREPARE
  #IF(NOT VAREXISTS(%MITLicenseText01))
    #DECLARE(%MITLicenseText01)
  #ENDIF
  #IF(NOT VAREXISTS(%MITLicenseText02))
    #DECLARE(%MITLicenseText02)
  #ENDIF
  #IF(NOT VAREXISTS(%MITLicenseText03))
    #DECLARE(%MITLicenseText03)
  #ENDIF
  #SET(%MITLicenseText01, '')
  #SET(%MITLicenseText01, %MITLicenseText01 & 'Permission is hereby granted, free of charge, to any person')
  #SET(%MITLicenseText01, %MITLicenseText01 & ' obtaining a copy of this software and associated documentation')
  #SET(%MITLicenseText01, %MITLicenseText01 & ' files (the "Software"), to deal in the software without')
  #SET(%MITLicenseText01, %MITLicenseText01 & ' restriction, including without limitation the rights to use,')
  #SET(%MITLicenseText01, %MITLicenseText01 & ' copy, modify, merge, publish, distribute, sublicense, and/or sell')
  #SET(%MITLicenseText01, %MITLicenseText01 & ' copies of the Software, and to permit persons to whom the Software')
  #SET(%MITLicenseText01, %MITLicenseText01 & ' is furnished to do so, subject to the following conditions:')
  #SET(%MITLicenseText02, '')
  #SET(%MITLicenseText02, %MITLicenseText02 & 'The above copyright notice and this permission notice shall be')
  #SET(%MITLicenseText02, %MITLicenseText02 & ' included in all copies or substantial portions of the Software.')
  #SET(%MITLicenseText03, '')
  #SET(%MITLicenseText03, %MITLicenseText03 & 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,')
  #SET(%MITLicenseText03, %MITLicenseText03 & ' EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF')
  #SET(%MITLicenseText03, %MITLicenseText03 & ' MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND')
  #SET(%MITLicenseText03, %MITLicenseText03 & ' NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT')
  #SET(%MITLicenseText03, %MITLicenseText03 & ' HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,')
  #SET(%MITLicenseText03, %MITLicenseText03 & ' WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,')
  #SET(%MITLicenseText03, %MITLicenseText03 & ' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER')
  #SET(%MITLicenseText03, %MITLicenseText03 & ' DEALINGS IN THE SOFTWARE.')
  #SET(%MITLicenseText03, %MITLicenseText03 & '')
#ENDPREPARE
#BOXED('MIT License'),AT(,,,),PROP(PROP:FontStyle,700)
#!BOXED('MIT License'),AT(,,278),PROP(PROP:FontStyle,700)
#!BOXED('MIT License'),AT(,,454),PROP(PROP:FontStyle,700)
  #DISPLAY(''),AT(,,,1)
  #DISPLAY('Copyright © 1999-' & YEAR(TODAY()) & ' by Roberto Artigas y Soler.'),PROP(PROP:FontStyle,700)
  #!DISPLAY('')
  #DISPLAY(''),AT(,,,1)
  #DISPLAY(%MITLicenseText01),AT(,,260,54)
  #DISPLAY(%MITLicenseText02),AT(,,260,24),PROP(PROP:FontStyle,700)
  #DISPLAY(%MITLicenseText03),AT(,,260,64)
  #!DISPLAY(%MITLicenseText01),AT(,,436,34)
  #!DISPLAY(%MITLicenseText02),AT(,,436,12),PROP(PROP:FontStyle,700)
  #!DISPLAY(%MITLicenseText03),AT(,,436,42)
#ENDBOXED
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#GROUP(%ExplainUtilDUMPLOAD)
#PREPARE
  #IF(NOT VAREXISTS(%ExplainTextDUMPLOAD))
    #DECLARE(%ExplainTextDUMPLOAD)
  #ENDIF
  #SET(%ExplainTextDUMPLOAD, '')
  #!SET(%ExplainTextDUMPLOAD, %ExplainTextDUMPLOAD & 'This is one of the METABASE templates.')
  #!SET(%ExplainTextDUMPLOAD, %ExplainTextDUMPLOAD & '<13,10><13,10>')
  #SET(%ExplainTextDUMPLOAD, %ExplainTextDUMPLOAD & 'This utility will take all you ISAM tables and EXPORT them as CSV comma delimited files.')
  #SET(%ExplainTextDUMPLOAD, %ExplainTextDUMPLOAD & ' The utility will also IMPORT them and restore your table with previous data. This will give you')
  #SET(%ExplainTextDUMPLOAD, %ExplainTextDUMPLOAD & ' and additional way of saving data for backup and restore purposes in a TEXT like format.')
  #SET(%ExplainTextDUMPLOAD, %ExplainTextDUMPLOAD & '<13,10><13,10>')
  #SET(%ExplainTextDUMPLOAD, %ExplainTextDUMPLOAD & 'Where this utility can become even more handy, is when you are doing conversions from ISAM to SQL.')
  #SET(%ExplainTextDUMPLOAD, %ExplainTextDUMPLOAD & ' The part where you have to create a procedure to output all your table''s data as a CSV file is done.')
  #SET(%ExplainTextDUMPLOAD, %ExplainTextDUMPLOAD & ' You will still have to create the SQL backend table LOAD query script. That is dependent on your SQL')
  #SET(%ExplainTextDUMPLOAD, %ExplainTextDUMPLOAD & ' backend and you will have to build that QUERY.')
  #!SET(%ExplainTextDUMPLOAD, %ExplainTextDUMPLOAD & '<13,10><13,10>')
  #!SET(%ExplainTextDUMPLOAD, %ExplainTextDUMPLOAD & '<13,10><13,10>')
  #!SET(%ExplainTextDUMPLOAD, %ExplainTextDUMPLOAD & 'This template has been tested with the ABC template chains.')
  #SET(%ExplainTextDUMPLOAD, %ExplainTextDUMPLOAD & '')
#ENDPREPARE
#!
#GROUP(%ShowExplainUtilDUMPLOAD)
#INSERT(%ExplainUtilDUMPLOAD)
#!TAB(UPPER(%Application) & '.' & UPPER(%ProgramExtension)),PROP(PROP:FontStyle,700),PROP(PROP:FontColor,0C79A3H)
#TAB('Documentation'),PROP(PROP:FontColor,0C79A3H) #! ,PROP(PROP:FontStyle,700),PROP(PROP:FontColor,0C79A3H)
  #BOXED('Documentation'),AT(,,,),PROP(PROP:FontStyle,700)
  #!BOXED('Documentation'),AT(,,278),PROP(PROP:FontStyle,700)
  #!BOXED('Documentation'),AT(,,454),PROP(PROP:FontStyle,700)
    #DISPLAY(''),AT(,,,1)
    #DISPLAY(%ExplainTextDUMPLOAD),AT(,,260,204)
    #!DISPLAY(%ExplainTextDUMPLOAD),AT(,,436,204)
  #ENDBOXED
#ENDTAB
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#GROUP(%ExplainUtilDUMPLOADTPL)
#PREPARE
  #IF(NOT VAREXISTS(%ExplainTextDUMPLOADTPL))
    #DECLARE(%ExplainTextDUMPLOADTPL)
  #ENDIF
  #SET(%ExplainTextDUMPLOADTPL, '')
  #SET(%ExplainTextDUMPLOADTPL, %ExplainTextDUMPLOADTPL & 'This template EXTENSION will take all you ISAM tables and create simple CODE and CONTROL templates for')
  #SET(%ExplainTextDUMPLOADTPL, %ExplainTextDUMPLOADTPL & ' all the tables that DUMP and LOAD routines are being created.')
  #SET(%ExplainTextDUMPLOADTPL, %ExplainTextDUMPLOADTPL & ' Once the templates are created you can add them to the template registry and remove them from generation.')
  #SET(%ExplainTextDUMPLOADTPL, %ExplainTextDUMPLOADTPL & '<13,10><13,10>')
  #SET(%ExplainTextDUMPLOADTPL, %ExplainTextDUMPLOADTPL & 'IF you add or delete tables from your dictionary, THEN you will have to regenerate your')
  #SET(%ExplainTextDUMPLOADTPL, %ExplainTextDUMPLOADTPL & ' templates and get them registered once again.')
  #SET(%ExplainTextDUMPLOADTPL, %ExplainTextDUMPLOADTPL & ' As part of your automation process you can leave the EXTENSION template generate all you CODE and CONTROL')
  #SET(%ExplainTextDUMPLOADTPL, %ExplainTextDUMPLOADTPL & ' templates in temporary directory and them move them to your template registry directory location.')
  #!SET(%ExplainTextDUMPLOADTPL, %ExplainTextDUMPLOADTPL & '<13,10><13,10>')
  #!SET(%ExplainTextDUMPLOADTPL, %ExplainTextDUMPLOADTPL & '<13,10><13,10>')
  #!SET(%ExplainTextDUMPLOADTPL, %ExplainTextDUMPLOADTPL & 'This template has been tested with the ABC template chains.')
  #SET(%ExplainTextDUMPLOADTPL, %ExplainTextDUMPLOADTPL & '')
#ENDPREPARE
#!
#GROUP(%ShowExplainUtilDUMPLOADTPL)
#INSERT(%ExplainUtilDUMPLOADTPL)
#!TAB(UPPER(%Application) & '.' & UPPER(%ProgramExtension)),PROP(PROP:FontStyle,700),PROP(PROP:FontColor,0C79A3H)
#TAB('Documentation'),PROP(PROP:FontColor,0C79A3H) #! ,PROP(PROP:FontStyle,700),PROP(PROP:FontColor,0C79A3H)
  #BOXED('Documentation'),AT(,,,),PROP(PROP:FontStyle,700)
  #!BOXED('Documentation'),AT(,,278),PROP(PROP:FontStyle,700)
  #!BOXED('Documentation'),AT(,,454),PROP(PROP:FontStyle,700)
    #DISPLAY(''),AT(,,,1)
    #DISPLAY(%ExplainTextDUMPLOADTPL),AT(,,260,204)
    #!DISPLAY(%ExplainTextDUMPLOADTPL),AT(,,436,204)
  #ENDBOXED
#ENDTAB
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
