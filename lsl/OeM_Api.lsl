/////////////////////////////////////////////////////
// OeM_Api, copyright OeM 2022
// You are free to use this code as a basis for your own applications for OeM products
//
// All other uses by request, contact by discord (https://discord.gg/j44BhKHBjw) or in Second Life (elvahardwick or gonkaotic)
/////////////////////////////////////////////////////

// Utillity defines
#define ENCODE_LIST_2_STRING_SEP llChar( 0xE010 )
#define ENCODE_LIST_2_STRING( s ) llDumpList2String( s, ENCODE_LIST_2_STRING_SEP  )
#define DECODE_LIST_2_STRING( s ) llParseStringKeepNulls( s, [ ENCODE_LIST_2_STRING_SEP ], [] )
#define ENCODE_LIST_2_STRING_2_SEP llChar( 0xE011 )
#define ENCODE_LIST_2_STRING_2( s ) llDumpList2String( s, ENCODE_LIST_2_STRING_2_SEP )
#define DECODE_LIST_2_STRING_2( s ) llParseStringKeepNulls( s, [ ENCODE_LIST_2_STRING_2_SEP ], [] )

// Message IDs for variables
#define MESSAGEID_REQUEST_CONFIGURATION 20
#define MESSAGEID_SET_CONFIGURATION 21
#define MESSAGEID_STORE_CONFIGURATION 22

#define MESSAGEID_REQUEST_VARIABLE 25
#define MESSAGEID_SET_VARIABLE 26
#define MESSAGEID_STORE_VARIABLE 27

#define REQUEST_CONFIGURATION SEND_LINKED_MESSAGE( MESSAGEID_REQUEST_CONFIGURATION, [], "" )

#define SEND_LINKED_MESSAGE_RAW( message_id, parameters, avatar ) llMessageLinked( LINK_SET, \
    message_id, \
    parameters, \
    avatar )
#define SEND_LINKED_MESSAGE( message_id, parameters, avatar ) SEND_LINKED_MESSAGE_RAW( message_id, ENCODE_LIST_2_STRING( ( parameters ) ), avatar )

#define CHANGED_DEFAULT_HANDLERS \
    if ( change & CHANGED_OWNER ) { llResetScript(); }

// Message IDs for linked numbers
#define MESSAGEID_REQUEST_COMMANDS				1602
#define MESSAGEID_ADD_COMMAND					1603
#define MESSAGEID_REM_COMMAND					1604
#define MESSAGEID_PROCESS_COMMAND				1605
#define MESSAGEID_PERM_CHECK_COMMAND			1606
#define MESSAGEID_PROCESS_COMMAND_AUTH			1607
#define MESSAGEID_PROCESS_IMPL_COMMAND			1608

#define PERMISSION_TOGGLE_POWER_FLAG 		0x00000001
#define PERMISSION_SUBSYSTEMS_FLAG 			0x00000002
#define PERMISSION_PROGRAMMING_FLAG			0x00000004
#define PERMISSION_FOLLOW_FLAG				0x00000008

#define PERMISSION_ADD_USER_FLAG 			0x00000010
#define PERMISSION_OPEN_MENU_FLAG 			0x00000020
#define PERMISSION_MANAGE_SOFTWARE_FLAG 	0x00000040
#define PERMISSION_ADMINISTRATION_FLAG		0x00000080

#define PERMISSION_ACCESS_FLAG				0x00000100
#define PERMISSION_USERS_FLAG				0x00000200
#define PERMISSION_ROLES_FLAG				0x00000400
#define PERMISSION_UPLOAD_PROGRAMMING		0x00000800

// Command handlers
#define REREGISTER_COMMAND() \
        SEND_LINKED_MESSAGE(MESSAGEID_REM_COMMAND, ( APPLICATION_COMMANDS ), NULL_KEY); \
        SEND_LINKED_MESSAGE(MESSAGEID_ADD_COMMAND, ( APPLICATION_COMMANDS ), NULL_KEY)

#define START_COMMAND_HANDLE \
    if ( number == MESSAGEID_REQUEST_COMMANDS ) SEND_LINKED_MESSAGE(MESSAGEID_ADD_COMMAND, ( APPLICATION_COMMANDS ), NULL_KEY); \
    else if ( number == MESSAGEID_APPLICATION_REQUEST_COMMANDS ) SEND_LINKED_MESSAGE(MESSAGEID_APPLICATION_LIST_COMMANDS, ( APPLICATION_COMMANDS ), (key)__app_id); \
    else if ( number == MESSAGEID_PROCESS_COMMAND || number == MESSAGEID_PROCESS_COMMAND_AUTH ) { \
								list info = DECODE_LIST_2_STRING(message); \
								integer command_origin = llList2Integer(info, 0);\
								string command = llToLower(llList2String(info, 1)); \
								list parameters = [];\
								if (llGetListLength(info) > 2) parameters = llList2List(info, 2, -1); \
								integer parameters_length = llGetListLength(parameters);
#define END_COMMAND_GROUP_HANDLE @command_processing_end;}
#define END_COMMAND_HANDLE jump command_processing_end;}

#define START_HELP_HANDLE if ( command == "help" ) { string topic = llList2String(parameters, 0);
#define HELP( c, help ) if ( topic == c ) { llRegionSayTo(data, 0, "Command \""+c+"\": "+help); END_COMMAND_HANDLE
#define END_HELP_HANDLE }

#define COMMAND_WITH_PERMISSIONS_HANDLE( command_name, required_perms ) \
    if ( command == command_name ) \
        if ( number == MESSAGEID_PROCESS_COMMAND ) {\
            SEND_LINKED_MESSAGE( MESSAGEID_PERM_CHECK_COMMAND, ( [ required_perms, MESSAGEID_PROCESS_COMMAND_AUTH, llDumpList2String( info, llChar( 0xE011 ) ) ] ), data ); \
            jump command_processing_end; \
        } else if ( number == MESSAGEID_PROCESS_COMMAND_AUTH ) {

#define COMMAND_HANDLE( command_name ) \
    if (  && command == command_name ) {


#define ON_REQUEST_FOR_COMMANDS( commands ) if ( number == MESSAGEID_REQUEST_COMMANDS ) SEND_LINKED_MESSAGE(MESSAGEID_ADD_COMMAND, commands, NULL_KEY);

// Register applications
#define MESSAGEID_APPLICATION_REQUEST           1700
#define MESSAGEID_APPLICATION_REGISTER          1701
#define MESSAGEID_APPLICATION_REQUEST_COMMANDS  1702
#define MESSAGEID_APPLICATION_LIST_COMMANDS     1703
#define MESSAGEID_APPLICATION_PRINT_STATUS      1704

#define MESSAGEID_APPLICATION_MENU_OPEN         1710
#define MESSAGEID_APPLICATION_MENU_HANDLE_INPUT 1711

#define APPLICATION_REGISTER() SEND_LINKED_MESSAGE( MESSAGEID_APPLICATION_REGISTER, ( [ llGetScriptName() , __app_name, __app_author, __app_version, __app_flags, __app_id, /*OeM Api Version number*/ 1, ENCODE_LIST_2_STRING_2( APPLICATION_COMMANDS ) ] ), NULL_KEY )
#define REGISTER_APPLICATION_ON_MESSAGE() if ( number == MESSAGEID_APPLICATION_REQUEST ) APPLICATION_REGISTER()

#define APPLICATION_MENU_CHARACTER "⮞"

// Localized constants
#define TEXT_MENUBUTTON_BACK "[Back]"
#define TEXT_MENUBUTTON_QUIT "[Quit]"
#define TEXT_MENUBUTTON_ADD "[Add]"
#define TEXT_MENUBUTTON_ALL "[All]"
#define TEXT_MENUBUTTON_NONE "[None]"
#define TEXT_MENUBUTTON_NEXT "[Next]"
#define TEXT_MENUBUTTON_PREV "[Prev]"
#define TEXT_MENUBUTTON_REFRESH "[Refresh]"

#define TEXT_MENU_ENDING " ", TEXT_MENUBUTTON_BACK, TEXT_MENUBUTTON_QUIT
#define TEXT_MENU_ENDING_ADD TEXT_MENUBUTTON_ADD, TEXT_MENUBUTTON_BACK, TEXT_MENUBUTTON_QUIT
#define TEXT_MENU_ENDING_ALL TEXT_MENUBUTTON_ALL, TEXT_MENUBUTTON_BACK, TEXT_MENUBUTTON_QUIT
#define TEXT_MENU_ENDING_NO_BACK " ", " ", TEXT_MENUBUTTON_QUIT

#define OEM_WHISPER 						"oemwhisper"
#define OEM_SHOUT 						    "oemshout"
#define OEM_NORMAL 						    "oemnormal"
#define OEM_THINK 						    "oemthink"
#define OEM_ANNOUNCE					    "oemaanounce"
#define OEM_ANNOUNCE_W					    "oemaanouncew" //Whisper announce
#define OEM_ANNOUNCE_S					    "oemaanounces" //Shout announce
#define MESSAGEID_OUTPUT_VOICE 			    705

#define DO_OEM_WHISPER( msg ) SEND_LINKED_MESSAGE_RAW( MESSAGEID_OUTPUT_VOICE, msg, (key)OEM_WHISPER )
#define DO_OEM_SHOUT( msg ) SEND_LINKED_MESSAGE_RAW( MESSAGEID_OUTPUT_VOICE, msg, (key)OEM_SHOUT )
#define DO_OEM_NORMAL( msg ) SEND_LINKED_MESSAGE_RAW( MESSAGEID_OUTPUT_VOICE, msg, (key)OEM_NORMAL )
#define DO_OEM_THINK( msg ) SEND_LINKED_MESSAGE_RAW( MESSAGEID_OUTPUT_VOICE, msg, (key)OEM_THINK )
#define DO_OEM_ANNOUNCE( msg ) SEND_LINKED_MESSAGE_RAW( MESSAGEID_OUTPUT_VOICE, msg, (key)OEM_ANNOUNCE )
#define DO_OEM_ANNOUNCE_W( msg ) SEND_LINKED_MESSAGE_RAW( MESSAGEID_OUTPUT_VOICE, msg, (key)OEM_ANNOUNCE_W )
#define DO_OEM_ANNOUNCE_S( msg ) SEND_LINKED_MESSAGE_RAW( MESSAGEID_OUTPUT_VOICE, msg, (key)OEM_ANNOUNCE_S )

string __app_id;
string __app_name;
string __app_author;
string __app_version;
integer __app_flags;

#define APPLICATION_FLAG_HAS_MENU 0x0001
#define APPLICATION_FLAG_HAS_COMMANDS 0x0002
#define APPLICATION_FLAG_HAS_STATUS 0x0004

#define OEM_APPLICATION_INIT( app_author, app_name, app_version, flags ) \
        __app_author = app_author; __app_name = app_name; __app_version = app_version; __app_flags = flags; \
        __app_id = llSHA1String( llGetScriptName() ); \
        REQUEST_CONFIGURATION; \
        if ( flags & APPLICATION_FLAG_HAS_COMMANDS ) REREGISTER_COMMAND(); \
        APPLICATION_REGISTER()


// Variable handling
#define REQUEST_VARIABLES SEND_LINKED_MESSAGE_RAW( MESSAGEID_REQUEST_VARIABLE, "", "" )

#define START_READ_VARIABLE_ON_MESSAGE \
    if ( number == MESSAGEID_SET_VARIABLE || number == MESSAGEID_SET_CONFIGURATION ) {\
        list parameters = DECODE_LIST_2_STRING( message ); \
        integer i = 0; \
        integer n = llGetListLength( parameters ); \
        for ( i = 0; i < n; i += 2 ) { \
            string m = llList2String( parameters, i ); \
            if ( 0 ) { }

#define READ_VAR( name, parse ) else if ( m == #name ) { name = parse( parameters, i + 1 ); }
#define READ_VAR_LIST( name ) else if ( m == #name ) { name = DECODE_LIST_2_STRING_2( llList2String( parameters, i + 1 ) ); }
#define READ_VAR_INT( name ) READ_VAR( name, llList2Integer )
#define READ_VAR_STRING( name ) READ_VAR( name, llList2String )
#define READ_VAR_VECTOR( name ) else if ( m == # name ) { name = (vector)llList2String( parameters, i + 1 ); }

#define END_READ_VARIABLE_ON_MESSAGE \
        } \
    }

#define SEND_VARIABLE_DIRECT( name ) SEND_LINKED_MESSAGE( MESSAGEID_SET_VARIABLE, ( [ #name, name ] ), "" );
#define SEND_VARIABLE_DIRECT_LIST( name ) SEND_LINKED_MESSAGE( MESSAGEID_SET_VARIABLE, ( [ #name, ENCODE_LIST_2_STRING_2( name ) ] ), "" );

#define SET_VARIABLE_DIRECT( name, value ) name = value; SEND_LINKED_MESSAGE( MESSAGEID_SET_VARIABLE, ( [ #name, name ] ), "" );
#define SET_VARIABLE_DIRECT_LIST( name, value ) name = value; SEND_LINKED_MESSAGE( MESSAGEID_SET_VARIABLE, ( [ #name, ENCODE_LIST_2_STRING_2( name ) ] ), "" );
