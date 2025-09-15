import 'dart:developer';

import 'package:get/get.dart';
import 'package:qarsspin/controller/specs/specs_data_layer.dart';
import 'package:qarsspin/model/specs.dart';

class SpecsController extends GetxController {
  final SpecsDataLayer repository;

  SpecsController(this.repository);

  // Specs state
  var specs = <Specs>[].obs;
  var isLoadingSpecs = false.obs;
  var specsError = Rxn<String>();
  var specsResponse = Rxn<Map<String, dynamic>>();

  // Current post ID
  var currentPostId = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
  }

  /// Fetch specs for a specific post
  Future<void> fetchSpecsForPost({
    required String postId,
    String showHidden = 'Yes',
  }) async {
    isLoadingSpecs.value = true;
    specsError.value = null;
    specsResponse.value = null;
    currentPostId.value = postId;

    try {
      log('Fetching specs for post ID: $postId');
      final response = await repository.getSpecsOfPostForEditing(
        postId: postId,
        showHidden: showHidden,
      );

      if (response['Code'] == 'OK') {
        specsResponse.value = response;
        
        // Parse specs from response - use 'Data' field and handle null case
        final specsList = response['Data'] as List? ?? <dynamic>[];
        final parsedSpecs = specsList.map((specJson) => Specs.fromJson(specJson)).toList();
        
        specs.assignAll(parsedSpecs);
        
        log('✅ Successfully fetched ${specs.length} specs');
        log('Specs data: ${specs.map((s) => '${s.specHeaderPl}: ${s.specValuePl}').toList()}');
      } else {
        specsError.value = response['Desc'] ?? 'Failed to fetch specs';
        log('❌ API Error: ${response['Desc']}');
      }
    } catch (e) {
      specsError.value = 'Network error: ${e.toString()}';
      log('❌ Error fetching specs: $e');
    } finally {
      isLoadingSpecs.value = false;
    }
  }

  /// Get visible specs only (not hidden)
  List<Specs> get visibleSpecs => specs.where((spec) => !spec.isHidden).toList();

  /// Get hidden specs only
  List<Specs> get hiddenSpecs => specs.where((spec) => spec.isHidden).toList();

  /// Get specs count
  int get specsCount => specs.length;

  /// Get visible specs count
  int get visibleSpecsCount => visibleSpecs.length;

  /// Get hidden specs count
  int get hiddenSpecsCount => hiddenSpecs.length;

  /// Refresh specs for current post
  Future<void> refreshSpecs() async {
    if (currentPostId.value != null) {
      await fetchSpecsForPost(postId: currentPostId.value!);
    }
  }

  /// Clear specs data
  void clearSpecs() {
    specs.clear();
    specsError.value = null;
    specsResponse.value = null;
    currentPostId.value = null;
  }

  /// Log specs data for debugging
  void logSpecsData() {
    log('=== Specs Data ===');
    log('Post ID: ${currentPostId.value}');
    log('Total Specs: ${specs.length}');
    log('Visible Specs: ${visibleSpecs.length}');
    log('Hidden Specs: ${hiddenSpecs.length}');
    
    for (int i = 0; i < specs.length; i++) {
      final spec = specs[i];
      log('Spec ${i + 1}:');
      log('  Header (PL): ${spec.specHeaderPl}');
      log('  Value (PL): ${spec.specValuePl}');
      log('  Header (SL): ${spec.specHeaderSl}');
      log('  Value (SL): ${spec.specValueSl}');
      log('  Type: ${spec.specType}');
      log('  Hidden: ${spec.isHidden}');
      log('  ---');
    }
    log('==================');
  }
}