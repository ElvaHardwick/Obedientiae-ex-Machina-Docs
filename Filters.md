# IO Filters for OeM Controller

In this page, we will explain what IO Filters are and how can they be made. This is a slightly more complex guide, since it requires basic scripting knowledge, even if it's not LSL based.

## 1. What are these filters?

Well that's an easy question! These filters modify what the unit hears (Input) and what the unit says (Output). And you might ask yourself, don't we have replace words for that last one? Well, yes! But this is a bit of a more complex feature. While replace words from notecard scripting are great and simple to use, they aren't very flexible. With IO filters you can use scripting to make your unit sounds exactly how you'd like it to. You can add random mews, squeaks or moans to their speech, or prevent them from ever hearing a certain word again. The possibilities are limited to your imagination and to your scripting capabilites.

## 2. How can we make a IO Filters

Well, we will need LSL scripting and at least one script (even though in this page we will make 1 filter in 1 script, in order to save memory in the controllers, we recommend doing more thna one filter per script). Every filter needs to do three basic functions:

1. [Register/Unregister](#21-registeringunregistering-io-filters) - The script lets the controller know it holds a functioning filter, and also unregisters when the script is uninstalled.
2. [Activate/deactivate](#22-activatedeactivate-io-filters) - A filter isn't active 100% of the time, and it's customizable through menu.
3. [Filter(DUH!)](#23-filtering) - The script operates on what the unit hears/says

Each step will be explained in detail, however, we have already made a template script that can work with minimal effort. You can find it here

### 2.1. Registering/unregistering IO Filters

We have to let the controller know when a new filter has been installed. For this we use the [MESSAGEID_FILTER_REGISTER (700)](./lsl/OeM_Api.lsl) linked message. In this linked message we use the message to inform the controller of the filters the script has. This text should be a strided list, where the even positions are the name of the filters and the odd positions are the info about the filter:

    ["InputFilter", "INPUT|0|1"", "OutputFilter", "OUTPUT|0|1"]

As you can see, the "info" elements are also a list separated by the character | . The first element indicates whether the filter is for input or for output, the second one is for priority and the third one is for flags.

The data of the Linked message should be a Unique Identifier which groups the filters being installed with the message. Once you have installed with an ID, any register message using that ID will be ignored until it unregisters.

This message must also be sent when receiving the [MESSAGEID_REQUEST_FILTERS (707)](./lsl/OeM_Api.lsl) linked message.

#### 2.1.1 Priority

Filters can have 3 priorities: -1, 0 and 1. Priority represents which filters should take place before others, 1 being the filters that should be the firsts to be used and -1 the last.

Why do we need priorities? Well, imagine you have a filter that adds extra "s" to imitate a snake sound, but also a filter that prevents the unit from ever saying its name. If the name contains an s, and we had no priorities, the user of the unit would have to be very careful when it comes to activating filters to make sure they are in the correct order, otherwise if the "s" filter goes first, the "s" in the name "Sylvia" ( for example) will be amplified and make "Sssylvia" which then the script that removes the name of the unit from its speech won't recognize. In this example, the "s" filter should be a priority -1 filter while the name filter should be a priority 1 filter.

#### 2.1.2 Filter flags

Currently, there is only one, and that is whether the filter has a menu or not. This will be explained [later](#31-filter-menu).

#### 2.1.3 Unregistering

Unregistering is quite easy, since it's the same as registering, only instead of using the [MESSAGEID_FILTER_REGISTER](./lsl/OeM_Api.lsl) we use [MESSAGEID_FILTER_UNREGISTER (701)](./lsl/OeM_Api.lsl)

To finish this section, here is a simple example of a linked message to register using [OeM API](./lsl/OeM_Api.lsl):

```lsl
SEND_LINKED_MESSAGE( MESSAGEID_FILTER_REGISTER,  ["out0", "OUTPUT|0|1", in0", "INPUT|0|1"],  llGetScriptName());
```

### 2.2. Activate/deactivate IO Filters

So, once the filter is registered, it doesn't mean it's active. For that the script needs to listen when to activate. 

The IO script will send the script a [MESSAGEID_FILTER_NEXT_FILTER (702)](./lsl/OeM_Api.lsl) to indicate to each filter who the next filter should be.
In order to do that, the data contains the name of the filter the message is directed to while the message contains the next filter down the pipeline.
If the message is empty that means the filter should deactivate. Check the [simple filter template](./lsl/Filter_simple_template.lsl) for more info.


### 2.3. Filtering

To filter there are two linked messages: [MESSAGEID_FILTER_OUTPUT (703)](./lsl/OeM_Api.lsl) and [MESSAGEID_FILTER_INPUT (704)](./lsl/OeM_Api.lsl) which are in themselves descriptive enough. The structure these linked messages have is similar: the data indicates which filter has to take care of the filtering, while the message has the actual info to filter.

The first element of this list is the only one that is different for Input than for output. For Input the first element is the key of the person who spoke.
For output, it's the level of voice the message is outputed ( whisper, normal or shout ) with <code>oemwhisper</code>, <code>oemnormal</code> and <code>oemshout</code> respectively.

After that, it's the same for both linked messages. The second element indicates whether the message started as an emote (so /me and speaking between double quotes) or as a normal text ( and emotes between *)

The rest is alternating between the emote text and the speech text. So <code>/me yawns "I feel tired" then waves "I'm heading off to bed" </code> will be divided into <code>yawns</code>, <code>I feel tired</code>, <code>then waves</code> and finally <code>I'm heading off to bed</code> while the second element of the list ( position 1 ) is <code>EMOTE</code>. Thus, you just need to loop over the rest of the list and filtering appropiatly. Once more we encourage you to look both at our [complex]((./lsl/Filter_complex_template.lsl)) and [simple](./lsl/Filter_simple_template.lsl) template scripts to get a general idea

## 3. Advanced IO Filters

There are two things for advanced IO filters:

1. Filter menu
2. Multiple filters per script

### 3.1. Filter menu

When the filter has a menu, as indicated in the [flags](#212-filter-flags), an extra button will appear in its menu. This button will give access to the configuration of the filter. Scripting wise, the filter will be in charge of offering the dialog in the same way as in the [application API](./application_api.md#menus). To indicate the opening of the filter menu, the [MESSAGEID_APPLICATION_MENU_OPEN](./lsl/OeM_Api.lsl) will be sent with the message containing `filter_<filter_name>` so to open the menu of the filter named `kitty`the message would be `filter_kitty`. Do not remove any parts of the menu state unless you have been the one adding them. Finally, the button to return the control of the menu to the controller is a `[Back]` button at the root of the filter menu, which will be handled by the controller. The [complex]((./lsl/Filter_complex_template.lsl)) template has an example of a filter with a menu.

### 3.2. Multiple filters per script

It's not extremely hard to get more than one filter per script, so we recommend it in order to make the controller more lightweight. The steps are the same, only that registering and unregistering of the filters must be done in bulk per script, since any message to register scripts after the first will be ignored until the unregister message is sent. I think the [complex]((./lsl/Filter_complex_template.lsl)) template script shows how to handle multiple filters per script in a tidy way.

The hardest part might be keeping track of filter order, 
