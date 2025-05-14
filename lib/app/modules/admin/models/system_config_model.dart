import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for system configuration
class SystemConfigModel {
  /// Creates a new system configuration model
  SystemConfigModel({
    required this.id,
    required this.name,
    required this.value,
    required this.category,
    this.description,
    this.dataType = 'string',
    this.lastUpdated,
    this.updatedBy,
  });

  /// Factory constructor from Firestore document
  factory SystemConfigModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return SystemConfigModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      value: data['value'],
      category: data['category'] as String? ?? 'general',
      description: data['description'] as String?,
      dataType: data['dataType'] as String? ?? 'string',
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate(),
      updatedBy: data['updatedBy'] as String?,
    );
  }

  /// Unique identifier
  final String id;

  /// Configuration name
  final String name;

  /// Configuration value
  final dynamic value;

  /// Category (e.g., "general", "security", "notifications")
  final String category;

  /// Description of the configuration
  final String? description;

  /// Data type (e.g., "string", "boolean", "number", "json")
  final String dataType;

  /// When the configuration was last updated
  final DateTime? lastUpdated;

  /// Who last updated the configuration
  final String? updatedBy;

  /// Convert to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value,
      'category': category,
      'description': description,
      'dataType': dataType,
      'lastUpdated':
          lastUpdated != null ? Timestamp.fromDate(lastUpdated!) : null,
      'updatedBy': updatedBy,
    };
  }

  /// Create a copy with updated values
  SystemConfigModel copyWith({
    String? name,
    dynamic value,
    String? category,
    String? description,
    String? dataType,
    DateTime? lastUpdated,
    String? updatedBy,
  }) {
    return SystemConfigModel(
      id: id,
      name: name ?? this.name,
      value: value ?? this.value,
      category: category ?? this.category,
      description: description ?? this.description,
      dataType: dataType ?? this.dataType,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  /// Get a formatted value based on the data type
  dynamic getTypedValue() {
    switch (dataType) {
      case 'boolean':
        return value is bool ? value : value.toString().toLowerCase() == 'true';
      case 'number':
        return value is num ? value : num.tryParse(value.toString()) ?? 0;
      case 'json':
        if (value is Map) {
          return value;
        }
        try {
          return value;
        } catch (_) {
          return {};
        }
      default:
        return value.toString();
    }
  }
}
