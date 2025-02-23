import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/enums.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider(
      ChangeNotifierProviderRef<NotificationProvider> this.ref);
  Ref? ref;
  StateEnum getCreatedState = StateEnum.loading;
  StateEnum getAssignedState = StateEnum.loading;
  StateEnum getWatchingState = StateEnum.loading;
  StateEnum getUnreadState = StateEnum.loading;
  StateEnum getArchivedState = StateEnum.loading;
  StateEnum getSnoozedState = StateEnum.loading;

  int getCreatedCount = 0;
  int getAssignedCount = 0;
  int getWatchingCount = 0;
  int totalUnread = 0;

  List<dynamic> created = [];
  List<dynamic> assigned = [];
  List<dynamic> watching = [];
  List<dynamic> unread = [];
  List<dynamic> archived = [];
  List<dynamic> snoozed = [];
  DateTime? snoozedDate;

  Future getNotifications({
    required String type,
    bool getUnread = false,
    bool getArchived = false,
    bool getSnoozed = false,
  }) async {
    type == 'created'
        ? getCreatedState = StateEnum.loading
        : type == 'assigned'
            ? getAssignedState = StateEnum.loading
            : type == 'watching'
                ? getWatchingState = StateEnum.loading
                : type == 'unread'
                    ? getUnreadState = StateEnum.loading
                    : type == 'archived'
                        ? getArchivedState = StateEnum.loading
                        : type == 'snoozed'
                            ? getSnoozedState = StateEnum.loading
                            : null;
    notifyListeners();
    String slug = ref!
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace!
        .workspaceSlug;
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: getUnread
            ? '${APIs.notifications.replaceAll('\$SLUG', slug)}?read=false'
            : getArchived
                ? '${APIs.notifications.replaceAll('\$SLUG', slug)}?archived=true'
                : getSnoozed
                    ? '${APIs.notifications.replaceAll('\$SLUG', slug)}?snoozed=true'
                    : '${APIs.notifications.replaceAll('\$SLUG', slug)}?type=$type',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      // log('getNotifications: ${response.data.toString()}');
      if (type == 'created') {
        created = response.data;
      } else if (type == 'assigned') {
        assigned = response.data;
      } else if (type == 'watching') {
        watching = response.data;
      }

      if (getUnread) {
        // log('getUnread: ${response.data.toString()}');
        unread = response.data;
      }
      if (getArchived) {
        // log('getArchived: ${response.data.toString()}');
        archived = response.data;
      }
      if (getSnoozed) {
        // log('getSnoozed: ${response.data.toString()}');
        snoozed = response.data;
      }
      type == 'created'
          ? getCreatedState = StateEnum.success
          : type == 'assigned'
              ? getAssignedState = StateEnum.success
              : type == 'watching'
                  ? getWatchingState = StateEnum.success
                  : type == 'unread'
                      ? getUnreadState = StateEnum.success
                      : type == 'archived'
                          ? getArchivedState = StateEnum.success
                          : type == 'snoozed'
                              ? getSnoozedState = StateEnum.success
                              : null;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
      type == 'created'
          ? getCreatedState = StateEnum.error
          : type == 'assigned'
              ? getAssignedState = StateEnum.error
              : getWatchingState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getUnreadCount() async {
    String slug = ref!
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace!
        .workspaceSlug;
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: '${APIs.notifications.replaceAll('\$SLUG', slug)}unread',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      log('getUnreadCount: ${response.data.toString()}');
      getCreatedCount = response.data['created_issues'];
      getAssignedCount = response.data['my_issues'];
      getWatchingCount = response.data['watching_issues'];

      totalUnread = getCreatedCount + getAssignedCount + getWatchingCount;

      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
    }
  }

  Future markAsRead(String notificationId) async {
    String slug = ref!
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace!
        .workspaceSlug;
    log('${APIs.notifications.replaceAll('\$SLUG', slug)}$notificationId/read');
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url:
            '${APIs.notifications.replaceAll('\$SLUG', slug)}$notificationId/read/',
        hasBody: true,
        data: {},
        httpMethod: HttpMethod.post,
      );
      log('markAsRead: ${response.data.toString()}');
      getUnreadCount();
      getNotifications(type: '', getUnread: true);
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
    }
  }

  Future archiveNotification(
      String notificationId, HttpMethod httpMethod) async {
    String slug = ref!
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace!
        .workspaceSlug;
    log('${APIs.notifications.replaceAll('\$SLUG', slug)}$notificationId');
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url:
            '${APIs.notifications.replaceAll('\$SLUG', slug)}$notificationId/archive/',
        hasBody: httpMethod == HttpMethod.post ? true : false,
        data: {},
        httpMethod: httpMethod,
      );
      log('archiveNotification: ${response.data.toString()}');
      getUnreadCount();
      getNotifications(type: 'archived', getArchived: true);
      getNotifications(type: 'assigned');
      getNotifications(type: 'created');
      getNotifications(type: 'watching');

      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
    }
  }

  Future updateSnooze(String notificationId) async {
    if (snoozedDate == null) {
      return;
    }
    String slug = ref!
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace!
        .workspaceSlug;
    log('${APIs.notifications.replaceAll('\$SLUG', slug)}$notificationId');
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: '${APIs.notifications.replaceAll('\$SLUG', slug)}$notificationId/',
        hasBody: true,
        data: {
          'snoozed_till': snoozedDate!.toIso8601String(),
        },
        httpMethod: HttpMethod.patch,
      );
      log('updateSnooze: ${response.data.toString()}');
      snoozedDate = null;
      getUnreadCount();
      getNotifications(type: 'snoozed', getSnoozed: true);
      getNotifications(type: 'assigned');
      getNotifications(type: 'created');
      getNotifications(type: 'watching');

      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
    }
  }
}
