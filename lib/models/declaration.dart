/*class Declaration1 {
  final int id;
  final String taxPayerNo;
  final String? taxTypeNo;
  final String? taxPeriode;
  final String? saveDate;
  final String? receivedDate;
  final String? dateEcheance;
  final String? motif;
  final String? montant_liquide;
  final String? statut;

  Declaration1({
    required this.id,
    required this.taxPayerNo,
    this.taxTypeNo,
    this.taxPeriode,
    this.saveDate,
    this.receivedDate,
    this.dateEcheance,
    this.motif,
    this.montant_liquide,
    this.statut,
  });

  factory Declaration1.fromJson(Map<String, dynamic> json) {
    return Declaration1(
      id: json['N_decl'] ?? 0,
      taxPayerNo: json['tax_payer_no'],
      taxTypeNo: json['tax_type_no'],
      taxPeriode: json['tax_periode'],
      saveDate: json['save_date'],
      receivedDate: json['received_date'],
      dateEcheance: json['date_echeance'],
      motif: json['motif'],
      montant_liquide: json['montant_liquide'],
      statut: json['statut'],
    );
  }
}*/
class Declaration1 {
  final int id;
  final String taxPayerNo;
  final String? taxTypeNo;
  final String? taxPeriode;
  final String? saveDate;
  final String? receivedDate;
  final String? dateEcheance;
  final String? motif;
  final String? montant_liquide;
  final String? statut;

  Declaration1({
    required this.id,
    required this.taxPayerNo,
    this.taxTypeNo,
    this.taxPeriode,
    this.saveDate,
    this.receivedDate,
    this.dateEcheance,
    this.motif,
    this.montant_liquide,
    this.statut,
  });

  factory Declaration1.fromJson(Map<String, dynamic> json) {
    return Declaration1(
      // Ataovy azo antoka fa int foana ny id, na dia null aza ny any amin'ny DB
      id: json['N_decl'] is int
          ? json['N_decl']
          : int.tryParse(json['N_decl']?.toString() ?? '0') ?? 0,

      // Ampio ?? '' (default value) mba tsy hitera-doza raha null ny any amin'ny DB
      taxPayerNo: json['tax_payer_no']?.toString() ?? '',
      taxTypeNo: json['tax_type_no']?.toString(),
      taxPeriode: json['tax_periode']?.toString(),
      saveDate: json['save_date']?.toString(),
      receivedDate: json['received_date']?.toString(),
      dateEcheance: json['date_echeance']?.toString(),
      motif: json['motif']?.toString(),
      montant_liquide: json['montant_liquide']?.toString(),
      statut: json['statut']?.toString(),
    );
  }
}
