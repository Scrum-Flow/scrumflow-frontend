enum PageStatus {
  none,
  loading,
  success,
  error;
}

class PageState {
  final PageStatus status;
  final String? info;
  final dynamic data;

  const PageState(
    this.status, {
    this.info,
    this.data,
  });

  factory PageState.loading([String? info]) =>
      PageState(PageStatus.loading, info: info);

  factory PageState.none() => const PageState(PageStatus.none);

  factory PageState.success({String? info, dynamic data}) =>
      PageState(PageStatus.success, info: info, data: data);

  factory PageState.error([String? info]) =>
      PageState(PageStatus.error, info: info);
}
