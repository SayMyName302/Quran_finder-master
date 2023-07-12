class AboutModel {
  String? _aboutText;
  String? _policyText;
  String? _termsandcondText;

  String? get aboutText => _aboutText;
  String? get policyText => _policyText;
  String? get termsandcondText => _termsandcondText;

  AboutModel(
      {required aboutText, required policyText, required termsandcondText}) {
    _aboutText = aboutText;
    _policyText = policyText;
    _termsandcondText = termsandcondText;
  }

  AboutModel.fromJson(Map<String, dynamic> json) {
    _aboutText = json['about'];
    _policyText = json['policy'];
    _termsandcondText = json['terms_and_conditions'];
  }
}
