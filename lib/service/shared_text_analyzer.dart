import 'package:collection/collection.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:trip/domain/bookmark.dart';
import 'package:trip/domain/shared_poi.dart';
import 'package:trip/domain/shared_text.dart';
import 'package:trip/repository/google_maps/place_api_client.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/util/global.dart';
import 'package:trip/util/string_ex.dart';

///
/// Created by jozuko on 2023/02/18.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SharedTextAnalyzer {
  static const _googleMapsUrl = "https://maps.app.goo.gl/";
  final _placeApiClient = getIt.get<PlaceApiClient>();

  Future<SharedData> analyze(String sharedText) async {
    TripLog.i('SharedTextAnalyzer::analyze start [$sharedText]');

    if (sharedText.contains(_googleMapsUrl)) {
      return await analyzeFromGoogleMap(sharedText);
    } else if (sharedText.startsWith("http")) {
      return await analyzeFromUrl(sharedText);
    } else {
      TripLog.e('SharedTextAnalyzer::analyze end cannot understand this text.');
      return const Bookmark();
    }
  }

  Future<SharedPoi> analyzeFromGoogleMap(String sharedText) async {
    TripLog.i('SharedTextAnalyzer::analyzeFromGoogleMap start [$sharedText]');
    final split = sharedText.split("\n");
    final url = split.firstWhereOrNull((element) => element.startsWith(_googleMapsUrl));
    if (url == null) {
      TripLog.e('SharedTextAnalyzer::analyzeFromGoogleMap end cannot understand this text.');
      return const SharedPoi();
    }

    final bookmark = await analyzeFromUrl(url);
    var sharedPoi = SharedPoi(
      url: bookmark.url,
      title: bookmark.title,
      description: bookmark.description,
      imageUrl: bookmark.imageUrl,
    );

    final searchTextRes = await _placeApiClient.searchText(bookmark.title);
    if (!searchTextRes.isSuccess) {
      TripLog.e('SharedTextAnalyzer::analyzeFromGoogleMap searchText failed. statusCode=${searchTextRes.statusCode}');
      return sharedPoi;
    }
    final placeId = searchTextRes.results.firstOrNull?.placeId.emptyToNull;
    if (placeId == null) {
      TripLog.i('SharedTextAnalyzer::analyzeFromGoogleMap searchText end. results is empty');
      return sharedPoi;
    }

    final searchDetailRes = await _placeApiClient.searchDetail(placeId);
    if (!searchDetailRes.isSuccess) {
      TripLog.e('SharedTextAnalyzer::analyzeFromGoogleMap searchDetail failed. statusCode=${searchDetailRes.statusCode}');
      return sharedPoi;
    }

    final detail = searchDetailRes.result;
    if (detail == null) {
      return sharedPoi;
    }

    var description = detail.overview;
    if (description.isEmpty) {
      description = bookmark.description;
    }

    return SharedPoi(
      url: detail.website,
      title: detail.name,
      description: description,
      imageUrl: bookmark.imageUrl,
      placeId: placeId,
      openingHours: detail.openingHours,
      address: detail.address,
      phoneNumber: detail.phoneNumber,
      location: detail.location,
      types: detail.types,
    );
  }

  Future<Bookmark> analyzeFromUrl(String url) async {
    TripLog.i('SharedTextAnalyzer::analyzeFromUrl start [$url]');
    var bookmark = Bookmark(url: url);

    try {
      Response response = await get(Uri.parse(url));
      final document = parse(response.body);
      final head = document.head;
      if (head == null) {
        TripLog.i('SharedTextAnalyzer::analyzeFromUrl no head url');
        return bookmark;
      }

      return bookmark.copyWith(
        title: _getTitle(head),
        description: _getDescription(head),
        imageUrl: _getImageUrl(head),
      );
    } catch (e) {
      TripLog.e('SharedTextAnalyzer::analyzeFromUrl', e);
      return bookmark;
    }
  }

  String _getMetadataContent(Element head, String propName) {
    final metas = head.getElementsByTagName('meta');
    final lowerPropName = propName.toLowerCase();
    final ogpPropName = "og:$lowerPropName";

    for (var meta in metas) {
      final propertyValue = meta.attributes['property']?.toLowerCase();
      if (propertyValue == ogpPropName) {
        final content = meta.attributes['content'].nullToEmpty;
        if (content.isNotEmpty) {
          return content;
        }
      }

      final itempropValue = meta.attributes['itemprop']?.toLowerCase();
      if (itempropValue == lowerPropName) {
        final content = meta.attributes['content'].nullToEmpty;
        if (content.isNotEmpty) {
          return content;
        }
      }
    }

    return "";
  }

  String _getTitle(Element head) {
    final metaContent = _getMetadataContent(head, 'title');
    if (metaContent.isNotEmpty) {
      return metaContent;
    }

    final titleElements = head.getElementsByTagName('title');
    if (titleElements.isEmpty) {
      return '';
    }

    return titleElements.first.innerHtml;
  }

  String _getDescription(Element head) {
    return _getMetadataContent(head, 'description');
  }

  String _getImageUrl(Element head) {
    return _getMetadataContent(head, 'image');
  }
}
