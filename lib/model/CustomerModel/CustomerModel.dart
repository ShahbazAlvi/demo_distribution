class CustomerModel {
  final String id;
  final String customerName;
  final String address;
  final String phoneNumber;
  final int creditTime;
  final double salesBalance;
  final String timeLimit;
  final String formattedTimeLimit;

  CustomerModel({
    required this.id,
    required this.customerName,
    required this.address,
    required this.phoneNumber,
    required this.creditTime,
    required this.salesBalance,
    required this.timeLimit,
    required this.formattedTimeLimit,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['_id'] ?? '',
      customerName: json['customerName'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      creditTime: json['creditTime'] ?? 0,
      salesBalance: (json['salesBalance'] ?? 0).toDouble(),
      timeLimit: json['timeLimit'] ?? '',
      formattedTimeLimit: json['formattedTimeLimit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'customerName': customerName,
      'address': address,
      'phoneNumber': phoneNumber,
      'creditTime': creditTime,
      'salesBalance': salesBalance,
      'timeLimit': timeLimit,
      'formattedTimeLimit': formattedTimeLimit,
    };
  }
}
