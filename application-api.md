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
#### MESSAGEID\_FILTER\_REGISTER			700

This is a message that should be sent right after any script with a filter in it is installed. Send a linked message with this number and the name of the filter(s) separated by the character 0xE010 as the string. The key should be the name of your script.

    llMessageLinked ( LINK_SET, 700, llDumpList2String( gFilters, llChar( 0xE010 ) ) ,  llGetScriptName());

#### MESSAGEID\_FILTER\_UNREGISTER			701

This is the linked message that HAS to be sent before any script with a filter in it is uninstalled. You'll be informed of that via another linked message TODO: LINKED MESSSAGE NAME. Similar to MESSAGEID_FILTER_REGISTER, the string is the name of the filters separated by the character 0xE010 as the string and the key should be the name of your script.

    llMessageLinked ( LINK_SET, 701, llDumpList2String( gFilters, llChar( 0xE010 ) ) ,  llGetScriptName());


#### MESSAGEID\_FILTER\_NEXT\_FILTER        702
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

#### MESSAGEID\_FILTER\_OUTPUT   			703

This linked message serves to send the unit's speech through the filter pipeline. You have to check if the key of the linked message is the name of one of your filters and if it is, process the speech stored in the linked message string. Once you are finished make sure to pass it on with this same message id to the next filter, which you have received with MESSAGEID_FILTER_NEXT_FILTER.

The speech is encoded in a slightly complex way. It is a list that separates the emotes from the actual speech, with the character 0xE010. The first element of the list is something not needed for the filter, but the second one must be checked to see if it is a string that says "EMOTE". If it is, then the next element is the emote part of the chat, if it isn't and it says "SPEAK", the next element is the speech part. After that it alternates between emotes and speech.

Here is an example of a simple filter that uses the functions filterEmote and filterChat to modify each part separatedly.

    if ( number == 703 && (string) data == llGetScriptName() ) {
        //filtering output
        list toFilter = llParseStringKeepNulls( message, [ llChar( 0xE010 ) ], [] );
        integer firstIsEmote = llList2String ( toFilter, 1 ) == "EMOTE";

        integer i;
        integer max = llGetListLength ( toFilter );
        for ( i = 2; i < max; i++) {
            if ( firstIsEmote + i%2 ) toFilter = llListReplaceList ( toFilter, [filterEmote ( llList2String ( toFilter, i ) )], i, i );
            else toFilter = llListReplaceList ( toFilter, [filterChat ( llList2String ( toFilter, i ) )], i, i );
        }

        llMessageLinked ( LINK_SET, 703, llDumpList2String(toFilter, llChar( 0xE010 )), nextFilter );

    }

And here is a more complex example with more filters in one script.

    if ( number == 703 ) {
        //Filtering output
        integer pos = llListFindList( gFilters, [ (string) data ] );
        if ( pos != -1 ) {
            //filtering output
            string filter = (string) data;

            pos = llListFindList(filters_order, [filter]);
            key next_filter = "";
            if( pos != -1 ) next_filter = llList2Key(filters_order, pos+1);

            list toFilter = llParseStringKeepNulls( message, [ llChar( 0xE010 ) ], [] );
            integer firstIsEmote = llList2String ( toFilter, 1 ) == "EMOTE";

            integer i;
            integer max = llGetListLength ( toFilter );
            for ( i = 2; i < max; i++) {
                if ( (firstIsEmote + i)%2 ) {
                    //Inside this conditional we are filtering an EMOTE(what the avatar is acting, not saying)
                    //MODIFY HERE: the name of the filters and the function related to them.
                    if ( filter == "Feline" ) {
                        toFilter = llListReplaceList ( toFilter, [ "#" + filterEmote__FELINE ( llGetSubString(llList2String ( toFilter, i ), 1, -2) ) + "#" ], i, i );
                    }

                } else {
                    //Inside this conditional we are filtering CHAT (what the avatar is saying, not acting)
                    //MODIFY HERE: the name of the filters and the function related to them.
                    if ( filter == "Feline" ) {
                        toFilter = llListReplaceList ( toFilter, [ "#" + filterChat__FELINE ( llGetSubString(llList2String ( toFilter, i ), 1, -2) ) + "#" ], i, i );
                    }
                }
            }

            llMessageLinked ( LINK_SET, 703, llDumpList2String(toFilter, llChar( 0xE010 )), next_filter );
        }

    }


#### MESSAGEID\_FILTER\_INPUT				704

Same as FILTER_OUTFUT, but instead of filtering the unit's speech, you are filtering what it hears. Due to this change there is a slight difference. The message is divided into two lists. The first one is separated by the character 0xE010 and it contains, in order, the uuid of the speaker, the name of the speaker and finally what was said. This last element is also a list, separated by the 0xE011 character. This second list is the same as the one you could find in the previous linked message FILTER_INPUT.

A simple script with just 1 output filter:

    if ( number == 704 && (string) data == llGetScriptName() ) {
        //filtering input
        list data = llParseStringKeepNulls( message , [ llChar( 0xE010 ) ], [] );
        key speaker = llList2Key( data, 0 );
        string speaker_name = llList2String( data, 1 );
        list toFilter = llParseStringKeepNulls( llList2String( data, 2 ), [ llChar(0xE011) ], []);
        integer firstIsEmote = llList2String ( toFilter, 1 ) == "EMOTE";

        integer i;
        integer max = llGetListLength ( toFilter );
        for ( i = 2; i < max; i++) {
            if ( firstIsEmote + i%2 ) toFilter = llListReplaceList ( toFilter, [filterEmoteInput ( speaker, speaker_name, llList2String ( toFilter, i ) )], i, i );
            else toFilter = llListReplaceList ( toFilter, [filterChatInput ( speaker, speaker_name, llList2String ( toFilter, i ) )], i, i );
        }
        string filtered_input = llDumpList2String( toFilter, llChar( 0xE011 ) );
        llMessageLinked ( LINK_SET, 704, llDumpList2String([speaker, speaker_name, filtered_input], llChar( 0xE010 )) , nextFilter );

    }

And a complex one with more than one output filter in the script:

    if ( number == 704 ) {
        //filtering input
        integer pos = llListFindList( gFilters, [ (string) data ] );
        if ( pos != -1 ) {
            string filter = (string) data;

            pos = llListFindList(filters_order, [filter]);
            key next_filter = "";
            if( pos != -1 ) next_filter = llList2Key(filters_order, pos+1);

            list info = llParseStringKeepNulls( message , [ llChar( 0xE010 ) ], [] );
            key speaker = llList2Key( info, 0 );
            string speaker_name = llList2String( info, 1 );
            list toFilter = llParseStringKeepNulls( llList2String( info, 2 ), [ llChar(0xE011) ], []);
            integer firstIsEmote = llList2String ( toFilter, 1 ) == "EMOTE";

            integer i;
            integer max = llGetListLength ( toFilter );
            for ( i = 2; i < max; i++) {
                if ( (firstIsEmote + i)%2 ) {
                    if ( filter == "Forgotten" ) {
                        toFilter = llListReplaceList ( toFilter, [filterEmoteInput__FORGOTTEN ( speaker, speaker_name, llGetSubString(llList2String ( toFilter, i ), 1, -2) )], i, i );
                    }
                } else {
                    if ( filter == "Forgotten" ) {
                        toFilter = llListReplaceList ( toFilter, [filterChatInput__FORGOTTEN ( speaker, speaker_name, llGetSubString(llList2String ( toFilter, i ), 1, -2) )], i, i );
                    }
                }
            }
            string filtered_input = llDumpList2String( toFilter, llChar( 0xE011 ) );
            llMessageLinked ( LINK_SET, 704, llDumpList2String([speaker, speaker_name, filtered_input], llChar( 0xE010 )) , next_filter );
        }

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
