/////////////////////////////////////////////////////
// App_Minimal, copyright OeM 2022
// You are free to use this code as a basis for your own applications for OeM products
//
// All other uses by request, contact by discord (https://discord.gg/j44BhKHBjw) or in Second Life (elvahardwick or gonkaotic)
/////////////////////////////////////////////////////

// This file is important, you need it unless you want to do a lot of tedious work of copy pasting, it's availabe from https://elvahardwick.github.io/Obedientiae-ex-Machina-Docs/application-api - Same as this sample code!
#include "OeM_Api.lsl"

#define APPLICATION_COMMANDS ["hello_world"]

default
{
    state_entry()
    {
        // This is an important line that does.. a lot of work, it will tell the controller that this script exists, who wrote it, what it's name is and what options it has.
        // We're saying here that we have a menu, and commands!
        OEM_APPLICATION_INIT( "Elva Hardwick", "Minimal", "v0.1.0", APPLICATION_FLAG_HAS_COMMANDS );
    }

    changed( integer change ) {
        // Simple little thing that checks if owner changed and resets the script to ensure everything gets registred
        CHANGED_DEFAULT_HANDLERS;
    }

    link_message(integer sender, integer number, string message, key data) {
        // Another important line for an application, will make sure that if something gets reset we still work, and that all the necessary things are informed about us
        REGISTER_APPLICATION_ON_MESSAGE();

        // This is where we handle both the help functionallity, and the actual functionallity for the commands
        START_COMMAND_HANDLE
            START_HELP_HANDLE
                HELP( "hello_world", "\nUsage: hello_world\n\nPrints 'hello world'.")
            END_HELP_HANDLE

            // This indicates that the command hello_world *needs* the ADMINISTRATION premission, you could also change this to COMMAND_HANDLE if you don't think it needs permissions
            COMMAND_WITH_PERMISSIONS_HANDLE( "hello_world", PERMISSION_ADMINISTRATION_FLAG )
                DO_OEM_ANNOUNCE( "Hello soon to be conquered world!" )
            END_COMMAND_HANDLE
        END_COMMAND_GROUP_HANDLE
    }
}
