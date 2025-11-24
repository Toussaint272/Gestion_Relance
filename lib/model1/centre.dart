class Centre {
  final int idCentreGest;
  final String cgDesignation;
  final String codeBureau;

  Centre({
    required this.idCentreGest,
    required this.cgDesignation,
    required this.codeBureau,
  });

  factory Centre.fromJson(Map<String, dynamic> json) {
    return Centre(
      idCentreGest: json['id_centre_gest'],
      cgDesignation: json['CG_designation'],
      codeBureau: json['code_bureau'],
    );
  }
}
