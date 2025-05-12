/// Extensions for List operations
extension SafeFirst<E> on List<E> {
  /// Safely get the first element of a list, returning null if the list is empty
  /// This prevents runtime errors when trying to access the first element of an empty list
  E? get safeFirst => isEmpty ? null : first;
}
