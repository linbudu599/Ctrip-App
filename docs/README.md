# Ctrip App Docs

## 页面白屏? 因为有个加载Flutter SDK的过程

使用splash 幻影页

flutter_splash 但是需要改mainAc文件, 教程中给的是java, 我这里的是kt, 打扰了

## 全面屏适配

长宽比不再是16:9 传统布局上下留黑边
控件位移

- 已使用了Scaffold / bottomNavigationBar, 会自动适配
- 否则需要注意:
  
顶部NavigationBar上部预留安全区域, 底部NB的底部预留安全区域

- SafeArea包裹, 类似于RN的SafeAreaView来进行适配
- MediaQuery.of(context).padding 自己实现对安全区域控制
- 前者简单, 后者灵活
 
```dart
final EdgeInsets padding = MediaQuery.of(context).padding;

// ...
padding: EdgeInsets.fromLTRB(0, padding.top, 0, padding.bottom);
```

- 安卓全面屏适配: 如果应用未做适配, 全屏区间长宽比必须在1.333-1.86间
    
    添加android: MaxAspectRatio
    android.max_aspect中添加meta_data