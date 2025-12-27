import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';
import 'chat_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final HomeController controller = Get.put(HomeController());

  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _showFab = _tabController.index == 0;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              floating: true,
              snap: true,
              pinned: false,
              centerTitle: true,
              title: Container(
                width: 300,
                height: 40,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: "Users",),
                    Tab(text: "Chat History"),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            UsersListTab(controller: controller),
            HistoryTab(controller: controller),
          ],
        ),
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
              onPressed: () {
                controller.addUser("User ${DateTime.now().second}"); 
              },
              child: Icon(Icons.add,color: Colors.white,),
            )
          : null,
    );
  }
}

class UsersListTab extends StatefulWidget {
  final HomeController controller;
  const UsersListTab({Key? key, required this.controller}) : super(key: key);

  @override
  State<UsersListTab> createState() => _UsersListTabState();
}

class _UsersListTabState extends State<UsersListTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      if (widget.controller.users.isEmpty) {
        return const Center(child: Text("No users added. Tap [+] to add."));
      }
      return ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 80),
        itemCount: widget.controller.users.length,
        itemBuilder: (context, index) {
          final user = widget.controller.users[index];
          return ListTile(
            leading: Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.purple,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      user.name.isNotEmpty
                          ? user.name[0].toUpperCase()
                          : "?",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                    right: 2,
                    child: Icon(Icons.circle,color: Colors.green,size: 10))
              ],
            ),
            title: Text(user.name,style: GoogleFonts.montserrat(fontSize: 16,fontWeight: FontWeight.bold)),
            subtitle: Text("Online",style: GoogleFonts.montserrat()),
            onTap: () {
              Get.to(() => const ChatView(), arguments: user);
            },
          );
        },
      );
    });
  }
}

class HistoryTab extends StatefulWidget {
  final HomeController controller;
  const HistoryTab({Key? key, required this.controller}) : super(key: key);

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      if (widget.controller.chatSessions.isEmpty) {
        return const Center(child: Text("No chat history yet."));
      }
      return ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemCount: widget.controller.chatSessions.length,
        itemBuilder: (context, index) {
          final session = widget.controller.chatSessions[index];
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.purple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.green,
                child: Text(session.user.name.isNotEmpty ? session.user.name[0].toUpperCase() : "?", style: const TextStyle(color: Colors.white)),
              ),
            ),
            title: Text(session.user.name,style: GoogleFonts.montserrat(fontSize: 16,fontWeight: FontWeight.bold)),
            subtitle: Text(
              session.lastMessage.content, 
              maxLines: 1, 
              overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w400)
            ),
            trailing: Column(
              children: [
                Text(
                  "${session.lastUpdated.hour}:${session.lastUpdated.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.blue,
                  child: Text("2",style: GoogleFonts.montserrat(fontSize: 8,color: Colors.white)),
                )
              ],
            ),
            onTap: () {
              Get.to(() => const ChatView(), arguments: session.user);
            },
          );
        },
      );
    });
  }
}
