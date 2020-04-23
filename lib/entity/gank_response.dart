class GankResponse<T> {
  int page;
  int page_count;
  int status;
  int total_counts;
  String hot;
  String category;
  T data;

  GankResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("page")) {
      page = json['page'];
    }
    if (json.containsKey("page_count")) {
      page_count = json['page_count'];
    }
    if (json.containsKey("total_counts")) {
      total_counts = json['total_counts'];
    }
    if (json.containsKey("hot")) {
      hot = json['hot'];
    }
    if (json.containsKey("category")) {
      category = json['category'];
    }
    status = json['status'];

    if (json.containsKey("data")) {
      //data.fromJson(json['data']);
    }
  }

  @override
  String toString() {
    return 'GankResponse{page: $page, page_count: $page_count, status: $status, total_counts: $total_counts, data: $data}';
  }
}
