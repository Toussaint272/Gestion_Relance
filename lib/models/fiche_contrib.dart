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

  get resteARecouvrer => null;

  get valider => null;
}

class Assujettissement1 {
  final int id;
  final String fiscalNo;
  final int annee;
  final String periodicite;
  final DateTime? debut;
  final DateTime? fin;
  final bool actif;
  final String? etat;

  Assujettissement1({
    required this.id,
    required this.fiscalNo,
    required this.annee,
    required this.periodicite,
    this.debut,
    this.fin,
    required this.actif,
    this.etat,
  });

  factory Assujettissement1.fromJson(Map<String, dynamic> json) {
    return Assujettissement1(
      id: json['id_assuj'],
      fiscalNo: json['fiscal_no'],
      annee: json['annee'],
      periodicite: json['periodicite'] ?? '',
      debut: json['debut'] != null ? DateTime.parse(json['debut']) : null,
      fin: json['fin'] != null ? DateTime.parse(json['fin']) : null,
      actif: json['actif'] == 1,
      etat: json['etat'],
    );
  }
}

class Declaration1 {
  final int nDecl;
  final String taxPayerNo;
  final String taxTypeNo;
  final DateTime? taxPeriode;
  final DateTime? saveDate;
  final DateTime? receivedDate;
  final DateTime? dateEcheance;
  final String? motif;
  final String? montant_liquide;
  final String? statut;
  final String? docStateNo;

  Declaration1({
    required this.nDecl,
    required this.taxPayerNo,
    this.taxTypeNo = '',
    this.taxPeriode,
    this.saveDate,
    this.receivedDate,
    this.dateEcheance,
    this.motif,
    this.montant_liquide,
    this.statut,
    this.docStateNo,
  });

  factory Declaration1.fromJson(Map<String, dynamic> json) {
    return Declaration1(
      nDecl: json['N_decl'],
      taxPayerNo: json['tax_payer_no'],
      taxTypeNo: json['tax_type_no'] ?? '',
      taxPeriode: json['tax_periode'] != null
          ? DateTime.parse(json['tax_periode'])
          : null,
      saveDate: json['save_date'] != null
          ? DateTime.parse(json['save_date'])
          : null,
      receivedDate: json['received_date'] != null
          ? DateTime.parse(json['received_date'])
          : null,
      dateEcheance: json['date_echeance'] != null
          ? DateTime.parse(json['date_echeance'])
          : null,
      motif: json['motif'],
      montant_liquide: json['montant_liquide'],
      statut: json['statut'],
      docStateNo: json['doc_state_no'],
    );
  }
}
