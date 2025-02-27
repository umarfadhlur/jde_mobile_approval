class EndPoint {
  //static String _baseUrl = 'http://36.37.92.3:9281';
  static const String _baseUrl = 'http://192.168.9.39:9281/jderest';
  // static const String _baseUrl = 'http://202.69.100.5:9281/jderest';
  //static String _baseUrl = 'https://wms2.opusb.id/jderest';

  static String login = "$_baseUrl/v2/tokenrequest";
  static String logout = "$_baseUrl/v2/tokenrequest/logout";
  static String company = "$_baseUrl/orchestrator/EM_COMPANY_ORCH";
  static String addressNumber = "$_baseUrl/orchestrator/EM_USERID_ORCH";
  static String currency = "$_baseUrl/orchestrator/EM_CUR_ORCH";
  static String listPayment = "$_baseUrl/orchestrator/EM_MYREQUEST_ORCH";
  static String payment = "$_baseUrl/orchestrator/EM_MYREQUEST_PAYMENT3_ORCH";
  static String deletePay = "$_baseUrl/orchestrator/EM_REQ_DEL3_ORCH";
  static String updatePay = "$_baseUrl/orchestrator/EM_REQUEST_UPD_ORCH";
  static String addPay = "$_baseUrl/orchestrator/EM_PAYMENT_REQUEST_ORCH";

  static String addWO = "$_baseUrl/orchestrator/RUD_ADDWO_P17714_ORC3";
  static String addPO = "$_baseUrl/orchestrator/ARD_PO_Receipt";
  static String checkLot = "$_baseUrl/orchestrator/ARD_CHECK_LOT NUMBER";
  static String getQty = "$_baseUrl/orchestrator/ARD_GET BARCODE QTY UOM 2";
  static String updateItem = "$_baseUrl/orchestrator/ARD_GET BARCODE QTY UOM";
  static String getDesc = "$_baseUrl/orchestrator/ARD_GET ITEM DESC";

  static String getAN8 = "$_baseUrl/orchestrator/RUD_GETAN8_P0092_ORC";
  static String getListChart = "$_baseUrl/orchestrator/RUD_COUNTWOTYPE";
  static String getWatch = "$_baseUrl/orchestrator/RUD_COUNTWO_F4801_ORC";
  static String getWOList = "$_baseUrl/orchestrator/RUD_LISTWO_F4801_ORC";

  static String getApvList = "$_baseUrl/orchestrator/GetDataF55ORCH1";
  static String getApvDetail = "$_baseUrl/orchestrator/GetDataF55ORCH2";
  // static String getApvList = "$_baseUrl/orchestrator/UF_PO_APPROVAL_LIST";
  static String approvePO = "$_baseUrl/orchestrator/UF_APPROVE_PO";
  static String rejectPO = "$_baseUrl/orchestrator/UF_REJECT_PO";
  static String getEMList = "$_baseUrl/orchestrator/Equip_Master_HDN";
  static String getDetailList =
      "$_baseUrl/orchestrator/Equip_Master_Detail_HDN_Orch";

  static String getCCLocs = "$_baseUrl/orchestrator/CC_Locs_Orch";
  static String getCCLocItem = "$_baseUrl/orchestrator/CC_Loc_item_Orch";
  static String getCCLocItemLot = "$_baseUrl/orchestrator/CC_Loc_item_Lot_Orch";
  static String ccEntry = "$_baseUrl/orchestrator/CC_Entry_Orch";

  static String getLongLatEquipment =
      "$_baseUrl/orchestrator/RUD_GETXYEQUIP_P1704_ORC";
  static String updateEquipment =
      "$_baseUrl/orchestrator/RUD_SAVEXYEQUIP_P1704_ORC";

  //category
  static String category =
      "$_baseUrl/orchestrator/FETCH_EM_REM_EXPCATEGORY_ORC";

  //Suplier
  static String supplier = "$_baseUrl/orchestrator/EM_AB_EMP_ORCH";

  //Busines Unit
  static String businesUnit = "$_baseUrl/orchestrator/EM_BU_ORCH";

  //Reimburstment
  static String reimbursement = "$_baseUrl/orchestrator/FETCH_REM_INQ_ORC";

  //Find Customer
  static String findCustomer =
      "$_baseUrl/orchestrator/RUD_FINDCUSTOMER_F03012_ORC";

  //Find Equipment
  static String findEquipment = "$_baseUrl/orchestrator/RUD_FINDEQP_F1201_ORC";

  //Find Item
  static String findItem = "$_baseUrl/orchestrator/RUD_FINDITEM_F4101_ORC";

  //Add Notes
  static String addNotes = "$_baseUrl/orchestrator/RUD_ADDWOTEXT_P17714_ORC";
  static String test = "$_baseUrl/orchestrator/DownloadORDerAttachmentFiles";
  static String dlAttach = "$_baseUrl/orchestrator/UF_DOWNLOAD_FILES";
  static String notification = "$_baseUrl/orchestrator/UF_GETNOTIFICATIONS";
  static String watchlist = "$_baseUrl/orchestrator/AB_GetWatchList";
  static String newWatchlist = "$_baseUrl/orchestrator/AB_GetwatchListFinal";

  //Dover
  static String getVehicle = "$_baseUrl/orchestrator/HDN_GET_VEHICLE_REG";
  static String getAddress = "$_baseUrl/orchestrator/HDN_GET_ADDRESS";
  static String getShipmentHeader =
      "$_baseUrl/orchestrator/HDN_GET_SHIPMENT_HEADER";
  static String getShipmentDetail =
      "$_baseUrl/orchestrator/HDN_GET_SHIPMENT_DETAIL";
  static String generateSJ = "$_baseUrl/orchestrator/HDN_NEW_SJ";
  static String getSJ = "$_baseUrl/orchestrator/HDN_GET_SJ";
  static String updateSJ = "$_baseUrl/orchestrator/HDN_UPDATE_SJ";
  static String deliverSJ = "$_baseUrl/orchestrator/HDN_DELIV";
}
