class GetAddressResponse {
  final List<GetAddress> rowset;

  GetAddressResponse({required this.rowset});

  factory GetAddressResponse.fromJson(Map<String, dynamic> json) {
    return GetAddressResponse(
      rowset: (json["ServiceRequest1"]["fs_DATABROWSE_V0116B"]["data"]
              ["gridData"]["rowset"] as List)
          .map((item) => GetAddress.fromJson(item))
          .toList(),
    );
  }
}

class GetAddress {
  final String addressLine1;
  final String addressLine2;

  GetAddress({required this.addressLine1, required this.addressLine2});

  factory GetAddress.fromJson(Map<String, dynamic> json) {
    return GetAddress(
      addressLine1: json["F0116_ADD1"],
      addressLine2: json["F0116_ADD2"],
    );
  }
}
