// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:aichatapp/app/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String docId;
  String catId;
  String id;
  String title;
  String? desc;
  String imageUrl;
  String prompt;
  String powerPrompt;
  String powerPromptPlaceholder;
  List<String>? prompt_extension;
  List<String> tips;

  Task({
    required this.id,
    required this.docId,
    required this.title,
    required this.catId,
    this.desc,
    required this.imageUrl,
    required this.prompt,
    required this.tips,
    this.prompt_extension,
    required this.powerPromptPlaceholder,
    required this.powerPrompt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': title,
      'task_image_url': imageUrl,
      'prompt': prompt,
      'tips': tips
    };
  }

  // factory Task.fromMap(Map<String, dynamic> map, {required String docId}) {
  //   return Task(
  //       id: map['id'] as String,
  //       docId: docId,
  //       title: map['name'] as String,
  //       imageUrl: map['task_image_url'] as String,
  //       prompt: map['prompt'] as String,
  //       tips: map['tips'] as List<String>);
  // }

  // String toJson() => json.encode(toMap());

  // factory Task.fromJson(String source) => Task.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Tasks {
  List<Task> _tasks = [];
  List<Task> get tasks {
    return [..._tasks];
  }

  Future<List<Task>> fetchAndSetTasks({required String catDocId}) async {
    List<Task> tempTasks = [];
    CollectionReference tasks =
        FirebaseFirestore.instance.collection('categories/$catDocId/tasks');
    QuerySnapshot response = await tasks.get();

    for (var doc in response.docs) {
      List<String> dbTips = [];
      var map = doc.data() as Map<String, dynamic>;
      if (map.containsKey('tips')) {
        var dynmaicTips = doc['tips'] as List<dynamic>;
        dynmaicTips.forEach((tip) {
          dbTips.add(tip);
        });
      } else {
        dbTips = [];
      }

      final field = 'prompt_extension';
      int index = 0;
      final List<String> extList = [];
      while (map.containsKey('$field${index == 0 ? '' : index}')) {
        extList.add(doc['prompt_extension${index == 0 ? '' : index}']);
        index = index + 1;
      }

      tempTasks.add(
        Task(
          docId: doc.id,
          catId: catDocId,
          id: doc['task_id'].toString(),
          title: doc['name'],
          desc: map.containsKey('description') ? doc['description'] : '',
          powerPrompt:
              map.containsKey('power_prompt') ? doc['power_prompt'] : '',
          powerPromptPlaceholder:
              map.containsKey('power_prompt_field_placeholder_text')
                  ? doc['power_prompt_field_placeholder_text']
                  : '',
          imageUrl: doc['task_image_url'],
          prompt: doc['prompt'],
          tips: dbTips,
          prompt_extension: extList,
        ),
      );
    }
    _tasks = tempTasks;
    return _tasks;
  }

  List<String> favoriteTasksIds = [];
  List<Task> favTasks = [];

  fetchFavoriteTaskIds({required String userId}) async {
    final refs = FirebaseFirestore.instance.collection('userPromptFavs');

    refs.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['userID'] == userId) {
          print('fav task : ${doc.id}');
          favoriteTasksIds.add(doc.id);
        }
        print('fav length: ${favoriteTasksIds.length}');
      });
    });

    favTasks = await fetchAndSetFavTasks();
  }

  Future<List<Task>> fetchAndSetFavTasks() async {
    List<Category> cats = await Categories().fetchAndSetCats();

    cats.forEach((cat) async {
      print('-------------yeh ha cat id : ${cat.id}');
// ye jo docId h ye document id h?ggg e k min ruk
      List<Task> tasks = await fetchAndSetTasks(catDocId: cat.docId);
      tasks.forEach((task) {
        if (favoriteTasksIds.contains(task.docId)) {
          favTasks.add(task);
        }
      });
      //each cat
      // FirebaseFirestore.instance
      //     .collection('categories/${cat.id}/tasks')
      //     .get()
      //     .then((QuerySnapshot querySnapshot) {
      //   List<Task> tempTasks = [];
      //   querySnapshot.docs.forEach((taskDoc) {
      //     if (favoriteTasksIds.contains(taskDoc.id)) {
      //       log('-------------yeh ha task id : ${taskDoc.id}');

      //       //adding task
      //       List<String> dbTips = [];
      //       var map = taskDoc.data() as Map<String, dynamic>;
      //       if (map.containsKey('tips')) {
      //         var dynmaicTips = taskDoc['tips'] as List<dynamic>;
      //         dynmaicTips.forEach((tip) {
      //           dbTips.add(tip);
      //         });
      //       } else {
      //         dbTips = [];
      //       }

      //       final field = 'prompt_extension';
      //       int index = 0;
      //       final List<String> extList = [];
      //       while (map.containsKey('$field${index == 0 ? '' : index}')) {
      //         extList
      //             .add(taskDoc['prompt_extension${index == 0 ? '' : index}']);
      //         index = index + 1;
      //       }

      //       tempTasks.add(
      //         Task(
      //           docId: taskDoc.id,
      //           catId: cat.id,
      //           id: taskDoc['task_id'].toString(),
      //           title: taskDoc['name'],
      //           desc: map.containsKey('description')
      //               ? taskDoc['description']
      //               : '',
      //           powerPrompt: map.containsKey('power_prompt')
      //               ? taskDoc['power_prompt']
      //               : '',
      //           powerPromptPlaceholder:
      //               map.containsKey('power_prompt_field_placeholder_text')
      //                   ? taskDoc['power_prompt_field_placeholder_text']
      //                   : '',
      //           imageUrl: taskDoc['task_image_url'],
      //           prompt: taskDoc['prompt'],
      //           tips: dbTips,
      //           prompt_extension: extList,
      //         ),
      //       );

      //       //adding task
      //     }
      //   });
      //   favTasks = tempTasks;
      // });
    });
    return favTasks;
  }
}
