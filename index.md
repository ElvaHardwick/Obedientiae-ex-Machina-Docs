# Main Menu

This is the menu that opens up when the  controller is first accessed

## Subsystems Menu

Menu that controls the unit's subsystems through RLV. If the tick is next to the subsystem it means it is currently allowed, an x means it is restricted.

### Video input
Allows/denies the unit to see ( vision restrictions depend on the viewer you are using )

### Audio Input
Allows/denies the unit to hear chat and emotes. ((not xure if this automatically activated input filtering for emotes, would have to check. Doesn't clear the chat inside the emptes))**TODO**

### Radar
Allows/denies the unit to see the radar, to see who is nearby ( doesn't restrict it from checking minimap)

### Facial Recognition
Allows/denies the unit to recognize those around them ( see their names and  nametags )

### Geolocation
Allows/denies the unit to see their current position in world ( blocks map and location )

### Mind
Allows/denies the unit to chat. Currently similar to setting the volume to mute, but in the future it will have more uses.
one of it's uses is that the unit can't control the speakers in them, but other external commands might be able to.

### Volume Level
Has four levels:
 * Mute(): doesn't allow chat.
 * Whisper(): Only allows whisper
 * No shout(): Allows normal and whisper, but no shouting.
 * Normal(): No restriction applied.

### Movement...
Submenu inside subsystems. Controls the Unit's abilities to move in the world.

#### Jetpack
Allows/denies the unit to Fly ()

#### Teleport
Has three levels.
No teleport(): Doesn't allow any teleport
Secured teleport((??????? not sure what this one does at the moment, I am guessing allows teleport by certain people))
Teleport allowed():

#### Movement
Has three levels:
No movement: freezes the unit's motors, which doesn't mean they can't still use other methods of movement such as teleporting.
Secured Movement(): takes away the control from the unit, but if there are external commands to move ( such as follow) the unit motors will answer to them
Slow Movement(): Allows the unit only to walk, no running
Normal Movement: Unit is able to walk and run normally

### LoRa Comms.
submenu that controls long range communications

#### Start Comms.
Allows/denies the unit to start long range communications ( Instant messages)

#### Comms
Once more, three levels, realted to Long Range(LoRa) communications ( Instant Messages ):
Receive(): Only allows receiving
Send(): Only allows sending
Normal(): allows both sending and receiving

#### Email
Allows/denies the unit to read emails ( Notecards )

### [PRESETS]
**TODO**

## IO Menu

### Out. Filters

### Out. release
Allows/denies the unit to release their output ( allows them to use the command !release to free their voice from the controller )

### Release input./ Filter input
(( currently blocks chat and emotes, but I am guessign the difference is that the chat is not completely blocked, but simply filtered))


## Administration

## Power

### Shutdown
Turns the unit off

### Boot
Turns the unit on

### Restart
Reboots the unit

## Status

## Applications

## Follow

## Programming
