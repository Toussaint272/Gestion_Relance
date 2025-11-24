class Contribuable1 {
  final int id;
  final String taxPayerNo;
  final String nif;
  final String rs;
  final String? centre;
  final String? adresse;
  final String? phone;
  final String? email;
  final int? dernAnnee;
  final bool actif;
  final String? activite;

  Contribuable1({
    required this.id,
    required this.taxPayerNo,
    required this.nif,
    required this.rs,
    this.centre,
    this.adresse,
    this.phone,
    this.email,
    this.dernAnnee,
    required this.actif,
    this.activite,
  });

  factory Contribuable1.fromJson(Map<String, dynamic> json) {
    return Contribuable1(
      id: json['id'],
      taxPayerNo: json['tax_payer_no'],
      nif: json['nif'],
      rs: json['rs'],
      centre: json['centre'] ?? '',
      adresse: json['adresse'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      dernAnnee: json['dern_annee'],
      actif: json['actif'] ?? false,
      activite: json['activite'] ?? '',
    );
  }
}
