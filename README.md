# Valuable
**Console tool to read and set values in config files**

Since I am a total sed- and awk noob, I struggled with reading config files into scripts, and spent a lot of time with trouble-shooting.
Mostly because I got the sed and awk commands slightly wrong, and their syntax being...Cryptic,so to speak.
And thus Valuable was born. A simple tool that does all the heavy lifting, so variables can be read into a script (or similar) with ease.

The tool concists of two console applications, **getvalue** and **setvalue**
both of which has a similar syntax. 
As the names implies, they are used to either *read* a value from a config file, or *write* one.



**GetValue**

USAGE: getvalue [OPTIONS]  (-f FILE -k KEY)             
Retrieves the value of the specified key/variable from a config file.
In order to prevent clogging up a script,there will be no output if no match is found or if there's any errors,
unless the -e flag is provided, in which case any errors will be returned as output.

OPTIONS:                                                                      
  -h            Show help message and exit                                     
  -e            Print error messages (Default: Do no print)                   
  -n            Interactive mode. (Cannot be combined with -f -k -i)          
  -d CHARACHTER Specify delimiter charchter (Default =) Ignored when using -i 
  -i SECTION    Read from INI-file (Section must be specified)                

MANDATORY:                                                                    
  -f FILE       Config file to read                                           
  -k KEY        Key/Variable to read from file                                

Both -f and -k are required in non-interactive mode,                          
Allowed delimiter charachters are: Equal(=) Dash(-) Colon(:)                  
If no delimiter is specified, then = is assumed.                              
When using -i the file is read as an INI-file, and -i must be followed by a   
section name within the file, even if there is only one section, as INI-files are required to have at least one.              
Because INI-files are organized in a specific way, the -d option is ignored when reading them, as = is the *only*
delimiter allowed.

Examples:  

     getvalue -f /etc/os-release -k NAME                                      
  Prints the name of the currently running Linux distribution.                

     getvalue -e -d : -f colonfile.txt -k foo                                 
  Prints the value of "foo" in *colonfile.txt* using a colon as the delimiter and shows errormessages (If any)                                           

     getvalue -f inifile.ini -k foo -i bar                                    
  Prints the value of "foo" in section "bar" from *inifile.ini*                 

Interactive mode allows for opening a specific file, and read                 
multiple values consecutively for testing or debugging purposes.              
Press CTRL+C or type "quit" to exit interactive mode                                                



**SetValue**

USAGE: setvalue [-e -d DELIMITER] [-i SECTION] (-f FILE -k KEY VALUE)         
Writes a value to the specified key/variable in a config file,                
the key/value pair will be created if it does not exist.                      

OPTIONS:                                                                      
  -h            Show help screen and exit                                      
  -e            Print error messages (Default: Do no print)                    
  -d CHARACHTER Specify delimiter charchter (Default =) Ignored when using -i  
  -i SECTION    Write to INI-file (Section must be specified)                  

MANDATORY:                                                                    
  -f FILE      Config file to write to                                        
  -k KEY       Key/Variable to write to file                                  

Both -f and -k are required in all cases. -d and -i are optional.             
Allowed delimiter charachters are: Equal(=) Dash(-) Colon(:)                  
If no delimiter is specified, then = is assumed.                              
When using -i the file is treated as an INI-file, and -i must be followed     
by the section within the file to write the key/value pair, even if the file has just one section                   
Both the file, section, and key/value is created automatically if they doesn't exist allready
Delimiter option is ignored when writing INI files.                           

Examples:  

     setvalue -e -f configfile -k foo bar                                     
  Sets "bar" as the value of "foo" in *configfile*, and show errors (if any)    

     setvalue -d : -f colonfile.txt -k foo bar                                
  Sets "bar" as the value of "foo" in *colonfile.txt* using a colon as the delimiter    

     setvalue -f inifile.ini -i foo -k bar whatever                           
  Sets "whatever" as the value of "bar" in section "foo" in *inifile.ini* 
  
  
  
  | Exit code | Description       |
  |-----------|-------------------|
  | 0         | Success           |
  | 1         | Read/Write error  |
  | 2         | Invalid option(s) |
  
  Both applications has the same exit codes, which can be used to check whether an operation was 
  successfull or not, without clogging up a script with error messages.
  
