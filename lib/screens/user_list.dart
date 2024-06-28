import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:people_frontend/screens/login_screen.dart';
import 'package:people_frontend/screens/user_create.dart';
import 'package:people_frontend/screens/user_details.dart';
import 'package:people_frontend/services/api.services.dart';

class UserListData extends StatefulWidget {
  final String token;
  final int? id, user_type;
  UserListData({super.key, required this.token, this.id, this.user_type});

  @override
  State<UserListData> createState() => _UserListDataState();
}

class _UserListDataState extends State<UserListData>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _users = [];
  late Timer timer;
  bool _isLoading = true;
  late TabController groupTabBarController;

  @override
  void initState() {
    super.initState();
    _fetchData();
    groupTabBarController = TabController(length: 4, vsync: this);
    timer = Timer.periodic(Duration(seconds: 30),(t){
      _fetchData();
    });
  }

  @override
  void dispose() {
    groupTabBarController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final response = await show(widget.token);
      setState(() {
        _users = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeUser(int index) {
    setState(() {
      _users.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User delete successful!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        floatingActionButton: widget.user_type == 1
          ? FloatingActionButton(
            backgroundColor: Color.fromRGBO(201, 219, 240, 1),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateUserPage()));
            },
            child: Icon(
              Icons.add,
              color: Color.fromRGBO(21, 101, 192, 1.0),
            ),
          )
          : null,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: TabBar(
            dividerColor: Colors.white,
            indicatorColor: Colors.white,
            unselectedLabelStyle: TextStyle(color: Colors.white),
            labelColor: Colors.white,
            controller: groupTabBarController,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Admin'),
              Tab(text: 'General'),
              Tab(text: 'Guest')
            ],
          ),
          actions: [
            if (widget.user_type == 1)
              _buildUserTypeIcon(Icons.admin_panel_settings, "Admin")
            else if (widget.user_type == 2)
              _buildUserTypeIcon(Icons.person, "General User")
            else
              _buildUserTypeIcon(Icons.people, "Guest User")
          ],
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => LoginPage(),
          //       ),
          //     );
          //   },
          //   icon: const Icon(
          //     Icons.arrow_back_ios,
          //     color: Colors.white,
          //   ),
          // ),
          title: const Text(
            'User List',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromRGBO(21, 101, 192, 1.0),
        ),
        body: TabBarView(
          controller: groupTabBarController,
          children: [
            _buildUserListView(_users, 'All users'), // All users
            _buildUserListView(
                _users.where((user) => user['user_type'] == 1).toList(),
                "Admin users"), // Admin users
            _buildUserListView(
                _users.where((user) => user['user_type'] == 2).toList(),
                "General users"), // General users
            _buildUserListView(
                _users.where((user) => user['user_type'] == 3).toList(),
                "Guest users"), // Guest users
          ],
        ),
      ),
    );
  }

  Widget _buildUserTypeIcon(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, top: 10, bottom: 5),
      child: Column(
        children: [
          Icon(icon, size: 25, color: Colors.white),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 10),
          )
        ],
      ),
    );
  }

  Widget _buildUserListView(
      List<Map<String, dynamic>> users, String user_type) {
    if (users.length > 0) {
      return _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailsPage(
                    userId: users[index]['user_id'])));
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 5, bottom: 5),
              child: Card(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipOval(
                        child: Image.network(
                          (kIsWeb) ?
                          users[index]['image'] ??
                              'https://i.pinimg.com/originals/58/51/2e/58512eb4e598b5ea4e2414e3c115bef9.jpg':
                              checkUrl(users[index]['image']),
                          width: 65.0,
                          height: 65.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Row(
                            children: [
                              Text(
                                users[index]['name'] ?? 'No Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              if (users[index]['user_type'] == 1)
                                Icon(Icons.star,
                                    color: Colors.amber, size: 15)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Text(
                            users[index]['email'] ?? 'No Email',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                // widget.user_type == 1 ||
                                //         widget.id ==
                                //             users[index]['user_id']
                                //     ? Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               EditForm(user:_users[index]
                                //               )))
                                //     : ScaffoldMessenger.of(context)
                                //         .showSnackBar(
                                //         SnackBar(
                                //           content:
                                //               Text('You are not admin'),
                                //           duration:
                                //               Duration(seconds: 2),
                                //         ),
                                //       );
                              },
                              child: Text("edit")),
                            TextButton(
                              onPressed: () {
                                widget.user_type == 1
                                    ? _showDeleteDialog(
                                        context,
                                        users[index]['user_id'],
                                        widget.token,
                                        index)
                                    : ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('You are not admin'),
                                          duration:
                                              Duration(seconds: 2),
                                        ),
                                      );
                              },
                              child: Text("delete")),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off,
              size: 80,
              color: Color.fromARGB(255, 223, 221, 221),
            ),
            Text(
              "No ${user_type}",
              style: TextStyle(color: Color.fromARGB(255, 223, 221, 221)),
            ),
          ],
        )
      );
    }
  }

  Future<void> _showDeleteDialog(
      BuildContext context, int user_id, String token, int index) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _removeUser(index);
                var delete_status = await delete(user_id, token);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User deleted!'),
        ),
      );
    }
  }

  String checkUrl(String imageUrl){
    String realPath = imageUrl.substring(12);
    return "http://10.0.2.2${realPath}";
  }
}
