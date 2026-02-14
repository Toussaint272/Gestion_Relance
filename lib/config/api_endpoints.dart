class ApiEndpoints {
  // 🔹 IP + PORT (OVAINA ETO IHANY)
  static const String _host = "http://10.102.34.240:5000";

  // 🔹 BASE API
  static const String baseApi = "$_host/api";

  // =========================
  // 🔐 AUTH / USERS
  // =========================
  static const String login = "$baseApi/users/login";
  static const String users = "$baseApi/users";
  static const String authLogin = "$baseApi/auth/login";
  static const String registerAdmin = "$baseApi/users/register-admin";

  // =========================
  // 📊 STATS
  // =========================
  static const String statsOverview = "$baseApi/stats/overview";
  static const String statsBase = "$baseApi/stats";

  // =========================
  // 📩 RELANCES
  // =========================
  static String relanceHistorique(String matricule) =>
      "$baseApi/relance_declarationRoute/historique?matricule=$matricule";

  static const String relanceEffectuees = "$baseApi/relanceRoute/effectuees";
  static const String relanceSend = "$baseApi/relanceRoute/send";

  // =========================
  // ⏳ DÉCLARATIONS
  // =========================
  static const String declarationRetard =
      "$baseApi/declarationRetardRoute/en-retard";

  static String declarationByFiscalNo(String fiscalNo) =>
      "$baseApi/declarationRoute/$fiscalNo";

  static const String declarationFiltre =
      "$baseApi/declarationFiltreRoute/filtre";

  // =========================
  // 👤 CONTRIBUABLES
  // =========================
  static String contribuableByNif(String nif) =>
      "$baseApi/contribuableRoute/nif/$nif";

  static const String contribuableBase = "$baseApi/contribuableRoute";

  static const String filtreContribuableByAgent =
      "$baseApi/filtreContribuableRoute/by-agent";

  static const String totalDefaillant = "$baseApi/totalDefaillantRoute/all";

  // =========================
  // 🧾 ASSUJETTISSEMENT
  // =========================
  static const String assujettissement = "$baseApi/assujettissementRoute";

  static String assujettissementByFiscalNo(String fiscalNo) =>
      "$baseApi/assujettissementRoute/$fiscalNo";

  // =========================
  // 💰 PAIEMENTS
  // =========================
  static const String paiementBase = "$baseApi/paiementRoute";

  static String paiementByContribuable(String taxPayerNo) =>
      "$baseApi/paiementRoute/contribuable/$taxPayerNo";

  // =========================
  // 🏢 CENTRES
  // =========================
  static const String centres = "$baseApi/centres";
}
