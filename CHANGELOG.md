# S7_Journal Changelog

----------

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
