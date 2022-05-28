# Chat commands for OeM controllers.

Chat commands can be introduced channel 1 by introducing the first two characters of the unit's identification, without distinguishig between lower or uppercases.

For example, to send a command to a unit whose name is L-Research-Unit, you'd have to use "l-command", for a unit named 632-78-123, yould have to use "63command", etc.

**IMPORTANT** If a unit has their serial number as their name, instead the first to letters of their username will be used (gonkaotic resident -> go )

A unit can issue commands to itself if their voice is being processed by the controller by simply staring the line with @, as shown in the examples.

For some commands, a certain level of access(permission) is required. See the [permissions](./menu-system#Manage-Roles) for more information

---
## A note on format

Every command has a "usage" section. In this section the document doesn't specify the prefix used but it should always have one (check above to see what it should be depending on the case).

Everything after the command is called a "Parameter". Parameters can be optional or mandatory. Optional parameters will be enclosed in square brackets []. Mandatory parameters will be enclosed in pointy brackets <>

Sometimes a parameter has some predefined options ( for example the command [servers](#Command:-servers) has two possible options for the first parameter) so they will be separated by a pipe <code>&#124;</code>. To differentiate what's an exact option ( meaning you can't deviate from the listed ones) and the options in which we just give a name to the parameter for clarification, these last ones will be encased in "". This doesn't mean that when issuing the command the parameter must be encased in them.

Finally, in the cases that were just explained, there can be extra parameters that can be added to certain options. To indicate which options they belong to, they will be preceeded by the option(or options) surrounded in curly brackets, and then the proper brackets to indicate if it is a mandatory parameter or not. For example, an optional parameter for the "software" option of the command servers will look like: {software}["server_name"].

We hope this, plus the examples, make the use of these commands clear.

---
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
+ Usage: servers <list <code>&#124;</code> software> {software}["server_name"]
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
+ Usage: software <list<code>&#124;</code>uninstall<code>&#124;</code>install> {uninstall,install}<"software_name">
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
+ Usage: color <"color">
+ Description:

	- Command to manage the main color of the controller. The color is specified in RGB format, from 0 to 255, separated by commas. If you want to make the controller white, the command would be "color 255,255,255" no spaces between the numbers, only comas.

+ Examples:
    - To change the color to red: **@color 255,0,0**

### Command: nick

+ Permissions required: Administration
+ Usage: nick <"new name">
+ Description:

	- Command to manage designation of the unit. The name can contain pretty much any known character, and it can have spaces. The initials to access via chat commands will be updated automatically.

+ Examples:
    - To change the unit's designation to "L-Research-Unit 375": **@nick L-Research-Unit 375**

### Command: rules
+ Permissions required: <to_be_determined>
+ Usage: rules
+ Description:
	
	- Command that will tell you the rules the unit is currently subjected to.
	
### Command: menu
+ Permissions required: Menu ( and more depending of the menu you decide to choose )
+ Usage: menu [subsystems<code>&#124;</code>admin<code>&#124;</code>follow<code>&#124;</code>IO<code>&#124;</code>power<code>&#124;</code>programming<code>&#124;</code>devices]
+ Description:
	
	- Command that will open a menu for you. You can specify the particular menu you want to open(in the list provided) or none, to open the main menu.
	
### Command: follow
+ Permissions required: follow
+ Usage: follow ["avatar"] ["distance"]
+ Description:

	- This commands takes up to two parameters, the first one is the person to follow and the second one is the distance from which to follow. If no parameters are given, the unit will follow the issuer of the command. The person to follow should be as much as you want of their username ( the more characters of their username you give, the more specific it will be). Alternatively, you can use "-stop" to finish the following action.

### Command: follow-dist
+ Permissions required: follow
+ Usage: follow-dist ["distance"]
+ Description:

	- This command allows you to specify the distance the unit will follow the target, without specifying a new target. That means that if the unit isn't following anyone, the distance will affect the next time a target is specified. If the unit is following someone already, the distance of following will be changed.


### Command: power
+ Permissions required: Toggle power
+ Usage: power <on<code>&#124;</code>off<code>&#124;</code>reboot>
+ Description:

	- This command allows you turns the unit on, off or reboots it. Each work only if the unit is in a state in which it can work. Turning a unit on when it already is doesn't make sense. If a unit is changing between states it won't work either.


### Command: initials
+ Permissions required: Administration
+ Usage: initials <"2 characters">
+ Description:

	- This command will let you change the intials used to issue more chat commands. If a string of more than 2 characters is used, only the first two characters will be taken. Please, ensure you remember the intials as of right now there is no way to reset it unless the unit is allowed administrative access to itself and uses the command ( using @initials )

### Command: relay
+ Permissions required: Menu
+ Usage: relay <"msg">
+ Description:

	- This command will relay, anonymously, the message to the unit ( as if it were a message from the controller ).


### Command: say
+ Permissions required: Menu
+ Usage: say [ -s <code>&#124;</code> -w] <"msg">
+ Description:

	- Outputs the message through the unit, unless the volume is off. The -w option makes the unit whisper. The -s option makes the unit shout. This command can't be used by the unit as it overrides the mind subsystem being off.

+ Examples:
    - To make a unit (with the initials go) say "I am a robot": /1 gosay I am a robot
    - To make a unit (with the initials go) whisper "I am groot": /1 gosay -w I am groot
    - To make a unit (with the initials go) shout "My name is Iñigo Montoya": /1 gosay -s My name is Iñigo Montoya

### Command: sit
+ Permissions required: subsystems
+ Usage: sit <"object name">
+ Description:

	- This command will force sit the unit into an object (no farther than 10 m) that starts with the same letters as the given parameter.

### Command: stand
+ Permissions required: subsystems
+ Usage: stand
+ Description:

	- This command will force the unit to stand. Please note that if the unit is prevented from standing, this command will fail silently.

### Command: subsystem
+ Permissions required: subsystems
+ Usage: subsystem < "subsystem_name" <code>&#124;</code> status > [new_state]
+ Description:

	- With this command you can check the status of a subsystem by adding its name as the second parameter. You can check all subsystems by using the keyword `status` as the second parameter. If you add a third parameter, you can also modify it as if you were on the subsystems menu. The available subsystem names are `mind`, `video`, `audio`, `speech`, `mind`, `volume`, `video`, `teleport`, `movement`, `jetpack`, `radar`, `startcomms`, `email`, `facial`, `geolocation`, `comms`. The third parameter can be either the keywords `on` and `off` or the numbers `1` and `0` respectively. For the special subsystmes, with more than two states, more keywords are provided:

	* `volume`: `mute` equivalent of `off`; `low` forces whisper; `normal` prevents shouting; `loud` is equivalent to `on`
	* `telport`: besides `on` and `off`; `block` prevents the unit from teleporting, but allows others to do so
	* `comms`: besides `on` and `off`; `RX` will prevent the unit just from receiving IMs; `TX` will prevent the unit just from sending IMs;
	* `movement`: `none` is equivalent of `off`; `block` will prevent the unit from moving without an order such as follow; `slow` prevents from running; `fast` is equivalent of `on`

### Command: bolts
+ Permissions required: Administration
+ Usage: bolts < on <code>&#124;</code> off <code>&#124;</code> powered>
+ Description:

	- This command will change the status of the bolts un the unit as if it were done through the menu.

## Special cases: Commands only for the unit

These are commands only the Controller's wearer can use. They are meant to be used only when everything else has failed in fixing the situation.

### Command: reset

+ Permissions required: NONE
+ Usage: reset <"script">
+ Description:

	- Allows you reset scripts. You can either use the full name or just the part after the "Core_". Upper case and lower case don't affect.

### Command: safeword

+ Permissions required: NONE
+ Usage: safeword
+ Description:

	- Safeword. This will give you back ownership of your controller as well as activate self-access. All subsystems will be turned off and the bolts will be unlocked.

### Command: hud_text

+ Permissions required: NONE
+ Usage: hud_text < name <code>&#124;</code> rules <code>&#124;</code> both > < height >
+ Description:

	- This command is used to modify the height of the text shown in the hud. It takes two mandatory parameters. The first is which text to move and the second is the ammount to move it by. The ammount is divided by 10 so an input of 1 will move the text 0.1 meters up. The name accepts three options: "name", "rules" and "both".

