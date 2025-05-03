import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/modules/search/models/search_filter.dart';
import 'package:next_gen/app/modules/search/models/search_history.dart';

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
  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(SortOptionAdapter());
  }

  // Register SortOrder adapter
  if (!Hive.isAdapterRegistered(6)) {
    Hive.registerAdapter(SortOrderAdapter());
  }
}
