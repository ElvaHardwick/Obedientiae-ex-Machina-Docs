# Chat commands for OeM controllers.

Chat commands can be introduced both in channel 0 ( local chat ) or channel 1 by introducing the first two characters of the unit's identification, without distinguishig between lower or uppercases. 
For example, to send a command to a unit whose name is L-Research-Unit, you'd have to use "l-command", for a unit named 632-78-123, yould have to use "63command", etc.

**IMPORTANT** If a unit has their serial number as their name, instead the first to letters of their username will be used (gonkaotic resident -> go )

For some commands, a certain level of access(permission) is required. See the [permissions](./index#Manage-Roles) for more information

## List of available commands
	
### Command: release

+ Permissions required: Menu
+ Usage: release
+ Description: 

	- Releases the voice from the controller. If the voice wasn't controlled nothing happens.

### Command: capture

+ Permissions required: Menu
+ Usage: capture
+ Description: 

	- Captures the voice through the controller. If the voice was already controlled nothing happens.

### Command: servers

+ Permissions required: Software
+ Usage: servers list|software <server_name>
+ Description: 

	- Command to learn about software servers in your region. 
	- The option "list" will list the names of the servers in your region.
	- The option "software" will list the server names as well as the software they have inside them. If you specify a sever name (not minding upper and lower cases) it will only inform you about the software in that server

+ Examples:
    - To list the servers available: **@servers list**

        It will returns something like:
    >       Available servers:
    >           OeM_Beta
    >           OeM_Employees
    - To list the softwares in the available servers: **@servers software**

        It will return something like:
    >        Available softwares per server:
    >           Server "OeM_Beta" offers:
    >                - OeMCore_1.1
    >                - OeMCore_1.0
    >            Server "OeM_Employees" offers:
    >                - ESU-programming
    >                - DSU-programming
    - To list the softwares in a specific servers(in this case OeM_Beta): **@servers software OeM_Beta**

        It will return something like:
    >        Available softwares per server:
    >            Server "OeM_Beta" offers:
    >                - OeMCore_1.1
    >                - OeMCore_1.0


### Command: software

+ Permissions required: Software
+ Usage: software list|uninstall|install <software_name>
+ Description: 

	- Command to manage software installed in the controller. 
	- The option "list "will list the software installed in the controller.
	- The option "uninstall" will delete the software specified afterwards. The name will be looked for without taking into consideration upper or lower case, or the version
	- **IMPORTANT** WIP, not implemented yet. ~~The option "install" will install software from a nearby server.~~

+ Examples:
    - To list installed softwares: **@software list**

        It will returns something like:
        >   Installed Software:
               OeMCore_1.0
               DefaultConfig_1.0
    - To uninstall a software: **@software uninstall DefaultConfig_1.0**

        It will returns something like:
        > Finished uninstalling -DefaultConfig_1.0

    - To install a software offered by a nerby server (see [Command: servers](#Command:-servers)): **@software install ESU-programming**

        **IMPORTANT** WIP, not implemented yet.

### Command: color

+ Permissions required: Administration
+ Usage: color <color>
+ Description: 

	- Command to manage the main color of the controller. The color is specified in RGB format, from 0 to 255, separated by commas. If you want to make the controller white, the command would be "color 255,255,255" no spaces between the numbers, only comas.

+ Examples:
    - To change the color to red: **@color 255,0,0**

### Command: nick

+ Permissions required: Administration
+ Usage: nick <new name>
+ Description: 

	- Command to manage designation of the unit. The name can contain pretty much any known character, and it can have spaces. The initials to access via chat commands will be updated automatically.

+ Examples:
    - To change the unit's designation to "L-Research-Unit 375": **@nick L-Research-Unit 375**

### Command: rules
+ Permissions required: <to_be_determined>
+ Usage: rules
+ Description:
	
	- Command that will tell you the rules the unit is currecntly subjected to. 
	
### Command: menu
+ Permissions required: Menu ( and more depending of the menu you decide to choose )
+ Usage: menu [subsystem]
+ Description:
	
	- Command that will open a menu for you. You can specify the particular menu you want to open(in the list provided) or none, to open the main menu.
	
### Command: follow
+ Permissions required:
+ Usage: follow [avatar] [distance]
+ Description:

	- This commands takes up to two parameters, the first one is the person to follow and the second one is the distance from which to follow. If no parameters are given, the unit will follow the issuer of the command. The person to follow should be as much as you want of their username ( the more characters of their username you give, the more specific it will be). Alternatively, you can use "-stop" to finish the following action.

### Command: follow-dist
+ Permissions required:
+ Usage: follow-dist [distance]
+ Description:

	- This command allows you to specify the distance the unit will follow the target, without specifying a new target. That means that if the unit isn't following anyone, the distance will affect the next time a target is specified. If the unit is following someone already, the distance of following will be changed.


	
	

## Special cases: Commands only for the unit

These are commands only the Controller's wearer can use. They are meant to be used only when everything else has failed in fixing the situation.

### Command: reset

+ Permissions required: NONE
+ Usage: reset <script>
+ Description: 

	- Allows you reset scripts. You can either use the full name or just the part after the "Core_". Upper case and lower case don't affect.

### Command: safeword

+ Permissions required: NONE
+ Usage: safeword 
+ Description: 

	- Safeword. This will give you back ownership of your controller as well as activate self-access. All subsystems will be turned off and the bolts will be unlocked. 
