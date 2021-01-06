# Take Notes
============

## Mod Details
--------------

### Take Notes
- Mod Version: ?TakeNotesVersion
- Author: ?TakeNotesAuthor

### UI Components Library
- Requirement: Critical
- ModVersion: ?UCLVersion
- Author: ?UCLAuthor

### Thanks and Credits
- Huge thanks to the following:
- ***Larian Studios*** for **Divinity Original Sin 2**.
- ***LaughingLeader*** for the **Source-Control-Generator**.
- ***Norbyte*** for the divine **Script-Extender**.
- ***SebastianLenz*** for the **VSCode** Extension.

## General Information
----------------------

### Notebooks
- Editable notebooks for story and GM modes! Take _notes_, keep a record of _events_ and _characters_, and write about your _deeds_ (or _misdeeds_) as you adventure through Rivellon. Author the most comprehensive compendium of knowledge that transcends even Cranley Huwbert's! or just make a todo-list. _Create_, _View_, _Edit_ your entries in-game or externally. Gold value of notebooks scale with their contents.

### How to acquire?
- Notebooks have been _integrated_ into vanilla **treasure-tables**. You can buy them from vendors and find them as loot.
- Notebooks can also be crafted. `LeatherScraps + Needle-&-Thread + 3x Sheet-of-Paper`
- If you've set the `Uniques` option, each player will get 1 notebook as soon as the game loads. But they won't be a part of _treasure-tables_ anymore.

### Mod Settings
- `ModSettings` can be changed by editing the global settings file (`S7Central.json`) in the `Osiris Data` folder. (`..\Documents\Larian Studios\Divinity Original Sin 2 Definitive Edition\Osiris Data\S7Central.json`). Search for `S7_Journal`, the internal identifier for the mod.
- ----------------------------------------------------------  
- `Uniques` (Default: false) --- By setting `Uniques` to true, the notebooks will be treated as a `Unique` story item by the game. One notebook will be granted to each player at the start of the game. However, they will not spawn as loot and you won't be able to sell them either.
- -----------------------------------------------------------
- `StorageMode` (Default: Internal) --- By default, the mod stores the notebook contents in the save-file itself. You can change this behaviour to "External" so that you can view/edit these notebooks externally as `markdown` files. They are stored in `Osiris Data/TakeNotes/`.
- -----------------------------------------------------------
- `SyncMode` (Default: ItemGUID) --- By default, the notebook contents are tied to the item. This means that each notebook holds its own contents. You can change this to "CharacterGUID" if you want the notebooks to be tied to the characters instead.

## Additional Information
--------------------------

### Console-Commands
- To be documented

### Limitations
- All notebooks share the same `JournalUI`. The contents are loaded in when you open the item and are saved when you close the UI. Opening a notebook when the UI is already opened will cause the new content to load over the last (without the opportunity to save). This is problematic as closing the UI now will save jumbled contents. In such an event, it may be wise to load a previous save (if content-storage is Internal) or Ctrl+Z your way out (if content-storage is External). You can avoid this situation altogether if you just close the UI before you open the next notebook.
- The GameMaster can't directly open these notebooks as they never trigger the `CharacterUseItem` osiris event. They can access the notebooks if they control a character though.
- The ContextMenu option persists if you left click to dismiss the ContextMenu. Dismissing by right clicking out of the menu or clicking a button works perfectly. 

## Changelog
-------------

### [v1.1.0.0]: -Jan-2021
- The `GoldValue` of notebooks now scales with the contents.
- The mod now stores and reads notebooks as `markdown` files.
- You probably already found it but I'll say it anyway. Added `ContextMenu` support for mod-information.

### [v1.0.1.0]: 31-Dec-2020
- The **displayName** of notebooks can now be changed by directly editing the JournalUI's caption. (save-reload for changes to apply).
- Changed `OsirisData` subdirectory to **TakeNotes**. If you were using the `External` storage mode, please rename `S7_Journal/` folder to `TakeNotes/`.

### [v1.0.0.0]: 27-Dec-2020
- Initial Release