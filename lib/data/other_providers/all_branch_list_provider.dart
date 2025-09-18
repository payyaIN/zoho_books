import 'package:payzo_books/data/models/branch_model/all_branch_model.dart';
import 'package:payzo_books/import_data.dart';

class BranchListNotifier extends StateNotifier<GetAllBranchListModel?> {
  BranchListNotifier() : super(null);

  void setBranchListData(GetAllBranchListModel branchModel) {
    state = branchModel;
  }

  void clearBranchListData() {
    state = null;
  }
}

final branchListProvider =
    StateNotifierProvider<BranchListNotifier, GetAllBranchListModel?>((ref) {
  return BranchListNotifier();
});

final selectedBranchProvider = StateProvider<Branch?>((ref) => null);

void setSelectedBranch(WidgetRef ref, Branch branch) {
  ref.read(selectedBranchProvider.notifier).state = branch;
}

Branch? getSelectedBranch(WidgetRef ref) {
  return ref.read(selectedBranchProvider);
}

final branchByIdProvider = Provider.family<Branch?, int>((ref, branchId) {
  final branchModel = ref.watch(branchListProvider);
  if (branchModel == null) return null;

  try {
    return branchModel.data.firstWhere((branch) => branch.branchId == branchId);
  } catch (e) {
    print('Branch with ID $branchId not found');
    return null;
  }
});

final searchBranchesProvider =
    Provider.family<List<Branch>, String>((ref, searchQuery) {
  final branchModel = ref.watch(branchListProvider);
  if (branchModel == null) return [];
  if (searchQuery.isEmpty) return branchModel.data;

  final query = searchQuery.toLowerCase();
  return branchModel.data.where((branch) {
    return branch.namePrimary.toLowerCase().contains(query) ||
        branch.nameSecondary.toLowerCase().contains(query);
  }).toList();
});

final activeBranchesProvider = Provider<List<Branch>>((ref) {
  final branchModel = ref.watch(branchListProvider);
  if (branchModel == null) return [];

  return branchModel.data
      .where((branch) => branch.primaryContact.isActive)
      .toList();
});
