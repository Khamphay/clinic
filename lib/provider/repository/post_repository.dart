import 'package:clinic/model/post_model.dart';

class PostRepository {
  Future<List<PostModel>> fetchPost() async {
    return await PostModel.fetchPost();
  }
}
