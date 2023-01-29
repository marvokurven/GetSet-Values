program getvalue;



{$MODE OBJFPC}

  {$IFDEF WINDOWS}
    {$APPTYPE CONSOLE}
  {$ENDIF}

uses Classes,getopts,IniFiles;

{   // REPLACED WITH COMMAND LINE OPTION   //

        const WriteErrors:boolean=FALSE;  }


        var
         filename,key,value:string;
         opt:char;
         delimiter:char = '=';
         WriteErrors:boolean = FALSE;


     Procedure showhelp;
     Begin;
        writeln ('GetValue   V0.9 - 29.01.2023                                                  ');
        writeln;
        writeln ('USAGE: getvalue [-e -n -d DELIMITER -i SECTION]  (-f FILE -k KEY)             ');
        Writeln ('Retrieves the value of the specified key/variable from a config file,         ');
        Writeln ('there will be no output if no match is found.                                 ');
        writeln;
        Writeln ('OPTIONS:                                                                      ');
        writeln ('  -h            Show this screen and exit                                     ');
        Writeln ('  -e            Print error messages (Default: Do no print)                   ');
        writeln ('  -n            Interactive mode. (Cannot be combined with -f -k -i)          ');
        Writeln ('  -d CHARACHTER Specify delimiter charchter (Default =) Ignored when using -i ');
        Writeln ('  -i SECTION    Read from INI-file (Section must be specified)                ');
        Writeln;
        Writeln ('MANDATORY:                                                                    ');
        writeln ('  -f FILE       Config file to read                                           ');
        writeln ('  -k KEY        Key/Variable to read from file                                ');
        writeln;
        writeln ('Both -f and -k are required in non-interactive mode,                          ');
        writeln ('Allowed delimiter charachters are: Equal(=) Dash(-) Colon(:)                  ');
        writeln ('If no delimiter is specified, then = is assumed.                              ');
        writeln ('When using -i the file is read as an INI-file, and -i must be followed by a   ');
        writeln ('section name within the file, even if there is only one section.              ');
        writeln ('Delimiter option is ignored when reading INI files.                           ');
        writeln;
        writeln ('Examples:                                                                     ');
     {$IFDEF LINUX}
        writeln ('     getvalue -f /etc/os-release -k NAME                                      ');
        writeln ('  Prints the name of the currently running Linux distribution.                ');
        writeln;
     {$ENDIF}
        writeln ('     getvalue -e -d : -f colonfile.txt -k foo                                 ');
        writeln ('  Prints the value of "foo" in colonfile.txt using a colon as the delimiter   ');
        Writeln ('  and shows errormessages (If any)                                            ');
        writeln;
        writeln ('     getvalue -f inifile.ini -k foo -i bar                                    ');
        writeln ('  Prints the value of "foo" in section "bar" from inifile.ini                 ');
        writeln;
        writeln ('Interactive mode allows for opening a specific file, and read                 ');
        writeln ('multiple values consecutively for testing or debugging purposes.              ');
        writeln ('Press CTRL+C or type "quit" to exit interactive mode.                         ');
        writeln;
        Writeln ('Exit codes: 0 - All good    1 - Error reading file    2 - Invalid option(s)   ');

     halt(0);
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
          if WriteErrors then  Writeln ('Invalid length of delimiter, only one charachter allowed');
           Exit(FALSE);
         end;
     end;


     Function readkey(Ffilename,Fkey:string; Fdelimiter:char):boolean;
     var list:TstringList;

     begin;
     Result:=TRUE;
       try;
          try;

          begin;
           list:=TstringList.Create;
           list.LoadFromFile(Ffilename);
           list.NameValueSeparator:=Fdelimiter;
           value:=list.Values[key];
          end;

          except
            if WriteErrors then Writeln ('Error reading ',filename);
            Result:=FALSE;
          end;

       finally
         list.free;
       end;
       {writeln (key,': ',value);}
     End;


     Function ReadIni(Ffilename,Fkey,Fsection:string):boolean;
     var IniFile:Tinifile;

     Begin;
     Result:=TRUE;
         try;
              try;
                begin;
                 IniFile:=Tinifile.create(Ffilename);
                 value:=IniFile.ReadString(Fsection,Fkey,'');
                end;

                except
                 if WriteErrors then Writeln ('Error reading ',filename);
                 result:=FALSE;
                end;

         finally
          IniFile.free;
         end;
     end;


     Procedure Interactive;
      begin;
      writeln ('Type QUIT to exit.');
      writeln;

         write ('File to read: ');
          readln(filename);

      while NOT (key='quit') do
          begin

             write ('Key to read from ',filename,': ');
            readln(key);
             Writeln (key,': ',readkey(filename,key,delimiter));
          end;

      halt(0);
      end;


  Function GetCommands:integer;
   Begin;
   Result:=2;

     repeat
        opt:=getOpt('d:f:k:i:hne');
                case opt OF
                  'h' : ShowHelp;
                  'e' : WriteErrors:=TRUE;
                  'k' : key:=optarg;
                  'f' : filename:=optarg;
                  'd' : if NOT SetDelimiter(optarg) then exit(2);
                  'i' : if NOT (key='') AND NOT (filename='') then
                          begin
                            if (ReadIni(filename,key,optarg)) then exit(0)
                            else exit(1)
                          end;
                  'n' : Interactive;
                  '?' : begin
                           if WriteErrors then Writeln ('Invalid option/argument: ',OptOpt);
                           exit(2);
                        end;
                end;
     until opt=Endofoptions;

        if NOT  (key = '')  AND NOT  (filename = '') then
          begin
            if (readkey(filename,key,delimiter)) then exit(0)
            else exit(1);
          end;
  end;


  Begin;
  ExitCode:=0;
  value:='';
      if ParamCount = 0 then ShowHelp;

      ExitCode:=GetCommands;
      if ExitCode=0 then writeln(value);
  end.
