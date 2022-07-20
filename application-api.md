# OeM Application API

Fair warning: Consider this a living document, it will be expanded in time based on feedback.

Table of Contents:

 * [Our structure](#structure)
 * [Commands to the system](#commands)
 * [Menu handling](#menus)
 * [Variables and configuration](#variables)
 * [Rainbow example](#rainbow-example)

<div class="top-marker"><a href="#a-title">Top</a></div>
# Structure
The most important thing for developing an extension/application to OeM is to use a viewer that supports a precompiler and to include our include file ([download OeM\_Api.lsl](lsl/OeM_Api.lsl)).

We really like our #define macro trickery over at OeM, it helps us ensure our code is easy to read even when *actually* it's doing a lot of things.

Our first example application should help elaborate: ([download App\_Minimal.lsl](lsl/App\_Minimal.lsl))

It works through most of the important bits of setting up an application.

{% highlight c %}
{% include_relative assets/lsl/App_Minimal.lsl %}
{% endhighlight %}

Our second example application is a lot more complex and we will include it at the [end](#rainbow-example), but it's a good place to start hacking: ([download App\_Rainbow.lsl](lsl/App\_Rainbow.lsl))

It shows off how to do menus, and how commands can have permissions.

(Known bug: The meta information (author, version, etc) in Applications won't be updated if you recompile a script, you can `@reset applications` to work around this.)

<div class="top-marker"><a href="#a-title">Top</a></div>
# Commands
## Think/Say/Stuff
This linked message is used when the controller has to ouput some text. The structure is simple: the string contains the message to be outputted while the key contains the output mode. There are several output modes, each one having their own reason to exist.

1. `DO_OEM_WHISPER`, `DO_OEM_SHOUT`, `DO_OEM_NORMAL`: These modes will output the text as if it was written by the unit. This means that if the unit has their mind or volume off, these won't work.
2. `DO_OEM_THINK`: Will relay the message ONLY to the unit, in the same way the chat command "relay" does. RLV commands won't be relayed.
3. `DO_OEM_ANNOUNCE`, `DO_OEM_ANNOUNCE_S`, `DO_OEM_ANNOUNCE_W`: Will act as if it was a message NOT produced by the mind of the unit, and thus will ignore the mind subsystem being off. S is for shout, W for whisper.

An example use is:

    DO_OEM_THINK( "This unit likes writing extensions for OeM" );

## Restrictions

The controller allows us to apply and remove restrictions from the unit. It is not a RLV relay, it has a limited number of restrictions it applies, identified with numbers. These numbers are powers of 2, so that they can all be used as flags inside an integer.

The controller keeps track of "who" has issued which restrictions and won't lift them until everyone has released them. That means that the subsystem menu and the power management both have motor speed restricted. then the subsystem menu lifts its restriction. The controller won't lift the restriction because the power management still has theirs issued.

Just a small note, to make everyone's life simpler. Bitwise logic operators. To add a new flag: 

    flags = flags \| new\_flag.

To remove a flag

    flags = flags & ~new\_flag.

### RESTRICTION\_APPLY

This linked message is used to apply restrictions on the unit. The string must be a number that contains the flags for the restrictions that you want to apply. In the key you must use your identifier. This should be a short string (we want to save memory) but asunique as you can. The device will add the restriction to the restrictions you have applied and if that restriction hadn't been applied yet, the system will issue the RLV command.

    SEND_LINKED_MESSAGE( MESSAGEID_RESTRICTION_APPLY, ([RESTRICTION_SPEECH]), "Core_IO_Menu" );

### RESTRICTION\_RELEASE

The opposite of apply, you have to send an integer with the restrictions flags you want to lift and your identifier as the key. The system will remove these flags from the restrictions you have applied and if nobody else has those restrictions applied, then it will issue the RLV command to lift them.

### RESTRICTION\_RELEASE\_ALL 

Will release all the restrictions that have the identifier sent in the key. The rest works like `RESTRICTION_RELEASE`

### RESTRICTION\_SAFEWORD   

Will release ALL the restrictions, no matter what the origin was for. If you receive this linked message, you can assume your restrictions have been forgotten by the system.

### RESTRICTION\_UPDATE	 

This is a linked message that is sent after any of the previous messages has been received. The string of this Linked Message contains the previous collective flags status and the new one, separated as a list.. This message is sent even if there has been no change.

### RESTRICTION\_REQUEST\_STATUS 

Linked message to request the current collective flag status.

### RESTRICTION\_STATUS 

Anser to the previous linked message, containing only the current overall flag status.

<div class="top-marker"><a href="#a-title">Top</a></div>
# Menus
## MESSAGEID\_APPLICATION\_MENU\_OPEN and MESSAGEID\_APPLICATION\_MENU\_HANDLE\_INPUT 

We've tried to take a lot of the mess of dialogs away, you will need a few things (check [the rainbow example](#rainbow-example) for details) like menu\_channel and a flag in `OEM_APPLICATION_INIT`, otherwise the dialog handling is hopefully fairly simple:

    if ( ( number == MESSAGEID_APPLICATION_MENU_OPEN || number == MESSAGEID_APPLICATION_MENU_HANDLE_INPUT ) && llGetSubString( message, 0, 39 ) == __app_id ) {
        if ( number == MESSAGEID_APPLICATION_MENU_HANDLE_INPUT ) toggle_rainbow( data );

        llDialog( data, "Toggle rainbow mdoe", [ TEXT_MENU_ENDING, "Toggle" ], menu_channel );
    }

The key field in the linked message (here `data`) contains the relevant avatar id. Note that the example doesn't do any parsing of the message, that would be the following

    list parameters = DECODE_LIST_2_STRING( message );
    string menu_path = llList2String( parameters, 0 );
    string button_value = llList2String( parameters, 1 );

Note the menu\_path bit, our menu system is based on something similar to a folder structure, if you prefix your button with `APPLICATION_MENU_CHARACTER` you'll get a `MENU_OPEN` message instead of a `HANDLE_INPUT` message, the system will automatically track what 'path' you're in.

Probably you won't need to use menu\_path if your menu is fairly simple, but we want to offer it anyway.

Oh and the `TEXT_MENU_ENDING`, that's a list of 3 buttons that will be automatically and neatly handled by the system so you don't need to worry about it.
There's a few more like that in the include file.

<div class="top-marker"><a href="#a-title">Top</a></div>
# Rainbow example

Here is the full code of our rainbow example:

{% highlight c %}
{% include_relative lsl/App_Rainbow.lsl %}
{% endhighlight %}

