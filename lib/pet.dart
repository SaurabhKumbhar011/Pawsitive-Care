class Pet {
  String id;
  String name;
  int age;
  String type;
  String imageUrl;

  Pet({
    required this.id,
    required this.name,
    required this.age,
    required this.type,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'type': type,
      'imageUrl': imageUrl,
    };
  }

  factory Pet.fromMap(Map<String, dynamic> data, String id) {
    return Pet(
      id: id,
      name: data['name'],
      age: data['age'],
      type: data['type'],
      imageUrl: data['imageUrl'],
    );
  }
}
