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
#### FILTER\_REGISTER			700

This is a message that should be sent right after any script with a filter in it is installed. Send a linked message with this number and the name of the filter(s) separated by the character 0xE010 as the string. The key should be the name of your script.

    llMessageLinked ( LINK_SET, 700, llDumpList2String( gFilters, llChar( 0xE010 ) ) ,  llGetScriptName());

#### FILTER\_UNREGISTER			701

This is the linked message that HAS to be sent before any script with a filter in it is uninstalled. You'll be informed of that via another linked message TODO: LINKED MESSSAGE NAME. Similar to MESSAGEID_FILTER_REGISTER, the string is the name of the filters separated by the character 0xE010 as the string and the key should be the name of your script.

    llMessageLinked ( LINK_SET, 701, llDumpList2String( gFilters, llChar( 0xE010 ) ) ,  llGetScriptName());


#### FILTER\_NEXT\_FILTER        702
This linked message is used to set up the pipeline of filters through which the unit's speech or the unit's hearing will go through. The key sent with the linked message is the filter name this linked message is targeting. The string sent in the linked message is the name of the filter that goes after. It's possible that this name is an empty string, but it's not a special case you should handle. You should default this value to an empty string when in doubt.

This message id serves for both input filters and output filters.

Here is an example for a filter that is named in the same way as the script.

    if ( number == 702 ) {
        if ( (string) data == llGetScriptName () ) nextFilter = message;
    }

Here is an example for a filter that is inside a script with multiple filters in it.

    if ( number == 702 ) {
        if ( llListFindList(gFilters, [(string) data ] ) != -1 ) {
            integer pos = llListFindList(filters_order, [(string)data] );
            if ( pos == -1 ) {
                filters_order += [(string) data, message];
            } else {
                filters_order = llListReplaceList(filters_order, [message], pos+1, pos+1);
            }
        }
    }

#### FILTER\_OUTPUT   			703

This linked message serves to send the unit's speech through the filter pipeline. You have to check if the key of the linked message is the name of one of your filters and if it is, process the speech stored in the linked message string. Once you are finished make sure to pass it on with this same message id to the next filter, which you have received with MESSAGEID_FILTER_NEXT_FILTER.

The speech is encoded in a slightly complex way. It is a list that separates the emotes from the actual speech, with the character 0xE010. The first element of the list is the volume level this message will try to go through as (whisper, normal or shout). Note that this level might not be the outputed due to volume restrictions. The second one must be checked to see if it is a string that says "EMOTE". If it is, then the next element is the emote part of the chat, if it isn't and it says "SPEAK", the next element is the speech part. After that it alternates between emotes and speech. THe first and lst character of each part is separated by a control character


#### FILTER\_INPUT				704

Same as FILTER_OUTPUT, but instead of filtering the unit's speech, you are filtering what it hears. So there is only one difference. The first element of the list instead of the volume of the input, is the UUID of the speaker.

Just like in FILTER_OUTPUT, make sure you pass the message down the pipeline.


### Think/Say/Stuff
#### OUTPUT\_VOICE                      705
This linked message is used when the controller has to ouput some text. The structure is simple: the string contains the message to be outputted while the key contains the output mode. There are several output modes, each one having their own reason to exist.

1. OEM_WHISPER, OEM_SHOUT, OEM_NORMAL: These modes will output the text as if it was written by the unit. This means that if the unit has their mind or volume off, these won't work.
2. OEM_THINK: Will relay the message ONLY to the unit, in the same way the chat command "relay" does. RLV commands won't be relayed.
3. OEM_ANNOUNCE, OEM_ANNOUNCE_S, OEM_ANNOUNCE_W: Will act as if it was a message NOT produced by the mind of the unit, and thus will ignore the mind subsystem being off. S is for shout, W for whisper.


### Restrictions

The controller allows us to apply and remove restrictions from the unit. It is not a RLV relay, it has a limited number of restrictions it applies, identified with numbers. These numbers are powers of 2, so that they can all be used as flags inside an integer.

The controller keeps track of "who" has issued which restrictions and won't lift them until everyone has released them. That means that the subsystem menu and the power management both have motor speed restricted. then the subsystem menu lifts its restriction. The controller won't lift the restriction because the power management still has theirs issued.

Just a small note, to make everyone's life simpler. Bitwise logic operators. To add a new flag -> flags = flags | new_flag. To remove a flag -> flags = flags & ~new_flag.

#### RESTRICTION\_APPLY                 600

This linked message is used to apply restrictions on the unit. The string must be a number that contains the flags for the restrictions that you want to apply. In the key you must use your identifier. This should be a short string (we want to save memory) but asunique as you can. The device will add the restriction to the restrictions you have applied and if that restriction hadn't been applied yet, the system will issue the RLV command.

    SEND_LINKED_MESSAGE( MESSAGEID_RESTRICTION_APPLY, ([RESTRICTION_SPEECH]), "Core_IO_Menu" );

#### RESTRICTION\_RELEASE               601

The opposite of apply, you have to send an integer with the restrictions flags you want to lift and your identifier as the key. The system will remove these flags from the restrictions you have applied and if nobody else has those restrictions applied, then it will issue the RLV command to lift them.

#### RESTRICTION\_RELEASE\_ALL 	        602

Will release all the restrictions that have the identifier sent in the key. The rest works like RESTRICTION_RELEASE

#### RESTRICTION\_SAFEWORD   		    603

Will release ALL the restrictions, no matter what the origin was for. If you receive this linked message, you can assume your restrictions have been forgotten by the system.

#### RESTRICTION\_UPDATE	 	        604

This is a linked message that is sent after any of the previous messages has been received. The string of this Linked Message contains the previous collective flags status and the new one, separated as a list.. This message is sent even if there has been no change.

#### RESTRICTION\_REQUEST_STATUS 	    606

Linked message to request the current collective flag status.

#### RESTRICTION\_STATUS 		        607

Anser to the previous linked message, containing only the current overall flag status.


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
Can be send by multiple sources, used to store the current menu position for the avatar with the UUID "data" after opening a new dialog.
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
