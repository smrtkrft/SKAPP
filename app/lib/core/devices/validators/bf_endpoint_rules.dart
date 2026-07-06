// sk_api USER endpoint alan sınırları — firmware sk_api.h sabitlerinin
// aynası. Hem OnDeviceApiEditorScreen hem şablon dağıtım servisi bu tek
// kaynaktan okur; cihaz sınırı değişirse tek dosya güncellenir.

/// SK_API_NAME_MAX
const int kBfEndpointNameMax = 31;

/// SK_API_URL_MAX
const int kBfEndpointUrlMax = 191;

/// SK_API_TOKEN_MAX
const int kBfEndpointTokenMax = 127;

/// SK_API_HEADER_MAX
const int kBfEndpointHeaderMax = 31;

/// SK_API_CT_MAX
const int kBfEndpointContentTypeMax = 63;

/// SK_API_EP_PAYLOAD_MAX (sk_api >= 0.5.0)
const int kBfEndpointPayloadMax = 512;

/// SK_API_DELAY_AFTER_MAX_SEC
const int kBfEndpointDelayMaxSec = 300;

enum BfEndpointJsonError {
  nameRequired,
  nameTooLong,
  urlRequired,
  urlTooLong,
  tokenTooLong,
  headerTooLong,
  contentTypeTooLong,
  payloadTooLong,
  delayOutOfRange,
}

/// Alan bazlı sınır denetimi — `api.endpoint.add` cihazda INVALID_ARG ile
/// reddetmeden ÖNCE app tarafında yakalanır. null = geçerli.
BfEndpointJsonError? validateBfEndpointFields({
  required String name,
  required String url,
  String? token,
  String? headerName,
  String? contentType,
  String? payload,
  int delayAfterSec = 0,
}) {
  if (name.trim().isEmpty) return BfEndpointJsonError.nameRequired;
  if (name.length > kBfEndpointNameMax) return BfEndpointJsonError.nameTooLong;
  if (url.trim().isEmpty) return BfEndpointJsonError.urlRequired;
  if (url.length > kBfEndpointUrlMax) return BfEndpointJsonError.urlTooLong;
  if ((token?.length ?? 0) > kBfEndpointTokenMax) {
    return BfEndpointJsonError.tokenTooLong;
  }
  if ((headerName?.length ?? 0) > kBfEndpointHeaderMax) {
    return BfEndpointJsonError.headerTooLong;
  }
  if ((contentType?.length ?? 0) > kBfEndpointContentTypeMax) {
    return BfEndpointJsonError.contentTypeTooLong;
  }
  if ((payload?.length ?? 0) > kBfEndpointPayloadMax) {
    return BfEndpointJsonError.payloadTooLong;
  }
  if (delayAfterSec < 0 || delayAfterSec > kBfEndpointDelayMaxSec) {
    return BfEndpointJsonError.delayOutOfRange;
  }
  return null;
}
