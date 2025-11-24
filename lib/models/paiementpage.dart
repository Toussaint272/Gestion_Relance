class Paiement1 {
  final int idPaiement;
  final String taxPayerNo;
  final String contribuable;
  final int nDecl;
  final double montantPayer;
  final DateTime datePaiement;
  final String modePaiement;
  final bool valider;
  final double montantLiquide;
  final double resteARecouvrer;
  final String declaration;

  Paiement1({
    required this.idPaiement,
    required this.taxPayerNo,
    required this.contribuable,
    required this.nDecl,
    required this.montantPayer,
    required this.datePaiement,
    required this.modePaiement,
    required this.valider,
    required this.montantLiquide,
    required this.resteARecouvrer,
    required this.declaration,
  });

  factory Paiement1.fromJson(Map<String, dynamic> json) {
    return Paiement1(
      idPaiement: json['id'],
      taxPayerNo: json['tax_payer_no'],
      contribuable: json['contribuable'] ?? 'Inconnu',
      nDecl: json['N_decl'],
      montantPayer: (json['montant_payer'] as num).toDouble(),
      datePaiement: DateTime.parse(json['date_payment']),
      modePaiement: json['mode_paiement'],
      valider: json['valider'],
      montantLiquide: (json['montant_liquide'] as num).toDouble(),
      resteARecouvrer: (json['reste_a_recouvrer'] as num).toDouble(),
      declaration: json['declaration'] ?? 'N/A',
    );
  }
}
