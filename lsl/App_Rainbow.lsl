/////////////////////////////////////////////////////
// App_Rainbow, copyright OeM 2022
// You are free to use this code as a basis for your own applications for OeM products
//
// All other uses by request, contact by discord (https://discord.gg/j44BhKHBjw) or in Second Life (elvahardwick or gonkaotic)
/////////////////////////////////////////////////////

// This file is important, you need it unless you want to do a lot of tedious work of copy pasting, it's availabe from https://elvahardwick.github.io/Obedientiae-ex-Machina-Docs/application-api - Same as this sample code!
#include "OeM_Api.lsl"

#define APPLICATION_COMMANDS ["rainbow_color"]

// This is the channel our system expects dialog messages on, as you can see below we don't have an llListen in this script.
// The parsing and handling special buttons like [Back] and [Quit] are all handled for you so you can just make what you need
integer menu_channel;

// These variables are for the rainbow functions! unit_color is the name of the variable that specifies the current unit color, and stored_unit_color is so that when we disable the rainbow we can go back to the original color
float current_hue = -1;
vector unit_color;
vector stored_unit_color;

// Simple toggling method
toggle_rainbow( key data ) {
    if ( current_hue == -1 ) {
        stored_unit_color = unit_color;
        llRegionSayTo( data, 0, "Enabling rainbow mode!" );
        llSetTimerEvent( 0.25 );
        current_hue = llFrand( TWO_PI );
    } else {
        llRegionSayTo( data, 0, "Disabling rainbow mode!" );
        llSetTimerEvent( 0.0 );
        // SET_VARIABLE_DIRECT is... basically: unit_color = stored_unit_color; Oh and inform the rest of the system we're doing it. You can also use SEND_VARIABLE_DIRECT which is used in the timer method
        SET_VARIABLE_DIRECT( unit_color, stored_unit_color );
        current_hue = -1;
    }
}

default
{
    state_entry()
    {
        // This is an important line that does.. a lot of work, it will tell the controller that this script exists, who wrote it, what it's name is and what options it has.
        // We're saying here that we have a menu, and commands!
        OEM_APPLICATION_INIT( "Elva Hardwick", "Rainbow mode", "v0.1.0", APPLICATION_FLAG_HAS_MENU | APPLICATION_FLAG_HAS_COMMANDS );

        // This line is to ask the rest of the system to inform us of what the current unit_color is
        REQUEST_VARIABLES;
    }

    changed( integer change ) {
        // Simple little thing
        CHANGED_DEFAULT_HANDLERS;
    }

    link_message(integer sender, integer number, string message, key data) {
        // Another important line for an application, will make sure that if something gets reset we still work, and that all the necessary things are informed about us
        REGISTER_APPLICATION_ON_MESSAGE();

        // This is where we handle both the help functionallity, and the actual functionallity for the commands
        START_COMMAND_HANDLE
            START_HELP_HANDLE
                HELP( "rainbow_color", "\nUsage: rainbow_color\n\Enables or disables the rainbow.")
            END_HELP_HANDLE

            // This indicates that the command rainbow_color *needs* the ADMINISTRATION premission, you could also change this to COMMAND_HANDLE if you don't think it needs permissions
            COMMAND_WITH_PERMISSIONS_HANDLE( "rainbow_color", PERMISSION_ADMINISTRATION_FLAG )
                // Just call our toggling method
                toggle_rainbow( data );
            END_COMMAND_HANDLE
        END_COMMAND_GROUP_HANDLE

        // In here we handle receiving the menu_channel (OEM_APPLICATION_INIT makes sure we get this) and the unit_color (REQUEST_VARIABLES gets us this one).
        // Note that the handling of unit_color is special, we want to also set stored_unit_color if we get it so we just do that! READ_VAR_* all gets translated into a less complicated version of how we handle unit_color here
        START_READ_VARIABLE_ON_MESSAGE
            READ_VAR_INT( menu_channel )
            else if ( m == "unit_color" ) { unit_color = (vector)llList2String( parameters, i + 1 ); if ( current_hue == -1 ) stored_unit_color = unit_color; }
        END_READ_VARIABLE_ON_MESSAGE

        // This is our menu handling. Yup, this is it, all of it. Okay the menu is pretty simple, we only have one button to handle so we can just pretend to know what the button says
        if ( ( number == MESSAGEID_APPLICATION_MENU_OPEN || number == MESSAGEID_APPLICATION_MENU_HANDLE_INPUT ) && llGetSubString( message, 0, 39 ) == __app_id ) {
            if ( number == MESSAGEID_APPLICATION_MENU_HANDLE_INPUT ) toggle_rainbow( data );

            if ( current_hue == -1 ) {
                llDialog( data, "Rainbow mode is disabled", [ TEXT_MENU_ENDING, "Enable" ], menu_channel );
            } else {
                llDialog( data, "Rainbow mode is enabled", [ TEXT_MENU_ENDING, "Disable" ], menu_channel );
            }
        }
    }

    // The code for the rainbow effect! Maybe you'd like to make it so you can set saturation? Or it isn't the full brightness? Try it out! Maybe you can add an extra command to set brightness.
    timer() {
        current_hue += 0.1;

        unit_color = < llSin( current_hue ), llSin( current_hue + TWO_PI / 3 ), llSin( current_hue + TWO_PI / 3 * 2 ) > / 2 + < 0.5, 0.5, 0.5 >;
        // This line pushes the new color out to all the other components, which will take care of pushing it to your external devices
        SEND_VARIABLE_DIRECT( unit_color );
    }
}
