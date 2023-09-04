class PaginatedList<T> {
  int pageNumber, pageSize, totalPages;
  int? totalItems;
  bool hasPrevious;
  bool hasNext;
  List<T> items;

  PaginatedList(this.items, this.pageNumber, this.pageSize, this.totalPages, this.totalItems, this.hasPrevious, this.hasNext);
}