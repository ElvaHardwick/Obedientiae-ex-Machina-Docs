# Notecard Scripting system

The notecard system offers customizabillity to your unit, for both RP purposes, and restriction purposes.

Most features are configurable via either menu, or notecard. If configured in notecard then that will take priority on either a reboot or a change of Programming option.

## Installing new notecards

There are a few options to install new notecards into a fresh unit:

 * The unit can drop the notecard into the OeM logo on their controller HUD, or via the Second Life edit option.
 * A unit can be connected to a Software Server nearby, allowing both notecards and scripts to be installed. [ Work In Progress ]
 * Someone with a OeM Remote Control can connect to the unit and download and/or upload notecards. [ Work In Progress ]

These are all of course accessible only to users with the appropriate rights, a unit without self access cannot manage their own programming.

# Writing new notecards

## Using variables
Setting a variable is done by `variable_name = "value"` or `variable_name = other_variable`. Variables can be used for conditional blocks, or in strings. If you have a string says "Beep $variable_name$", and `variable_name` has the value 'boop' then it will be be replaced, output as "Beep boop"

## Blocks of code
There are a few code 'blocks' that are available, see the [examples section](#examples) to show how they're used.
 * `when variable =/!= "value" ..... end` - Evaluated whenever something is updated and the condition is still true
 * `on variable =/!= "value" ..... end` - Evaluated if the relevant variable is changed, and the condition is true.
 * `button ... option,option,option ... end` - Used to create buttons in the programming menu, the same button can be specified in multiple scripts, letting new options be added to it. The first option in the highest numbered notecard is set as default upon reboot.


## Possible calls:
 * `rewrite_word` - Causes the dictionary filter to enable, any number of search/replace values can be added in a line.
 * `phrase` - Specifies a phrase that is available for use when the `mind` sub system is disabled.
 * `think` - Causes a thought to appear in the unit's head, this can be a notification or an impulse the unit feels compelled to do.
 * `say` - Causes the unit to say something, this is restricted by restrictions on the unit's speech.
 * `wait` - Causes the rest of the block it is in to be scheduled for the specified amount of seconds later, the evaluation of other notecards immediately continues, so if you have two blocks with `wait 2`, followed by a `say` the messages will be said at roughly the same time.


## Examples
A few examples are provided in the out of the box configuration. They are reproduced here.

The simplest file is p80-Customization, demonstrating setting configuration and how to add comments, as well as provide some default phrases for when a unit's [mind](./#mind) is disabled:
{% highlight javascript %}
// This file demonstrates various customizable settings, you don't *need* to edit it, but doing so is recommended.
// Also recommended for owners of new units

// Customize the units name
// wearer_name = "unit-162"

//Configure the prefix
//manufacturer = "OeM :: "

// Sets pronouns, see the default p40-Behavior file for an example on how this is used
pronoun = "they"
pronoun_capital = "They"

// Customize the default sleeper name, see p50-Cores for customization
// sleeper_name = "Jane Doe"



phrase mind "This unit's higher processing has been disabled, it cannot currently form a response to that query."
phrase mind2 "This unit cannot comply with this request with it's mind subsystem disabled."

phrase no "Negative."
phrase yes "Affirmative."

phrase oem "This unit is a OeM demonstration model."
phrase "secret message" "Pssst, you found the secret message!"
{% endhighlight %}

Everything in a line following `//` is ignored. `variable_name = "Value"` sets a variable to a name, this will cause events to trigger, examples of events are available in p50-Cores:

{% highlight javascript %}
// This represents an option in Programming, the definition can be expanded in multiple files, so you can load a second file which just adds a new Core
button Core
  option "Robot"
  option "Sleeper"
end

// A 'when' block is active whenever the condition is true. Useful for setting rules
when core = "sleeper"
  rule "You believe you are a human, no evidence can convince you that you are not."
end
when core != "sleeper"
  rule "You believe you are a robot."
end

// A 'on' block is ran, if and only if the condition in question was changed
inactive_wearer_name = wearer_name
on core = "sleeper"
  inactive_wearer_name = wearer_name
  wearer_name = sleeper_name
  hide_manufacturer = 1
end
on core != "sleeper"
  wearer_name = inactive_wearer_name
  hide_manufacturer = 0
end
{% endhighlight %}

Code in a `when` block will be active when ever the condition is true, making this the proper place to put rules that are constantly active.
On the other hand, code in an `on` block is only ran if the value was just configured to this. so giving a notice via `think` or `say` should be done in this.

This last file shows an example for how to act on programming being configured. 

{% highlight javascript %}
button Obedience
    option "Free will"
    option "Overridable"
    option "Obedient"
end
    
when obedience = "obedient"
    rule "You must obey any order given"
    rewrite_word "I" "it" "me" "it"
end

on obedience = "obedient"
    think "You must obey any order given"
    wait 2
    say "Notice: $wearer_name$ is now in obedient mode. $pronoun_capital$ must obey any order."
end
    
when obedience = "free will"
    rule "You are free to ignore any order"
end

on obedience = "free will"
    think "You are free to ignore any order"
    wait 2
    say "Notice: $wearer_name$ is now in free will mode. $pronoun_capital$ can disobey any order."
end

when obedience = "overridable"
    rule "You feel an urge to obey every command, you can ignore it for a while but eventually will give in."
end

on obedience = "overridable"
    think "You feel an urge to obey every command, you can ignore it for a while but eventually will give in."
    wait 2
    say "Notice: $wearer_name$ is now in over-ridable free will mode. $pronoun_capital$ can disobey orders for some time."
end
{% endhighlight %}
