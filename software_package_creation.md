# Installation protocol


## Installer

The installer object must be the name of the Software in the following format:

	<Name>_<version>
	
	- Name: Must not contain an underscore ( "_" ) 
	- Version: two numbers separated by a dot (".")

## Inside the installer

The installer should contain all the scripts that wants to be uploaded, aswell as a notecard that must be the **same name as the installer**, but begining with a "-"

Inside this notecard, it will be divided by tags. Tags are public "names" for devices, denoted by double square brackets ( [[example]] ) . Currently this are the tags OeM supports. You can create your own and use OeM as a software manager:
	- oem_controller
	- AccessPanel

Inside each tag, line by line, should be the name of the scripts, objects, notecards, sounds and textures that the tag should receive, except for this notecard itself. If some content is not listed in this notecard, it won't be uploaded to the controller.
If some content is listed, but can't be found in the installer, the installer will notify you, and will not work until you fix the issue.
### **E.G. of how the inventory should look** 
	Installer name: HypnoApp_6.1 
		HypnoApplication_v6.1
		Triggers
		Info Notecard
		((Mandatory Notecard)): -HypnoApp_6.1
			[[AccessPanel]]
			HypnoApplication_v6.1
			Info Notecard
			[[HypnoGoogles]]
			Triggers
			
(there will be an example notecard in the future)
				
## Advance installation 				
With this you can install/update anything in the same prim as the updater script.
If you want to update things outside of that prim, it's slightly more complex. 
The notecard structure is pretty much the same with the slight difference that those eobjects that have to be installed in other prims must be followed by "->" and the description of the prim the installation goes into.
	element->description
If the element is a script, there isn't much more problems. 
If the element is anything else, you have to have a script in that same prim as those objects. This script is in charge of deleting the objects when it receives the linked message whose number is: 108. The message of the linked message is the name of the inventory while the key is the id of the linked prim that contains it. 