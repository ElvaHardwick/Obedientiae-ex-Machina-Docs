# Customizing your Controller Housing

## Basic configuration

First up, most elements of the controller can be re-colored using the default Second Life build tools, however, dynamic elements might be reset.

Second up, we offer some menu based customizations.

 * Battery holder (CH-One Mini): In the device menu (Devices-\>CH One Mini) you can configure if the battery holder is visible or not, or if that's automatic based on having a battery.
 * Labels: In the device menu (Devices-\>Housing) you can choose one of several label options, show what you are, whether you're robot, cyborg, drone, specimen, or one of several other options!

## Advanced configuration

Aesthetics and design features are important for any line of units, our Controller Housings are designed to be relatively easy to to customize.

This isn't *super* supported, you might break the housing, you can always get a redelivery, but the easiest thing to do is to first create a backup.
This document is also a work in progress and will be expended upon mostly based on request.

That warning aside, the most important thing to know: For performance reasons, the housing *only* reads this configuration on first init, to re-read the configuration reset the script in side the housing. That is to say. **After editing, reset the housing scripts**

### How to configure

There are two ways to configure the housing script:

 * First, it reads the description of all linked prims and, if it starts with `OeM:` it will read the rest of the line for configuration options, multiples can be split up by adding a `;`
 * Second, it reads the *names* of all the notecards in the prim with the script, similarly, if it starts with `OeM:` it will see the *name* of the file as a single configuration

### Values that can be configured

All things are considered to talk about the prim they've been found in (inventory or description), inventory can't be read from linked prims so only description is considered for those.

| TextBaseColor:<70,50,70>          | This one allows is special, it allows you to set the default color of all the texts, it's an RGB vector in the range of 0...255. It also accepts the special value `dynamic` in order to have the text be the color of the unit |
| LightGlow:0,2                     | The (comma separated) list of faces given as argument is considered to "glow" with the unit color. Can be -1 to have every face on the link be set to the color   |
| BatteryHolder:0,0,0.005:0,45,0    | This prim is a battery holder, there should be only one of these, and this configuration makes it so the battery is position to the position of the linked prim. The first argument is an offset and the second is an additional rotation of the battery when set. |
| ToggleShow:Battery:Battery        | This will configure the controller housing to be able to show and hide by configuration. The first value is the name of the group of prims that are hidden together, the second one is for the automatic hide feature, as listed this will show/hide as the battery is connected. |

### Troubleshooting

 * My changes aren't being picked up: You might still need to reset the script, alternatively, some things are only changed on a reboot of the unit.
