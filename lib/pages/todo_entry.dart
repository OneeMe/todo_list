import 'package:flutter/material.dart';
import 'package:todo_list/config/colors.dart';
import 'package:todo_list/pages/calendart.dart';
import 'package:todo_list/pages/reporter.dart';
import 'package:todo_list/pages/route_url.dart';
import 'package:todo_list/pages/about.dart';
import 'package:todo_list/pages/todo_list.dart';

class TodoEntryPage extends StatefulWidget {
  TodoEntryPage({Key key}) : super(key: key);

  _TodoEntryState createState() => _TodoEntryState();
}

class _TodoEntryState extends State<TodoEntryPage> {
  // List<Widget> childPages;
  int currentIndex;

  final List<TabConfig> tabConfigs = [
    TabConfig(title: '你的清单', page: TodoListPage(), imagePath: 'assets/images/lists.png'),
    TabConfig(title: '日历', page: CalendarPage(), imagePath: 'assets/images/calendar.png'),
    TabConfig(title: '', page: Container(), imagePath: 'assets/images/add.png', size: 50, singleImage: true),
    TabConfig(title: '任务回顾', page: ReporterPage(), imagePath: 'assets/images/report.png'),
    TabConfig(title: '关于', page: AboutPage(), imagePath: 'assets/images/about.png'),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  void _onTabChange(int index) async {
    if (mounted) {
      if (index == 2) {
        await Navigator.of(context).pushNamed(EDIT_TODO_PAGE_URL);
        index = 0;
      }
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: IndexedStack(
         index: currentIndex,
         children: tabConfigs.map((config) => config.page).toList()
       ),
      //  body: childPages[currentIndex],
       appBar: AppBar(
         title: Text(tabConfigs[currentIndex].title),
         automaticallyImplyLeading: false,
         backgroundColor: BACKGROUND_COLOR,
         centerTitle: true,
       ),
       bottomNavigationBar: BottomNavigationBar(
         onTap: _onTabChange,
         currentIndex: currentIndex,
         type: BottomNavigationBarType.fixed,
         items: tabConfigs.map((config) => config.navigationBarItem).toList(),
       ),
    );
  }
}

class TabConfig {
  /// Tab 名字
  final String title;
  /// Tab 上显示的图片
  final String imagePath;
  /// tab 对应的页面
  final Widget page;
  /// 根据配置生成的 BottomNavigationBarItem
  final BottomNavigationBarItem navigationBarItem;

  TabConfig({
    this.title,
    this.imagePath,
    this.page,
    double size = 24,
    bool singleImage = false,
  }) : this.navigationBarItem = buildBottomNavigationBarItem(imagePath, size: size, singleImage: singleImage);


  static Color activeTabColor = Color(0xff50D2C2);
  static Color inactiveTabColor = Colors.black;
  static BottomNavigationBarItem buildBottomNavigationBarItem(String imagePath, {double size, bool singleImage}) {
    if (singleImage) {
      return BottomNavigationBarItem(
        icon: Image(
          width: size,
          height: size,
          image: AssetImage(imagePath),
        ),
        title: Text(''),
      );
    }
    ImageIcon activeIcon = ImageIcon(
      AssetImage(imagePath),
      size: size,
      color: activeTabColor,
    );
    ImageIcon inactiveImageIcon = ImageIcon(
      AssetImage(imagePath),
      size: size,
      color: singleImage ? Colors.transparent : inactiveTabColor,
    );
    return BottomNavigationBarItem(
      activeIcon: activeIcon,
      icon: inactiveImageIcon,
      title: Text(''),
    );
  }
}