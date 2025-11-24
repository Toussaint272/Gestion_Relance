/*class Paiement1 {
  final int idPaiement;
  final String contribuable;
  final String declaration;
  final double montantPayer;
  final double resteARecouvrer;
  final String modePaiement;
  final String datePaiement;

  Paiement1({
    required this.idPaiement,
    required this.contribuable,
    required this.declaration,
    required this.montantPayer,
    required this.resteARecouvrer,
    required this.modePaiement,
    required this.datePaiement,
  });

  /*factory Paiement1.fromJson(Map<String, dynamic> json) {
    return Paiement1(
      idPaiement: json['id_paiement'],
      contribuable: json['Contribuable1']?['rs'] ?? 'N/A',
      declaration: json['Declaration1']?['tax_type_no'] ?? 'N/A',
      montantPayer: (json['montant_payer'] ?? 0).toDouble(),
      resteARecouvrer: (json['reste_a_recouvrer'] ?? 0).toDouble(),
      modePaiement: json['mode_paiement'] ?? '',
      datePaiement: json['date_payment'] ?? '',
    );
  }*/
  factory Paiement1.fromJson(Map<String, dynamic> json) {
    return Paiement1(
      idPaiement: int.tryParse(json['id_paiement']?.toString() ?? '0') ?? 0,
      contribuable: json['Contribuable1']?['rs'] ?? 'Inconnu',
      declaration: json['Declaration1']?['tax_type_no'] ?? 'N/A',
      montantPayer:
          double.tryParse(json['montant_payer']?.toString() ?? '0') ?? 0.0,
      resteARecouvrer:
          double.tryParse(json['reste_a_recouvrer']?.toString() ?? '0') ?? 0.0,
      modePaiement: json['mode_paiement'] ?? 'Non spécifié',
      datePaiement: json['date_payment'] ?? '',
    );
  }
}*/
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
  final String declaration; // tax_type_no

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
      datePaiement: DateTime.parse(
        json['date_payment'],
      ), // ✅ ovaina ho DateTime
      modePaiement: json['mode_paiement'],
      valider: json['valider'],
      montantLiquide: (json['montant_liquide'] as num).toDouble(),
      resteARecouvrer: (json['reste_a_recouvrer'] as num).toDouble(),
      declaration: json['declaration'] ?? 'N/A',
    );
  }
}
