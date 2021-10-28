# Chat commands for OeM controllers.

Chat commands can be introduced both in channel 0 ( local chat ) or channel 1 by introducing the first two characters of the unit's identification, without distinguishig between lower or uppercases. 
For example, to send a command to a unit whose name is L-Research-Unit, you'd have to use "l-command", for a unit named 632-78-123, yould have to use "63command", etc.

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
+ Usage: servers list|softwares <server_name>
+ Description: 

	- Command to learn about software servers in your region. 
	- The option "list" will list the names of the servers in your region.
	- The option "softwares" will list the server names as well as the software they have inside them. If you specify a sever name (not minding upper and lower cases) it will only inform you about the software in that server
	

### Command: software

+ Permissions required: Software
+ Usage: software list|uninstall <software_name>
+ Description: 

	- Command to manage software installed in the controller. 
	- The option "list "will list the software installed in the controller.
	- The option "uninstall" will delete the software specified afterwards. The name will be looked for without taking into consideration upper or lower case, or the version.	

### Command: color

+ Permissions required: Administration
+ Usage: color <color>
+ Description: 

	- Command to manage the main color of the controller. The color is specified in RGB format, from 0 to 255, separated by commas. If you want to make the controller white, the command would be "color 255,255,255" no spaces between the numbers, only comas.

### Command: nick

+ Permissions required: Administration
+ Usage: nick <new name>
+ Description: 

	- Command to manage designation of the unit. The name can contain pretty much any known character, and it can have spaces. The initials to access via chat commands will be updated automatically.

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
