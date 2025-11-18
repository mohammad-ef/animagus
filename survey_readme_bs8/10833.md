# PopupList
It can show a edit menu when you press a View by a long-press gesture.  
This utility class can bind a edit menu for ListView, GridView, or other View easily.  
**Welcome star, fork**  
## Screenshots
![ScreenShot](https://github.com/shangmingchao/PopupList/blob/master/screenshots/screenshot_1.png)![ScreenShot](https://github.com/shangmingchao/PopupList/blob/master/screenshots/screenshot_2.png)<br />
![ScreenShot](https://github.com/shangmingchao/PopupList/blob/master/screenshots/screenshot_3.png)![ScreenShot](https://github.com/shangmingchao/PopupList/blob/master/screenshots/screenshot_4.png)
## How do I use PopupList?
Just need a `.java` file and a little code.  
```java
    PopupList popupList = new PopupList(context);
    popupList.bind(anchorView, popupMenuItemList, PopupListListener);
```
## Sample
```java
    PopupList popupList = new PopupList(this);
    popupList.bind(lv_main, popupMenuItemList, new PopupList.PopupListListener() {
        @Override
        public boolean showPopupList(View adapterView, View contextView, int contextPosition) {
            return true;
        }
        @Override
        public void onPopupListClick(View contextView, int contextPosition, int position) {
            Toast.makeText(MainActivity.this, contextPosition + "," + position, Toast.LENGTH_SHORT).show();
        }
    });
```
## Customization
You can get more information from the [Wiki](https://github.com/shangmingchao/PopupList/wiki/Configuration) page.  
