class Post {
  final String image, name, text, time, messages;
  final bool replied;
  final int likes, timeInMinutes;

  Post(this.image, this.name, this.text, this.time, this.messages, this.replied,
      {this.likes = 0, this.timeInMinutes = 10});

  static List<Post> postsList() {
    List<Post> list = [];

    list.add(
      Post('assets/images/profile/avatar_2.jpg', 'Dr. John Rodriguez',
          'Hello, how can i help you man?', '14:22 am', '2', false, likes: 54),
    );
    list.add(
      Post('assets/images/profile/avatar_1.jpg', 'Dr. Elizabeth Scott',
          'Thank you for visiting.', '05:25 pm', '2', true, likes: 3),
    );
    list.add(
      Post('assets/images/profile/avatar_3.jpg', 'Dr. Miguel Johnson',
          'What are your requirements?', '12:32 am', '1', false, likes: 12),
    );
    list.add(
      Post('assets/images/profile/avatar_4.jpg', 'Dr. Sarah Palson',
          'I want a 2 floored house.', '07:56 am', '2', true, likes: 7),
    );
    list.add(
      Post('assets/images/profile/avatar_5.jpg', 'Dr. Anna Handy',
          'Hello, when will you be available?', '16:45 am', '2', true, likes: 23),
    );

    return list;
  }

  static Post getOne() {
    return postsList().first;
  }
}
