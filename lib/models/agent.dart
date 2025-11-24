class Agent {
  final String? id;
  final String nom;
  final String prenom;
  final String email;
  final String bureau;
  final String role;
  final String? password; // ✅ ampiana

  Agent({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.bureau,
    required this.role,
    this.password, // ✅ facultatif
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'].toString(),
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      bureau: json['bureau'] ?? '',
      role: json['role'] ?? '',
      password: json['password'], // ✅ récupération si dispo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nom": nom,
      "prenom": prenom,
      "email": email,
      "bureau": bureau,
      "role": role,
      "password": password, // ✅ inclus à l’envoi
    };
  }
}
