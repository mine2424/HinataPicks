// import 'package:flutter/material.dart';
// import 'Blog/Blog.dart';
// import 'video/video.dart';
// 
// class HomeSection extends StatefulWidget {
//   @override
//   _HomeSectionState createState() => _HomeSectionState();
// }
// 
// enum BottomIcons { Blog, Video, Archive, Other }
// 
// class _HomeSectionState extends State<HomeSection> {
//   BottomIcons bottomIcons = BottomIcons.Blog;
//   @override
//   Widget build(BuildContext context) {
//     //TabController _tabController;
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//           appBar: AppBar(
//             title: Text("HinataPicks", style: TextStyle(color: Colors.black)),
//             leading: IconButton(
//               icon: Icon(
//                 Icons.menu,
//                 color: Colors.black,
//               ),
//               onPressed: () {},
//             ),
//             actions: <Widget>[
//               IconButton(
//                 icon: Icon(Icons.settings),
//                 onPressed: () {},
//               )
//             ],
//             backgroundColor: Colors.white,
//             elevation: 0,
//             brightness: Brightness.light,
//             centerTitle: true,
//           ),
//           body: Stack(
//             children: [
//               bottomIcons == BottomIcons.Blog ? BlogPage() : Container(),
//               bottomIcons == BottomIcons.Video ? VideoPage() : Container(),
//               bottomIcons == BottomIcons.Other ? BlogPage() : Container(),
//               bottomIcons == BottomIcons.Archive ? BlogPage() : Container(),
//               Align(
//                   alignment: Alignment.bottomLeft,
//                   child: Container(
//                     padding: EdgeInsets.only(left: 24, right: 24, bottom: 30),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 bottomIcons = BottomIcons.Blog;
//                               });
//                             },
//                             child: bottomIcons == BottomIcons.Blog
//                                 ? Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.indigo.shade100
//                                             .withOpacity(0.6),
//                                         borderRadius:
//                                             BorderRadius.circular(30)),
//                                     padding: EdgeInsets.only(
//                                         left: 16, right: 16, top: 8, bottom: 8),
//                                     child: Row(
//                                       children: [
//                                         Icon(
//                                           Icons.book,
//                                           color: Colors.indigo,
//                                         ),
//                                         SizedBox(
//                                           width: 8,
//                                         ),
//                                         Text('blog',
//                                             style: TextStyle(
//                                                 color: Colors.indigo,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 15))
//                                       ],
//                                     ),
//                                   )
//                                 : Icon(Icons.book)),
//                         GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 bottomIcons = BottomIcons.Video;
//                               });
//                             },
//                             child: bottomIcons == BottomIcons.Video
//                                 ? Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.indigo.shade100
//                                             .withOpacity(0.6),
//                                         borderRadius:
//                                             BorderRadius.circular(30)),
//                                     padding: EdgeInsets.only(
//                                         left: 16, right: 16, top: 8, bottom: 8),
//                                     child: Row(
//                                       children: [
//                                         Icon(
//                                           Icons.video_library,
//                                           color: Colors.indigo,
//                                         ),
//                                         SizedBox(
//                                           width: 8,
//                                         ),
//                                         Text('Video',
//                                             style: TextStyle(
//                                                 color: Colors.indigo,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 15))
//                                       ],
//                                     ),
//                                   )
//                                 : Icon(Icons.video_library)),
//                         GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 bottomIcons = BottomIcons.Archive;
//                               });
//                             },
//                             child: bottomIcons == BottomIcons.Archive
//                                 ? Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.indigo.shade100
//                                             .withOpacity(0.6),
//                                         borderRadius:
//                                             BorderRadius.circular(30)),
//                                     padding: EdgeInsets.only(
//                                         left: 16, right: 16, top: 8, bottom: 8),
//                                     child: Row(
//                                       children: [
//                                         Icon(
//                                           Icons.library_books,
//                                           color: Colors.indigo,
//                                         ),
//                                         SizedBox(
//                                           width: 8,
//                                         ),
//                                         Text('Archive',
//                                             style: TextStyle(
//                                                 color: Colors.indigo,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 15))
//                                       ],
//                                     ),
//                                   )
//                                 : Icon(Icons.library_books)),
//                         GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 bottomIcons = BottomIcons.Other;
//                               });
//                             },
//                             child: bottomIcons == BottomIcons.Other
//                                 ? Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.indigo.shade100
//                                             .withOpacity(0.6),
//                                         borderRadius:
//                                             BorderRadius.circular(30)),
//                                     padding: EdgeInsets.only(
//                                         left: 16, right: 16, top: 8, bottom: 8),
//                                     child: Row(
//                                       children: [
//                                         Icon(
//                                           Icons.settings,
//                                           color: Colors.indigo,
//                                         ),
//                                         SizedBox(
//                                           width: 8,
//                                         ),
//                                         Text('Other',
//                                             style: TextStyle(
//                                                 color: Colors.indigo,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 15))
//                                       ],
//                                     ),
//                                   )
//                                 : Icon(Icons.settings)),
//                       ],
//                     ),
//                   ))
//             ],
//           )),
//     );
//   }
// }
