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
  
  // Track modified specs directly
  final List<Specs> _modifiedSpecsList = [];
  
  // Track when _modifiedSpecIds is cleared
  void _clearModifiedSpecs() {
    log('\n⚠️ [CLEAR] Clearing _modifiedSpecsList. Current count: ${_modifiedSpecsList.length}');
    if (_modifiedSpecsList.isNotEmpty) {
      log('   - Clearing these specs: ${_modifiedSpecsList.map((s) => '${s.specId}:${s.specHeaderPl}').join(', ')}');
      // Log the stack trace to see where this is being called from
      log('   - Cleared from: ${StackTrace.current.toString().split('\n').take(3).join('\n        ')}');
    }
    _modifiedSpecsList.clear();
  }
  
 
  
  // Track all modifications to _modifiedSpecsList
  void _trackModifiedSpecsChange(String action, Specs? spec) {
    log('🔄 [_modifiedSpecsList] $action - Current count: ${_modifiedSpecsList.length}');
    if (spec != null) {
      log('   - Spec: ${spec.specId}:${spec.specHeaderPl} = "${spec.specValuePl}"');
    }
    log('   - Current modified specs: ${_modifiedSpecsList.isNotEmpty ? _modifiedSpecsList.map((s) => s.specId).join(', ') : 'none'}');
  }

  // Current post ID
  var currentPostId = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    log('🔄 [SPECS] SpecsController initialized, _modifiedSpecsList count: ${_modifiedSpecsList.length}');
  }
  
  /// Clear the list of modified specs (call this after successful upload)
  void clearModifiedSpecs() {
    _clearModifiedSpecs();
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

  /// Update spec value
  Future<bool> updateSpecValue({
    required String postId,
    required String specId,
    required String specValue,
    String selectedLanguage = 'en',
  }) async
  {
    try {
      log('Updating spec value - Post ID: $postId, Spec ID: $specId, Value: $specValue');

      final response = await repository.updateSpecValue(
        postId: postId,
        selectedLanguage: selectedLanguage,
        specId: specId,
        specValue: specValue,
      );

      if (response['Code'] == 'OK') {
        log('✅ Successfully updated spec value');

        // Update the spec in the local list
        final specIndex = specs.indexWhere((spec) => spec.specId == specId);
        if (specIndex != -1) {
          // Create updated spec
          final updatedSpec = Specs(
            postId: specs[specIndex].postId,
            specId: specs[specIndex].specId,
            specType: specs[specIndex].specType,
            specHeaderPl: specs[specIndex].specHeaderPl,
            specValuePl: specValue, // Update the value
            specHeaderSl: specs[specIndex].specHeaderSl,
            specValueSl: specs[specIndex].specValueSl,
            isHidden: specs[specIndex].isHidden,
          );

          // Update the list
          specs[specIndex] = updatedSpec;
          log('✅ Updated spec in local list: ${updatedSpec.specHeaderPl} = ${updatedSpec.specValuePl}');
        }
//jk
        return true;
      } else {
        log('❌ API Error updating spec: ${response['Desc']}');
        return false;
      }
    } catch (e) {
      log('❌ Error updating spec value: $e');
      return false;
    }
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

  List<Specs> specsStatic = <Specs>[
    // Specs(postId: "0", specId: "2", specType: "Number", specHeaderPl: "Seats Type", specValuePl: "", specHeaderSl: "المقاعد", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "3", specType: "Text", specHeaderPl: "Slide Roof", specValuePl: "", specHeaderSl: "فتحة السقف", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "4", specType: "Yes - No", specHeaderPl: "Park Sensors", specValuePl: "", specHeaderSl: "حساسات", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "5", specType: "Yes - No", specHeaderPl: "Camera", specValuePl: "", specHeaderSl: "كاميرا", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "6", specType: "Yes - No", specHeaderPl: "Bluetooth", specValuePl: "", specHeaderSl: "بلوتوث", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "7", specType: "Yes - No", specHeaderPl: "GPS", specValuePl: "", specHeaderSl: "نظام الخرائط", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "10", specType: "Text", specHeaderPl: "Engine Power", specValuePl: "", specHeaderSl: "قوة المحرك", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "11", specType: "Text", specHeaderPl: "Torque", specValuePl: "", specHeaderSl: "عزم الدوران", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "9", specType: "Color", specHeaderPl: "Interior color", specValuePl: "", specHeaderSl: "اللون الداخلي", specValueSl: "", isHidden: false),
    Specs(postId: "0", specId: "12", specType: "Text", specHeaderPl: "Fuel Type", specValuePl: "", specHeaderSl: "نوع الوقود", specValueSl: "", isHidden: false,options: ['Diesel','Petrol','Electric','Hybrid','LPG']),
    Specs(postId: "0", specId: "1", specType: "Number", specHeaderPl: "Cylinders", specValuePl: "", specHeaderSl: "الاسطوانات", specValueSl: "", isHidden: false,options: ['2','3','4','6','8','10','12','16']),
    Specs(postId: "0", specId: "13", specType: "Text", specHeaderPl: "Transmission", specValuePl: "", specHeaderSl: "ناقل الحركة", specValueSl: "", isHidden: false,options: ['Manual','Automatic']),
    // Specs(postId: "0", specId: "14", specType: "Text", specHeaderPl: "Drivetrain", specValuePl: "", specHeaderSl: "نظام القيادة", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "15", specType: "Text", specHeaderPl: "Upholstery Material", specValuePl: "", specHeaderSl: "مواد التنجيد", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "16", specType: "Number", specHeaderPl: "Infotainment Screen Size", specValuePl: "", specHeaderSl: "حجم شاشة الترفيه", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "17", specType: "Text", specHeaderPl: "Climate Control", specValuePl: "", specHeaderSl: "نظام التحكم بالمناخ", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "18", specType: "Yes - No", specHeaderPl: "Heated Seats", specValuePl: "", specHeaderSl: "المقاعد المدفأة", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "19", specType: "Yes - No", specHeaderPl: "Ventilated Seats", specValuePl: "", specHeaderSl: "المقاعد المهوّاة", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "20", specType: "Text", specHeaderPl: "Steering Wheel Features", specValuePl: "", specHeaderSl: "خصائص عجلة القيادة", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "21", specType: "Text", specHeaderPl: "Wheels", specValuePl: "", specHeaderSl: "العجلات", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "22", specType: "Text", specHeaderPl: "Headlights", specValuePl: "", specHeaderSl: "المصابيح الأمامية", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "23", specType: "Text", specHeaderPl: "Tail Lights", specValuePl: "", specHeaderSl: "المصابيح الخلفية", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "24", specType: "Yes - No", specHeaderPl: "Fog Lamps", specValuePl: "", specHeaderSl: "مصابيح الضباب", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "25", specType: "Text", specHeaderPl: "Body Type", specValuePl: "", specHeaderSl: "نوع الهيكل", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "26", specType: "Number", specHeaderPl: "Airbags", specValuePl: "", specHeaderSl: "الوسائد الهوائية", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "27", specType: "Yes - No", specHeaderPl: "ABS", specValuePl: "", specHeaderSl: "نظام المكابح المانعة للانغلاق", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "28", specType: "Yes - No", specHeaderPl: "Traction Control", specValuePl: "", specHeaderSl: "نظام التحكم بالجر", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "29", specType: "Yes - No", specHeaderPl: "Lane Assist", specValuePl: "", specHeaderSl: "مساعد المسار", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "30", specType: "Yes - No", specHeaderPl: "Adaptive Cruise Control", specValuePl: "", specHeaderSl: "التحكم الذكي بالسرعة", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "31", specType: "Yes - No", specHeaderPl: "Automatic Emergency Braking", specValuePl: "", specHeaderSl: "الفرامل التلقائية الطارئة", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "32", specType: "Number", specHeaderPl: "Top Speed", specValuePl: "", specHeaderSl: "السرعة القصوى", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "33", specType: "Number", specHeaderPl: "0-100 km/h Acceleration", specValuePl: "", specHeaderSl: "التسارع من 0-100 كم/س", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "34", specType: "Number", specHeaderPl: "Fuel Efficiency", specValuePl: "", specHeaderSl: "كفاءة استهلاك الوقود", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "35", specType: "Number", specHeaderPl: "Battery Range", specValuePl: "", specHeaderSl: "نطاق البطارية", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "36", specType: "Yes - No", specHeaderPl: "Wireless Charging", specValuePl: "", specHeaderSl: "الشحن اللاسلكي", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "37", specType: "Yes - No", specHeaderPl: "Apple CarPlay/Android Auto", specValuePl: "", specHeaderSl: "آبل كار بلاي/أندرويد أوتو", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "38", specType: "Number", specHeaderPl: "USB Ports", specValuePl: "", specHeaderSl: "منافذ USB", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "39", specType: "Yes - No", specHeaderPl: "Voice Commands", specValuePl: "", specHeaderSl: "أوامر صوتية", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "40", specType: "Text", specHeaderPl: "Exterior Colors", specValuePl: "", specHeaderSl: "ألوان الهيكل الخارجي", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "41", specType: "Text", specHeaderPl: "Interior Themes", specValuePl: "", specHeaderSl: "أشكال التصميم الداخلي", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "42", specType: "Text", specHeaderPl: "Warranty Period", specValuePl: "", specHeaderSl: "فترة الضمان", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "43", specType: "Text", specHeaderPl: "Service Intervals", specValuePl: "", specHeaderSl: "فترات الصيانة", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "44", specType: "Number", specHeaderPl: "Cargo Space", specValuePl: "", specHeaderSl: "مساحة التخزين", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "45", specType: "Number", specHeaderPl: "Towing Capacity", specValuePl: "", specHeaderSl: "قدرة السحب", specValueSl: "", isHidden: false),
    // Specs(postId: "0", specId: "46", specType: "Yes - No", specHeaderPl: "Roof Rails", specValuePl: "", specHeaderSl: "قضبان السقف", specValueSl: "", isHidden: false),
  ];
  
  /// Update spec value locally in specsStatic list
  void _logSpecsState(String message) {
    log('📊 [STATE] $message');
    for (final spec in specsStatic) {
      final isModified = _modifiedSpecsList.any((s) => s.specId == spec.specId);
      log('   - ${spec.specId.padLeft(2)}: ${spec.specHeaderPl.padRight(15)} = "${spec.specValuePl}" ${isModified ? '(MODIFIED)' : ''}');
    }
  }

  void updateLocal({
    required String specId,
    required String specValuePl,
    String? specValueSl,
  }) {
    try {
      // Log current state before any changes
      log('\n📌 [UPDATE STARTED] Spec ID: $specId, New Value: "$specValuePl"');
      _logSpecsState('BEFORE UPDATE');
      
      // Find the spec in specsStatic list
      final specIndex = specsStatic.indexWhere((spec) => spec.specId == specId);
      
      if (specIndex == -1) {
        log('❌ [ERROR] Spec ID $specId not found in specsStatic');
        return;
      }
      
      final oldSpec = specsStatic[specIndex];
      final oldValue = oldSpec.specValuePl;
      
      // Only proceed if the value has actually changed
      if (oldValue == specValuePl && (specValueSl == null || oldSpec.specValueSl == specValueSl)) {
        log('ℹ️ [LOCAL] No change in value for spec ID: $specId, skipping update');
        return;
      }
      
      log('🔄 [DROPDOWN] Changing spec ID: $specId from "$oldValue" to "$specValuePl"');
      
      // Create updated spec with new value
      final updatedSpec = Specs(
        postId: oldSpec.postId,
        specId: oldSpec.specId,
        specType: oldSpec.specType,
        specHeaderPl: oldSpec.specHeaderPl,
        specValuePl: specValuePl,
        specHeaderSl: oldSpec.specHeaderSl,
        specValueSl: specValueSl ?? oldSpec.specValueSl,
        isHidden: oldSpec.isHidden,
        options: oldSpec.options,
      );
      
      // Update the specsStatic list
      specsStatic[specIndex] = updatedSpec;
      
      // Check if we already have this spec in the modified list
      final existingIndex = _modifiedSpecsList.indexWhere((s) => s.specId == specId);
      
      if (existingIndex != -1) {
        // Update existing modified spec
        _modifiedSpecsList[existingIndex] = updatedSpec;
        log('🔄 [MODIFIED] Updated existing modified spec: ${updatedSpec.specHeaderPl} = "$specValuePl"');
      } else {
        // Add new modified spec
        _modifiedSpecsList.add(updatedSpec);
        log('➕ [MODIFIED] Added new modified spec: ${updatedSpec.specHeaderPl} = "$specValuePl"');
      }
      
      // Log all modified specs with their values
      log('📋 [MODIFIED SPECS] Current state (${_modifiedSpecsList.length} specs):');
      for (final spec in _modifiedSpecsList) {
        log('   - ${spec.specId}: ${spec.specHeaderPl} = "${spec.specValuePl}"');
      }
      
      // Log the current state of all specs
      _logAllSpecs();
      
      // Trigger UI update for GetBuilder
      update();
      
      log('✅ [LOCAL] Successfully updated spec in specsStatic and _modifiedSpecsList:');
      log('  Header: ${updatedSpec.specHeaderPl}');
      log('  New Value: ${updatedSpec.specValuePl}');
      log('  Spec ID: ${updatedSpec.specId}');
    } catch (e) {
      log('❌ [LOCAL] Error updating spec value locally: $e');
    }
  }

  /// Clear spec value locally in specsStatic list
  void clearLocal({
    required String specId,
  }) {
    try {
      log('🔧 [LOCAL] Clearing spec value - Spec ID: $specId');
      
      // Find the spec in specsStatic list
      final specIndex = specsStatic.indexWhere((spec) => spec.specId == specId);

      if (specIndex != -1) {
        // Create updated spec with cleared value
        final updatedSpec = Specs(
          postId: specsStatic[specIndex].postId,
          specId: specsStatic[specIndex].specId,
          specType: specsStatic[specIndex].specType,
          specHeaderPl: specsStatic[specIndex].specHeaderPl,
          specValuePl: "", // Clear the Polish value
          specHeaderSl: specsStatic[specIndex].specHeaderSl,
          specValueSl: "", // Clear the Slovenian value
          isHidden: specsStatic[specIndex].isHidden,
          options: specsStatic[specIndex].options,
        );

        // Update the specsStatic list
        specsStatic[specIndex] = updatedSpec;
        
        // Track before updating in modified list
        _trackModifiedSpecsChange('CLEARING', updatedSpec);
        
        // Remove if exists (to avoid duplicates)
        _modifiedSpecsList.removeWhere((s) => s.specId == specId);
        
        // Add the updated spec to modified list
        _modifiedSpecsList.add(updatedSpec);
        
        // Track after updating
        _trackModifiedSpecsChange('CLEARED', updatedSpec);
        
        // Trigger UI update for GetBuilder
        update();

        log('✅ [LOCAL] Successfully cleared spec value in specsStatic and _modifiedSpecsList:');
        log('  Header: ${updatedSpec.specHeaderPl}');
        log('  Spec ID: ${updatedSpec.specId}');
        
        // Log all modified specs with their values
        log('📋 [MODIFIED SPECS] Current state after clear:');
        for (final spec in _modifiedSpecsList) {
          log('   - ${spec.specId}: ${spec.specHeaderPl} = "${spec.specValuePl}"');
        }
      } else {
        log('❌ [LOCAL] Spec not found in specsStatic with ID: $specId');
      }
    } catch (e) {
      log('❌ [LOCAL] Error clearing spec value locally: $e');
    }
  }

  /// Get only the specs that have been modified (non-empty values)
  /// Log the current state of all specs for debugging
  void _logAllSpecs() {
    log('📋 [DEBUG] === Current State of All Specs ===');
    log('📋 [DEBUG] Total specs: ${specsStatic.length}');
    log('📋 [DEBUG] Modified specs count: ${_modifiedSpecsList.length}');
    
    for (final spec in specsStatic) {
      final isModified = _modifiedSpecsList.any((s) => s.specId == spec.specId);
      log('  - ${spec.specId.padLeft(2)} | ${spec.specHeaderPl.padRight(20)} | Value: "${spec.specValuePl}" | Modified: ${isModified ? '✅' : '❌'}');
    }
    log('📋 [DEBUG] =================================');
  }

  List<Specs> getModifiedSpecs() {
    try {
      log('🔍 [FILTER] === Starting getModifiedSpecs() ===');
      _logAllSpecs();
      
      log('🔍 [FILTER] Found ${_modifiedSpecsList.length} modified specs');
      
      // Filter out any specs with empty values
      final modifiedWithValues = _modifiedSpecsList.where((s) => s.specValuePl.trim().isNotEmpty).toList();
      
      log('🔍 [FILTER] Found ${modifiedWithValues.length} modified specs with non-empty values:');
      for (final spec in modifiedWithValues) {
        log('  - ${spec.specId.padLeft(2)} | ${spec.specHeaderPl.padRight(20)} | Value: "${spec.specValuePl}"');
      }
      
      if (modifiedWithValues.isEmpty) {
        log('⚠️ [FILTER] No modified specs found with values. Possible issues:');
        log('  - Specs might be modified but not marked in _modifiedSpecsList');
        log('  - Specs might be marked as modified but have empty values');
        log('  - _modifiedSpecsList might have been cleared unexpectedly');
      }
      
      return modifiedWithValues;
    } catch (e) {
      log('❌ [FILTER] Error getting modified specs: $e');
      return [];
    }
  }
}