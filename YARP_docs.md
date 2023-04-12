# New ORIX

## Table of contents

## New implementation

## Commands

### Command *Ping*

- **Description**: Command used by controller or device to make sure the other is still there

- **Number**: $$ORIX_COMMAND_PING$$

- **Parameters**:

- **Example**:

        ORIX_MESSAGE_BROADCAST($$ORIX_COMMAND_PING$$, []);

- **Answers**:

    + **PONG**

### Command *Pong*

- **Description**: Command used by controller or device to let the other know it is still there

- **Number**: $$ORIX_COMMAND_PONG$$

- **Parameters**:

- **Example**:

        ORIX_MESSAGE_BROADCAST($$ORIX_COMMAND_PONG$$, []);

- **Answers**:

### Command *Hello*

- **Description**: Command used by controller to let devices know they are there.

- **Number**: $$ORIX_COMMAND_HELLO$$

- **Parameters**:

    0. **Brand**: The brand of the controller

    1. **CoreVersion**: The version of software the controller is at.

    2. **ORIXVersion**: The version of ORIX the controller implements.

- **Example**:

        ORIX_MESSAGE_BROADCAST($$ORIX_COMMAND_HELLO$$, ["OEM", "4.0", "1.0"])

- **Answers**

    + **Connect**

### Command *Goodbye*

- **Description**: Command used by controller OR device to let the other know the connection is ending, either because of detachment, or becausethe connection is no longer needed.

- **Number**: $$ORIX_COMMAND_GOODBYE$$

- **Parameters**:

    0. **Reason**: A small description of why this command is sent. Quite useful to let the user know what is the situation, but especially helpfulfor debugging

- **Example**:

        ORIX_MESSAGE_BROADCAST($$ORIX_COMMAND_GOODBYE$$, ["Script reset."]);

- **Answers**

    + No answer expected

### Command *Register*

- **Description**: Command used by devices to request a connection to the controller. Depending on the ownership of the device requesting this access, it will be allowed or not.

- **Number**: $$ORIX_COMMAND_GOODBYE$$

- **Parameters**:

    0. **DeviceType**: The type of the device connecting. Almost any value will be accepted, however there will be some particular that will produce different responses from the controller, such as battery types. You can be more than one! Consider it more like tags.
    The recognized values for OEM are:

        + Battery: A devices that stores energy. There can be only one registered at a time. Once registered, the controller will request more information about the battery.

            + value: 0x00000001

        + AccessPoint: Represents Devices that give others a point to attempt to access the controller through a menu.

            + value: 0x00000002

        + Button: Usually a device with only one action, such as turning on and off the unit

            + value: 0x00000004

        + Handle: Devices meant for carrying or directing a unit.

            + value: 0x00000008

        + Display: A display or storage device.

            + value: 0x0000000F

    1. **Flags**: Flags that give more information about the device.

        + HasMenu

        + RequiresBattery

        + RequiresAdminAccess

    2. **Name** *(optional)*: The name by which the device will be identified

    3. **BatteryConsuption** *(optional)*: How much power does the device draw.

- **Example**:

        ORIX_MESSAGE_BROADCAST($$ORIX_COMMAND_REGISTER$$, ["Battery", 0]);

- **Answers**

    + **Welcome**: If the device is allowed

    + **Error**: If the device isn't allowed

### Command *Welcome*

- **Description**: Command used by controller when a device has been allowed to register.

- **Number**: $$ORIX_COMMAND_WELCOME$$

- **Parameters**:

- **Example**:

        ORIX_MESSAGE_BROADCAST($$ORIX_COMMAND_WELCOME$$, []);

- **Answers**

    + No answer expected, but other commands will likely follow such as <<>>

### Command *Failed*

- **Description**: Command used by controller when a device has issued a command that has failed.

- **Number**: $$ORIX_COMMAND_Failed$$

- **Parameters**:

    0. Integer: The command that failed.

    1. String: A reason as to why the command failed. They tend to be concise, due to memory restrictions.

- **Example**:

        ORIX_MESSAGE_BROADCAST($$ORIX_COMMAND_ERROR$$, [$$ORIX_COMMAND_REGISTER$$, "Not enough permissions"]);

- **Answers**

    + No answer expected

### Command *Subscribe*

- **Description**: Command used by device to ask the controller to keep it informed of values

- **Number**: $$ORIX_COMMAND_SUBSCRIBE$$

- **Parameters**:

    0. Flags: An integer with the flags of the values to subscribe to

        + **Color**: Color of the unit

            + Value: 0x00000001

        + **Identification**: Serial number and display

            + Value: 0x00000002

        + **Programming**: Which Programming is currently on.

            + Value: 0x00000004

        + **Subsystem**: When subsystems change

            + Value: 0x00000008

        + **Menu**: Whether the menu is in use

            + Value: 0x00000010

        + **Power**: Whether the unit is on or not

            + Value: 0x00000020

        + **Battery**: The battery level.

            + Value: 0x00000040

        + **Charging**: Is the unit charging

            + Value: 0x00000080

        + **PowerUsage**: How much power is unit requiring

            + Value: 0x00000100

        + **Follow**: Gives information about who the unit is following and from what distance

            + Value: 0x00000200

        + **Devices**: Gives information about what devices connect.

            + Value: 0x00000400

        + **Software**: Gives information about installed software

            + Value: 0x00000800



- **Example**:

        ORIX_MESSAGE_BROADCAST($$ORIX_COMMAND_SUBSCRIBE$$, [1]); // will subscribe only to Color
        ORIX_MESSAGE_BROADCAST($$ORIX_COMMAND_SUBSCRIBE$$, [3]); // will subscribe to Color and Identification

- **Answers**

    + Status message is likely to follow




### Command *OpenMenu*

- **Description**: Command used by devices to indicate the controller to open a menu for a certain avatar. The menu will only open if the avatar has enough permissions, but no error message will be sent if not, since the problem is not from the command.

- **Number**: $$ORIX_COMMAND_MENU$$

- **Parameters**:

    0. Avatar: Who to open the menu to.

    1. Menu(optional): Menu to open. If none is given, it will open main menu.

- **Example**:

        ORIX_MESSAGE_BROADCAST($$ORIX_COMMAND_MENU$$, ["6f73f209-52dd-4305-b46d-bd63ea572177"]); // Will open the maun menu

- **Answers**

    + No answer expected

### Command *DeviceMenu*

- **Description**: Command used by the controller to indicate a device it's menu is opened. The menu system will be explained in a different file.

- **Number**: $$ORIX_COMMAND_DEV_MENU$$

- **Parameters**:

    0. Avatar: Who to open the menu to.

    1. MenuChannel: Channel to open.

    2. MenuState: State of the device menu. Empty string means root.

    3. Button: Button selected. When a new menu is generated, this value will be empty.

- **Example**:

        ORIX_MESSAGE_BROADCAST($$ORIX_COMMAND_DEV_MENU$$, ["6f73f209-52dd-4305-b46d-bd63ea572177", -67898263, "", ""]); // Will open the main menu

- **Answers**

    + No answer expected by the controller. But the Avatar will be expecting a dialog, most likely.


### Command *status*

- **Description**: Command used by the controller to rely the status of values inside the controller

- **Number**: $$ORIX_COMMAND_STATUS$$

- **Parameters**:

    0. **Subscribe Flag**: Flag from the Subscribe command of the info we are being given. Depending on which one is it, more arguments will follow.

        + **Devices**:

             0. List of devices names.

             1. List of devices Types.

             2. List of devices IDS

        + **Subsystems**:

            0. Integer: Current Subsystems flags.

        + **Color**:

            0. Vector: Color

        + **Battery**:

            0. Integer: Previous Battery level

            1. Integer: Current Battery level

            2. Integer: Max battery level

        + **Identification**:

            0. String: Serial

            1. String: Name

        + **Menu**

            0. Integer(bool): Is the menu open

            1. (optional) list: Strided list of menu states. in order: Avatar Id, menu state, unix timestamp, role, permissions

        + **Power**

            0. Integer(bool): Is the unit powered


        + **PowerUsage**:

            0. Integer: Power draw ( per second )


        + **Follow**:

            0. Key: UUID of the person being followed. Check to see if it's NULL_KEY to indicate the end of a follow

            1. Float: Distance at which we are following.


        + **Programming**

            NOT implemented yet

        + **Charging**

            NOT implemented

        + **Software**:

            NOT implemented

- **Example**:

        ORIX_MESSAGE_BROADCAST($$ORIX_COMMAND_STATUS$$, [0x00000100, DEVICES_NAMES, DEVICES_TYPES, DEVICES_IDS]);

- **Answers**

    + No answer expected by the controller. But the Avatar will be expecting a dialog, most likely.


### Command *Adjust Device*

- **Description**: Command used by the devices to modify other devices position, in order to fit better. This command is commonly used by Controller housings to adjusts batteries.

- **Number**: $$ORIX_COMMAND_ADJUST_DEV$$

- **Parameters**:

    0. device_type: The device type this message is intended for. See the register command for a list of available device types

    1. rot_str: The rotation the device should have

    2. pos_str: The position the device should take

    3. attach_point: The attach point the device should go into.

    4. (optional) scale_str: The scale the device should take


### Command *Set Pos*

- **Description**: Command used by the controller to tell a device to modify itself. This information is usually obtained from an Adjust Device command.

- **Number**: $$ORIX_COMMAND_SET_POS$$

- **Parameters**:

    0. rot_str: The rotation the device should have

    1. pos_str: The position the device should take

    2. attach_point: The attach point the device should go into.

    3. (optional) scale_str: The scale the device should take

### Command *DeepConfig*

- **Description**: Command used by the device to modfiy the configuration of other devices, included the controller itself.

- **Number**: $$ORIX_COMMAND_DEEPCONFIG$$

- **Parameters**:

    0. Key: The device id the message is intended for

    1. String: The configuration to change

    2. (Variable): The new value for the configuration

### Command *Set Config*

- **Description**: Command used by the Controller to modfiy the configuration of other devices.

- **Number**: $$ORIX_COMMAND_SET_CONFIG$$

- **Parameters**:

    1. String: The configuration to be changed

    2. (Variable): The value of the configuration

### Command *Battery Set up*

- **Description**: Command used by batteries AFTER registeration has been confirmed to give information about themselves to the controller.

- **Number**: $$ORIX_COMMAND_ADJUST_DEV$$

- **Parameters**:

    0. Integer: The maximum capacity currently configured in the battery

    1. Integer: The current capacity currently stored in the battery

    2. (optional) Integer: Recharge modes, how can this battery be recharged. Still a bit of a WIP.

        - ALL (0x0001): Any will be allowed (default option if none is provided)

        - NONE (0x0002): This battery can't recharge.

        - Wireless (0x0004): This battery can be recharged wirelessly

        - Induction (0x0008):

        - Cable (0x0010):

### Command *Add Commands*

- **Description**: Command used by devices to be able to register commands to the controller. When these commands are invoked, they will be send with the command Process Command. If a new Add command is sent by a device, the previous setting will be overwritten.

- **Number**: $$ORIX_COMMAND_ADD_COMMAND$$

- **Parameters**:

    0. List: Commands to be added to the controller


### Command *Process Command*

- **Description**: Command used to tell devices they need to process a command.

- **Number**: $$ORIX_COMMAND_PROCESS_COMMAND$$

- **Parameters**:

    0. String: Command

    1. List: parameters in the command.

### Command *Execute Command*

- **Description**: Command used by registered devices to request the controller to execute a chat command. This has some **important notes**. This command will check wether the owner of the issuer device is either the owner of the controller or they have a role that has the devices permission enabled and nothing else before running the command. When checking permissions for the command, it will be against the owner of the issuer device... unless it's the owner of the controller, in which case it will ignore all perm restrictions.

- **Number**: $$ORIX_COMMAND_RUN_COMMAND$$

- **Parameters**:

    0. String: Command

    1. List: parameters in the command.

### Command *Go To*

- **Description**: Command used by devices to move the unit. This will not work if the unit's motors are completely disabled, but it will work if the unit's motors are locked.

- **Number**: $$ORIX_COMMAND_GOTO$$

- **Parameters**:

    0. Vector: Destination in regional coordinates.

    1. (optional) Integer: Time in seconds it will take the unit to move over there. If you want to add data (next param) but not the time, set this to -1

    2. (optional) String: Data that will be returned when the unit reaches the point. It can also be a ORIX list, the important thing is it will be stored and returned as if it were a string.
