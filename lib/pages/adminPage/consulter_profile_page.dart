import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsulterProfilesPage extends StatefulWidget {
  const ConsulterProfilesPage({Key? key}) : super(key: key);

  @override
  _ConsulterProfilesPageState createState() => _ConsulterProfilesPageState();
}

class _ConsulterProfilesPageState extends State<ConsulterProfilesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _currentUser;
  List<Profile> profiles = [];
  List<Profile> filteredProfiles = [];
  String filterText = '';

  final List<String> _roles = ['admin', 'Employé'];
  String selectedRole = 'Employé';

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    debugger; // Add a breakpoint here
    _fetchProfiles();
  }

  void _fetchProfiles() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();

    List<Profile> fetchedProfiles = snapshot.docs.map((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        return Profile(
          doc.id,
          data['Nom'],
          data['email'],
          data['role'],
          data['profileIcon'],
        );
      } else {
        return Profile('', '', '', '', '');
      }
    }).toList();

    setState(() {
      profiles = fetchedProfiles;
      _applyFilter(); // Apply filter after fetching profiles
    });
  }

  void _resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Un e-mail de réinitialisation du mot de passe a été envoyé'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la réinitialisation du mot de passe'),
        ),
      );
    }
  }

  void _deleteProfile(Profile profile) async {
    try {
      if (profile.id == _currentUser.uid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vous ne pouvez pas supprimer votre propre profil'),
          ),
        );
        return;
      }

      // Delete the profile from Firestore
      await _firestore.collection('users').doc(profile.id).delete();

      // Remove the profile from the list
      setState(() {
        profiles.remove(profile);
        _applyFilter(); // Apply filter after deleting profile
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil supprimé avec succès')),
      );
    } catch (error) {
      // Show an error in case of failure
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la suppression du profil'),
        ),
      );
    }
  }

  void _editProfile(Profile profile) {
    String newName = profile.Nom;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier le profil'),
          content: TextField(
            onChanged: (value) {
              newName = value;
            },
            decoration: const InputDecoration(labelText: 'Nouveau nom'),
            controller: TextEditingController(text: profile.Nom),
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Enregistrer'),
              onPressed: () async {
                // Update the employee's name in Firestore
                await _firestore
                    .collection('users')
                    .doc(profile.id)
                    .update({'Nom': newName});

                // Update the profiles list
                setState(() {
                  profile.Nom = newName;
                  _applyFilter(); // Apply filter after updating profile
                });

                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(Profile profile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer le profil'),
          content: Text(
              'Voulez-vous vraiment supprimer le profil de ${profile.Nom}?'),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () {
                _deleteProfile(profile);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _createProfile() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String Nom = '';
        String email = '';
        String password = '';
        String profileIcon = '';

        return AlertDialog(
          title: const Text('Créer un profil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  Nom = value;
                },
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: const InputDecoration(labelText: 'E-mail'),
              ),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),
              DropdownButtonFormField<String>(
                value: selectedRole,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
                items: _roles.map<DropdownMenuItem<String>>((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Rôle',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Créer'),
              onPressed: () async {
                if (Nom.isNotEmpty &&
                    email.isNotEmpty &&
                    password.isNotEmpty &&
                    selectedRole.isNotEmpty) {
                  try {
                    // Create the user in Firebase Authentication
                    UserCredential userCredential =
                        await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    // Get the ID of the created user
                    String userID = userCredential.user!.uid;

                    // Create a new document in the "users" collection with the profile information
                    await _firestore.collection('users').doc(userID).set({
                      'Nom': Nom,
                      'email': email,
                      'role': selectedRole,
                      'profileIcon': profileIcon,
                    });

                    // Show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profil créé avec succès')),
                    );

                    // Refresh the profiles list
                    _fetchProfiles();

                    // Close the dialog
                    Navigator.of(context).pop();
                  } catch (error) {
                    // Show an error in case of failure
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erreur lors de la création du profil'),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _applyFilter() {
    setState(() {
      filteredProfiles = profiles.where((profile) {
        return profile.Nom.toLowerCase().contains(filterText.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulter les profils'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  filterText = value;
                  _applyFilter();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Filtrer par nom',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProfiles.length,
              itemBuilder: (context, index) {
                Profile profile = filteredProfiles[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(profile.profileIcon),
                  ),
                  title: Text(profile.Nom),
                  subtitle: Text(profile.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons
                            .lock), // Icône pour réinitialiser le mot de passe
                        onPressed: () {
                          _resetPassword(profile.email);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                            Icons.delete), // Icône pour supprimer les profils
                        onPressed: () {
                          _showConfirmationDialog(profile);
                        },
                      ),
                    ],
                  ),
                  onLongPress: () {
                    _showConfirmationDialog(profile);
                  },
                  onTap: () {
                    _editProfile(profile);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _createProfile,
      ),
    );
  }
}

class Profile {
  late String id;
  late String Nom;
  late String email;
  late String role;
  late String profileIcon;

  Profile(this.id, this.Nom, this.email, this.role, this.profileIcon);
}

void main() {
  runApp(const MaterialApp(
    home: ConsulterProfilesPage(),
  ));
}
