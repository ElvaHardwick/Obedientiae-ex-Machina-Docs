# Main Menu

This is the menu that opens up when the  controller is first accessed

## Subsystems Menu

Menu that controls the unit's subsystems through RLV. If the tick(✔) is next to the subsystem it means it is currently allowed, an ❌ means it is restricted.

### Video input
Allows/denies the unit to see ( vision restrictions might depend on the viewer you are using )

### Audio Input
Allows/denies the unit to hear chat and emotes. ((not xure if this automatically activated input filtering for emotes, would have to check. Doesn't clear the chat inside the emptes))**TODO**

### Radar
Allows/denies the unit to see the radar, to see who is nearby ( doesn't restrict it from checking minimap)

### Facial Recognition
Allows/denies the unit to recognize those around them ( see their names and  nametags )

### Geolocation
Allows/denies the unit to see their current position in world ( blocks map and location )

### Mind
Allows/denies the unit to chat. Currently similar to setting the volume to mute, but in the future it will have more uses **TODO**
one of it's uses is that the unit can't control the speakers in them, but other external commands might be able to. ((should probably be a fifth level volume...?))

### Volume Level
Has four levels:
Mute(🔈): doesn't allow chat.
Whisper(🔉): Only allows whisper
No shout(🔇): Allows normal and whisper, but no shouting.
Normal(🔊): No restriction applied.

### Movement...
Submenu inside subsystems. Controls the Unit's abilities to move in the world.

#### Jetpack
Allows/denies the unit to Fly ()

#### Teleport
Has three levels.
No teleport: Doesn't allow any teleport
Secured teleport(🔒): The unit can't use the teleport, but others can teleport it
Teleport allowed:

#### Movement
Has three levels:
No movement: freezes the unit's motors, which doesn't mean they can't still use other methods of movement such as teleporting.
Secured Movement(🔒): takes away the control from the unit, but if there are external commands to move ( such as follow) the unit motors will answer to them
Slow Movement(▶): Allows the unit only to walk, no running
Normal Movement(⏩): Unit is able to walk and run normally

### LoRa Comms.
submenu that controls long range communications 

#### Start Comms.
Allows/denies the unit to start long range communications ( Instant messages)

#### Comms
Once more, three levels, realted to Long Range(LoRa) communications ( Instant Messages ):
Receive(⤵️): Only allows receiving
Send(⤴️): Only allows sending
Normal: allows both sending and receiving

#### Email
Allows/denies the unit to read emails ( Notecards )

### [PRESETS]
Opens the preset menu, which will list the current saved Subsystems presets. You can also add one with the current values of the subsystem menu. If you click in one of the named presets a new menu will open which will allow you to apply, delete or modify the preset.

## IO Menu

### Out. Filters
Not implemented **TODO**

### In. Filters 
Not implemented **TODO**

### Out. release
Allows/denies the unit to release their output ( allows them to use the command !release to free their voice from the controller )

### Release input./ Filter input
(( currently blocks chat and emotes, but I am guessign the difference is that the chat is not completely blocked, but simply filtered))


## Administration

### Access

#### User list
Lists of users with a role inside the unit's controller. You can click on them to modify their role or to remove them. You can also add new users to the controller, in which case the default role will be "user"

#### Manage Roles
It will list the different roles supported by this controller. If you have the permissions required you are able to open them and modify the permissions of each of the roles. 
These are the current permissions supported:
+ Menu: grants access to the main menu, so it will be able to use the [follow](#follow) and [status](#status) functionalities.
+ Power: Allows turning on and off the unit as well as rebooting (grants access to [power menu](#power))
+ Subsystems: Allows access to the [subsystems menu](#subsystems-menu)
+ Programming: Allows access to the [programming menu](#prgramming)
+ Admin: Allows opening the [administration menu](#administration), therefor allowing [personalization](#personalization) and changing the controller [bolt setting](#bolts)
+ Software: Allows entering the [software menu](#software) to manage it. 
+ Add user: Allows adding or removing users via the [users menu](#user-list)
+ Access: Allows entering the [access menu](#access), thus allowing to add to blacklist, change the public access settings and the self access
+ Users: Allows modifying a user role via the [users menu](#user-list)
+ Roles: Allows opening this menu ([roles](#manage-roles)) to modify what each role can do

As you might be able to see, some roles block others at the moment (since there is no other way to access the controller except via a menu), for example, having all permissions except Menu permission is useless, since you won't be able to access anything. In the future there will be more ways to access the controller and this won't matter as much.

#### Blacklist
List blacklisted avatars, if you click on them you can change their role or remove them from the blacklist

#### Public Access
Opens the menu to modify the permissions to for those not listed in the controller as any role. It follows the same model as the one open in [Manage Roles](#manage-roles)

#### Self Access

Toggles self access, so the unit can't access it's own controller. 

### Bolts
Toggles the bolt status between three modes:
on: Bolts are always on: this will lock the controller to the unit
off: Bolts will be unlocked: this will allow the removal of the controller at all times.
powered: Bolts will depend on the unit power status: if the power is off ( the unit is turned off) the bolts will be off. If the unit is on, the bolts will be on. 

### Personalization

#### Name
Opens a dialog to change the name of the unit
#### Color
Opens a dialog to change the color of the unit, it must be introduced in RGB format, with commas separating the numbers from 0-255. An example could be Red: 255,0,0

#### Gender
Allows the personalization of the unit's gender. By default it is They/them/theirs, but can be changed to she/her/hers, he/him/his or it/it/its


### Software

#### Installed
List of installed software. If none is installed it will inform so and return to the Software page. If inside the menu you choose one o the softwares it will give you the more options


#### Uninstall
lists installed software so you can uninstall it

#### Servers
Lists OeM servers in the region, and if you choose one, connects you to them to install or update software

## Power

### Shutdown
Turns the unit off

### Boot
Turns the unit on

### Restart
Reboots the unit

## Status
Not implemented **TODO**

## Applications
Not implemented **TODO**

## Follow
Opens a menu listing people and the distances to them. If you select one of them, the unit will follow them. Exactly the same path they take, the unit will take it too.

### [Distance]
Opens a menu which allows to set the distance from which the unit will follow

#### [Custom]
Opens a Textbox to set the distance you want the unit to follow from (use a period if you want to set a decimal number)

## Programming
Gives a menu with the different options programmed via notecards. 

## Devices
Shows a list of the devices connected to the controller. If you click them you can obtain information about them, as well as diconnecting them.

