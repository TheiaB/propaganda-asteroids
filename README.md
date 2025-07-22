# propaganda-asteroids

# IMPLEMENTATION

## Missions

On the bottom left in the FileSystem, search for the game.tscn scene. In the Outliner (Scene Tab, top left), there are lots of nodes. Look for Mission Manager and click the "Open In Editor" Scene Icon (looks like a film symbol). In here, you can simply suplicate a child node (e.g. "from home") and adjust Parameters (rename the node, on the right in Inspector, you can adjust Title, Description, Finish Text, Reward amount, and which planets are involved). Save the scene and the the game should have now have all the new missions ingame.

## Items

In the file system (bottom left), look for the folders in "scenes > items". Each item type has a folder (e.g. shields). Within is a item scene (e.g. basic_shield.tscn"). Open the scene and select (in the top left scene panel) the node representing the item. On the right, you will have a few input fields, such as Title, Price, Description, Video and a Legal Text (put a super long nonsensical scammy one here). Enter the data. Save the scene. The item should now be updated in the game.

# TODOs
- [ ] check for edge cases (mission/closing missions window/ items)
- [ ] radar item
- [ ] Ship break?


- [ ] item -> progression needed
- [ ] -> buyable -> zugriff auf planeten usw
