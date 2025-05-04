import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/modules/search/models/search_filter.dart';
import 'package:next_gen/app/modules/search/models/search_history.dart';

/// Type IDs for Hive adapters
const int sortOptionTypeId = 5;
const int sortOrderTypeId = 6;

/// Register all Hive adapters for the search module
void registerSearchHiveAdapters() {
  // Register JobModel adapter
  if (!Hive.isAdapterRegistered(jobModelTypeId)) {
    Hive.registerAdapter(JobModelAdapter());
  }

  // Register SearchHistory adapter
  if (!Hive.isAdapterRegistered(searchHistoryTypeId)) {
    Hive.registerAdapter(SearchHistoryAdapter());
  }

  // Register SearchFilter adapter
  if (!Hive.isAdapterRegistered(searchFilterTypeId)) {
    Hive.registerAdapter(SearchFilterAdapter());
  }

  // Register SortOption adapter
  if (!Hive.isAdapterRegistered(sortOptionTypeId)) {
    Hive.registerAdapter(SortOptionAdapter());
  }

  // Register SortOrder adapter
  if (!Hive.isAdapterRegistered(sortOrderTypeId)) {
    Hive.registerAdapter(SortOrderAdapter());
  }
}
