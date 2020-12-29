# Take Notes Changelog

----------


## [1.0.1.0] --- 30th December 2020 --- **_Minor Improvements_**

### CHANGED

* _Changed_ `OsirisData` subdirectory prefix to `TakeNotes`.

## [1.0.0.0] --- 27th December 2020 --- **_Initial Release_**

* _Released_ the mod on the steam-workshop.

## [1.0.0.0] --- 23rd December 2020 --- **_Preparing for Release_**

### NEW

* _Added_ Notebooks to treasure table: `ST_KitchenThings`.
* _Added_ option for `Unique` notebooks.

### FIXED

* _Fixed_ item combo bug.

## [0.3.0.0] --- 20th December 2020 --- **_Settings_**

### NEW

* _Created_ ModSettings.
* _Created_ ModSetting Option for toggling storage method.
* _Created_ ConsoleCommand to remove JournalData from PersistentVars.
* _Created_ ConsoleCommand to export PersistentVars entries.
* _Added_ Crafting recipe for notebooks.

### CHANGED

* _Renamed_ "Journal" to "Notebook".

## [0.3.0.0] --- 17th December 2020 --- **_Casual rewrite of the entire code_**

### NEW

* _Renamed_ `S7_JournalAuxiliary.lua` to `Auxiliary.lua`.
* _Renamed_ `S7_ModVersioning.lua` to `ModVersioning.lua`.


## [0.3.0.0] --- 16th December 2020 --- **_TreasureTables_**

### NEW

* _Added_ journals to vanilla treasure-tables. Will shop up in trader and container inventories.

## [0.3.0.0] --- 11th December 2020 --- **_Added GM Support_**

### ADDED

* `CharacterUsedItemTemplate()` doesn't seem to work in GM-mode. _Changed_ to `CharacterUseItem()`.
* Journal _Unloads_ data when closed.

### REMOVED

* _Removed_ `Unique` attribute from items.

### COMMENTS

* Seems to work in GM mode now - no noticeable issues.

## [0.2.1.0] --- 10th December 2020 --- **_Item-Bound-Content_**

### CHANGED

* _Revamped_ the entire code inorder to tie the journal content to items instead of characters.
* Channel names now reference `IDENTIFIER`.

## [0.2.0.0] --- 7th December 2020 --- **_UCL Integration_**

### NEW

* _Integrated_ with **UI Components Library**.
* _Created_ *ModVersioning* script.
* _Account_ for different `characters` and `userIDs`.

### CHANGED

* Use the Host's Character ProfileID instead of Client's.
## [0.1.1.0] --- 20th November 2020 --- **_Journal Item Creation_**

### NEW

* _Created_ a new `BOOK` for the journal.
* _Implemented_ `OsirisHandler` for journal `onUse` in lua.

## [0.1.0.0] --- 20th November 2020 --- **_Initial Commit_**

### NEW

* Initial Commit.
