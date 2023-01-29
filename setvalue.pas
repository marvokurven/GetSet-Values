program setvalue;
{$MODE OBJFPC}

  {$IFDEF WINDOWS}
      {$APPTYPE CONSOLE}
  {$ENDIF}

uses Classes,getopts,IniFiles;


      {  Const
         WriteErrors:boolean = FALSE;  // REPLACED WITH COMMANDLINE OPTION}



        var
         filename,sect,key,value:string;
         opt:char;
         delimiter:char = '=';
         WriteErrors:boolean = FALSE;


     Procedure showhelp;
     Begin;
        writeln ('SetValue  V0.9 - 29.01.2023 ');
        writeln;
        writeln ('USAGE: setvalue [-e -d DELIMITER] [-i SECTION] (-f FILE -k KEY VALUE)         ');
        Writeln ('Sets the value of the specified key/variable in a config file,                ');
        Writeln ('the key/value pair will be created if it does not exist.                      ');
        writeln;
        Writeln ('OPTIONS:                                                                      ');
        writeln ('  -h            Show this screen and exit                                      ');
        Writeln ('  -e            Print error messages (Default: Do no print)                    ');
        Writeln ('  -d CHARACHTER Specify delimiter charchter (Default =) Ignored when using -i  ');
        Writeln ('  -i SECTION    Write to INI-file (Section must be specified)                  ');
        Writeln;
        Writeln ('MANDATORY:                                                                    ');
        writeln ('  -f FILE      Config file to write to                                        ');
        writeln ('  -k KEY       Key/Variable to write to file                                  ');
        writeln;
        writeln ('Both -f and -k are required in all cases. -d and -i are optional.             ');
        writeln ('Allowed delimiter charachters are: Equal(=) Dash(-) Colon(:)                  ');
        writeln ('If no delimiter is specified, then = is assumed.                              ');
        writeln ('When using -i the file is treated as an INI-file, and -i must be followed     ');
        writeln ('by the section within the file to write the key/value pair.                   ');
        writeln ('Both the file, section, and key/value is created automatically if not existing.');
        writeln ('Delimiter option is ignored when writing INI files.                           ');
        writeln;
        writeln ('Examples:                                                                     ');
        writeln ('     setvalue -e -f configfile -k foo bar                                     ');
        writeln ('  Sets "bar" as the value of "foo" in configfile, and show errors (if any)    ');
        writeln;
        writeln ('     setvalue -d : -f colonfile.txt -k foo bar                                ');
        writeln ('  Sets "bar" as the value of "foo" in colonfile.txt using a colon as the delimiter    ');
        writeln;
        writeln ('     setvalue -f inifile.ini -i foo -k bar whatever                           ');
        writeln ('  Sets "whatever" as the value of "bar" in section "foo" in inifile.ini       ');
        writeln;
        Writeln ('Exit codes: 0 - All good    1 - Error writing to file    2 - Invalid option(s)');

     halt;
     end;


     Function SetDelimiter(Fdelimiter:string):boolean;
     begin;
            if Length(Fdelimiter) = 1 then
                begin;
                  case Fdelimiter OF
                   '=','-',':' : begin
                       delimiter:=Fdelimiter[1];
                       Result:=TRUE;
                      end
                   else
                      begin;
                              if WriteErrors then
                                begin
                                 Writeln ('Invalid delimiter: ',Fdelimiter);
                                 Writeln ('Valid delimiters are = : -');
                                end;
                       Result:=FALSE;
                      end;
                  end;
                end
         else
         begin;
           if WriteErrors then Writeln ('Invalid length of delimiter, only one charachter allowed');
           Exit(FALSE);
         end;
     end;


     Function WriteKey(Ffilename,Fkey,Fvalue:string; Fdelimiter:char):boolean;
     var list:TstringList;

     begin;
     Result:=TRUE;
       try;
          try;

          begin;
           list:=TstringList.Create;
           list.LoadFromFile(Ffilename);
           list.NameValueSeparator:=Fdelimiter;
           list.Values[key]:=value;
           list.SaveToFile(Ffilename);
          end;

          except
           if WriteErrors then Writeln ('Error writing to file');
           Result:=FALSE
          end;

       finally
         list.free;
       end;
       {writeln (key,': ',value);}
     End;


     Function WriteIni(Ffilename,Fkey,Fsection,Fvalue:string):boolean;
     var IniFile:Tinifile;

     Begin;
     Result:=TRUE;
         try;
              try;
                begin;
                 IniFile:=Tinifile.create(Ffilename);
                 IniFile.WriteString(Fsection,Fkey,Fvalue);
                end;

                except
                 if WriteErrors then Writeln ('Error writing to file');
                 Result:=FALSE;
                end;

         finally
          IniFile.free;
         end;
     end;




  Function GetCommands:shortint;
   Begin;
   Result:=2;

     repeat
        opt:=getOpt('d:f:k:i:he');
                case opt OF
                  'e' : WriteErrors:=TRUE;
                  'h' : ShowHelp;
                  'k' : key:=optarg;
                  'f' : filename:=optarg;
                  'd' : if NOT SetDelimiter(optarg) then exit(2);
                  'i' : sect:=optarg;
                  '?' : begin
                           if WriteErrors then Writeln ('Invalid option/argument: ',OptOpt);
                           exit(2);
                        end;
                end;
     until opt=Endofoptions;

     if optind = ParamCount then
        begin
          value:=ParamStr(optind);
        { writeln (value,paramcount); }
        end;

        if NOT (key='') AND NOT (filename='') AND NOT (sect='') then
                          begin
                            If WriteIni(filename,key,sect,value) then Exit(0)
                             else Exit(1);
                          end;

        if NOT (key='') AND NOT (filename='') AND (sect='')then
                          begin
                            if Writekey(filename,key,value,delimiter) then Exit(0)
                             else exit(1);
                          end;
  end;


  Begin;
      if ParamCount = 0 then ShowHelp;
      filename:='';
      key:='';
      value:='';
      sect:='';

      ExitCode:=(GetCommands);

  end.
