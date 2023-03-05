# GetSet-Values
**Console tool to read and set values in config files**

Since I am a total sed- and awk noob, I struggled with reading config files into scripts, and spent a lot of time with troubleshooting.
Mostly because I got the sed and awk commands slightly wrong, and their syntax being... Cryptic, to say the least.    
And thus GetSet-Values was born; A simple tool that does all the heavy lifting, so variables can be read into a script (or similar) with ease,
 and without sourcing a file into the script -a file that would be run from start to end,
 and with that the risk of bogous commands the file could contain- And without having to create functions in the script to read the file in a safer manner,
nor drown the list of environment variables with every single entry in the file. 

The tool concists of two console applications, **getvalue** and **setvalue**,
both of which has a similar syntax.     
As the names implies, they are used to either *read* a value from a config file, or *write* one.

In order to prevent clogging up a script,there will be no output if there's any errors, 
or -in the case of GetValue, if no match is found.
However, by using the `-e` flag, any errors will be returned as output.

More features might be added if needed, currently and option to getting rid of "quotes" from quoted strings are planned.




# GetValue
**USAGE:** getvalue *[OPTIONS]*   ( -f FILE  -k KEY )

Retrieves the value of the specified key/variable from a config file.

Both `-f` and `-k` are required in non-interactive mode, the rest is optional.
Allowed delimiter charachters are: Equal(**=**) Dash(**-**) Colon(**:**)      
If no delimiter is specified, then **=** is assumed.

When using `-i` the file is read as an INI-file, and `-i` must be followed by a section name within the file, 
even if there is only one section, as INI-files are required to have at least one,
and since they are organized in a specific way, the `-d` option is ignored when reading them, 
as **=** is the *only* delimiter allowed.

Interactive mode allows for opening a specific file, and read multiple values consecutively for testing or debugging purposes.
`-f`and `-k` are ignored when starting in interactive mode, and as such they can be omitted.     
Press `CTRL+C` or type `quit` to exit.

| Options | Description |
| :---: | :--- |
| `-f [FILE]`| File to read **(Required)** |
| `-k [KEY]`| Key to read from file **(Required)** |
| `-i [SECTION]` | Read from INI-file **(Section is required)** |
| `-d [CHARACHTER]` | Specify delimiter character *(Optional)* |
| `-h` | Show help screen, and exit |
| `-e` | Print error messages *(Optional)* |
| `-n` | Interactive mode |

**Examples:**  

     echo $(getvalue -f /etc/os-release -k NAME) | figlet
  Prints the name of the currently running Linux distribution in fancy text using figlet

     getvalue -e -d : -f colonfile.txt -k foo
  Prints the value of "foo" in *colonfile.txt* using a colon as the delimiter and shows errormessages (If any)

     getvalue -f inifile.ini -k foo -i bar
  Prints the value of "foo" in section "bar" from *inifile.ini*





# SetValue

**USAGE:** setvalue *[OPTIONS]*   ( -f FILE  -k KEY ) ( VALUE )

Writes a vlaue to the file and key specified. The Key/Value pair will be created if it doesn't exist

Both `-f` and `-k` are required, the rest is optional.
Allowed delimiter charachters are: Equal(**=**) Dash(**-**) Colon(**:**)     
If no delimiter is specified, then **=** is assumed.

When using `-i` the file is treated as an INI-file, and `-i` must be followed by the section within the file
to write the key/value pair, even if the file has just one section.
Non-existant files, sections, key/value pairs are created automatically as needed.
Delimiter option is ignored when writing INI files.

| Options | Description |
| :---: | :--- |
| `-f [FILE]`| File to write **(Required)** |
| `-k [KEY]`| Key to write to file **(Required)** |
| `-i [SECTION]` | Write to INI-file **(Section is required)** |
| `-d [CHARACHTER]` | Specify delimiter character *(Optional)* |
| `-h` | Show help screen, and exit |
| `-e` | Print error messages *(Optional)* |

**Examples:**  

     setvalue -e -f configfile -k foo bar                                     
  Sets "bar" as the value of "foo" in *configfile*, and shows errors (if any)

     setvalue -d : -f colonfile.txt -k foo bar                                
  Sets "bar" as the value of "foo" in *colonfile.txt* using a colon as the delimiter

     setvalue -f inifile.ini -i foo -k bar whatever                           
  Sets "whatever" as the value of "bar" in section "foo" in *inifile.ini*


# Exit codes

 Both applications has the same exit codes, which can be used to check whether an operation was
 successfull or not, without clogging up a script with error messages.  
  
  | Exit code | Description       |
  |:---------:|:------------------|
  | 0         | Success           |
  | 1         | Read/Write error (File or key doesn't exist, or no permission)  |
  | 2         | Invalid option(s) and/or argument(s)|
  
  
# Installing

The binaries can be used as-is in cunjunction with scripts, or they can be copied to a directory in either     
local $PATH or system-wide.     
There's no dependencies, except the compiler itself should you want to compile it for yourself

Currently there are two ways of installing GetSet-Values:    

**Download the binaries**    
Copy the binaries to `/home/[USER]/.local/bin` to make them available for the user alone,     
or `/usr/local/bin` to make them available system-wide for all users.      

**Compiling**      
The FreePascal Compiler is required to compile the sources.      
It's available for both Linux, Windows, and MacOS, and can be obtained at [freepascal.org](https://www.freepascal.org/download.html)
or in the package manager's default repo on most Linux distros.      
The full-blown Lazarus IDE also has it included if you want the whole shebang.     

 COMPILING IN LINUX:    
 `make`    
 `sudo make install` *(Optional)*       
 
 
 COMPILING IN WINDOWS:       
 `fpc -XX -O3 -vi getvalue.pas`     
 `fpc -XX -O3 -vi setvalue.pas`      
 Copy the binaries to *C:\windows\system32* or just use them as-is     
      
 I have added a batch-script as a makefile for Windows, but it is not tested yet so bugs can be expected.    
 Run it like so:     
 `make`    
 `make install`
  
 
  
