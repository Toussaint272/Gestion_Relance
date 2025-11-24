class Agent {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String role;
  final String? matricule;
  final int? idCentreGest;
  final String? codeBureau; // avy amin'ny relation centre
  final String? centreDesignation; // avy amin'ny relation centre

  Agent({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
    this.matricule,
    this.idCentreGest,
    this.codeBureau,
    this.centreDesignation,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      role: json['role'],
      matricule: json['matricule'],
      idCentreGest: json['id_centre_gest'],
      codeBureau: json['centre'] != null ? json['centre']['code_bureau'] : null,
      centreDesignation: json['centre'] != null
          ? json['centre']['CG_designation']
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nom": nom,
      "prenom": prenom,
      "email": email,
      "role": role,
      "id_centre_gest": idCentreGest,
      "password": null, // A remplir si ajout ou modification
    };
  }
}
