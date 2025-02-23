import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/enums.dart';

class PageProvider with ChangeNotifier {
  StateEnum pagesListState = StateEnum.empty;
  StateEnum blockState = StateEnum.empty;
  StateEnum pageFavoriteState = StateEnum.empty;
  StateEnum blockSheetState = StateEnum.empty;

  PageFilters selectedFilter = PageFilters.all;
  Map<PageFilters, List<dynamic>> pages = {
    PageFilters.all: [],
    PageFilters.recent: [],
    PageFilters.favourites: [],
    PageFilters.createdByMe: [],
    PageFilters.createdByOthers: [],
  };
  List blocks = [];

  String getQuery(PageFilters filters) {
    switch (filters) {
      case PageFilters.all:
        return '?page_view=all';
      case PageFilters.recent:
        return '?page_view=recent';
      case PageFilters.favourites:
        return '?page_view=favorite';
      case PageFilters.createdByMe:
        return '?page_view=created_by_me';
      case PageFilters.createdByOthers:
        return '?page_view=created_by_other';
      default:
        return '?page_view=all';
    }
  }

  Future filterPageList(
      {required PageFilters pageFilter,
      required slug,
      required projectId,
      required userId}) async {
    selectedFilter = pageFilter;
    await updatepageList(
      slug: slug,
      projectId: projectId,
    );
  }

  Future handleBlocks(
      {required String pageID,
      required String slug,
      required HttpMethod httpMethod,
      required String blockID,
      String? name,
      String? description,
      required String projectId}) async {
    try {
      if (httpMethod != HttpMethod.get || httpMethod == HttpMethod.delete) {
        if (httpMethod == HttpMethod.delete) {
          blockState = StateEnum.loading;
        }
        blockSheetState = StateEnum.loading;
        notifyListeners();
      } else {
        blockState = StateEnum.loading;
      }
      var res = await DioConfig().dioServe(
          httpMethod: httpMethod,
          hasAuth: true,
          hasBody: httpMethod == HttpMethod.get ? false : true,
          url: APIs.pageBlock
                  .replaceAll("\$SLUG", slug)
                  .replaceAll("\$PAGEID", pageID)
                  .replaceAll("\$PROJECTID", projectId) +
              (httpMethod == HttpMethod.patch || httpMethod == HttpMethod.delete
                  ? "$blockID/"
                  : ""),
          data: httpMethod == HttpMethod.get || httpMethod == HttpMethod.delete
              ? null
              : {
                  'name': name,
                  "description": description,
                });
      log(res.statusCode.toString());
      if (httpMethod == HttpMethod.delete) {
        blocks.removeWhere((element) => element['id'] == blockID);
      } else if (httpMethod == HttpMethod.post) {
        blocks.add(res.data);
      } else if (httpMethod == HttpMethod.patch) {
        blocks[blocks.indexWhere((element) => element["id"] == blockID)] =
            res.data;
      } else {
        blocks = res.data;
      }
      blockSheetState = StateEnum.success;
      blockState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      //log(e.response.toString());
      log(e.response!.data.toString());
      blockSheetState = StateEnum.failed;
      blockState = StateEnum.error;
      notifyListeners();
    }
  }

  Future updatepageList({
    required String slug,
    required String projectId,
  }) async {
    pagesListState = StateEnum.loading;
    notifyListeners();
    try {
      log(APIs.getPages
              .replaceAll("\$SLUG", slug)
              .replaceAll("\$PROJECTID", projectId) +
          getQuery(selectedFilter));
      Response response = await DioConfig().dioServe(
          httpMethod: HttpMethod.get,
          url: APIs.getPages
                  .replaceAll("\$SLUG", slug)
                  .replaceAll("\$PROJECTID", projectId) +
              getQuery(selectedFilter));

      if (selectedFilter == PageFilters.recent) {
        pages[PageFilters.recent] = [];
        response.data.forEach((key, element) {
          pages[PageFilters.recent]!.addAll(element);
        });
      } else {
        pages[selectedFilter] = response.data;
      }

      pagesListState = StateEnum.success;
      setState();
    } on DioException catch (e) {
      log(e.response.toString());
      pagesListState = StateEnum.error;
      setState();
    }
  }

  Future makePageFavorite(
      {required String pageId,
      required String slug,
      required String projectId,
      required bool shouldItBeFavorite}) async {
    pageFavoriteState = StateEnum.loading;
    setState();
    try {
      if (shouldItBeFavorite) {
        await DioConfig().dioServe(
            httpMethod: HttpMethod.post,
            data: {"page": pageId},
            hasAuth: true,
            hasBody: true,
            url: APIs.favouritePage
                .replaceAll("\$SLUG", slug)
                .replaceAll("\$PROJECTID", projectId));
      } else {
        await DioConfig().dioServe(
            hasAuth: true,
            hasBody: false,
            httpMethod: HttpMethod.delete,
            url:
                '${APIs.favouritePage.replaceAll("\$SLUG", slug).replaceAll("\$PROJECTID", projectId)}$pageId/');
      }

      pageFavoriteState = StateEnum.success;
      setState();
    } on DioException catch (e) {
      pageFavoriteState = StateEnum.error;
      log(e.response.toString());

      setState();
    }
  }

  Future editPage({
    required String slug,
    required String projectId,
    required String pageId,
    required dynamic data,
  }) async {
    blockSheetState = StateEnum.loading;
    notifyListeners();
    try {
      var res = await DioConfig().dioServe(
          httpMethod: HttpMethod.patch,
          hasAuth: true,
          hasBody: true,
          url:
              "${APIs.getPages.replaceAll("\$SLUG", slug).replaceAll("\$PROJECTID", projectId)}$pageId/",
          data: data);
      int index = pages[selectedFilter]!
          .indexWhere((element) => element["id"] == pageId);
      pagesListState = StateEnum.success;
      res.data["is_favorite"] = pages[selectedFilter]![index]["is_favorite"];
      pages[selectedFilter]![index] = res.data;

      blockSheetState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      //log(e.response.toString());
      log(e.response!.data.toString());
      blockSheetState = StateEnum.error;
      notifyListeners();
      setState();
    }
  }

  Future converToIssues(
      {required String slug,
      required String pageID,
      required String projectId,
      required String blockID}) async {
    try {
      blockState = StateEnum.loading;
      notifyListeners();
      var res = await DioConfig().dioServe(
          httpMethod: HttpMethod.post,
          hasAuth: true,
          hasBody: true,
          data: {},
          url:
              "${APIs.pageBlock.replaceAll("\$SLUG", slug).replaceAll("\$PAGEID", pageID).replaceAll("\$PROJECTID", projectId)}$blockID/issues/");

      await handleBlocks(
          pageID: pageID,
          slug: slug,
          httpMethod: HttpMethod.get,
          blockID: blockID,
          projectId: projectId);
      blockState = StateEnum.success;

      log(res.data.toString());
      notifyListeners();
    } on DioException catch (err) {
      blockState = StateEnum.error;
      notifyListeners();
    }
  }

  Future addPage({
    required String pageTitle,
    required String slug,
    required String projectId,
    required String userId,
  }) async {
    pagesListState = StateEnum.loading;
    setState();
    try {
      await DioConfig().dioServe(
          httpMethod: HttpMethod.post,
          url: APIs.createPage
              .replaceAll("\$SLUG", slug)
              .replaceAll("\$PROJECTID", projectId),
          data: {"name": pageTitle});
      pagesListState = StateEnum.success;
      updatepageList(
        slug: slug,
        projectId: projectId,
      );
      setState();
    } on DioException catch (e) {
      log(e.response.toString());
      pagesListState = StateEnum.error;
      setState();
    }
  }

  Future deletePage({
    required String pageId,
    required String slug,
    required String projectId,
    required String userId,
  }) async {
    pagesListState = StateEnum.loading;
    setState();
    try {
      await DioConfig().dioServe(
        httpMethod: HttpMethod.delete,
        url: APIs.deletePage
            .replaceAll("\$SLUG", slug)
            .replaceAll("\$PAGEID", pageId)
            .replaceAll("\$PROJECTID", projectId),
      );

      pagesListState = StateEnum.success;
      setState();
    } on DioException catch (e) {
      log(e.response.toString());
      pagesListState = StateEnum.error;
      setState();
    }
  }

  void clear() {}
  void setState() {
    notifyListeners();
  }
}
