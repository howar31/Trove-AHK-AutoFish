> _[中文說明在文章後面](https://github.com/howar31/Trove-AHK-AutoFish#trove-ahk-autofish-1)_

# Trove-AHK-AutoFish
This is an AutoHotKey script for auto fishing in Trove.

![previewimg](https://raw.githubusercontent.com/howar31/Trove-AHK-AutoFish/master/preview.png "Trove-AHK-AutoFish Preview Screenshot")

## Feature
* Using **Memory Address** to detect biting.
> Very solid compare to image search or audio detect method.

* Toggleable **Auto Fish**
> Press **F11** to toggle Auto Fish on or off.
>
> You can start/stop auto fishing at any time without exiting the whole script.
>
> Auto fishing can be minimized and run in the background to automatically fishing for you without interfearence your current work.  That is, you can use your computer while Trove is fishing in your taskbar.
>
> Note that Auto Fish contain Anti-AFK functionality.  You do not need to enable Anti-AFK seperately.

* Toggleable **Auto Boot Throw (ABT)** mechanism.
> Press **F10** to toggle ABT on or off.
>
> Automatically discard the _Old Boot_ from your backpack.  Convenient for long-time fishing.
> 
> Turning off the ABT mechanism to make sure AHK won't move your mouse.  Sometimes AHK ImageSearch will mis-find the image and accidentally move your mouse.  It's better to turn ABT off if you are currently working on other windows and have Trove minimized in the background.
>
> ABT is always available even when you're not auto fishing.  You may press **F10** at any time to clean up your backpack.

* Toggleable **Anti-AFK**
> Press **F9** to toggle Anti-AFK on or off.
>
> This is an independent Anti-AFK mechanism from Auto Fish.  You do not need to enable Auto Fish to use this feature (and vise versa).
>
> The default setting is to send "END" to Trove every 10 seconds to prevent AFK, and also not interrupt Trove gameplay.  That is, you may play Trove with this feature enable and normal gameplay will not be affected.  And also you may minimize Trove to taskbar, the Anti-AFK will still work in the background.
>
> Note that, you have to press **F9** while Trove window is active for AHK to capture the process ID and send the key correct to Trove.

* Toggleable **Information Tooltip**
> Press **F8** to toggle showing or hiding the info tooltip.
>
> This is a always-on-top tooltip which show the script current status and related information.  So you may see the info on desktop even when Trove minimized.
>
> Hotkeys instruction and fishing info are always available in tooltop.

* Simulated **Natual Action**
> The script will simulate human keypress and pause to present natual action.

* Configurable **Hotkeys**
> All hotkeys are configurable in the script file.  You may follow the comments in script files to edit the hotkeys.


## Installation
1. Download and install AutoHotKey from the [official website](http://www.autohotkey.com/).
> AutoHotKey main program is needed to run the .ahk file.  Running .ahk script file other than the compiled .exe file to make sure that the script is cleanp and pure without any unintended modification.

2. Download files from this repo.
> You may find the **Download ZIP** button on the repo page.  Extract the .zip file and you can find the files below.
 * **TroveAutoFish.ahk**
 > This is the main AHK script file.

 * **boot.bmp**
 > This is the image used for ImageSearch by AHK to find the boot in your backpack.  You may make your own screenshot of _Old Boot_ if the auto boot throw is not working.

3. Put the boot.bmp file under C:\  (C:\boot.bmp)
 > This path is currently hard-coded in AHK script.  So if you want to change the path you may modify the script yourself.

## Usage
1. Double click script file **TroveAutoFish.ahk** to execute the script.
> A _green H_ icon will show up when the script is running.  If you can not execute the script, make sure you have AutoHotKey correctlly installed.

2. Open **Trove**, find a pool, and press **F11** to start auto fishing.
> Auto Fish will automatically open your backpack to prevent camera rotate while moving mouse.  And also allow AHK ImageSearch to find the Old Boot in your backpack.
>
> Auto Fish will close and reopen your backpack to reset the item rotation for porper Imagesearch.

3. The default of auto boot throw (ABT) is off at start.  Press **F10** to toggle on.
> Note that you have to keep Trove window active for AHK ImageSearch.  And AHK will use and move your mouse to throw the boot out of your backpack once if found the match image.
>
> If ABT is not working correctly, you may:
>
> 1. Item will rotate while mouse hover on them.  Close then reopen the backpack will set the item to default position which will match the boot.bmp
> 2. Create a new boot.bmp by yourself.  Just simply take a screenshot of the _Old Boot_.  Note that, hover will rotate the item.  You don't want a rotated image which will cause the ImageSearch fail.

4. Press **F6** to stop and terminate the whole script.

## Hotkeys 

The hotkeys are all configurable in the script file.  You may change the keys by yourself.

Here are the default hotkey settings:

* **F11** - Toggle Auto Fish on or off
* **F10** - Toggle Auto Boot Throw on or off
* **F9** - Toggle Anti-AFK on or off
* **F8** - Toggle Info tooltips on or off
* **F6** - Terminate and exit the whole script

All hotkeys info are also displayed in tooltip.

--

# Trove-AHK-AutoFish
這是 Trove 自動釣魚的 AutoHotKey 腳本。

![previewimg](https://raw.githubusercontent.com/howar31/Trove-AHK-AutoFish/master/preview.png "Trove-AHK-AutoFish Preview Screenshot")

## 特色
* 使用 **記憶體位置** 偵測是否有魚上鉤
> 使用記憶體偵測的方式非常精準，比圖片比對或聲音偵測的釣魚方式還要更好。

* 可切換開關的 **自動釣魚**
> 按 **F11** 可切換自動釣魚功能的開關。
>
> 你不需要關閉整個腳本就可以隨時切換自動釣魚功能啟用與否。
>
> 自動釣魚完全不影響你使用電腦，可以自動在背景釣魚，也就是說，你可以把 Trove 縮小在工作列釣魚，然後用電腦做其他事情。
>
> 注意，自動釣魚本身帶有防斷線的功能，你不需要另外去開啟防斷線機制。

* 可切換開關的 **自動丟鞋 (ABT)**
> 按 **F10** 可切換自動丟鞋功能的開關。
>
> 腳本可以自動的把背包內的 _鞋子 (Old Boot)_ 丟掉，有利於長時間自動釣魚。
> 
> 將 自動丟鞋 (ABT) 功能關閉時，可以確保 AHK 完全不會動到你的滑鼠。有時候 AHK 的圖片搜尋功能會比對錯誤，因此讓滑鼠亂飄，如果你將 Trove 縮小到工具列背景釣魚，同時用電腦進行其他工作，建議將丟鞋功能關閉以確保滑鼠不會亂動。
>
> 自動丟鞋隨時可用，沒有自動釣魚的時候也可以按 **F10** 清理背包。

* 可切換開關的 **防斷線** 機制
> 按 **F9** 可切換防斷線機制的開關。
>
> 這個防斷線機制與自動釣魚完全無關，兩者互不影響也不依賴，你不需要啟用自動釣魚就可以使用這個功能 (反之亦然) 。
>
> 這功能預設是每10秒送一個「END」按鍵給 Trove 以防止閒置斷線，而同時也不會影響正常的 Trove 遊戲，也就是說你可以把這功能打開，然後正常的玩 Trove 也不會有任何干擾。同時你也可以將 Trove 縮小到工具列，防斷線功能依然可以在背景正常運作。
>
> 注意，務必要在 Trove 的視窗內按 **F9** ，好讓 AHK 可以抓到正確的 process ID ，才能把按鍵正確傳送給 Trove 。

* 可切換顯示的 **資訊浮動視窗**
> 可按 **F8** 切換顯示或隱藏浮動視窗。
>
> 這是一個置頂的浮動視窗，顯示腳本目前的狀況以及相關資訊，所以就算 Trove 縮到最小，你仍然可以在桌面上察看相關的資訊。
>
> 按鍵功能以及釣魚相關資訊都會顯示在這裡。

* 模擬 **自然操作**
> 腳本會模擬人類按鍵盤的方式與停頓時間，達到更自然的操作效果。

* 可自訂的 **按鍵設定**
> 所有快捷鍵都可以在腳本內修改，你可以參考腳本內的註解資訊自行修改按鍵設定。

## 安裝說明
1. 到 AutoHotKey [官方網站](http://www.autohotkey.com/) 下載並安裝程式
> 你必需要安裝 AutoHotKey 程式才能執行 .ahk 檔案。推薦執行 .ahk 腳本檔案而非製作完成的 .exe 檔案，以確保腳本完全乾淨無毒，不會遭人加料修改。

2. 在這個頁面下載檔案
> 在網頁右邊可以找到 **Download ZIP** 的按鈕，下載並解壓縮 .zip 檔案即可找到下列檔案。
 * **TroveAutoFish.ahk**
 > 這是主要的 AHK 腳本檔案。

 * **boot.bmp**
 > 這是一張鞋子的圖片，用來讓 AHK 進行圖片比對搜尋背包內的鞋子用。若腳本的自動丟鞋功能無法正常運作，你也可以自行拍照截圖鞋子的圖片來取代這個檔案。

3. 把 boot.bmp 放在 C:\ 目錄底下  (C:\boot.bmp)
 > 這個路徑位置目前是寫死在腳本內的，所以如果你想把圖片放在其他路徑你可以自行修改腳本內的路徑位置。

## 使用方式
1. 點兩下 **TroveAutoFish.ahk** 開始執行腳本
> 當腳本執行時工具列會出現一個 _綠底的H_ 圖示。如果你點兩下無法執行腳本，請確定 AutoHotKey 是否有正確安裝。

2. 開啟 **Trove** ，然後找個魚池，再按 **F11** 即可開始自動釣魚
> 自動釣魚會自動打開你的背包，防止滑鼠轉動視角而無法對準魚池拋竿，並讓 AHK 的圖片比對能搜尋背包內的鞋子。
>
> 自動釣魚會定時關閉再開啟背包，這樣可以重設物品旋轉，讓圖片比對搜尋能正確運作。

3. 自動丟鞋功能 (ABT) 剛啟動時預設是關閉的，按 **F10** 可切換開啟
> 注意，你必需要保持 Trove 視窗為啟用狀態，這樣腳本才能進行圖片比對搜尋。每當 AHK 發現符合的圖片時，會自動移動你的滑鼠把鞋子丟掉。
>
> 如果 ABT 無法正常運作，你可以嘗試:
>
> 1. 當滑鼠指在物品上的時候物品會旋轉，把背包關掉然後重新打開可以讓物品回到原始位置，也就是 boot.bmp 預設的位置。
> 2. 自己重新建立一個新的 boot.bmp 檔案，只要將 _Old Boot_ 拍照截圖儲存即可，注意滑鼠指在物品上的時候會旋轉，旋轉過的物品截圖會造成圖片比對搜尋失敗而無法正常運作。

4. 按 **F6** 停止並完全關閉整個腳本

## 快捷鍵 

所有的按鍵設定都可以在腳本原始檔內修改，你可以自行編輯腳本修改按鍵設定。

預設的按鍵設定為:

* **F11** - 切換自動釣魚開啟或關閉
* **F10** - 切換自動丟鞋開啟或關閉
* **F9** - 切換防斷線機制開啟或關閉
* **F8** - 切換資訊浮動視窗顯示或隱藏
* **F6** - 結束並完全關閉整個腳本

所有的按鍵資訊都有顯示在資訊浮動視窗內。
