# Take Notes
=============

## Mod Details
--------------

### Take Notes
- Mod Version:  ?TakeNotesVersion
- Author:  ?TakeNotesAuthor
- Description:  **Editable notebooks** for *story* and *GM modes*! Take notes, keep a record of events and characters, and write about your deeds (or misdeeds) as you adventure through Rivellon. *Create*, *View*, *Edit* your entries in-game or externally.
- ===
- ***CURRENT MOD SETTINGS***
- Unique Notebooks:  `?UniquesOption`
- Storage Mode:  `?StorageOption`
- Sync Mode:  `?SyncOption`

### UI Components Library
- ModVersion:  ?UCLVersion  *(Required: v0.4.0.0+)*
- Author:  ?UCLAuthor
- Description:  ?UCLDescription

## General Information
-----------------------

### How to use?
- Just find and open a **notebook**, enable `edit-mode` and start writing. The contents will be automatically saved when you close the UI.
- The notebook's **title** can also be edited!

### How to acquire?
- Notebooks have been integrated into vanilla **treasure-tables**. You can buy them off vendors and find them as loot.
- Notebooks can also be crafted: `LeatherScraps + Needle-&-Thread + 3x Sheet-of-Paper`
- If you've set the `Uniques` option, each player will get 1 notebook as soon as the game loads. But they won't be a part of *treasure-tables* anymore.

### Mod Settings
- ModSettings can be changed by editing the global settings file (`S7Central.json`) in the *Osiris Data* folder. (`..\Documents\Larian Studios\Divinity Original Sin 2 Definitive Edition\Osiris Data\S7Central.json`). Search for **S7_Journal**, the internal identifier for the mod.
- ===
- ***Uniques*** <font color='#888888'>(Default: false)</font> --- By setting `Uniques` to _true_, the notebooks will be treated as a **Unique story item** by the game. One notebook will be granted to each player at the start of the game. However, they will not spawn as loot and you won't be able to sell them either. <font color='#888888'>(Current: `?UniquesOption`)</font>
- ===
- ***StorageMode*** <font color='#888888'>(Default: Internal)</font> --- By default, the mod stores the notebook contents in the save-file itself. You can change this behaviour to `External` so that you can view/edit these notebooks externally as `markdown` files. They are stored in `Osiris Data/TakeNotes/`. <font color='#888888'>(Current: `?StorageOption`)</font>
- ===
- ***SyncMode*** <font color='#888888'>(Default: ItemGUID)</font> --- By default, the notebook contents are tied to the item. This means that each notebook holds its own contents. You can change this to `CharacterGUID` if you want the notebooks to be tied to the characters instead. <font color='#888888'>(Current: `?SyncOption`)</font>

## Additional Information
--------------------------

### Formatting Tips
- You can do some basic formatting using `markdown` syntax. Most of them just add *colors* `like` **this**.
- Avoid using HTML tags directly in the in-game UI. They are not parsed correctly by `textInputs`. Using tags in the `External` files seems fine. 
- ===
- Entries can be left completely blank if they just contain 3 ***=***. Like the line above.

### Editing Externally
- If you enable the `External` storage mode, then notebooks will be saved as *markdown* files in `Osiris Data/TakeNotes/` folder.
- ===
- ***#*** for the notebook's caption or title.
- ***##*** for a category
- ***###*** for a chapter within the category
- ***-*** for a paragraph within the chapter

### Known Issues
- All notebooks share the same `Journal UI`. The contents are loaded in when you open the item and are saved when you close the UI. Opening a notebook when the UI is already opened will cause the new content to load **over** the last (without the opportunity to save).
- ===
- This is problematic as closing the UI now will save jumbled contents. In such an event, it may be wise to load a previous save (if content-storage is _Internal_) or `Ctrl+Z` your way out (if content-storage is _External_).
- <font color='#E03616'>You can avoid this situation altogether if you just close the UI before you open the next notebook</font>.
- ===
- The line spacing in larger paragraphs looks off.
- ===
- The <font color='#9A5085'>GameMaster</font> can't directly open these notebooks as they never trigger the `CharacterUseItem` Osiris event. They can access the notebooks if they control a character though.
- ===
- The ContextMenu option <font color='#E03616'>persists</font> if you `left-click` to dismiss it. Dismissing by `right-clicking` out of the menu or `clicking a button` works perfectly. 

## <font color='#3F784C'>Changelog</font>
-----------------------------------------

## [v1.1.1.0]<font color='#888888'>: 21-Feb-2021</font>
- *Refactored* Auxiliary Functions.

### [v1.1.0.0]<font color='#888888'>: 9-Jan-2021</font>
- The **Gold Value** of notebooks now scales with the contents.
- The mod now stores and reads notebooks as `markdown` files.
- The mod will try to patch existing `JournalData` to the new format automatically.
- Added `ContextMenu` support for mod-information.

### [v1.0.1.0]<font color='#888888'>: 31-Dec-2020</font>
- The `displayName` of notebooks can now be changed by directly editing the _Journal UI's caption_. <font color='#888888'>(save-reload for changes to apply).</font>
- Changed `Osiris Data` subdirectory to "**TakeNotes**". If you were using the _External_ storage mode, please rename `S7_Journal/` folder to `TakeNotes/`.

### [v1.0.0.0]<font color='#888888'>: 27-Dec-2020</font>
- Initial Release.

