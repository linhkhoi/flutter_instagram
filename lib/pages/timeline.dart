import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/users.dart';
import 'package:flutter_instagram/pages/home.dart';
import 'package:flutter_instagram/widgets/header.dart';
import 'package:flutter_instagram/widgets/post.dart';
import 'package:flutter_instagram/widgets/progress.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  final Users currentUser;

  Timeline({this.currentUser});

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<Post> posts;
  final String currentUserId = currentUser?.id;

  @override
  void initState() {
    super.initState();
    getTimeline();
  }

  getTimeline() async {
    QuerySnapshot snapfl = await followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .get();

    List<String> locations = [];
    snapfl.docs.forEach((element) {
      final map2 = element.data();
      locations.add(map2);
    });
    print(locations);

    List<Post> newPos = [];

    QuerySnapshot snapshot = await usersRef.get();

    List<Users> listUsers = snapshot.docs.map((doc) => Users.fromDocument(doc)).toList();

    for(Users u in listUsers){
      // if(arr.contains(u.id)){
      //   QuerySnapshot snap = await postsRef
      //       .doc(u.id)
      //       .collection('userPosts')
      //       .orderBy('timestamp', descending: true)
      //       .get();
      //   List<Post> posts = snap.docs.map((doc) => Post.fromDocument(doc)).toList();
      //   newPos += posts;
      // }
    }
    // QuerySnapshot snapshot = await postsRef
    //     .doc(widget.currentUser.id)
    //     .collection('userPosts')
    //     .orderBy('timestamp', descending: true)
    //     .get();
    // List<Post> posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    setState(() {
      this.posts = newPos;
    });
  }

  buildTimeline() {
    if (posts == null) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return Text("No posts");
    } else {
      return ListView(children: posts);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(context, isAppTitle: true),
        body: RefreshIndicator(
            onRefresh: () => getTimeline(), child: buildTimeline()));
  }
}
