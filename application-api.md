## TODO Document

### the Application API
#### TODO MAKE AN APPLICATION API

### Commands
#### MESSAGEID\_REQUEST\_COMMANDS				1602
#### MESSAGEID\_ADD\_COMMAND					1603
#### MESSAGEID\_REM\_COMMAND					1604
#### MESSAGEID\_PROCESS\_COMMAND				1605
#### MESSAGEID\_PERM\_CHECK\_COMMAND			1606
#### MESSAGEID\_PROCESS\_COMMAND\_AUTH			1607
#### MESSAGEID\_PROCESS\_IMPL\_COMMAND			1608

### Filters
#### FILTER\_NEXT\_FILTER            702

### Think/Say/Stuff
#### OUTPUT\_VOICE                      705

### Restrictions
#### RESTRICTION\_APPLY                 600
#### RESTRICTION\_RELEASE               601

### Menus
#### OPEN\_MENU 11
#### SET\_MENUSTATE 12


## Linked messages

### MESSAGEID\_PARSE\_MENUINPUT 10
Send by the menu parser script, if it is unable to handle the message from a dialog.

Contains two json encoded parameters in `message`, the first is the current menustate, the second is the received text.
The key `data` contains the relevant avatar id.

### MESSAGEID\_OPEN\_MENU 11
Can be send by multiple things, most often in cases of [Back] buttons where the script handling the current menu is not responsible for the new menu.

Contains the unencoded new name in message. An example of use to open the main  menu


    case MESSAGEID\_OPEN\_MENU:
        switch ( message ) {
            case "":
                open\_root\_menu( data );
                set\_menu\_state( llListFindList( menu\_states, [ data ] ), "" );
                break;
            default:
        }
        break;

### MESSAGEID\_SET\_MENUSTATE 12
Can be send by multiple sources, used to store the current menu position after opening a new dialog.
This way the resulting message can be dispatched appropriately.

Don't send this manually, use the following pre-defined macro:

    SET\_MENUSTATE( "avatars/0", data );

### MESSAGEID\_REQUEST\_CONFIGURATION 20
Automatically send on startup of any script using `STATE\_ENTRY\_INIT;`.
Used to synchronise settings like wearer name, etc. Small, often-needed simple strings.


### MESSAGEID\_SET\_CONFIGURATION 21
Used to respond to `MESSAGEID\_REQUEST\_CONFIGURATION`, use the macros  for convenience:

    START\_SEND\_CONFIG\_ON\_REQUEST
        SEND\_CONFIG\_VAR( pod\_owner ),
        SEND\_CONFIG\_VAR( menu\_channel )
    END\_SEND\_CONFIG\_ON\_REQUEST

The above is enough synchronize the two variables pod\_owner and menu\_channel automatically.

### MESSAGEID\_STORE\_CONFIGURATION 22
Used to parse incoming configuration, will start a loop through the decoded values send via above, setting each variable that matches.
Again, use the convenient macros

    switch ( number ) {
        START\_READ\_CONFIG\_ON\_MESSAGE
            READ\_CONFIG\_VAR\_INT( menu\_channel )
            READ\_CONFIG\_VAR\_STRING( pod\_owner )
            READ\_CONFIG\_VAR\_LIST( avatar\_settings )
        END\_READ\_CONFIG\_ON\_MESSAGE
