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
      id: json['N_decl'],
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
}
