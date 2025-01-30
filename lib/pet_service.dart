import 'package:cloud_firestore/cloud_firestore.dart';
import 'pet.dart';

class PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new pet to a user's pets collection
  Future<void> addPet(String userId, Pet pet) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('pets')
        .doc(pet.id)
        .set(pet.toMap());
  }

  // Retrieve all pets for a user
  Future<List<Pet>> getPets(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('pets')
        .get();

    return snapshot.docs
        .map((doc) => Pet.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
